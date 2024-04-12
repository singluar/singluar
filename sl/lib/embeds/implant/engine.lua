---@type table<string,any>
SL_CACHE = SL_CACHE or {
    ["tips"] = {},
    ["Roulette"] = nil,
    ["RouletteWait"] = false,
    ["IsWideScreen"] = false,
    ["FrameTagIndex"] = 0,
    ["DzLoadToc"] = {},
    ["Z"] = {},
    ["ZI"] = 32,
    ["FrameBlackTop"] = 0.020,
    ["FrameBlackBottom"] = 0.130,
    ["FrameInnerHeight"] = 0.45,
    ["Refresh"] = nil,
    ["IsTyping"] = {},
}
SL_ENGINE = SL_ENGINE or {}

local function msg_(msg)
    if (SL_CACHE["tips"][msg] == nil) then
        SL_CACHE["tips"][msg] = 1
        if (DEBUGGING) then
            print("JAPI " .. msg)
        else
            echo("JAPI " .. msg)
        end
    end
end

--- 轮盘队列
--- 此方法自带延迟策略
--- 并且自动合并请求
--- 从而可以大大减轻执行压力
--- 只适用于无返回执行
---@param whichPlayer number
---@param key string
---@param func function
---@return void
local function roulette_(func, whichPlayer, key, value)
    if (type(func) ~= "function" or type(key) ~= "string" or type(value) ~= "string") then
        return
    end
    local rf = function()
        if (SL_ENGINE["ServerAlready_"](whichPlayer)) then
            func(whichPlayer, key, value)
        end
    end
    if (isArray(SL_CACHE["Roulette"])) then
        SL_CACHE["RouletteWait"] = false
        if (SL_CACHE["Roulette"].keyExists(key)) then
            SL_CACHE["Roulette"].set(key, nil)
        end
        SL_CACHE["Roulette"].set(key, rf)
        return
    end
    SL_CACHE["Roulette"] = Array()
    SL_CACHE["Roulette"].set(key, rf)
    time.setInterval(0, function(curTimer)
        curTimer.period(3)
        local ks = SL_CACHE["Roulette"].keys()
        local k1 = ks[1]
        local f = SL_CACHE["Roulette"].get(k1)
        f()
        SL_CACHE["Roulette"].set(k1, nil)
        if (SL_CACHE["Roulette"].count() == 0) then
            SL_CACHE["RouletteWait"] = true
            time.setTimeout(3, function()
                if (SL_CACHE["RouletteWait"] == true) then
                    curTimer.destroy()
                    SL_CACHE["Roulette"] = nil
                    SL_CACHE["RouletteWait"] = false
                end
            end)
        end
    end)
end

---@param method string
---@vararg any
---@return any
J.ExecJAPI = function(method, ...)
    if (type(method) ~= "string") then
        return false
    end
    local m = string.sub(method, string.len(method))
    if ("_" == m) then
        return SL_ENGINE[method](...)
    else
        if (JassJapi == nil) then
            return false
        end
        if (type(JassJapi[method]) ~= "function") then
            msg_(method .. "_FUNCTION_NOT_EXIST")
            return false
        end
        return JassJapi[method](...)
    end
end

SL_ENGINE["DzFrameEditBlackBorders_"] = function(topHeight, bottomHeight)
    SL_CACHE["FrameBlackTop"] = topHeight
    SL_CACHE["FrameBlackBottom"] = bottomHeight
    SL_CACHE["FrameInnerHeight"] = 0.6 - topHeight - bottomHeight
    return J.ExecJAPI("DzFrameEditBlackBorders", topHeight, bottomHeight)
end

SL_ENGINE["DzEnableWideScreen_"] = function(enable)
    SL_CACHE["IsWideScreen"] = enable
    return J.ExecJAPI("DzEnableWideScreen", enable)
end

SL_ENGINE["DzLoadToc_"] = function(tocFilePath)
    if (SL_CACHE["DzLoadToc"][tocFilePath] == true) then
        return true
    end
    SL_CACHE["DzLoadToc"][tocFilePath] = true
    return J.ExecJAPI("DzLoadToc", tocFilePath)
end

