group = group or {}
group._d = group._d or {}

--- 对象集
---@param key string
---@return Array
function group.data(key)
    if (type(key) ~= "string") then
        return nil
    end
    if (group._d[key] == nil) then
        group._d[key] = Array()
    end
    return group._d[key]
end

--- 添加对象
---@param whichObj Object|Unit|Item
---@return void
function group.push(whichObj)
    if (whichObj.__NAME__ ~= nil) then
        local d = group.data(whichObj.__NAME__)
        if (d ~= nil and false == d.keyExists(whichObj.__ID__)) then
            d.set(whichObj.__ID__, whichObj)
        end
    end
end

--- 删除对象
---@param whichObj Object|Unit|Item
---@return void
function group.remove(whichObj)
    if (whichObj.__NAME__ ~= nil) then
        group.data(whichObj.__NAME__).set(whichObj.__ID__, nil)
    end
end

--- 根据条件，获取对象数组
---@alias unitGroupFilter {key:string|"Unit"|"Item",rect:Rect,x:number,y:number,radius:number,width:number,height:number,limit:number,filter:fun(enumObj:Object|Unit|Item)}
---@param options unitGroupFilter
---@return Unit[]|Item[]
function group.catch(options)
    local res = {}
    local d = group.data(options.key)
    if (d == nil) then
        return res
    end
    d.forEach(function(_, enumObj)
        if (enumObj == nil) then
            group.remove(enumObj)
            return
        end
        local x = enumObj.x()
        local y = enumObj.y()
        if (isObject(options.rect, "Rect")) then
            if (false == options.rect.isInside(x, y)) then
                return
            end
        end
        if (type(options.x) == "number" and type(options.y) == "number") then
            if (type(options.radius) == "number") then
                if (options.radius < math.distance(options.x, options.y, x, y)) then
                    return
                end
            end
            if (type(options.width) == "number" and type(options.height) == "number") then
                local xMin = options.x - options.width * 0.5
                local yMin = options.y - options.height * 0.5
                local xMax = options.x + options.width * 0.5
                local yMax = options.y + options.height * 0.5
                if ((x < xMax and x > xMin and y < yMax and y > yMin) == false) then
                    return
                end
            end
        end
        if (type(options.filter) == "function") then
            if (options.filter(enumObj) == true) then
                table.insert(res, enumObj)
            end
        else
            table.insert(res, enumObj)
        end
        local limit = options.limit or 100
        if (#res >= limit) then
            return false
        end
    end)
    return res
end

--- 遍历单位组
---@param filter unitGroupFilter
---@param action fun(enumObj: Unit):void
---@return void
function group.forEach(filter, action)
    local catch = group.catch(filter)
    if (#catch > 0) then
        for _, c in ipairs(catch) do
            action(c)
        end
    end
end

--- 获取组内随机一个单位
---@param filter unitGroupFilter
---@return Unit|nil
function group.rand(filter)
    local catch = group.catch(filter)
    if (#catch > 0) then
        return table.rand(catch)
    end
end

--- 获取组内离选定的(x,y)最近的单位
--- 必须设定filter里面的x,y参数,radius默认600
---@param filter unitGroupFilter
---@return Unit|nil
function group.closest(filter)
    if (filter.x == nil or filter.y == nil) then
        return nil
    end
    filter.radius = filter.radius or 600
    local catch = group.catch(filter)
    if (#catch <= 0) then
        return nil
    end
    local closer
    local closestDst = 99999
    for _, c in ipairs(catch) do
        local dst = math.distance(filter.x, filter.y, c.x(), c.y())
        if (dst < closestDst) then
            closer = c
            closestDst = dst
        end
    end
    return closer
end