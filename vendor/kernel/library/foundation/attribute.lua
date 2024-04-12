--- 属性
attribute = attribute or {}

--- 智能属性
---@param attributes table 属性集
---@param targetUnit Unit
---@param lv number 当前等级
---@param diff number 等级差值
---@return void
function attribute.clever(attributes, targetUnit, lv, diff)
    if (isObject(targetUnit, "Unit") == false) then
        return
    end
    if (isObject(targetUnit, "Unit")) then
        for _, a in ipairs(attributes) do
            local key = a[1]
            local t1 = a[2] or 0
            local d1
            local d2
            local params = {}
            if (type(t1) == "number") then
                d1 = t1
                d2 = a[3] or d1
            elseif (type(t1) == "string") then
                d1 = a[3] or 0
                d2 = a[4] or d1
                table.insert(params, t1)
            end
            local v = 0
            if (diff > 0) then
                if (lv <= 0) then
                    v = d1 + (diff - 1) * d2
                else
                    v = diff * d2
                end
            elseif (diff < 0) then
                if (lv + diff < 0) then
                    diff = -lv
                end
                if (lv + diff == 0) then
                    v = -d1 + (diff + 1) * d2
                else
                    v = diff * d2
                end
            end
            if (v > 0) then
                table.insert(params, "+=" .. v)
            elseif (v < 0) then
                table.insert(params, "-=" .. -v)
            end
            targetUnit.prop(key, table.unpack(params))
        end
    end
end