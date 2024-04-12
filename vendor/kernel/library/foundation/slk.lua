--- slk专用管理
slk = slk or {}

--- 根据ID获取slk数据（包含原生的slk和hslk）
--- 原生的slk数值键值是根据地图编辑器作为标准的，所以大小写也是与之一致
---@param id string|number
---@vararg string 可选，直接获取级层key的值，如 hslk.i2v("slk","Primary") "STR"
---@return table|nil
slk.i2v = function(id, ...)
    if (id == nil) then
        return
    end
    if (type(id) == "number") then
        id = i2c(id)
    end
    if (SINGLUAR_SLK_I2V[id] == nil) then
        return
    end
    local n = select("#", ...)
    if (n > 0) then
        local val = SINGLUAR_SLK_I2V[id]
        for i = 1, n, 1 do
            local k = select(i, ...)
            if (val[k] ~= nil) then
                val = val[k]
            else
                val = nil
            end
            if (val == nil) then
                break
            end
        end
        return val
    end
    return SINGLUAR_SLK_I2V[id]
end

--- 根据名称获取ID
--- 根据名称只对应一个ID，返回string
--- 根据名称如对应多个ID，返回table
---@param name string
---@return string|table|nil
slk.n2i = function(name)
    if (type(name) ~= "string") then
        return
    end
    if (SINGLUAR_SLK_N2I[name] == nil or type(SINGLUAR_SLK_N2I[name]) ~= "table") then
        print("NameNotExist=", name)
        return
    end
    if (#SINGLUAR_SLK_N2I[name] == 1) then
        return SINGLUAR_SLK_N2I[name][1]
    end
    return SINGLUAR_SLK_N2I[name]
end
