---@type Player
local _

--- 通用简化型事件注册
---@param evt string 事件类型字符
---@vararg string|fun(callData:table)
---@return self
function _.onEvent(evt, ...) end

--- 玩家选择单位 n 次
---@param n number integer
---@param callFunc fun(evtData:noteOnPlayerSelectUnitData)
---@param key string
---@return self
function _.onSelectUnit(n, callFunc, key) end

--- 玩家选择物品 n 次
---@param n number integer
---@param callFunc fun(evtData:noteOnPlayerSelectItemData)
---@param key string
---@return self
function _.onSelectItem(n, callFunc, key) end

--- 当聊天时
---@param pattern string 正则匹配内容
---@param callFunc fun(evtData:noteOnPlayerChatData)
---@return self
function _.onChat(pattern, callFunc) end

--- handle
---@return number
function _.handle() end

--- 是否中立玩家
---@return boolean
function _.isNeutral() end

--- 是否电脑(如果位置为电脑玩家或无玩家，则为true)【常用来判断电脑AI是否开启】
---@return boolean
function _.isComputer() end

--- 是否玩家位置(如果位置为真实玩家或为空，则为true；而如果选择了电脑玩家补充，则为false)【常用来判断该是否玩家可填补位置】
---@return boolean
function _.isUser() end

--- 是否正在游戏
---@return boolean
function _.isPlaying() end

--- 是否红V
---@return boolean
function _.isRedVip() end

--- 是否蓝V
---@return boolean
function _.isBlueVip() end

--- 是否平台VIP
---@return boolean
function _.isPlatformVIP() end

--- 是否正在受伤
---@return boolean
function _.isHurting() end

--- 是否正在造成伤害
---@return boolean
function _.isDamaging() end

--- 是否有屏幕贴图正在展示
---@return boolean
function _.isMarking() end

--- 是否有商城道具,由于官方设置的key必须大写，所以会在japi里自动转换
---@param mallItemKey string
---@return boolean
function _.hasMallItem(mallItemKey) end

--- 索引[1-16]
---@return number
function _.index() end

--- 指针
---@return Cursor
function _.cursor() end

--- 地图等级
---@return number
function _.mapLv() end

--- 名称
---@param modify string
---@return string|self
function _.name(modify) end

--- 队伍颜色
--- 使用玩家索引1-12决定颜色值,单位会自动同步
---@param modify number
---@return any|self
function _.teamColor(modify) end

--- 种族
---@param modify string
---@return string|self
function _.race(modify) end

--- 状态值
---@param modify PLAYER_STATUS
---@return PLAYER_STATUS|self
function _.status(modify) end

--- 财产管理
--- 当data同时存在时，会根据当前玩家资源计算
--- 当operator为=符号时，设定价值，当operator为+-*/时，会进行运算
--- 当operator为+时会计算worthRatio
---@param operator string|nil "="|"+"|"-"|"*"|"/"
---@param data table|number 计算变动值
---@return self|table
function _.worth(operator, data) end

--- 财产获得率[%]
--- 默认100
--- 当使用worth方法且operator为+时有作用
---@param modify number|nil
---@return self|number
function _.worthRatio(modify) end

--- 售卖折价率[%]
--- 默认50
---@param modify number
---@return number|self
function _.sell(modify) end

--- 称号
---@param modify string
---@return string|self
function _.prestige(modify) end

--- 选择一个单位
---@return Unit|Item|nil
function _.select(targetUnit) end

--- 当前选中单位
---@return Unit|Item|nil
function _.selection() end

--- APM
---@return number
function _.apm() end

--- 令玩家退出
---@param reason string 原因
function _.quit(reason) end

--- 创建单位
---@param tpl UnitTpl 单位模版
---@param x number 坐标X[默认0]
---@param y number 坐标Y[默认0]
---@param facing number 面向角度[默认270]
---@return Unit
function _.unit(tpl, x, y, facing) end

--- 仓库栏
---@return WarehouseSlot
function _.warehouseSlot() end

--- 创建一个遮罩
---@param path string 贴图路径 512x256 blp
---@param duration number 持续时间,默认3秒
---@param red number 0-255
---@param green number 0-255
---@param blue number 0-255
---@return self
function _.mark(path, duration, red, green, blue) end

--- 玩家警告提示
---@param modify string
---@param vcm boolean 是否播放音效
---@return self|string
function _.alert(modify, vcm) end