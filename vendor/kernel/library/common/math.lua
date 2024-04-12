math._r2d = 180 / math.pi
math._d2r = math.pi / 180
if (JassCommon ~= nil) then
    -- 禁用lua自带方法引用
    math.random = nil
end

--- 判断数字是否为NaN
---@param decimal number
---@return boolean
function math.isNaN(decimal)
    local s = tostring(decimal)
    if (s == "inf" or s == "-nan(ind)") then
        return true
    end
    return false
end

--- 四舍五入取整
---@param decimal number
---@return number integer
function math.round(decimal)
    return math.floor(decimal + 0.5)
end

--- 随机整数
---@param n number
---@param m number
---@return number
function math.rand(n, m)
    if (n == nil or m == nil) then
        return 0
    end
    m = math.floor(m)
    n = math.floor(n)
    if (n == m) then
        return n
    end
    if (m < n) then
        return J.GetRandomInt(m, n)
    end
    return J.GetRandomInt(n, m)
end

--- 随机切割整数
---@param digit number integer 被切割的数
---@param n number integer 切割份数
---@return number[]
function math.divide(digit, n)
    digit = math.floor(digit)
    n = math.floor(n)
    if (n < 1) then
        n = 1
    end
    local div = {}
    while (n > 1) do
        n = n - 1
        local d = math.rand(0, digit)
        div[#div + 1] = d
        digit = digit - d
    end
    div[#div + 1] = digit
    return div
end

--- 数字格式化
---@param decimal number 数字
---@param n number 小数最大截断位，默认2位
---@return string
function math.format(decimal, n)
    n = math.floor(n or 2)
    if (n < 1) then
        return math.floor(decimal)
    end
    return string.format('%.' .. n .. 'f', decimal)
end

--- 数字位数截断
---@param decimal number 数字
---@param n number 小数最大截断位，默认2位
---@return number
function math.trunc(decimal, n)
    return tonumber(math.format(decimal, n))
end

--- 两数正差额
---@param value1 number 数字1
---@param value2 number 数字2
---@return number
function math.disparity(value1, value2)
    if (value1 >= value2) then
        return value1 - value2
    end
    return value2 - value1
end

--- 数字格式化
---@param value number
---@param n number 小数最大截断位，默认2位
---@return string
function math.numberFormat(value, n)
    n = math.floor(n or 2)
    if (n < 1) then
        n = 2
    end
    if (value > 999999999999) then
        return string.format("%." .. n .. "f", value / 1000000000000) .. "T"
    elseif (value > 999999999) then
        return string.format("%." .. n .. "f", value / 1000000000) .. "B"
    elseif (value > 999999) then
        return string.format("%." .. n .. "f", value / 1000000) .. "M"
    elseif (value > 9999) then
        return string.format("%." .. n .. "f", value / 1000) .. "K"
    else
        return string.format("%." .. n .. "f", value)
    end
end

--- 整型格式化
---@param value number
---@return string
function math.integerFormat(value)
    if (value > 999999999999) then
        return math.floor(value / 1000000000000) .. "T"
    elseif (value > 999999999) then
        return math.floor(value / 1000000000) .. "B"
    elseif (value > 999999) then
        return math.floor(value / 1000000) .. "M"
    elseif (value > 9999) then
        return math.floor(value / 1000) .. "K"
    else
        return tostring(math.floor(value))
    end
end

--- 极坐标位移
---@param x number
---@param y number
---@param dist number
---@param angle number
---@return number,number
function math.polar(x, y, dist, angle)
    local tx = x + dist * math.cos(angle * math._d2r)
    local ty = y + dist * math.sin(angle * math._d2r)
    if (tx < RectPlayable.xMin()) then
        tx = RectPlayable.xMin()
    elseif (tx > RectPlayable.xMax()) then
        tx = RectPlayable.xMax()
    end
    if (ty < RectPlayable.yMin()) then
        ty = RectPlayable.yMin()
    elseif (ty > RectPlayable.yMax()) then
        ty = RectPlayable.yMax()
    end
    return tx, ty
end

--- 获取两个坐标间角度，如果其中一个单位为空 返回0
--- 返回的范围是[0-360(0)]
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function math.angle(x1, y1, x2, y2)
    return math.trunc((math._r2d * math.atan(y2 - y1, x2 - x1) + 360) % 360, 4)
end

--- 获取两个坐标距离
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function math.distance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

--- 时间戳转日期对象
---@param timestamp number Unix时间戳
---@return table {Y:"年",m:"月",d:"日",H:"时",i:"分",s:"秒",w:"周[0-6]",W:"周[日-六]"}
function math.date(timestamp)
    local d = os.date("%Y|%m|%d|%H|%M|%S|%w", timestamp)
    d = string.explode("|", d)
    local W = { "日", "一", "二", "三", "四", "五", "六" }
    return {
        Y = d[1],
        m = d[2],
        d = d[3],
        H = d[4],
        i = d[5],
        s = d[6],
        w = d[7],
        W = W[d[7] + 1],
    }
end

--- 判断两个单位是否接近平行同方向，本质上是两单位面向角度接近
--- x1,y1,facing1 是第1个单位的坐标和面向角度
--- x2,y2,facing2 是第2个单位的坐标和面向角度
---@param maxDistance number 最大相对距离
---@param forcedOrder boolean 是否强制顺序，也就是主观上必须 1 站在前，2在后
---@type fun(OtherUnit:Unit, maxDistance:number, forcedOrder:boolean):boolean
function math.parallel(x1, y1, facing1, x2, y2, facing2, maxDistance, forcedOrder)
    maxDistance = maxDistance or 99999
    if (math.distance(x1, y1, x2, y2) > maxDistance) then
        return false
    end
    if (type(forcedOrder) == "boolean" and forcedOrder == true) then
        return math.abs(facing1 - facing2) < 50 and math.abs(math.angle(x2, y2, x1, y1) - facing2) < 90
    end
    return math.abs(facing1 - facing2) < 50
end

--- 判断两个单位是否"正对着"或"背对着"，本质上是两单位面向极度相反
--- x1,y1,facing1 是第1个单位的坐标和面向角度
--- x2,y2,facing2 是第2个单位的坐标和面向角度
---@param maxDistance number 最大相对距离
---@param face2face boolean 是否【面对面】而不是【背对背】
---@return number
function math.intersect(x1, y1, facing1, x2, y2, facing2, maxDistance, face2face)
    maxDistance = maxDistance or 99999
    if (math.distance(x1, y1, x2, y2) > maxDistance) then
        return false
    end
    if (type(face2face) == "boolean" and face2face == true) then
        return math.abs((math.abs(facing1 - facing2) - 180)) < 50 and math.abs(math.angle(x2, y2, x1, y1) - facing2) < 90
    end
    return math.abs((math.abs(facing1 - facing2) - 180)) < 50
end

--- 升级经验计算
---@param max number 最大等级
---@param fixed number 每级需要经验固定值
---@param ratio number 每级需要经验对上一级提升百分比(默认固定提升)
---@param limit number 每级需要经验上限
---@return number[]
function math.expNeeds(max, fixed, ratio, limit)
    local needs = {}
    local need = 0
    for i = 1, math.max(1, max) do
        if (i > 1) then
            fixed = math.max(1, fixed)
            ratio = math.max(1.00, ratio)
            local add = need * (ratio - 1.00) + fixed
            if (add >= limit) then
                add = limit
                need = math.floor(need / limit) * limit
            end
            need = need + add
            need = math.floor(need / 10) * 10
        end
        needs[i] = math.ceil(need)
    end
    return needs
end

--- 高度斜率的角度
---@param z1 number
---@param z2 number
---@param distance number
---@return number
function math.slopeAngle(z1, z2, distance)
    return math._r2d * math.atan(z2 - z1, distance)
end

--- 目标转换坐标值
---@param target Unit|Item|{number,number} 目标
---@return number,number
function math.coordinate(target)
    if (isObject(target, "Unit") or isObject(target, "Item")) then
        return target.x(), target.y()
    elseif (type(target) == "table") then
        return target[1], target[2]
    end
    return 0, 0
end

--- 奇妙计算
--- 专算字符串 ; == += -= *= /= 其他类型跳过
---@param variety string 目标值，如："+=10" | "*=10"
---@param base number|nil 基值|数字时可用，其他类型不可用
---@return any,number|nil diff只有在数字类型才会存在
function math.cale(variety, base)
    local val = variety
    local diff
    if (type(variety) == "string") then
        local opr = string.sub(variety, 1, 2)
        if (opr == "+=" or opr == "-=" or opr == "*=" or opr == "/=") then
            -- 相对值时必须带数字型基值
            if (opr == "*=" or opr == "/=") then
                if (type(base) ~= "number") then
                    return val
                end
            end
            local vd = tonumber(string.sub(val, 3))
            if (vd ~= nil) then
                val = base or 0
                if (opr == "+=") then
                    diff = vd
                elseif (opr == "-=") then
                    diff = -vd
                elseif (opr == "*=") then
                    if (vd >= 1) then
                        diff = base * (vd - 1)
                    elseif (vd > 0) then
                        diff = base * vd
                    else
                        diff = 0
                    end
                elseif (opr == "/=") then
                    if (vd >= 1) then
                        diff = base * (1 - (1 / vd))
                    elseif (vd > 0) then
                        diff = base * (1 / vd)
                    else
                        diff = 0
                    end
                end
                val = val + diff
            end
        end
    end
    return val, diff
end