---@type ItemTpl
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

--- 绑定技能TPL
--- 创建物品对象时，此TPL会转为具体的技能对象
---@param modify AbilityTpl|nil
---@return self|AbilityTpl
function _.ability(modify) end

--- 物品具现化，没有具现化的物品不会出现在大地图
--- 物品处于单位身上时自动失去具现化意义
---@param modify boolean|nil
---@return boolean
function _.instance(modify) end

--- 模型ID
---@return number
function _.modelId() end

--- 物品模型（别称）
---@param modify string|nil
---@return self|string
function _.modelAlias(modify) end

--- 模型缩放
---@param modify number|nil
---@return self|number
function _.modelScale(modify) end

--- 碰撞体积
---@param modify number|nil
---@return self|number
function _.animateScale(modify) end

--- 碰撞体积
---@param modify number|nil
---@return self|number
function _.collision(modify) end

--- 归类
--- 默认与名字一致，联动合成
---@param modify string|nil
---@return self|string
function _.class(modify) end

--- 名称
---@param modify string|nil
---@return self|string
function _.name(modify) end

--- 图标
---@param modify string|nil
---@return self|string
function _.icon(modify) end

--- 描述体
---@alias noteTplDescriptionFunc fun(obj:Item):string[]
---@param modify nil|string[]|string|noteTplDescriptionFunc
---@return self|string[]
function _.description(modify) end

--- 存在周期
---@param modify number|nil
---@return self|number|-1
function _.period(modify) end

--- 是否消耗品
--- 默认false
--- 消耗品的数目小于1时，物品会自动销毁
---@param modify boolean|nil
---@return self|boolean
function _.consumable(modify) end

--- 是否可抵押
--- 不可抵押则没法出售
---@param modify boolean|nil
---@return self|boolean
function _.pawnable(modify) end

--- 是否可丢弃
---@param modify boolean|nil
---@return self|boolean
function _.dropable(modify) end

--- 使用次数
---@param modify number|nil
---@return self|number|0
function _.charges(modify) end

--- 物品最大级
---@param modify number|nil
---@return self|number
function _.levelMax(modify) end

--- 物品当前等级
---@param modify number|nil
---@return self|number
function _.level(modify) end

--- 财物消耗
---@param modify number|nil
---@return self|number
function _.worth(modify) end