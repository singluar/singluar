---@param this Dialog
---@param resultStr string
Class("Dialog")
    .exec("title",
    function(this, resultStr)
        J.DialogSetMessage(this.__HANDLE__, resultStr)
    end)