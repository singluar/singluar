---@class FrameText:FrameCustom
---@param frameIndex string 索引名
---@param parent Frame
---@return FrameText
function FrameText(frameIndex, parent)
    if (frameIndex == nil) then
        return
    end
    return Object("FrameText", {
        static = { "FrameText", frameIndex },
        frameIndex = frameIndex,
        parent = parent,
    })
end
