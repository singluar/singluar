--- 暴击
--[[
    options = {
        sourceUnit 伤害来源
        targetUnit 目标单位
        damage 暴击最终伤害
        damageSrc 伤害来源 DAMAGE_SRC
        damageType 伤害类型
        breakArmor 破防类型
    }
]]
---@param options {sourceUnit:Unit,targetUnit:Unit,damage:number,damageSrc:DAMAGE_SRC,damageType:table,breakArmor:table}
function ability.crit(options)
    local sourceUnit = options.sourceUnit
    local targetUnit = options.targetUnit
    if (isObject(sourceUnit, "Unit") == false or sourceUnit.isDead()) then
        return
    end
    if (isObject(targetUnit, "Unit") == false or targetUnit.isDead()) then
        return
    end
    event.trigger(sourceUnit, EVENT.Unit.Crit, { triggerUnit = sourceUnit, targetUnit = targetUnit })
    event.trigger(targetUnit, EVENT.Unit.Be.Crit, { triggerUnit = targetUnit, critUnit = sourceUnit })
    local damage = options.damage or 0
    if (damage > 0) then
        local damageSrc = options.damageSrc or DAMAGE_SRC.ability
        local damageType = options.damageType or { DAMAGE_TYPE.common }
        local breakArmor = options.breakArmor or { BREAK_ARMOR.avoid }
        ability.damage({
            sourceUnit = sourceUnit,
            targetUnit = targetUnit,
            damage = damage,
            damageSrc = damageSrc,
            damageType = damageType,
            breakArmor = breakArmor
        })
    end
end