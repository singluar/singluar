---@param this WarehouseSlot
Class("WarehouseSlot")

    .public("bindPlayer",
    function(this)
        return this.prop("bindPlayer")
    end)

    .public("storage",
    function(this, modify)
        return this.prop("storage", modify)
    end)

    .public("empty",
    function(this)
        local number = 0
        local storage = this.storage()
        for i = 1, Game().warehouseSlot(), 1 do
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
        local bp = this.bindPlayer()
        if (index == nil) then
            if (it.bindPlayer() == bp) then
                return
            end
            for i = 1, Game().warehouseSlot(), 1 do
                if (storage[i] == nil) then
                    index = i
                    break
                end
            end
            if (index == nil) then
                bp.alert(colour.hex(colour.gold, "仓库已满"))
                return
            end
        end
        must(type(index) == "number")
        if (it.instance() == true) then
            it.instance(false)
        end
        if (it.bindUnit() ~= nil) then
            if (it.itemSlotIndex() ~= nil) then
                it.bindUnit().itemSlot().remove(it.itemSlotIndex())
            end
            it.prop("bindUnit", NIL)
        end
        if (it.ability() ~= nil) then
            it.ability().prop("bindUnit", NIL)
        end
        local prev = storage[index]
        if (isObject(prev, "Item")) then
            local swap = 0
            for i = 1, Game().warehouseSlot(), 1 do
                if (storage[i] == it) then
                    swap = i
                    break
                end
            end
            if (swap > 0) then
                -- 交换物品的情况
                storage[swap] = prev.warehouseSlotIndex(swap)
                storage[index] = it.bindPlayer(bp).warehouseSlotIndex(index)
            else
                local replace = 0
                for i = 1, Game().warehouseSlot(), 1 do
                    if (storage[i] == nil) then
                        replace = i
                        break
                    end
                end
                if (replace > 0) then
                    -- 挤开物品的情况
                    storage[replace] = prev.bindPlayer(bp).warehouseSlotIndex(replace)
                else
                    -- 删除物品的情况
                    this.remove(index)
                end
                storage[index] = it.bindPlayer(bp).warehouseSlotIndex(index)
            end
        else
            if (it.bindPlayer() == bp) then
                if (it.warehouseSlotIndex() ~= index) then
                    storage[it.warehouseSlotIndex()] = nil
                    storage[index] = it.bindPlayer(bp).warehouseSlotIndex(index)
                end
            else
                storage[index] = it.bindPlayer(bp).warehouseSlotIndex(index)
            end
        end
        this.storage(storage)
    end)

    .public("remove",
    function(this, index)
        local storage = this.storage()
        if (type(index) == "number" and index > 0 and index <= Game().warehouseSlot() and isObject(storage[index], "Item")) then
            storage[index].prop("warehouseSlotIndex", NIL)
            storage[index].prop("bindPlayer", NIL)
            storage[index] = nil
        end
    end)

    .public("drop",
    function(this, index, x, y)
        local storage = this.storage()
        if (isObject(storage[index], "Item") == false) then
            return
        end
        storage[index].drop(x, y)
        storage[index] = nil
    end)