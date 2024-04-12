---@type WarehouseSlot
local _

--- 仓库归属玩家
---@return Player
function _.bindPlayer() end

--- 存贮数据
---@param modify:Item[]|nil
---@return Item[]
function _.storage(modify) end

--- 空位数量
---@return number
function _.empty() end

--- 推进一个物品
---@param whichItem ItemTpl|Item
---@param index number|nil 对应的仓库栏位置[1-18]
---@return void
function _.push(whichItem, index) end

--- 删除一个物品
---@param index number|nil 对应的仓库栏位置[1-6]
---@return void
function _.remove(index) end

--- 丢弃一个物品到X,Y
---@param index number|nil 对应的仓库栏位置[1-6]
---@param x number
---@param y number
---@return void
function _.drop(index, x, y) end