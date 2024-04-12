---@class Item:ItemTpl
---@param tpl ItemTpl
---@return Item
function Item(tpl)
    if (false == isObject(tpl, "ItemTpl")) then
        return
    end
    return Object("Item", {
        tpl = tpl,
    })
end
