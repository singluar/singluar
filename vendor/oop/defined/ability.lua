---@param this Ability
Class("Ability")
    .inherit("AbilityTpl")
    .construct(
    function(this, options)
        PropChange(this, "tpl", "std", options.tpl, false)
        PropChange(this, "prohibitor", "std", Array(), false)
        PropChange(this, "exp", "std", 0, false)
        setmetatable(this.__PROP__["0"].std, { __index = options.tpl.__PROP__["0"].std })
    end)
    .initial(
    function(this)
        --- TPL事件注册
        local onEvent = this.prop("onEvent")
        if (type(onEvent) == "table") then
            for _, e in ipairs(onEvent) do
                event.register(this, table.unpack(e))
            end
            this.prop("onEvent", NIL)
        end
        --- TPL单位事件注册
        local onUnitEvent = this.prop("onUnitEvent")
        if (type(onUnitEvent) == "table") then
            for _, e in ipairs(onUnitEvent) do
                this.onUnitEvent(table.unpack(e))
            end
            this.prop("onUnitEvent", NIL)
        end
    end)
    .destroy(
    function(this)
        ---@type Unit
        local bindUnit = this.prop("bindUnit")
        if (isObject(bindUnit, "Unit")) then
            local slot = bindUnit.abilitySlot()
            if (isObject(slot, "AbilitySlot")) then
                slot.remove(this.abilitySlotIndex())
            end
        end
        this.prop("abilitySlotIndex", NIL)
        this.prop("bindUnit", NIL)
        this.prop("bindItem", NIL)
    end)