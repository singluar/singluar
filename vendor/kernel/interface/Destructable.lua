---@type Destructable
local _

--- handle
---@return number
function _.handle() end

--- 获得X坐标
---@return number
function _.x() end

--- 获得Y坐标
---@return number
function _.y() end

--- 获得Z坐标
---@return number
function _.z() end

--- 移动到XYZ
---@param x number
---@param y number
---@param z number
---@return self|number
function _.position(x, y, z) end

--- model id
---@return string
function _.modelId() end

--- model alias
---@return string
function _.modelAlias() end

--- 面向角度
---@param modify number|nil
---@return self|number
function _.facing(modify) end

--- 缩放
---@param modify number|nil
---@return self|number
function _.scale(modify) end

--- 板式
---@param modify number|nil
---@return self|number
function _.variation(modify) end

--- 闭塞高度
---@param modify number|nil
---@return self|number
function _.occluderHeight(modify) end

--- 无敌
---@param modify boolean|nil
---@return self|boolean
function _.invulnerable(modify) end

--- 显示
---@return self
function _.show() end

--- 隐藏
---@return self
function _.hide() end

--- 生命值
---@param modify number|nil
---@return self|number
function _.hp(modify) end

--- 当前生命值
---@param modify number|nil
---@return self|number
function _.hpCur(modify) end

--- 杀死
---@return self
function _.kill() end

--- 复活
---@return self
function _.reborn() end