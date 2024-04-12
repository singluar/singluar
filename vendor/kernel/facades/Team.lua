---@class Team:Object
---@param key string 唯一标识key
---@return nil|Team
function Team(key)
    if (key == nil) then
        return nil
    end
    return Object("Team", {
        static = { "Team", key },
        key = key,
    })
end
