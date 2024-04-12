---@class Missile:Object
---@param modelAlias string
---@return Missile|nil
function Missile(modelAlias)
    modelAlias = AModel(modelAlias)
    if (modelAlias == nil) then
        return
    end
    return Object("Missile", {
        modelAlias = modelAlias
    })
end
