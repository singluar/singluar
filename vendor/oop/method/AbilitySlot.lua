---@param this AbilitySlot
Class("AbilitySlot")

    .public("bindUnit",
    function(this)
        return this.prop("bindUnit")
    end)

    .public("storage",
    function(this, modify)
        if (modify) then
            local tail
            for i = #Game().abilityHotkey(), 1, -1 do
                if (modify[i] ~= nil) then
                    tail = i
                    break
                end
            end
            if (tail > this.prop("tail")) then
                this.prop("tail", tail)
            end
        end
        return this.prop("storage", modify)
    end)

    .public("empty",
    function(this)
        local number = 0
        local storage = this.storage()
        for i = 1, #Game().abilityHotkey(), 1 do
            if (false == isObject(storage[i], "Ability")) then
                number = number + 1
            end
        end
        return number
    end)

    .public("tail",
    function(this)
        return this.prop("tail")
    end)

    .public("push",
    function(this, whichAbility, index)
        ---@type Ability
        local ab
        if (isObject(whichAbility, "Ability")) then
            ab = whichAbility
        elseif (isObject(whichAbility, "AbilityTpl")) then
            ab = Ability(whichAbility)
        end
        must(isObject(ab, "Ability"))
        local storage = this.storage()
        local bu = this.bindUnit()
        if (index == nil) then
            if (ab.bindUnit() == bu) then
                return
            end
            for i = 1, #Game().abilityHotkey() do
                if (storage[i] == nil) then
                    index = i
                    break
                end
            end
        end
        must(type(index) == "number")
        local prev = storage[index]
        if (isObject(prev, "Ability")) then
            local swap = 0
            for i = 1, #Game().abilityHotkey() do
                if (storage[i] == ab) then
                    swap = i
                    break
                end
            end
            if (swap > 0) then
                -- 交换技能的情况
                storage[swap] = prev.bindUnit(this.bindUnit()).abilitySlotIndex(swap)
                storage[index] = ab.bindUnit(this.bindUnit()).abilitySlotIndex(index)
            else
                local replace = 0
                for i = 1, #Game().abilityHotkey() do
                    if (storage[i] == nil) then
                        replace = i
                        break
                    end
                end
                if (replace > 0) then
                    -- 挤开技能的情况
                    storage[replace] = prev.bindUnit(this.bindUnit()).abilitySlotIndex(replace)
                else
                    -- 删除技能的情况
                    this.remove(index)
                end
                storage[index] = ab.bindUnit(this.bindUnit()).abilitySlotIndex(index)
                event.trigger(ab, EVENT.Ability.Get, { triggerUnit = this.bindUnit(), triggerAbility = ab })
                if (isObject(ab, "Ability")) then
                    event.trigger(this.bindUnit(), EVENT.Ability.Get, { triggerUnit = this.bindUnit(), triggerAbility = ab })
                end
            end
        else
            if (ab.bindUnit() == this.bindUnit()) then
                for i = 1, #Game().abilityHotkey() do
                    if (storage[i] == ab) then
                        storage[i] = nil
                        break
                    end
                end
                storage[index] = ab.bindUnit(this.bindUnit()).abilitySlotIndex(index)
            else
                storage[index] = ab.bindUnit(this.bindUnit()).abilitySlotIndex(index)
                event.trigger(storage[index], EVENT.Ability.Get, { triggerUnit = this.bindUnit(), triggerAbility = storage[index] })
                if (isObject(storage[index], "Ability")) then
                    event.trigger(this.bindUnit(), EVENT.Ability.Get, { triggerUnit = this.bindUnit(), triggerAbility = storage[index] })
                end
            end
        end
        this.storage(storage)
    end)

    .public("remove",
    function(this, index)
        local storage = this.storage()
        if (type(index) == "number" and index > 0 and index <= #Game().abilityHotkey() and isObject(storage[index], "Ability")) then
            event.trigger(storage[index], EVENT.Ability.Lose, { triggerUnit = this.bindUnit(), triggerAbility = storage[index] })
            if (isObject(storage[index], "Ability")) then
                event.trigger(this.bindUnit(), EVENT.Ability.Lose, { triggerUnit = this.bindUnit(), triggerAbility = storage[index] })
            end
            storage[index].prop("abilitySlotIndex", NIL)
            storage[index].prop("bindUnit", NIL)
            storage[index] = nil
        end
    end)