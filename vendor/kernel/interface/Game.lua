---@type Game
local _

--- 通用简化型事件注册
---@param evt string 事件类型字符
---@vararg string|fun(callData:table)
---@return self
function _.onEvent(evt, ...) end

--- 游戏名字（地图名字）
---@param modify string|nil
---@return self|string
function _.name(modify) end

--- 开始玩家数
---@return number
function _.playingQuantityStart() end

--- 正在游戏的玩家数
---@param modify number|nil
---@return self|number
function _.playingQuantity(modify) end

--- 定义某个key游戏描述体设置
---@alias noteGameDescriptionSetting fun(this:Object,options:table):string[]|string
---@param key string
---@param descSetting noteGameDescriptionSetting
---@return noteGameDescriptionSetting|nil
function _.defineDescription(key, descSetting) end

--- 获取游戏描述设置
---@vararg string
---@param obj Object
---@param options table
---@vararg table
---@return string[]
function _.combineDescription(obj, options, ...) end

--- 设置战争迷雾
---@param enableFog boolean
---@return self
function _.fog(enableFog) end

--- 设置黑色阴影
---@param enableMark boolean
---@return self
function _.mark(enableMark) end

--- 游戏技能栏热键
--- 当param为字符串数组时，设置键值
--- 当param为数字时，返回对应键值设置
--- 当param为nil时，返回所有设置
---@param param nil|number|string[]
---@return self|string|string[]
function _.abilityHotkey(param) end

--- 游戏技能升级经验机制
---@param max number 最大等级
---@param fixed number 每级固定需要经验
---@param ratio number 每级对应上一级需要经验的加成数
---@param limit number 每级需要经验上限，当fixed、ratio计算超过这个值的时候进行约束
---@return self|number,number,number,number
function _.abilityUpgrade(max, fixed, ratio, limit) end

--- 游戏技能升级最大级
---@return number
function _.abilityLevelMax() end

--- 游戏技能升级经验需要条件
---@param whichLevel number
---@return number|number[]
function _.abilityExpNeeds(whichLevel) end

--- 游戏物品栏热键
--- 当param为字符串数组时，设置键值
--- 当param为数字时，返回对应键值设置
--- 当param为nil时，返回所有设置
---@param param nil|number|string[]
---@return self|string|string[]
function _.itemHotkey(param) end

--- 游戏物品升级经验机制
---@param max number 最大等级
---@param fixed number 每级固定需要经验
---@param ratio number 每级对应上一级需要经验的加成数
---@param limit number 每级需要经验上限，当fixed、ratio计算超过这个值的时候进行约束
---@return self|number,number,number,number
function _.itemUpgrade(max, fixed, ratio, limit) end

--- 游戏物品升级最大级
---@return number
function _.itemLevelMax() end

--- 游戏物品升级经验需要条件
---@param whichLevel number
---@return number|number[]
function _.itemExpNeeds(whichLevel) end

--- 游戏单位升级经验机制
---@param max number 最大等级
---@param fixed number 每级固定需要经验
---@param ratio number 每级对应上一级需要经验的加成数
---@param limit number 每级需要经验上限，当fixed、ratio计算超过这个值的时候进行约束
---@return self|number,number,number,number
function _.unitUpgrade(max, fixed, ratio, limit) end

--- 游戏单位升级最大级
---@return number
function _.unitLevelMax() end

--- 游戏单位升级经验需要条件
---@param whichLevel number
---@return number|number[]
function _.unitExpNeeds(whichLevel) end

--- 玩家仓库容量机制
---@param max number
---@return self|number
function _.warehouseSlot(max) end

--- 撤销指令
---@param pattern string 正则字符串
---@return self
function _.unCommand(pattern) end

--- 配置这局游戏支持的框架指令
---@param pattern string 正则字符串
---@param callFunc:fun(evtData:noteOnChatData)
---@return self
function _.command(pattern, callFunc) end

--- 游戏财物规则
---@example Game().worth("lumber","木头",{"gold",1000000})
---@example Game().worth("gold","黄金")
---@param key string 财物key
---@param name string 财物名词
---@param convert table 等价物
---@return self|Array|number
function _.worth(key, name, convert) end

--- 获取游戏财物转化规则
---@param key string
---@return Array|table
function _.worthConvert(key) end

--- 游戏财物换算（Upper 2 Lower）
--- 将上级财物尽可能地换算为最下级财物单位
--- data = { gold = 1,silver = 1,copper = 0}
--- 得到 { gold = 0, silver = 0, copper = 10100 }
---@param data table
---@return table
function _.worthU2L(data) end

--- 游戏财物换算（Lower 2 Upper）
--- 将上级财物尽可能地换算为最下级财物单位
--- data = { copper = 10100}
--- 得到 { gold = 1,silver = 1,copper = 0}
---@param data table
---@return table
function _.worthL2U(data) end

--- 游戏财物比例计算,如:
--- 乘除可算比例，加减可算相互计算
--- worthCale({gold=100}, "*", 0.5)
--- worthCale({gold=100}, "/", 2)
--- worthCale(3, "*", {gold=100})
--- worthCale({gold=100}, "+", {gold=100})
--- worthCale({gold=100}, "-", {gold=100})
---@param data1 table|number
---@param operator string "+"|"-"|"*"|"/"
---@param data2 table|number
---@return Array|table
function _.worthCale(data1, operator, data2) end

--- 采取 floor 的取整结果
---@param data table
---@return table
function _.worthFloor(data) end

--- 采取 ceil 的取整结果
---@param data table
---@return table
function _.worthCeil(data) end

--- 采取 round 的取整结果
---@param data table
---@return table
function _.worthRound(data) end

--- 在财物转化规则下，比较两个数据集的大小
--- 1大于2 返回true
--- 1小于2 返回false
--- 相等 返回 0（数据不相应时，没法比较）
--- 没法比较 返回nil
--[[ 如
    data1 = { gold = 1,silver = 1,copper = 0}
    data2 = { gold = 0,silver = 77,copper = 33}
    1 > 2
]]
---@param data1 table
---@param data2 table
---@return boolean|nil
function _.worthCompare(data1, data2) end

--- 判断财物1是否 等价于 财物2
--- 无法比较时为false
---@param data1 table
---@param data2 table
---@return boolean
function _.worthEqual(data1, data2) end

--- 判断财物1是否 大于 财物2
--- 无法比较时为false
---@param data1 table
---@param data2 table
---@return boolean
function _.worthGreater(data1, data2) end

--- 判断财物1是否 小于 财物2
--- 无法比较时为false
---@param data1 table
---@param data2 table
---@return boolean
function _.worthLess(data1, data2) end

--- 判断财物1是否 大于等于 财物2
--- 无法比较时为false
---@param data1 table
---@param data2 table
---@return boolean
function _.worthEqualOrGreater(data1, data2) end

--- 判断财物1是否 小于等于 财物2
--- 无法比较时为false
---@param data1 table
---@param data2 table
---@return boolean
function _.worthEqualOrLess(data1, data2) end