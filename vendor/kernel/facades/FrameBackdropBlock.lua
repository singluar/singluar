---@class FrameBackdropBlock:FrameCustom
---@param frameIndex string 索引名
---@param parent Frame
---@return FrameBackdropBlock
function FrameBackdropBlock(frameIndex, parent)
    if (frameIndex == nil) then
        return
    end
    return Object("FrameBackdropBlock", {
        static = { "FrameBackdropBlock", frameIndex },
        frameIndex = frameIndex,
        parent = parent,
    })
end
