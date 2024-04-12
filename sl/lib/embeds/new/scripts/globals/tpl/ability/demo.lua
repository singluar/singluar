---@param effectiveData noteOnAbilityEffectiveData
TPL_ABILITY.DEMO = AbilityTpl()
    .name("技能例子")
    .description("这是一个技能例子")
    .targetType(ABILITY_TARGET_TYPE.TAG_E)
    .icon("black")
    .coolDownAdv(10, 0)
    .mpCostAdv(100, 0)
    .onEvent(EVENT.Ability.Effective,
    function(effectiveData)
        echo("技能释放", effectiveData.triggerUnit.owner())
    end)