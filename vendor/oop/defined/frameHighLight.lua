---@param this FrameHighLight
Class("FrameHighLight")
    .inherit("FrameCustom")
    .construct(
    function(_, options)
        options.fdfName = "SINGLUAR_HIGHLIGHT"
        options.fdfType = "HIGHLIGHT"
    end)