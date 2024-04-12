---@type Lightning
local _

--- 闪电类型
---@param modify table|nil LIGHTNING_TYPE
---@return self|LIGHTNING_TYPE
function _.lightningType(modify) end

--- 优先级(越大优先级越高)
---@param modify number|nil
---@return self|number
function _.priority(modify) end

-- 散射效果
---@param modify number|nil
---@return self|number
function _.scatter(modify) end

-- 散射范围
---@param modify number|nil
---@return self|number
function _.radius(modify) end

--- 聚焦效果
---@param modify number|nil
---@return self|number
function _.focus(modify) end
