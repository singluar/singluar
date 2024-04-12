---@private
local function _leapEnding(isOK, options, point)
    options.buff:rollback()
    options.buff = nil
    local qty = options.reflex or 0
    local res = isOK
    if (res == true) then
        local resReflex = true
        if (qty > 0 and isObject(options.targetUnit, "Unit")) then
            if (type(options.onReflex) == "function") then
                local r = options.onReflex(options, point)
                if (type(r) == "boolean" and r == false) then
                    resReflex = false
                end
            end
            if (resReflex == true) then
                local nextUnit = group.rand({
                    key = "Unit",
                    x = point[1],
                    y = point[2],
                    radius = 600,
                    filter = function(enumUnit)
                        return enumUnit.isOther(options.targetUnit) and enumUnit.isAlive() and enumUnit.isEnemy(options.sourceUnit.owner())
                    end,
                })
                if (isObject(nextUnit, "Unit")) then
                    ability.leap({
                        sourceUnit = options.sourceUnit,
                        targetUnit = nextUnit,
                        modelAlias = options.modelAlias,
                        speed = options.speed,
                        acceleration = options.acceleration,
                        height = options.height,
                        shake = options.shake,
                        shakeOffset = options.shakeOffset,
                        reflex = options.reflex - 1,
                        onMove = options.onMove,
                        onReflex = options.onReflex,
                        onEnd = options.onEnd,
                    })
                end
            end
            return
        end
        if (type(options.onEnd) == "function") then
            res = options.onEnd(options, point)
        end
    end
end


