---@param this Ability
---@param resultNum number
---@param resultUnit Unit
---@param resultItem Item
---@param resultAttributes {string,number}[]
Class("Ability")
    .exec("attributes",
    function(this, resultAttributes)
        local eKey = "attributes"
        event.unregister(this, EVENT.Ability.Get, eKey)
        event.unregister(this, EVENT.Ability.Lose, eKey)
        event.unregister(this, EVENT.Ability.LevelChange, eKey)
        if (type(resultAttributes) == "table") then
            for i = #resultAttributes, 1, -1 do
                local method = resultAttributes[i][1]
                local base = resultAttributes[i][2]
                local vary = resultAttributes[i][3]
                if (type(method) ~= "string" or (base == nil and vary == nil)) then
                    table.remove(resultAttributes, i)
                end
            end
            local prev = this.prop("attributes")
            if (type(prev) == "table") then
                local u = this.bindUnit()
                if (isObject(u, "Unit")) then
                    local lv = this.level()
                    attribute.clever(prev, u, lv, -lv)
                    attribute.clever(resultAttributes, u, 0, lv)
                end
            end
            ---@param getData noteOnAbilityGetData
            this.onEvent(EVENT.Ability.Get, eKey, function(getData)
                attribute.clever(resultAttributes, getData.triggerUnit, 0, getData.triggerAbility.level())
            end)
            ---@param loseData noteOnAbilityLoseData
            this.onEvent(EVENT.Ability.Lose, eKey, function(loseData)
                attribute.clever(resultAttributes, loseData.triggerUnit, loseData.triggerAbility.level(), -loseData.triggerAbility.level())
            end)
            ---@param lvcData noteOnAbilityLevelChangeData
            this.onEvent(EVENT.Ability.LevelChange, eKey, function(lvcData)
                attribute.clever(resultAttributes, lvcData.triggerUnit, lvcData.triggerAbility.level(), lvcData.value)
            end)
        end
    end)
    .exec("abilitySlotIndex",
    function(this, resultNum)
        PropChange(this, "hotkey", "std", Game().abilityHotkey(resultNum), false)
    end)
    .exec("bindUnit",
    function(this, resultUnit)
        if (isObject(resultUnit, "Unit")) then
            ---@type Unit
            local prev = this.prop("bindUnit")
            if (isObject(prev, "Unit") and prev.id() ~= resultUnit.id()) then
                prev.abilitySlot().remove(this.abilitySlotIndex())
                this.prop("bindUnit", NIL)
            end
        end
    end)
    .exec("bindItem",
    function(this, resultItem)
        if (isObject(resultItem, "Item")) then
            ---@type Item
            local prev = this.prop("bindItem")
            if (isObject(prev, "Item") and prev.id() ~= resultItem.id()) then
                prev.prop("bindAbility", NIL)
                this.prop("bindItem", NIL)
            end
        end
    end)
    .exec("exp",
    function(this, resultNum)
        local prevLv = this.level() or 0
        if (prevLv >= 1) then
            local lv = 0
            for i = Game().abilityLevelMax(), 1, -1 do
                if (resultNum >= Game().abilityExpNeeds(i)) then
                    lv = i
                    break
                end
            end
            if (lv ~= prevLv) then
                this.level(lv)
            end
        end
    end)
    .exec("level",
    function(this, resultNum)
        local prevLv = this.level()
        if (resultNum ~= prevLv) then
            local bu = this.bindUnit()
            event.trigger(this, EVENT.Ability.LevelChange, { triggerAbility = this, triggerUnit = bu, value = resultNum - prevLv })
            event.trigger(bu, EVENT.Ability.LevelChange, { triggerAbility = this, triggerUnit = bu, resultNum - prevLv })
            if ((this.exp() or 0) > 0) then
                if ((resultNum > 1 and resultNum > prevLv) or resultNum < prevLv) then
                    PropChange(this, "exp", "std", Game().abilityExpNeeds(resultNum), false)
                end
            end
        end
    end)