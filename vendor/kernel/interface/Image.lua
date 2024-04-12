---@type Image
local _

--- handle
---@return number|nil
function _.handle() end

--- 贴图路径
---@param modify string|nil
---@return self|string
---@return number|nil
function _.texture(modify) end

--- 大小
---@param width number|nil
---@param height number|nil
---@return self|number[]
function _.size(width, height) end

--- 显示
---@param modify boolean|nil
---@return self|boolean
function _.show(modify) end

--- rgba颜色
---@param red number|nil
---@param green number|nil
---@param blue number|nil
---@param alpha number|nil
---@return self|number[]
function _.rgba(red, green, blue, alpha) end

--- 移动到X,Y坐标
---@param x number|nil
---@param y number|nil
---@return self
function _.position(x, y) end
