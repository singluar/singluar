---@class
player = player or {}

player.evtEsc = J.Condition(function()
    local triggerPlayer = h2p(J.GetTriggerPlayer())
    event.trigger(triggerPlayer, EVENT.Player.Esc, {
        triggerPlayer = triggerPlayer
    })
    --- 清空控制技能
    async.call(triggerPlayer, function()
        Cursor().abilityStop()
    end)
    ---@type Unit
    local selection = triggerPlayer.selection()
    if (isObject(selection, "Unit") and selection.owner() == triggerPlayer) then
        if (selection.isAbilityChantCasting()) then
            local reset = selection.prop("abilitySpellReset")
            if (type(reset) == "function") then
                reset(false)
            end
        end
        if (selection.isAbilityKeepCasting()) then
            local reset = selection.prop("abilitySpellReset")
            if (type(reset) == "function") then
                reset(false)
            end
        end
    end
end)

player.evtSelection = J.Condition(function()
    local selector = h2p(J.GetTriggerPlayer())
    local triggerObject = h2u(J.GetTriggerUnit())
    local prevObject = selector.selection()
    local select0 = true
    if (triggerObject == nil) then
        return
    end
    --- 多选记录
    if (isObject(prevObject, "Unit")) then
        if (prevObject.id() == triggerObject.id()) then
            select0 = false
        end
    end
    if (select0) then
        selector.prop("click", 0)
        selector.prop("selection", triggerObject)
        if (selector.prop("clickTimer") ~= nil) then
            selector.prop("clickTimer").destroy()
            selector.prop("clickTimer", NIL)
        end
    end
    selector.prop("click", "+=1")
    selector.prop("clickTimer", time.setTimeout(0.3, function()
        selector.prop("click", "-=1")
    end))
    local clickCur = math.floor(selector.prop("click"))
    for qty = 5, 1, -1 do
        if (clickCur >= qty) then
            if (isObject(triggerObject, "Unit")) then
                event.trigger(selector, EVENT.Player.SelectUnit .. "#" .. qty, {
                    triggerPlayer = selector,
                    triggerUnit = triggerObject,
                    qty = qty,
                })
            elseif (isObject(triggerObject, "Item")) then
                event.trigger(selector, EVENT.Player.SelectItem .. "#" .. qty, {
                    triggerPlayer = selector,
                    triggerItem = triggerObject,
                    qty = qty,
                })
            end
            break
        end
    end
end)

player.evtDeSelection = J.Condition(function()
    local triggerPlayer = J.GetTriggerPlayer()
    local deSelector = h2p(triggerPlayer)
    local triggerObject = h2u(J.GetTriggerUnit())
    deSelector.prop("click", 0)
    async.call(deSelector, function()
        if (Cursor().ability() == nil) then
            deSelector.prop("selection", NIL)
        end
    end)
    if (isObject(triggerObject, "Unit")) then
        event.trigger(deSelector, EVENT.Player.DeSelectUnit, { triggerPlayer = deSelector, triggerUnit = triggerObject })
    elseif (isObject(triggerObject, "Item")) then
        event.trigger(deSelector, EVENT.Player.DeSelectItem, { triggerPlayer = deSelector, triggerItem = triggerObject })
    end
end)

player.evtLeave = J.Condition(function()
    local triggerPlayer = J.GetTriggerPlayer()
    local leavePlayer = h2p(triggerPlayer)
    leavePlayer.status(PLAYER_STATUS.leave)
    async.call(leavePlayer, function()
        Cursor().abilityStop()
    end)
    echo(leavePlayer.name() .. "离开了游戏～")
    Game().playingQuantity('-=1')
    event.trigger(leavePlayer, EVENT.Player.Quit, { triggerPlayer = leavePlayer })
end)

player.evtChat = J.Condition(function()
    local chatPlayer = h2p(J.GetTriggerPlayer())
    event.trigger(chatPlayer, EVENT.Player.Chat, {
        triggerPlayer = chatPlayer,
        chatString = J.GetEventPlayerChatString()
    })
end)

