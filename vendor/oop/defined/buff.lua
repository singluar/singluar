---@param this Buff
Class("Buff")
    .construct(
    function(this, options)
        PropChange(this, "key", "std", options.key, false)
        PropChange(this, "duration", "std", options.duration, false)
        PropChange(this, "remain", "std", options.duration, false)
        PropChange(this, "obj", "std", options.obj, false)
        PropChange(this, "diff", "std", options.diff, false)
        PropChange(this, "purpose", "std", options.purpose, false)
        PropChange(this, "rollback", "std", options.rollback, false)
        PropChange(this, "affecting", "std", false, false)
        PropChange(this, "visible", "std", true, false)
        if (this.prop("obj").__BUFF__ == nil) then
            this.prop("obj").__BUFF__ = Array()
        end
    end)
    .destroy(
    function(this)
        if (this.prop("affecting") == true) then
            this.rollback()
        end
    end)