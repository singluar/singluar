---@param this Destructable
---@param result number
Class("Destructable")
    .limiter("hpCur",
    function(this, result)
        if (this.prop("hp") ~= nil) then
            result = math.min(this.prop("hp"), result)
        end
        result = math.max(0, result)
        return result
    end)