---@type fun(sourceUnit:Unit,targetUnit:Unit):void
player.evtDamagedArrived = function(sourceUnit, targetUnit)
    if (isObject(sourceUnit, "Unit") == false or isObject(targetUnit, "Unit") == false) then
        return
    end
    if (sourceUnit.weaponSoundMode() == 1) then
        audio(Vwp(sourceUnit, targetUnit))
    end
    local dmg = sourceUnit.attack() + math.rand(0, sourceUnit.attackRipple())
    if (dmg >= 0.1) then
        ability.damage({
            sourceUnit = sourceUnit,
            targetUnit = targetUnit,
            damage = dmg,
            damageSrc = DAMAGE_SRC.attack,
        })
    end
end

---@type fun(sourceUnit:Unit,targetUnit:Unit):void
player.evtDamaged = function(sourceUnit, targetUnit)
    if (isObject(sourceUnit, "Unit") == false or isObject(targetUnit, "Unit") == false) then
        return
    end
    if (sourceUnit.isMelee()) then
        player.evtDamagedArrived(sourceUnit, targetUnit)
    elseif (sourceUnit.isRanged()) then
        local lt = sourceUnit.lightning()
        if (isObject(lt, "Lightning")) then
            local lDur = 0.3
            local lDelay = lDur * 0.6
            local focus = lt.focus()
            if (focus < 1) then
                focus = 1
            end
            for _ = 1, focus do
                ability.lightning(
                    lt.lightningType(),
                    sourceUnit.x() + math.rand(-50, 50),
                    sourceUnit.y() + math.rand(-50, 50),
                    sourceUnit.h() + math.rand(25, 75),
                    targetUnit.x(),
                    targetUnit.y(),
                    targetUnit.h() + math.rand(25, 75),
                    lDur
                )
                time.setTimeout(lDelay, function()
                    player.evtDamagedArrived(sourceUnit, targetUnit)
                end)
            end
            if (lt.scatter() > 0 and lt.radius() > 0) then
                group.forEach({
                    key = "Unit", limit = lt.scatter(),
                    x = targetUnit.x(), y = targetUnit.y(), radius = lt.radius(),
                    filter = function(enumUnit)
                        return enumUnit.isOther(targetUnit) and enumUnit.isAlive() and enumUnit.isEnemy(sourceUnit.owner())
                    end
                }, function(enumUnit)
                    ability.lightning(
                        lt.lightningType(),
                        sourceUnit.x(), sourceUnit.y(), sourceUnit.h(),
                        enumUnit.x(), enumUnit.y(), enumUnit.h(),
                        lDur
                    )
                    time.setTimeout(lDelay, function()
                        player.evtDamagedArrived(sourceUnit, enumUnit)
                    end)
                end)
            end
        else
            local m = sourceUnit.missile()
            if (isObject(m, "Missile")) then
                local gatlin = m.gatlin()
                local options = {
                    modelAlias = m.modelAlias(),
                    scale = sourceUnit.modelScale(),
                    sourceUnit = sourceUnit,
                    targetUnit = targetUnit,
                    scale = m.scale(),
                    speed = m.speed(),
                    height = m.height(),
                    acceleration = m.acceleration(),
                    shake = m.shake(),
                    shakeOffset = m.shakeOffset(),
                    reflex = m.reflex(),
                    onEnd = function(opt, point)
                        if (math.distance(point[1], point[2], opt.targetUnit.x(), opt.targetUnit.y()) <= 100) then
                            player.evtDamagedArrived(opt.sourceUnit, opt.targetUnit)
                            return true
                        end
                        return false
                    end,
                }
                if (false == m.homing()) then
                    options.targetPoint = { targetUnit.x(), targetUnit.y(), targetUnit.z() }
                end
                ability.missile(options)
                if (gatlin > 0) then
                    time.setInterval(0.25, function(gatlinTimer)
                        if (gatlin <= 0
                            or false == isObject(sourceUnit, "Unit") or sourceUnit.isDead()
                            or false == isObject(targetUnit, "Unit") or targetUnit.isDead()) then
                            gatlinTimer.destroy()
                            return
                        end
                        gatlin = gatlin - 1
                        local gatlinOptions = {
                            modelAlias = options.modelAlias,
                            scale = options.scale,
                            sourceUnit = sourceUnit,
                            targetUnit = targetUnit,
                            scale = options.scale,
                            speed = options.speed,
                            height = options.height,
                            acceleration = options.acceleration,
                            shake = options.shake,
                            reflex = options.reflex,
                            onEnd = options.onEnd,
                        }
                        if (false == m.homing()) then
                            gatlinOptions.targetPoint = { targetUnit.x(), targetUnit.y(), targetUnit.z() }
                        end
                        ability.missile(gatlinOptions)
                    end)
                end
                if (m.scatter() > 0 and m.radius() > 0) then
                    group.forEach({
                        key = "Unit", limit = m.scatter(),
                        x = targetUnit.x(), y = targetUnit.y(), radius = m.radius(),
                        filter = function(enumUnit)
                            return enumUnit.isOther(targetUnit) and enumUnit.isAlive() and enumUnit.isEnemy(sourceUnit.owner())
                        end
                    }, function(enumUnit)
                        local scatterOptions = {
                            modelAlias = options.modelAlias,
                            scale = options.scale,
                            sourceUnit = sourceUnit,
                            targetUnit = enumUnit,
                            scale = options.scale,
                            speed = options.speed,
                            height = options.height,
                            acceleration = options.acceleration,
                            shake = options.shake,
                            reflex = options.reflex,
                            onEnd = options.onEnd,
                        }
                        if (false == m.homing()) then
                            scatterOptions.targetPoint = { enumUnit.x(), enumUnit.y(), targetUnit.z() }
                        end
                        ability.missile(scatterOptions)
                    end)
                end
            end
        end
    end
