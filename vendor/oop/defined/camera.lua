---@param this Camera
Class("Camera")
    .construct(
    function(this)
        PropChange(this, "<SUPERPOSITION>shake", "std", 0, false)
        PropChange(this, "<SUPERPOSITION>quake", "std", 0, false)
    end)