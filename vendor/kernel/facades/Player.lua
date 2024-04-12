---@class Player:Object
---@param index number integer
---@return Player
function Player(index)
    index = math.floor(index)
    if (index == nil or index < 1 or index > 16) then
        return
    end
    return Object("Player", {
        protect = true,
        static = { "Player", index },
        index = index,
    })
end