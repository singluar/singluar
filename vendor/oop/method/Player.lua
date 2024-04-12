---@param this Player
Class("Player")

    .public("onEvent",
    function(this, evt, ...)
        event.register(this, evt, ...)
        return this
    end)

    .public("onSelectUnit",
    function(this, qty, callFunc)
        event.register(this, EVENT.Player.SelectUnit .. "#" .. qty, callFunc)
        return this
    end)

    .public("onSelectItem",
    function(this, qty, callFunc)
        event.register(this, EVENT.Player.SelectItem .. "#" .. qty, callFunc)
        return this
    end)

    .public("onChat",
    function(this, pattern, callFunc)
        if (false == event.has(this, EVENT.Player.Chat)) then
            event.register(this, EVENT.Player.Chat, function(evtData)
                ---@type Array
                local chatPattern = this.prop("chatPattern")
                chatPattern.forEach(function(p, c)
                    local m = string.match(evtData.chatString, p)
                    if (m ~= nil) then
                        evtData.matchedString = m
                        promise(c, nil, nil, evtData)
                    end
                end)
            end)
        end
        ---@type Array
        local chatPattern = this.prop("chatPattern")
        if (type(callFunc) == "function") then
            chatPattern.set(pattern, callFunc)
        else
            chatPattern.set(pattern, nil)
        end
        return this
    end)

    .public("handle",
    function(this)
        return this.__HANDLE__
    end)

    .public("isNeutral",
    function(this)
        return this.prop("index") >= 13
    end)

    .public("isComputer",
    function(this)
        return this.prop("isComputer")
    end)

    .public("isUser",
    function(this)
        return this.prop("isUser")
    end)

    .public("isPlaying",
    function(this)
        return this.prop("status") == PLAYER_STATUS.playing
    end)

    .public("isRedVip",
    function(this)
        return this.prop("isRedVip")
    end)

    .public("isBlueVip",
    function(this)
        return this.prop("isBlueVip")
    end)

    .public("isPlatformVIP",
    function(this)
        return this.prop("isPlatformVIP")
    end)

    .public("isHurting",
    function(this)
        return this.superposition("hurt") > 0
    end)

    .public("isDamaging",
    function(this)
        return this.superposition("damage") > 0
    end)

    .public("isMarking",
    function(this)
        return this.superposition("mark") > 0
    end)

    .public("hasMallItem",
    function(this, k)
        if (k == nil) then
            return false
        end
        local i = this.prop("dzMallItem")
        if (i[k] == nil) then
            i[k] = japi.DzAPI_Map_HasMallItem(this.handle(), k) or false
        end
        return i[k]
    end)

    .public("index",
    function(this)
        return this.prop("index")
    end)

    .public("mapLv",
    function(this)
        return this.prop("mapLv")
    end)

    .public("name",
    function(this, modify)
        return this.prop("name", modify)
    end)

    .public("teamColor",
    function(this, modify)
        return this.prop("teamColor", modify)
    end)

    .public("race",
    function(this, modify)
        return this.prop("race", modify)
    end)

    .public("status",
    function(this, modify)
        return this.prop("status", modify)
    end)

    .public("worth",
    function(this, operator, data)
        local w = this.prop("worth")
        if (type(operator) == "string" and (type(data) == "table" or type(data) == "number")) then
            if (operator == "=") then
                this.prop("worth", Game().worthL2U(Game().worthU2L(data)))
            else
                local ratio = this.worthRatio()
                if (ratio ~= 100 and operator == "+") then
                    local r = math.max(0, ratio * 0.01)
                    data = Game().worthCale(data, '*', r)
                end
                this.prop("worth", Game().worthCale(w, operator, data))
            end
            return this
        end
        return w
    end)

    .public("worthRatio",
    function(this, modify)
        return this.prop("worthRatio", modify)
    end)

    .public("sell",
    function(this, modify)
        return this.prop("sell", modify)
    end)

    .public("prestige",
    function(this, modify)
        return this.prop("prestige", modify)
    end)

    .public("select",
    function(this, targetUnit)
        this.prop("selection", NIL)
        if (isObject(targetUnit, "Unit")) then
            async.call(this, function()
                J.ClearSelection()
                J.SelectUnit(targetUnit.handle(), true)
            end)
        end
    end)

    .public("selection",
    function(this)
        return this.prop("selection")
    end)

    .public("apm",
    function(this)
        return math.floor(this.prop("apm"))
    end)

    .public("quit",
    function(this, reason)
        reason = reason or ""
        if (this.isUser()) then
            Dialog(reason, { { value = "Q", label = J.GetLocalizedString("GAMEOVER_QUIT_MISSION") } }, function(evtData)
                async.call(evtData.triggerPlayer, function()
                    J.EndGame(true)
                end)
            end).show(this)
        end
    end)

    .public("unit",
    function(this, tpl, x, y, facing)
        return Unit(tpl, this, x, y, facing)
    end)

    .public("warehouseSlot",
    function(this)
        return this.prop("warehouseSlot")
    end)

    .public("mark",
    function(this, path, duration, red, green, blue)
        if (path ~= nil and not this.isNeutral() and this.isPlaying()) then
            red = red or 255
            green = green or 255
            blue = blue or 255
            duration = math.trunc(duration or 3, 2)
            async.call(this, function()
                texture.cinematicFilterGeneric(0.50, BLEND_MODE_ADDITIVE, path, red, green, blue, 255, red, green, blue, 0)
            end)
            this.superposition("mark", "+=1")
            time.setTimeout(duration, function()
                this.superposition("mark", "-=1")
                async.call(this, function()
                    texture.cinematicFilterGeneric(0.50, BLEND_MODE_ADDITIVE, path, red, green, blue, 0, red, green, blue, 255)
                end)
            end)
        end
        return this
    end)

    .public("alert",
    function(this, modify, vcm)
        if (type(modify) == "string" and string.len(modify) > 0) then
            if (type(vcm) ~= "boolean") then
                vcm = true
            end
            if (vcm) then
                audio(Vcm("war3_error"), this)
            end
            local alertTimer = this.prop("alertTimer")
            if (isObject(alertTimer, "Timer")) then
                alertTimer.destroy()
                this.prop("alertTimer", NIL)
            end
            this.prop("alert", modify)
            local t = math.max(3, 0.2 * mbstring.len(modify))
            this.prop("alertTimer", time.setTimeout(t, function()
                this.prop("alertTimer", NIL)
                this.prop("alert", "")
            end))
            return this
        end
        return this.prop("alert")
    end)