---@param this FrameText
Class("FrameText")
    .inherit("FrameCustom")
    .construct(
    function(_, options)
        options.fdfName = "SINGLUAR_TEXT"
        options.fdfType = "TEXT"
    end)
    .initial(
    function(this)
        this.textAlign(TEXT_ALIGN_CENTER)
        this.fontSize(10)
    end)