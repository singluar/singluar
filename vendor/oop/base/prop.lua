---@protected
---@param this Object
---@param key string
---@param value any
function PropLimit(this, key, value)
    local c = Class(this)
    while (c ~= nil) do
        local limiter = c.limiter()
        if (limiter ~= nil and type(limiter[key]) == "function") then
            value = limiter[key](this, value)
            break
        end
        if (c.inherit()) then
            c = Class(c.inherit())
        else
            c = nil
        end
    end
    return value
end

---@protected
---@param this Object
---@param key string
---@param futureValue any
function PropExec(this, key, futureValue)
    if (futureValue == nil) then
        return
    end
    local c = Class(this)
    while (c ~= nil) do
        local exec = c.exec()
        if (isArray(exec)) then
            local execFunc = exec.get(key)
            if (type(execFunc) == "function") then
                execFunc(this, PropLimit(this, key, futureValue))
                break
            end
        end
        if (c.inherit()) then
            c = Class(c.inherit())
        else
            c = nil
        end
    end
end

---@protected
---@param this Object
function PropReExec(this)
    local c = Class(this)
    local exec = c.exec()
    if (isArray(exec)) then
        local eks = exec.keys()
        for _, k in ipairs(eks) do
            PropExec(this, k, PropValue(this, k))
        end
    end
end

---@protected
---@param this Object
---@param key string
function PropValue(this, key, std, dyn)
    if (key == nil) then
        return
    end
    local aid = tostring(async.index)
    if (this.__PROP__ == nil) then
        error("propValue is nil", this.id())
        return
    end
    if (this.__PROP__[aid] ~= nil) then
        if (std == nil) then
            std = this.__PROP__[aid].std[key]
        end
        if (dyn == nil) then
            dyn = this.__PROP__[aid].dyn[key]
        end
    end
    if (this.__PROP__["0"] ~= nil) then
        if (std == nil) then
            std = this.__PROP__["0"].std[key]
        end
        if (dyn == nil) then
            dyn = this.__PROP__["0"].dyn[key]
        end
    end
    if (std == NIL) then
        std = nil
    end
    if (dyn == NIL) then
        dyn = nil
    end
    local val = std
    if (dyn ~= nil) then
        if (type(dyn) == "number") then
            val = (val or 0) + dyn
        else
            val = dyn
        end
    end
    return val
end

---@protected
function PropChange(this, key, space, setVal, isExec)
    if (type(isExec) ~= "boolean") then
        isExec = true
    end
    local aid = tostring(async.index)
    if (this.__PROP__[aid] == nil) then
        this.__PROP__[aid] = { std = {}, dyn = {} }
    end
    local oldVal = PROP(this, key)
    local newVal
    if (space == "std") then
        newVal = PropValue(this, key, setVal, nil)
    elseif (space == "dyn") then
        newVal = PropValue(this, key, nil, setVal)
    else
        return
    end
    local updated = (false == datum.equal(oldVal, newVal))
    if (updated) then
        if (event.propChange(key)) then
            event.trigger(this, EVENT.Prop.BeforeChange, {
                triggerObject = this,
                key = key,
                old = oldVal,
                new = newVal,
            })
        end
        if (isExec and newVal ~= nil) then
            PropExec(this, key, newVal)
        end
    end
    if (setVal == NIL) then
        setVal = nil
    end
    local pda = this.__PROP__[aid]
    if (space == "std") then
        pda.std[key] = setVal
    elseif (space == "dyn") then
        pda.dyn[key] = setVal
    end
    if (updated) then
        if (event.propChange(key)) then
            event.trigger(this, EVENT.Prop.Change, {
                triggerObject = this,
                key = key,
                old = oldVal,
                new = newVal,
            })
        end
    end
    return updated
end

