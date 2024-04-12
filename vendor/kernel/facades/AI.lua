---@class AI:Object
---@alias key string
---@return AI
function AI(key)
    must(type(key) == "string")
    return Object("AI", {
        static = { "AI", key },
        key = key,
    })
end
