-- 事件反应
---@param u Unit
local function _z(u, offset)
    return u.h() + 130 + offset
end

---@param evtData noteOnUnitCritData
event.reaction(EVENT.Unit.Crit, function(evtData)
    evtData.targetUnit.attach("singluar_crit", "origin", 0.5, 1)
    ttg.model({
        model = "singluar_ttg_crit",
        size = 1.4,
        x = evtData.targetUnit.x(),
        y = evtData.targetUnit.y(),
        z = _z(evtData.targetUnit, -24),
        height = 50,
        speed = 0.5,
        duration = 0.8,
    })
end)
---@param evtData noteOnUnitAvoidData
event.reaction(EVENT.Unit.Avoid, function(evtData)
    evtData.triggerUnit.attach("singluar_ttg_avoid", "overhead", 0.3, 0.2)
end)
---@param evtData noteOnUnitImmuneInvincibleData
event.reaction(EVENT.Unit.ImmuneInvincible, function(evtData)
    evtData.triggerUnit.attach("DivineShieldTarget", "origin", 1)
    ttg.model({
        model = "singluar_ttg_immuneInvincible",
        size = 1.4,
        x = evtData.triggerUnit.x(),
        y = evtData.triggerUnit.y(),
        z = _z(evtData.triggerUnit, -44),
        height = 100,
        duration = 1,
    })
end)
---@param evtData noteOnUnitImmuneDefendData
event.reaction(EVENT.Unit.ImmuneDefend, function(evtData)
    ttg.model({
        model = "singluar_ttg_immune",
        size = 1.2,
        x = evtData.triggerUnit.x(),
        y = evtData.triggerUnit.y(),
        z = _z(evtData.triggerUnit, -44),
        height = 100,
        duration = 1,
    })
end)
---@param evtData noteOnUnitImmuneReductionData
event.reaction(EVENT.Unit.ImmuneReduction, function(evtData)
    ttg.model({
        model = "singluar_ttg_immune",
        size = 1.2,
        x = evtData.triggerUnit.x(),
        y = evtData.triggerUnit.y(),
        z = _z(evtData.triggerUnit, -44),
        height = 100,
        duration = 1,
    })
end)
---@param evtData noteOnUnitHPSuckAttackData
event.reaction(EVENT.Unit.HPSuckAttack, function(evtData)
    evtData.triggerUnit.attach("HealTarget2", "origin", 0.5)
end)
---@param evtData noteOnUnitHPSuckAbilityData
event.reaction(EVENT.Unit.HPSuckAbility, function(evtData)
    evtData.triggerUnit.attach("HealTarget2", "origin", 0.5)
end)
---@param evtData noteOnUnitMPSuckAttackData
event.reaction(EVENT.Unit.MPSuckAttack, function(evtData)
    evtData.triggerUnit.attach("AImaTarget", "origin", 0.5)
end)
---@param evtData noteOnUnitMPSuckAbilityData
event.reaction(EVENT.Unit.MPSuckAbility, function(evtData)
    evtData.triggerUnit.attach("AImaTarget", "origin", 0.5)
end)
---@param evtData noteOnUnitPunishData
event.reaction(EVENT.Unit.Punish, function(evtData)
    evtData.triggerUnit.rgba(140, 140, 140, 255, evtData.duration)
    evtData.triggerUnit.attach("singluar_ttg_punish", "head", 4.9, 0.2)
end)
---@param evtData noteOnUnitBeStunData
event.reaction(EVENT.Unit.Be.Stun, function(evtData)
    evtData.triggerUnit.attach("ThunderclapTarget", "overhead", evtData.duration)
end)
---@param evtData noteOnUnitBeSplitData
event.reaction(EVENT.Unit.Be.Split, function(evtData)
    evtData.triggerUnit.effect("SpellBreakerAttack", 0)
end)
---@param evtData noteOnUnitBeSplitSpreadData
event.reaction(EVENT.Unit.Be.SplitSpread, function(evtData)
    evtData.triggerUnit.effect("CleaveDamageTarget", 0)
end)
---@param evtData noteOnUnitHurtData
event.reaction(EVENT.Unit.Hurt, function(evtData)
    ttg.word({
        str = math.floor(evtData.damage),
        width = 7,
        size = 0.4,
        x = evtData.triggerUnit.x(),
        y = evtData.triggerUnit.y(),
        z = _z(evtData.triggerUnit, 0),
        height = 250,
        duration = 0.5,
    })
end)
---@param evtData noteOnUnitEnchantData
event.reaction(EVENT.Unit.Enchant, function(evtData)
    ttg.model({
        model = "singluar_ttg_e_" .. evtData.enchantType,
        size = 1.1,
        x = evtData.targetUnit.x() - math.rand(50, 100),
        y = evtData.targetUnit.y() - math.rand(50, 100),
        z = _z(evtData.targetUnit, -24),
        height = 200,
        speed = 0.5,
        duration = 0.5,
    })
end)