---@param this Quest
Class("Quest")

    .public("handle",
    function(this)
        return this.__HANDLE__
    end)

    .public("title",
    function(this, modify)
        return this.prop("title", modify)
    end)

    .public("icon",
    function(this, modify)
        return this.prop("icon", AIcon(modify))
    end)

    .public("side",
    function(this, modify)
        return this.prop("side", modify)
    end)

    .public("content",
    function(this, modify)
        if (modify and type(modify) == "table") then
            modify = string.implode("|n", modify)
        end
        return this.prop("content", modify)
    end)

    .public("complete",
    function(this, modify)
        return this.prop("complete", modify)
    end)

    .public("fail",
    function(this, modify)
        return this.prop("fail", modify)
    end)

    .public("discover",
    function(this, modify)
        return this.prop("discover", modify)
    end)

    .public("flash",
    function(this)
        J.FlashQuestDialogButton()
    end)