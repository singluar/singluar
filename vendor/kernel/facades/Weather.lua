---@class Weather:Object
---@param bindRect Rect
---@param weatherType string
---@return Weather|nil
function Weather(bindRect, weatherType)
    if (not isObject(bindRect, "Rect") or weatherType == nil) then
        return error("params")
    end
    local realType = c2i(weatherType.value)
    if (realType == nil) then
        return error("weatherType")
    end
    return Object("Weather", {
        bindRect = bindRect,
        weatherType = weatherType,
        realType = realType,
    })
end
