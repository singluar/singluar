---@type Camera
local _

--- 是否在摇晃
---@return boolean
function _.isShaking() end

--- 是否在震动
---@return boolean
function _.isQuaking() end

--- 重置镜头
---@param duration number
---@return self
function _.reset(duration) end

--- 设置空格坐标
---@param x number
---@param y number
---@return self
function _.spacePosition(x, y) end

--- 移动到XY
---@param x number
---@param y number
---@param duration number
---@return self
function _.to(x, y, duration) end

--- 远景截断距离
---@param modify number|nil
---@return self|number
function _.farZ(modify) end

--- Z轴偏移（高度偏移）
---@param modify number|nil
---@return self|number
function _.zOffset(modify) end

--- 观察角度
--- 最小20,最大120
---@param modify number|nil
---@return self|number
function _.fov(modify) end

--- X轴翻转角度
---@param modify number|nil
---@return self|number
function _.xTra(modify) end

--- Y轴翻转角度
---@param modify number|nil
---@return self|number
function _.yTra(modify) end

--- Z轴翻转角度
---@param modify number|nil
---@return self|number
function _.zTra(modify) end

--- 镜头距离
---@param modify number|nil
---@return self|number
function _.distance(modify) end

--- 锁定镜头跟踪某单位
---@param whichUnit Unit
---@return self
function _.follow(whichUnit) end

--- 摇晃镜头
---@param magnitude number 幅度
---@param velocity number 速率
---@param duration number 持续时间
---@return self
function _.shake(magnitude, velocity, duration) end

--- 震动镜头
---@param magnitude number 幅度
---@param duration number 持续时间
---@return self
function _.quake(magnitude, duration) end