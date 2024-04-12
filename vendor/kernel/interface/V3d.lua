---@type V3d
local _

--- handle
---@return number
function _.handle() end

--- 获取时长[秒]
---@return number
function _.duration() end

--- 音量[0-100]
---@param modify number|nil
---@return self|number
function _.volume(modify) end

--- 通道
---@param modify SOUND_CHANNEL|nil
---@return self|SOUND_CHANNEL
function _.channel(modify) end

--- 音高
---@param modify number|nil
---@return self|number
function _.pitch(modify) end

--- 衰减截断范围
---@param modify number|nil
---@return self|number
function _.distanceCutoff(modify) end

--- 衰减范围[最小,最大]
---@param modify {number,number}|nil
---@return self|{number,number}
function _.distances(modify) end

--- 对单位绑定音效播放
---@param whichUnit Unit
---@return self
function _.unit(whichUnit) end

--- 对坐标绑定音效并播放
---@param x number
---@param y number
---@param z number
---@return self
function _.xyz(x, y, z) end

--- 对区域绑定音效
---@param whichRect Rect
---@param duration number 等于0时为无限持续时间
---@return self
function _.rect(whichRect, duration) end

--- 播放
---@return self
function _.play() end