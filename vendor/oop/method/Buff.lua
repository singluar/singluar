---@param this Buff
Class("Buff")

    .public("duration",
    function(this)
        return this.prop("duration")
    end)

    .public("remain",
    function(this, variety)
        ---@type Timer
        local affectTimer = this.prop("affectTimer")
        if (false == isObject(affectTimer, "Timer")) then
            return 0
        end
        return affectTimer.remain(variety)
    end)

    .public("obj",
    function(this)
        return this.prop("obj")
    end)

    .public("key",
    function(this)
        return this.prop("key")
    end)

    .public("name",
    function(this, modify)
        return this.prop("name", modify)
    end)

    .public("visible",
    function(this, modify)
        return this.prop("visible", modify)
    end)

    .public("icon",
    function(this, modify)
        if (type(modify) == "string") then
            return this.prop("icon", AIcon(modify))
        end
        return this.prop("icon")
    end)

    .public("description",
    function(this, modify)
        local mType = type(modify)
        if (mType == "string" or mType == "table" or mType == "function") then
            return this.prop("description", modify)
        end
        local d = this.prop("description")
        if (d == nil) then
            return
        end
        local desc = {}
        if (type(d) == "string") then
            desc[#desc + 1] = d
        elseif (type(d) == "table") then
            for _, v in ipairs(d) do
                desc[#desc + 1] = tostring(v)
            end
        elseif (type(d) == "function") then
            desc = table.merge(desc, d(this))
        end
        return desc
    end)

    .public("diff",
    function(this)
        return this.prop("diff")
    end)

    .public("purpose",
    function(this)
        if (this.prop("affecting") == false) then
            if (this.obj().isDestroy() == false) then
                this.prop("affecting", true)
                if (type(this.prop("purpose")) == "function") then
                    this.prop("purpose")(this.obj())
                end
                this.obj().__BUFF__.set(this.id(), this)
                local dur = this.prop("duration")
                if (dur > 0) then
                    this.prop("affectTimer", time.setTimeout(dur, function(_)
                        this.rollback()
                    end))
                end
            else
                this.destroy()
            end
        end
        return this
    end)

    .public("rollback",
    function(this)
        if (this.prop("affecting") == true) then
            if (this.obj().isDestroy() == false) then
                if (type(this.prop("rollback")) == "function") then
                    this.prop("rollback")(this.obj())
                end
                this.obj().__BUFF__.set(this.id(), nil)
            end
            if (isObject(this.prop("affectTimer"), "Timer")) then
                this.prop("affectTimer").destroy()
                this.prop("affectTimer", NIL)
            end
            this.prop("affecting", false)
        end
        this.destroy()
    end)