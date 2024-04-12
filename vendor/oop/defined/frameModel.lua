---@param this FrameModel
Class("FrameModel")
    .inherit("FrameCustom")
    .construct(
    function(_, options)
        options.fdfName = "SINGLUAR_MODEL"
        options.fdfType = "SPRITE"
    end)