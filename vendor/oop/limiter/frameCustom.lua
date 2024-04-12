---@param this FrameCustom
---@param result number
Class("FrameCustom")
    .limiter("alpha",
    function(_, result)
        result = math.max(0, result)
        result = math.min(255, result)
        return result
    end)