---@class
dialog = dialog or {}

dialog.evtClick = J.Condition(function()
    local triggerDialog = h2d(J.GetClickedDialog())
    local buttons = triggerDialog.prop("buttons")
    local evtData = buttons.get(tostring(J.GetClickedButton()))
    local action = triggerDialog.prop("action")
    if (evtData and type(action) == "function") then
        evtData.triggerDialog = triggerDialog
        evtData.triggerPlayer = Player(1 + J.GetPlayerId(J.GetTriggerPlayer()))
        action(evtData)
    end
end)

function dialog.hotkey(key)
    if (type(key) == "number") then
        return key
    elseif (type(key) == "string") then
        return string.byte(key, 1)
    end
    return 0
end