---@class Server:Object
---@param bindPlayer Player
---@return nil|Server
function Server(bindPlayer)
    if (false == isObject(bindPlayer, "Player")) then
        return
    end
    return Object("Server", {
        static = { "Server", bindPlayer.index() },
        bindPlayer = bindPlayer,
    })
end
