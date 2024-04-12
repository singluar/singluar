---@param this AbilitySlot
---@param result number
Class("AbilitySlot")
    .limiter("abilityPoint",
    function(_, result)
        return math.floor(result)
    end)