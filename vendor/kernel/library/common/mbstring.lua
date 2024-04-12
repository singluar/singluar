mbstring = mbstring or {}

--- 获取字符串真实长度
---@param inputStr string
---@return number
function mbstring.len(inputStr)
    local lenInByte = #inputStr
    local width = 0
    local i = 1
    while (i <= lenInByte) do
        local curByte = string.byte(inputStr, i)
        local byteCount = 1
        if curByte > 0 and curByte <= 127 then
            byteCount = 1 -- 1字节字符
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 2 -- 双字节字符
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 3 -- 汉字
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 4 -- 4字节字符
        end
        i = i + byteCount -- 重置下一字节的索引
        width = width + 1 -- 字符的个数（长度）
    end
    return width
end

--- 获取字符串视图长度
---@param inputStr string
---@param fontSize number 字体大小,默认10
---@param width number 一个字符占的位置
---@param widthCN number 一个汉字占的位置
---@return number
function mbstring.viewWidth(inputStr, fontSize, width, widthCN)
    if (type(inputStr) == "number") then
        inputStr = tostring(inputStr)
    end
    if (type(inputStr) ~= "string") then
        return 0
    end
    local cff = string.subCount(inputStr, "|cff") * 12
    local l1 = string.len(inputStr) - cff
    local l2 = mbstring.len(inputStr) - cff
    local cn = (l1 - l2) / 2
    local xn = l2 - cn
    local fv = FONT_VIEW[SINGLUAR_FONT] or FONT_VIEW.default
    fontSize = (fontSize or 10) * 0.001
    width = width or (fontSize * fv.cr)
    widthCN = widthCN or (fontSize * fv.zh)
    return xn * width + cn * widthCN
end

--- 获取字视图高度
---@param line number 行数
---@param fontSize number 字体大小,默认10
---@param height number 一个字符占的高度
---@return number
function mbstring.viewHeight(line, fontSize, height)
    if (line <= 0) then
        return 0
    end
    local fv = FONT_VIEW[SINGLUAR_FONT] or FONT_VIEW.default
    fontSize = (fontSize or 10) * 0.001
    height = height or (fontSize * fv.h)
    return line * height
end

--- 分隔字符串(支持中文)
---@param str string
---@param size number 每隔[size]个字切一次
---@return string[]
function mbstring.split(str, size)
    local sp = {}
    local lenInByte = #str
    if (lenInByte <= 0) then
        return sp
    end
    size = size or 1
    local count = 0
    local i0 = 1
    local i = 1
    while (i <= lenInByte) do
        local curByte = string.byte(str, i)
        local byteCount = 1
        if curByte > 0 and curByte <= 127 then
            byteCount = 1 -- 1字节字符
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 2 -- 双字节字符
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 3 -- 汉字
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 4 -- 4字节字符
        end
        count = count + 1 -- 字符的个数（长度）
        i = i + byteCount -- 重置下一字节的索引
        if (count >= size) then
            table.insert(sp, string.sub(str, i0, i - 1))
            i0 = i
            count = 0
        elseif (i > lenInByte) then
            table.insert(sp, string.sub(str, i0, lenInByte))
        end
    end
    return sp
end