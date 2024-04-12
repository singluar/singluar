---@type FrameAnimate
local _

--- 贴图动作集
---@param modify string[]|nil
---@return self|string[]
function _.motion(modify) end

--- 动作持续时间
---@param modify number|nil
---@return self|number
function _.duration(modify) end

--- 动作中断间距
---@param modify number|nil
---@return self|number
function _.halt(modify) end

--- 是否正在播放
---@return boolean
function _.isPlaying() end

---@param isInterval boolean 是否循环播放，默认nil(false)
---@param isReset boolean 是否从头开始，默认nil(false)
---@return void
function _.play(isInterval, isReset) end

--- 停止播放
---@return void
function _.stop() end