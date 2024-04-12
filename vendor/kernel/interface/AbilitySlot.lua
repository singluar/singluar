---@type AbilitySlot
local _

---@return Unit
function _.bindUnit() end

---@return Ability[]
function _.storage(modify) end

--- 空位数量
---@return number
function _.empty() end

--- 单位技能曾在的最后位置
---@return number
function _.tail() end

--- 推进一个技能
--- 热键强制与位置顺序【ABILITY_HOTKEY】绑定，如果没有配置位置,从集合中选出一个位置自动赋予
---@param whichAbility AbilityTpl|Ability
---@param index number|nil 配置顺序位置
---@return void
function _.push(whichAbility, index) end

--- 移除一个技能
---@param index number|nil 技能在技能栏中的索引
---@return void
function _.remove(index) end