---@param this FrameBackdropTile
---@param resultStr string
Class("FrameBackdropTile")
    .exec("texture",
    function(this, resultStr)
        japi.DzFrameSetTexture(this.__FRAME_ID__, resultStr, 1)
    end)
