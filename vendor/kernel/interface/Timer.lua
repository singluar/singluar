---@type Timer
local _

--- 剩余时间
---@param modify number|nil
---@return self|number
function _.remain(modify) end

--- 周期时间
---@param modify number|nil
---@return self|number
function _.period(modify) end

--- 已逝时间（周期时间-剩余时间）
---@param modify number|nil
---@return self|number
function _.elapsed(modify) end

--- 暂停计时器
---@return self
function _.pause() end

--- 恢复计时器
---@return self
function _.resume() end
