---@type Buff
local _

--- 持续时间
---@return number
function _.duration() end

--- 剩余时间
---@param variety number|string|nil
---@return self|number
---@return number
function _.remain(variety) end

--- 对应对象
---@return Object
function _.obj() end

--- key
---@return string
function _.key() end

--- 名称，默认nil
---@param modify nil|string
---@return self|string|nil
function _.name(modify) end

--- 可视判断
--- 可根据此值决定UI显隐等，默认true
---@param modify nil|boolean
---@return self|boolean
function _.visible(modify) end

--- 状态图标，默认nil
---@param modify nil|string
---@return self|string
function _.icon(modify) end

--- 状态描述体，默认nil
---@param modify nil|string[]|string|fun(obj:Buff):string[]
---@return self|string[]
function _.description(modify) end

--- 差异值
---@return number
function _.diff() end

--- 预期执行
---@return void
function _.purpose() end

--- 执行回滚
---@return void
function _.rollback() end