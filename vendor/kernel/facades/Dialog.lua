--[[
    对话框
    options = {
        "第1个",
        "第2个",
        "第3个",
    }
    或
    options = {
        { value = "Q", label = "第1个" },
        { value = "W", label = "第2个" },
        { value = "D", label = "第3个" },
        { value = 3, label = "第3个", hotkey = "D" },
    }
]]

---@class Dialog:Object
---@param title string
---@alias noteDialogAction fun(evtData:{triggerPlayer:Player,triggerDialog:Dialog,label:"标签",value:"值"}):void
---@param options table
---@param action noteDialogAction | "function(evtData) end"
---@return Dialog
function Dialog(title, options, action)
    if (#options <= 0) then
        error("optionsIsEmpty")
        return
    end
    if (type(action) ~= "function") then
        error("actionIsEmpty")
        return
    end
    return Object("Dialog", {
        static = { "Dialog", title },
        title = title,
        options = options,
        action = action,
    })
end
