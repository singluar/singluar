--- 提取一些需要的参数
damaging.defined("prop", function(options)
    options.defend = options.targetUnit.defend()
    options.avoid = options.targetUnit.avoid() - options.sourceUnit.aim()
end)

--- 判断无视装甲类型
damaging.defined("breakArmor", function(options)
    local ignore = { defend = false, avoid = false, invincible = false }
    if (#options.breakArmor > 0) then
        for _, b in ipairs(options.breakArmor) do
            if (b ~= nil) then
                ignore[b.value] = true
                --- 触发无视防御事件
                event.trigger(options.sourceUnit, EVENT.Unit.BreakArmor, { triggerUnit = options.sourceUnit, targetUnit = options.targetUnit, breakType = b })
                --- 触发被破防事件
                event.trigger(options.targetUnit, EVENT.Unit.Be.BreakArmor, { triggerUnit = options.targetUnit, breakUnit = options.sourceUnit, breakType = b })
            end
        end
    end
    --- 处理护甲
    if (ignore.defend == true and options.defend > 0) then
        options.defend = 0
    end
    --- 处理回避
    if (ignore.avoid == true and options.avoid > 0) then
        options.avoid = 0
    end
    --- 单位是否无视无敌
    if (true == options.targetUnit.isInvulnerable()) then
        if (ignore.invincible == false) then
            --- 触发无敌抵御事件
            options.damage = 0
            event.trigger(options.sourceUnit, EVENT.Unit.ImmuneInvincible, { triggerUnit = options.targetUnit, sourceUnit = options.sourceUnit })
            return
        end
    end
end)

--- 自身攻击暴击
damaging.defined("crit", function(options)
    local approve = (options.sourceUnit ~= nil and (options.damageSrc == DAMAGE_SRC.attack or options.damageSrc == DAMAGE_SRC.ability))
    if (approve) then
        local crit = options.sourceUnit.crit()
        if (crit > 0) then
            local odds = options.sourceUnit.odds("crit") - options.targetUnit.resistance("crit")
            if (odds > math.rand(1, 100)) then
                options.damage = options.damage * (1 + crit * 0.01)
                --- 触发时自动无视回避
                options.avoid = 0
                --- 触发暴击事件
                ability.crit({ sourceUnit = options.sourceUnit, targetUnit = options.targetUnit })
            end
        end
    end
end)

--- 回避
damaging.defined("avoid", function(options)
    local approve = (options.avoid > 0 and (options.damageSrc == DAMAGE_SRC.attack or options.damageSrc == DAMAGE_SRC.rebound))
    if (approve) then
        if (options.avoid > math.rand(1, 100)) then
            -- 触发回避事件
            options.damage = 0
            event.trigger(options.targetUnit, EVENT.Unit.Avoid, { triggerUnit = options.targetUnit, sourceUnit = options.sourceUnit })
            event.trigger(options.sourceUnit, EVENT.Unit.Be.Avoid, { triggerUnit = options.sourceUnit, targetUnit = options.targetUnit })
            return
        end
    end
end)

--- 伤害加深(%)
damaging.defined("damageIncrease", function(options)
    local approve = (options.sourceUnit ~= nil)
    if (approve) then
        local damageIncrease = options.sourceUnit.damageIncrease()
        if (damageIncrease > 0) then
            options.damage = options.damage * (1 + damageIncrease * 0.01)
        end
    end
end)

--- 受伤加深(%)
damaging.defined("hurtIncrease", function(options)
    local hurtIncrease = options.targetUnit.hurtIncrease()
    if (hurtIncrease > 0) then
        options.damage = options.damage * (1 + hurtIncrease * 0.01)
    end
end)

--- 反伤(%)
damaging.defined("hurtRebound", function(options)
    -- 抵抗
    local approve = (options.sourceUnit ~= nil and options.damageSrc == DAMAGE_SRC.rebound)
    if (approve) then
        local resistance = options.sourceUnit.resistance("hurtRebound")
        if (resistance > 0) then
            options.damage = math.max(0, options.damage * (1 - resistance * 0.01))
            if (options.damage < 1) then
                options.damage = 0
                return
            end
        end
    end
    -- 反射
    approve = (options.sourceUnit ~= nil and (options.damageSrc == DAMAGE_SRC.attack or options.damageSrc == DAMAGE_SRC.ability))
    if (approve) then
        local hurtRebound = options.targetUnit.hurtRebound()
        local odds = options.targetUnit.odds("hurtRebound")
        if (hurtRebound > 0 and odds > math.rand(1, 100)) then
            local dmgRebound = math.trunc(options.damage * hurtRebound * 0.01, 3)
            if (dmgRebound >= 1.0) then
                local damagedArrived = function()
                    --- 触发反伤事件
                    ability.damage({
                        sourceUnit = options.targetUnit,
                        targetUnit = options.sourceUnit,
                        damage = dmgRebound,
                        damageSrc = DAMAGE_SRC.rebound,
                        damageType = options.damageType,
                    })
                end
                if (options.damageSrc == DAMAGE_SRC.attack) then
                    -- 攻击下
                    if (options.sourceUnit.isMelee()) then
                        damagedArrived()
                    elseif (options.sourceUnit.isRanged()) then
                        local lt = options.sourceUnit.lightning()
                        if (isObject(lt, "Lightning")) then
                            local lDur = 0.3
                            local lDelay = lDur * 0.6
                            ability.lightning(lt.lightningType(),
                                options.targetUnit.x(), options.targetUnit.y(), options.targetUnit.h(),
                                options.sourceUnit.x(), options.sourceUnit.y(), options.sourceUnit.h(), lDur)
                            time.setTimeout(lDelay, function()
                                damagedArrived()
                            end)
                        else
                            local m = options.sourceUnit.missile()
                            if (isObject(m, "Missile")) then
                                ability.missile({
                                    modelAlias = m.modelAlias(),
                                    sourceUnit = options.targetUnit,
                                    targetUnit = options.sourceUnit,
                                    speed = m.speed(),
                                    height = 0,
                                    acceleration = m.acceleration(),
                                    onEnd = function() damagedArrived() end,
                                })
                            end
                        end
                    end
                elseif (options.damageSrc == DAMAGE_SRC.ability) then
                    -- 技能情况
                    damagedArrived()
                end
            end
        end
    end
end)

--- 防御
damaging.defined("defend", function(options)
    if (options.defend < 0) then
        options.damage = options.damage + math.abs(options.defend)
    elseif (options.defend > 0) then
        options.damage = options.damage - options.defend
        if (options.damage < 1) then
            -- 触发防御完全抵消事件
            options.damage = 0
            event.trigger(options.targetUnit, EVENT.Unit.ImmuneDefend, { triggerUnit = options.targetUnit, sourceUnit = options.sourceUnit })
            return
        end
    end
end)

--- 减伤(%)
damaging.defined("hurtReduction", function(options)
    local hurtReduction = options.targetUnit.hurtReduction()
    if (hurtReduction > 0) then
        options.damage = options.damage * (1 - hurtReduction * 0.01)
        if (options.damage < 1) then
            -- 触发减伤完全抵消事件
            options.damage = 0
            event.trigger(options.targetUnit, EVENT.Unit.ImmuneReduction, { triggerUnit = options.targetUnit, sourceUnit = options.sourceUnit })
            return
        end
    end
end)

--- 攻击吸血
damaging.defined("hpSuckAttack", function(options)
    local approve = (options.sourceUnit ~= nil and options.damageSrc == DAMAGE_SRC.attack)
    if (approve) then
        local percent = options.sourceUnit.hpSuckAttack() - options.targetUnit.resistance("hpSuckAttack")
        local val = options.damage * percent * 0.01
        if (percent > 0 and val > 0) then
            options.sourceUnit.hpCur("+=" .. val)
            --- 触发吸血事件
            event.trigger(options.sourceUnit, EVENT.Unit.HPSuckAttack, { triggerUnit = options.sourceUnit, targetUnit = options.targetUnit, value = val, percent = percent })
            event.trigger(options.targetUnit, EVENT.Unit.Be.HPSuckAttack, { triggerUnit = options.targetUnit, sourceUnit = options.sourceUnit, value = val, percent = percent })
        end
    end
end)

--- 技能吸血
damaging.defined("hpSuckAbility", function(options)
    local approve = (options.sourceUnit ~= nil and options.damageSrc == DAMAGE_SRC.ability)
    if (approve) then
        local percent = options.sourceUnit.hpSuckAbility() - options.targetUnit.resistance("hpSuckAbility")
        local val = options.damage * percent * 0.01
        if (percent > 0 and val > 0) then
            options.sourceUnit.hpCur("+=" .. val)
            --- 触发技能吸血事件
            event.trigger(options.sourceUnit, EVENT.Unit.HPSuckAbility, { triggerUnit = options.sourceUnit, targetUnit = options.targetUnit, value = val, percent = percent })
            event.trigger(options.targetUnit, EVENT.Unit.Be.HPSuckAbility, { triggerUnit = options.targetUnit, sourceUnit = options.sourceUnit, value = val, percent = percent })
        end
    end
end)

--- 攻击吸魔;吸魔会根据伤害，扣减目标的魔法值，再据百分比增加自己的魔法值;目标魔法值不足 1 从而吸收时，则无法吸取
damaging.defined("mpSuckAttack", function(options)
    local approve = (options.sourceUnit ~= nil and options.damageSrc == DAMAGE_SRC.attack and options.sourceUnit.mp() > 0 and options.targetUnit.mpCur() > 0)
    if (approve) then
        local percent = options.sourceUnit.mpSuckAttack() - options.targetUnit.resistance("mpSuckAttack")
        if (percent > 0) then
            local mana = math.min(options.targetUnit.mp(), options.damage)
            local val = mana * percent * 0.01
            if (val > 1) then
                options.targetUnit.mpCur("-=" .. val)
                options.sourceUnit.mpCur("+=" .. val)
                --- 触发吸魔事件
                event.trigger(options.sourceUnit, EVENT.Unit.MPSuckAttack, { triggerUnit = options.sourceUnit, targetUnit = options.targetUnit, value = val, percent = percent })
                event.trigger(options.targetUnit, EVENT.Unit.Be.MPSuckAttack, { triggerUnit = options.targetUnit, sourceUnit = options.sourceUnit, value = val, percent = percent })
            end
        end
    end
end)

--- 技能吸魔;吸魔会根据伤害，扣减目标的魔法值，再据百分比增加自己的魔法值;目标魔法值不足 1 从而吸收时，则无法吸取
damaging.defined("mpSuckAbility", function(options)
    local approve = (options.sourceUnit ~= nil and options.damageSrc == DAMAGE_SRC.ability and options.sourceUnit.mp() > 0 and options.targetUnit.mpCur() > 0)
    if (approve) then
        local percent = options.sourceUnit.mpSuckAbility() - options.targetUnit.resistance("mpSuckAbility")
        if (percent > 0) then
            local mana = math.min(options.targetUnit.mp(), options.damage)
            local val = mana * percent * 0.01
            if (val > 1) then
                options.targetUnit.mpCur("-=" .. val)
                options.sourceUnit.mpCur("+=" .. val)
                --- 触发技能吸魔事件
                event.trigger(options.sourceUnit, EVENT.Unit.MPSuckAbility, { triggerUnit = options.sourceUnit, targetUnit = options.targetUnit, value = val, percent = percent })
                event.trigger(options.targetUnit, EVENT.Unit.Be.MPSuckAbility, { triggerUnit = options.targetUnit, sourceUnit = options.sourceUnit, value = val, percent = percent })
            end
        end
    end
end)

--- 硬直
damaging.defined("punishCur", function(options)
    local approve = (options.targetUnit.punish() > 0 and options.targetUnit.isPunishing() == false)
    if (approve) then
        options.targetUnit.punishCur("-=" .. options.damage)
    end
end)

--- 伤害类型占比处理
damaging.defined("enchant", function(options)
    options.damageTypeRatio = {}
    options.enchantType = {}
    local damageTypeOcc = 0
    local ratio = {}
    if (options.damageSrc == DAMAGE_SRC.attack and options.sourceUnit ~= nil) then
        -- 附加攻击形态的伤害类型
        enchant.types.forEach(function(ek, _)
            local ew = options.sourceUnit.enchantWeapon(ek)
            if (ew > 0) then
                damageTypeOcc = damageTypeOcc + ew
                if (ratio[ek] == nil) then
                    ratio[ek] = 0
                end
                ratio[ek] = ratio[ek] + ew
                table.insert(options.enchantType, ek)
            end
        end)
    elseif (type(options.damageType) == "table" and #options.damageType > 0) then
        for _, d in ipairs(options.damageType) do
            if (type(d) == "table" and d.value) then
                damageTypeOcc = damageTypeOcc + 1
                if (ratio[d.value] == nil) then
                    ratio[d.value] = 0
                end
                ratio[d.value] = ratio[d.value] + 1
                table.insert(options.enchantType, d.value)
            end
        end
    end
    if (damageTypeOcc == 0) then
        damageTypeOcc = 1
        ratio[DAMAGE_TYPE.common.value] = 1
    end
    local dtu = 1 / damageTypeOcc
    for _, dt in ipairs(DAMAGE_TYPE_KEYS) do
        if (ratio[dt] == nil) then
            ratio[dt] = 0
        end
        options.damageTypeRatio[dt] = dtu * ratio[dt]
    end
end)

-- 附魔类型(加成|抵抗|上身)
damaging.defined("enchantAppend", function(options)
    for _, et in ipairs(options.enchantType) do
        local addition = 0
        if (options.sourceUnit ~= nil) then
            local amplify = options.sourceUnit.enchant(et)
            if (amplify ~= 0) then
                addition = addition + amplify * 0.01
            end
        end
        local resistance = options.targetUnit.enchantResistance(et)
        if (resistance ~= 0) then
            addition = addition - resistance * 0.01
        end
        local d = options.damage * addition * options.damageTypeRatio[et]
        --- 触发附魔事件
        event.trigger(options.targetUnit, EVENT.Unit.Enchant, {
            triggerUnit = options.sourceUnit, targetUnit = options.targetUnit,
            enchantType = et,
            radio = options.damageTypeRatio[et], damage = d, addition = addition
        })
        options.damage = options.damage + d
    end
    if (#options.enchantType > 0) then
        enchant.append(options.targetUnit, options.sourceUnit, options.enchantType)
    end
end)