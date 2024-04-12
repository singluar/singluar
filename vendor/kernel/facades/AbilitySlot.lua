---@class AbilitySlot:Object
---@param bindUnit Unit
---@return Item
function AbilitySlot(bindUnit)
    if (isObject(bindUnit, "Unit") == false) then
        return
    end
    return Object("AbilitySlot", {
        static = { bindUnit.id(), "AbilitySlot" },
        bindUnit = bindUnit,
    })
end
