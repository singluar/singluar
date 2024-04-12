---@param this ItemSlot
Class("ItemSlot")

    .public("bindUnit",
    function(this)
        return this.prop("bindUnit")
    end)

    .public("storage",
    function(this, modify)
        return this.prop("storage", modify)
    end)

    .public("empty",
    function(this)
        local number = 0
        local storage = this.storage()
        for i = 1, #Game().itemHotkey(), 1 do
            if (false == isObject(storage[i], "Item")) then
                number = number + 1
            end
        end
        return number
    end)

    .public("push",
    function(this, whichItem, index)
        ---@type Item
        local it
        if (isObject(whichItem, "Item")) then
            it = whichItem
        elseif (isObject(whichItem, "ItemTpl")) then
            it = Item(whichItem)
        end
        must(isObject(it, "Item"))
        local storage = this.storage()
        local bu = this.bindUnit()
        if (index == nil) then
            if (it.bindUnit() == bu) then
                return
            end
            for i = 1, #Game().itemHotkey(), 1 do
                if (storage[i] == nil) then
                    index = i
                    break
                end
            end
            if (index == nil) then
                bu.owner().alert("背包已满已移至个人仓库", false)
                bu.owner().warehouseSlot().push(whichItem)
                return
            end
        end
        must(type(index) == "number")
        if (it.instance() == true) then
            it.instance(false)
        end
        local prev = storage[index]
        if (isObject(prev, "Item")) then
            local swap = 0
            for i = 1, #Game().itemHotkey(), 1 do
                if (storage[i] == it) then
                    swap = i
                    break
                end
            end
            if (swap > 0) then
                -- 交换物品的情况
                storage[swap] = prev.bindUnit(bu).itemSlotIndex(swap)
                storage[index] = it.bindUnit(bu).itemSlotIndex(index)
            else
                local replace = 0
                for i = 1, #Game().itemHotkey(), 1 do
                    if (storage[i] == nil) then
                        replace = i
                        break
                    end
                end
                if (replace > 0) then
                    -- 挤开物品的情况
                    storage[replace] = prev.bindUnit(bu).itemSlotIndex(replace)
                else
                    -- 删除物品的情况
                    this.remove(index)
                end
                storage[index] = it.bindUnit(bu).itemSlotIndex(index)
                event.trigger(it, EVENT.Item.Get, { triggerItem = it, triggerUnit = bu })
                if (isObject(it, "Item")) then
                    event.trigger(bu, EVENT.Item.Get, { triggerItem = it, triggerUnit = bu })
                end
                if (isObject(it, "Item")) then
                    local ab = it.ability()
                    if (isObject(ab, "Ability")) then
                        event.trigger(ab, EVENT.Ability.Get, { triggerAbility = ab, triggerUnit = bu })
                        event.trigger(bu, EVENT.Ability.Get, { triggerAbility = ab, triggerUnit = bu })
                    end
                end
            end
        else
            if (it.bindUnit() == bu) then
                if (it.itemSlotIndex() ~= index) then
                    storage[it.itemSlotIndex()] = nil
                    storage[index] = it.bindUnit(bu).itemSlotIndex(index)
                end
            else
                storage[index] = it.bindUnit(bu).itemSlotIndex(index)
                event.trigger(storage[index], EVENT.Item.Get, { triggerItem = storage[index], triggerUnit = bu })
                if (isObject(storage[index], "Item")) then
                    event.trigger(bu, EVENT.Item.Get, { triggerItem = storage[index], triggerUnit = bu })
                end
                if (isObject(storage[index], "Item")) then
                    local ab = storage[index].ability()
                    if (isObject(ab, "Ability")) then
                        event.trigger(ab, EVENT.Ability.Get, { triggerAbility = ab, triggerUnit = bu })
                        event.trigger(bu, EVENT.Ability.Get, { triggerAbility = ab, triggerUnit = bu })
                    end
                end
            end
        end
    end)

    .public("remove",
    function(this, index)
        local storage = this.storage()
        if (type(index) == "number" and index > 0 and index <= #Game().itemHotkey() and isObject(storage[index], "Item")) then
            local bu = this.bindUnit()
            local ab = storage[index]:ability()
            if (isObject(ab, "Ability")) then
                event.trigger(ab, EVENT.Ability.Lose, { triggerAbility = ab, triggerUnit = bu })
                event.trigger(bu, EVENT.Ability.Lose, { triggerAbility = ab, triggerUnit = bu })
            end
            event.trigger(storage[index], EVENT.Item.Lose, { triggerItem = storage[index], triggerUnit = bu })
            if (isObject(storage[index], "Item")) then
                event.trigger(bu, EVENT.Item.Lose, { triggerItem = storage[index], triggerUnit = bu })
            end
            storage[index].prop("itemSlotIndex", NIL)
            storage[index].prop("bindUnit", NIL)
            storage[index] = nil
        end
    end)

    .public("drop",
    function(this, index, x, y)
        local storage = this.storage()
        if (isObject(storage[index], "Item") == false) then
            return
        end
        if (x == nil or y == nil) then
            if (isObject(this.bindUnit(), "Unit")) then
                x = this.bindUnit().x()
                y = this.bindUnit().y()
            else
                x = 0
                y = 0
            end
        end
        storage[index].drop(x, y)
        storage[index] = nil
    end)

    .public("dropAll",
    function(this, x, y)
        for i = 1, #Game().itemHotkey() do
            this.drop(i, x, y)
        end
    end)