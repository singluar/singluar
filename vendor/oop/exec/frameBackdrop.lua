---@param this FrameBackdrop
---@param resultStr string
Class("FrameBackdrop")
    .exec("texture",
    function(this, resultStr)
        japi.DzFrameSetTexture(this.__FRAME_ID__, resultStr, 0)
    end)
