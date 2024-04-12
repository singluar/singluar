---@param this Lightning
Class("Lightning")

    .public("lightningType",
    function(this, modify)
        return this.prop("lightningType", modify)
    end)

    .public("priority",
    function(this, modify)
        return this.prop("priority", modify)
    end)

    .public("scatter",
    function(this, modify)
        return this.prop("scatter", modify)
    end)

    .public("radius",
    function(this, modify)
        return this.prop("radius", modify)
    end)

    .public("focus",
    function(this, modify)
        return this.prop("focus", modify)
    end)
