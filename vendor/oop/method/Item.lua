---@param this Item
Class("Item")

    .public("onEvent",
    function(this, evt, ...)
        event.register(this, evt, ...)
        return this
    end)

    .public("onUnitEvent",
    function(this, evt, ...)
        local opt = { ... }
        local key
        local callFunc
        if (type(opt[1]) == "function") then
            key = this.id() .. evt
            callFunc = opt[1]
        elseif (type(opt[1]) == "string" and type(opt[2]) == "function") then
            key = this.id() .. opt[1]
            callFunc = opt[2]
        end
        if (key ~= nil) then
            local eKey = "ioue#" .. key
            if (callFunc == nil) then
                event.unregister(this, EVENT.Item.Get, eKey)
                event.unregister(this, EVENT.Item.Lose, eKey)
            else
                ---@param getData noteOnItemGetData
                this.onEvent(EVENT.Item.Get, eKey, function(getData)
                    event.register(getData.triggerUnit, evt, eKey, function(callData)
                        callData.triggerItem = getData.triggerItem
                        callFunc(callData)
                    end)
                end)
                ---@param loseData noteOnItemLoseData
                this.onEvent(EVENT.Item.Lose, eKey, function(loseData)
                    event.register(loseData.triggerUnit, evt, eKey)
                end)
            end
        end
        return this
    end)

    .public("cls",
    function(this)
        -- 清除掉绑定的数据和对象
        ---@type Player
        local bindPlayer = this.prop("bindPlayer")
        if (isObject(bindPlayer, "Player")) then
            bindPlayer.warehouseSlot().remove(this.warehouseSlotIndex())
        end
        ---@type Unit
        local bindUnit = this.prop("bindUnit")
        if (isObject(bindUnit, "Unit")) then
            local slot = bindUnit.itemSlot()
            if (isObject(slot, "ItemSlot")) then
                slot.remove(this.itemSlotIndex())
            end
        end
        this.prop("itemSlotIndex", NIL)
    end)

    .public("handle",
    function(this)
        return this.__HANDLE__
    end)

    .public("ability",
    function(this, modify)
        if (isObject(modify, "AbilityTpl")) then
            this.prop("ability", Ability(modify))
            return this
        end
        return this.prop("ability")
    end)

    .public("itemSlotIndex",
    function(this, modify)
        return this.prop("itemSlotIndex", modify)
    end)

    .public("warehouseSlotIndex",
    function(this, modify)
        return this.prop("warehouseSlotIndex", modify)
    end)

    .public("hotkey",
    function(this)
        return this.prop("hotkey")
    end)

    .public("bindPlayer",
    function(this, modify)
        return this.prop("bindPlayer", modify)
    end)

    .public("bindUnit",
    function(this, modify)
        if (isObject(modify, "Unit")) then
            this.prop("bindUnit", modify)
            if (this.ability() ~= nil) then
                this.ability().bindUnit(modify)
            end
            return this
        end
        return this.prop("bindUnit")
    end)

    .public("x",
    function(this)
        if (this.instance() == false) then
            return 0
        end
        return this.prop("x")
    end)

    .public("y",
    function(this)
        if (this.instance() == false) then
            return 0
        end
        return this.prop("y")
    end)

    .public("z",
    function(this)
        if (this.instance() == false) then
            return 0
        end
        return japi.Z(this.x(), this.y())
    end)

    .public("position",
    function(this, x, y)
        if (type(x) == "number" and type(y) == "number") then
            if (false == this.instance()) then
                this.instance(true)
            end
            x, y = Game().findPosition(x, y, this.id())
            this.prop("x", x)
            this.prop("y", y)
            J.SetUnitPosition(this.handle(), x, y)
        end
        return this
    end)

    .public("periodRemain",
    function(this)
        ---@type Timer
        local periodTimer = this.prop("periodTimer")
        if (isObject(periodTimer, "Timer")) then
            return periodTimer.remain()
        end
        return -1
    end)

    .public("exp",
    function(this, modify)
        return this.prop("exp", modify)
    end)

    .public("expNeed",
    function(this, whichLevel)
        whichLevel = whichLevel or (1 + this.level())
        whichLevel = math.max(1, whichLevel)
        whichLevel = math.min(Game().itemLevelMax(), whichLevel)
        return Game().itemExpNeeds(math.floor(whichLevel))
    end)

    .public("recoveryPrice",
    function(this)
        ---@type Player
        local bp = this.bindPlayer()
        if (isObject(bp, "Player") == false) then
            local bu = this.bindUnit()
            if (isObject(bu, "Unit")) then
                bp = bu.owner()
            else
                return nil, nil
            end
        end
        return Game().worthCale(this.worth(), "*", 0.01 * bp.sell()), bp
    end)

    .public("sellingPrice",
    function(this)
        ---@type Player
        local bs = this.bindStore()
        return Game().worthCale(this.worth(), "*", 1), bs
    end)

    .public("drop",
    function(this, x, y)
        local u = this.bindUnit()
        if (isObject(u, "Unit") == false) then
            local bp = this.bindPlayer()
            if (isObject(bp, "Player")) then
                u = bp.selection()
                if (false == table.equal(u.owner(), bp)) then
                    return
                end
            else
                return
            end
        end
        x = x or u.x()
        y = y or u.y()
        u.distanceAction({ x, y }, 200, function()
            event.trigger(u, EVENT.Item.Drop, { triggerItem = this, triggerUnit = u })
            event.trigger(this, EVENT.Item.Drop, { triggerItem = this, triggerUnit = u })
            audio(Vcm("war3_dropItem"), u.owner())
            time.setTimeout(0.15, function()
                this.position(x, y)
            end)
        end)
    end)

    .public("deliver",
    function(this, targetUnit)
        local u = this.bindUnit()
        if (isObject(u, "Unit") == false) then
            local bp = this.bindPlayer()
            if (isObject(bp, "Player")) then
                u = bp.selection()
                if (false == table.equal(u.owner(), bp)) then
                    return
                end
            else
                return
            end
        end
        if (isObject(targetUnit, "Unit") and targetUnit.isAlive()) then
            local slot = targetUnit.itemSlot()
            if (slot) then
                local x = targetUnit.x()
                local y = targetUnit.y()
                u.distanceAction({ x, y }, 200, function()
                    audio(Vcm("war3_dropItem"), u.owner())
                    time.setTimeout(0.15, function()
                        if (false == this.isDestroy()) then
                            slot.push(this)
                            event.trigger(u, EVENT.Item.Deliver, { triggerItem = this, triggerUnit = u, targetUnit = targetUnit })
                            event.trigger(this, EVENT.Item.Deliver, { triggerItem = this, triggerUnit = u, targetUnit = targetUnit })
                        end
                    end)
                end)
            end
        end
    end)

    .public("pawn",
    function(this)
        local rp, bp = this.recoveryPrice()
        if (isObject(bp, "Player")) then
            rp = Game().worthRound(rp)
            bp.worth("+", rp)
            event.trigger(this, EVENT.Item.Pawn, { triggerItem = this, triggerUnit = this.bindUnit() })
            event.trigger(this.bindUnit(), EVENT.Item.Pawn, { triggerItem = this, triggerUnit = this.bindUnit() })
        end
        this.destroy()
    end)

    .public("effective",
    function(this, evtData)
        ---@type Ability
        local ba = this.ability()
        if (isObject(ba, "Ability")) then
            ba.effective(evtData)
        end
    end)