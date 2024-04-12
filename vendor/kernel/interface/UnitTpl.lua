---@type UnitTpl
local _

--- 本对象事件注册
---@param evt string 事件类型字符
---@vararg string|fun(callData:table)
---@return self
function _.onEvent(evt, ...) end

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

--- 绑定技能栏TPL
--- 创建单位对象时，此组TPL会转为具体的技能对象，并按顺序push进单位技能栏，是时数量溢出会报错
---@param modify AbilityTpl[]
---@return self|AbilityTpl[]
function _.abilitySlot(modify) end

--- 绑定物品栏TPL
--- 创建单位对象时，此TPLs会转为具体的物品对象，并按顺序push进单位物品栏，是时数量溢出会报错
---@param modify ItemTpl[]|nil
---@return self|ItemTpl[]
function _.itemSlot(modify) end

--- 模型ID
---@return number
function _.modelId() end

--- 单位模型（别称）
---@param modify string|nil
---@return self|string
function _.modelAlias(modify) end

--- 单位模型缩放[0.00-1.00]
---@param modify number|nil
---@return self|number
function _.modelScale(modify) end

--- 单位动画速度[0.00-1.00]
---@param modify number|nil
---@return self|number
function _.animateScale(modify) end

--- 发动施法动作
---@param modify string|nil
---@return self|string
function _.castAnimation(modify) end

--- 持续施法动作
---@param modify string|nil
---@return self|string
function _.keepAnimation(modify) end

--- 单位攻击动作击出比率点[%]
--- 默认0.8，范围[0-1.5]
---@param modify number|nil
---@return self|number
function _.attackPoint(modify) end

--- 单位转身速度[0.00-1.00]
---@param modify number|nil
---@return self|number
function _.turnSpeed(modify) end

--- 单位身材高度
---@param modify number
---@return self|number
function _.stature(modify) end

--- 名称
---@param modify string|nil
---@return self|string
function _.name(modify) end

--- 称谓
---@param modify string|nil
---@return self|string
function _.properName(modify) end

--- 设置单位动画颜色
---@param red number 红0-255
---@param green number 绿0-255
---@param blue number 蓝0-255
---@param alpha number 透明度0-255
---@param duration number 持续时间 -1无限
---@return self|number[4]
function _.rgba(red, green, blue, alpha, duration) end

--- 单位图标
---@param modify string|nil
---@return self|string
function _.icon(modify) end

--- 单位身体材质
---@param modify MATERIAL|nil
---@return self|MATERIAL
function _.material(modify) end

--- 单位武器声音模式
--- 默认1，可选2
--- 1为击中时发声，2为攻击点动作时发声
---@param modify number|nil
---@return self|number
function _.weaponSoundMode(modify) end

--- 单位武器声音
---@param modify string|nil
---@return self|string
function _.weaponSound(modify) end

--- 武器长度
--- 默认50，箭矢将从伸长的位置开始生成
---@param modify number|nil
---@return self|number
function _.weaponLength(modify) end

--- 武器高度
--- 默认30，箭矢将从对应高度的位置开始生成
---@param modify number|nil
---@return self|number
function _.weaponHeight(modify) end

--- 单位移动类型
---@param modify string|nil
---@return self|string
function _.moveType(modify) end

--- 生命周期
---@param modify number|nil
---@return self|number|-1
function _.period(modify) end

--- 主属性（虚假的）
---@param modify UNIT_PRIMARY|nil
---@return self|UNIT_PRIMARY
function _.primary(modify) end

--- 单位飞行高度
---@param modify number|nil
---@return self|number
function _.flyHeight(modify) end

--- 单位碰撞体积
---@param modify number|nil
---@return self|number
function _.collision(modify) end

--- 单位最大级
---@param modify number|nil
---@return self|number
function _.levelMax(modify) end

--- 单位当前等级
---@param modify number|nil
---@return self|number
function _.level(modify) end

--- 单位技能点数量
---@param modify number|nil
---@return self|number
function _.abilityPoint(modify) end

--- 描述体
---@alias noteTplDescriptionFunc fun(obj:Unit):string[]
---@param modify nil|string[]|string|noteTplDescriptionFunc
---@return self|string[]
function _.description(modify) end