---@param this FrameCustom
Class("FrameCustom")
    .inherit("Frame")
    .construct(
    function(this, options)
        local tag = japi.FrameTagIndex()
        options.parent = options.parent or FrameGameUI
        options.frameId = japi.DzCreateFrameByTagName(options.fdfType, tag, options.parent.__FRAME_ID__, options.fdfName, 0)
        PropChange(this, "tag", "std", options.tag, false)
        PropChange(this, "fdfName", "std", options.fdfName, false)
        PropChange(this, "fdfType", "std", options.fdfType, false)
        PropChange(this, "alpha", "std", 255, false)
    end)