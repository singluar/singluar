---@param this FrameTextarea
---@param result number
Class("FrameTextarea")
    .limiter("textColor",
    function(_, result)
        result = math.max(0, result)
        result = math.min(255, result)
        return result
    end)
    .limiter("fontSize",
    function(_, result)
        result = math.max(6, result)
        result = math.min(16, result)
        return result
    end)