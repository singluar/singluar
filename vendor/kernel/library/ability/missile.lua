---@private
local function _missileEnding(isok, options, point)
    if (options.arrowToken ~= nil) then
        J.DestroyEffect(options.arrowToken)
        J.handleUnRef(options.arrowToken)
        options.arrowToken = nil
    end
    local res = isok
    if (res == true and type(options.onEnd) == "function") then
        res = options.onEnd(options, point)
    end
    if (res == true and (options.reflex or 0) > 0) then
        if (isObject(options.targetUnit, "Unit") and false == options.targetUnit.isDestroy()) then
            local nextUnit = group.rand({
                key = "Unit",
                x = point[1],
                y = point[2],
                radius = 600,
                ---@param enumUnit Unit
                filter = function(enumUnit)
                    return enumUnit.isOther(options.targetUnit) and enumUnit.isAlive() and enumUnit.isEnemy(options.sourceUnit.owner())
                end
            })
            if (isObject(nextUnit, "Unit")) then
                ability.missile({
                    modelAlias = options.modelAlias,
                    scale = options.scale,
                    sourceUnit = options.sourceUnit,
                    speed = options.speed,
                    height = options.height,
                    acceleration = options.acceleration,
                    shake = options.shake,
                    shakeOffset = options.shakeOffset,
                    reflex = options.reflex - 1,
                    onMove = options.onMove,
                    onEnd = options.onEnd,
                    sourcePoint = point,
                    targetUnit = nextUnit,
                })
            end
        end
    end
end

