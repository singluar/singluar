---@private
local function _crackFlyEnding(isOK, options, point)
    local res = isOK
    options.buff.rollback()
    options.buff = nil
    local qty = 0
    if (type(options.bounce) == "table") then
        qty = options.bounce.qty or 0
    end
    if (res == true) then
        local resBounce = true
        if (qty > 0) then
            if (type(options.onBounce) == "function") then
                local r = options.onBounce(options, point)
                if (type(r) == "boolean" and r == false) then
                    resBounce = false
                end
            end
            if (resBounce == true) then
                local di = options.bounce.distance or 0.8
                local he = options.bounce.height or 0.8
                local du = options.bounce.duration or 0.8
                if (isObject(options.targetUnit, "Unit") and false == options.targetUnit.isDestroy()) then
                    ability.crackFly({
                        sourceUnit = options.sourceUnit,
                        targetUnit = options.targetUnit,
                        modelAlias = options.modelAlias,
                        animate = options.animate,
                        animateScale = options.animateScale,
                        distance = options.distance * di,
                        height = options.height * he,
                        duration = options.duration * du,
                        bounce = { qty = qty - 1, distance = di, height = he, duration = du },
                        onMove = options.onMove,
                        onBounce = options.onBounce,
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
    击飞
    sourceUnit = Unit, --[可选]伤害来源
    targetUnit = Unit, --[必须]目标单位
    modelAlias = nil, --[可选]目标单位飞行origin特效
    animate = "dead", --[可选]目标单位飞行动作或序号,默认无
    animateScale = 1.00, --[可选]目标单位飞行动画速度，默认1
    distance = 0, --[可选]击退距离，默认0
    height = 100, --[可选]飞跃高度，默认100
    duration = 0.5, --[必须]击飞过程持续时间，可选，默认0.5秒
    bounce = noteAbilityCrackFlyBounceParam, --[可选]弹跳参数，noteAbilityCrackFlyBounceParam
    onMove = noteAbilityCrackFlyOnEvt, --[可选]每周期回调（return false时可强行中止循环）
    onBounce = noteAbilityCrackFlyOnEvt, --[可选]每弹跳回调（return false时可强行中止后续弹跳）
    onEnd = noteAbilityCrackFlyOnEvt, --[可选]结束回调（弹跳完毕才算结束）
]]
---@alias noteAbilityCrackFlyBounceParam {qty:0, distance:0.8, height:0.8, duration:0.8} qty弹跳次数，后面三个为相对前1次的相乘变化率，默认0.8
---@alias noteAbilityCrackFlyParam {sourceUnit:Unit,targetUnit:Unit,modelAlias:string,animate:number,animateScale:number,distance:number,height:number,bounce:noteAbilityCrackFlyBounceParam,duration:number,onMove:noteAbilityCrackFlyOnEvt,onEnd:noteAbilityCrackFlyOnEvt,onBounce:noteAbilityCrackFlyOnEvt}
---@alias noteAbilityCrackFlyOnEvt fun(options:noteAbilityCrackFlyParam,point:number[]):boolean
---@param options noteAbilityCrackFlyParam
function ability.crackFly(options)
    local sourceUnit = options.sourceUnit
    local targetUnit = options.targetUnit
    if (isObject(targetUnit, "Unit") == false or targetUnit.isDead()) then
        return
    end
    options.distance = math.max(0, options.distance or 0)
    options.height = options.height or 100
    options.duration = options.duration or 0.5
    if (options.height <= 0 or options.duration < 0.1) then
        return
    end
    if (targetUnit.isCrackFlying()) then
        return
    end
    if (sourceUnit ~= nil) then
        event.trigger(sourceUnit, EVENT.Unit.CrackFly, { triggerUnit = sourceUnit, targetUnit = targetUnit, distance = options.distance, height = options.height, duration = options.duration })
    end
    event.trigger(targetUnit, EVENT.Unit.Be.CrackFly, { triggerUnit = targetUnit, sourceUnit = sourceUnit, distance = options.distance, height = options.height, duration = options.duration })

    local frequency = 0.02
    if (options.animate) then
        targetUnit.animate(options.animate)
    end

    local flyHeight0 = targetUnit.flyHeight()
    local animateDiff = (options.animateScale or 1) - targetUnit.animateScale()

    options.buff = Buff(targetUnit, "crackFly", -1, 0,
        function(buffObj)
            options.effectAttach = buffObj.attach(options.modelAlias, "origin", -1)
            if (animateDiff ~= 0) then
                buffObj.animateScale("+=" .. animateDiff)
            end
            buffObj.superposition("crackFly", "+=1")
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
            buffObj.superposition("crackFly", "-=1")
        end
    )

    local fac0 = 0
    if (isObject(sourceUnit, "Unit")) then
        fac0 = math.angle(sourceUnit.x(), sourceUnit.y(), targetUnit.x(), targetUnit.y())
    else
        fac0 = targetUnit.facing() - 180
    end
    local sPoint = { targetUnit.x(), targetUnit.y(), targetUnit.h() }
    local tx, ty = math.polar(targetUnit.x(), targetUnit.y(), options.distance, fac0)
    local tPoint = { tx, ty, targetUnit.h() }

    local dtSpd = 1 / (options.duration / frequency)

    local mid = math.distance(sPoint[1], sPoint[2], tPoint[1], tPoint[2])
    local mx, my = math.polar(sPoint[1], sPoint[2], mid, fac0)
    local mPoint = { mx, my, 1.5 * options.height }

    options.buff.purpose()
    local dt = 0
    local cPoint
    time.setInterval(frequency, function(curTimer)
        if (targetUnit.isDead()) then
            curTimer.destroy()
            _crackFlyEnding(false, options, cPoint or sPoint)
            return
        end
        dt = dt + dtSpd
        local nPoint = {
            sPoint[1] + 2 * (mPoint[1] - sPoint[1]) * dt + (tPoint[1] - 2 * mPoint[1] + sPoint[1]) * dt ^ 2,
            sPoint[2] + 2 * (mPoint[2] - sPoint[2]) * dt + (tPoint[2] - 2 * mPoint[2] + sPoint[2]) * dt ^ 2,
            sPoint[3] + 2 * (mPoint[3] - sPoint[3]) * dt + (tPoint[3] - 2 * mPoint[3] + sPoint[3]) * dt ^ 2,
        }
        if (RectPlayable.isBorder(nPoint[1], nPoint[2])) then
            nPoint = cPoint
        end
        if (type(options.onMove) == "function") then
            local mRes = options.onMove(options, nPoint or sPoint)
            if (mRes == false) then
                curTimer.destroy()
                _crackFlyEnding(false, options, cPoint)
                return
            end
        end
        cPoint = nPoint
        targetUnit.position(cPoint[1], cPoint[2])
        targetUnit.flyHeight(cPoint[3])
        if (dt >= 1) then
            curTimer.destroy()
            _crackFlyEnding(true, options, tPoint)
        end
    end)
end