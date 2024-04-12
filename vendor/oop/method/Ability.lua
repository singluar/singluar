---@param this Ability
Class("Ability")

    .public("onEvent",
    function(this, evt, ...)
        event.register(this, evt, ...)
        return this
    end)

    .public("onUnitEvent",
    function(this, evt, ...)
        local opt = { ... }
        local key
        local callFunc
        if (type(opt[1]) == "function") then
            key = this.id() .. evt
            callFunc = opt[1]
        elseif (type(opt[1]) == "string" and type(opt[2]) == "function") then
            key = this.id() .. opt[1]
            callFunc = opt[2]
        end
        if (key ~= nil) then
            local eKey = "aoue#" .. key
            if (callFunc == nil) then
                event.unregister(this, EVENT.Ability.Get, eKey)
                event.unregister(this, EVENT.Ability.Lose, eKey)
            else
                ---@param getData noteOnAbilityGetData
                this.onEvent(EVENT.Ability.Get, eKey, function(getData)
                    event.register(getData.triggerUnit, evt, eKey, function(callData)
                        callData.triggerAbility = getData.triggerAbility
                        callFunc(callData)
                    end)
                end)
                ---@param loseData noteOnAbilityLoseData
                this.onEvent(EVENT.Ability.Lose, eKey, function(loseData)
                    event.register(loseData.triggerUnit, evt, eKey)
                end)
            end
        end
        return this
    end)

    .public("abilitySlotIndex",
    function(this, modify)
        return this.prop("abilitySlotIndex", modify)
    end)

    .public("hotkey",
    function(this)
        return this.prop("hotkey")
    end)

    .public("bindUnit",
    function(this, modify)
        return this.prop("bindUnit", modify)
    end)

    .public("bindItem",
    function(this, modify)
        return this.prop("bindItem", modify)
    end)

    .public("coolDownTimer",
    function(this)
        return this.prop("coolDownTimer")
    end)

    .public("coolDownRemain",
    function(this)
        if (isObject(this.prop("coolDownTimer"), "Timer")) then
            return this.prop("coolDownTimer").remain()
        end
        return 0
    end)

    .public("prohibitReason",
    function(this)
        local reason
        if (this.prop("prohibitor").get("preCast") == true) then
            reason = "吟唱中"
        end
        if (this.prop("prohibitor").get("keepCast") == true) then
            reason = "施法中"
        end
        if (this.prop("prohibitor").get("coolDown") == true) then
            reason = "冷却中"
        end
        if (this.prop("prohibitor").get("MP") == true) then
            reason = "MP不足"
        end
        if (this.prop("prohibitor").get("HP") == true) then
            reason = "HP不足"
        end
        if (this.prop("prohibitor").get("worth") == true) then
            reason = "财物不足"
        end
        if (this.prop("prohibitor").get("stun") == true) then
            reason = "被眩晕"
        end
        if (this.prop("prohibitor").get("silent") == true) then
            reason = "被沉默"
        end
        return reason
    end)

    .public("ban",
    function(this, reason)
        this.prop("prohibitor").set(reason, true)
        return this
    end)

    .public("allow",
    function(this, reason)
        this.prop("prohibitor").set(reason, nil)
        return this
    end)

    .public("exp",
    function(this, modify)
        if (modify ~= nil) then
            if (this.level() > 1 and this.prop("exp") <= 0) then
                -- 技能等级提前提升过，则补回之前的升级经验，当作是早已获取
                this.prop("exp", Game().abilityExpNeeds(this.level()))
            end
        end
        return this.prop("exp", modify)
    end)

    .public("expNeed",
    function(this, whichLevel)
        whichLevel = whichLevel or (1 + this.level())
        whichLevel = math.max(1, whichLevel)
        whichLevel = math.min(Game().abilityLevelMax(), whichLevel)
        return Game().abilityExpNeeds(math.floor(whichLevel))
    end)

    .public("coolingEnter",
    function(this)
        local coolDown = this.coolDown()
        if (coolDown > 0) then
            local coolDownTimer = this.prop("coolDownTimer")
            if (isObject(coolDownTimer, "Timer")) then
                coolDownTimer.destroy()
                this.prop("coolDownTimer", NIL)
            end
            this.ban("coolDown")
            this.prop("coolDownTimer", time.setTimeout(coolDown, function(curTimer)
                curTimer.destroy()
                this.prop("coolDownTimer", NIL)
                this.allow("coolDown")
            end))
        end
    end)

    .public("coolingInstant",
    function(this)
        ---@type Timer
        local t = this.prop("coolDownTimer")
        if (isObject(t, "Timer") and t.remain() > 0.01) then
            t.remain(0.01)
        end
    end)

    .public("isCooling",
    function(this)
        return this.prop("prohibitor").get("coolDown") == true
    end)

    .public("isProhibiting",
    function(this)
        local bu = this.bindUnit()
        local count = this.prop("prohibitor").count()
        if (isObject(bu, "Unit")) then
            if (bu.isStunning()) then
                this.ban("stun")
            else
                this.allow("stun")
            end
            if (bu.isCrackFlying()) then
                this.ban("crackFly")
            else
                this.allow("crackFly")
            end
            if (bu.isLeaping()) then
                this.ban("leap")
            else
                this.allow("leap")
            end
            if (bu.isWhirlwind()) then
                this.ban("whirlwind")
            else
                this.allow("whirlwind")
            end
            if (bu.isSilencing()) then
                this.ban("silent")
            else
                this.allow("silent")
            end
            if (this.hpCost() > 0 and this.hpCost() >= bu.hpCur()) then
                this.ban("HP")
            else
                this.allow("HP")
            end
            if (this.mpCost() > 0 and this.mpCost() > bu.mpCur()) then
                this.ban("MP")
            else
                this.allow("MP")
            end
            local w = this.worthCost()
            if (w ~= nil and Game().worthGreater(w, bu.owner().worth())) then
                this.ban("worth")
            else
                this.allow("worth")
            end
        elseif (count > 0) then
            this.prop("prohibitor", Array())
            count = 0
        end
        local status = count > 0
        this.prop("prohibiting", status)
        return status
    end)

    .public("isCastTarget",
    function(this, targetObj)
        local tt = this.targetType()
        if (tt == ABILITY_TARGET_TYPE.TAG_U and isObject(targetObj, "Unit") == false) then
            return false
        end
        local cta = this.prop("castTargetFilter")
        if (cta == nil or type(cta) ~= "function") then
            return false
        end
        return cta(this, targetObj)
    end)

    .public("effective",
    function(this, evtData)
        must(async.index == 0, "AsynchronousReferenceIsProhibited")
        local triggerUnit = this.bindUnit()
        if (isObject(triggerUnit, "Unit") == false) then
            return
        end
        evtData = evtData or {}
        local tt = this.targetType()
        if (tt == ABILITY_TARGET_TYPE.TAG_U and isObject(evtData.targetUnit, "Unit")) then
            if (this.isCastTarget(evtData.targetUnit) == false) then
                return
            end
        end
        if (this.isProhibiting() == true or triggerUnit.isInterrupt() or triggerUnit.isPause()) then
            return
        end
        local triggerOwner = triggerUnit.owner()
        async.call(triggerOwner, function()
            Cursor().abilityStop()
        end)
        evtData.triggerAbility = this
        evtData.triggerUnit = triggerUnit
        if (evtData.targetX == nil or evtData.targetY == nil or evtData.targetZ == nil) then
            if (isObject(evtData.targetUnit, "Unit")) then
                evtData.targetX = evtData.targetUnit.x()
                evtData.targetY = evtData.targetUnit.y()
                evtData.targetZ = evtData.targetUnit.z()
            end
        end
        local _effective = function()
            local hpCast = this.hpCost()
            local mpCast = this.mpCost()
            local worthCost = this.worthCost()
            if (hpCast > 0 and triggerUnit.hpCur() <= hpCast) then
                return
            end
            if (mpCast > 0 and triggerUnit.mpCur() < mpCast) then
                return
            end
            if (worthCost ~= nil and Game().worthLess(triggerUnit.owner().worth(), worthCost)) then
                return
            end
            async.call(triggerUnit.owner(), function()
                Cursor().abilityStop()
            end)
            if (tt == ABILITY_TARGET_TYPE.TAG_C) then
                evtData.targetUnits = group.catch({
                    key = "Unit",
                    x = evtData.targetX,
                    y = evtData.targetY,
                    radius = this.castRadius(),
                    func = function(enumUnit)
                        return this.isCastTarget(enumUnit)
                    end
                })
            elseif (tt == ABILITY_TARGET_TYPE.TAG_S) then
                evtData.targetUnits = group.catch({
                    key = "Unit",
                    x = evtData.targetX,
                    y = evtData.targetY,
                    width = this.castWidth(),
                    height = this.castHeight(),
                    func = function(enumUnit)
                        return this.isCastTarget(enumUnit)
                    end
                })
            end
            --- 预执行
            if (hpCast > 0) then
                triggerUnit.hpCur("-=" .. hpCast)
            end
            if (mpCast > 0) then
                triggerUnit.mpCur("-=" .. mpCast)
            end
            if (worthCost ~= nil) then
                triggerUnit.owner().worth("-", worthCost)
            end
            --- 有目标坐标时，改一下面向角度
            if (evtData.targetX and evtData.targetY) then
                evtData.triggerUnit.facing(math.angle(evtData.triggerUnit.x(), evtData.triggerUnit.y(), evtData.targetX, evtData.targetY))
            end
            local otherData = {
                triggerAbility = this,
                triggerUnit = triggerUnit,
            }
            --- 触发使用物品
            local bIt = this.bindItem()
            if (isObject(bIt, "Item") and bIt.consumable()) then
                if (bIt.charges() <= 0) then
                    return
                end
                evtData.triggerItem = bIt
                event.trigger(bIt, EVENT.Item.Used, evtData)
                event.trigger(triggerUnit, EVENT.Item.Used, evtData)
            end
            --- 触发技能开始施放（但未生效）
            event.trigger(this, EVENT.Ability.Spell, evtData)
            event.trigger(triggerUnit, EVENT.Ability.Spell, evtData)
            local spell = function()
                event.trigger(this, EVENT.Ability.Effective, evtData) --触发技能被施放
                event.trigger(triggerUnit, EVENT.Ability.Effective, evtData) --触发单位施放了技能
            end
            local keep = function()
                local ka = triggerUnit.keepAnimation() or this.keepAnimation()
                if (ka) then
                    triggerUnit.animate(ka)
                end
                event.trigger(this, EVENT.Ability.Casting, evtData) --触发技能持续每周期做动作时
                event.trigger(triggerUnit, EVENT.Ability.Casting, evtData) --触发技能持续每周期做动作时
            end
            local stop = function()
                event.trigger(this, EVENT.Ability.Stop, otherData) --触发技能被停止
                event.trigger(triggerUnit, EVENT.Ability.Stop, otherData) --触发单位停止施放技能
            end
            local over = function()
                event.trigger(this, EVENT.Ability.Over, otherData) --触发持续技能结束
                event.trigger(triggerUnit, EVENT.Ability.Over, otherData) --触发单位持续技能结束
            end
            -- keepCast
            local castKeep = function()
                local kc = this.castKeep()
                if (kc > 0) then
                    this.ban("kc")
                    triggerUnit.superposition("pause", "+=1")
                    triggerUnit.prop("abilitySpellReset", function(status)
                        triggerUnit.prop("abilitySpellReset", NIL)
                        local t = triggerUnit.prop("abilityKeepCastTimer")
                        t.destroy()
                        this.allow("kc")
                        triggerUnit.prop("abilityKeepCastTimer", NIL)
                        triggerUnit.superposition("pause", "-=1")
                        if (status == false) then
                            stop()
                        end
                    end)
                    local ti = 0
                    local period = 0.05
                    keep()
                    triggerUnit.prop("abilityKeepCastTimerInc", ti)
                    triggerUnit.prop("abilityKeepCastTimerStatic", kc / period)
                    triggerUnit.prop("abilityKeepCastTimer", time.setInterval(period, function(keepTimer)
                        ti = ti + 1
                        triggerUnit.prop("abilityKeepCastTimerInc", ti)
                        if (triggerUnit.isInterrupt()) then
                            keepTimer.destroy()
                            local r2 = triggerUnit.prop("abilitySpellReset")
                            if (type(r2) == "function") then
                                r2(false)
                            end
                        elseif (ti >= triggerUnit.prop("abilityKeepCastTimerStatic")) then
                            keepTimer.destroy()
                            local r2 = triggerUnit.prop("abilitySpellReset")
                            if (type(r2) == "function") then
                                r2(true)
                                over()
                            end
                        else
                            if (ti % 20 == 0) then
                                keep()
                            end
                        end
                    end))
                end
            end
            -- preCast
            local preCast = this.castChant()
            if (preCast > 0) then
                this.ban("preCast")
                triggerUnit.superposition("pause", "+=1")
                local ca = triggerUnit.castAnimation() or this.castAnimation()
                if (ca) then
                    time.setTimeout(0, function()
                        triggerUnit.animate(ca)
                    end)
                end
                local animateScale = triggerUnit.animateScale()
                triggerUnit.animateScale(1 / preCast)
                triggerUnit.prop("abilitySpellReset", function(status)
                    triggerUnit.prop("abilitySpellReset", NIL)
                    local t = triggerUnit.prop("abilityChantCastTimer")
                    t.destroy()
                    triggerUnit.prop("abilityChantCastTimer", NIL)
                    this.allow("preCast")
                    triggerUnit.animateScale(animateScale)
                    triggerUnit.superposition("pause", "-=1")
                    if (status == false) then
                        stop()
                    end
                end)
                local ti = 0
                local period = 0.05
                triggerUnit.prop("abilityChantCastTimerInc", ti)
                triggerUnit.prop("abilityChantCastTimerStatic", preCast / period)
                triggerUnit.prop("abilityChantCastTimer", time.setInterval(period, function(spellTimer)
                    ti = ti + 1
                    triggerUnit.prop("abilityChantCastTimerInc", ti)
                    if (triggerUnit.isInterrupt()) then
                        spellTimer.destroy()
                        local r1 = triggerUnit.prop("abilitySpellReset")
                        if (type(r1) == "function") then
                            r1(false)
                        end
                    elseif (ti >= triggerUnit.prop("abilityChantCastTimerStatic")) then
                        spellTimer.destroy()
                        local r1 = triggerUnit.prop("abilitySpellReset")
                        if (type(r1) == "function") then
                            r1(true)
                        end
                        spell()
                        castKeep()
                    end
                end))
                this.coolingEnter()
            else
                spell()
                this.coolingEnter()
                castKeep()
            end
        end
        if (tt == ABILITY_TARGET_TYPE.PAS or tt == ABILITY_TARGET_TYPE.TAG_E) then
            _effective()
        else
            --- 非无视距离类型需要进行距离判断
            local castDistance = this.castDistance()
            local distTarget
            if (isObject(evtData.targetUnit, "Unit")) then
                distTarget = evtData.targetUnit
            elseif (evtData.targetX and evtData.targetY) then
                distTarget = { evtData.targetX, evtData.targetY }
            else
                distTarget = triggerUnit
            end
            triggerUnit.distanceAction(distTarget, castDistance, _effective)
        end
    end)