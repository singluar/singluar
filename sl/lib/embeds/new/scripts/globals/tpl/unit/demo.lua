--- 单位例子
TPL_UNIT.Footman = UnitTpl("Footman")
    .abilitySlot({ TPL_ABILITY.DEMO, TPL_ABILITY.ZZJY })
    .itemSlot({ TPL_ITEM.DEMO })
    .move(522)
    .onEvent(EVENT.Unit.MoveTurn, "myTurn",
    function()
        print("I am turning!")
    end)