---@class Store:Object
---@param key string 唯一标识key
---@return nil|Store
function Store(key)
    if (key == nil) then
        return nil
    end
    return Object("Store", {
        static = { "Store", key },
        key = key,
    })
end
