---@param this AI
Class("AI")

    .public("onEvent",
    function(this, evt, ...)
        event.register(this, evt, ...)
        return this
    end)

    .public("key",
    function(this)
        return this.prop("key")
    end)

    .public("period",
    function(this, modify)
        return this.prop("period", modify)
    end)

    .public("action",
    function(this, modify)
        return this.prop("action", modify)
    end)

    .public("link",
    function(this, whichUnit)
        must(isObject(whichUnit, "Unit"))
        local tk = "aiTimer" .. this.id()
        local t = whichUnit.prop(tk)
        if (isObject(t, "Timer")) then
            return
        end
        local period = this.period()
        if (type(period) ~= "number" or period < 0.5) then
            return
        end
        t = time.setInterval(period, function(curTimer)
            if (whichUnit.isDestroy() or this.isDestroy()) then
                curTimer.destroy()
                return
            end
            if (whichUnit.isDead()) then
                return
            end
            local action = this.action()
            if (type(action) == "function") then
                action(whichUnit)
            end
        end)
        whichUnit.prop(tk, t)
        event.trigger(this, EVENT.AI.Link, { triggerAI = this, triggerUnit = whichUnit })
        event.trigger(whichUnit, EVENT.AI.Link, { triggerAI = this, triggerUnit = whichUnit })
        ---@param unlinkData noteOnAIUnlinkData
        whichUnit.onEvent(EVENT.AI.Unlink, tk, function(unlinkData)
            local u = unlinkData.triggerUnit
            u.onEvent(EVENT.AI.Unlink, tk, nil)
            local t = u.prop(tk)
            if (isObject(t, "Timer")) then
                t.destroy()
            end
            u.prop(tk, NIL)
        end)
        ---@param destroyData noteOnAIDestroyData
        this.onEvent(EVENT.AI.Destroy, tk, function(destroyData)
            if (isObject(whichUnit, "Unit")) then
                local ai = destroyData.triggerAI
                event.trigger(ai, EVENT.AI.Unlink, { triggerAI = ai, triggerUnit = whichUnit })
                event.trigger(whichUnit, EVENT.AI.Unlink, { triggerAI = ai, triggerUnit = whichUnit })
            end
        end)
    end)

    .public("unlink",
    function(this, whichUnit)
        must(isObject(whichUnit, "Unit"))
        event.trigger(this, EVENT.AI.Unlink, { triggerAI = this, triggerUnit = whichUnit })
        event.trigger(whichUnit, EVENT.AI.Unlink, { triggerAI = this, triggerUnit = whichUnit })
    end)

