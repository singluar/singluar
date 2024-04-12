---@param this Team
Class("Team")

    .public("nameSync",
    function(this, modify)
        if (type(modify) == "boolean") then
            if (true == modify and this.name()) then
                local ms = this.members()
                if (#ms > 0) then
                    for _, i in ipairs(ms) do
                        Player(i).name(this.name())
                    end
                end
            end
            return this.prop("nameSync", modify)
        end
        return this.prop("nameSync")
    end)

    .public("colorSync",
    function(this, modify)
        if (type(modify) == "boolean") then
            if (true == modify and this.color()) then
                local ms = this.members()
                if (#ms > 0) then
                    for _, i in ipairs(ms) do
                        Player(i).teamColor(this.color())
                    end
                end
            end
            return this.prop("colorSync", modify)
        end
        return this.prop("colorSync")
    end)

    .public("name",
    function(this, modify)
        local prev = this.prop("name")
        if (modify == nil) then
            return prev
        end
        if (prev ~= modify) then
            this.prop("name", modify)
            if (true == this.nameSync()) then
                local ms = this.members()
                if (#ms > 0) then
                    for _, i in ipairs(ms) do
                        if (modify) then
                            Player(i).name(modify)
                        end
                    end
                end
            end
        end
        return this
    end)

    .public("color",
    function(this, modify)
        local prev = this.prop("color")
        if (modify == nil) then
            return prev
        end
        if (prev ~= modify) then
            this.prop("color", modify)
            if (true == this.colorSync()) then
                local ms = this.members()
                if (#ms > 0) then
                    if (modify) then
                        for _, i in ipairs(ms) do
                            Player(i).teamColor(modify)
                        end
                    end
                end
            end
        end
        return this
    end)

    .public("members",
    function(this, modify)
        if (modify ~= nil) then
            if (type(modify) ~= "table") then
                return this
            end
            local pls = {}
            local c, mn
            if (this.colorSync()) then
                c = this.color()
            end
            if (this.colorSync()) then
                mn = this.name()
            end
            for _, m in ipairs(modify) do
                if (type(m) == "number") then
                    if (false == table.includes(pls, m)) then
                        table.insert(pls, m)
                        if (c ~= nil) then
                            Player(m).teamColor(c)
                        end
                        if (mn ~= nil) then
                            Player(m).name(mn)
                        end
                    end
                end
            end
            this.prop("members", pls)
            -- 联盟
            if (#pls > 0) then
                for _, i in ipairs(pls) do
                    for _, j in ipairs(pls) do
                        if (i ~= j) then
                            alliance.ally(Player(i), Player(j), true)
                            alliance.vision(Player(i), Player(j), true)
                            alliance.control(Player(i), Player(j), false)
                            alliance.fullControl(Player(i), Player(j), false)
                        end
                    end
                end
            end
            return this
        end
        return this.prop("members")
    end)

    .public("unit",
    function(this, tpl, x, y, facing)
        local ms = this.members()
        must(#ms > 0)
        local counter = this.prop("counter")
        local i = 0
        local c = 101
        for _, m in ipairs(ms) do
            if (counter[m] == nil) then
                counter[m] = 0
                i = m
                break
            end
            if (counter[m] < c) then
                i = m
                c = counter[m]
            end
        end
        counter[i] = counter[i] + 1
        if (counter[i] >= 100) then
            for _, m in ipairs(ms) do
                counter[m] = 0
            end
        end
        local u = Player(i).unit(tpl, x, y, facing)
        if (u) then
            u.teamColor(this.color())
        end
        return u
    end)