---@param this FrameBackdropBlock
Class("FrameBackdropBlock")
    .inherit("FrameCustom")
    .construct(
    function(_, options)
        options.fdfName = "SINGLUAR_BACKDROP"
        options.fdfType = "BACKDROP"
    end)
    .initial(
    function(this)
        this.texture("Singluar\\ui\\nil.tga")
        local childBlock = FrameText(this.frameIndex() .. "->childBlock", this)
            .relation(FRAME_ALIGN_CENTER, this, FRAME_ALIGN_CENTER, 0, 0)
            .show(true)
        this.prop("childBlock", childBlock)
    end)