---@param this Destructable
Class("Destructable")
    .construct(
    function(this, options)
        local dSlk = slk.i2v(options.id)
        local variationQty = math.floor(tonumber(dSlk.slk.numVar) or 1)

        options.x = options.x or 0
        options.y = options.y or 0
        options.z = options.z or 0
        options.facing = options.facing or math.rand(0, 360)
        options.scale = options.scale or (math.rand(7, 11) * 0.1)
        options.variation = options.variation or math.rand(1, variationQty)

        href(this, J.CreateDestructableZ(c2i(options.id), options.x, options.y, options.z, options.facing, options.scale, options.variation))

        PropChange(this, "modelId", "std", c2i(options.id), false)
        PropChange(this, "modelAlias", "std", options.modelAlias, false)
        PropChange(this, "variationQty", "std", variationQty, false)
        PropChange(this, "occluderHeight", "std", math.trunc(dSlk.slk.occH or 0.00, 2), false) -- 闭塞高度
        PropChange(this, "x", "std", options.x, false)
        PropChange(this, "y", "std", options.y, false)
        PropChange(this, "z", "std", options.z, false)
        PropChange(this, "facing", "std", options.facing, false)
        PropChange(this, "scale", "std", options.scale, false)
        PropChange(this, "variation", "std", options.variation, false)
    end)
    .initial(
    function(this)
        PropChange(this, "hp", "std", J.GetDestructableMaxLife(this.__HANDLE__), false)
        PropChange(this, "hpCur", "std", J.GetDestructableLife(this.__HANDLE__), false)
    end)