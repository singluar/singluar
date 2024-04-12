---@type Frame
local _

---@alias noteOnFrameEvtData {triggerFrame:Frame,triggerPlayer:Player}
---@alias noteOnFrameEvtReleaseData {triggerFrame:Frame,triggerPlayer:Player,status:boolean 鼠标是否还在Frame内}

--- handle
---@return number
function _.handle() end

--- frame index(cache key)
---@return any
function _.frameIndex() end

--- frame kit
---@return string
function _.kit() end

--- 自适应
--- * 需要自适应的UI请在尺寸定位之前立即设为true
--- * 如果在设置此数值后前已完成定位尺寸，可能初始时无法自适应
---@param modify boolean|nil
---@return self|boolean
function _.adaptive(modify) end

--- 锚
--- 记录从屏幕左下角为原点的[偏移XY，宽高]
---@alias noteAnchorData {x,y,width,height}
---@return noteAnchorData
function _.anchor() end

--- 设置父节点
---@param modify Frame|nil
---@return self|Frame
function _.parent(modify) end

--- 所有子节点
---@return Frame[]
function _.children() end

--- 上级关系节点
---@return Frame
function _.upperNode() end

--- 所有下级关系节点
---@return Frame[]
function _.lowerNodes() end

--- 宽高尺寸(0-0.8,0-0.6)
--- 百分比占比设置
---@param w number
---@param h number
---@return self|number[2]
function _.size(w, h) end

--- 相对锚点
---@param point number integer 参考 FRAME_ALIGN
---@param relativeFrame Frame 相对节点ID(def:FrameGameUI)
---@param relativePoint number 以 align-> alignParent 对齐
---@param x number 锚点X
---@param y number 锚点Y
---@return self|table
function _.relation(point, relativeFrame, relativePoint, x, y) end

--- 绝对锚点
---@param point number
---@param x number
---@param y number
---@return self|table
function _.absolut(point, x, y) end

--- 显示
---@param modify boolean|nil
---@param delay number 延时
---@return self|boolean
function _.show(modify, delay) end

--- 鼠标左键点击
---@vararg string|fun(evtData:noteOnFrameEvtData)
---@return self
function _.onMouseLeftClick(...) end

--- 鼠标右键点击
---@vararg string|fun(evtData:noteOnFrameEvtData)
---@return self
function _.onMouseRightClick(...) end

--- 鼠标移动
---@vararg string|fun(evtData:noteOnFrameEvtData)
---@return self
function _.onMouseMove(...) end

--- 鼠标进入
---@vararg string|fun(evtData:noteOnFrameEvtData)
---@return self
function _.onMouseEnter(...) end

--- 鼠标离开
---@vararg string|fun(evtData:noteOnFrameEvtData)
---@return self
function _.onMouseLeave(...) end