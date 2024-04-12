---@type Cursor
local _

--- UI kit配置
--- 虽然指针不是Frame对象，但可以为指针配置一个uiKit
--- 方便写于UI时，引入资源
--- 而挂靠于UI也是一种比较舒适的写法
---@param modify nil|string
---@return self|string
function _.uiKit(modify) end

--- 瞄准准心贴图
--- 设置3个贴图，顺序为 常规、对友、对敌
--- 常见为 白、绿、红三种
---@alias noteCursorTextureAim {normal:string,ally:string,enemy:string}
---@param modify nil|noteCursorTextureAim
---@return self|noteCursorTextureAim
function _.textureAim(modify) end

--- 圆型选区贴图
--- 当为nil时采用魔兽原生4族
---@alias noteCursorTextureRadius {alpha:number,allow:string,ban:string}
---@param modify noteCursorTextureRadius
---@return self|noteCursorTextureRadius
function _.textureCircle(modify) end

--- 方型选区贴图
--- 当为nil时采用魔兽原生贴图
---@alias noteCursorTextureSquare {alpha:number,allow:string,ban:string}
---@param modify noteCursorTextureSquare
---@return self|noteCursorTextureSquare
function _.textureSquare(modify) end

--- 尺寸变化量
--- 默认为-1，即瞬间变化完成
---@param modify number
---@return self|number
function _.sizeRate(modify) end

--- 禁用不安全边界区
--- 填写Frame对象，将根据anchor自动计算
---@param modify table anchors
---@return self|table
function _.banBorders(modify) end

--- 是否安全区
--- 只有安全区可以安全显示指针
---@param rx number
---@param ry number
---@return boolean
function _.isSave(rx, ry) end

--- 指针浮动提示
---@param modify nil|fun(obj:Unit|Item)
---@return self|string
function _.tooltips(modify) end

--- 当前引用技能对象
---@param modify Ability|nil
---@return self|Ability
function _.ability(modify) end

--- 停止引用技能对象
---@return self
function _.abilityStop() end

--- 调用技能对象
---@param whichAbility Ability
---@return void
function _.abilityQuote(whichAbility) end

--- 调用物品对象
---@param whichItem Item
---@return void
function _.itemQuote(whichItem) end

--- 跟踪图层关联对象
---@return Object
function _.followObj() end

--- 跟踪图层中
---@return boolean
function _.following() end

--- 跟踪图层
---@alias noteFollowData {texture:string,size:table,frame:Frame}
---@alias noteFollowStopFunc fun(stopData:{followObj:Object,...})
---@param obj Object
---@param data noteFollowData
---@param stopFunc noteFollowStopFunc|nil
---@return void
function _.followCall(obj, data, stopFunc) end

--- 停止跟踪图层
---@param callFunc noteFollowStopFunc|nil
---@return void
function _.followStop(callFunc) end