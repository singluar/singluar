---@class WarehouseSlot:Object
---@param bindPlayer Player
---@return Item
function WarehouseSlot(bindPlayer)
    if (isObject(bindPlayer, "Player") == false) then
        return
    end
    return Object("WarehouseSlot", {
        protect = true,
        static = { bindPlayer.id(), "WarehouseSlot" },
        bindPlayer = bindPlayer,
    })
end
