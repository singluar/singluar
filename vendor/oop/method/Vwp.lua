---@param this Vwp
Class("Vwp")

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

    .public("play",
    function(this)
        local targetUnit = this.prop("targetUnit")
        if (isObject(targetUnit, "Unit")) then
            J.AttachSoundToUnit(this.handle(), targetUnit.handle())
            J.StartSound(this.handle())
        end
    end)