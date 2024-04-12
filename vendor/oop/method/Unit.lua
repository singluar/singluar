---@param this Unit
Class("Unit")

    .public("onEvent",
    function(this, evt, ...)
        event.register(this, evt, ...)
        return this
    end)

    .public("handle",
    function(this)
        return this.__HANDLE__
    end)

    .public("periodRemain",
    function(this)
        ---@type Timer
        local periodTimer = this.prop("periodTimer")
        if (isObject(periodTimer, "Timer")) then
            return periodTimer.remain()
        end
        return -1
    end)

    .public("exp",
    function(this, modify)
        return this.prop("exp", modify)
    end)

    .public("expNeed",
    function(this, whichLevel)
        whichLevel = whichLevel or (1 + this.level())
        whichLevel = math.max(1, whichLevel)
        whichLevel = math.min(Game().unitLevelMax(), whichLevel)
        return Game().unitExpNeeds(math.floor(whichLevel))
    end)

    .public("isSelf",
    function(this, Who)
        return this.id() == Who.id()
    end)

    .public("isOther",
    function(this, Who)
        return not this.isSelf(Who)
    end)

    .public("isEnemy",
    function(this, JudgePlayer)
        return J.IsUnitEnemy(this.handle(), JudgePlayer.handle())
    end)

    .public("isAlly",
    function(this, JudgePlayer)
        return J.IsUnitAlly(this.handle(), JudgePlayer.handle())
    end)

    .public("isAlive",
    function(this)
        return this.prop("isAlive")
    end)

    .public("isDead",
    function(this)
        return not this.prop("isAlive")
    end)

    .public("isGround",
    function(this)
        return this.prop("moveType") == UNIT_MOVE_TYPE.foot
    end)

    .public("isAir",
    function(this)
        return this.prop("moveType") == UNIT_MOVE_TYPE.fly
    end)

    .public("isWater",
    function(this)
        local mt = this.prop("moveType")
        return mt == UNIT_MOVE_TYPE.amphibious or mt == UNIT_MOVE_TYPE.float
    end)

    .public("isMelee",
    function(this)
        return this.missile() == nil and this.lightning() == nil
    end)

    .public("isRanged",
    function(this)
        return this.missile() ~= nil or this.lightning() ~= nil
    end)

    .public("isPause",
    function(this)
        return this.superposition("pause") > 0
    end)

    .public("isShow",
    function(this)
        return this.superposition("show") > 0
    end)

    .public("isCollision",
    function(this)
        return this.superposition("collision") > 0
    end)

    .public("isSelectable",
    function(this)
        return this.superposition("select") > 0
    end)

    .public("isAttackAble",
    function(this)
        return this.prop("isAttackAble") == true
    end)

    .public("isInvulnerable",
    function(this)
        return this.superposition("invulnerable") > 0
    end)

    .public("isInvisible",
    function(this)
        return this.superposition("invisible") > 0
    end)

    .public("isHurting",
    function(this)
        return this.superposition("hurt") > 0
    end)

    .public("isDamaging",
    function(this)
        return this.superposition("damage") > 0
    end)

    .public("isStunning",
    function(this)
        return this.superposition("stun") > 0
    end)

    .public("isPunishing",
    function(this)
        return this.superposition("punish") > 0
    end)

    .public("isSilencing",
    function(this)
        return this.superposition("silent") > 0
    end)

    .public("isUnArming",
    function(this)
        return this.superposition("unArm") > 0
    end)

    .public("isCrackFlying",
    function(this)
        return this.superposition("crackFly") > 0
    end)

    .public("isLeaping",
    function(this)
        return this.superposition("leap") > 0
    end)

    .public("isWhirlwind",
    function(this)
        return this.superposition("whirlwind") > 0
    end)

    .public("isAbilityChantCasting",
    function(this)
        return isObject(this.prop("abilityChantCastTimer"), "Timer")
    end)

    .public("isAbilityKeepCasting",
    function(this)
        return isObject(this.prop("abilityKeepCastTimer"), "Timer")
    end)

    .public("isInterrupt",
    function(this)
        return this.isDead() or this.isStunning() or this.isCrackFlying() or this.isLeaping() or this.isWhirlwind() or this.isSilencing()
    end)

    .public("hasAbility",
    function(this, whichTpl)
        if (false == isObject(whichTpl, "AbilityTpl")) then
            return false
        end
        local has = false
        local ss = this.abilitySlot().storage()
        for _, v in ipairs(ss) do
            if (v.prop("tpl").id() == whichTpl.id()) then
                has = true
                break
            end
        end
        return has
    end)

    .public("hasItem",
    function(this, whichTpl)
        if (false == isObject(whichTpl, "ItemTpl")) then
            return false
        end
        local has = false
        local ss = this.itemSlot().storage()
        for _, v in ipairs(ss) do
            if (v.prop("tpl").id() == whichTpl.id()) then
                has = true
                break
            end
        end
        return has
    end)

    .public("x",
    function(this)
        return J.GetUnitX(this.handle())
    end)

    .public("y",
    function(this)
        return J.GetUnitY(this.handle())
    end)

    .public("z",
    function(this)
        return japi.Z(this.x(), this.y())
    end)

    .public("h",
    function(this)
        return this.z() + this.flyHeight() + this.collision() / 2
    end)

    .public("facing",
    function(this, modify)
        if (modify ~= nil) then
            J.SetUnitFacing(this.handle(), modify)
            return this
        end
        return J.GetUnitFacing(this.handle())
    end)

    .public("owner",
    function(this, modify)
        return this.prop("owner", modify)
    end)

    .public("teamColor",
    function(this, modify)
        return this.prop("teamColor", modify)
    end)

    .public("lastHurtSource",
    function(this, modify)
        return this.prop("lastHurtSource", modify)
    end)

    .public("lastDamageTarget",
    function(this, modify)
        return this.prop("lastDamageTarget", modify)
    end)

    .public("position",
    function(this, x, y)
        if (type(x) == "number" and type(y) == "number") then
            J.SetUnitPosition(this.handle(), x, y)
        end
    end)

    .public("animate",
    function(this, animate)
        if (type(animate) == "string") then
            J.SetUnitAnimation(this.handle(), animate)
        elseif (type(animate) == "number") then
            J.SetUnitAnimationByIndex(this.handle(), math.floor(animate))
        end
    end)

    .public("animateProperties",
    function(this, animate, enable)
        J.AddUnitAnimationProperties(this.handle(), animate, enable)
    end)

    .public("kill",
    function(this)
        J.KillUnit(this.handle())
    end)

    .public("exploded",
    function(this)
        J.SetUnitExploded(this.handle())
        J.KillUnit(this.handle())
    end)

    .public("orderStop",
    function(this)
        J.IssueImmediateOrder(this.handle(), "stop")
    end)

    .public("orderHold",
    function(this)
        J.IssueImmediateOrder(this.handle(), "holdposition")
    end)

    .public("orderAttack",
    function(this, tx, ty)
        J.IssuePointOrder(this.handle(), "attack", tx, ty)
    end)

    .public("orderFollowTargetUnit",
    function(this, targetUnit)
        J.IssueTargetOrder(this.handle(), "move", targetUnit.handle())
    end)

    .public("orderAttackTargetUnit",
    function(this, targetUnit)
        J.IssueTargetOrder(this.handle(), "attack", targetUnit.handle())
    end)

    .public("orderMove",
    function(this, tx, ty)
        J.IssuePointOrder(this.handle(), "move", tx, ty)
    end)

    .public("orderAIMove",
    function(this, tx, ty)
        J.IssuePointOrderById(this.handle(), 851988, tx, ty)
    end)

    .public("orderPatrol",
    function(this, tx, ty)
        J.IssuePointOrderById(this.handle(), 851990, tx, ty)
    end)

    .public("orderRoute",
    function(this, isLoop, routes)
        if (type(routes) == "table" and #routes > 0) then
            this.prop("orderRoute", routes)
            this.prop("orderRouteLoop", isLoop or false)
        else
            this.orderRouteDestroy()
        end
    end)

    .public("orderRouteSet",
    function(this, index, route)
        local r = this.prop("orderRoute")
        if (type(r) == "table") then
            if (index <= 0 or index > (#r + 1)) then
                index = #r + 1
                r[index] = route
            else
                if (route == nil) then
                    table.remove(r, index)
                else
                    r[index] = route
                end
            end
        end
    end)

    .public("orderRouteDestroy",
    function(this)
        event.register(this, EVENT.Unit.MoveRoute, "SLOrderRoute", nil)
        this.prop("orderRoute", NIL)
        this.prop("orderRouteLoop", NIL)
        this.prop("orderRouteIdx", NIL)
        this.prop("orderRoutePause", NIL)
        local t = this.prop("orderRoutePauseTimer")
        if (isObject(t, "Timer")) then
            t.destroy()
            this.prop("orderRoutePauseTimer", NIL)
        end
    end)

    .public("orderRoutePause",
    function(this)
        local i = this.prop("orderRouteIdx")
        if (i >= 1) then
            this.prop("orderRoutePause", i)
            this.prop("orderRoutePauseTimer", time.setTimeout(10, function()
                this.orderRouteDestroy()
            end))
        end
    end)

    .public("orderRouteResume",
    function(this)
        local r = this.prop("orderRoute")
        local i = this.prop("orderRouteIdx")
        this.prop("orderRoutePause", NIL)
        local t = this.prop("orderRoutePauseTimer")
        if (isObject(t, "Timer")) then
            t.destroy()
            this.prop("orderRoutePauseTimer", NIL)
        end
        if (type(r) == "table" and type(i) == "number") then
            this.orderMove(r[i][1], r[i][2])
        end
    end)

    .public("effect",
    function(this, model, duration)
        return effect.xyz(model, this.x(), this.y(), this.h(), duration)
    end)

    .public("attach",
    function(this, model, attach, duration)
        if (model == nil or attach == nil) then
            return
        end
        return effect.attach(model, this, attach, duration)
    end)

    .public("abilitySlot",
    function(this)
        return this.prop("abilitySlot")
    end)

    .public("abilityChantCastingSet",
    function(this)
        ---@type Timer
        local t = this.prop("abilityChantCastTimer")
        if (isObject(t, "Timer")) then
            return t.period() * this.prop("abilityChantCastTimerStatic")
        end
        return 0
    end)

    .public("abilityChantCastingRemain",
    function(this)
        ---@type Timer
        local t = this.prop("abilityChantCastTimer")
        if (isObject(t, "Timer")) then
            return t.period() * (this.prop("abilityChantCastTimerStatic") - this.prop("abilityChantCastTimerInc"))
        end
        return 0
    end)

    .public("abilityKeepCastingSet",
    function(this)
        ---@type Timer
        local t = this.prop("abilityKeepCastTimer")
        if (isObject(t, "Timer")) then
            return t.period() * this.prop("abilityKeepCastTimerStatic")
        end
        return 0
    end)

    .public("abilityKeepCastingRemain",
    function(this)
        ---@type Timer
        local t = this.prop("abilityKeepCastTimer")
        if (isObject(t, "Timer")) then
            return t.period() * (this.prop("abilityKeepCastTimerStatic") - this.prop("abilityKeepCastTimerInc"))
        end
        return 0
    end)

    .public("itemSlot",
    function(this)
        return this.prop("itemSlot")
    end)

    .public("distanceAction",
    function(this, target, judgeDistance, callFunc)
        local distanceTimer = this.prop("distanceTimer")
        if (isObject(distanceTimer, "Timer")) then
            distanceTimer.destroy()
            distanceTimer = nil
            this.prop("distanceTimer", NIL)
        end
        --- 距离判断
        local _x, _y = math.coordinate(target)
        local d1 = math.distance(_x, _y, this.x(), this.y())
        if (d1 > judgeDistance) then
            local px, py = math.polar(_x, _y, judgeDistance - 75, math.angle(_x, _y, this.x(), this.y()))
            J.IssuePointOrder(this.handle(), "move", px, py)
            this.prop("distanceTimer", time.setInterval(0.1, function(curTimer)
                if (this.isInterrupt()) then
                    curTimer.destroy()
                    this.prop("distanceTimer", NIL)
                    return
                end
                _x, _y = math.coordinate(target)
                local d2 = math.distance(_x, _y, this.x(), this.y())
                if (d2 <= judgeDistance) then
                    curTimer.destroy()
                    this.prop("distanceTimer", NIL)
                    callFunc()
                end
            end))
        else
            callFunc()
        end
    end)

    .public("pickItem",
    function(this, targetItem)
        if (isObject(targetItem, "Item") and targetItem.instance() == true) then
            this.distanceAction(targetItem, 150, function()
                if (targetItem.instance() == true) then
                    this.itemSlot().push(targetItem)
                    audio(Vcm("war3_pickItem"), this.owner())
                end
            end)
        end
    end)