SL_ENGINE["EXGetUnitAbility_"] = function(whichUnit, abilityID)
    if (type(abilityID) == "string") then
        abilityID = c2i(abilityID)
    end
    return J.ExecJAPI("EXGetUnitAbility", whichUnit, abilityID)
end

SL_ENGINE["SetUnitState_"] = function(whichUnit, state, value)
    J.ExecJAPI("SetUnitState", whichUnit, state, value)
    if (whichUnit ~= nil and state == UNIT_STATE_ATTACK_WHITE or state == UNIT_STATE_DEFEND_WHITE) then
        J.UnitAddAbility(whichUnit, SINGLUAR_ID["japi_delay"])
        J.UnitRemoveAbility(whichUnit, SINGLUAR_ID["japi_delay"])
    end
end

SL_ENGINE["FPS_"] = function()
    return SL_FPS
end

SL_ENGINE["ServerAlready_"] = function(whichPlayer)
    local res = japi.DzAPI_Map_GetServerValueErrorCode(whichPlayer)
    if (type(res) == "number") then
        return math.floor(res) == 0
    end
    return false
end

SL_ENGINE["ServerSaveValue_"] = function(whichPlayer, key, value)
    if (string.len(key) > 63) then
        japi._msg("63_KEY_TOO_LONG")
        return
    end
    if (type(value) == "boolean") then
        if (value == true) then
            value = "B:1"
        else
            value = "B:0"
        end
    elseif (type(value) == "number") then
        value = "N:" .. tostring(value)
    elseif (type(value) ~= "string") then
        value = ""
    end
    if (string.len(value) > 63) then
        msg_("63_VALUE_TOO_LONG")
        return
    end
    roulette_(japi.DzAPI_Map_SaveServerValue, whichPlayer, key, value)
end

SL_ENGINE["ServerLoadValue_"] = function(whichPlayer, key)
    if (string.len(key) > 63) then
        japi._msg("63_KEY_TOO_LONG")
        return
    end
    if (SL_ENGINE["ServerAlready_"](whichPlayer)) then
        local result = japi.DzAPI_Map_GetServerValue(whichPlayer, key)
        if (type(result) == "string") then
            local valType = string.sub(result, 1, 2)
            if (valType == "B:") then
                local v = string.sub(result, 3)
                return "1" == v
            elseif (valType == "N:") then
                local v = string.sub(result, 3)
                return tonumber(v or 0)
            end
            if (result == '') then
                return nil
            end
            return result
        end
    end
    return nil
end

SL_ENGINE["ServerSaveRoom_"] = function(whichPlayer, key, value)
    if (string.len(key) > 63) then
        msg_("63_KEY_TOO_LONG")
        return
    end
    key = string.upper(key)
    if (type(value) == "boolean") then
        if (value == true) then
            value = "true"
        else
            value = "false"
        end
    elseif (type(value) == "number") then
        value = math.numberFormat(value, 2)
    elseif (type(value) ~= "string") then
        value = ""
    end
    if (string.len(value) > 63) then
        msg_("63_VALUE_TOO_LONG")
        return
    end
    roulette_(japi.DzAPI_Map_Stat_SetStat, whichPlayer, key, value)
end

SL_ENGINE["GetFrameBorders_"] = function()
    return SL_CACHE["FrameBlackTop"], SL_CACHE["FrameBlackBottom"], SL_CACHE["FrameInnerHeight"]
end

SL_ENGINE["IsWideScreen_"] = function()
    return SL_CACHE["IsWideScreen"]
end

SL_ENGINE["IsEventPhysicalDamage_"] = function()
    return 0 ~= japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_PHYSICAL)
end

SL_ENGINE["IsEventAttackDamage_"] = function()
    return 0 ~= japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_ATTACK)
end

SL_ENGINE["IsEventRangedDamage_"] = function()
    return 0 ~= japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_IS_RANGED)
end

SL_ENGINE["IsEventDamageType_"] = function(damageType)
    return damageType == J.ConvertDamageType(japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_DAMAGE_TYPE))
end

SL_ENGINE["IsEventWeaponType_"] = function(weaponType)
    return weaponType == J.ConvertWeaponType(japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_WEAPON_TYPE))
end

