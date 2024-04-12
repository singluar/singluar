---@param this ItemSlot
Class("ItemSlot")
    .construct(
    function(this, options)
        PropChange(this, "bindUnit", "std", options.bindUnit, false)
        PropChange(this, "storage", "std", {}, false)
    end)
    .destroy(
    function(this)
        local storage = this.storage()
        for i = 1, #Game().itemHotkey() do
            if (isObject(storage[i], "Item")) then
                storage[i].destroy()
            end
        end
    end)