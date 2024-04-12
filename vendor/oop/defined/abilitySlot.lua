---@param this AbilitySlot
Class("AbilitySlot")
    .construct(
    function(this, options)
        PropChange(this, "bindUnit", "std", options.bindUnit, false)
        PropChange(this, "storage", "std", {}, false)
        PropChange(this, "tail", "std", 0, false)
    end)
    .destroy(
    function(this)
        local storage = this.storage()
        for i = 1, #Game().abilityHotkey() do
            if (isObject(storage[i], "Ability")) then
                storage[i].destroy()
            end
        end
    end)