SL_ENGINE["IsEventAttackType_"] = function(attackType)
    return attackType == J.ConvertAttackType(japi.EXGetEventDamageData(EVENT_DAMAGE_DATA_ATTACK_TYPE))
end

SL_ENGINE["IsTyping_"] = function()
    local pi = 1 + J.GetPlayerId(JassCommon["GetLocalPlayer"]())
    return SL_CACHE["IsTyping"][pi] or false
end

SL_ENGINE["FrameTagIndex_"] = function()
    SL_CACHE["FrameTagIndex"] = SL_CACHE["FrameTagIndex"] + 1
    return "Frame#" .. SL_CACHE["FrameTagIndex"]
end

SL_ENGINE["DzConvertWorldPosition_"] = function(x, y, z)
    return -1, -1
end

SL_ENGINE["DzAPI_Map_IsPlatformVIP_"] = function(whichPlayer)
    local res = japi.DzAPI_Map_GetPlatformVIP(whichPlayer)
    if (type(res) == "number") then
        return math.round(res) > 0
    end
    return false
end

SL_ENGINE["DzAPI_Map_Ladder_SubmitPlayerRank_"] = function(whichPlayer, value)
    return japi.DzAPI_Map_Ladder_SetPlayerStat(whichPlayer, "RankIndex", math.floor(value))
end

SL_ENGINE["DzAPI_Map_Ladder_SubmitTitle_"] = function(whichPlayer, value)
    return japi.DzAPI_Map_Ladder_SetStat(whichPlayer, value, "1")
end

SL_ENGINE["DzAPI_Map_Ladder_SubmitPlayerExtraExp_"] = function(whichPlayer, value)
    return japi.DzAPI_Map_Ladder_SetStat(whichPlayer, "ExtraExp", math.floor(value))
end

SL_ENGINE["DzTriggerRegisterMallItemSyncData_"] = function(trig)
    japi.DzTriggerRegisterSyncData(trig, "DZMIA", true)
end

SL_ENGINE["DzAPI_Map_Global_ChangeMsg_"] = function(trig)
    japi.DzTriggerRegisterSyncData(trig, "DZGAU", true)
end

SL_ENGINE["DzAPI_Map_IsRPGQuickMatch_"] = function()
    return japi.RequestExtraBooleanData(40, nil, nil, nil, false, 0, 0, 0)
end

SL_ENGINE["DzAPI_Map_GetMallItemCount_"] = function(whichPlayer, key)
    return japi.RequestExtraIntegerData(41, whichPlayer, key, nil, false, 0, 0, 0)
end

SL_ENGINE["DzAPI_Map_ConsumeMallItem_"] = function(whichPlayer, key, value)
    return japi.RequestExtraBooleanData(42, whichPlayer, key, nil, false, value, 0, 0)
end

SL_ENGINE["DzAPI_Map_EnablePlatformSettings_"] = function(whichPlayer, option, enable)
    return japi.RequestExtraBooleanData(43, whichPlayer, nil, nil, enable, option, 0, 0)
end

SL_ENGINE["DzAPI_Map_IsBuyReforged_"] = function(whichPlayer)
    return japi.RequestExtraBooleanData(44, whichPlayer, nil, nil, false, 0, 0, 0)
end

SL_ENGINE["DzAPI_Map_PlayedGames_"] = function(whichPlayer)
    return japi.RequestExtraIntegerData(45, whichPlayer, nil, nil, false, 0, 0, 0)
end

SL_ENGINE["DzAPI_Map_CommentCount_"] = function(whichPlayer)
    return japi.RequestExtraIntegerData(46, whichPlayer, nil, nil, false, 0, 0, 0)
end

SL_ENGINE["DzAPI_Map_FriendCount_"] = function(whichPlayer)
    return japi.RequestExtraIntegerData(47, whichPlayer, nil, nil, false, 0, 0, 0)
end

SL_ENGINE["DzAPI_Map_IsConnoisseur_"] = function(whichPlayer)
    return japi.RequestExtraBooleanData(48, whichPlayer, nil, nil, false, 0, 0, 0)
end

