---@param this Camera
---@param result number
Class("Camera")
    .limiter("farZ",
    function(_, result)
        result = math.min(3000, result)
        result = math.max(100, result)
        return result
    end)
    .limiter("zOffset",
    function(_, result)
        result = math.min(3000, result)
        result = math.max(-1000, result)
        return result
    end)
    .limiter("fov",
    function(_, result)
        result = math.min(120, result)
        result = math.max(20, result)
        return result
    end)
    .limiter("xTra",
    function(_, result)
        result = math.min(350, result)
        result = math.max(270, result)
        return result
    end)
    .limiter("yTra",
    function(_, result)
        result = math.min(280, result)
        result = math.max(80, result)
        return result
    end)
    .limiter("zTra",
    function(_, result)
        result = math.min(280, result)
        result = math.max(80, result)
        return result
    end)
    .limiter("distance",
    function(_, result)
        result = math.min(3000, result)
        result = math.max(400, result)
        return result
    end)