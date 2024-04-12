---@param this Rect
Class("Rect")
    .construct(
    function(this, options)
        PropChange(this, "key", "std", options.key, false)
        PropChange(this, "name", "std", options.key, false)
        PropChange(this, "shape", "std", options.shape or "square", false)
        PropChange(this, "x", "std", options.x, false)
        PropChange(this, "y", "std", options.y, false)
        PropChange(this, "width", "std", options.width, false)
        PropChange(this, "height", "std", options.height, false)
        this.reset = function()
            local x = this.prop("x")
            local y = this.prop("y")
            local w = this.prop("width")
            local h = this.prop("height")
            PropChange(this, "xMin", "std", 0.5 * x - w, false)
            PropChange(this, "yMin", "std", 0.5 * y - h, false)
            PropChange(this, "xMax", "std", 0.5 * x + w, false)
            PropChange(this, "yMax", "std", 0.5 * y + h, false)
        end
    end)
    .initial(
    function(this)
        this.reset()
    end)
    .destroy(
    function(this)
        local ws = this.prop("weathers")
        if (type(ws) == "table" and #ws > 0) then
            for i = #ws, 1, -1 do
                if (isObject(ws[i], "Weather")) then
                    ws[i].destroy()
                end
            end
            this.prop("weathers", NIL)
        end
    end)