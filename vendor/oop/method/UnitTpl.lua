---@param this UnitTpl
Class("UnitTpl")

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

    .public("attributes",
    function(this, modify)
        return this.prop("attributes", modify)
    end)

    .private("abilitySlot",
    function(this, modify)
        if (type(modify) == "table") then
            local ms = {}
            for _, m in ipairs(modify) do
                if (isObject(m, "AbilityTpl")) then
                    table.insert(ms, m)
                end
            end
            this.prop("abilitySlot", ms)
            return this
        end
        return this.prop("abilitySlot")
    end)

    .private("itemSlot",
    function(this, modify)
        if (type(modify) == "table") then
            local ms = {}
            for _, m in ipairs(modify) do
                if (isObject(m, "ItemTpl")) then
                    table.insert(ms, m)
                end
            end
            this.prop("itemSlot", ms)
            return this
        end
        return this.prop("itemSlot")
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

    .public("castAnimation",
    function(this, modify)
        return this.prop("castAnimation", modify)
    end)

    .public("keepAnimation",
    function(this, modify)
        return this.prop("keepAnimation", modify)
    end)

    .public("attackPoint",
    function(this, modify)
        return this.prop("attackPoint", modify)
    end)

    .public("turnSpeed",
    function(this, modify)
        return this.prop("turnSpeed", modify)
    end)

    .public("name",
    function(this, modify)
        return this.prop("name", modify)
    end)

    .public("properName",
    function(this, modify)
        return this.prop("properName", modify)
    end)

    .public("rgba",
    function(this, red, green, blue, alpha, duration)
        local modify
        if (type(red) == "number" or type(green) == "number" or type(blue) == "number" or type(alpha) == "number") then
            return this.prop("rgba", { red, green, blue, alpha }, duration)
        end
        return this.prop("rgba", modify)
    end)

    .public("icon",
    function(this, modify)
        return this.prop("icon", AIcon(modify))
    end)

    .public("material",
    function(this, modify)
        return this.prop("material", modify)
    end)

    .public("weaponSoundMode",
    function(this, modify)
        return this.prop("weaponSoundMode", modify)
    end)

    .public("weaponSound",
    function(this, modify)
        return this.prop("weaponSound", modify)
    end)

    .public("weaponLength",
    function(this, modify)
        return this.prop("weaponLength", modify)
    end)

    .public("weaponHeight",
    function(this, modify)
        return this.prop("weaponHeight", modify)
    end)

    .public("moveType",
    function(this, modify)
        return this.prop("moveType", modify)
    end)

    .public("stature",
    function(this, modify)
        return this.prop("stature", modify)
    end)

    .public("period",
    function(this, modify)
        return this.prop("period", modify)
    end)

    .public("primary",
    function(this, modify)
        return this.prop("primary", modify)
    end)

    .public("flyHeight",
    function(this, modify)
        return this.prop("flyHeight", modify)
    end)

    .public("collision",
    function(this, modify)
        return this.prop("collision", modify)
    end)

    .public("levelMax",
    function(this, modify)
        return this.prop("levelMax", modify)
    end)

    .public("level",
    function(this, modify)
        return this.prop("level", modify)
    end)

    .public("abilityPoint",
    function(this, modify)
        return this.prop("abilityPoint", modify)
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