---@private
---@param key string
---@param variety any
---@param duration number
---@return self|any,boolean
function PROP(this, key, variety, duration)
    if (key == nil and variety == nil and duration == nil) then
        error("prop")
    end
    if (type(duration) ~= "number") then
        duration = 0
    end
    if (type(variety) == "string") then
        local durc = string.explode(";", variety)
        if (#durc == 2) then
            local durc2 = tonumber(durc[2])
            if (type(durc2) == "number") then
                duration = math.max(0, durc2)
                variety = durc[1]
            end
        end
    end
    if (key == nil) then
        return nil, false
    end
    local curVal = PropValue(this, key)
    if (variety == nil) then
        if (type(curVal) == "number") then
            if (curVal > 0 and key[1] ~= "<") then
                local mut = PROP(this, "<MUTATION>" .. key) or 0
                if (mut ~= 0) then
                    if (mut <= -100) then
                        curVal = 0
                    else
                        curVal = curVal * (1 + mut * 0.01)
                    end
                end
            end
            local formatter = Class(this).formatter()
            if (formatter ~= nil and type(formatter[key]) == "function") then
                curVal = formatter[key](curVal)
            end
            curVal = PropLimit(this, key, curVal)
        end
        return curVal, false
    end
    local aid = tostring(async.index)
    if (this.__PROP__[aid] == nil) then
        this.__PROP__[aid] = { std = {}, dyn = {} }
    end
    --- 同步数据设置时，强制清理异步数据
    if (aid == "0") then
        for i = 1, BJ_MAX_PLAYERS do
            local si = tostring(i)
            if (this.__PROP__[si]) then
                if (this.__PROP__[si].std and this.__PROP__[si].std[key]) then
                    this.__PROP__[si].std[key] = nil
                end
                if (this.__PROP__[si].dyn and this.__PROP__[si].dyn[key]) then
                    this.__PROP__[si].dyn[key] = nil
                end
            end
        end
    end

    if (variety == NIL) then
        local s = PropChange(this, key, "std", NIL, false)
        local d = PropChange(this, key, "dyn", NIL, false)
        return this, s or d
    end

    local pda = this.__PROP__[aid]
    local caleVal, diff = math.cale(variety, pda.std[key])
    if (caleVal == nil) then
        return this, false
    end

    -- 增幅 raise
    if (type(diff) == "number") then
        if (type(caleVal) == "number") then
            if (diff ~= 0 and key[1] ~= "<") then
                local raise = PROP(this, "<RAISE>" .. key) or 0
                if raise ~= 0 then
                    caleVal = caleVal - diff
                    diff = diff * (raise * 0.01 + 1)
                    caleVal = caleVal + diff
                end
            end
        end
    end
    if duration <= 0 then
        return this, PropChange(this, key, "std", caleVal)
    end
    local tmpDyn
    if (type(diff) == "number") then
        tmpDyn = (pda.dyn[key] or 0) + diff
    else
        tmpDyn = caleVal
    end
    -- 同步时挂载Buff
    if (aid == "0") then
        local bk = "prop_" .. key
        local bf
        bf = Buff(this, bk, duration, diff,
            function(o)
                PropChange(o, key, "dyn", tmpDyn)
            end,
            function(o)
                if (type(pda.dyn[key]) == "number") then
                    local new = pda.dyn[key] - diff
                    PropChange(o, key, "dyn", new)
                else
                    local cs = BuffCatcher(this, {
                        forward = false,
                        key = bk,
                        limit = 1,
                        filter = function(enumBuff) return enumBuff.id() ~= bf.id() end,
                    })
                    if (#cs > 0) then
                        cs[1].prop("purpose")(o)
                    else
                        PropChange(o, key, "dyn", NIL)
                    end
                end
            end)
            .purpose()
    else
        -- 异步时挂载计时器(只支持diff型)
        if (type(diff) == "number") then
            PropChange(this, key, "dyn", tmpDyn)
            time.setTimeout(duration, function()
                if (type(pda.dyn[key]) == "number") then
                    local new = pda.dyn[key] - diff
                    PropChange(this, key, "dyn", new)
                end
            end)
        end
    end
    return this, true
end

---@protected
---@param this Object
---@param key string
---@param variety nil|any
---@param duration number|0
---@return Object|any
function Prop(this, key, variety, duration)
    local v = PROP(this, key, variety, duration)
    return v
end