SL_ENGINE["DzAPI_Map_IsBattleNetAccount_"] = function(whichPlayer)
    return japi.RequestExtraBooleanData(49, whichPlayer, nil, nil, false, 0, 0, 0)
end

SL_ENGINE["DzAPI_Map_IsAuthor_"] = function(whichPlayer)
    return japi.RequestExtraBooleanData(50, whichPlayer, nil, nil, false, 0, 0, 0)
end

SL_ENGINE["DzAPI_Map_CommentTotalCount_"] = function()
    return japi.RequestExtraIntegerData(51, nil, nil, nil, false, 0, 0, 0)
end

SL_ENGINE["DzAPI_Map_CustomRanking_"] = function(whichPlayer, id)
    return japi.RequestExtraIntegerData(52, whichPlayer, nil, nil, false, id, 0, 0)
end

SL_ENGINE["DzAPI_Map_IsPlatformReturn_"] = function(whichPlayer)
    return japi.RequestExtraBooleanData(53, whichPlayer, nil, nil, false, 2, 0, 0)
end

SL_ENGINE["DzAPI_Map_IsMapReturn_"] = function(whichPlayer)
    return japi.RequestExtraBooleanData(53, whichPlayer, nil, nil, false, 8, 0, 0)
end

SL_ENGINE["DzAPI_Map_IsPlatformReturnUsed_"] = function(whichPlayer)
    return japi.RequestExtraBooleanData(53, whichPlayer, nil, nil, false, 4, 0, 0)
end

SL_ENGINE["DzAPI_Map_IsMapReturnUsed_"] = function(whichPlayer)
    return japi.RequestExtraBooleanData(53, whichPlayer, nil, nil, false, 1, 0, 0)
end

SL_ENGINE["DzAPI_Map_IsCollected_"] = function(whichPlayer)
    return japi.RequestExtraBooleanData(53, whichPlayer, nil, nil, false, 16, 0, 0)
end

SL_ENGINE["DzAPI_Map_ContinuousCount_"] = function(whichPlayer, id)
    return japi.RequestExtraIntegerData(54, whichPlayer, nil, nil, false, id, 0, 0)
end

SL_ENGINE["DzAPI_Map_IsPlayer_"] = function(whichPlayer)
    return japi.RequestExtraBooleanData(55, whichPlayer, nil, nil, false, 0, 0, 0)
end

SL_ENGINE["DzAPI_Map_MapsTotalPlayed_"] = function(whichPlayer)
    return japi.RequestExtraIntegerData(56, whichPlayer, nil, nil, false, 0, 0, 0)
end

SL_ENGINE["DzAPI_Map_MapsLevel_"] = function(whichPlayer, mapId)
    return japi.RequestExtraIntegerData(57, whichPlayer, nil, nil, false, mapId, 0, 0)
end

SL_ENGINE["DzAPI_Map_MapsConsumeGold_"] = function(whichPlayer, mapId)
    return japi.RequestExtraIntegerData(58, whichPlayer, nil, nil, false, mapId, 0, 0)
end

SL_ENGINE["DzAPI_Map_MapsConsumeLumber_"] = function(whichPlayer, mapId)
    return japi.RequestExtraIntegerData(59, whichPlayer, nil, nil, false, mapId, 0, 0)
end

SL_ENGINE["DzAPI_Map_MapsConsume_1_199_"] = function(whichPlayer, mapId)
    return japi.RequestExtraBooleanData(60, whichPlayer, nil, nil, false, mapId, 0, 0)
end

SL_ENGINE["DzAPI_Map_MapsConsume_200_499_"] = function(whichPlayer, mapId)
    return japi.RequestExtraBooleanData(61, whichPlayer, nil, nil, false, mapId, 0, 0)
end

SL_ENGINE["DzAPI_Map_MapsConsume_500_999_"] = function(whichPlayer, mapId)
    return japi.RequestExtraBooleanData(62, whichPlayer, nil, nil, false, mapId, 0, 0)
end

SL_ENGINE["DzAPI_Map_MapsConsume_1000_"] = function(whichPlayer, mapId)
    return japi.RequestExtraBooleanData(63, whichPlayer, nil, nil, false, mapId, 0, 0)
end

