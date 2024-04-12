---@class Quest:Object
---@param key string 唯一标识key
---@return Quest|nil
function Quest(key)
    if (key == nil) then
        return
    end
    return Object("Quest", {
        static = { "Quest", key },
        key = key,
    })
end
