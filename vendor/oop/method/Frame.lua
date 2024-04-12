Class("Frame")

    .public("handle",
    function(this)
        return this.__FRAME_ID__
    end)

    .public("frameIndex",
    function(this)
        return this.prop("frameIndex")
    end)

    .public("kit",
    function(this)
        return this.prop("kit")
    end)

    .public("adaptive",
    function(this, modify)
        if (type(modify) == "boolean") then
            this.prop("adaptive", modify)
            local cs = this.children()
            if (#cs > 0) then
                for _, c in ipairs(cs) do
                    local adap = c.adaptive()
                    c.adaptive(modify)
                    if (adap ~= modify) then
                        local rel = c.relation()
                        if (type(rel) == "table") then
                            c.relation(table.unpack(rel))
                        end
                        local s = c.size()
                        if (type(s) == "table") then
                            c.size(table.unpack(s))
                        end
                    end
                end
            end
            return this
        end
        return this.prop("adaptive")
    end)

    .public("anchor",
    function(this)
        return this.prop("anchor")
    end)

    .public("parent",
    function(this, modify)
        if (view.isGameUI(this)) then
            -- 游戏UI禁止
            return
        end
        local p = this.prop("parent")
        if (modify ~= nil and modify ~= p) then
            local c = p.prop("children")
            table.delete(c, this)
            c = modify.prop("children")
            if (false == table.includes(c, this)) then
                table.insert(c, this)
                this.prop("adaptive", modify.adaptive())
            end
            this.prop("parent", modify)
            --japi.DzFrameSetParent(this.handle(), modify.handle())
            return this
        end
        return p
    end)

    .public("children",
    function(this)
        return this.prop("children")
    end)

    .public("upperNode",
    function(this)
        local r = this.prop("relation")
        if (type(r) == "table") then
            return r[2]
        end
    end)

    .public("lowerNodes",
    function(this)
        return this.prop("lowerNodes")
    end)

    .public("size",
    function(this, w, h)
        if (w ~= nil and h ~= nil) then
            if (view.isGameUI(this)) then
                -- 游戏UI禁止
                return this
            end
            local aw = w
            if (true == this.adaptive()) then
                aw = japi.FrameAdaptive(w)
            end
            local _, updated = PROP(this, "size", { aw, h })
            if (updated == true) then
                this.prop("unAdaptiveSize", { w, h })
                view.setAnchor(this)
            end
            return this
        end
        return this.prop("size")
    end)

    .public("relation",
    function(this, point, relativeFrame, relativePoint, x, y)
        if (point ~= nil and relativeFrame ~= nil and relativePoint ~= nil and x ~= nil and y ~= nil) then
            if (view.isGameUI(this)) then
                -- 游戏UI禁止
                return this
            end
            local ax = x
            if (true == this.adaptive()) then
                ax = japi.FrameAdaptive(x)
            end
            local upper = this.upperNode()
            local _, updated = PROP(this, "relation", { point, relativeFrame, relativePoint, ax, y })
            if (updated == true) then
                if (upper ~= relativeFrame) then
                    if (instanceof(upper, "Frame") and view.isGameUI(upper) == false) then
                        local lns = upper.lowerNodes()
                        if (isArray(lns)) then
                            lns.set(this.id(), nil)
                        end
                    end
                    if (view.isGameUI(relativeFrame) == false) then
                        local lns = relativeFrame.lowerNodes()
                        if (lns == nil) then
                            lns = Array()
                            relativeFrame.prop("lowerNodes", lns)
                        end
                        if (false == lns.keyExists(this.id())) then
                            lns.set(this.id(), this)
                        end
                    end
                end
                this.prop("unAdaptiveRelation", { point, relativeFrame, relativePoint, x, y })
                view.setAnchor(this)
            end
            return this
        end
        return this.prop("relation")
    end)

    .public("absolut",
    function(this, point, x, y)
        return this.relation(point, FrameGameUI, point, x, y)
    end)

    .public("show",
    function(this, modify, delay)
        if (view.isGameUI(this)) then
            -- 游戏UI禁止
            return this
        end
        if (type(modify) == "boolean") then
            local showDelay = this.prop("showDelay")
            if (isObject(showDelay, "Timer")) then
                showDelay.destroy()
                showDelay = nil
            end
            delay = delay or 0
            local act = function()
                local _, updated = PROP(this, "show", modify)
                if (updated) then
                    view.triggerFrameEvent(this)
                end
            end
            if (delay >= 0.1) then
                this.prop("showDelay", time.setTimeout(delay, function()
                    this.prop("showDelay", NIL)
                    act()
                end))
            else
                act()
            end
            return this
        end
        local o = this
        local s = o.prop("show") or false
        while (s == true) do
            local p = o.parent()
            if (p == nil or p == FrameGameUI) then
                break
            end
            o = p
            s = o.prop("show")
            if (s == false) then
                break
            end
        end
        return s
    end)

    .public("onMouseLeftClick",
    function(this, ...)
        local key, func = datum.keyFunc(...)
        ---@type Array
        local list = this.prop("evtList")
        if (list.onMouseLeftClick == nil) then
            list.onMouseLeftClick = Array()
        end
        list.onMouseLeftClick.set(key, func)
        view.triggerFrameEvent(this, "onMouseLeftClick")
        return this
    end)

    .public("onMouseRightClick",
    function(this, ...)
        local key, func = datum.keyFunc(...)
        ---@type Array
        local list = this.prop("evtList")
        if (list.onMouseRightClick == nil) then
            list.onMouseRightClick = Array()
        end
        list.onMouseRightClick.set(key, func)
        view.triggerFrameEvent(this, "onMouseRightClick")
        return this
    end)

    .public("onMouseMove",
    function(this, ...)
        local key, func = datum.keyFunc(...)
        ---@type Array
        local list = this.prop("evtList")
        if (list.onMouseMove == nil) then
            list.onMouseMove = Array()
        end
        list.onMouseMove.set(key, func)
        view.triggerFrameEvent(this, "onMouseMove")
        return this
    end)

    .public("onMouseEnter",
    function(this, ...)
        local key, func = datum.keyFunc(...)
        ---@type Array
        local list = this.prop("evtList")
        if (list.onMouseEnter == nil) then
            list.onMouseEnter = Array()
        end
        list.onMouseEnter.set(key, func)
        view.triggerFrameEvent(this, "onMouseEnter")
        return this
    end)

    .public("onMouseLeave",
    function(this, ...)
        local key, func = datum.keyFunc(...)
        ---@type Array
        local list = this.prop("evtList")
        if (list.onMouseLeave == nil) then
            list.onMouseLeave = Array()
        end
        list.onMouseLeave.set(key, func)
        view.triggerFrameEvent(this, "onMouseLeave")
        return this
    end)