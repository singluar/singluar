---@class FrameTextarea:FrameCustom
---@param frameIndex string 索引名
---@param parent Frame
---@return FrameTextarea
function FrameTextarea(frameIndex, parent)
    if (frameIndex == nil) then
        return
    end
    return Object("FrameTextarea", {
        static = { "FrameTextarea", frameIndex },
        frameIndex = frameIndex,
        parent = parent,
    })
end
