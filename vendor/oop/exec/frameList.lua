---@param this FrameList
---@param resultNum number
Class("FrameList")
    .exec("fontSize",
    function(this, resultNum)
        for _, t in ipairs(this.prop("childTexts")) do
            t.fontSize(resultNum)
        end
    end)