---@param this Item
---@param result number
Class("Item")
    .limiter("levelMax",
    function(_, result)
        return math.min(Game().itemLevelMax(), result)
    end)
    .limiter("level",
    function(this, result)
        return math.min(this.prop("levelMax"), result)
    end)
    .limiter("charges",
    function(_, result)
        return math.max(0, result)
    end)