---@class Destructable:Object
---@param modelAlias string
---@param x number
---@param y number
---@param z number|nil
---@param facing number|nil
---@param scale number|nil
---@param variation number|nil
---@return Destructable|nil
function Destructable(modelAlias, x, y, z, facing, scale, variation)
    if (modelAlias == nil or x == nil or y == nil) then
        return
    end
    if (SINGLUAR_MODEL_D[modelAlias] == nil) then
        error("modelAliasNotExist " .. modelAlias)
        return
    end
    local id = slk.n2i("　" .. modelAlias .. "　")
    if (id == nil) then
        return
    end
    return Object("Destructable", {
        id = id,
        variation = variation,
        modelAlias = modelAlias,
        facing = facing,
        scale = scale,
        x = x,
        y = y,
        z = z,
    })
end
