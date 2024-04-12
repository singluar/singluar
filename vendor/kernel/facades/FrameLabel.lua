---@class FrameLabel:FrameCustom
---@param frameIndex string 索引名
---@param parent Frame
---@return FrameLabel
function FrameLabel(frameIndex, parent)
    if (frameIndex == nil) then
        return
    end
    return Object("FrameLabel", {
        static = { "FrameLabel", frameIndex },
        frameIndex = frameIndex,
        parent = parent,
    })
end
