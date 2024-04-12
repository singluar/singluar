---@class effect 特效
effect = effect or {}

--- 删除特效
---@param e number
---@return void
function effect.destroy(e)
    if (e ~= nil) then
        J.DestroyEffect(e)
        J.handleUnRef(e)
        e = nil
    end
end

--- 特效缩放
---@param e number
---@param x number
---@param y number
---@param z number
---@return void
function effect.scale(e, x, y, z)
    if (e ~= nil and x ~= nil and y ~= nil and z ~= nil) then
        japi.EXEffectMatScale(e, x, y, z)
    end
end

--- 特效速度
---@param e number
---@param spd number
---@return void
function effect.speed(e, spd)
    if (e ~= nil and spd ~= nil) then
        japi.EXSetEffectSpeed(e, spd)
    end
end

--- 在XY坐标创建特效
--- 有的模型用此方法不会播放，此时需要duration>0
---@param model string support:alias
---@param x number
---@param y number
---@param z number
---@param duration number 当小于0时不主动删除，等于0时为删除型播放，大于0时持续一段时间
---@return number|nil
function effect.xyz(model, x, y, z, duration)
    model = AModel(model)
    if (model == nil) then
        return
    end
    z = z or 0
    duration = duration or 0
    local e = J.AddSpecialEffect(model, x, y)
    if (e > 0) then
        J.handleRef(e)
        if (duration == 0) then
            effect.destroy(e)
            return
        end
        if (type(z) == "number") then
            japi.EXSetEffectZ(e, z)
        end
        if (duration > 0) then
            time.setTimeout(duration, function(curTimer)
                curTimer.destroy()
                effect.destroy(e)
            end)
        end
    end
    return e
end

--- 创建特效绑定单位模型
---@param model string
---@param targetUnit Unit
---@param attach string | "'origin'" | "'head'" | "'chest'" | "'weapon'"
---@param duration number 当小于0时不主动删除，等于0时为删除型播放，大于0时持续一段时间
---@return number|nil
function effect.attach(model, targetUnit, attach, duration)
    model = AModel(model)
    if (model == nil or attach == nil) then
        return
    end
    if (isObject(targetUnit, "Unit") == false) then
        return
    end
    duration = duration or 0
    local e = J.AddSpecialEffectTarget(model, targetUnit.handle(), attach)
    if (e > 0) then
        J.handleRef(e)
        if (duration == 0) then
            effect.destroy(e)
            return
        end
        if (duration > 0) then
            time.setTimeout(duration, function(curTimer)
                curTimer.destroy()
                effect.destroy(e)
            end)
        end
    end
    return e
end
