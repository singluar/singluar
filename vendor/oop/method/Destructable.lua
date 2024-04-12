---@param this Destructable
Class("Destructable")

    .public("handle",
    function(this)
        return this.__HANDLE__
    end)

    .public("x",
    function(this)
        return this.prop("x")
    end)

    .public("y",
    function(this)
        return this.prop("y")
    end)

    .public("z",
    function(this)
        return this.prop("z")
    end)

    .public("position",
    function(this, tx, ty, tz)
        this.prop("x", tx)
        this.prop("y", ty)
        this.prop("z", tz)
        return this
    end)

    .public("modelId",
    function(this)
        return this.prop("modelId")
    end)

    .public("modelAlias",
    function(this)
        return this.prop("modelAlias")
    end)

    .public("facing",
    function(this, modify)
        return this.prop("facing", modify)
    end)

    .public("scale",
    function(this, modify)
        return this.prop("scale", modify)
    end)

    .public("variation",
    function(this, modify)
        return this.prop("variation", modify)
    end)

    .public("occluderHeight",
    function(this, modify)
        return this.prop("occluderHeight", modify)
    end)

    .public("invulnerable",
    function(this, modify)
        if (type(modify) ~= "boolean") then
            return J.IsDestructableInvulnerable(this.handle())
        end
        J.SetDestructableInvulnerable(this.handle(), modify)
        return this
    end)

    .public("show",
    function(this)
        J.ShowDestructable(this.handle(), true)
        return this
    end)

    .public("hide",
    function(this)
        J.ShowDestructable(this.handle(), false)
        return this
    end)

    .public("hp",
    function(this, modify)
        return this.prop("hp", modify)
    end)

    .public("hpCur",
    function(this, modify)
        return this.prop("hpCur", modify)
    end)

    .public("kill",
    function(this)
        J.KillDestructable(this.handle())
        return this
    end)

    .public("reborn",
    function(this)
        J.DestructableRestoreLife(this.handle(), J.GetDestructableMaxLife(this.handle()), true)
        return this
    end)