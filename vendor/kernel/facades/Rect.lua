---@class Rect:Object
---@param key string 唯一标识key
---@param shape string | "'square'" | "'round'"
---@param x number
---@param y number
---@param width number
---@param height number
---@return Rect|nil
function Rect(key, shape, x, y, width, height)
    if (key == nil or x == nil or y == nil or width == nil or height == nil) then
        return
    end
    return Object("Rect", {
        static = { "Rect", key },
        key = key,
        shape = shape,
        x = x,
        y = y,
        width = width,
        height = height,
    })
end
