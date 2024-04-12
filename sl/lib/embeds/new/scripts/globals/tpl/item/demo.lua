---@param getData noteOnItemGetData
TPL_ITEM.DEMO = ItemTpl("TreasureChest")
    .name("物品例子")
    .description(
    {
        "|n这是一个物品例子",
        "这是第二行description",
    })
    .ability(TPL_ABILITY.DEMO)
    .icon("black")
    .worth({ gold = 10 })
    .onEvent(EVENT.Item.Get,
    function(getData)
        echo("获得物品", getData.triggerUnit.owner())
    end)