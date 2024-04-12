---@type FrameCustom
local _

--- fdf名称
---@param
---@return string
function _.fdfName() end

--- 透明度
---@param modify number|nil
---@return self|number
function _.alpha(modify) end

--- 显示 渐变
---@see duration 渐变时间
---@see x 坐标偏移
---@see y 坐标偏移
---@alias noteFrameShowGradient {duration:number,x:number,y:number}
---@param modify boolean|nil
---@param options noteFrameShowGradient
---@return self
function _.showGradient(modify, options) end