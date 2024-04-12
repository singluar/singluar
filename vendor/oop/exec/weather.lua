---@param this Weather
---@param resultBool boolean
---@param resultNumber number
Class("Weather")
    .exec("enable",
    function(this, resultBool)
        J.EnableWeatherEffect(this.prop("handle"), resultBool)
    end)
    .exec("period",
    function(this, resultNumber)
        local t = this.prop("periodTimer")
        if (isObject(t, "Timer")) then
            t.destroy()
            this.prop("periodTimer", NIL)
            t = nil
        end
        if (resultNumber > 0) then
            t = time.setTimeout(resultNumber, function()
                this.prop("periodTimer", NIL)
                this.destroy()
            end)
            this.prop("periodTimer", t)
        end
    end)