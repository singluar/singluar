---@param this Vcm
Class("Vcm")

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

    .public("play",
    function(this)
        J.StartSound(this.handle())
    end)