---@class FrameBar:FrameCustom
---@param frameIndex string 索引名
---@param parent Frame
---@param fdfName string 模版边框(可选) 启用边框时，边框也会算进整体宽高里，自行设置borderOffset调整
---@param borderOffset number 边框模式下的内置位置调整值，默认0.007
---@return FrameBar
function FrameBar(frameIndex, parent, fdfName, borderOffset)
    if (frameIndex == nil) then
        return
    end
    return Object("FrameBar", {
        static = { "FrameBar", frameIndex },
        frameIndex = frameIndex,
        fdfName = fdfName,
        parent = parent,
        borderOffset = borderOffset,
    })
end
