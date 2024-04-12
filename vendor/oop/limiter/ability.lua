---@param this Ability
---@param result number
Class("Ability")
    .limiter("exp",
    function(_, result)
        result = math.max(0, result)
        result = math.min(Game().abilityExpNeeds(Game().abilityLevelMax()), result)
        return result
    end)
    .limiter("levelMax",
    function(_, result)
        return math.min(Game().abilityLevelMax(), result)
    end)
    .limiter("level",
    function(this, result)
        return math.min(this.prop("levelMax"), result)
    end)