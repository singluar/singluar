---@class UnitTpl:Attribute
---@param modelAlias string
---@return UnitTpl
function UnitTpl(modelAlias)
    if (modelAlias == nil) then
        return
    end
    if (SINGLUAR_MODEL_U[modelAlias] == nil) then
        error("modelAliasNotExist " .. modelAlias)
        return
    end
    return Object("UnitTpl", {
        modelAlias = modelAlias,
    })
end
