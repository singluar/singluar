local inc = 1

SINGLUAR_MAP_NAME = ''
SINGLUAR_GO_IDS = {}
SINGLUAR_SLK_I2V = {}
SINGLUAR_SLK_N2I = {}
SINGLUAR_ICON = {}
SINGLUAR_MODEL = {}
SINGLUAR_MODEL_U = {}
SINGLUAR_MODEL_I = {}
SINGLUAR_MODEL_D = {}
SINGLUAR_SOUND = { vcm = {}, v3d = {}, bgm = {}, vwp = {}, }
SINGLUAR_WEAPON = {}
SINGLUAR_FONT = ''

-- 用于反向补充slk优化造成的数据丢失问题
-- 如你遇到slk优化后（dist后）地图忽然报错问题，则有可能是优化丢失
SINGLUAR_SLK_FIX = {
    ability = {},
    unit = { "sight", "nsight" },
    destructable = {},
}

-- 音频初始化
SINGLUAR_VOICE_INIT = function()
    for _ = 1, 4 do
        __SINGLUAR_VOICE_INIT__ = 7
    end
end

SINGLUAR_SETTING = function(_v)
    _v._id = SINGLUAR_GO_IDS[inc]
    local id = _v._id
    local data = _v
    SINGLUAR_SLK_I2V[id] = data[id] or {}
    SINGLUAR_SLK_I2V[id]._type = SINGLUAR_SLK_I2V[id]._type or "slk"
    if (JassSlk.unit[id] ~= nil) then
        SINGLUAR_SLK_I2V[id].slk = setmetatable({}, { __index = JassSlk.unit[id] })
        for _, f in ipairs(SINGLUAR_SLK_FIX.unit) do
            if (SINGLUAR_SLK_I2V[id].slk[f] == nil) then
                SINGLUAR_SLK_I2V[id].slk[f] = SINGLUAR_SLK_I2V[id][f] or 0
            end
        end
    elseif (JassSlk.ability[id] ~= nil) then
        SINGLUAR_SLK_I2V[id].slk = setmetatable({}, { __index = JassSlk.ability[id] })
        for _, f in ipairs(SINGLUAR_SLK_FIX.ability) do
            if (SINGLUAR_SLK_I2V[id].slk[f] == nil) then
                SINGLUAR_SLK_I2V[id].slk[f] = SINGLUAR_SLK_I2V[id][f] or 0
            end
        end
    elseif (JassSlk.destructable[id] ~= nil) then
        SINGLUAR_SLK_I2V[id].slk = setmetatable({}, { __index = JassSlk.destructable[id] })
        for _, f in ipairs(SINGLUAR_SLK_FIX.destructable) do
            if (SINGLUAR_SLK_I2V[id].slk[f] == nil) then
                SINGLUAR_SLK_I2V[id].slk[f] = SINGLUAR_SLK_I2V[id][f] or 0
            end
        end
    end
    if (SINGLUAR_SLK_I2V[id].slk) then
        local n = SINGLUAR_SLK_I2V[id].slk.Name
        if (n ~= nil) then
            if (SINGLUAR_SLK_N2I[n] == nil) then
                SINGLUAR_SLK_N2I[n] = {}
            end
            table.insert(SINGLUAR_SLK_N2I[n], id)
        end
    end
    inc = inc + 1
end