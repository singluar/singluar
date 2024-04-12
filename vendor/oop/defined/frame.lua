---@param this Frame
Class("Frame")
    .construct(
    function(this, options)
        this.__FRAME_ID__ = options.frameId
        PropChange(this, "frameIndex", "std", options.frameIndex, false)
        PropChange(this, "parent", "std", options.parent, false)
        PropChange(this, "children", "std", Array(), false)
        PropChange(this, "show", "std", true, false)
        local kits = string.explode("->", options.frameIndex)
        PropChange(this, "kit", "std", tostring(kits[1]), false)
        PropChange(this, "evtList", "std", {}, false)
    end)
    .initial(
    function(this)
        if (view.isGameUI(this)) then
            this.prop("adaptive", false)
            this.prop("size", { 0.8, 0.6 })
            this.prop("anchor", { 0.4, 0.3, 0.8, 0.6 })
        else
            if (view._adaptiveFrames == nil) then
                view._adaptiveFrames = Array()
                local setting = {}
                window.onResize("frame_adaptive", function(evtData)
                    local pIdx = evtData.triggerPlayer.index()
                    if (isObject(setting[pIdx], "Timer")) then
                        setting[pIdx].remain(setting[pIdx].period())
                        return
                    end
                    setting[pIdx] = time.setTimeout(0.1, function()
                        setting[pIdx] = nil
                        ---@param value Frame
                        view._adaptiveFrames.forEach(function(_, value)
                            if (instanceof(value, "Frame")) then
                                if (true == value.adaptive()) then
                                    local s = value.prop("unAdaptiveSize")
                                    local r = value.prop("unAdaptiveRelation")
                                    if (type(s) == "table") then
                                        value.size(table.unpack(s))
                                    end
                                    if (type(r) == "table") then
                                        value.relation(table.unpack(r))
                                    end
                                end
                            end
                        end)
                    end)
                end)
            end
            view._adaptiveFrames.set(this.id(), this)
        end
        local parent = this.prop("parent")
        if (parent ~= nil) then
            local child = parent.prop("children")
            if (false == child.keyExists(this.id())) then
                child.set(this.id(), this)
                this.prop("adaptive", parent.adaptive())
            end
        end
    end)
    .destroy(
    function(this)
        if (isArray(view._adaptiveFrames)) then
            view._adaptiveFrames.set(this.id(), nil)
        end
        view.clearFrameEvent(this)
        this.prop("lowerNodes", NIL)
        local child = this.children()
        if (isArray(child)) then
            child.forEach(function(_, c)
                child.set(c.id(), nil)
                destroy(c)
            end, true)
            this.prop("children", NIL)
        end
        local parent = this.parent()
        if (parent ~= nil) then
            local pChild = parent.children()
            if (isArray(pChild)) then
                pChild.set(this.id(), nil)
            end
            this.prop("parent", NIL)
        end
        japi.DzDestroyFrame(this.__FRAME_ID__)
    end)