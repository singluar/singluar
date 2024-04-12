---@return Player
function PlayerLocal()
    local index = 1 + J.GetPlayerId(JassCommon["GetLocalPlayer"]())
    local p = bop.static["Player" .. index]
    must(isObject(p, "Player"), "uninitialized")
    return p
end