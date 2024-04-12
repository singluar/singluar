---@class mouse
mouse = mouse or {}

-- 鼠标事件
---@type table<string,Array>
mouse._evt = mouse._evt or {}

--- 设置鼠标坐标
---@param x number
---@param y number
---@return void
function mouse.position(x, y)
    japi.DzSetMousePos(x, y)
end

--- 当鼠标触发事件
---@protected
---@alias noteOnMouseGameData fun(evtData:{triggerPlayer:Player).void
---@param name string
---@param typ string
---@param btn number
---@param status number
---@param key string
---@param callFunc noteOnMouseGameData
---@return void
function mouse.evt(name, typ, btn, status, key, callFunc)
    if (mouse._evt[name] == nil) then
        if (callFunc == nil) then
            return
        end
        mouse._evt[name] = Array()
        local call = function()
            if (mouse._evt[name].count() > 0) then
                local data = { triggerPlayer = Player(1 + J.GetPlayerId(japi.DzGetTriggerKeyPlayer())) }
                if (typ == 2) then
                    data.delta = japi.DzGetWheelDelta()
                end
                async.call(data.triggerPlayer, function()
                    mouse._evt[name].backEach(function(k, v)
                        promise(v, nil, nil, data)
                    end)
                end)
            end
        end
        if (typ == 1) then
            JassJapi["DzTriggerRegisterMouseEventByCode"](nil, btn, status, false, call)
        elseif (typ == 2) then
            JassJapi["DzTriggerRegisterMouseWheelEventByCode"](nil, false, call)
        elseif (typ == 3) then
            JassJapi["DzTriggerRegisterMouseMoveEventByCode"](nil, false, call)
        end
    end
    key = key or "default"
    if (type(callFunc) == "function") then
        mouse._evt[name].set(key, callFunc)
    else
        mouse._evt[name].set(key, nil)
    end
end

--- 当鼠标左键点击
---@param key string
---@param callFunc noteOnMouseGameData
---@return void
function mouse.onLeftClick(key, callFunc)
    mouse.evt("onLeftClick", 1, GAME_KEY_MOUSE_LEFT, 1, key, callFunc)
end

--- 当鼠标左键释放
---@param key string
---@param callFunc noteOnMouseGameData
---@return void
function mouse.onLeftRelease(key, callFunc)
    mouse.evt("onLeftRelease", 1, GAME_KEY_MOUSE_LEFT, 0, key, callFunc)
end

--- 当鼠标右键点击
---@param key string
---@param callFunc noteOnMouseGameData
---@return void
function mouse.onRightClick(key, callFunc)
    mouse.evt("onRightClick", 1, GAME_KEY_MOUSE_RIGHT, 1, key, callFunc)
end

--- 当鼠标右键释放
---@param key string
---@param callFunc noteOnMouseGameData
---@return void
function mouse.onRightRelease(key, callFunc)
    mouse.evt("onRightRelease", 1, GAME_KEY_MOUSE_RIGHT, 0, key, callFunc)
end

--- 当鼠标滚轮
---@param key string
---@param callFunc noteOnMouseGameData|{delta:number}
---@return void
function mouse.onWheel(key, callFunc)
    mouse.evt("onWheel", 2, nil, nil, key, callFunc)
end

--- 当鼠标移动
---@param key string
---@param callFunc noteOnMouseGameData|{x:number,y:number}
---@return void
function mouse.onMove(key, callFunc)
    mouse.evt("onMove", 3, nil, nil, key, callFunc)
end