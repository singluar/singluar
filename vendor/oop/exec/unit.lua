---@param this Unit
---@param resultNum number
---@param resultStr string
Class("Unit")
    .exec("attributes",
    function(this, resultAttributes)
        local eKey = "attributes"
        event.unregister(this, EVENT.Unit.Born, eKey)
        event.unregister(this, EVENT.Unit.LevelChange, eKey)
        if (type(resultAttributes) == "table") then
            for i = #resultAttributes, 1, -1 do
                local method = resultAttributes[i][1]
                local base = resultAttributes[i][2]
                local vary = resultAttributes[i][3]
                if (type(method) ~= "string" or (base == nil and vary == nil)) then
                    table.remove(resultAttributes, i)
                end
            end
            local prev = this.prop("attributes")
            if (type(prev) == "table") then
                local lv = this.level()
                attribute.clever(prev, this, lv, -lv)
                attribute.clever(resultAttributes, this, 0, lv)
            end
            ---@param getData noteOnUnitBornData
            this.onEvent(EVENT.Unit.Born, eKey, function(getData)
                attribute.clever(resultAttributes, getData.triggerUnit, 0, getData.triggerUnit.level())
            end)
            ---@param lvcData noteOnUnitLevelChangeData
            this.onEvent(EVENT.Unit.LevelChange, eKey, function(lvcData)
                attribute.clever(resultAttributes, lvcData.triggerUnit, lvcData.triggerUnit.level(), lvcData.value)
            end)
        end
    end)
    .exec("sight",
    function(this, resultNum)
        local diff = math.floor(resultNum - this.prop("sightBase"))
        ability.sight(this.__HANDLE__, diff)
        PropChange(this, "nsight", "std", resultNum - this.prop("sightDiff"), false)
    end)
    .exec("nsight",
    function(this, resultNum)
        if (this.prop("sight") ~= nil) then
            local diff = math.floor(resultNum + this.prop("sightDiff") - this.prop("sightBase"))
            ability.sight(this.__HANDLE__, diff)
            PropChange(this, "sight", "std", resultNum + this.prop("sightDiff"), false)
        end
    end)
    .exec("attackSpaceBase",
    function(this, resultNum)
        resultNum = math.min(5, math.max(0.1, resultNum))
        local attackSpeed = this.prop("attackSpeed") or 0
        if (attackSpeed ~= 0) then
            resultNum = math.trunc(resultNum / (1 + math.min(math.max(attackSpeed, -80), 400) * 0.01))
        end
        japi.SetUnitState(this.__HANDLE__, UNIT_STATE_ATTACK_SPACE, resultNum)
        this.prop("attackSpace", resultNum)
    end)
    .exec("attackSpeed",
    function(this, resultNum)
        resultNum = math.min(400, math.max(-80, resultNum))
        local space = math.trunc(this.prop("attackSpaceBase") / (1 + resultNum * 0.01))
        space = math.min(5, math.max(0.1, space))
        japi.SetUnitState(this.__HANDLE__, UNIT_STATE_ATTACK_SPACE, space)
        this.prop("attackSpace", space)
    end)
    .exec("attackRangeAcquire",
    function(this, resultNum)
        resultNum = math.floor(resultNum)
        resultNum = math.min(9999, math.max(100 + (this.prop("attackRange") or 0), resultNum))
        J.SetUnitAcquireRange(this.__HANDLE__, resultNum)
    end)
    .exec("attackRange",
    function(this, resultNum)
        resultNum = math.floor(resultNum)
        resultNum = math.min(9999, math.max(0, resultNum))
        japi.SetUnitState(this.__HANDLE__, UNIT_STATE_ATTACK_RANGE, resultNum)
        local atkRangeAcquire = this.prop("attackRangeAcquire")
        local ac = resultNum + 100
        if (atkRangeAcquire == nil or atkRangeAcquire < ac) then
            this.prop("attackRangeAcquire", ac)
            J.SetUnitAcquireRange(this.__HANDLE__, ac)
        end
    end)
    .exec("hp",
    function(this, resultNum)
        local hp = this.prop("hp")
        if (type(hp) == "number" and hp > 0) then
            local cur = this.prop("hpCur") or resultNum
            local percent = math.trunc(cur / hp)
            this.prop("hpCur", math.max(1, math.max(0, percent) * resultNum))
        end
    end)
    .exec("hpCur",
    function(this, resultNum)
        local hp = this.prop("hp")
        if (hp ~= nil) then
            local hpc = resultNum / hp * 1e4
            if (resultNum >= 1) then
                hpc = math.max(1, hpc)
            end
            J.SetUnitState(this.__HANDLE__, UNIT_STATE_LIFE, hpc)
            if (resultNum < hp) then
                monitor.listen("monitor-life_back", this)
            else
                if (this.prop("hpRegen") >= 0) then
                    monitor.ignore("monitor-life_back", this)
                else
                    monitor.listen("monitor-life_back", this)
                end
            end
        end
    end)
    .exec("hpRegen",
    function(this, resultNum)
        if (resultNum ~= nil and resultNum ~= 0) then
            monitor.listen("monitor-life_back", this)
        else
            monitor.ignore("monitor-life_back", this)
        end
    end)
    .exec("mp",
    function(this, resultNum)
        if (resultNum == 0) then
            this.prop("mpCur", 0)
        else
            local mp = this.prop("mp")
            if (type(mp) == "number" and mp > 0) then
                local cur = this.prop("mpCur") or resultNum
                local percent = math.trunc(cur / mp)
                this.prop("mpCur", math.max(1, math.max(0, percent) * resultNum))
            end
        end
    end)
    .exec("mpCur",
    function(this, resultNum)
        local mp = this.prop("mp")
        if (mp ~= nil and mp > 0) then
            if (resultNum < mp) then
                monitor.listen("monitor-mana_back", this)
            else
                if (this.prop("mpRegen") >= 0) then
                    monitor.ignore("monitor-mana_back", this)
                else
                    monitor.listen("monitor-mana_back", this)
                end
            end
        end
    end)
    .exec("mpRegen",
    function(this, resultNum)
        if (resultNum ~= nil and resultNum ~= 0) then
            monitor.listen("monitor-mana_back", this)
        else
            monitor.ignore("monitor-mana_back", this)
        end
    end)
    .exec("move",
    function(this, resultNum)
        resultNum = math.floor(resultNum)
        resultNum = math.min(522, math.max(0, resultNum))
        J.SetUnitMoveSpeed(this.__HANDLE__, resultNum)
    end)
    .exec("punish",
    function(this, resultNum)
        resultNum = math.floor(resultNum)
        resultNum = math.max(0, resultNum)
        if (this.prop("punishCur") == nil or this.prop("punish") <= 0) then
            this.prop("punishCur", resultNum)
        end
    end)
    .exec("punishCur",
    function(this, resultNum)
        local punish = this.prop("punish")
        if (punish == nil or punish <= 0) then
            monitor.ignore("monitor-punish_back", this)
        else
            resultNum = math.min(punish, resultNum)
            if (resultNum <= 0) then
                if (this.isPunishing() ~= true) then
                    monitor.ignore("monitor-punish_back", this)
                    if (this.isAlive()) then
                        local percent = 50
                        local resistance = this.resistance("punish")
                        if (resistance > 0) then
                            percent = percent - resistance
                            if (percent < 5) then
                                percent = 5
                            end
                        end
                        local dur = 5
                        local reduceAtkSpd = math.floor(percent)
                        local reduceMove = math.floor(percent * 0.01 * math.min(522, this.prop("move")))
                        this.prop("attackSpeed", "-=" .. reduceAtkSpd .. ";" .. dur)
                        this.prop("move", "-=" .. reduceMove .. ";" .. dur)
                        this.prop("animateScale", "-=" .. percent * 0.005 .. ";" .. dur)
                        --- 触发硬直事件
                        this.superposition("punish", "+=1")
                        event.trigger(this, EVENT.Unit.Punish, { triggerUnit = this, sourceUnit = this.lastHurtSource(), percent = percent, duration = dur })
                        time.setTimeout(dur + 0.5, function()
                            this.superposition("punish", "-=1")
                            this.punishCur(this.punish())
                        end)
                    end
                end
            elseif (resultNum < punish) then
                monitor.listen("monitor-punish_back", this)
            end
        end
    end)
    .exec("punishRegen",
    function(this, _)
        local punish = this.prop("punish")
        if (punish == nil or punish <= 0) then
            monitor.ignore("monitor-punish_back", this)
        elseif (this.isPunishing()) then
            monitor.ignore("monitor-punish_back", this)
        else
            monitor.listen("monitor-punish_back", this)
        end
    end)
    .exec("modelAlias",
    function(this, resultStr)
        if (this.prop("modelAlias") ~= resultStr) then
            japi.DzSetUnitID(this.__HANDLE__, c2i(slk.n2i(resultStr .. "|U")))
            PropChange(this, "modelAlias", "std", resultStr, false)
            PropReExec(this)
        end
    end)
    .exec("modelScale",
    function(this, resultNum)
        J.SetUnitScale(this.__HANDLE__, resultNum, resultNum, resultNum)
    end)
    .exec("animateScale",
    function(this, resultNum)
        J.SetUnitTimeScale(this.__HANDLE__, resultNum)
    end)
    .exec("turnSpeed",
    function(this, resultNum)
        J.SetUnitTurnSpeed(this.__HANDLE__, resultNum)
    end)
    .exec("rgba",
    function(this, result)
        local prev = this.prop("rgba")
        result[1] = prev[1]
        result[2] = prev[2]
        result[3] = prev[3]
        result[4] = prev[4]
        J.SetUnitVertexColor(this.__HANDLE__, result[1], result[2], result[3], result[4])
    end)
    .exec("moveType",
    function(this, result)
        if (result ~= UNIT_MOVE_TYPE.fly) then
            this.prop("moveTypePrev", result)
        end
        time.setTimeout(0, function()
            if (result == UNIT_MOVE_TYPE.foot) then
                japi.EXSetUnitMoveType(this.__HANDLE__, MOVE_TYPE_FOOT)
            elseif (result == UNIT_MOVE_TYPE.fly) then
                japi.EXSetUnitMoveType(this.__HANDLE__, MOVE_TYPE_FLY)
            elseif (result == UNIT_MOVE_TYPE.amphibious) then
                japi.EXSetUnitMoveType(this.__HANDLE__, MOVE_TYPE_AMPH)
            elseif (result == UNIT_MOVE_TYPE.float) then
                japi.EXSetUnitMoveType(this.__HANDLE__, MOVE_TYPE_FLOAT)
            end
        end)
    end)
    .exec("period",
    function(this, resultNum)
        if (isObject(this.prop("periodTimer"), "Timer")) then
            this.prop("periodTimer").destroy()
            this.prop("periodTimer", NIL)
        end
        if (resultNum > 0) then
            this.prop("periodTimer", time.setTimeout(resultNum, function()
                this.prop("periodTimer", NIL)
                J.KillUnit(this.__HANDLE__)
            end))
        end
    end)
    .exec("flyHeight",
    function(this, resultNum)
        J.UnitAddAbility(this.__HANDLE__, SINGLUAR_ID["ability_fly"])
        J.UnitRemoveAbility(this.__HANDLE__, SINGLUAR_ID["ability_fly"])
        J.SetUnitFlyHeight(this.__HANDLE__, resultNum, 9999)
        if (resultNum > 0) then
            this.prop("moveType", UNIT_MOVE_TYPE.fly)
        else
            this.prop("moveType", this.prop("moveTypePrev") or UNIT_MOVE_TYPE.foot)
        end
    end)
    .exec("exp",
    function(this, resultNum)
        local prevLv = this.prop("level") or 0
        if (prevLv >= 1) then
            local lv = 0
            for i = Game().unitLevelMax(), 1, -1 do
                if (resultNum >= Game().unitExpNeeds(i)) then
                    lv = i
                    break
                end
            end
            if (lv ~= prevLv) then
                if (lv > prevLv) then
                    this.prop("level", lv)
                elseif (lv < prevLv) then
                    this.prop("level", lv)
                end
            end
        end
    end)
    .exec("level",
    function(this, resultNum)
        local prevLv = this.prop("level") or 0
        if (resultNum > 1 and resultNum > prevLv) then
            this.effect("AIemTarget", 0)
            PropChange(this, "exp", "std", Game().unitExpNeeds(resultNum), false)
        elseif (resultNum < prevLv) then
            this.effect("DispelMagicTarget", 0)
            PropChange(this, "exp", "std", Game().unitExpNeeds(resultNum), false)
        end
        event.trigger(this, EVENT.Unit.LevelChange, { triggerUnit = this, value = resultNum - prevLv })
    end)
    .exec("owner",
    function(this, result)
        J.SetUnitOwner(this.__HANDLE__, result.handle(), true)
    end)
    .exec("teamColor",
    function(this, resultNum)
        J.SetUnitColor(this.__HANDLE__, PLAYER_COLOR[resultNum])
    end)
    .exec("orderRoute",
    function(this, result)
        local prev = this.prop("orderRoute")
        if (false == datum.equal(prev, result)) then
            this.prop("orderRouteIdx", 1)
        end
        event.register(this, EVENT.Unit.MoveRoute, "SLOrderRoute", function(evtData)
            local u = evtData.triggerUnit
            local r = u.prop("orderRoute")
            local i = u.prop("orderRouteIdx")
            if (i > 0 and i <= #r) then
                local call = r[i][3]
                if (evtData.inc == true) then
                    i = i + 1
                end
                if (i > #r and u.prop("orderRouteLoop")) then
                    i = 1
                end
                u.prop("orderRouteIdx", i)
                if (evtData.inc == true and type(call) == "function") then
                    u.orderRoutePause()
                    call(u)
                else
                    if (i > 0 and i <= #r) then
                        u.orderMove(r[i][1], r[i][2])
                    else
                        u.orderRouteDestroy()
                    end
                end
            else
                u.orderRouteDestroy()
            end
        end)
        if (prev == nil) then
            PropChange(this, "orderRoute", "std", result, false)
        end
        this.orderRouteResume()
    end)
    .exec("<SUPERPOSITION>collision",
    function(this, resultNum)
        J.SetUnitPathing(this.__HANDLE__, resultNum > 0)
    end)
    .exec("<SUPERPOSITION>select",
    function(this, resultNum)
        if (resultNum > 0) then
            if (J.GetUnitAbilityLevel(this.__HANDLE__, SINGLUAR_ID["ability_locust"]) >= 1) then
                J.UnitRemoveAbility(this.__HANDLE__, SINGLUAR_ID["ability_locust"])
            end
        else
            if (J.GetUnitAbilityLevel(this.__HANDLE__, SINGLUAR_ID["ability_locust"]) < 1) then
                J.UnitAddAbility(this.__HANDLE__, SINGLUAR_ID["ability_locust"])
            end
        end
    end)
    .exec("<SUPERPOSITION>attack",
    function(this, resultNum)
        local isAttackAble = this.prop("isAttackAble")
        if (resultNum > 0 and isAttackAble == false) then
            this.prop("isAttackAble", true)
            japi.DzUnitDisableAttack(this.__HANDLE__, false)
        elseif (resultNum <= 0 and isAttackAble == true) then
            this.prop("isAttackAble", false)
            japi.DzUnitDisableAttack(this.__HANDLE__, true)
        end
    end)
    .exec("<SUPERPOSITION>invulnerable",
    function(this, resultNum)
        if (resultNum > 0) then
            if (J.GetUnitAbilityLevel(this.__HANDLE__, SINGLUAR_ID["ability_invulnerable"]) < 1) then
                J.UnitAddAbility(this.__HANDLE__, SINGLUAR_ID["ability_invulnerable"])
            end
        else
            if (J.GetUnitAbilityLevel(this.__HANDLE__, SINGLUAR_ID["ability_invulnerable"]) >= 1) then
                J.UnitRemoveAbility(this.__HANDLE__, SINGLUAR_ID["ability_invulnerable"])
            end
        end
    end)
    .exec("<SUPERPOSITION>invisible",
    function(this, resultNum)
        if (resultNum > 0) then
            if (J.GetUnitAbilityLevel(this.__HANDLE__, SINGLUAR_ID["ability_invisible"]) < 1) then
                J.UnitAddAbility(this.__HANDLE__, SINGLUAR_ID["ability_invisible"])
            end
        else
            if (J.GetUnitAbilityLevel(this.__HANDLE__, SINGLUAR_ID["ability_invisible"]) >= 1) then
                J.UnitRemoveAbility(this.__HANDLE__, SINGLUAR_ID["ability_invisible"])
            end
        end
    end)
    .exec("<SUPERPOSITION>pause",
    function(this, resultNum)
        J.PauseUnit(this.__HANDLE__, resultNum > 0)
    end)
    .exec("<SUPERPOSITION>show",
    function(this, resultNum)
        J.ShowUnit(this.__HANDLE__, resultNum > 0)
    end)