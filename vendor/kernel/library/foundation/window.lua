---@class window
window = window or {}

-- 窗口改变大小
---@type Array
window._evt = window._evt or nil

--- 当游戏窗口大小异步改变
---@alias noteOnWindowResizeData fun(evtData:{triggerPlayer:Player):void
---@param key string
---@param callFunc noteOnWindowResizeData
---@return void
function window.onResize(key, callFunc)
    if (window._evt == nil) then
        if (callFunc == nil) then
            return
        end
        window._evt = Array()
        JassJapi["DzTriggerRegisterWindowResizeEventByCode"](nil, false, function()
            if (window._evt.count() > 0) then
                local triggerPlayer = Player(1 + J.GetPlayerId(japi.DzGetTriggerKeyPlayer()))
                async.call(triggerPlayer, function()
                    window._evt.forEach(function(_, v)
                        promise(v, nil, nil, { triggerPlayer = triggerPlayer })
                    end)
                end)
            end
        end)
    end
    key = key or "default"
    if (type(callFunc) == "function") then
        window._evt.set(key, callFunc)
    else
        window._evt.set(key, nil)
    end
end