end

player.evtAttacked = J.Condition(function()
    local attacker = h2u(J.GetAttacker())
    if (attacker ~= nil) then
        local targetUnit = h2u(J.GetTriggerUnit())
        local v = slk.i2v(attacker.modelId())
        if (v == nil) then
            print("attackerError")
            return
        end
        event.trigger(attacker, EVENT.Unit.BeforeAttack, { triggerUnit = attacker, targetUnit = targetUnit })
        event.trigger(targetUnit, EVENT.Unit.Be.BeforeAttack, { triggerUnit = targetUnit, sourceUnit = attacker })
        local slk = v.slk
        local dmgpt = math.trunc(slk.dmgpt1, 3)
        local attackSpeed = math.min(math.max(attacker.attackSpeed(), -80), 400)
        local delay = 0.25 + attacker.attackPoint() * dmgpt / (1 + attackSpeed * 0.01)
        local ag = attacker.prop("attackedGather")
        local t = time.setTimeout(delay, function(curTimer)
            ag.set(curTimer.id(), nil)
            curTimer.destroy()
            if (attacker.weaponSoundMode() == 2) then
                audio(Vwp(attacker, targetUnit))
            end
            player.evtDamaged(attacker, targetUnit)
        end)
        if (isArray(ag) == false) then
            ag = Array()
            attacker.prop("attackedGather", ag)
        end
        ag.set(t.id(), t)
    end
end)

player.evtOrderMoveEnd = function(triggerUnit)
    local t = triggerUnit.prop("movingTimer")
    if (isObject(t, "Timer")) then
        t.destroy()
        triggerUnit.prop("movingTimer", NIL)
        triggerUnit.prop("movingStatus", 0)
        triggerUnit.prop("movingStep", 0)
        event.trigger(triggerUnit, EVENT.Unit.MoveStop, { triggerUnit = triggerUnit })
    end
end

player.evtOrderMoveTurn = function(triggerUnit)
    local t = triggerUnit.prop("movingTimer")
    if (isObject(t, "Timer")) then
        t.destroy()
        triggerUnit.prop("movingTimer", NIL)
        event.trigger(triggerUnit, EVENT.Unit.MoveTurn, { triggerUnit = triggerUnit })
        triggerUnit.prop("movingStatus", 2)
    else
        triggerUnit.prop("movingStatus", 1)
    end
