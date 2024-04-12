---@param this Team
Class("Team")
    .construct(
    function(this, options)
        PropChange(this, "key", "std", options.key, false)
        PropChange(this, "name", "std", options.key, false)
        PropChange(this, "nameSync", "std", false, false)
        PropChange(this, "colorSync", "std", false, false)
        PropChange(this, "members", "std", {}, false)
        PropChange(this, "counter", "std", {}, false)
    end)