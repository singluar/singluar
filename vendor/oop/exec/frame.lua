---@param this Frame
---@param resultBool boolean
---@param resultNum number[]
Class("Frame")
    .exec("size",
    function(this, resultNum)
        japi.DzFrameSetSize(this.__FRAME_ID__, resultNum[1], resultNum[2])
    end)
    .exec("relation",
    function(this, result)
        japi.DzFrameClearAllPoints(this.__FRAME_ID__)
        japi.DzFrameSetPoint(this.__FRAME_ID__, result[1], result[2].__FRAME_ID__, result[3], result[4], result[5])
    end)
    .exec("show",
    function(this, resultBool)
        japi.DzFrameShow(this.__FRAME_ID__, resultBool)
    end)