---@class FrameModel:FrameCustom
---@param frameIndex string 索引名
---@param parent Frame
---@return FrameModel
function FrameModel(frameIndex, parent)
    if (frameIndex == nil) then
        return
    end
    return Object("FrameModel", {
        static = { "FrameModel", frameIndex },
        frameIndex = frameIndex,
        parent = parent,
    })
end