end

player.evtOrderMoveRoute = function(triggerUnit, x, y, flag)
    local res = false
    if (type(x) ~= "number") then
        x = triggerUnit.x()
    end
    if (type(y) ~= "number") then
        y = triggerUnit.y()
    end
    local pause = triggerUnit.prop("orderRoutePause")
    local route = triggerUnit.prop("orderRoute")
    local idx = triggerUnit.prop("orderRouteIdx")
    if (pause == nil and type(route) == "table" and type(idx) == "number") then
        if (route[idx]) then
            if (flag == "stop" or math.distance(x, y, route[idx][1], route[idx][2]) < 100) then
                event.trigger(triggerUnit, EVENT.Unit.MoveRoute, { triggerUnit = triggerUnit, x = x, y = y, inc = (flag ~= "stop") })
                res = true
            elseif (flag == "moving" and math.distance(x, y, route[idx][1], route[idx][2]) > 100) then
                event.trigger(triggerUnit, EVENT.Unit.MoveRoute, { triggerUnit = triggerUnit, x = x, y = y, inc = false })
                res = true
            end
        end
    end
    return res
end

player.evtOrderMoveCatch = function(triggerUnit, tx, ty)
    if (event.has(triggerUnit, EVENT.Unit.MoveStart) or
        event.has(triggerUnit, EVENT.Unit.Moving) or
        event.has(triggerUnit, EVENT.Unit.MoveStop) or
        event.has(triggerUnit, EVENT.Unit.MoveTurn) or
        event.has(triggerUnit, EVENT.Unit.MoveRoute)) then
        local xl = math.trunc(triggerUnit.x())
        local yl = math.trunc(triggerUnit.y())
        local xc = xl
        local yc = yl
        triggerUnit.prop("movingTimer", time.setInterval(0.1, function(curTimer)
            local ms = triggerUnit.prop("movingStatus")
            if (ms == 0) then
                curTimer.destroy()
                triggerUnit.prop("movingStep", 0)
                return
            end
            local xt = math.floor(triggerUnit.x())
            local yt = math.floor(triggerUnit.y())
            if (ms == 1) then
                if (xt ~= xc or yt ~= yc) then
                    triggerUnit.prop("movingStatus", 2)
                    event.trigger(triggerUnit, EVENT.Unit.MoveStart, { triggerUnit = triggerUnit, x = tx, y = ty })
                else
                    local rRes = player.evtOrderMoveRoute(triggerUnit, xt, yt, "moving")
                    if (rRes == false) then
                        player.evtOrderMoveEnd(triggerUnit)
                    end
                end
            elseif (ms == 2) then
                local d = math.distance(xl, yl, xt, yt)
                if (d >= 99) then
                    xl = xt
                    yl = yt
                    local step = 1 + triggerUnit.prop("movingStep")
                    event.trigger(triggerUnit, EVENT.Unit.Moving, { triggerUnit = triggerUnit, x = xt, y = yt, step = step })
                    triggerUnit.prop("movingStep", step)
                end
                local rRes = player.evtOrderMoveRoute(triggerUnit, xt, yt)
                if (rRes == false and math.abs(xt - xc) < 3 and math.abs(yt - yc) < 3) then
                    player.evtOrderMoveEnd(triggerUnit)
                    player.evtOrderMoveRoute(triggerUnit, nil, nil, "stop")
                end
            end
            xc = xt
            yc = yt
        end))
    end
end

