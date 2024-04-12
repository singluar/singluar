---@param this V3d
---@param resultNum number
---@param resultTable table
Class("V3d")
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
    .exec("distanceCutoff",
    function(this, resultNum)
        J.SetSoundDistanceCutoff(this.__HANDLE__, resultNum)
    end)
    .exec("distances",
    function(this, result)
        if (#result == 2) then
            J.SetSoundDistances(this.__HANDLE__, result[1], result[2])
        end
    end)