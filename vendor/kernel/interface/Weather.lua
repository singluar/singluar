---@type Weather
local _

--- handle
---@return number
function _.handle() end

--- 天气所在区域
---@return Rect
function _.bindRect() end

--- 天气类型
---@return WEATHER_TYPE
function _.weatherType() end

--- 是否启用
---@param modify boolean
---@return self|boolean
function _.enable(modify) end

--- 存在周期
---@param modify number|nil
---@return self|number|-1
function _.period(modify) end