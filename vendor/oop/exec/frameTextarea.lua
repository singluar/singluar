---@param this FrameTextarea
---@param resultNum number
---@param resultStr string
Class("FrameTextarea")
    .exec("textAlign",
    function(this, resultNum)
        japi.DzFrameSetTextAlignment(this.__FRAME_ID__, resultNum)
    end)
    .exec("textColor",
    function(this, resultNum)
        japi.DzFrameSetTextColor(this.__FRAME_ID__, resultNum)
    end)
    .exec("textSizeLimit",
    function(this, resultNum)
        japi.DzFrameSetTextSizeLimit(this.__FRAME_ID__, resultNum)
    end)
    .exec("fontSize",
    function(this, resultNum)
        japi.DzFrameSetFont(this.__FRAME_ID__, 'fonts.ttf', resultNum * 0.001, 0)
    end)
    .exec("text",
    function(this, resultStr)
        japi.DzFrameSetText(this.__FRAME_ID__, resultStr)
    end)