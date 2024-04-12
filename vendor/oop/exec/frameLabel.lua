---@param this FrameLabel
---@param resultStr string
Class("FrameLabel")
    .exec("texture",
    function(this, resultStr)
        japi.DzFrameSetTexture(this.__FRAME_ID__, resultStr, 0)
    end)