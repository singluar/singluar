---@class keyboard
keyboard = keyboard or {}

-- 键盘事件
---@type table<string,Array>
keyboard._evt = keyboard._evt or {}

--- 按下键盘
---@param ketString string
---@return void
function keyboard.press(ketString)
    J.ForceUIKey(ketString)
end

--- 当键盘触发事件
---@protected
---@alias noteOnKeyboardData fun(evtData:{triggerPlayer:Player,triggerKey:number}):void
---@param name string
---@param keyboardCode number
---@param status number
---@param key string
---@param callFunc noteOnKeyboardData
---@return void
function keyboard.evt(name, keyboardCode, status, key, callFunc)
    if (keyboard._evt[name] == nil) then
        if (callFunc == nil) then
            return
        end
        keyboard._evt[name] = {}
    end
    if (keyboard._evt[name][keyboardCode] == nil) then
        keyboard._evt[name][keyboardCode] = Array()
        JassJapi["DzTriggerRegisterKeyEventByCode"](nil, keyboardCode, status, false, function()
            local triggerKey = japi.DzGetTriggerKey()
            if (triggerKey ~= KEYBOARD["Esc"] and triggerKey ~= KEYBOARD["Enter"] and japi.IsTyping()) then
                return
            end
            if (isArray(keyboard._evt[name][triggerKey]) and keyboard._evt[name][triggerKey].count() > 0) then
                local triggerPlayer = Player(1 + J.GetPlayerId(japi.DzGetTriggerKeyPlayer()))
                async.call(triggerPlayer, function()
                    keyboard._evt[name][triggerKey].forEach(function(_, v)
                        promise(v, nil, nil, { triggerPlayer = triggerPlayer, triggerKey = triggerKey })
                    end)
                end)
            end
        end)
    end
    key = key or "default"
    if (type(callFunc) == "function") then
        keyboard._evt[name][keyboardCode].set(key, callFunc)
    else
        keyboard._evt[name][keyboardCode].set(key, nil)
    end
end

--- 当键盘异步点击
---@param keyboardCode number
---@param key string
---@param callFunc noteOnKeyboardData
---@return void
function keyboard.onPress(keyboardCode, key, callFunc)
    keyboard.evt("onPress", keyboardCode, GAME_KEY_ACTION_PRESS, key, callFunc)
end

--- 当键盘异步释放
---@param key string
---@param callFunc noteOnKeyboardData
---@return void
function keyboard.onRelease(keyboardCode, key, callFunc)
    keyboard.evt("onRelease", keyboardCode, GAME_KEY_ACTION_RELEASE, key, callFunc)
end