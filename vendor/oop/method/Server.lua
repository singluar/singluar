---@param this Server
Class("Server")

    .public("data",
    function(this)
        return this.prop("data")
    end)

    .public("bindPlayer",
    function(this)
        return this.prop("bindPlayer")
    end)

    .public("load",
    function(this, key, default)
        local data = this.data()
        if (data[key] == nil) then
            data[key] = japi.ServerLoadValue(this.bindPlayer().handle(), key) or default
        end
        return data[key]
    end)

    .public("save",
    function(this, key, value)
        local data = this.data()
        japi.ServerSaveValue(this.bindPlayer().handle(), key, value)
        if (data[key] ~= nil) then
            data[key] = nil
        end
    end)

    .public("clear",
    function(this, key)
        local data = this.data()
        japi.ServerSaveValue(this.bindPlayer().handle(), key, nil)
        if (data[key] ~= nil) then
            data[key] = nil
        end
    end)

    .public("room",
    function(this, key, value)
        japi.ServerSaveRoom(this.bindPlayer().handle(), key, value)
    end)