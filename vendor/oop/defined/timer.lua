---@param this Timer
Class("Timer")
    .construct(
    function(this, options)
        PropChange(this, "isInterval", "std", options.isInterval, false)
        PropChange(this, "period", "std", options.period, false)
        PropChange(this, "callFunc", "std", options.callFunc, false)
        PropChange(this, "link", "std", 0, false)
    end)
    .destroy(
    function(this)
        local l = this.prop("link") or 0
        this.prop("link", NIL)
        if (l > time.inc) then
            local k = this.kernel()
            if (type(k) == "table" and isArray(k[l])) then
                k[l].set(this.id(), nil)
            end
        end
    end)