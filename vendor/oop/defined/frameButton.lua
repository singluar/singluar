---@param this FrameButton
Class("FrameButton")
    .inherit("FrameCustom")
    .construct(
    function(_, options)
        options.fdfName = "FRAMEWORK_BACKDROP"
        options.fdfType = "BACKDROP"
    end)
    .initial(
    function(this)
        this.texture("Singluar\\ui\\nil.tga")

        local chl = FrameHighLight(this.frameIndex() .. "->ChildHL", this)
            .relation(FRAME_ALIGN_CENTER, this, FRAME_ALIGN_CENTER, 0, 0)
            .show(false)
        this.prop("childHighLight", chl)

        local border = FrameBackdrop(this.frameIndex() .. '->childBorder', this)
            .relation(FRAME_ALIGN_CENTER, this, FRAME_ALIGN_CENTER, 0, 0)
        this.prop("childBorder", border)

        local mark = FrameBackdrop(this.frameIndex() .. '->childMask', this)
            .relation(FRAME_ALIGN_BOTTOM, this, FRAME_ALIGN_BOTTOM, 0, 0)
            .show(false)
        this.prop("childMask", mark)

        local txt = FrameText(this.frameIndex() .. "->childText", this)
        txt.relation(FRAME_ALIGN_CENTER, this, FRAME_ALIGN_CENTER, 0, 0)
           .textAlign(TEXT_ALIGN_CENTER)
           .fontSize(8)
        this.prop("childText", txt)

        local hk = FrameText(this.frameIndex() .. "->childHotkey", this)
        hk.relation(FRAME_ALIGN_BOTTOM, this, FRAME_ALIGN_BOTTOM, 0, -0.01)
          .textAlign(TEXT_ALIGN_CENTER)
          .fontSize(10)
        this.prop("childHotkey", hk)

    end)