---@param this FrameLabel
Class("FrameLabel")
    .inherit("FrameCustom")
    .construct(
    function(_, options)
        options.fdfName = "SINGLUAR_BACKDROP"
        options.fdfType = "BACKDROP"
    end)
    .initial(
    function(this)
        this.texture("Singluar\\ui\\nil.tga")
        local highLight = FrameHighLight(this.frameIndex() .. "->highlight", this)
            .relation(FRAME_ALIGN_CENTER, this, FRAME_ALIGN_CENTER, 0, 0)
            .show(false)
        this.prop("childHighLight", highLight)
        local icon = FrameBackdrop(this.frameIndex() .. '->icon', this)
        this.prop("childIcon", icon)
        local label = FrameText(this.frameIndex() .. '->text', this)
        this.prop("childLabel", label)
        this.autoSize(true)
        this.side(LAYOUT_ALIGN_LEFT)
        this.textAlign(TEXT_ALIGN_LEFT)
        this.fontSize(10)
    end)