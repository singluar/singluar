---@type Dialog
local _

--- handle
---@return number
function _.handle() end

--- 标题
---@param modify string|nil
---@return self|string
function _.title(modify) end

--- 展示，可指定给某玩家
---@param Who Player|nil
---@return self
function _.show(Who) end