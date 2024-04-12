---@param this Bgm
---@param result number
Class("Bgm")
    .limiter("volume",
    function(_, result)
        result = math.max(0, result)
        result = math.min(100, result)
        return result
    end)