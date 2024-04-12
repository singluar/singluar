---@type Server
local _

--- 缓存数据
---@private
---@return table
function _.data() end

--- 对应玩家
---@return Player
function _.bindPlayer() end

--- 获取服务器数据
---@param key string
---@param default any 默认值
---@return any
function _.load(key, default) end

--- 保存服务器数据
---@param key string
---@param value string|number|boolean
---@return void
function _.save(key, value) end

--- 清理服务器数据
---@param key string
---@return void
function _.clear(key) end

--- 设置房间服务器数据
---@param key string
---@param value string|number
---@return void
function _.room(key, value) end