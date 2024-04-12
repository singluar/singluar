--- 监听器是一种工具，用于管理周期性操作
---@class monitor 监听器
monitor = monitor or {}

---@type table<string,{frequency:number, actionFunc:function, ignoreFilter:function|nil}>
monitor._r = monitor._r or {}

---@type table<string,{arr:Array, timer:Timer}>
monitor._m = monitor._m or {}

--- 注册(创建)一个监听器行为
--- 行为会在listen时判断是否已注册，没有注册的行为没法执行
--- 相同的key可覆盖式更新
--- 一般写在setup阶段
---@alias noteMonAction fun(object: any):void
---@alias noteMonRemoveFilter fun(object: any):boolean
---@param key string 唯一key
---@param frequency number 周期间隔，每个周期会把受监听对象回调
---@param actionFunc noteMonAction | "function(object) end" 监听操作
---@param ignoreFilter nil|noteMonRemoveFilter | "function(object) end" 移除监听对象的适配条件
---@return void
function monitor.create(key, frequency, actionFunc, ignoreFilter)
    if (type(key) == "string" and type(actionFunc) == "function") then
        frequency = frequency or 1
        if (type(ignoreFilter) ~= "function") then
            ignoreFilter = nil
        end
        monitor._r[key] = {
            frequency = frequency,
            actionFunc = actionFunc,
            ignoreFilter = ignoreFilter,
        }
    end
end

--- 毁灭一个监听器
---@param key string 唯一key
function monitor.destroy(key)
    if (key == nil) then
        return
    end
    if (monitor._m[key] ~= nil) then
        monitor._m[key].timer.destroy()
        monitor._m[key] = nil
    end
end

--- 检查一个对象是否正在受到监听
---@param key string 唯一key
---@param obj Object 监听对象
---@return boolean
function monitor.isListening(key, obj)
    if (key == nil or obj == nil or obj.isDestroy()) then
        return
    end
    if (monitor._m[key] ~= nil) then
        return monitor._m[key].arr.keyExists(obj.id())
    end
    return false
end

--- 监听对象
---@param key string 唯一key
---@param obj Object 监听对象
function monitor.listen(key, obj)
    if (key == nil or obj == nil or obj.isDestroy()) then
        return
    end
    if (monitor._m[key] == nil) then
        must(monitor._r[key] ~= nil, "unRegisteredActionListened")
        local frequency = monitor._r[key].frequency
        local actionFunc = monitor._r[key].actionFunc
        local ignoreFilter = monitor._r[key].ignoreFilter
        monitor._m[key] = {
            arr = Array(),
            timer = time.setInterval(frequency, function(curTimer)
                local arr = monitor._m[key].arr
                if (arr == nil or arr.count() <= 0) then
                    curTimer.destroy()
                    monitor._m[key] = nil
                    return
                end
                arr.forEach(function(id, o)
                    if (o == nil or o.isDestroy() or (type(ignoreFilter) == "function" and ignoreFilter(o) == true)) then
                        arr.set(id, nil)
                        return
                    end
                    promise(actionFunc, nil, nil, o)
                end)
            end)
        }
    end
    monitor._m[key].arr.set(obj.id(), obj)
end

--- 忽略对象
--- 由于监听器的特殊性和长效性
--- 不建议手动忽略，推荐在 create 时严谨地编写 ignoreFilter 中返回true从而自动忽略
---@protected
---@param key string 唯一key
---@param obj Object 监听对象
function monitor.ignore(key, obj)
    if (key == nil or obj == nil or obj.isDestroy()) then
        return
    end
    if (monitor._m[key] ~= nil) then
        monitor._m[key].arr.set(obj.id(), nil)
    end
end