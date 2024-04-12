---@class Buff:Object
---@param obj Object 作用对象
---@param key string
---@param duration number
---@param diff number 差异额
---@param purpose fun(buffObj:Object):void
---@param rollback fun(buffObj:Object):void
---@return nil|Buff
function Buff(obj, key, duration, diff, purpose, rollback)
    if (type(obj) ~= "table" and obj.id() == nil) then
        return nil
    end
    if (key == nil) then
        return nil
    end
    duration = duration or -1
    obj = obj
    diff = diff or 0
    return Object("Buff", {
        key = key,
        duration = duration,
        diff = diff,
        purpose = purpose,
        rollback = rollback,
        obj = obj,
    })
end

---@protected
---@return Array|nil
function Buffs(obj)
    return obj.__BUFF__
end

--- buff提取器
---@param obj Object 作用对象
---@alias forwardType boolean 正序(true)|反序(false)
---@alias buffFilter {forward:forwardType,key:string,diff:any,limit:number,filter:fun(enumBuff:Buff)}
---@param options buffFilter
---@return Buff[]
function BuffCatcher(obj, options)
    local catch = {}
    local b = Buffs(obj)
    if (type(obj) == "table" and obj.id() ~= nil) then
        if (isArray(b)) then
            local each = "forEach"
            if (type(options) == "table") then
                if (type(options.forward) ~= "boolean") then
                    options.forward = true
                end
                if (options.forward == false) then
                    each = "backEach"
                end
                if (type(options.limit) ~= "number") then
                    options.limit = 100
                end
            end
            ---@param enumBuff Buff
            b[each](function(ek, enumBuff)
                if (enumBuff.isDestroy()) then
                    b.set(ek, nil)
                    return
                end
                if (type(options) == "table") then
                    if (#catch >= options.limit) then
                        return false
                    end
                    if (type(options.key) == "string") then
                        if (options.key ~= enumBuff.key()) then
                            return
                        end
                    end
                    if (options.diff ~= nil) then
                        if (options.diff ~= enumBuff.diff()) then
                            return
                        end
                    end
                    if (type(options.filter) == "function") then
                        if (options.filter(enumBuff) ~= true) then
                            return
                        end
                    end
                end
                table.insert(catch, enumBuff)
            end)
        end
    end
    return catch
end

--- buff清理
---@param obj Object 作用对象
---@param options buffFilter
function BuffClear(obj, options)
    local buffs = BuffCatcher(obj, options)
    if (#buffs > 0) then
        for _, b in ipairs(buffs) do
            b.rollback()
        end
    end
end
