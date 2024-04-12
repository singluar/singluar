---@param this Player
Class("Player")
    .construct(
    function(this, options)
        href(this, J.Player(options.index - 1))
        PropChange(this, "warehouseSlot", "std", WarehouseSlot(this), false)
        PropChange(this, "index", "std", options.index, false) -- 玩家索引[1-16]
        PropChange(this, "mapLv", "std", math.max(1, japi.DzAPI_Map_GetMapLevel(this.__HANDLE__) or 1), false)
        PropChange(this, "isRedVip", "std", japi.DzAPI_Map_IsRedVIP(this.__HANDLE__) or false, false)
        PropChange(this, "isBlueVip", "std", japi.DzAPI_Map_IsBlueVIP(this.__HANDLE__) or false, false)
        PropChange(this, "isPlatformVIP", "std", japi.DzAPI_Map_IsPlatformVIP(this.__HANDLE__) or false, false)
        PropChange(this, "dzMallItem", "std", {}, false)
        PropChange(this, "apm", "std", 0, false)
        PropChange(this, "isUser", "std", J.GetPlayerController(this.__HANDLE__) == MAP_CONTROL_USER, false)
        local isComputer = J.GetPlayerController(this.__HANDLE__) == MAP_CONTROL_COMPUTER or J.GetPlayerSlotState(this.__HANDLE__) ~= PLAYER_SLOT_STATE_PLAYING
        PropChange(this, "isComputer", "std", isComputer, false)
        PropChange(this, "name", "std", J.GetPlayerName(this.__HANDLE__), false)
        PropChange(this, "teamColor", "std", options.index, false)
        PropChange(this, "worth", "std", {}, false)
        PropChange(this, "worthRatio", "std", 100, false)
        PropChange(this, "prestige", "std", "-", false)
        PropChange(this, "sell", "std", 50, false)
        PropChange(this, "chatPattern", "std", Array(), false)
        --叠加态(叠加态可以轻松管理可叠层的状态控制)
        this.superposition("hurt", 0) --受到伤害态
        this.superposition("damage", 0) --造成伤害态
        this.superposition("mark", 0) --贴图显示态
        --
        local playerRace = J.GetPlayerRace(this.__HANDLE__)
        if (playerRace == RACE_UNDEAD or playerRace == RACE_PREF_UNDEAD or playerRace == RACE_DEMON or playerRace == RACE_PREF_DEMON) then
            playerRace = RACE_UNDEAD_NAME
        elseif (playerRace == RACE_NIGHTELF or playerRace == RACE_PREF_NIGHTELF) then
            playerRace = RACE_NIGHTELF_NAME
        elseif (playerRace == RACE_ORC or playerRace == RACE_PREF_ORC) then
            playerRace = RACE_ORC_NAME
        else
            playerRace = RACE_HUMAN_NAME
        end
        PropChange(this, "race", "std", playerRace, false)

        local playerSlotState = J.GetPlayerSlotState(this.__HANDLE__)
        if (playerSlotState == PLAYER_SLOT_STATE_EMPTY) then
            playerSlotState = PLAYER_STATUS.empty
        elseif (playerSlotState == PLAYER_SLOT_STATE_PLAYING) then
            playerSlotState = PLAYER_STATUS.playing
        elseif (playerSlotState == PLAYER_SLOT_STATE_LEFT) then
            playerSlotState = PLAYER_STATUS.leave
        end
        PropChange(this, "status", "std", playerSlotState, false)

        J.SetPlayerHandicapXP(this.__HANDLE__, 0) -- 经验置0
        event.pool(player.evtDead, function(tgr)
            J.TriggerRegisterPlayerUnitEvent(tgr, this.__HANDLE__, EVENT_PLAYER_UNIT_DEATH, nil)
        end)
        event.pool(player.evtAttacked, function(tgr)
            J.TriggerRegisterPlayerUnitEvent(tgr, this.__HANDLE__, EVENT_PLAYER_UNIT_ATTACKED, nil)
        end)
        event.pool(player.evtOrder, function(tgr)
            J.TriggerRegisterPlayerUnitEvent(tgr, this.__HANDLE__, EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER, nil)
            J.TriggerRegisterPlayerUnitEvent(tgr, this.__HANDLE__, EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER, nil)
            J.TriggerRegisterPlayerUnitEvent(tgr, this.__HANDLE__, EVENT_PLAYER_UNIT_ISSUED_ORDER, nil)
        end)
        if (false == isComputer) then
            event.pool(player.evtLeave, function(tgr)
                J.TriggerRegisterPlayerEvent(tgr, this.__HANDLE__, EVENT_PLAYER_LEAVE)
            end)
            event.pool(player.evtEsc, function(tgr)
                J.TriggerRegisterPlayerEvent(tgr, this.__HANDLE__, EVENT_PLAYER_END_CINEMATIC)
            end)
            event.pool(player.evtChat, function(tgr)
                J.TriggerRegisterPlayerChatEvent(tgr, this.__HANDLE__, "", false)
            end)
            event.pool(player.evtSelection, function(tgr)
                J.TriggerRegisterPlayerUnitEvent(tgr, this.__HANDLE__, EVENT_PLAYER_UNIT_SELECTED, nil)
            end)
            event.pool(player.evtDeSelection, function(tgr)
                J.TriggerRegisterPlayerUnitEvent(tgr, this.__HANDLE__, EVENT_PLAYER_UNIT_DESELECTED, nil)
            end)
        end
    end)