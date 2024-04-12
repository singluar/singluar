---@param this FrameBackdrop
Class("FrameBackdrop")
    .inherit("FrameCustom")
    .construct(
    function(_, options)
        options.fdfName = "SINGLUAR_BACKDROP"
        options.fdfType = "BACKDROP"
    end)
    .initial(
    function(this)
        this.texture("Singluar\\ui\\nil.tga")
    end)