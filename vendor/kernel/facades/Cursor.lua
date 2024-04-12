---@class Cursor:Object
---@return Cursor|nil
function Cursor()
    return Object("Cursor", {
        protect = true,
        static = { "Cursor", "_" },
    })
end
