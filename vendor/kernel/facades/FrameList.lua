---@class FrameList:FrameBackdrop
---@param frameIndex string 索引名
---@param parent Frame
---@param max number 最大label数
---@return FrameList
function FrameList(frameIndex, parent, max)
    if (frameIndex == nil) then
        return
    end
    max = max or 3
    return Object("FrameList", {
        static = { "FrameList", frameIndex },
        frameIndex = frameIndex,
        parent = parent,
        max = max,
    })
end
