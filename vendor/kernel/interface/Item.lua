---@type Item
local _

--- handle
---@return number|nil
function _.handle() end

--- 绑定技能
--- 可以设置TPL或技能，使用TPL时会自动新建为具体技能对象
---@param modify Ability|AbilityTpl|nil
---@return Item|Ability|AbilityTpl
function _.ability(modify) end

--- 当前物品栏位置
---@param modify number|nil
---@return self|number|nil
function _.itemSlotIndex(modify) end

--- 当前仓库栏位置
---@param modify number|nil
---@return self|number|nil
function _.warehouseSlotIndex(modify) end

--- 当前热键字符串
---@return string|nil
function _.hotkey() end

--- 当前物品在某玩家仓库
---@param modify Player|nil
---@return self|Player
function _.bindPlayer(modify) end

--- 当前物品被某单位持有
---@param modify Unit|nil
---@return self|Unit
function _.bindUnit(modify) end

--- X坐标
---@return number
function _.x() end

--- Y坐标
---@return number
function _.y() end

--- Z坐标
---@return number
function _.z() end

--- 联合位移物品到X,Y坐标
--- 如果物品在单位身上，会自动失去
---@param x number
---@param y number
---@return self
function _.position(x, y) end

--- 剩余存在周期
---@return number
function _.periodRemain() end

--- 物品当前经验
---@param modify number|nil
---@return self|number
function _.exp(modify) end

--- 获取物品升级到某等级需要的总经验
--- 根据Game的itemExpNeeds
---@param whichLevel number
---@return number
function _.expNeed(whichLevel) end

--- 回收价
--- 与Player数据有关连
---@return table,Player
function _.recoveryPrice() end

--- 出售价
--- 与Store数据有关连
---@return table,Store
function _.sellingPrice() end

--- 丢弃物品
---@param x number
---@param y number
---@return void
function _.drop(x, y) end

--- 传递物品
---@param targetUnit Unit 目标单位
---@return void
function _.deliver(targetUnit) end

--- 抵押物品
---@return void
function _.pawn() end

--- 物品使用起效
---@param evtData noteAbilitySpellEvt
---@return void
function _.effective(evtData) end
