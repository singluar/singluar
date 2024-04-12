---@param this Lightning
Class("Lightning")
    .construct(
    function(this, options)
        PropChange(this, "lightningType", "std", options.lightningType, false)
        PropChange(this, "priority", "std", 0, false)
        PropChange(this, "scatter", "std", 0, false)
        PropChange(this, "radius", "std", 0, false)
        PropChange(this, "focus", "std", 0, false)
    end)
