---@class FrameCustom:Frame
---@param frameIndex string 索引名
---@param parent Frame
---@param fdfName string
---@param fdfType string|nil
---@return FrameCustom
function FrameCustom(frameIndex, parent, fdfName, fdfType)
    if (frameIndex == nil or fdfName == nil) then
        return
    end
    return Object("FrameCustom", {
        static = { "FrameCustom", frameIndex },
        frameIndex = frameIndex,
        parent = parent,
        fdfName = fdfName,
        fdfType = fdfType,
    })
end
