---@type FrameList
local _

--- 自文本对象
---@protected
---@param index number
---@return FrameText|FrameText[]
function _.childTexts(index) end

--- 自按钮对象
---@protected
---@param index number
---@return FrameButton|FrameButton[]
function _.childButtons(index) end

--- 最大按钮数
---@return number
function _.max() end

--- 组合方向
---@param modify nil|string|"'vertical'"|"'horizontal'"
---@return self|string
function _.direction(modify) end

--- 文本字号[6-16]
---@param modify number|nil
---@return self|number
function _.fontSize(modify) end

--- 内容
---@alias noteFrameListContent table<number,{ texture:string,text:string,textAlign:number,highlight:boolean,showGradient:noteFrameShowGradient }>
---@param data noteFrameListContent[]
---@return self
function _.content(data) end