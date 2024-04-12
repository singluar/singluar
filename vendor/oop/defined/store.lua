---@param this Store
Class("Store")
    .construct(
    function(this, options)
        PropChange(this, "key", "std", options.key, false)
        PropChange(this, "name", "std", options.key, false)
        PropChange(this, "icon", "std", "Singluar\\ui\\default.tga", false)
        PropChange(this, "salesGoods", "std", Array(), false)
        PropChange(this, "salesPlayers", "std", {}, false)
    end)