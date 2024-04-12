---@class FrameTooltips:FrameCustom
---@param index number
---@return FrameTooltips
function FrameTooltips(index)
    index = math.floor(index or 1)
    must(type(index) == "number")
    must(index >= 0 and index <= FRAME_OBJ_MAX_TOOLTIPS)
    return Object("FrameTooltips", {
        static = { "FrameTooltips", index },
        frameIndex = "FrameTooltips" .. index,
    })
end
