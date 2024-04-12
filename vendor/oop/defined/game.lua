---@param this Game
Class("Game")
    .construct(
    function(this, _)
        local qty = 0
        for i = 0, 11 do
            if ((J.GetPlayerController(J.Player(i)) == MAP_CONTROL_USER) and (J.GetPlayerSlotState(J.Player(i)) == PLAYER_SLOT_STATE_PLAYING)) then
                qty = qty + 1
            end
        end
        PropChange(this, "name", "std", SINGLUAR_MAP_NAME, false)
        PropChange(this, "description", "std", Array(), false)
        PropChange(this, "playingQuantityStart", "std", qty, false)
        PropChange(this, "playingQuantity", "std", qty, false)
        PropChange(this, "syncCallback", "std", {}, false)
        PropChange(this, "commands", "std", {}, false)
        PropChange(this, "worth", "std", Array(), false)
        PropChange(this, "abilityHotkey", "std", Array(), false) -- [技能]栏热键配置
        PropChange(this, "abilityLevelMax", "std", 0, false) -- [技能]最大等级数
        PropChange(this, "abilityExpFixed", "std", 0, false) -- [技能]每级需要经验固定值
        PropChange(this, "abilityExpRatio", "std", 0, false) -- [技能]每级需要经验对上一级提升百分比(默认固定提升)
        PropChange(this, "abilityExpLimit", "std", 0, false) -- [技能]每级需要经验上限
        PropChange(this, "itemHotkey", "std", 0, false) -- [物品]栏热键配置
        PropChange(this, "itemLevelMax", "std", 0, false) -- [物品]最大等级数
        PropChange(this, "itemExpFixed", "std", 0, false) -- [物品]每级需要经验固定值
        PropChange(this, "itemExpRatio", "std", 0, false) -- [物品]每级需要经验对上一级提升百分比(默认固定提升)
        PropChange(this, "itemExpLimit", "std", 0, false) -- [物品]每级需要经验上限
        PropChange(this, "itemKeyBoardRecord", "std", {}, false)
        PropChange(this, "unitLevelMax", "std", 0, false) -- [单位]最大等级数
        PropChange(this, "unitExpFixed", "std", 0, false) -- [单位]每级需要经验固定值
        PropChange(this, "unitExpRatio", "std", 0, false) -- [单位]每级需要经验对上一级提升百分比(默认固定提升)
        PropChange(this, "unitExpLimit", "std", 0, false) -- [单位]每级需要经验上限
        PropChange(this, "warehouseSlotMax", "std", 18, false) -- 玩家仓库容量(鉴于set,这里使用18为默认值)
        PropChange(this, "findPosition", "std", {}, false) -- 玩家仓库容量(鉴于set,这里使用18为默认值)
    end)