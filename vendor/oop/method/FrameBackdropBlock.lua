---@param this FrameBackdropBlock
Class("FrameBackdropBlock")

    .public("size",
    function(this, w, h)
        if (w ~= nil and h ~= nil) then
            CLink(this, "Frame", "size", w, h)
            this.prop("childBlock").size(w, h)
            return this
        end
        return CLink(this, "Frame", "size")
    end)

    .public("texture",
    function(this, modify)
        if (modify) then
            modify = AUIKit(this.kit(), modify, "tga")
        end
        return this.prop("texture", modify)
    end)

