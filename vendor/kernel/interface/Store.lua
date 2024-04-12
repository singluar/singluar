---@type Store
local _

--- 店铺名称
---@param modify string|nil
---@return self|string
function _.name(modify) end

--- 店铺图标
---@param modify string|nil
---@return self|string
function _.icon(modify) end

--- 限制玩家可买（只控制索引）
---@param modify:number[]|nil
---@return self|number[]
function _.salesPlayers(modify) end

--- 在售商品数组
---@return Array
function _.salesGoods() end

--- 遍历在售商品
---@alias nodeSalesGoods {goods:ItemTpl|AbilityTpl|UnitTpl,worth:table,stock:number,period:number,delay:number,periodTimer:Timer|nil}
---@param actionFunc fun(enumGoods:nodeSalesGoods)
---@return void
function _.forEach(actionFunc) end

--- 添加（覆盖）售卖的商品，data填什么数据都行，常见填入TPL
---@param goods ItemTpl|AbilityTpl|UnitTpl
---@param worth {gold:?}
---@param stock number 最大库存数量
---@param period number 补货周期，默认0，0表示不会缺货也不会自动补货，大于0则按周期补货，小于0不补货
---@param delay number 允许售卖延后时间，默认0
---@return void
function _.push(goods, worth, stock, period, delay) end

--- 删除某个售卖中的商品的数量，必须已set
---@param goods ItemTpl|AbilityTpl|UnitTpl
---@return void
function _.remove(goods) end

--- 设置当前售卖中的商品的数量，必须已set
---@param goods ItemTpl|AbilityTpl|UnitTpl
---@param variety string|number 奇妙数量
---@return void
function _.qty(goods, variety) end

--- 售卖商品行为
--- 当模拟虚假店铺售出时，应使用此方法作为依据处理
---@param goods ItemTpl|AbilityTpl|UnitTpl
---@param qty number 卖出数量，默认1
---@param buyUnit Unit 购买单位
---@return void
function _.sell(goods, qty, buyUnit) end