---@class FrameAnimate:FrameBackdrop
---@param frameIndex string 索引名
---@param parent Frame
---@return FrameAnimate
function FrameAnimate(frameIndex, parent)
    if (frameIndex == nil) then
        return
    end
    return Object("FrameAnimate", {
        static = { "FrameAnimate", frameIndex },
        frameIndex = frameIndex,
        parent = parent,
    })
end
