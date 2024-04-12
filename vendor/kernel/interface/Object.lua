---@type Object
local _

--- 对象ID
---@return string|nil
function _.id() end

--- 对象是否已删除
---@return boolean
function _.isDestroy() end

--- 删除对象（如果允许）
---@param delay number
---@return void
function _.destroy(delay) end

--- 对象内部参
---@param key string
---@param modify any
---@return self|any|nil
function _.prop(key, modify) end

--- 对象内部参 增幅，作用于[修改过程]的[改变]数值的增减
---@param key string
---@param modify number
---@return self|number|nil
function _.raise(key, modify) end

--- 对象内部参 突变，作用于[获取时]的[终结]数值的突破增减
---@param key string
---@param modify number
---@return self|number|nil
function _.mutation(key, modify) end

--- 对象内部参 叠加态，用于[判断时]叠加[结果]数值间的判断关系
---@param key string
---@param modify number
---@return self|number|nil
function _.superposition(key, modify) end

