---@param this FrameBackdropBlock
---@param resultStr string
Class("FrameBackdropBlock")
    .exec("texture",
    function(this, resultStr)
        japi.DzFrameSetTexture(this.__FRAME_ID__, resultStr, 0)
    end)
