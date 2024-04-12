alliance = alliance or {}

--- 设置结盟
---@param sourcePlayer Player
---@param otherPlayer Player
---@param flag boolean
function alliance.ally(sourcePlayer, otherPlayer, flag)
    J.SetPlayerAlliance(sourcePlayer.handle(), otherPlayer.handle(), ALLIANCE_PASSIVE, flag)
    J.SetPlayerAlliance(sourcePlayer.handle(), otherPlayer.handle(), ALLIANCE_HELP_REQUEST, flag)
    J.SetPlayerAlliance(sourcePlayer.handle(), otherPlayer.handle(), ALLIANCE_HELP_RESPONSE, flag)
    J.SetPlayerAlliance(sourcePlayer.handle(), otherPlayer.handle(), ALLIANCE_SHARED_XP, flag)
    J.SetPlayerAlliance(sourcePlayer.handle(), otherPlayer.handle(), ALLIANCE_SHARED_SPELLS, flag)
end

--- 设置视野
---@param sourcePlayer Player
---@param otherPlayer Player
---@param flag boolean
function alliance.vision(sourcePlayer, otherPlayer, flag)
    J.SetPlayerAlliance(sourcePlayer.handle(), otherPlayer.handle(), ALLIANCE_SHARED_VISION, flag)
end

--- 设置控制
---@param sourcePlayer Player
---@param otherPlayer Player
---@param flag boolean
function alliance.control(sourcePlayer, otherPlayer, flag)
    J.SetPlayerAlliance(sourcePlayer.handle(), otherPlayer.handle(), ALLIANCE_SHARED_CONTROL, flag)
end

--- 设置完全控制
---@param sourcePlayer Player
---@param otherPlayer Player
---@param flag boolean
function alliance.fullControl(sourcePlayer, otherPlayer, flag)
    J.SetPlayerAlliance(sourcePlayer.handle(), otherPlayer.handle(), ALLIANCE_SHARED_ADVANCED_CONTROL, flag)
end

--- 设置中立
---@param sourcePlayer Player
---@param otherPlayer Player
---@param flag boolean
function alliance.neutral(sourcePlayer, otherPlayer, flag)
    J.SetPlayerAlliance(sourcePlayer.handle(), otherPlayer.handle(), ALLIANCE_PASSIVE, flag)
end

