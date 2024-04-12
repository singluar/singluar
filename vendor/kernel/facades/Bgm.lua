---@class Bgm:Object
---@return Bgm
function Bgm()
    return Object("Bgm", {
        protect = true,
        static = { "Game", "Bgm" },
    })
end
