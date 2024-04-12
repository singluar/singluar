---@class FrameHighLight:FrameCustom
---@param frameIndex string 索引名
---@param parent Frame
---@return FrameHighLight
function FrameHighLight(frameIndex, parent)
    if (frameIndex == nil) then
        return
    end
    return Object("FrameHighLight", {
        static = { "FrameHighLight", frameIndex },
        frameIndex = frameIndex,
        parent = parent,
    })
end
