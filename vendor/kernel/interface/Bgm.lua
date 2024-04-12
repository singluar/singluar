---@type Bgm
local _

--- 是否播放中
---@return boolean
function _.isPlaying() end

--- 音量[0%-100%]
---@param modify number|nil
---@return self|number
function _.volume(modify) end

--- 停止
---@return self
function _.stop() end

--- 播放
---@param musicAlias string
---@return void
function _.play(musicAlias) end