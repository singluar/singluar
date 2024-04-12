---@class Lightning:Object
---@param lightningType LIGHTNING_TYPE
---@return Lightning|nil
function Lightning(lightningType)
    ---@see LIGHTNING_TYPE variable.lua
    if (lightningType == nil) then
        return
    end
    return Object("Lightning", {
        lightningType = lightningType,
    })
end