--[[
    虚拟箭矢
    modelAlias = nil, --[必须]虚拟箭矢的特效
    sourceUnit, --[必须]伤害来源
    targetUnit, --[可选]目标单位（有单位目标，那么冲击跟踪到单位就结束）
    sourcePoint = number[3][可选]强制设定初始坐标
    targetPoint = number[3][可选]强制设定目标坐标
    animateScale = 1.00, --[可选]虚拟箭矢的动画速度，默认1
    scale = 1.00, --[可选]虚拟箭矢的模型缩放，默认1
    acceleration = 0, --[可选]冲击加速度，每个周期[0.02秒]都会增加一次
    reflex = 0, --[可选]弹射次数，默认0
    speed = 500, --[可选]每秒冲击的距离，默认1秒500px
    height = 0, --[可选]飞跃高度，默认0
    shake = 0, --[可选]摇摆角度[number|'rand']默认0
    shakeOffset = 50%, --[可选]摇摆偏移，默认为距离的50%
    onMove = noteAbilityMissileOnEvt, --[可选]每移动回调,当return false时可强行中止循环
    onEnd = noteAbilityMissileOnEvt, --[可选]结束回调
]]
---@alias noteAbilityMissileOptions {modelAlias:string,animateScale:number,scale:number,speed:number,acceleration:number,height:number,shake:number,shakeOffset:number,reflex:number,sourceUnit:Unit,targetUnit:Unit,sourcePoint:number[],targetPoint:number[],onMove:noteAbilityMissileOnEvt,onEnd:noteAbilityMissileOnEvt}
---@alias noteAbilityMissileOnEvt fun(options:noteAbilityMissileOptions,point:number[]):nil|boolean
---@param options noteAbilityMissileOptions
function ability.missile(options)
    options.modelAlias = AModel(options.modelAlias)
    must(type(options.modelAlias) == "string")
    must(isObject(options.sourceUnit, "Unit"))
    if (options.targetPoint == nil) then
        must(isObject(options.targetUnit, "Unit"))
    end

    options.acceleration = options.acceleration or 0
    options.animateScale = options.animateScale or 1
    options.scale = options.scale or 1
    local frequency = 0.02
    local speed = math.min(5000, math.max(100, options.speed or 500))
    local collision = 0
    local weaponHeight = 0
    if (isObject(options.sourceUnit, "Unit")) then
        weaponHeight = options.sourceUnit.weaponHeight()
    else
        weaponHeight = 20
    end

    ---@type number[]
    local sPoint = options.sourcePoint
    ---@type number[]
    local tPoint
    if (type(options.targetPoint) == "table") then
        tPoint = { options.targetPoint[1], options.targetPoint[2], options.targetPoint[3] }
    else
        tPoint = { options.targetUnit.x(), options.targetUnit.y(), options.targetUnit.stature() + options.targetUnit.h() }
        collision = options.targetUnit.collision() * 2
    end
    local fac0 = math.angle(options.sourceUnit.x(), options.sourceUnit.y(), tPoint[1], tPoint[2])
    if (sPoint == nil) then
        local sx, sy = math.polar(options.sourceUnit.x(), options.sourceUnit.y(), options.sourceUnit.weaponLength(), fac0)
        sPoint = { sx, sy, weaponHeight + options.sourceUnit.h() }
    end

    local distance0 = math.distance(sPoint[1], sPoint[2], tPoint[1], tPoint[2])
    local dtStep = distance0 / speed / frequency
    local dtSpd = 1 / dtStep

    local height = (options.height or 0)
    if (sPoint[3] >= tPoint[3]) then
        height = height + sPoint[3]
    else
        height = height + tPoint[3]
    end
    local rotateY0 = -math._r2d * math.atan(height, distance0 / 2)
    if (fac0 > 90 and fac0 < 270) then
        rotateY0 = -rotateY0
    end
    local dtRot = 2.2 * rotateY0 / dtStep

    local hh = height * 0.6
    if (distance0 < hh) then
        height = height * (distance0 / hh)
    end
    height = height + math.rand(-15, 15)

    local shake = options.shake
    local shakeOffset = options.shakeOffset or distance0 / 2
    if (shake == "rand") then
        shake = math.rand(0, 359)
    elseif (type(shake) == "number") then
        shake = math.ceil(shake) % 360
    else
        shake = 0
    end

    local mx, my = math.polar(sPoint[1], sPoint[2], shakeOffset, fac0 + shake)
    local mPoint = { mx, my, 1.5 * height }

    local oriX, oriY = sPoint[1], sPoint[2]
    options.arrowToken = J.AddSpecialEffect(options.modelAlias, sPoint[1], sPoint[2])
    J.handleRef(options.arrowToken)
    japi.EXSetEffectZ(options.arrowToken, sPoint[3])
    japi.EXSetEffectSpeed(options.arrowToken, options.animateScale)
    japi.EXSetEffectSize(options.arrowToken, options.scale)
    japi.EXEffectMatRotateZ(options.arrowToken, fac0)
    japi.EXEffectMatRotateY(options.arrowToken, rotateY0)

    local dt = 0
    local distanceCur = distance0
    local distancePrev
    local faraway = frequency * speed * 30
    local cPoint = { sPoint[1], sPoint[2], sPoint[3] }
    local fac = fac0
    local rotateY = rotateY0
    time.setInterval(frequency, function(curTimer)
        if (options.arrowToken == nil or options.sourceUnit.isDestroy() or (isObject(options.targetUnit, "Unit") and options.targetUnit.isDestroy())) then
            curTimer.destroy()
            _missileEnding(false, options, cPoint)
            return
        end
        local di = 1
        if (type(options.targetPoint) ~= "table") then
            if (options.targetUnit ~= nil and options.targetUnit.isAlive()) then
                tPoint = { options.targetUnit.x(), options.targetUnit.y(), options.targetUnit.stature() + options.targetUnit.h() }
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
            _missileEnding(false, options, cPoint)
            return
        end
        cPoint = nPoint
        distanceCur = math.distance(cPoint[1], cPoint[2], tPoint[1], tPoint[2])
        if (distanceCur > collision and distancePrev ~= nil) then
            if ((distanceCur - distancePrev) > faraway) then
                curTimer.destroy()
                _missileEnding(false, options, cPoint)
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
                _missileEnding(false, options, cPoint)
                return
            end
        end
        fac = math.angle(cPoint[1], cPoint[2], tPoint[1], tPoint[2])
        rotateY = rotateY - dtRot * di
        if (math.distance(oriX, oriY, cPoint[1], cPoint[2]) > 2000) then
            japi.EXSetEffectZ(options.arrowToken, -9999)
            japi.EXSetEffectSize(options.arrowToken, 0.01)
            J.DestroyEffect(options.arrowToken)
            J.handleUnRef(options.arrowToken)
            options.arrowToken = J.AddSpecialEffect(options.modelAlias, cPoint[1], cPoint[2])
            J.handleRef(options.arrowToken)
            japi.EXEffectMatRotateZ(options.arrowToken, fac)
            japi.EXEffectMatRotateY(options.arrowToken, rotateY)
            oriX, oriY = cPoint[1], cPoint[2]
        else
            japi.EXSetEffectXY(options.arrowToken, cPoint[1], cPoint[2])
            japi.EXEffectMatRotateZ(options.arrowToken, fac - fac0)
            japi.EXEffectMatRotateY(options.arrowToken, -dtRot * di)
        end
        japi.EXSetEffectZ(options.arrowToken, cPoint[3])
        fac0 = fac
        distancePrev = distanceCur
        if (dt >= 1 or distanceCur <= collision) then
            curTimer.destroy()
            _missileEnding(true, options, tPoint)
        end
    end)
end