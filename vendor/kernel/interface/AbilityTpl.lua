---@type AbilityTpl
local _

--- 本对象事件注册
---@param evt string 事件类型字符
---@vararg string|fun(callData:table)
---@return self
function _.onEvent(evt, ...) end

--- 通用型单位事件注册
---@param evt string 事件类型字符
---@vararg string|fun(callData:table)
---@return self
function _.onUnitEvent(evt, ...) end

--- 智能属性数组配置
--- {method, baseValue, varyValue}
--- Unit方法名, 1级数值, 升级加成
--- varyValue不设置时，自动取baseValue做线性加成
--- 方法不存在 或 1级数值、升级加成同时为0 会被忽略
--- * 只适用于部分数值型方法
--[[
    attrs:{
        {"attack", 10, 10}, -- 每级+10点攻击
        {"attack", 10}, -- 每级+10点攻击，与上面一样
        {"defend", -1, -0.1}, -- 第1级-1护甲，2级-1.1护甲...
        {"attackSpeed", 10, 0}, -- 技能无论多少级都只加10攻速
        {"enchantWeapon", "water", 1, 0 }, -- 水附魔武器
    }
]]
---@param attrs table|nil
---@return self|table|nil
function _.attributes(attrs) end

--- 技能名
---@param modify string|nil
---@return self|string
function _.name(modify) end

--- 技能类型（目标类型）
---@param modify string|nil ABILITY_TARGET_TYPE
---@return self|string
function _.targetType(modify) end

--- 技能图标
---@param modify string|nil
---@return self|string
function _.icon(modify) end

--- 发动施法动作
---@param modify string|nil
---@return self|string
function _.castAnimation(modify) end

--- 持续施法动作
---@param modify string|nil
---@return self|string
function _.keepAnimation(modify) end

--- 施法目标允许(回调单位函数)
---@alias noteCastTargetAllowFunc fun(this:Ability,targetUnit:Unit):boolean
---@param modify noteCastTargetAllowFunc
---@return self|noteCastTargetAllowFunc|nil
function _.castTargetFilter(modify) end

--- [成长推导]血耗
---@param base number
---@param vary number
---@return self
function _.hpCostAdv(base, vary) end

--- [成长推导]蓝耗
---@param base number
---@param vary number
---@return self
function _.mpCostAdv(base, vary) end

--- [成长推导]财耗
---@param base table
---@param vary table
---@return self
function _.worthCostAdv(base, vary) end

--- [成长推导]冷却时间
---@param base number
---@param vary number
---@return self
function _.coolDownAdv(base, vary) end

--- [成长推导]吟唱等待（秒）
---@param base number
---@param vary number
---@return self
function _.castChantAdv(base, vary) end

--- [成长推导]施法持续（秒）
---@param base number
---@param vary number
---@return self
function _.castKeepAdv(base, vary) end

--- [成长推导]施法距离 [默认600]
---@param base number
---@param vary number
---@return self
function _.castDistanceAdv(base, vary) end

--- [成长推导]施法圆形半径 [默认300]
---@param base number
---@param vary number
---@return self
function _.castRadiusAdv(base, vary) end

--- [成长推导]施法方形宽度 [默认300]
---@param base number
---@param vary number
---@return self
function _.castWidthAdv(base, vary) end

--- [成长推导]施法方形高度 [默认300]
---@param base number
---@param vary number
---@return self
function _.castHeightAdv(base, vary) end

--- 描述体
---@alias noteTplDescriptionFunc fun(obj:Ability):string[]
---@param modify nil|string[]|string|noteTplDescriptionFunc
---@return self|string[]
function _.description(modify) end

--- 技能最大级
---@param modify number|nil
---@return self|number
function _.levelMax(modify) end

--- 技能当前等级
---@param modify number|nil
---@return self|number
function _.level(modify) end

--- 技能升级所需技能点,小于1则无法升级
---@param modify number|nil
---@return self|number
function _.levelUpNeedPoint(modify) end

--- [实际]血耗
---@param whichLevel number|nil
---@return number
function _.hpCost(whichLevel) end

--- [实际]蓝耗
---@param whichLevel number|nil
---@return number
function _.mpCost(whichLevel) end

--- [实际]财耗
---@param whichLevel number|nil
---@return table|nil
function _.worthCost(whichLevel) end

--- [实际]冷却时间
---@param whichLevel number|nil
---@return number
function _.coolDown(whichLevel) end

--- [实际]吟唱等待（秒）
---@param whichLevel number|nil
---@return number
function _.castChant(whichLevel) end

--- [实际]施法持续（秒）
---@param whichLevel number|nil
---@return number
function _.castKeep(whichLevel) end

--- [实际]施法距离
---@param whichLevel number|nil
---@return number
function _.castDistance(whichLevel) end

--- [实际]施法圆形半径
---@param whichLevel number|nil
---@return number
function _.castRadius(whichLevel) end

--- [实际]施法方形宽度
---@param whichLevel number|nil
---@return number
function _.castWidth(whichLevel) end

--- [实际]施法方形高度
---@param whichLevel number|nil
---@return number
function _.castHeight(whichLevel) end

--- 禁用指针条件 [圆/方范围]
---@alias noteAbilityBanCursor {x:number,y:number,radius:number,width:number,height:number}
---@alias noteAbilityBanCursorFunc fun(options:noteAbilityBanCursor)
---@param modify noteAbilityBanCursorFunc|nil
---@return self|noteAbilityBanCursorFunc
function _.banCursor(modify) end