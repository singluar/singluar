---@param result number
Class("Vcm")
    .limiter("volume",
    function(_, result)
        result = math.max(0, result)
        result = math.min(127, result)
        return math.floor(result)
    end)