player.evtOrder = J.Condition(function()
    local triggerUnit = h2u(J.GetTriggerUnit())
    if (false == isObject(triggerUnit, "Unit")) then
        return
    end
    local orderId = J.GetIssuedOrderId()
    local orderTargetUnit = J.GetOrderTargetUnit()
    local tx, ty, tz
    if (orderTargetUnit ~= 0) then
        tx = J.GetUnitX(orderTargetUnit)
        ty = J.GetUnitY(orderTargetUnit)
        tz = japi.Z(tx, ty)
    else
        local loc = J.GetOrderPointLoc()
        if (loc ~= 0) then
            J.handleRef(loc)
            tx = J.GetLocationX(loc)
            ty = J.GetLocationY(loc)
            tz = J.GetLocationZ(loc)
            J.RemoveLocation(loc)
            J.handleUnRef(loc)
            loc = nil
        end
    end
    local owner = triggerUnit.owner()
    if (owner.isPlaying() and owner.isUser() and false == owner.isComputer()) then
        owner.prop("operand", "+=1")
        owner.prop("apm", owner.prop("operand") / (time.min + 1))
    end
    async.call(owner, function()
        Cursor().abilityStop()
    end)
    local distanceTimer = triggerUnit.prop("distanceTimer")
    if (isObject(distanceTimer, "Timer")) then
        distanceTimer.destroy()
        triggerUnit.prop("distanceTimer", NIL)
    end
    --[[
       851983:ATTACK 攻击
       851971:SMART
       851986:MOVE 移动
       851993:HOLD 保持原位
       851972:STOP 停止
   ]]
    if (orderId ~= 851983) then
        ---@type Array
        local ag = triggerUnit.prop("attackedGather")
        if (isArray(ag)) then
            ag.forEach(function(key, val)
                if (isObject(val, "Timer")) then
                    ag.set(key, nil)
                    val.destroy()
                end
            end, true)
        end
    end
    if (orderId == 851993) then
        event.trigger(triggerUnit, EVENT.Unit.Hold, { triggerUnit = triggerUnit })
        player.evtOrderMoveEnd(triggerUnit)
        player.evtOrderMoveRoute(triggerUnit, nil, nil, "stop")
    elseif (orderId == 851972) then
        event.trigger(triggerUnit, EVENT.Unit.Stop, { triggerUnit = triggerUnit })
        player.evtOrderMoveEnd(triggerUnit)
        player.evtOrderMoveRoute(triggerUnit, nil, nil, "stop")
    else
        if (tx ~= nil and ty ~= nil and tz ~= nil) then
            if (orderId == 851971) then
                local ci = group.closest({
                    key = "Item",
                    x = tx,
                    y = ty,
                    radius = 1
                })
                if (ci) then
                    triggerUnit.pickItem(ci)
                else
                    player.evtOrderMoveTurn(triggerUnit)
                    player.evtOrderMoveCatch(triggerUnit, tx, ty)
                end
            elseif (orderId == 851983 or orderId == 851986) then
                player.evtOrderMoveTurn(triggerUnit)
                player.evtOrderMoveCatch(triggerUnit, tx, ty)
            end
        end
    end
end)

---@param deadUnit Unit
player.evtKill = function(deadUnit)
    local killer = deadUnit.lastHurtSource()
    deadUnit.prop("isAlive", false)
    --- 触发击杀事件
    if (killer ~= nil) then
        event.trigger(killer, EVENT.Unit.Kill, { triggerUnit = killer, targetUnit = deadUnit })
    end
    -- 复活判断
    deadUnit.prop("isAttackAble", true)
    local rebornDelay = deadUnit.reborn()
    if (rebornDelay < 0) then
        --- 触发死亡事件
        event.trigger(deadUnit, EVENT.Unit.Dead, { triggerUnit = deadUnit, sourceUnit = killer })
        deadUnit.destroy(3)
    else
        --- 触发假死事件
        event.trigger(deadUnit, EVENT.Unit.FeignDead, { triggerUnit = deadUnit, sourceUnit = killer })
        ability.reborn(deadUnit, rebornDelay, 3.476, deadUnit.x(), deadUnit.y(), true)
    end
end

player.evtDead = J.Condition(function()
    local deadUnit = h2u(J.GetTriggerUnit())
    if (deadUnit == nil) then
        return
    end
    player.evtKill(deadUnit)
end)