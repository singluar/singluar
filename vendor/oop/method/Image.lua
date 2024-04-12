---@param this Image
Class("Image")

    .public("handle",
    function(this)
        return this.prop("handle")
    end)

    .public("texture",
    function(this, modify)
        return this.prop("texture", modify)
    end)

    .public("size",
    function(this, width, height)
        if (type(width) == "number" and type(height) == "number") then
            local modify = { width, height }
            return this.prop("size", modify)
        end
        return this.prop("size")
    end)

    .public("show",
    function(this, modify)
        return this.prop("show", modify)
    end)

    .public("rgba",
    function(this, red, green, blue, alpha)
        if (type(red) == "number" and type(green) == "number" and type(blue) == "number" and type(alpha) == "number") then
            return this.prop("rgba", { red, green, blue, alpha })
        end
        return this.prop("rgba")
    end)

    .public("position",
    function(this, x, y)
        if (type(x) == "number" or type(y) == "number") then
            this.prop("position", { x, y })
        end
        return this
    end)

