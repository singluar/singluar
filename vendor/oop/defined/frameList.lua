---@param this FrameList
Class("FrameList")
    .inherit("FrameBackdrop")
    .construct(
    function(this, options)
        PropChange(this, "max", "std", options.max, false)
    end)
    .initial(
    function(this)
        this.texture("Singluar\\ui\\nil.tga")
        local texts = {}
        local buttons = {}
        for i = 1, this.max() do
            local txt = FrameText(this.frameIndex() .. '->txt->' .. i, this)
            table.insert(texts, txt)
            local btn = FrameButton(this.frameIndex() .. '->btn->' .. i, txt)
            btn.relation(FRAME_ALIGN_TOP, txt, FRAME_ALIGN_TOP, 0, 0)
            table.insert(buttons, btn)
        end
        this.prop("childTexts", texts)
        this.prop("childButtons", buttons)
    end)