---@class FrameBackdrop:FrameCustom
---@param frameIndex string 索引名
---@param parent Frame
---@return FrameBackdrop
function FrameBackdrop(frameIndex, parent)
    if (frameIndex == nil) then
        return
    end
    return Object("FrameBackdrop", {
        static = { "FrameBackdrop", frameIndex },
        frameIndex = frameIndex,
        parent = parent,
    })
end
