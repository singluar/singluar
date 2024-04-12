---@class ItemSlot:Object
---@param bindUnit Unit
---@return Item
function ItemSlot(bindUnit)
    if (isObject(bindUnit, "Unit") == false) then
        return
    end
    return Object("ItemSlot", {
        static = { bindUnit.id(), "ItemSlot" },
        bindUnit = bindUnit,
    })
end
