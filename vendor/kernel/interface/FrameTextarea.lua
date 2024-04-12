---@type FrameTextarea
local _

--- 文本排列
---@param modify number|nil TEXT_ALIGN?
---@return self|string
function _.textAlign(modify) end

--- 文本颜色
---@param modify number|nil
---@return self|number
function _.textColor(modify) end

--- 文本尺寸限制
---@param modify number|nil
---@return self|number
function _.textSizeLimit(modify) end

--- 文本字号[6-16]
---@param modify number|nil
---@return self|number
function _.fontSize(modify) end

--- 文本内容
---@param modify string|nil
---@return self|string
function _.text(modify) end