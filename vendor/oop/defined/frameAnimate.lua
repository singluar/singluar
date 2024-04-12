---@param this FrameAnimate
Class("FrameAnimate")
    .inherit("FrameBackdrop")
    .construct(
    function(this)
        PropChange(this, "duration", "std", 1, false)
        PropChange(this, "halt", "std", 0, false)
        PropChange(this, "step", "std", 0, false)
    end)