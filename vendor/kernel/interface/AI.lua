---@type AI
local _

--- 本对象事件注册
---@param evt string 事件类型字符
---@vararg string|fun(callData:table)
---@return self
function _.onEvent(evt, ...) end

--- key
---@return string
function _.key() end

--- 执行周期，默认10
--- 不会影响已经关连的单位，如需要修改单位的执行周期，需要先断重连
--- 小于0.5或不合法数据将使AI关连
---@param modify number|nil
---@return self|number|10
function _.period(modify) end

--- 执行回调
---@alias noteAICall fun(linkUnit:Unit):void
---@param modify nil|noteAICall
---@return self|noteAICall
function _.action(modify) end

--- 关连单位
--- 单位被关连后等于启用了此AI
---@param whichUnit Unit
---@return void
function _.link(whichUnit) end

--- 断连单位
--- 单位被断连后等于关闭了此AI
---@param whichUnit Unit
---@return void
function _.unlink(whichUnit) end