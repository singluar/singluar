---@param this FrameCustom
Class("FrameCustom")

    .public("fdfName",
    function(this)
        return this.prop("fdfName")
    end)

    .public("alpha",
    function(this, modify)
        return this.prop("alpha", modify)
    end)

    .public("showGradient",
    function(this, modify, options)
        local duration = options.duration or 0.1
        if (duration == nil or duration < 0.1) then
            return this.show(modify)
        end
        local x = options.x or 0
        local y = options.y or 0
        local al = this.alpha()
        local rel = this.relation()
        local ai = al * 0.1
        local ac
        local ox = x or 0
        local oy = y or 0
        if (type(rel) ~= "table") then
            ox = 0
            oy = 0
        end
        -- show
        if (modify ~= true) then
            ac = al
            ai = -ai
        else
            ac = 0
            japi.DzFrameSetAlpha(this.handle(), 0)
            this.show(modify)
        end
        -- xy
        if (ox ~= 0 or oy ~= 0) then
            japi.DzFrameClearAllPoints(this.handle())
            japi.DzFrameSetPoint(this.handle(), rel[1], rel[2].handle(), rel[3], rel[4] + ox * 10, rel[5] + oy * 10)
        end
        local i = 10
        time.setInterval(duration * 0.1, function(curTimer)
            i = i - 1
            if (i <= 0) then
                curTimer.destroy()
                if (modify ~= true) then
                    this.show(false)
                end
                japi.DzFrameSetAlpha(this.handle(), al)
                return
            end
            ac = ac + ai
            japi.DzFrameSetAlpha(this.handle(), ac)
            if (ox ~= 0 or oy ~= 0) then
                japi.DzFrameClearAllPoints(this.handle())
                japi.DzFrameSetPoint(this.handle(), rel[1], rel[2].handle(), rel[3], rel[4] + ox * i, rel[5] + oy * i)
            end
        end)
        return this
    end)