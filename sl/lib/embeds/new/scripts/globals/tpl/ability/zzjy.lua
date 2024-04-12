---@param hurtData noteOnUnitHurtData
---@param effectiveData noteOnAbilityEffectiveData
TPL_ABILITY.ZZJY = AbilityTpl()
    .name("自在极意被动")
    .description(
    function(this)
        local hurtReduction = 100
        local hurtRebound = 100
        local hurtReboundOdds = 100
        return {
            "受到伤害时，启动自在极意功",
            "得到以下效果：",
            "伤害减免：+" .. colour.hex(colour.palegreen, hurtReduction) .. '%',
            "反伤比例：+" .. colour.hex(colour.violet, hurtRebound) .. '%',
            "反伤几率：+" .. colour.hex(colour.violet, hurtReboundOdds) .. '%',
        }
    end)
    .targetType(ABILITY_TARGET_TYPE.PAS)
    .icon("black")
    .coolDownAdv(5, 0)
    .mpCostAdv(50, 0)
    .levelMax(10)
    .levelUpNeedPoint(2)
    .onUnitEvent(EVENT.Unit.Hurt,
    function(hurtData)
        hurtData.triggerAbility.effective()
    end)
    .onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        -- 技能被触发的效果
        effectiveData.triggerUnit.attach("DivineShieldTarget", "origin", 3)
        ---@param buffObj Unit
        Buff(effectiveData.triggerUnit, "hurtRebound", 3, 0,
            function(buffObj)
                buffObj.hurtReduction("+=100").hurtRebound("+=100").odds("hurtRebound", "+=100")
            end,
            function(buffObj)
                buffObj.hurtReduction("-=100").hurtRebound("-=100").odds("hurtRebound", "-=100")
            end)
            .purpose()
    end)