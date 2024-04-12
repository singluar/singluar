--- 最上位玩家
---@return Player
function Player1st()
    local i = 1
    for j = 1, BJ_MAX_PLAYERS do
        if (Player(j).isPlaying() and Player(j).isUser()) then
            i = j
            break
        end
    end
    return Player(i)
end