--[[
    冲锋
    sourceUnit, --[必须]冲锋单位，同时也是伤害来源
    targetUnit, --[可选]目标单位（有单位目标，那么冲击跟踪到单位就结束）
    targetPoint = number[3][可选]强制设定目标坐标
    modelAlias = nil, --[可选]冲锋单位origin特效
    animate = "attack", --冲锋动作
    animateScale = 1.00, --冲锋的动画速度
    speed = 500, --每秒冲击的距离（可选的，默认1秒500px)
    acceleration = 0, --冲击加速度（可选的，每个周期[0.02秒]都会增加一次)
    height = 0, --飞跃高度（可选的，默认0)
    shake = 0, --摇摆振幅程度度[0.00~1.00|rand]（可选的，默认0)
    reflex = 0, --弹射次数（可选的，默认0)
    onMove = [function], --[可选]每周期移动回调（return false时可强行中止循环）
    onReflex = [function], --[可选]每弹跳回调（return false时可强行中止后续弹跳）
    onEnd = [function], --[可选]结束回调（弹跳完毕才算结束）
]]
---@alias noteAbLeapOptions {sourceUnit:Unit,targetUnit:Unit,targetPoint:number[],animate:string,animateScale:number,speed:number,acceleration:number,height:number,shake:number,shakeOffset:number,reflex:number,modelAlias:string,onMove:noteAbLeapOnEvt,onEnd:noteAbLeapOnEvt}
---@alias noteAbLeapOnEvt fun(options:noteAbLeapOptions,point:number[]):nil|boolean
---@param options noteAbLeapOptions
function ability.leap(options)
    local sourceUnit = options.sourceUnit
    must(isObject(sourceUnit, "Unit"))
    if (options.targetPoint == nil) then
        must(isObject(options.targetUnit, "Unit"))
    end
    if (sourceUnit.isLeaping()) then
        return
    end

    options.acceleration = options.acceleration or 0
    local frequency = 0.02
    local speed = math.min(5000, math.max(100, options.speed or 500))

    ---@type number[]
    local sPoint = { sourceUnit.x(), sourceUnit.y(), sourceUnit.h() }
    ---@type number[]
    local tPoint
    if (type(options.targetPoint) == "table") then
        tPoint = { options.targetPoint[1], options.targetPoint[2], options.targetPoint[3] or japi.Z(options.targetPoint[1], options.targetPoint[2]) }
    else
        tPoint = { options.targetUnit.x(), options.targetUnit.y(), options.targetUnit.h() }
    end

    local distance0 = math.distance(sPoint[1], sPoint[2], tPoint[1], tPoint[2])
    local dtStep = distance0 / speed / frequency
    local dtSpd = 1 / dtStep

    local height = sPoint[3] + (tPoint[3] - sPoint[3]) * 0.5 + (options.height or 0)

    local shake = options.shake
    local shakeOffset = options.shakeOffset or distance0 / 2
    if (shake == "rand") then
        shake = math.rand(0, 359)
    elseif (type(shake) == "number") then
        shake = math.ceil(shake) % 360
    else
        shake = 0
    end

    local facing = math.angle(sPoint[1], sPoint[2], tPoint[1], tPoint[2])
    local mx, my = math.polar(sPoint[1], sPoint[2], shakeOffset, facing + shake)
    local mPoint = { mx, my, height }

    if (options.animate) then
        sourceUnit.animate(options.animate)
    end

    local flyHeight0 = sourceUnit.flyHeight()
    local animateDiff = (options.animateScale or 1) - sourceUnit.animateScale()

    options.buff = Buff(sourceUnit, "leap", -1, 0,
        function(buffObj)
            options.effectAttach = buffObj.attach(options.modelAlias, "origin", -1)
            if (animateDiff ~= 0) then
                buffObj.animateScale("+=" .. animateDiff)
            end
            buffObj.superposition("leap", "+=1")
            buffObj.superposition("collision", "-=1")
            buffObj.superposition("pause", "+=1")
        end,
        function(buffObj)
            effect.destroy(options.effectAttach)
            options.effectAttach = nil
            if (animateDiff ~= 0) then
                buffObj.animateScale("-=" .. animateDiff)
            end
            buffObj.flyHeight(flyHeight0)
            buffObj.superposition("pause", "-=1")
            buffObj.superposition("collision", "+=1")
            buffObj.superposition("leap", "-=1")
        end
    )
    options.buff.purpose()

    local dt = 0
    local distanceCur = distance0
    local distancePrev
    local collision = sourceUnit.collision() * 2
    local faraway = frequency * speed * 30
    local cPoint
    time.setInterval(frequency, function(curTimer)
        if (sourceUnit.isDead()) then
            curTimer.destroy()
            _leapEnding(false, options, cPoint or sPoint)
            return
        end
        local di = 1
        if (options.targetVec == nil) then
            if (options.targetUnit ~= nil and options.targetUnit.isAlive()) then
                tPoint = { options.targetUnit.x(), options.targetUnit.y(), options.targetUnit.h() }
                di = distance0 / distanceCur
            end
        end
        di = math.min(1, di)
        dt = dt + dtSpd * di
        if (options.acceleration > 0) then
            dtSpd = dtSpd + 1 / (distance0 / options.acceleration / frequency)
        end

        local nPoint = {
            sPoint[1] + 2 * (mPoint[1] - sPoint[1]) * dt + (tPoint[1] - 2 * mPoint[1] + sPoint[1]) * dt ^ 2,
            sPoint[2] + 2 * (mPoint[2] - sPoint[2]) * dt + (tPoint[2] - 2 * mPoint[2] + sPoint[2]) * dt ^ 2,
            sPoint[3] + 2 * (mPoint[3] - sPoint[3]) * dt + (tPoint[3] - 2 * mPoint[3] + sPoint[3]) * dt ^ 2,
        }
        if (RectPlayable.isBorder(nPoint[1], nPoint[2])) then
            curTimer.destroy()
            _leapEnding(false, options, cPoint)
            return
        end
        cPoint = nPoint
        distanceCur = math.distance(cPoint[1], cPoint[2], tPoint[1], tPoint[2])
        if (distanceCur > collision and distancePrev ~= nil) then
            if ((distanceCur - distancePrev) > faraway) then
                curTimer.destroy()
                _leapEnding(false, options, cPoint)
                return
            end
        end
        if (distanceCur <= collision) then
            cPoint = { tPoint[1], tPoint[2], tPoint[3] }
        end
        if (type(options.onMove) == "function") then
            local mRes = options.onMove(options, cPoint)
            if (mRes == false) then
                curTimer.destroy()
                _leapEnding(false, options, cPoint)
                return
            end
        end
        sourceUnit.facing(math.angle(cPoint[1], cPoint[2], tPoint[1], tPoint[2]))
        sourceUnit.position(cPoint[1], cPoint[2])
        sourceUnit.flyHeight(cPoint[3])
        distancePrev = distanceCur
        if (dt >= 1 or distanceCur <= collision) then
            curTimer.destroy()
            _leapEnding(true, options, tPoint)
        end
    end)
end