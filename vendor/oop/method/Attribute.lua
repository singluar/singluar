---@param this Attribute
Class("Attribute")

    .public("missile",
    function(this)
        ---@type Missile[]
        local missiles = this.prop("missile")
        if (#missiles == 0) then
            return nil
        end
        local len = #missiles
        local mc = missiles[len]
        for i = (len - 1), 1, -1 do
            local m = missiles[i]
            if (m.priority() > mc.priority()) then
                mc = m
            end
        end
        return mc
    end)

    .public("missilePush",
    function(this, missile)
        if (isObject(missile, "Missile")) then
            ---@type Missile[]
            local missiles = this.prop("missile")
            table.insert(missiles, missile)
        end
        return this
    end)

    .public("missileRemove",
    function(this, missileId)
        if (type(missileId) == "string") then
            ---@type Missile[]
            local missiles = this.prop("missile")
            if (#missiles > 0) then
                for i = #missiles, 1, -1 do
                    if (missiles[i].id() == missileId) then
                        table.remove(missiles, i)
                    end
                end
            end
        end
        return this
    end)

    .public("lightning",
    function(this)
        ---@type Lightning[]
        local lightnings = this.prop("lightning")
        if (#lightnings == 0) then
            return nil
        end
        local len = #lightnings
        local lt = lightnings[len]
        for i = (len - 1), 1, -1 do
            local l = lightnings[i]
            if (l.priority() > lt.priority()) then
                lt = l
            end
        end
        return lt
    end)

    .public("lightningPush",
    function(this, lightning)
        if (isObject(lightning, "Lightning")) then
            ---@type Lightning[]
            local lightnings = this.prop("lightning")
            table.insert(lightnings, lightning)
        end
        return this
    end)

    .public("lightningRemove",
    function(this, lightningId)
        if (type(lightningId) == "string") then
            ---@type Lightning[]
            local lightnings = this.prop("lightning")
            if (#lightnings > 0) then
                for i = #lightnings, 1, -1 do
                    if (lightnings[i].id() == lightnings) then
                        table.remove(lightnings, i)
                    end
                end
            end
        end
        return this
    end)

    .public("reborn",
    function(this, modify)
        return this.prop("reborn", modify)
    end)

    .public("hp",
    function(this, modify)
        return this.prop("hp", modify)
    end)

    .public("hpCur",
    function(this, modify)
        return this.prop("hpCur", modify)
    end)

    .public("hpRegen",
    function(this, modify)
        return this.prop("hpRegen", modify)
    end)

    .public("hpSuckAttack",
    function(this, modify)
        return this.prop("hpSuckAttack", modify)
    end)

    .public("hpSuckAbility",
    function(this, modify)
        return this.prop("hpSuckAbility", modify)
    end)

    .public("mp",
    function(this, modify)
        return this.prop("mp", modify)
    end)

    .public("mpCur",
    function(this, modify)
        return this.prop("mpCur", modify)
    end)

    .public("mpRegen",
    function(this, modify)
        return this.prop("mpRegen", modify)
    end)

    .public("mpSuckAttack",
    function(this, modify)
        return this.prop("mpSuckAttack", modify)
    end)

    .public("mpSuckAbility",
    function(this, modify)
        return this.prop("mpSuckAbility", modify)
    end)

    .public("sight",
    function(this, modify)
        return this.prop("sight", modify)
    end)

    .public("nsight",
    function(this, modify)
        return this.prop("nsight", modify)
    end)

    .public("sightBase",
    function(this, modify)
        return this.prop("sightBase", modify)
    end)

    .public("sightDiff",
    function(this, modify)
        return this.prop("sightDiff", modify)
    end)

    .public("attack",
    function(this, modify)
        return this.prop("attack", modify)
    end)

    .public("attackSpaceBase",
    function(this, modify)
        return this.prop("attackSpaceBase", modify)
    end)

    .public("attackSpace",
    function(this)
        return this.prop("attackSpace")
    end)

    .public("attackSpeed",
    function(this, modify)
        return this.prop("attackSpeed", modify)
    end)

    .public("attackRangeAcquire",
    function(this, modify)
        return this.prop("attackRangeAcquire", modify)
    end)

    .public("attackRange",
    function(this, modify)
        return this.prop("attackRange", modify)
    end)

    .public("attackRipple",
    function(this, modify)
        return this.prop("attackRipple", modify)
    end)

    .public("defend",
    function(this, modify)
        return this.prop("defend", modify)
    end)

    .public("move",
    function(this, modify)
        return this.prop("move", modify)
    end)

    .public("str",
    function(this, modify)
        return this.prop("str", modify)
    end)

    .public("agi",
    function(this, modify)
        return this.prop("agi", modify)
    end)

    .public("int",
    function(this, modify)
        return this.prop("int", modify)
    end)

    .public("cure",
    function(this, modify)
        return this.prop("cure", modify)
    end)

    .public("avoid",
    function(this, modify)
        return this.prop("avoid", modify)
    end)

    .public("aim",
    function(this, modify)
        return this.prop("aim", modify)
    end)

    .public("punish",
    function(this, modify)
        return this.prop("punish", modify)
    end)

    .public("punishCur",
    function(this, modify)
        return this.prop("punishCur", modify)
    end)

    .public("punishRegen",
    function(this, modify)
        return this.prop("punishRegen", modify)
    end)

    .public("weight",
    function(this, modify)
        return this.prop("weight", modify)
    end)

    .public("weightCur",
    function(this, modify)
        return this.prop("weightCur", modify)
    end)

    .public("hurtIncrease",
    function(this, modify)
        return this.prop("hurtIncrease", modify)
    end)

    .public("hurtReduction",
    function(this, modify)
        return this.prop("hurtReduction", modify)
    end)

    .public("hurtRebound",
    function(this, modify)
        return this.prop("hurtRebound", modify)
    end)

    .public("damageIncrease",
    function(this, modify)
        return this.prop("damageIncrease", modify)
    end)

    .public("crit",
    function(this, modify)
        return this.prop("crit", modify)
    end)

    .public("cost",
    function(this, modify)
        return this.prop("cost", modify)
    end)

    .public("castChant",
    function(this, modify)
        return this.prop("castChant", modify)
    end)

    .public("coolDown",
    function(this, modify)
        return this.prop("coolDown", modify)
    end)

    .public("coolDownSec",
    function(this, modify)
        return this.prop("coolDownSec", modify)
    end)

    .public("odds",
    function(this, key, modify)
        if (modify ~= nil) then
            this.prop("<ODDS>" .. key, modify)
            return this
        end
        return this.prop("<ODDS>" .. key) or 0
    end)

    .public("resistance",
    function(this, key, modify)
        if (modify ~= nil) then
            this.prop("<RESISTANCE>" .. key, modify)
            return this
        end
        return this.prop("<RESISTANCE>" .. key) or 0
    end)

    .public("enchant",
    function(this, key, modify)
        if (modify ~= nil) then
            this.prop("e_" .. key, modify)
            return this
        end
        return this.prop("e_" .. key) or 0
    end)

    .public("enchantResistance",
    function(this, key, modify)
        if (modify ~= nil) then
            this.resistance("e_" .. key, modify)
            return this
        end
        return this.resistance("e_" .. key) or 0
    end)

    .public("enchantWeapon",
    function(this, key, modify)
        if (modify ~= nil) then
            this.prop("<WEAPON>e_" .. key, modify)
            return this
        end
        return this.prop("<WEAPON>e_" .. key) or 0
    end)

    .public("enchantAppend",
    function(this, key, modify)
        if (modify ~= nil) then
            this.prop("<APPEND>e_" .. key, modify)
            return this
        end
        return this.prop("<APPEND>e_" .. key) or 0
    end)