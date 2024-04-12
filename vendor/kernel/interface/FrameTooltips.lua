---@type FrameTooltips
local _

--- kit
---@param modify string|nil
---@return self|string
function _.kit() end

--- 子文本对象
---@protected
---@return FrameText
function _.childText() end

--- 子图标对象
---@protected
---@return table<number,{bg:FrameBackdrop,txt:FrameText}>
function _.childIcons() end

--- 子条状物对象
---@protected
---@return table<number,{bg:FrameBackdrop,txt:FrameBar}>
function _.childBars() end

--- 子列表对象
---@protected
---@return FrameList
function _.childList() end

--- 文本排列
---@param align string
---@return self
function _.textAlign(align) end

--- 文本字号[6-16]
---@param fontSize number
---@return self
function _.fontSize(fontSize) end

---- 内容设置
--[[
    -- 数据格式
    data:{
        icons:{
            { texture, text },-- 图标带文本的东东格式
        }
        bars:{
            { texture, text, ratio, width, height }, -- 条状物格式
        }
        list:{
            { texture, text, textAlign, highlight, showGradient }, -- 菜单按钮格式
        }
        tips:{
            "string",
        }
    },
]]
---@alias noteFrameTooltipContentIcons { texture:string, text:string }
---@alias noteFrameTooltipContentBars { texture:string, text:string,ratio:number,width:number,height:number }
---@alias noteFrameTooltipContentList { texture:string, text:string,textAlign:number,highlight:boolean,showGradient:table }
---@param data {icons:noteFrameTooltipContentIcons[],bars:noteFrameTooltipContentBars[],list:noteFrameTooltipContentList[],tips:string|string[]}
---@return self
function _.content(data) end