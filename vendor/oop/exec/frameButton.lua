---@param this FrameButton
---@param resultStr string
Class("FrameButton")
    .exec("texture",
    function(this, resultStr)
        japi.DzFrameSetTexture(this.__FRAME_ID__, resultStr, 0)
    end)
