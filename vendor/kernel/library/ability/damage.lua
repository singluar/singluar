---@alias noteOnUnitDamagingData {sourceUnit:Unit,targetUnit:Unit,damage:number,damageSrc:DAMAGE_SRC,damageType:DAMAGE_TYPE[],breakArmor:BREAK_ARMOR[]}
---@param options noteOnUnitDamagingData
function ability.damage(options)
    options.damage = options.damage or 0
    if (options.damage < 1 or false == isObject(options.targetUnit, "Unit")) then
        return
    end
    if (options.targetUnit.isDead()) then
        return
    end
    if (options.ourceUnit ~= nil) then
        if (false == isObject(options.sourceUnit, "Unit")) then
            return
        end
        if (options.sourceUnit.isDead()) then
            return
        end
    end
    -- 禁用错误的伤害来源
    options.damageSrc = options.damageSrc or DAMAGE_SRC.common
    if (options.damageSrc == DAMAGE_SRC.attack and options.sourceUnit ~= nil and options.sourceUnit.isUnArming()) then
        return
    elseif (options.damageSrc == DAMAGE_SRC.ability and options.sourceUnit ~= nil and options.sourceUnit.isSilencing()) then
        return
    end
    --- 触发受伤前事件
    options.triggerUnit = options.targetUnit
    event.trigger(options.targetUnit, EVENT.Unit.BeforeHurt, options)
    options.triggerUnit = nil
    -- 修正伤害类型
    options.damageType = options.damageType or { DAMAGE_TYPE.common }
    -- 修正破防类型
    options.breakArmor = options.breakArmor or {}
    --- 对接伤害过程
    damaging.actions.forEach(function(_, callFunc)
        promise(callFunc, nil, nil, options)
        return options.damage > 0
    end)
    --- 最终伤害
    if (options.damage >= 0.1) then
        if (options.sourceUnit ~= nil) then
            options.targetUnit.lastHurtSource(options.sourceUnit)
            options.sourceUnit.lastDamageTarget(options.targetUnit)
            options.sourceUnit.superposition("damage", "+=1")
            options.sourceUnit.owner().superposition("damage", "+=1")
            time.setTimeout(3.5, function()
                if (false == options.sourceUnit.isDestroy()) then
                    options.sourceUnit.superposition("damage", "-=1")
                    options.sourceUnit.owner().superposition("damage", "-=1")
                end
            end)
            --- 触发伤害事件
            options.triggerUnit = options.sourceUnit
            event.trigger(options.sourceUnit, EVENT.Unit.Damage, options)
            if (options.damageSrc == DAMAGE_SRC.attack) then
                event.trigger(options.sourceUnit, EVENT.Unit.Attack, options)
            elseif (options.damageSrc == DAMAGE_SRC.rebound) then
                event.trigger(options.sourceUnit, EVENT.Unit.Rebound, options)
            end
            options.triggerUnit = nil
        end
        options.targetUnit.superposition("hurt", "+=1")
        options.targetUnit.owner().superposition("hurt", "+=1")
        time.setTimeout(3.5, function()
            if (false == options.targetUnit.isDestroy()) then
                options.targetUnit.superposition("hurt", "-=1")
                options.targetUnit.owner().superposition("hurt", "-=1")
            end
        end)
        options.targetUnit.hpCur("-=" .. options.damage)
        --- 触发受伤事件
        options.triggerUnit = options.targetUnit
        event.trigger(options.targetUnit, EVENT.Unit.Hurt, options)
        if (options.damageSrc == DAMAGE_SRC.attack) then
            event.trigger(options.targetUnit, EVENT.Unit.Be.Attack, options)
        elseif (options.damageSrc == DAMAGE_SRC.rebound) then
            event.trigger(options.targetUnit, EVENT.Unit.Be.Rebound, options)
        end
        options.triggerUnit = nil
    end
end
