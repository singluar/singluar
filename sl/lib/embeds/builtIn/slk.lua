local defaultData = function(_v)
    local dfd = {
        Art = "Singluar\\ui\\default.tga",
        unitSound = "",
        scale = 1.0,
        backSw1 = 0.3,
        dmgpt1 = 0.3,
        movetp = "foot",
        moveHeight = 0,
    }
    if (_v.isDef == true) then
        if (_SLK_ORIGIN_DATA[_v.file] ~= nil) then
            if (_SLK_ORIGIN_DATA[_v.file].unitSound ~= nil) then
                dfd.unitSound = _SLK_ORIGIN_DATA[_v.file].unitSound
            end
            if (_SLK_ORIGIN_DATA[_v.file].scale ~= nil) then
                dfd.scale = _SLK_ORIGIN_DATA[_v.file].scale
            end
            if (_SLK_ORIGIN_DATA[_v.file].backSw1 ~= nil) then
                dfd.backSw1 = _SLK_ORIGIN_DATA[_v.file].backSw1
            end
            if (_SLK_ORIGIN_DATA[_v.file].dmgpt1 ~= nil) then
                dfd.dmgpt1 = _SLK_ORIGIN_DATA[_v.file].dmgpt1
            end
            if (_SLK_ORIGIN_DATA[_v.file].movetp ~= nil) then
                dfd.movetp = _SLK_ORIGIN_DATA[_v.file].movetp
            end
            if (_SLK_ORIGIN_DATA[_v.file].moveHeight ~= nil) then
                dfd.moveHeight = _SLK_ORIGIN_DATA[_v.file].moveHeight
            end
        end
    end
    _v.isDef = nil
    return dfd
end

---@protected
_SET_UNIT = function(_v)
    _v._class = "unit"
    if (_v._parent == nil) then
        _v._parent = "nfrp"
    end
    local dfd = defaultData(_v)
    _v.goldcost = 0
    _v.lumbercost = 0
    _v.fmade = 0
    _v.fused = 0
    _v.regenMana = 0
    _v.regenHP = 0
    _v.regenType = "none"
    _v.tilesets = "*"
    _v.sides1 = 1
    _v.dice1 = 1
    _v.def = 0
    _v.HP = 1e4
    _v.manaN = 1e4
    _v.defType = "large"
    _v.Art = _v.Art or dfd.Art
    _v.unitSound = _v.unitSound or dfd.unitSound
    _v.unitShadow = _v.unitShadow or "ShadowFlyer"
    _v.scale = _v.scale or dfd.scale
    _v.dmgpt1 = _v.dmgpt1 or dfd.dmgpt1
    _v.backSw1 = _v.backSw1 or dfd.backSw1
    _v.castpt = _v.castpt or 0.1
    _v.castbsw = _v.castbsw or 0.1
    _v.targs1 = _v.targs1 or "vulnerable,ground,structure,organic,air" --攻击目标
    _v.movetp = _v.movetp or dfd.movetp
    _v.moveHeight = _v.moveHeight or dfd.moveHeight
    _v.spd = _v.spd or 10
    _v.rangeN1 = _v.rangeN1 or 100
    _v.acquire = _v.acquire or math.max(600, _v.rangeN1)
    _v.dmgplus1 = _v.dmgplus1 or 1
    _v.cool1 = _v.cool1 or 2.0
    _v.race = _v.race or "other"
    _v.sight = _v.sight or 1000
    _v.nsight = _v.nsight or math.floor(_v.sight / 2)
    _v.weapsOn = _v.weapsOn or 1
    _v.collision = _v.collision or 32
    if (_v.abilList == nil) then
        _v.abilList = ""
    else
        _v.abilList = _v.abilList
    end
    if (_v.weapsOn == 1) then
        _v.weapTp1 = "instant"
        _v.weapType1 = "" -- 攻击声音
        _v.Missileart_1 = "" -- 箭矢模型
        _v.Missilespeed_1 = 99999 -- 箭矢速度
        _v.Missilearc_1 = 0
    else
        _v.weapTp1 = ""
        _v.weapType1 = ""
        _v.Missileart_1 = ""
        _v.Missilespeed_1 = 0
        _v.Missilearc_1 = 0
    end
    return _v
end

---@protected
_SET_ABILITY = function(_v)
    _v._class = "ability"
    if (_v._parent == nil) then
        _v._parent = "ANcl"
    end
    return _v
end

---@protected
_SET_DESTRUCTABLE = function(_v)
    _v._class = "destructable"
    if (_v._parent == nil) then
        _v._parent = "BTsc"
    end
    _v.fogVis = _v.fogVis or 0
    _v.showInMM = _v.showInMM or 0
    return _v
end
