---@param this Weather
Class("Weather")

    .public("handle",
    function(this)
        return this.prop("handle")
    end)

    .public("bindRect",
    function(this)
        return this.prop("bindRect")
    end)

    .public("weatherType",
    function(this)
        return this.prop("weatherType")
    end)

    .public("enable",
    function(this, modify)
        return this.prop("enable", modify)
    end)

    .public("period",
    function(this, modify)
        return this.prop("period", modify)
    end)