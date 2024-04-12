---@param this Unit
Class("Unit")
    .inherit("UnitTpl")
    .construct(
    function(this, options)
        options.x = options.x or 0
        options.y = options.y or 0
        options.facing = options.facing or 270
        href(this, J.CreateUnit(options.owner.handle(), options.tpl.modelId(), options.x, options.y, options.facing))
        PropChange(this, "tpl", "std", options.tpl, false)
        PropChange(this, "weightCur", "std", 0, false)
        PropChange(this, "exp", "std", 0, false)
        PropChange(this, "isAlive", "std", true, false)
        PropChange(this, "owner", "std", options.owner, false)
        PropChange(this, "teamColor", "std", options.owner.teamColor(), false)
        PropChange(this, "movingStatus", "std", 0, false)
        PropChange(this, "movingStep", "std", 0, false)
        PropChange(this, "attackedTimers", "std", {}, false)
        setmetatable(this.__PROP__["0"].std, { __index = options.tpl.__PROP__["0"].std })
    end)
    .initial(
    function(this)
        group.push(this)
        --- TPL事件注册
        local onEvent = this.prop("onEvent")
        if (type(onEvent) == "table") then
            for _, e in ipairs(onEvent) do
                event.register(this, table.unpack(e))
            end
            this.prop("onEvent", NIL)
        end
        --- 模版TPL转具体技能对象，并写入技能栏
        local as = AbilitySlot(this)
        local abilitySlot = this.prop("abilitySlot")
        if (type(abilitySlot) == "table") then
            for _, v in ipairs(abilitySlot) do
                if (isObject(v, "AbilityTpl")) then
                    as.push(Ability(v))
                end
            end
        end
        this.prop("abilitySlot", as)

        --- 模版TPL转具体物品对象，并写入物品栏
        local is = ItemSlot(this)
        local itemSlot = this.prop("itemSlot")
        if (type(itemSlot) == "table") then
            for _, v in ipairs(itemSlot) do
                if (isObject(v, "ItemTpl")) then
                    is.push(Item(v))
                end
            end
        end
        this.prop("itemSlot", is)
    end)
    .destroy(
    function(this)
        group.remove(this)
        this.prop("isAlive", false)
        local itemSlot = this.itemSlot()
        if (isObject(itemSlot, "ItemSlot")) then
            itemSlot.destroy()
            this.prop("itemSlot", NIL)
        end
        local abilitySlot = this.abilitySlot()
        if (isObject(abilitySlot, "AbilitySlot")) then
            abilitySlot.destroy()
            this.prop("abilitySlot", NIL)
        end
        ---@type Array
        local ag = this.prop("attackedGather")
        if (isArray(ag)) then
            ag.forEach(function(key, val)
                if (isObject(val, "Timer")) then
                    ag.set(key, nil)
                    val.destroy()
                end
            end, true)
        end
        this.prop("attackedGather", NIL)
        this.prop("distanceTimer", NIL)
    end)

Class("Unit").afterInitial = function(this)
    event.trigger(this, EVENT.Unit.Born, { triggerUnit = this })
end