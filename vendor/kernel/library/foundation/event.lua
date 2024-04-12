--- 事件
event = event or {}

--- 动态事件池
event_pool = event_pool or {}

--- 事件反应
event_reaction = event_reaction or {}

--- 触发池
--- 使用一个handle，以不同的conditionAction累计计数
--- 分配触发到回调注册
--- 触发池的action是不会被同一个handle注册两次的，与on事件并不相同
---@param conditionFunc number
---@param regEvent function
---@return void
function event.pool(conditionFunc, regEvent)
    if (type(regEvent) ~= "function") then
        return
    end
    local id = J.GetHandleId(conditionFunc)
    -- 如果这个handle已经注册过此动作，则不重复注册
    local tgr = event_pool[id]
    if (tgr == nil) then
        tgr = J.CreateTrigger()
        J.handleRef(tgr)
        J.TriggerAddCondition(tgr, conditionFunc)
        event_pool[id] = tgr
    end
    regEvent(event_pool[id])
end

--- 捕捉反应
---@param evt string 事件类型
---@vararg any
---@return void
function event.reaction(evt, ...)
    local opt = { ... }
    ---@type string 关联反应标识符
    local key
    ---@type fun(callData:table) 回调
    local callFunc
    if (type(opt[1]) == "function") then
        key = "default"
        callFunc = opt[1]
    elseif (type(opt[1]) == "string") then
        key = opt[1]
        if (type(opt[2]) == "function") then
            callFunc = opt[2]
        end
    end
    if (evt == nil) then
        stack()
    end
    if (event_reaction[evt] == nil) then
        event_reaction[evt] = Array()
    end
    event_reaction[evt].set(key, callFunc)
end

---@param obj Object|string
---@param evt string 事件类型
---@param init boolean
---@return nil|table<string,Array>|Array
function event.data(obj, evt, init)
    if (obj == nil) then
        return
    end
    local oid = obj.id()
    if (oid == nil or bop.i2o[oid] == nil) then
        return
    end
    if (init == true) then
        if (bop.i2o[oid]._event == nil) then
            bop.i2o[oid]._event = {}
        end
        if (evt ~= nil and bop.i2o[oid]._event[evt] == nil) then
            bop.i2o[oid]._event[evt] = Array()
        end
    end
    if (evt == nil) then
        return bop.i2o[oid]._event
    else
        if (type(bop.i2o[oid]._event) == "table") then
            return bop.i2o[oid]._event[evt]
        end
    end
end

--- 摧毁事件|事件集
---@param obj Object
---@param evt string 事件类型
---@param key string|nil
---@return void
function event.unregister(obj, evt, key)
    if (obj == nil or evt == nil) then
        return
    end
    local reg = event.data(obj)
    if (reg == nil or reg[evt] == nil) then
        return
    end
    if (key == nil) then
        reg[evt] = nil
    else
        reg[evt].set(key, nil)
    end
end

--- 注册事件
--- 每种类型的事件默认只会被注册一次，重复会覆盖
--- 这是根据 key 值决定的，key 默认就是default，需要的时候可以自定义
---@param obj Object|string
---@param evt string 事件类型字符
---@vararg string|function
---@return void
function event.register(obj, evt, ...)
    if (obj == nil) then
        return
    end
    local opt = { ... }
    ---@type string 关联事件标识符
    local key
    ---@type fun(callData:table) 回调
    local callFunc
    if (type(opt[1]) == "function") then
        key = "default"
        callFunc = opt[1]
    elseif (type(opt[1]) == "string") then
        key = opt[1]
        if (type(opt[2]) == "function") then
            callFunc = opt[2]
        end
    end
    if (key ~= nil) then
        ---@type Array
        if (callFunc == nil) then
            event.unregister(obj, evt, key)
        elseif (type(callFunc) == "function") then
            event.data(obj, evt, true).set(key, callFunc)
        end
    end
end

--- 拥有事件
---@param obj Object|string
---@param evt string 事件类型
---@return boolean
function event.has(obj, evt)
    local c = event.data(obj, evt)
    return isArray(c) and c.count() > 0
end

--- 触发事件
---@param obj Object|string
---@param evt string 事件类型
---@param triggerData table
function event.trigger(obj, evt, triggerData)
    if (obj == nil or evt == nil) then
        return
    end
    -- 数据
    triggerData = triggerData or {}
    -- 反应
    if (isArray(event_reaction[evt])) then
        event_reaction[evt].forEach(function(_, val)
            if (type(val) == "function") then
                promise(val, nil, nil, triggerData)
            end
        end)
    end
    -- 判断事件注册执行与否
    local reg = event.data(obj, evt)
    if (isArray(reg)) then
        reg.forEach(function(_, callFunc)
            promise(callFunc, nil, nil, triggerData)
        end)
    end
end

--- 参变判定
---@param key string
---@return boolean
function event.propChange(key)
    if (async.index == 0) then
        return event_prop_std == "any" or (type(event_prop_std) == "table" and event_prop_std[key] == true)
    else
        return event_prop_dyn == "any" or (type(event_prop_dyn) == "table" and event_prop_dyn[key] == true)
    end
end