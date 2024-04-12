---@param this V3d
Class("V3d")

    .public("handle",
    function(this)
        return this.__HANDLE__
    end)

    .public("duration",
    function(this)
        return this.prop("duration")
    end)

    .public("volume",
    function(this, modify)
        return this.prop("volume", modify)
    end)

    .public("channel",
    function(this, modify)
        return this.prop("channel", modify)
    end)

    .public("pitch",
    function(this, modify)
        return this.prop("pitch", modify)
    end)

    .public("distanceCutoff",
    function(this, modify)
        return this.prop("distanceCutoff", modify)
    end)

    .public("distances",
    function(this, modify)
        return this.prop("distances", modify)
    end)

    .public("unit",
    function(this, whichUnit)
        J.AttachSoundToUnit(this.handle(), whichUnit.handle())
        return this
    end)

    .public("xyz",
    function(this, x, y, z)
        J.SetSoundPosition(this.handle(), x, y, z)
        return this
    end)

    .public("rect",
    function(this, whichRegent, dur)
        dur = dur or 0
        local width = whichRegent.width()
        local height = whichRegent.height()
        J.SetSoundPosition(this.handle(), whichRegent.x(), whichRegent.y(), 0)
        J.RegisterStackedSound(this.handle(), true, width, height)
        if (dur > 0) then
            time.setTimeout(dur, function(curTimer)
                curTimer.destroy()
                J.UnregisterStackedSound(this.handle(), true, width, height)
            end)
        end
        return this
    end)

    .public("play",
    function(this)
        J.StartSound(this.handle())
    end)