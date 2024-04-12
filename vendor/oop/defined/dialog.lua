---@param this Dialog
Class("Dialog")
    .construct(
    function(this, options)
        href(this, J.DialogCreate())
        --
        local buttons = Array()
        for i = 1, #options.options do
            local label, value, hotkey
            if (type(options.options[i]) == "table") then
                label = options.options[i].label
                value = options.options[i].value
                hotkey = options.options[i].hotkey or options.options[i].value
            else
                label = options.options[i]
                value = options.options[i]
                hotkey = options.options[i]
            end
            local hk = dialog.hotkey(hotkey)
            local b = J.DialogAddButton(this.__HANDLE__, label, hk)
            J.handleRef(b)
            buttons.set(tostring(b), { label = label, value = value })
        end
        PropChange(this, "action", "std", options.action, false)
        PropChange(this, "buttons", "std", buttons, false)
        PropChange(this, "title", "std", options.title or "标题", false)
        event.pool(dialog.evtClick, function(tgr)
            J.TriggerRegisterDialogEvent(tgr, this.__HANDLE__)
        end)
    end)