_ttg_limit = 100
_ttg_limiter = _ttg_limiter or 0
_ttg_char = _ttg_char or {}
_ttg_site = _ttg_site or {}

---@class ttg
ttg = ttg or {}

--- 注册字符对应的模型和位宽
---@param char string
---@param modelAlias string
---@param bit number
function ttg.char(char, modelAlias, bit)
    _ttg_char[tostring(char)] = { modelAlias, bit }
end

--- 字串漂浮字
---@see str string 漂浮字信息
---@see width number 字间
---@see speed number 速度
---@see size number 尺寸
---@see scale {number,number} 缩放变化
---@see x number 创建坐标X
---@see y number 创建坐标Y
---@see z number 创建坐标Z
---@see height number 上升高度
---@see duration number 持续时间
---@param options {str:number,width:number,speed:number,size:number,scale:{number,number},x:number,y:number,z:number,height:number,duration:number}
function ttg.word(options)
    if (_ttg_limiter > _ttg_limit) then
        return
    end
    local str = tostring(options.str) or ""
    local width = options.width or 10
    local speed = options.speed or 1
    local size = options.size or 0.25
    local scale = options.scale or { 1, 1 }
    local x = options.x or 0
    local y = options.y or 0
    local z = options.z or 150
    local height = options.height or 200
    local duration = options.duration or 0.5
    local frequency = 0.05
    local spd = height / (duration / frequency)
    --
    local words = mbstring.split(str, 1)
    if (#words > 0) then
        x = math.floor(x)
        y = math.floor(y)
        local site = x .. y
        if (_ttg_site[site] == nil) then
            _ttg_site[site] = {}
        end
        if (_ttg_site[site][str] == nil) then
            _ttg_site[site][str] = true
            time.setTimeout(0.2, function()
                _ttg_site[site][str] = nil
            end)
            _ttg_limiter = _ttg_limiter + 1
            local effs = {}
            for i, w in ipairs(words) do
                must(_ttg_char[w] ~= nil)
                local mdl = _ttg_char[w][1]
                local bit = _ttg_char[w][2]
                effs[i] = effect.xyz(mdl, x + ((i - 1) * width * bit), y, z, -1)
                effect.speed(effs[i], speed)
                effect.scale(effs[i], size, size, size)
            end
            local dur = 0
            local h = z
            local ani = 0
            time.setInterval(frequency, function(curTimer)
                dur = dur + frequency
                if (dur >= duration) then
                    curTimer.destroy()
                    for i, _ in ipairs(words) do
                        effect.destroy(effs[i])
                    end
                    _ttg_limiter = _ttg_limiter - 1
                    return
                end
                h = h + spd
                local s1
                local s2
                if (scale[1] ~= 1 or scale[2] ~= 1) then
                    ani = ani + frequency
                    if (ani >= 0.1) then
                        ani = 0
                        if (dur < duration * 0.5) then
                            s1 = scale[1]
                            width = width * s1
                        else
                            s2 = scale[2]
                            width = width * s2
                        end
                    end
                end
                for i, w in ipairs(words) do
                    japi.EXSetEffectZ(effs[i], h)
                    if (s1 ~= nil) then
                        japi.EXSetEffectXY(effs[i], x + ((i - 1) * width * _ttg_char[w][2]), y)
                        japi.EXEffectMatScale(effs[i], s1, s1, s1)
                    elseif (s2 ~= nil) then
                        japi.EXSetEffectXY(effs[i], x + ((i - 1) * width * _ttg_char[w][2]), y)
                        japi.EXEffectMatScale(effs[i], s2, s2, s2)
                    end
                end
            end)
        end
    end
end


-- 模型漂浮字
---@see model string 模型路径
---@see speed number 速度
---@see size number 尺寸
---@see scale number 缩放
---@see x number 创建坐标X
---@see y number 创建坐标Y
---@see z number 创建坐标Z
---@see offset number 偏移
---@see height number 上升高度
---@see duration number 持续时间
---@param options {model:string,speed:number,size:number,scale:number,x:number,y:number,z:number,offset:number,height:number,duration:number}
function ttg.model(options)
    local model = AModel(options.model)
    if (model == nil) then
        return
    end
    if (_ttg_limiter > _ttg_limit) then
        return
    end
    local size = options.size or 0.25
    local scale = options.scale or { 1, 1 }
    local x = options.x or 0
    local y = options.y or 0
    local z = options.z or 150
    local offset = math.floor(options.offset or 0)
    local height = options.height or 1000
    local speed = options.speed or 1
    local duration = options.duration or 1
    local frequency = 0.05
    x = math.floor(x)
    y = math.floor(y)
    local site = x .. y
    if (_ttg_site[site] == nil) then
        _ttg_site[site] = {}
    end
    if (_ttg_site[site][model] == nil) then
        _ttg_site[site][model] = true
        time.setTimeout(duration, function()
            _ttg_site[site][model] = nil
        end)
        _ttg_limiter = _ttg_limiter + 1
        local spd = height / (duration / frequency)
        local eff = effect.xyz(model, x, y, z, -1)
        effect.speed(eff, speed)
        effect.scale(eff, size, size, size)
        local dur = 0
        local h = z
        local randX = 0
        local randY = 0
        if (offset ~= 0) then
            randX = math.rand(-offset, offset)
            randY = math.rand(-offset, offset)
        end
        local ani = 0
        time.setInterval(frequency, function(curTimer)
            dur = dur + frequency
            if (dur >= duration) then
                curTimer.destroy()
                effect.destroy(eff)
                _ttg_limiter = _ttg_limiter - 1
                return
            end
            h = h + spd
            local s1
            local s2
            if (scale[1] ~= 1 or scale[2] ~= 1) then
                ani = ani + frequency
                if (ani >= 0.1) then
                    ani = 0
                    if (dur < duration * 0.5) then
                        s1 = scale[1]
                    else
                        s2 = scale[2]
                    end
                end
            end
            x = x + randX
            y = y + randY
            japi.EXSetEffectXY(eff, x, y)
            japi.EXSetEffectZ(eff, h)
            if (s1 ~= nil) then
                japi.EXEffectMatScale(eff, s1, s1, s1)
            elseif (s2 ~= nil) then
                japi.EXEffectMatScale(eff, s2, s2, s2)
            end
        end)
    end
end