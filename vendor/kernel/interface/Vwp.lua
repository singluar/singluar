---@type Vwp
local _

--- handle
---@return number
function _.handle() end

--- 是否播放中
---@return boolean
function _.isPlaying() end

--- 获取标签
---@return string
function _.label() end

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

--- 播放
---@return self
function _.play() end