---@class time
time = time or {}
time.triggerTimeOfDay = {
    { evt = EVENT.Game.Dawn, time = 0, status = false },
    { evt = EVENT.Game.Day, time = 6, status = false },
    { evt = EVENT.Game.Noon, time = 12, status = false },
    { evt = EVENT.Game.Night, time = 18, status = false },
}
time.inc = time.inc or 0 --- 获取开始游戏后经过的总累计数
time.hour = time.hour or 0 --- 时
time.min = time.min or 0 --- 分
time.sec = time.sec or 0 --- 秒
time.msec = time.msec or 0 --- 毫秒
time.lastTimeOfDay = time.lastTimeOfDay or 0
---@type Array[]
time.kernel = time.kernel or {} --- 内核
for i = 0, BJ_MAX_PLAYERS, 1 do
    time.kernel[i] = {}
end

---@param t Timer
---@param remain number sec
---@private
function time.penetrate(t, remain)
    remain = remain or t.period()
    local i = math.ceil(time.inc + math.max(1, remain * 100))
    local asyncId
    if (t.prop("asyncId") ~= nil) then
        asyncId = t.prop("asyncId")
    else
        asyncId = async.index
        t.prop("asyncId", asyncId)
    end
    local kl = time.kernel[asyncId]
    if (kl[i] == nil) then
        kl[i] = Array()
    end
    t.prop("link", i)
    kl[i].set(t.id(), t)
end

--- 系统时钟
---@private
function time.clock()
    time.inc = time.inc + 1
    -- timer
    time.msec = time.msec + 10
    if (time.msec >= 1000) then
        time.msec = 0
        time.sec = time.sec + 1
        if (time.sec >= 60) then
            time.sec = 0
            time.min = time.min + 1
            if (time.min >= 60) then
                time.min = 0
                time.hour = time.hour + 1
            end
        end
        local timeOfDay = J.GetFloatGameState(GAME_STATE_TIME_OF_DAY)
        if (time.lastTimeOfDay > timeOfDay) then
            time.lastTimeOfDay = 0
            for _, t in ipairs(time.triggerTimeOfDay) do
                t.status = false
            end
        else
            for _, t in ipairs(time.triggerTimeOfDay) do
                if (t.status == false and timeOfDay >= t.time) then
                    t.status = true
                    event.trigger(Game(), t.evt, nil)
                end
            end
            time.lastTimeOfDay = timeOfDay
        end
    end
    -- trigger
    local inc = math.floor(time.inc)
    for i = 0, BJ_MAX_PLAYERS, 1 do
        local kl = time.kernel[i]
        if (kl[inc] ~= nil) then
            local kdo = function()
                ---@param t Timer
                kl[inc].forEach(function(_, t)
                    if (t.isDestroy() == false) then
                        promise(t.prop("callFunc"),
                            function()
                                t.destroy()
                            end,
                            function()
                                if (t.prop("isInterval") == true) then
                                    if (t.prop("link") ~= nil) then
                                        time.penetrate(t)
                                    end
                                else
                                    t.destroy()
                                end
                            end
                        , t)
                    end
                end)
                kl[inc] = nil
            end
            if (i == 0) then
                kdo()
            else
                async.call(Player(i), kdo)
            end
        end
    end
end

--- 从内核中获取一个Timer对象
---@param isInterval boolean
---@param period number sec
---@param callFunc function
---@private
function time.periodic(isInterval, period, callFunc)
    local t = Timer(isInterval, period, callFunc)
    if (t ~= nil) then
        time.penetrate(t)
    end
    return t
end

--- 魔兽小时[0.00-24.00]
function time.timeOfDay(modify)
    if (type(modify) == "number") then
        J.SetFloatGameState(GAME_STATE_TIME_OF_DAY, modify)
    end
    return J.GetFloatGameState(GAME_STATE_TIME_OF_DAY)
end

--- 魔兽小时流逝速度[默认1.00]
function time.timeOfDayScale(modify)
    if (type(modify) == "number") then
        J.SetTimeOfDayScale(modify)
    end
    return J.GetTimeOfDayScale()
end

--- 是否夜晚
---@return boolean
function time.isNight()
    return (time.timeOfDay() <= 6.00 or time.timeOfDay() >= 18.00)
end

--- 是否白天
---@return boolean
function time.isDay()
    return (time.timeOfDay() > 6.00 and time.timeOfDay() < 18.00)
end

-- 设置一次性计时器
---@param period number
---@param callFunc fun(curTimer:Timer):void
---@return Timer
function time.setTimeout(period, callFunc)
    return time.periodic(false, period, callFunc)
end

--- 设置周期性计时器
---@param period number
---@param callFunc fun(curTimer:Timer):void
---@return Timer
function time.setInterval(period, callFunc)
    return time.periodic(true, period, callFunc)
end

--- 获取过去的时分秒
---@return string HH:ii:ss
function time.gone()
    local str = ""
    if (time.hour < 10) then
        str = str .. "0" .. time.hour
    else
        str = str .. time.hour
    end
    str = str .. ":"
    if (time.min < 10) then
        str = str .. "0" .. time.min
    else
        str = str .. time.min
    end
    str = str .. ":"
    if (time.sec < 10) then
        str = str .. "0" .. time.sec
    else
        str = str .. time.sec
    end
    return str
end

--- 获取服务器当前时间戳
--- * 此方法在本地不能准确获取当前时间
---@return number
function time.unix()
    return (japi.DzAPI_Map_GetGameStartTime() or 0) + time.sec
end

--- 获取服务器当前时间对象
--- * 此方法在本地不能准确获取当前时间，将从UNIX元秒开始(1970年)
---@param timestamp number
---@return table {Y:"年",m:"月",d:"日",H:"时",i:"分",s:"秒",w:"周[0-6]",W:"周[日-六]"}
function time.date(timestamp)
    timestamp = timestamp or time.unix()
    return math.date(timestamp)
end