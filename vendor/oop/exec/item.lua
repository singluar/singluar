---@param this Item
---@param resultNum number
---@param resultBool boolean
---@param resultStr string
---@param resultAbility Ability
---@param resultUnit Unit
Class("Item")
    .exec("bindUnit",
    function(this, resultUnit)
        if (isObject(resultUnit, "Unit")) then
            ---@type Unit
            local prev = this.prop("bindUnit")
            if (isObject(prev, "Unit") and prev.id() ~= resultUnit.id()) then
                prev.itemSlot().remove(this.itemSlotIndex())
                this.prop("bindUnit", NIL)
            end
        end
    end)
    .exec("attributes",
    function(this, resultAttributes)
        local eKey = "attributes"
        event.unregister(this, EVENT.Item.Get, eKey)
        event.unregister(this, EVENT.Item.Lose, eKey)
        event.unregister(this, EVENT.Item.LevelChange, eKey)
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
            ---@param getData noteOnItemGetData
            this.onEvent(EVENT.Item.Get, eKey, function(getData)
                attribute.clever(resultAttributes, getData.triggerUnit, 0, getData.triggerItem.level())
            end)
            ---@param loseData noteOnItemLoseData
            this.onEvent(EVENT.Item.Lose, eKey, function(loseData)
                attribute.clever(resultAttributes, loseData.triggerUnit, loseData.triggerItem.level(), -loseData.triggerItem.level())
            end)
            ---@param lvcData noteOnItemLevelChangeData
            this.onEvent(EVENT.Item.LevelChange, eKey, function(lvcData)
                attribute.clever(resultAttributes, lvcData.triggerUnit, lvcData.triggerItem.level(), lvcData.value)
            end)
        end
    end)
    .exec("itemSlotIndex",
    function(this, resultNum)
        this.prop("hotkey", Game().itemHotkey(resultNum))
        local ab = this.prop("bindAbility")
        if (isObject(ab, "Ability")) then
            ab.prop("hotkey", Game().itemHotkey(resultNum))
        end
    end)
    .exec("ability",
    function(this, resultAbility)
        if (this.isDestroy() == false and isObject(resultAbility, "Ability")) then
            local bu = this.bindUnit()
            ---@type Ability
            local prev = this.prop("ability")
            if (isObject(prev, "Ability") and prev.id() ~= resultAbility.id()) then
                prev.prop("bindItem", NIL)
                event.trigger(prev, EVENT.Ability.Lose, { triggerAbility = prev, triggerUnit = bu })
                event.trigger(bu, EVENT.Ability.Lose, { triggerAbility = prev, triggerUnit = bu })
            end
            resultAbility.bindItem(this)
            event.trigger(resultAbility, EVENT.Ability.Get, { triggerAbility = resultAbility, triggerUnit = bu })
            event.trigger(bu, EVENT.Ability.Get, { triggerAbility = resultAbility, triggerUnit = bu })
        end
    end)
    .exec("instance",
    function(this, resultBool)
        local cur = this.__HANDLE__
        if (resultBool == true) then
            if (cur == nil) then
                local x = this.prop("x")
                local y = this.prop("y")
                cur = J.CreateUnit(PlayerPassive.handle(), this.modelId(), x, y, 270)
                href(this, cur)
                japi.EXSetUnitMoveType(cur, 0x00)
                group.push(this)
            end
        else
            if (cur ~= nil) then
                href(this, nil)
                Game().freePosition(this.prop("x"), this.prop("y"))
                this.prop("x", NIL)
                this.prop("y", NIL)
                group.remove(this)
            end
        end
        this.cls()
    end)
    .exec("modelAlias",
    function(this, resultStr)
        if (this.__HANDLE__ ~= nil) then
            japi.DzSetUnitID(this.__HANDLE__, c2i(slk.n2i(resultStr .. "|I")))
        end
    end)
    .exec("modelScale",
    function(this, resultNum)
        if (this.__HANDLE__ ~= nil) then
            J.SetUnitScale(this.__HANDLE__, resultNum, resultNum, resultNum)
        end
    end)
    .exec("animateScale",
    function(this, resultNum)
        if (this.__HANDLE__ ~= nil) then
            J.SetUnitTimeScale(this.__HANDLE__, resultNum)
        end
    end)
    .exec("period",
    function(this, resultNum)
        if (isObject(this.prop("periodTimer"), "Timer")) then
            this.prop("periodTimer").destroy()
            this.prop("periodTimer", NIL)
        end
        if (resultNum > 0) then
            this.prop("periodTimer", time.setTimeout(resultNum, function()
                this.prop("periodTimer", NIL)
                if (this.__HANDLE__ ~= nil) then
                    href(this, nil)
                end
            end))
        end
    end)
    .exec("exp",
    function(this, resultNum)
        local prevLv = this.prop("level") or 0
        if (prevLv >= 1) then
            local lv = 0
            for i = Game().itemLevelMax(), 1, -1 do
                if (resultNum >= Game().itemExpNeeds(i)) then
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
        local prevLv = this.prop("level") or 0
        if (resultNum ~= prevLv) then
            local bu = this.bindUnit()
            event.trigger(this, EVENT.Item.LevelChange, { triggerItem = this, triggerUnit = bu, value = resultNum - prevLv })
            event.trigger(bu, EVENT.Item.LevelChange, { triggerItem = this, triggerUnit = bu, resultNum - prevLv })
            local ab = this.ability()
            if isObject(ab, "Ability") then
                if (resultNum <= ab.levelMax() and ab.level() ~= resultNum) then
                    ab.level(resultNum)
                end
            end
            if ((this.exp() or 0) > 0) then
                if ((resultNum > 1 and resultNum > prevLv) or resultNum < prevLv) then
                    PropChange(this, "exp", "std", Game().itemExpNeeds(resultNum), false)
                end
            end
        end
    end)