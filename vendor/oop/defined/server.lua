---@param this Server
Class("Server")
    .construct(
    function(this, options)
        PropChange(this, "bindPlayer", "std", options.bindPlayer, false)
        PropChange(this, "data", "std", {}, false)
    end)