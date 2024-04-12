--- 格挡|回避 只能用在瞬间伤害之后
---@param whichUnit Unit
function ability.parry(whichUnit)
    J.UnitAddAbility(whichUnit.handle(), SINGLUAR_ID["avoid"].add)
    J.SetUnitAbilityLevel(whichUnit.handle(), SINGLUAR_ID["avoid"].add, 2)
    J.UnitRemoveAbility(whichUnit.handle(), SINGLUAR_ID["avoid"].add)
    time.setTimeout(0, function(_)
        J.UnitAddAbility(whichUnit.handle(), SINGLUAR_ID["avoid"].sub)
        J.SetUnitAbilityLevel(whichUnit.handle(), SINGLUAR_ID["avoid"].sub, 2)
        J.UnitRemoveAbility(whichUnit.handle(), SINGLUAR_ID["avoid"].sub)
    end)
end