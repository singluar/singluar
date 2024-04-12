---@type FrameModel
local _

--- 模型
---@param modify string|nil
---@return self|string
function _.model(modify) end

--- 动画
---@param animId string
---@param autoCast boolean
---@return self|{string,boolean}
function _.animate(animId, autoCast) end