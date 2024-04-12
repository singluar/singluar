---@type Team
local _

--- 名字同步
--- 设为true后，成员的名称会同步跟随队伍的名称（一般用于通用共同敌人）
---@param modify boolean|nil
---@return self|boolean
function _.nameSync(modify) end

--- 全员颜色同步
--- 设为true后，成员的颜色以及他单位的颜色都会同步跟随队伍的颜色（一般用于通用共同敌人）
---@param modify boolean|nil
---@return self|boolean
function _.colorSync(modify) end

--- 队伍名称
---@param modify string|nil PLAYER_COLOR_?
---@return self|string
function _.name(modify) end

--- 为队伍设置统一的颜色
--- 一般用于通用共同敌人
--- 使用玩家索引1-12决定颜色值
---@param modify number|nil
---@return self|number
function _.color(modify) end

--- 队伍成员玩家（只控制索引）
---@param modify number[]|nil
---@return self|number[]
function _.members(modify) end

--- 在队伍玩家内创建一个单位
--- 这个单位的拥有者会自动分配给队伍内的某个玩家
--- 一般用于通用共同敌人
---@param tpl UnitTpl
---@param x number,
---@param y number,
---@param facing number
---@return Unit
function _.unit(tpl, x, y, facing) end