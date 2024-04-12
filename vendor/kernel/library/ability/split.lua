--- 分裂
--[[
    options = {
        sourceUnit 伤害来源
        targetUnit 目标单位
        radius 作用半径[默认200]
        damage 分裂最终伤害
        damageSrc 伤害来源
        damageType 伤害类型
        breakArmor 破防类型
    }
]]
---@param options {sourceUnit:Unit,targetUnit:Unit,damage:number,damageSrc:DAMAGE_SRC,damageType:table,breakArmor:table}
function ability.split(options)
    local sourceUnit = options.sourceUnit
    local targetUnit = options.targetUnit
    if (isObject(sourceUnit, "Unit") == false or sourceUnit.isDead()) then
        return
    end
    if (isObject(targetUnit, "Unit") == false or targetUnit.isDead()) then
        return
    end
    local radius = options.radius or 200
    event.trigger(sourceUnit, EVENT.Unit.Split, { triggerUnit = sourceUnit, targetUnit = targetUnit, radius = radius })
    event.trigger(targetUnit, EVENT.Unit.Be.Split, { triggerUnit = targetUnit, sourceUnit = sourceUnit, radius = radius })
    local damage = options.damage or 0
    if (damage > 0) then
        local dmgSrc = options.damageSrc or DAMAGE_SRC.ability
        local damageType = options.damageType or { DAMAGE_TYPE.common }
        local breakArmor = options.breakArmor or { BREAK_ARMOR.avoid }
        local enumUnits = group.catch({
            key = "Unit",
            x = targetUnit.x(), y = targetUnit.y(), radius = radius,
            ---@param enumUnit Unit
            filter = function(enumUnit)
                return enumUnit.isAlive() and enumUnit.isSelf(targetUnit) == false and sourceUnit.isEnemy(enumUnit.owner())
            end
        })
        if (#enumUnits > 0) then
            for _, eu in ipairs(enumUnits) do
                event.trigger(eu, EVENT.Unit.Be.SplitSpread, { triggerUnit = sourceUnit, sourceUnit = sourceUnit })
                ability.damage({
                    sourceUnit = sourceUnit,
                    targetUnit = eu,
                    damage = damage,
                    damageSrc = dmgSrc,
                    damageType = damageType,
                    breakArmor = breakArmor
                })
            end
        end
    end
end