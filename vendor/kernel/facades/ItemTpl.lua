---@class ItemTpl:Object
---@param modelAlias string 模型指引
---@return ItemTpl
function ItemTpl(modelAlias)
    if (modelAlias == nil) then
        return
    end
    if (SINGLUAR_MODEL_I[modelAlias] == nil) then
        error("modelAliasNotExist " .. modelAlias)
        return
    end
    return Object("ItemTpl", {
        modelAlias = modelAlias,
    })
end
