---@param this FrameBackdropTile
Class("FrameBackdropTile")

    .public("texture",
    function(this, modify)
        if (modify) then
            modify = AUIKit(this.kit(), modify, "tga")
        end
        return this.prop("texture", modify)
    end)