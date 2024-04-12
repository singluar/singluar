---@param this Unit
---@param result number
Class("Unit")
    .limiter("attackPoint",
    function(_, result)
        result = math.max(0, result)
        result = math.min(1.5, result)
        return result
    end)
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
    .limiter("flyHeight",
    function(_, result)
        result = math.floor(result)
        result = math.min(1500, math.max(0, result))
        return result
    end)
    .limiter("exp",
    function(this, result)
        if ((this.prop("level") or 0) < 1) then
            return 0
        else
            result = math.max(0, result)
            result = math.min(Game().unitExpNeeds(Game().unitLevelMax()), result)
            return result
        end
    end)
    .limiter("levelMax",
    function(_, result)
        return math.min(Game().unitLevelMax(), result)
    end)
    .limiter("level",
    function(this, result)
        return math.min(this.prop("levelMax"), result)
    end)
    .limiter("hp",
    function(_, result)
        return math.max(1, result)
    end)
    .limiter("hpCur",
    function(this, result)
        if (this.prop("hp") ~= nil) then
            result = math.min(this.prop("hp"), result)
        end
        result = math.max(0, result)
        return result
    end)
    .limiter("mp",
    function(_, result)
        return math.max(0, result)
    end)
    .limiter("mpCur",
    function(this, result)
        if (this.prop("mp") ~= nil) then
            result = math.min(this.prop("mp"), result)
        end
        result = math.max(0, result)
        return result
    end)
    .limiter("punishCur",
    function(this, result)
        if (this.prop("punish") ~= nil) then
            result = math.min(this.prop("punish"), result)
        end
        result = math.floor(result)
        result = math.max(0, result)
        return result
    end)
    .limiter("weightCur",
    function(this, result)
        if (this.prop("weight") ~= nil) then
            result = math.min(this.prop("weight"), result)
        end
        result = math.max(0, result)
        return result
    end)