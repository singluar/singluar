---@param this AI
Class("AI")
    .construct(
    function(this, options)
        PropChange(this, "key", "std", options.key, false)
        PropChange(this, "period", "std", 10, false)
    end)
    .destroy(
    function(this)
        event.trigger(this, EVENT.AI.Destroy, { triggerAI = this })
    end)