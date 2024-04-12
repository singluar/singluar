---@param this Vcm
Class("Vcm")
    .construct(
    function(this, options)
        href(this, J.CreateSound(AVcm(options.alias), false, false, false, 10, 10, "DefaultEAXON"))
        PropChange(this, "alias", "std", options.alias, false)
        PropChange(this, "duration", "std", options.duration / 1000, false)
        PropChange(this, "volume", "std", 100, false)
        PropChange(this, "pitch", "std", 1, false)
    end)
    .initial(
    function(this)
        J.SetSoundDuration(this.__HANDLE__, this.prop("duration"))
    end)