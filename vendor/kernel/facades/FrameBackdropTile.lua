---@class FrameBackdropTile:FrameCustom
---@param frameIndex string 索引名
---@param parent Frame
---@return FrameBackdropTile
function FrameBackdropTile(frameIndex, parent)
    if (frameIndex == nil) then
        return
    end
    return Object("FrameBackdropTile", {
        static = { "FrameBackdropTile", frameIndex },
        frameIndex = frameIndex,
        parent = parent,
    })
end
