---@param this Weather
Class("Weather")
    .construct(
    function(this, options)
        PropChange(this, "handle", "std", J.AddWeatherEffect(options.bindRect.handle(), options.realType), false) -- 绑定区域
        PropChange(this, "bindRect", "std", options.bindRect, false) -- 绑定区域
        PropChange(this, "weatherType", "std", options.weatherType, false) -- 天气类型 WEATHER_TYPE
        PropChange(this, "enable", "std", false, false)
        PropChange(this, "period", "std", -1, false)
    end)
    .initial(
    function(this)
        J.EnableWeatherEffect(this.prop("handle"), false)
    end)
    .destroy(
    function(this)
        local t = this.prop("periodTimer")
        if (isObject(t, "Timer")) then
            t.destroy()
            this.prop("periodTimer", NIL)
            t = nil
        end
        local h = this.prop("handle")
        J.EnableWeatherEffect(h, false)
        J.RemoveWeatherEffect(h)
        this.prop("handle", NIL)
    end)