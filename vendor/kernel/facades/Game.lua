---@class Game:Object
---@return Game
function Game()
    return Object("Game", {
        protect = true,
        static = { "Game", "_" },
    })
end