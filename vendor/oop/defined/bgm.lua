---@param this Bgm
Class("Bgm")
    .construct(
    function(this)
        PropChange(this, "volume", "std", 100, false)
    end)