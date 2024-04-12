---@param this Vcm
---@param resultNum number
---@param resultTable table
Class("Vcm")
    .exec("volume",
    function(this, resultNum)
        J.SetSoundVolume(this.__HANDLE__, math.floor(resultNum * 1.27))
    end)
    .exec("channel",
    function(this, resultTable)
        J.SetSoundChannel(this.__HANDLE__, resultTable.value)
    end)
    .exec("pitch",
    function(this, resultNum)
        J.SetSoundPitch(this.__HANDLE__, resultNum)
    end)