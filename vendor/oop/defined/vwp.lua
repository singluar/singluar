---@param this Vwp
Class("Vwp")
    .construct(
    function(this, options)
        href(this, J.CreateSound(AVwp(options.alias), false, true, true, 10, 10, "CombatSoundsEAX"))
        PropChange(this, "alias", "std", options.alias, false)
        PropChange(this, "duration", "std", options.duration / 1000, false)
        PropChange(this, "volume", "std", 100, false)
        PropChange(this, "pitch", "std", 1, false)
        PropChange(this, "distanceCutoff", "std", 2000, false)
        PropChange(this, "distances", "std", { 500, 2500 }, false)
    end)
    .initial(
    function(this)
        J.SetSoundDuration(this.__HANDLE__, this.prop("duration"))
    end)