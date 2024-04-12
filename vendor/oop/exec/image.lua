---@param this Image
Class("Image")
    .exec("texture",
    function(this, result)
        local size = this.size()
        if (this.prop("texture") ~= result and type(size) == "table") then
            local h = this.prop("handle")
            J.ShowImage(h, false)
            J.DestroyImage(h)
            this.prop("handle", NIL)
            h = J.CreateImage(result, size[1], size[2], 0, -size[1] / 2, -size[2] / 2, 0, 0, 0, 0, 3)
            J.SetImageAboveWater(h, true, true)
            J.SetImageRenderAlways(h, true)
            this.prop("handle", h)
            PropChange(this, "texture", "std", result, false)
            PropReExec(this)
        end
    end)
    .exec("size",
    function(this, result)
        local texture = this.texture()
        if (this.prop("size") ~= result and texture ~= nil) then
            local h = this.prop("handle")
            J.ShowImage(h, false)
            J.DestroyImage(h)
            this.prop("handle", NIL)
            h = J.CreateImage(texture, result[1], result[2], 0, -result[1] / 2, -result[2] / 2, 0, 0, 0, 0, 3)
            J.SetImageAboveWater(h, true, true)
            J.SetImageRenderAlways(h, true)
            this.prop("handle", h)
            PropChange(this, "size", "std", result, false)
            PropReExec(this)
        end
    end)
    .exec("show",
    function(this, result)
        J.ShowImage(this.prop("handle"), result)
    end)
    .exec("rgba",
    function(this, result)
        J.SetImageColor(this.prop("handle"), table.unpack(result))
    end)
    .exec("position",
    function(this, result)
        local prev = this.prop("position")
        result[1] = result[1] or prev[1]
        result[2] = result[2] or prev[2]
        local size = this.size()
        J.SetImageConstantHeight(this.prop("handle"), false, 0)
        J.SetImagePosition(this.prop("handle"), result[1] - size[1] / 2, result[2] - size[2] / 2, 0)
    end)