---@param this WarehouseSlot
Class("WarehouseSlot")
    .construct(
    function(this, options)
        PropChange(this, "bindPlayer", "std", options.bindPlayer, false)
        PropChange(this, "storage", "std", {}, false)
    end)