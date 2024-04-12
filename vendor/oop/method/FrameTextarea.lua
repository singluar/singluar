---@param this FrameTextarea
Class("FrameTextarea")

    .public("textAlign",
    function(this, modify)
        return this.prop("textAlign", modify)
    end)

    .public("textColor",
    function(this, modify)
        return this.prop("textColor", modify)
    end)

    .public("textSizeLimit",
    function(this, modify)
        return this.prop("textSizeLimit", modify)
    end)

    .public("fontSize",
    function(this, modify)
        return this.prop("fontSize", modify)
    end)

    .public("text",
    function(this, modify)
        return this.prop("text", modify)
    end)