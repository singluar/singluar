---@param this AbilityTpl
Class("AbilityTpl")

    .private("onEvent",
    function(this, evt, ...)
        ---@type Array
        local onEvent = this.prop("onEvent")
        if (onEvent == nil) then
            onEvent = {}
            this.prop("onEvent", onEvent)
        end
        table.insert(onEvent, { evt, ... })
        return this
    end)

    .private("onUnitEvent",
    function(this, evt, ...)
        ---@type Array
        local onUnitEvent = this.prop("onUnitEvent")
        if (onUnitEvent == nil) then
            onUnitEvent = {}
            this.prop("onUnitEvent", onUnitEvent)
        end
        table.insert(onUnitEvent, { evt, ... })
        return this
    end)

    .public("attributes",
    function(this, modify)
        return this.prop("attributes", modify)
    end)

    .public("name",
    function(this, modify)
        return this.prop("name", modify)
    end)

    .public("targetType",
    function(this, modify)
        return this.prop("targetType", modify)
    end)

    .public("icon",
    function(this, modify)
        return this.prop("icon", AIcon(modify))
    end)

    .public("castAnimation",
    function(this, modify)
        return this.prop("castAnimation", modify)
    end)

    .public("keepAnimation",
    function(this, modify)
        return this.prop("keepAnimation", modify)
    end)

    .public("castTargetFilter",
    function(this, modify)
        return this.prop("castTargetFilter", modify)
    end)

    .public("hpCostAdv",
    function(this, base, vary)
        this.prop("hpCostBase", base)
        this.prop("hpCostVary", vary)
        return this
    end)

    .public("mpCostAdv",
    function(this, base, vary)
        this.prop("mpCostBase", base)
        this.prop("mpCostVary", vary)
        return this
    end)

    .public("worthCostAdv",
    function(this, base, vary)
        this.prop("worthCostBase", base)
        this.prop("worthCostVary", vary)
        return this
    end)

    .public("coolDownAdv",
    function(this, base, vary)
        this.prop("coolDownBase", base)
        this.prop("coolDownVary", vary)
        return this
    end)

    .public("castChantAdv",
    function(this, base, vary)
        this.prop("castChantBase", base)
        this.prop("castChantVary", vary)
        return this
    end)

    .public("castKeepAdv",
    function(this, base, vary)
        this.prop("castKeepBase", base)
        this.prop("castKeepVary", vary)
        return this
    end)

    .public("castDistanceAdv",
    function(this, base, vary)
        this.prop("castDistanceBase", base)
        this.prop("castDistanceVary", vary)
        return this
    end)

    .public("castRadiusAdv",
    function(this, base, vary)
        this.prop("castRadiusBase", base)
        this.prop("castRadiusVary", vary)
        return this
    end)

    .public("castWidthAdv",
    function(this, base, vary)
        this.prop("castWidthBase", base)
        this.prop("castWidthVary", vary)
        return this
    end)

    .public("castHeightAdv",
    function(this, base, vary)
        this.prop("castHeightBase", base)
        this.prop("castHeightVary", vary)
        return this
    end)

    .public("hpCost",
    function(this, whichLevel)
        whichLevel = whichLevel or this.level()
        local cost = this.prop("hpCostBase") + (whichLevel - 1) * this.prop("hpCostVary")
        if (type(this.bindUnit) == "function") then
            ---@type Unit
            local u = this.bindUnit()
            if (isObject(u, "Unit")) then
                cost = cost * (1 + 0.01 * u.cost())
            end
        end
        return math.ceil(math.max(0, cost))
    end)

    .public("mpCost",
    function(this, whichLevel)
        whichLevel = whichLevel or this.level()
        local cost = this.prop("mpCostBase") + (whichLevel - 1) * this.prop("mpCostVary")
        if (type(this.bindUnit) == "function") then
            ---@type Unit
            local u = this.bindUnit()
            if (isObject(u, "Unit")) then
                cost = cost * (1 + 0.01 * u.cost())
            end
        end
        return math.ceil(math.max(0, cost))
    end)

    .public("worthCost",
    function(this, whichLevel)
        local base = this.prop("worthCostBase")
        if (base == nil) then
            return
        end
        whichLevel = whichLevel or this.level()
        local worthKeys = Game().worth().keys()
        local val = {}
        local vary
        if (whichLevel > 1) then
            vary = this.prop("worthCostVary")
        end
        for _, k in ipairs(worthKeys) do
            if (type(base[k]) == "number" and base[k] ~= 0) then
                val[k] = base[k]
            end
            if (type(vary) == "table" and type(vary[k]) == "number" and vary[k] ~= 0) then
                val[k] = (val[k] or 0) + (whichLevel - 1) * vary[k]
            end
        end
        if (type(this.bindUnit) == "function") then
            ---@type Unit
            local u = this.bindUnit()
            if (isObject(u, "Unit")) then
                local percent = u.cost()
                val = Game().worthCale(val, "*", 1 + 0.01 * percent)
            end
        end
        return Game().worthL2U(val)
    end)

    .public("coolDown",
    function(this, whichLevel)
        whichLevel = whichLevel or this.level()
        local cd = this.prop("coolDownBase") + (whichLevel - 1) * this.prop("coolDownVary")
        if (type(this.bindUnit) == "function") then
            ---@type Unit
            local u = this.bindUnit()
            if (isObject(u, "Unit")) then
                cd = cd * (1 + 0.01 * u.coolDown()) + u.coolDownSec()
            end
        end
        return math.max(0, math.trunc(cd))
    end)

    .public("castChant",
    function(this, whichLevel)
        whichLevel = whichLevel or this.level()
        local castChant = this.prop("castChantBase") + (whichLevel - 1) * this.prop("castChantVary")
        if (type(this.bindUnit) == "function") then
            ---@type Unit
            local u = this.bindUnit()
            if (isObject(u, "Unit")) then
                castChant = castChant * (1 + 0.01 * u.castChant())
            end
        end
        return math.max(0, math.trunc(castChant, 2))
    end)

    .public("castKeep",
    function(this, whichLevel)
        whichLevel = whichLevel or this.level()
        return math.max(0, math.trunc(this.prop("castKeepBase") + (whichLevel - 1) * this.prop("castKeepVary")))
    end)

    .public("castDistance",
    function(this, whichLevel)
        whichLevel = whichLevel or this.level()
        return math.max(0, math.round(this.prop("castDistanceBase") + (whichLevel - 1) * this.prop("castDistanceVary")))
    end)

    .public("castRadius",
    function(this, whichLevel)
        whichLevel = whichLevel or this.level()
        return math.max(0, math.round(this.prop("castRadiusBase") + (whichLevel - 1) * this.prop("castRadiusVary")))
    end)

    .public("castWidth",
    function(this, whichLevel)
        whichLevel = whichLevel or this.level()
        return math.max(0, math.round(this.prop("castWidthBase") + (whichLevel - 1) * this.prop("castWidthVary")))
    end)

    .public("castHeight",
    function(this, whichLevel)
        whichLevel = whichLevel or this.level()
        return math.max(0, math.round(this.prop("castHeightBase") + (whichLevel - 1) * this.prop("castHeightVary")))
    end)

    .public("levelMax",
    function(this, modify)
        return this.prop("levelMax", modify)
    end)

    .public("level",
    function(this, modify)
        return this.prop("level", modify)
    end)

    .public("levelUpNeedPoint",
    function(this, modify)
        return this.prop("levelUpNeedPoint", modify)
    end)

    .public("description",
    function(this, modify)
        local mType = type(modify)
        if (mType == "string" or mType == "table" or mType == "function") then
            return this.prop("description", modify)
        end
        local desc = {}
        local d = this.prop("description")
        if (type(d) == "string") then
            desc[#desc + 1] = d
        elseif (type(d) == "table") then
            for _, v in ipairs(d) do
                desc[#desc + 1] = v
            end
        elseif (type(d) == "function") then
            desc = d(this)
        end
        return desc
    end)

    .public("banCursor",
    function(this, modify)
        return this.prop("banCursor", modify)
    end)

    .public("isBanCursor",
    function(this, options)
        local cond = this.banCursor()
        if (type(cond) ~= "function") then
            return false
        end
        return cond(options)
    end)