SL_ENGINE["DzAPI_Map_GetForumData_"] = function(whichPlayer, data)
    return japi.RequestExtraIntegerData(65, whichPlayer, nil, nil, false, data, 0, 0)
end

SL_ENGINE["DzAPI_Map_OpenMall_"] = function(whichPlayer, key)
    return japi.RequestExtraIntegerData(66, whichPlayer, key, nil, false, 0, 0, 0)
end

SL_ENGINE["DzAPI_Map_GetLastRecommendTime_"] = function(whichPlayer)
    return japi.RequestExtraIntegerData(67, whichPlayer, nil, nil, false, 0, 0, 0)
end

SL_ENGINE["DzAPI_Map_GetLotteryUsedCount_"] = function(whichPlayer)
    return japi.RequestExtraIntegerData(68, whichPlayer, nil, nil, false, 0, 0, 0)
end

SL_ENGINE["DzAPI_Map_GameResult_CommitData_"] = function(whichPlayer, key, value)
    return japi.RequestExtraIntegerData(69, whichPlayer, key, tostring(value), false, 0, 0, 0)
end

SL_ENGINE["DzAPI_Map_IsMapTest_"] = function()
    return japi.RequestExtraBooleanData(74, nil, nil, nil, false, 0, 0, 0)
end

SL_ENGINE["Z_"] = function(x, y)
    if (type(x) == "number" and type(y) == "number") then
        local xi = math.floor(x / SL_CACHE["ZI"])
        local yi = math.floor(y / SL_CACHE["ZI"])
        if (SL_CACHE["Z"][xi]) then
            return SL_CACHE["Z"][xi][yi] or 0
        end
    end
    return 0
end

SL_ENGINE["PX_"] = function(x)
    return japi.DzGetClientWidth() * x / 0.8
end

SL_ENGINE["PY_"] = function(y)
    return japi.DzGetClientHeight() * y / 0.6
end

SL_ENGINE["RX_"] = function(x)
    return x / japi.DzGetClientWidth() * 0.8
end

SL_ENGINE["RY_"] = function(y)
    return y / japi.DzGetClientHeight() * 0.6
end

SL_ENGINE["MousePX_"] = function()
    return japi.DzGetMouseXRelative()
end

SL_ENGINE["MousePY_"] = function()
    return japi.DzGetClientHeight() - japi.DzGetMouseYRelative()
end

SL_ENGINE["MouseRX_"] = function()
    return japi.RX(japi.MousePX())
end

SL_ENGINE["MouseRY_"] = function()
    return japi.RY(japi.MousePY())
end

SL_ENGINE["InWindow_"] = function(rx, ry)
    return rx > 0 and rx < 0.8 and ry > 0 and ry < 0.6
end

SL_ENGINE["InWindowMouse_"] = function()
    return japi.InWindow(japi.MouseRX(), japi.MouseRY())
end

SL_ENGINE["FrameAdaptive_"] = function(w)
    w = w or 0
    if (w == 0) then
        return 0
    end
    local sr = 4 / 3
    local pr = 16 / 9
    local tr = sr / pr
    local dr = japi.DzGetClientWidth() / japi.DzGetClientHeight() / pr
    w = w * tr / dr
    if (w > 0) then
        w = math.max(0.0002, w)
        w = math.min(0.8, w)
    elseif (w < 0) then
        w = math.max(-0.8, w)
        w = math.min(-0.0002, w)
    end
    return w
end

SL_ENGINE["FrameDisAdaptive_"] = function(w)
    w = w or 0
    if (w == 0) then
        return 0
    end
    local sr = 4 / 3
    local pr = 16 / 9
    local tr = sr / pr
    local dr = japi.DzGetClientWidth() / japi.DzGetClientHeight() / pr
    w = w * dr / tr
    if (w > 0) then
        w = math.max(0.0002, w)
        w = math.min(1.6, w)
    elseif (w < 0) then
        w = math.max(-1.6, w)
        w = math.min(-0.0002, w)
    end
    return w
end

SL_ENGINE["Refresh_"] = function(key, callFunc)
    if (type(callFunc) == "function") then
        SL_CACHE["Refresh"].set(key, callFunc)
    else
        SL_CACHE["Refresh"].set(key)
    end
end