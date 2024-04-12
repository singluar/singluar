---@type Ability
local _

--- 当前技能栏位置
---@param modify number|nil
---@return self|number|nil
function _.abilitySlotIndex(modify) end

--- 当前热键字符串
---@return string|nil
function _.hotkey() end

--- 当前绑定单位
---@param modify Unit|nil
---@return self|Unit
function _.bindUnit(modify) end

--- 当前绑定物品
---@param modify Item|nil
---@type fun(modify:Item|nil):self|Item
function _.bindItem(modify) end

--- 冷却时间计时器对象
---@return Timer|nil
function _.coolDownTimer() end

--- 冷却时间剩余时间
---@return number
function _.coolDownRemain() end

--- 技能不能使用的原因
---@return string|nil
function _.prohibitReason() end

--- 禁用技能
---@type fun(reason:string)
---@return self
function _.ban(reason) end

--- 允许技能
---@type fun(reason:string)
---@return self
function _.allow(reason) end

--- 技能当前经验
---@param modify number|nil
---@return self|number
function _.exp(modify) end

--- 获取技能升级到某等级需要的总经验；根据Game的abilityExpNeeds
---@param whichLevel number
---@return number
function _.expNeed(whichLevel) end

--- 进入冷却
---@return void
function _.coolingEnter() end

--- 立即冷却
---@return void
function _.coolingInstant() end

--- 是否冷却中
---@return boolean
function _.isCooling() end

--- 技能是否处于禁用状态
---@return boolean
function _.isProhibiting() end

--- 是否施法目标允许
---@param targetObj nil|Unit
---@return boolean
function _.isCastTarget(targetObj) end

--- 技能起效
---@see targetUnit 对单位时存在
---@see targetX 对单位、点、范围时存在
---@see targetY 对单位、点、范围时存在
---@see targetZ 对单位、点、范围时存在
---@alias noteAbilitySpellEvt {targetUnit:Unit,targetX:number,targetY:number,targetZ:number}
---@param evtData noteAbilitySpellEvt
---@return void
function _.effective(evtData) end