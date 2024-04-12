---@param this Missile
Class("Missile")

    .public("modelAlias",
    function(this, modify)
        return this.prop("modelAlias", modify)
    end)

    .public("priority",
    function(this, modify)
        return this.prop("priority", modify)
    end)

    .public("scale",
    function(this, modify)
        return this.prop("scale", modify)
    end)

    .public("speed",
    function(this, modify)
        return this.prop("speed", modify)
    end)

    .public("height",
    function(this, modify)
        return this.prop("height", modify)
    end)

    .public("acceleration",
    function(this, modify)
        return this.prop("acceleration", modify)
    end)

    .public("shake",
    function(this, modify)
        return this.prop("shake", modify)
    end)

    .public("shakeOffset",
    function(this, modify)
        return this.prop("shakeOffset", modify)
    end)

    .public("homing",
    function(this, modify)
        return this.prop("homing", modify)
    end)

    .public("gatlin",
    function(this, modify)
        return this.prop("gatlin", modify)
    end)

    .public("scatter",
    function(this, modify)
        return this.prop("scatter", modify)
    end)

    .public("radius",
    function(this, modify)
        return this.prop("radius", modify)
    end)

    .public("reflex",
    function(this, modify)
        return this.prop("reflex", modify)
    end)
