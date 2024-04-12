---@param this Image
---@param result number
Class("Image")
    .limiter("rgba",
    function(_, result)
        for i = 1, 4 do
            if (type(result[i]) == "number") then
                result[i] = math.floor(result[i])
                result[i] = math.max(0, result[i])
                result[i] = math.min(255, result[i])
            end
        end
        return result
    end)