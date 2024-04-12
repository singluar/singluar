---@param this FrameAnimate
Class("FrameAnimate")

    .public("motion",
    function(this, modify)
        return this.prop("motion", modify)
    end)

    .public("duration",
    function(this, modify)
        if (type(modify) == "number" and modify > 0) then
            this.prop("duration", modify)
            ---@type Timer
            local stepTimer = this.prop("stepTimer")
            if (isObject(stepTimer, "Timer")) then
                if (stepTimer.prop("isInterval") == true) then
                    stepTimer.period(modify / #this.motion() - stepTimer.period())
                end
            end
            return this
        end
        return this.prop("duration")
    end)

    .public("halt",
    function(this, modify)
        return this.prop("halt", modify)
    end)

    .public("isPlaying",
    function(this)
        return isObject(this.prop("stepTimer"), "Timer")
    end)

    .public("play",
    function(this, isInterval, isReset)
        local stepTimer = this.prop("stepTimer")
        if (isObject(stepTimer, "Timer")) then
            stepTimer.destroy()
            stepTimer = nil
        end
        if (isReset == true) then
            this.prop("step", 0)
        end
        local m = this.motion()
        must(type(m) == "table" and #m > 0)
        local frequency = this.duration() / #m
        stepTimer = time.setInterval(frequency, function(curTimer)
            local motion = this.motion()
            if (motion == nil) then
                curTimer.destroy()
                return
            end
            local step = this.prop("step")
            step = step + 1
            if (motion[step] == nil) then
                if (isInterval ~= true or motion[1] == nil) then
                    curTimer.destroy()
                    this.prop("stepTimer", NIL)
                    this.prop("step", 0)
                    return
                end
                local halt = this.halt()
                if (halt > 0) then
                    curTimer.destroy()
                    this.prop("step", 0)
                    this.prop("stepTimer", time.setTimeout(halt, function()
                        this.prop("stepTimer", NIL)
                        this.play(isInterval, isReset)
                    end))
                    return
                end
                step = 1
            end
            this.prop("step", step)
            this.prop("stepTimer", stepTimer)
            this.texture(motion[step])
        end)
    end)

    .public("stop",
    function(this)
        local stepTimer = this.prop("stepTimer")
        if (isObject(stepTimer, "Timer")) then
            stepTimer.destroy()
            this.prop("stepTimer", NIL)
        end
    end)
