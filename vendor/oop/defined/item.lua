---@param this Item
Class("Item")
    .inherit("ItemTpl")
    .construct(
    function(this, options)
        PropChange(this, "tpl", "std", options.tpl, false)
        PropChange(this, "x", "std", 0, false)
        PropChange(this, "y", "std", 0, false)
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
        --- 模版TPL转具体技能对象
        local ab = this.prop("ability")
        if (isObject(ab, "AbilityTpl")) then
            this.prop("ability", Ability(ab))
        end
        --- 拥有次数的物品消减
        ---@param usedData noteOnItemUsedData
        this.onEvent(EVENT.Item.Used, "chargesReduce", function(usedData)
            local charges = usedData.triggerItem.charges()
            if (charges > 0) then
                charges = charges - 1
                if (charges <= 0 and usedData.triggerItem.consumable()) then
                    usedData.triggerItem.destroy()
                else
                    usedData.triggerItem.charges(charges)
                end
            end
        end)
    end)
    .destroy(
    function(this)
        if (this.instance()) then
            this.instance(false)
        else
            this.cls()
        end
    end)