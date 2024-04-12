---@class Frame:Object
---@param frameIndex any
---@param frameId number
---@param parent Frame|nil
---@return Frame
function Frame(frameIndex, frameId, parent)
    if (frameIndex == nil or frameId == nil) then
        return
    end
    return Object("Frame", {
        static = { "Frame", frameIndex },
        parent = parent,
        frameIndex = frameIndex,
        frameId = frameId,
    })
end
