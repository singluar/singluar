---@param this Dialog
Class("Dialog")

    .public("handle",
    function(this)
        return this.__HANDLE__
    end)

    .public("title",
    function(this, modify)
        return this.prop("title", modify)
    end)

    .public("show",
    function(this, Who)
        if (isObject(Who, "Player")) then
            J.DialogDisplay(Who.handle(), this.handle(), true)
        else
            J.DialogDisplay(Player1st().handle(), this.handle(), true)
        end
        return this
    end)
