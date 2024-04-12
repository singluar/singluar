--- 生成整数段
---@param n1 number integer
---@param n2 number integer
---@return table
function table.section(n1, n2)
    n1 = math.floor(n1)
    n2 = math.floor(n2 or n1)
    local s = {}
    if (n1 == n2) then
        n2 = nil
    end
    if (n2 == nil) then
        for i = 1, n1 do
            table.insert(s, i)
        end
    else
        if (n1 < n2) then
            for i = n1, n2, 1 do
                table.insert(s, i)
            end
        else
            for i = n1, n2, -1 do
                table.insert(s, i)
            end
        end
    end
    return s
end

--- 随机在数组内取N个
--- 如果 n == 1, 则返回某值
--- 如果 n > 1, 则返回table
---@param arr table
---@return nil|any|any[]
function table.rand(arr, n)
    if (type(arr) ~= "table") then
        return
    end
    n = n or 1
    if (n < 1) then
        return
    end
    if (n == 1) then
        return arr[math.rand(1, #arr)]
    end
    local res = {}
    local l = #arr
    while (#res < n) do
        local rge = {}
        for i = 1, l do
            rge[i] = arr[i]
        end
        for i = 1, l do
            local j = math.rand(i, #rge)
            table.insert(res, rge[j])
            if (#res >= n) then
                break
            end
            rge[i], rge[j] = rge[j], rge[i]
        end
    end
    return res
end

--- 洗牌
---@param arr table
---@return table
function table.shuffle(arr)
    local shuffle = table.clone(arr)
    local length = #shuffle
    local times = length
    local temp
    local random
    while (times > 1) do
        random = math.rand(1, length)
        temp = shuffle[times]
        shuffle[times] = shuffle[random]
        shuffle[random] = temp
        times = times - 1
    end
    return shuffle
end

--- 倒序
---@param arr table
---@return table
function table.reverse(arr)
    local r = {}
    for i = #arr, 1, -1 do
        if (type(arr[i]) == "table") then
            table.insert(r, table.reverse(arr[i]))
        else
            table.insert(r, arr[i])
        end
    end
    return r
end

--- 重复table
---@param params any
---@param times number integer
---@return table
function table.repeater(params, times)
    times = math.floor(times or 1)
    local r = {}
    for _ = 1, times do
        table.insert(r, params)
    end
    return r
end

--- 克隆table
---@param org table
---@return table
function table.clone(org)
    local function _cp(org1, res)
        if (JassCommon == nil) then
            for k, v in pairs(org1) do
                if type(v) ~= "table" then
                    res[k] = v
                else
                    res[k] = {}
                    _cp(v, res[k])
                end
            end
        else
            local max = #org1
            for k = 1, max, 1 do
                if type(org1[k]) ~= "table" then
                    res[k] = org1[k]
                else
                    res[k] = {}
                    _cp(org1[k], res[k])
                end
            end
        end
    end
    local res = {}
    _cp(org, res)
    return res
end

--- 合并table
---@vararg table
---@return table
function table.merge(...)
    local tempTable = {}
    local tables = { ... }
    if (tables == nil) then
        return {}
    end
    for _, tn in ipairs(tables) do
        if (type(tn) == "table") then
            if (JassCommon == nil) then
                for k, v in pairs(tn) do
                    tempTable[k] = v
                end
            else
                for _, v in ipairs(tn) do
                    tempTable[#tempTable + 1] = v
                end
            end
        end
    end
    return tempTable
end

--- 在数组内
---@param arr table
---@param val any
---@return boolean
function table.includes(arr, val)
    local isIn = false
    if (val == nil or #arr <= 0) then
        return isIn
    end
    for _, v in ipairs(arr) do
        if (v == val) then
            isIn = true
            break
        end
    end
    return isIn
end

--- 删除数组一次某个值(qty次,默认删除全部)
---@param arr table
---@param val any
---@param qty number
function table.delete(arr, val, qty)
    qty = qty or -1
    local q = 0
    for k, v in ipairs(arr) do
        if (v == val) then
            q = q + 1
            table.remove(arr, k)
            k = k - 1
            if (qty ~= -1 and q >= qty) then
                break
            end
        end
    end
end

--- 根据key从数组table返回一个对应值的数组
---@param arr table
---@param key string
---@return table
function table.value(arr, key)
    local values = {}
    if (arr ~= nil and key ~= nil and #arr > 0) then
        for _, v in ipairs(arr) do
            if (v[key] ~= nil) then
                table.insert(values, v[key])
            end
        end
    end
    return values
end

--- 比较两个数组是否相同（地址可以不同，数据相同）
---@param arr1 table array
---@param arr2 table array
---@return boolean
function table.equal(arr1, arr2)
    if (arr1 == nil and arr2 == nil) then
        return true
    end
    if (arr1 == nil or arr2 == nil) then
        return false
    end
    if (type(arr1) == "table" and type(arr2) == "table") then
        if (#arr1 ~= #arr2) then
            return false
        end
        if (#arr1 == 0) then
            return arr1 == arr2
        end
        local res = true
        if (arr1.__NAME__ ~= nil or arr2.__NAME__ ~= nil) then
            res = arr1.__ID__ == arr2.__ID__
        else
            for i, v in ipairs(arr1) do
                if (type(v) == "table") then
                    res = table.equal(v, arr2[i])
                else
                    res = (v == arr2[i])
                end
                if (res == false) then
                    break
                end
            end
        end
        return res
    end
    return false
end

--- 计算数组平均数，如果某值不是number，会先强制转换，失败以0计算
---@param arr number[]
---@return number
function table.average(arr)
    if (arr == nil or type(arr) ~= "table" or #arr == 0) then
        return 0
    end
    local avg = 0
    local aci = 0
    for _, v in ipairs(arr) do
        if (type(v) ~= "number") then
            v = tonumber(v, 10)
            if (v == nil) then
                v = 0
            end
        end
        avg = avg + v
        aci = aci + 1
    end
    return avg / aci
end

--- 数组轮偏
---@param arr any[]
---@param offset number
---@return any[]
function table.wheel(arr, offset)
    offset = offset or 0
    if (type(arr) ~= "table") then
        return {}
    end
    local l = #arr
    if (l == 0) then
        return {}
    end
    local s = offset % l
    if (s < 0) then
        s = s + l
    end
    local new = {}
    for i = 1, l do
        s = s + 1
        if (s > l) then
            s = 1
        end
        new[i] = arr[s]
    end
    return new
end

--- 数组切片
---@param arr any[]
---@param i number 起始索引
---@param j number 终止索引，当j小于i时将反向切片
---@return any[]
function table.slice(arr, i, j)
    if (type(arr) ~= "table" or type(i) ~= "number" or type(j) ~= "number") then
        return {}
    end
    local l = #arr
    if (l == 0) then
        return {}
    end
    local slice = {}
    if (i < j) then
        for k = i, j, 1 do
            slice[#slice + 1] = arr[k]
        end
    elseif (i > j) then
        for k = i, j, -1 do
            slice[#slice + 1] = arr[k]
        end
    end
    return slice
end