---@type FrameButton
local _

--- 子高亮对象
---@return FrameHighLight|nil
function _.childHighLight() end

--- 子边框对象
---@protected
---@return FrameBackdrop
function _.childBorder() end

--- 子遮罩对象
---@protected
---@return FrameBackdrop
function _.childMask() end

--- 子主要文本对象
---@protected
---@return FrameText
function _.childText() end

--- 子热键文本对象
---@protected
---@return FrameText
function _.childHotkey() end

--- 底贴图
---@param modify string|nil
---@return self|string
function _.texture(modify) end

--- 边框贴图
---@param modify string|nil
---@return self|string
function _.border(modify) end

--- 遮罩贴图
---@param modify string|nil
---@return self|string
function _.mask(modify) end

--- 遮罩值
---@param modify number|nil [0.00-1.00]
---@return self|number
function _.maskValue(modify) end

--- 中心文本内容
---@param modify string|nil
---@return self|string
function _.text(modify) end

--- 中央文本字号[6-16]
---@param modify number|nil
---@return self|number
function _.fontSize(modify) end

--- 热键文本
---@param modify string|nil
---@return self|string
function _.hotkey(modify) end

--- 热键字号
---@param modify number|nil
---@return self|number
function _.hotkeyFontSize(modify) end