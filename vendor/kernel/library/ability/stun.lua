--- 眩晕
---@param sourceUnit Unit|nil 可无
---@param targetUnit Unit
function ability.stun(targetUnit, sourceUnit, duration)
    if (isObject(targetUnit, "Unit") == false or targetUnit.isDead()) then
        return
    end
    if (isObject(sourceUnit, "Unit")) then
        if (targetUnit.isDead()) then
            return
        end
    end
    duration = duration or 0
    if (duration <= 0) then
        return
    end
    if (duration <= 0.05) then
        event.trigger(targetUnit, EVENT.Unit.Be.Shock, { triggerUnit = targetUnit, sourceUnit = sourceUnit })
        if (sourceUnit) then
            event.trigger(sourceUnit, EVENT.Unit.Shock, { triggerUnit = sourceUnit, targetUnit = targetUnit })
        end
    else
        event.trigger(targetUnit, EVENT.Unit.Be.Stun, { triggerUnit = targetUnit, sourceUnit = sourceUnit, duration = duration })
        if (sourceUnit) then
            event.trigger(sourceUnit, EVENT.Unit.Stun, { triggerUnit = sourceUnit, targetUnit = targetUnit, duration = duration })
        end
    end
    Buff(targetUnit, "stun", duration, 0,
        function(buffObj)
            buffObj.superposition("stun", "+=1")
            buffObj.superposition("pause", "+=1")
        end,
        function(buffObj)
            buffObj.superposition("pause", "-=1")
            buffObj.superposition("stun", "-=1")
        end).purpose()
end