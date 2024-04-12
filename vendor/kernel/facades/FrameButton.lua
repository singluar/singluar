---@class FrameButton:FrameCustom
---@param frameIndex string 索引名
---@param parent Frame
---@return FrameButton
function FrameButton(frameIndex, parent)
    if (frameIndex == nil) then
        return
    end
    return Object("FrameButton", {
        static = { "FrameButton", frameIndex },
        frameIndex = frameIndex,
        parent = parent,
    })
end
