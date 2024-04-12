---@private
---@class Timer:Object
---@param isInterval boolean
---@param period number float
---@param callFunc fun(curTimer:Timer):Timer
---@return Timer
function Timer(isInterval, period, callFunc)
    if (type(isInterval) ~= "boolean" or type(period) ~= "number" or type(callFunc) ~= "function") then
        return
    end
    return Object("Timer", {
        isInterval = isInterval,
        period = period,
        callFunc = callFunc,
    })
end
