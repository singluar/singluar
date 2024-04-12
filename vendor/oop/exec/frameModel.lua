---@param this FrameModel
---@param resultStr string
Class("FrameModel")
    .exec("model",
    function(this, resultStr)
        japi.DzFrameSetModel(this.__FRAME_ID__, resultStr, 0, 0)
    end)
    .exec("animate",
    function(this, result)
        japi.DzFrameSetAnimate(this.__FRAME_ID__, table.unpack(result))
    end)