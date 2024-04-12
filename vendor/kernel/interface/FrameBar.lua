---@type FrameBar
local _

--- 子贴图对象
---@protected
---@param side string | "'value'" | "'mark'" 条性对应位置
---@return FrameBackdrop|FrameBackdropTile
function _.childTexture(side) end

--- 子文本对象
---@protected
---@param layout number LAYOUT_ALIGN_?
---@return FrameText
function _.childText(layout) end

--- 条数据值设置
---@param ratio number 0.00-1.00
---@param width number
---@param height number
---@return self|number
function _.value(ratio, width, height) end

--- 条状底图
---@param side string | "'value'" | "'mark'" 条性对应位置
---@param modify string|nil
---@return self|string
function _.texture(side, modify) end

--- 文本排列
---@param layout number LAYOUT_ALIGN_?
---@param modify string|nil
---@return self|number
function _.textAlign(layout, modify) end

--- 字号大小
---@param layout number LAYOUT_ALIGN_?
---@param modify number|nil
function _.fontSize(layout, modify) end

--- 文本内容
---@param layout number LAYOUT_ALIGN_?
---@param modify number|nil
---@return self|string
function _.text(layout, modify) end
