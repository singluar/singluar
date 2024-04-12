---@param this FrameCustom
---@param resultNum number
Class("FrameCustom")
    .exec("alpha",
    function(this, resultNum)
        japi.DzFrameSetAlpha(this.__FRAME_ID__, resultNum)
    end)