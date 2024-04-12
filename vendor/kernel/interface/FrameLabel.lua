---@type FrameLabel
local _

--- 自动尺寸
---@param modify boolean
---@return self|boolean
---@return FrameButton
function _.autoSize() end

--- 子高亮对象
---@return FrameButton
function _.childHighLight() end

--- 子图标对象
---@protected
---@return FrameButton
function _.childIcon() end

--- 子文本对象
---@protected
---@return FrameText
function _.childLabel() end

--- 侧偏，有左和右两种，默认左[LAYOUT_ALIGN_LEFT]
---@param modify number|nil LAYOUT_ALIGN_LEFT | LAYOUT_ALIGN_RIGHT
---@return self|number
function _.side(modify) end

--- 背景贴图
---@param modify string|nil
---@return self|string
function _.texture(modify) end

--- 图标贴图
---@param modify string|nil
---@return self|string
function _.icon(modify) end

--- 文本排列
---@param modify number|nil
---@return self|number
function _.textAlign(modify) end

--- 文本字号[6-16]
---@param modify number|nil
---@return self|number
function _.fontSize(modify) end

--- 文本内容
---@param modify string|nil
---@return self|string
function _.text(modify) end