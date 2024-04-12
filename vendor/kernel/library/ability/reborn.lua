-- 复活回调
---@param whichUnit Unit
function ability.rebornRevive(whichUnit, invulnerable, x, y, eff)
    if (isObject(whichUnit, "Unit") == false) then
        return
    end
    PropChange(whichUnit, "hpCur", "std", whichUnit.prop("hp"), false)
    local reviveToken = J.CreateUnit(whichUnit.owner().handle(), whichUnit.modelId(), x, y, 270)
    href(whichUnit, reviveToken)
    PropChange(whichUnit, "isAlive", "std", true, false)
    PropReExec(whichUnit)
    whichUnit.attach(eff, "origin", 3)
    if (invulnerable > 0) then
        ability.invulnerable(whichUnit, invulnerable, "DivineShieldTarget")
    end
    --- 触发复活事件
    event.trigger(whichUnit, EVENT.Unit.Reborn, { triggerUnit = whichUnit })
end

--- 重生
---@param whichUnit Unit
---@param delay number|0
---@param invulnerable number 复活后的无敌时间
---@param x number 在哪复活X
---@param y number 在哪复活Y
---@return Timer|nil
function ability.reborn(whichUnit, delay, invulnerable, x, y)
    if (isObject(whichUnit, "Unit") == false) then
        return
    end
    BuffClear(whichUnit)
    local rebornTimer
    if (delay < 1) then
        delay = math.max(0.1, delay)
        time.setTimeout(delay, function(curTimer)
            ability.rebornRevive(whichUnit, invulnerable, x, y, "DispelMagicTarget")
        end)
    else
        whichUnit.owner().mark(TEXTURE_MARK.DREAM, delay, 255, 0, 0)
        --- 复活标志
        local unitGhost = J.CreateUnit(PlayerPassive.handle(), whichUnit.prop("tpl").modelId(), whichUnit.x(), whichUnit.y(), 270)
        J.handleRef(unitGhost)
        J.PauseUnit(unitGhost, true)
        J.SetUnitVertexColor(unitGhost, 255, 255, 255, 100)
        J.SetUnitScale(unitGhost, whichUnit.modelScale() * 0.9, whichUnit.modelScale() * 0.9, whichUnit.modelScale() * 0.9)
        J.SetUnitColor(unitGhost, PLAYER_COLOR[whichUnit.owner().index()])
        J.UnitAddAbility(unitGhost, SINGLUAR_ID["ability_fly"])
        J.UnitRemoveAbility(unitGhost, SINGLUAR_ID["ability_fly"])
        J.SetUnitFlyHeight(unitGhost, 40, 9999)
        J.SetUnitPathing(unitGhost, false)
        J.UnitAddAbility(unitGhost, SINGLUAR_ID["ability_locust"])
        J.UnitAddAbility(unitGhost, SINGLUAR_ID["ability_invulnerable"])
        local deathToken = J.CreateUnit(PlayerPassive.handle(), SINGLUAR_ID["unit_death_token"], whichUnit.x(), whichUnit.y(), 270)
        J.handleRef(deathToken)
        J.SetUnitVertexColor(deathToken, 255, 255, 255, 180)
        J.SetUnitScale(deathToken, whichUnit.modelScale() * 0.75, whichUnit.modelScale() * 0.75, whichUnit.modelScale() * 0.75)
        J.SetUnitTimeScale(deathToken, 10 / delay)
        rebornTimer = time.setTimeout(delay, function(curTimer)
            curTimer.destroy()
            J.RemoveUnit(deathToken)
            J.handleUnRef(deathToken)
            J.RemoveUnit(unitGhost)
            J.handleUnRef(unitGhost)
            ability.rebornRevive(whichUnit, invulnerable, x, y, "ResurrectTarget")
        end)
    end
    return rebornTimer
end