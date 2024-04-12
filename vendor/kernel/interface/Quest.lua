---@type Quest
local _

--- handle
---@return number
function _.handle() end

--- 标题
---@param modify string|nil
---@return self|string
function _.title(modify) end

--- 图标
---@param modify string|nil
---@return self|string
function _.icon(modify) end

--- 位置
---@param modify nil|string|"'left'"|"'right'"
---@return self|string
function _.side(modify) end

--- 内容
---@param modify string|string[]
---@return self|string
function _.content(modify) end

--- 完成状态
---@param modify boolean|nil
---@return self|boolean
function _.complete(modify) end

--- 失败状态
---@param modify boolean|nil
---@return self|boolean
function _.fail(modify) end

--- 发现状态
---@param modify boolean|nil
---@return self|boolean
function _.discover(modify) end

--- 令任务按钮闪烁
---@return void
function _.flash() end