---@param this Bgm
---@param resultNum string
---@param resultStr string
Class("Bgm")
    .exec("volume",
    function(_, resultNum)
        J.SetMusicVolume(math.floor(resultNum * 1.27))
    end)
    .exec("currentMusic",
    function(this, resultStr)
        J.StopMusic(true)
        if (resultStr ~= "") then
            local delay = 3.3
            ---@type Timer
            local delayTimer = this.prop("delayTimer")
            if (isObject(delayTimer, "Timer")) then
                delay = math.max(0, delayTimer.remain())
                delayTimer.destroy()
                this.prop("delayTimer", NIL)
                delayTimer = nil
            end
            this.prop("delayTimer", time.setTimeout(delay, function()
                this.prop("delayTimer", NIL)
                J.PlayMusic(resultStr)
            end))
        end
    end)