---@param this Game
Class("Game")

    .public("onEvent",
    function(this, evt, ...)
        event.register(this, evt, ...)
        return this
    end)

    .public("name",
    function(this, modify)
        return this.prop("name", modify)
    end)

    .public("playingQuantityStart",
    function(this)
        return this.prop("playingQuantityStart")
    end)

    .public("playingQuantity",
    function(this, modify)
        return this.prop("playingQuantity", modify)
    end)

    .public("defineDescription",
    function(this, key, descSetting)
        if (type(descSetting) == "function") then
            ---@type Array
            local desc = this.prop("description")
            desc.set(key, descSetting)
        end
        return this
    end)

    .public("combineDescription",
    function(this, obj, options, ...)
        local joiner = {}
        ---@type Array
        local desc = this.prop("description")
        options = options or {}
        local _join
        _join = function(ts)
            if (type(ts) == "string") then
                if (string.subPos(ts, "|n") == false) then
                    table.insert(joiner, ts)
                else
                    _join(string.explode("|n", ts))
                end
            elseif (type(ts) == "table") then
                for _, v in ipairs(ts) do
                    _join(v)
                end
            end
        end
        for _, data in ipairs({ ... }) do
            if (type(data) == "string" and data == "<D>" and type(obj.description) == "function") then
                _join(obj.description())
            elseif (type(data) == "string" and desc.keyExists(data)) then
                _join(desc.get(data)(obj, options))
            else
                _join(data)
            end
        end
        return joiner
    end)

    .public("fog",
    function(this, enableFog)
        J.FogEnable(enableFog)
        return this
    end)

    .public("mark",
    function(this, enableMark)
        J.FogMaskEnable(enableMark)
        return this
    end)

    .public("findPosition",
    function(this, x, y)
        local nx = 0
        local ny = 0
        local d = 32
        if (x ~= nil and y ~= nil) then
            x = d * math.round(x / d)
            y = d * math.round(y / d)
            nx = x
            ny = y
            local pd = this.prop("findPosition")
            local ik = x .. '_' .. y
            local bic = 0
            local bor = 1
            local bi = 0
            while (pd[ik] == 1) do
                if (bi == 0) then
                    bic = bic + 1
                    bor = bor + 2
                    nx = x + d * bic
                    ny = y + d * bic
                elseif (bi < bor * 1 - 0) then
                    ny = ny - d
                elseif (bi < bor * 2 - 1) then
                    nx = nx - d
                elseif (bi < bor * 3 - 2) then
                    ny = ny + d
                else
                    nx = nx + d
                end
                bi = bi + 1
                if (bi >= (bor - 1) * 4) then
                    bi = 0
                end
                ik = nx .. '_' .. ny
            end
            pd[ik] = 1
        end
        return nx, ny
    end)

    .public("freePosition",
    function(this, x, y)
        if (x ~= nil and y ~= nil) then
            local pd = this.prop("findPosition")
            x = math.round(x)
            y = math.round(y)
            local ik = x .. '_' .. y
            pd[ik] = nil
        end
    end)

    .public("abilityHotkey",
    function(this, param)
        if (type(param) == "table") then
            local prev = this.prop("abilityHotkey")
            if (type(prev) == "table") then
                for _, k in ipairs(prev) do
                    keyboard.onRelease(KEYBOARD[k], "abilityHotkey", nil)
                end
            end
            for idx, key in ipairs(param) do
                keyboard.onRelease(KEYBOARD[key], "abilityHotkey", function(evtData)
                    local selection = evtData.triggerPlayer.selection()
                    if (isObject(selection, "Unit") == false) then
                        return
                    end
                    if (selection.isDestroy()) then
                        return
                    end
                    Cursor().abilityQuote(selection.abilitySlot().storage()[idx])
                end)
            end
            return this.prop("abilityHotkey", param)
        end
        if (type(param) == "number") then
            return this.prop("abilityHotkey")[param] or ''
        else
            return this.prop("abilityHotkey")
        end
    end)

    .public("abilityUpgrade",
    function(this, max, fixed, ratio, limit)
        local isModify = max or fixed or ratio or limit
        if (max) then
            this.prop("abilityLevelMax", max)
        end
        if (fixed) then
            this.prop("abilityExpFixed", fixed)
        end
        if (ratio) then
            this.prop("abilityExpRatio", ratio)
        end
        if (limit) then
            this.prop("abilityExpLimit", limit)
        end
        local _max = this.prop("abilityLevelMax") or 1
        local _fixed = this.prop("abilityExpFixed") or 100
        local _radio = this.prop("abilityExpRatio") or 1.00
        local _limit = this.prop("abilityExpLimit") or 10000
        if (isModify) then
            this.prop("abilityExpNeeds", math.expNeeds(_max, _fixed, _radio, _limit))
            return this
        end
        return _max, _fixed, _radio, _limit
    end)

    .public("abilityLevelMax",
    function(this)
        return this.prop("abilityLevelMax")
    end)

    .public("abilityExpNeeds",
    function(this, whichLevel)
        local ns = this.prop("abilityExpNeeds")
        must(type(ns) == "table")
        if (type(whichLevel) == "number") then
            return ns[whichLevel] or 0
        else
            return ns
        end
    end)

    .public("itemHotkey",
    function(this, param)
        if (type(param) == "table") then
            local prev = this.prop("abilityHotkey")
            if (type(prev) == "table") then
                for _, k in ipairs(prev) do
                    keyboard.onRelease(KEYBOARD[k], "itemHotkey", nil)
                end
            end
            for idx, key in ipairs(param) do
                keyboard.onRelease(KEYBOARD[key], "itemHotkey", function(evtData)
                    local selection = evtData.triggerPlayer.selection()
                    if (isObject(selection, "Unit") == false) then
                        return
                    end
                    if (selection.isDestroy()) then
                        return
                    end
                    Cursor().itemQuote(selection.itemSlot().storage()[idx])
                end)
            end
            return this.prop("itemHotkey", param)
        end
        if (type(param) == "number") then
            return this.prop("itemHotkey")[param] or ''
        else
            return this.prop("itemHotkey")
        end
    end)

    .public("itemUpgrade",
    function(this, max, fixed, ratio, limit)
        local isModify = max or fixed or ratio or limit
        if (max)
        then this.prop("itemLevelMax", max)
        end
        if (fixed)
        then this.prop("itemExpFixed", fixed)
        end
        if (ratio)
        then this.prop("itemExpRatio", ratio)
        end
        if (limit)
        then this.prop("itemExpLimit", limit)
        end
        local _max = this.prop("itemLevelMax") or 1
        local _fixed = this.prop("itemExpFixed") or 100
        local _radio = this.prop("itemExpRatio") or 1.00
        local _limit = this.prop("itemExpLimit") or 10000
        if (isModify) then
            this.prop("itemExpNeeds", math.expNeeds(_max, _fixed, _radio, _limit))
            return this
        end
        return _max, _fixed, _radio, _limit
    end)

    .public("itemLevelMax",
    function(this)
        return this.prop("itemLevelMax")
    end)

    .public("itemExpNeeds",
    function(this, whichLevel)
        local ns = this.prop("itemExpNeeds")
        must(type(ns) == "table")
        if (type(whichLevel) == "number") then
            return ns[whichLevel] or 0
        else
            return ns
        end
    end)

    .public("unitUpgrade",
    function(this, max, fixed, ratio, limit)
        local isModify = max or fixed or ratio or limit
        if (max) then
            this.prop("unitLevelMax", max)
        end
        if (fixed) then
            this.prop("unitExpFixed", fixed)
        end
        if (ratio) then
            this.prop("unitExpRatio", ratio)
        end
        if (limit) then
            this.prop("unitExpLimit", limit)
        end
        local _max = this.prop("unitLevelMax") or 1
        local _fixed = this.prop("unitExpFixed") or 100
        local _radio = this.prop("unitExpRatio") or 1.00
        local _limit = this.prop("unitExpLimit") or 10000
        if (isModify) then
            this.prop("unitExpNeeds", math.expNeeds(_max, _fixed, _radio, _limit))
            return this
        end
        return _max, _fixed, _radio, _limit
    end)

    .public("unitLevelMax",
    function(this)
        return this.prop("unitLevelMax")
    end)

    .public("unitExpNeeds",
    function(this, whichLevel)
        local ns = this.prop("unitExpNeeds")
        must(type(ns) == "table")
        if (type(whichLevel) == "number") then
            return ns[whichLevel] or 0
        else
            return ns
        end
    end)

    .public("warehouseSlot",
    function(this, max)
        local isModify = max
        if (max) then this.prop("warehouseSlotMax", max) end
        if (isModify) then
            return this
        end
        return this.prop("warehouseSlotMax")
    end)

    .public("unCommand",
    function(this, pattern)
        if (type(pattern) == "string") then
            for i = 1, BJ_MAX_PLAYERS, 1 do
                Player(i).onChat(pattern, nil)
            end
        end
        return this
    end)

    .public("command",
    function(this, pattern, callFunc)
        if (type(pattern) == "string") then
            for i = 1, BJ_MAX_PLAYERS, 1 do
                Player(i).onChat(pattern, callFunc)
            end
        end
        return this
    end)

    .public("worth",
    function(this, key, name, convert)
        ---@type Array
        local wor = this.prop("worth")
        if (key ~= nil and name ~= nil) then
            wor.set(key, { name = name, convert = convert })
            this.prop("worthConvert", NIL)
            return this
        end
        if (key == nil) then
            return wor
        end
        return wor.get(key)
    end)

    .public("worthConvert",
    function(this, key)
        local cov = this.prop("worthConvert")
        if (cov == nil) then
            local wor = this.prop("worth")
            cov = Array()
            this.prop("worthConvert", cov)
            wor.forEach(function(k, v)
                if (v.convert ~= nil) then
                    cov.set(v.convert[1], { k, v.convert[2] })
                end
            end)
        end
        if (key == nil) then
            return cov
        end
        return cov.get(key)
    end)

    .public("worthU2L",
    function(this, data)
        local turn = {}
        if (type(data) == "table") then
            ---@type Array
            local cvt = this.worthConvert()
            local rev = {}
            local keys = cvt.keys()
            this.worth().forEach(function(key, _)
                local value = cvt.get(key)
                if (value) then
                    rev[value[1]] = { key, value[2] }
                    turn[key] = data[key] or 0
                else
                    turn[key] = data[key]
                end
            end)
            local run = true
            while (run) do
                local count = 0
                for _, k in ipairs(keys) do
                    if (rev[k] ~= nil) then
                        if (turn[rev[k][1]] == nil) then
                            turn[rev[k][1]] = 0
                        end
                        if (turn[k] ~= 0) then
                            turn[rev[k][1]] = turn[rev[k][1]] + turn[k] * rev[k][2]
                            turn[k] = 0
                            count = count + 1
                        end
                    end
                end
                run = (count > 0)
            end
        end
        return turn
    end)

    .public("worthL2U",
    function(this, data)
        local turn = {}
        if (type(data) == "table") then
            ---@type Array
            local cvt = this.worthConvert()
            local rev = {}
            local keys = cvt.keys()
            this.worth().forEach(function(key, _)
                local value = cvt.get(key)
                if (value) then
                    rev[key] = { value[1], value[2] }
                    turn[key] = data[key] or 0
                else
                    turn[key] = data[key]
                end
            end)
            local run = true
            while (run) do
                local count = 0
                for _, k in ipairs(keys) do
                    if (rev[k] ~= nil) then
                        for i = 10, 0, -1 do
                            local d = math.floor(10 ^ i)
                            local rd = rev[k][2] * d
                            while (turn[k] >= rd) do
                                turn[k] = turn[k] - rd
                                turn[rev[k][1]] = (turn[rev[k][1]] or 0) + d
                                count = count + 1
                            end
                        end
                    end
                end
                run = (count > 0)
            end
        end
        return turn
    end)

    .public("worthCale",
    function(this, data1, operator, data2)
        local keys = this.worth().keys()
        local res
        if (operator == "*" or operator == "/") then
            local ratio = 0
            if (type(data1) == "table" or type(data2) == "number") then
                res = this.worthU2L(data1)
                ratio = data2
            end
            if (type(data1) == "number" or type(data2) == "table") then
                res = this.worthU2L(data2)
                ratio = data1
            end
            for _, k in ipairs(keys) do
                if (type(res[k]) == "number") then
                    if (operator == "*") then
                        res[k] = res[k] * ratio
                    elseif (operator == "/") then
                        res[k] = res[k] / ratio
                    end
                end
            end
        elseif (operator == "+" or operator == "-") then
            if (type(data1) == "table" and type(data2) == "table") then
                res = this.worthU2L(data1)
                data2 = this.worthU2L(data2)
                for _, k in ipairs(keys) do
                    res[k] = res[k] or 0
                    if (type(data2[k]) == "number") then
                        if (operator == "+") then
                            res[k] = res[k] + data2[k]
                        elseif (operator == "-") then
                            res[k] = res[k] - data2[k]
                        end
                    end
                end
            end
        end
        if (res == nil) then
            stack("wrong cale")
            return data1
        end
        return this.worthL2U(res)
    end)

    .public("worthFloor",
    function(this, data)
        data = this.worthU2L(data)
        for _, k in ipairs(this.worth().keys()) do
            if (type(data[k]) == "number") then
                data[k] = math.floor(data[k])
            end
        end
        return this.worthL2U(data)
    end)

    .public("worthCeil",
    function(this, data)
        data = this.worthU2L(data)
        for _, k in ipairs(this.worth().keys()) do
            if (type(data[k]) == "number") then
                data[k] = math.ceil(data[k])
            end
        end
        return this.worthL2U(data)
    end)

    .public("worthRound",
    function(this, data)
        data = this.worthU2L(data)
        for _, k in ipairs(this.worth().keys()) do
            if (type(data[k]) == "number") then
                data[k] = math.round(data[k])
            end
        end
        return this.worthL2U(data)
    end)

    .public("worthCompare",
    function(this, data1, data2)
        if (data1 == nil or data2 == nil) then
            return nil
        end
        local lower1 = this.worthU2L(data1)
        local lower2 = this.worthU2L(data2)
        local keys = this.prop("worth").keys()
        local result = { g = 0, l = 0 }
        for _, k in ipairs(keys) do
            local d1 = lower1[k] or 0
            local d2 = lower2[k] or 0
            if (d1 > d2) then
                result.g = result.g + 1
            elseif (d1 < d2) then
                result.l = result.l + 1
            end
        end
        if (result.g == 0 and result.l == 0) then
            return 0
        end
        if (result.g > 0 and result.l > 0) then
            return nil
        end
        if (result.g > 0) then
            return true
        end
        if (result.l > 0) then
            return false
        end
    end)

    .public("worthEqual",
    function(this, data1, data2)
        return this.worthCompare(data1, data2) == 0
    end)

    .public("worthGreater",
    function(this, data1, data2)
        return this.worthCompare(data1, data2) == true
    end)

    .public("worthLess",
    function(this, data1, data2)
        return this.worthCompare(data1, data2) == false
    end)

    .public("worthEqualOrGreater",
    function(this, data1, data2)
        local res = this.worthCompare(data1, data2)
        return res == true or res == 0
    end)

    .public("worthEqualOrLess",
    function(this, data1, data2)
        local res = this.worthCompare(data1, data2)
        return res == false or res == 0
    end)