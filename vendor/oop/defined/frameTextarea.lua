---@param this FrameTextarea
Class("FrameTextarea")
    .inherit("FrameCustom")
    .construct(
    function(_, options)
        options.fdfName = "SINGLUAR_TEXTAREA"
        options.fdfType = "TEXTAREA"
    end)
    .initial(
    function(this)
        this.textAlign(TEXT_ALIGN_CENTER)
        this.fontSize(10)
    end)