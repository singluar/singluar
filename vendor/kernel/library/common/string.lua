string._randChars = {
    "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
    "~", "$", "#", "@", "!", "%", "^", "&", "*", "-", "+"
}

--[[
    允许使用方括号索引到字符串
    s = "hello"
    s[1] = "h"
]]
---@param str string
---@param i number
---@return string
getmetatable('').__index = function(str, i)
    if (type(i) == 'number') then
        return string.sub(str, i, i)
    end
    return string[i]
end

--[[
    允许使用前后两个索引执行括号法返回子字符串
    s = "hello"
    s(2,5) = "ello"

    如果只有单索引，则返回byte(unicode)
    s = "hello"
    s(2) = 101 (e)

    如果第二个索引为字符串，则进行替换
    s = "hello"
    s(2,'p') = "hpllo"
]]
---@param str string
---@param i number
---@param j number
---@return string
getmetatable('').__call = function(str, i, j)
    if (type(i) == 'number' and type(j) == 'number') then
        return string.sub(str, i, j)
    elseif (type(i) == 'number' and type(j) == 'string') then
        return table.concat { string.sub(str, 1, i - 1), j, string.sub(str, i + 1) }
    elseif (type(i) == 'number' and type(j) == 'nil') then
        return string.byte(str, i)
    end
    return string[i]
end

--- 转义
---@param s string
---@return string
function string.addslashes(s)
    local in_char = { "\\", '"', "/", "\b", "\f", "\n", "\r", "\t" }
    local out_char = { "\\", '"', "/", "b", "f", "n", "r", "t" }
    for i, c in ipairs(in_char) do
        s = s:gsub(c, "\\" .. out_char[i])
    end
    return s
end

--- 反转义
---@param s string
---@return string
function string.stripslashes(s)
    local in_char = { "\\", '"', "/", "b", "f", "n", "r", "t" }
    local out_char = { "\\", '"', "/", "\b", "\f", "\n", "\r", "\t" }

    for i, c in ipairs(in_char) do
        s = s:gsub("\\" .. c, out_char[i])
    end
    return s
end

--- 把字符串以分隔符打散为数组
---@param delimeter string
---@param str string
---@return table
function string.explode(delimeter, str)
    local res = {}
    local start, start_pos, end_pos = 1, 1, 1
    while true do
        start_pos, end_pos = string.find(str, delimeter, start, true)
        if not start_pos then
            break
        end
        table.insert(res, string.sub(str, start, start_pos - 1))
        start = end_pos + 1
    end
    table.insert(res, string.sub(str, start))
    return res
end

--- 把数组以分隔符拼接回字符串
---@param delimeter string
---@param table table
---@return string
function string.implode(delimeter, table)
    local str
    for _, v in ipairs(table) do
        if (str == nil) then
            str = v
        else
            str = str .. delimeter .. v
        end
    end
    return str
end

--- 分隔字符串
---@param str string
---@param size number 每隔[size]字符切一次
---@return string
function string.split(str, size)
    local sp = {}
    local len = string.len(str)
    if (len <= 0) then
        return sp
    end
    size = size or 1
    local i = 1
    while (i <= len) do
        table.insert(sp, string.sub(str, i, i + size - 1))
        i = i + size
    end
    return sp
end

--- 统计某个子串出现的首位,不包含返回false
---@param str string
---@param pattern string
---@return number|boolean
function string.subPos(str, pattern)
    if (str == nil or pattern == nil) then
        return false
    end
    local s = string.find(str, pattern, 0)
    if (type(s) == "number") then
        return s
    else
        return false
    end
end

--- 找出某个子串出现的所有位置
---@param str string
---@param pattern string
---@return table
function string.subAllPos(str, pattern)
    if (str == nil or pattern == nil) then
        return
    end
    local s
    local e = 0
    local res = {}
    while (true) do
        s, e = string.find(str, pattern, e + 1)
        if (s == nil) then
            break
        end
        table.insert(res, { s, e })
        if (e == nil) then
            break
        end
    end
    return res
end

--- 统计某个子串出现的次数
---@param str string
---@param pattern string
---@return number
function string.subCount(str, pattern)
    if (str == nil or pattern == nil) then
        return 0
    end
    local s
    local e = 0
    local qty = 0
    while (true) do
        s, e = string.find(str, pattern, e + 1)
        if (s == nil) then
            break
        end
        qty = qty + 1
        if (e == nil) then
            break
        end
    end
    return qty
end

--- 汇总两标志的所有匹配
---@param str string
---@param head string 如'('
---@param tail string 如')'
---@return table<number,{number,number,number}> {start,end,inner}
function string.subBetween(str, head, tail)
    local res = {}
    if (str ~= nil and head ~= nil and head ~= tail) then
        local s
        local t
        local i = 0
        while (true) do
            if (s == nil) then
                s, i = string.find(str, head, i + 1)
                if (s == nil) then
                    break
                end
            else
                t, i = string.find(str, tail, i + 1)
                if (t == nil) then
                    break
                end
                table.insert(res, { s - string.len(head), t + string.len(tail), string.sub(str, s + 1, t - 1) })
                s = nil
            end
            if (i == nil) then
                break
            end
        end
    end
    return res
end

--- 移除字符串两侧的空白字符或其他预定义字符
---@param str string
---@return string
function string.trim(str)
    local res = string.gsub(str, "^%s*(.-)%s*$", "%1")
    return res
end

--- 替换字符串
---@param str string
---@return string
function string.replace(str, pattern, repl)
    local res = string.gsub(str, pattern, repl)
    return res
end

--- 随机字符串
---@param n number
---@return string
function string.rand(n)
    n = math.floor(n or 0)
    if (n <= 0) then
        return ""
    end
    local s = ""
    for _ = 1, n do
        s = s .. string._randChars[math.rand(1, #string._randChars)]
    end
    return s
end

--- 参数地址
---@param param any
---@return string
function string.address(param)
    local a = ""
    if (type(param) == "function") then
        a = string.gsub(tostring(param), "function: ", '')
    elseif (type(param) == "table") then
        a = string.gsub(tostring(param), "table: ", '')
    elseif (type(param) == "userdata") then
        a = string.gsub(tostring(param), "handle: ", '')
    else
        a = type(param) .. ": " .. tostring(param)
    end
    return a
end

--- 重复字串
---@param str string
---@param times number integer
---@return string
function string.repeater(str, times)
    times = math.floor(times or 1)
    local r = ''
    for _ = 1, times do
        r = r .. str
    end
    return r
end

--- 填充
---@param str string 原字串
---@param length number 最终长度
---@param pack string 填充字符
---@param isLeft boolean 是否左侧填充
---@return string
function string.fill(str, length, pack, isLeft)
    if (string.len(pack) < 1 or string.len(str) >= length) then
        return str
    end
    if ((length - string.len(str)) % string.len(pack) ~= 0) then
        return str
    end
    local left = true
    if (type(isLeft) == "boolean") then
        left = isLeft
    end
    local new = str or ""
    while (string.len(new) < length) do
        if (left == true) then
            new = pack .. new
        else
            new = new .. pack
        end
    end
    return new
end