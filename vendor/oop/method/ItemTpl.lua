---@param this ItemTpl
Class("ItemTpl")

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

    .private("ability",
    function(this, modify)
        if (isObject(modify, "AbilityTpl")) then
            this.prop("ability", modify)
            return this
        end
        return this.prop("ability")
    end)

    .public("instance",
    function(this, modify)
        return this.prop("instance", modify)
    end)

    .public("modelId",
    function(this)
        return this.prop("modelId")
    end)

    .public("modelAlias",
    function(this, alias)
        return this.prop("modelAlias", alias)
    end)

    .public("modelScale",
    function(this, modify)
        return this.prop("modelScale", modify)
    end)

    .public("animateScale",
    function(this, modify)
        return this.prop("animateScale", modify)
    end)

    .public("collision",
    function(this, modify)
        return this.prop("collision", modify)
    end)

    .public("class",
    function(this, modify)
        return this.prop("class", modify)
    end)

    .public("name",
    function(this, modify)
        return this.prop("name", modify)
    end)

    .public("icon",
    function(this, modify)
        return this.prop("icon", AIcon(modify))
    end)

    .public("period",
    function(this, modify)
        return this.prop("period", modify)
    end)

    .public("consumable",
    function(this, modify)
        return this.prop("consumable", modify)
    end)

    .public("pawnable",
    function(this, modify)
        return this.prop("pawnable", modify)
    end)

    .public("dropable",
    function(this, modify)
        return this.prop("dropable", modify)
    end)

    .public("charges",
    function(this, modify)
        return this.prop("charges", modify)
    end)

    .public("levelMax",
    function(this, modify)
        return this.prop("levelMax", modify)
    end)

    .public("level",
    function(this, modify)
        return this.prop("level", modify)
    end)

    .public("worth",
    function(this, modify)
        return this.prop("worth", modify)
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