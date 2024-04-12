--- #单位 token
_unit({
    _parent = "ogru",
    Name = "F6S_UNIT_TOKEN",
    special = 1,
    abilList = "Avul,Aloc",
    upgrade = "",
    file = ".mdl",
    unitShadow = "",
    collision = 0,
    Art = "",
    movetp = "fly",
    moveHeight = 25.00,
    spd = 522,
    turnRate = 3.00,
    moveFloor = 25.00,
    weapsOn = 0,
    race = "other",
    fused = 0,
    sight = 0,
    nsight = 0,
    Builds = "",
    upgrades = "",
})

--- #单位死亡标志
_unit({
    _parent = "ogru",
    Name = "F6S_UNIT_TOKEN_DEATH",
    special = 1,
    abilList = "Avul,Aloc",
    upgrade = "",
    file = "Singluar\\clock_rune.mdl",
    unitShadow = "",
    collision = 0,
    Art = "",
    modelScale = 1.00,
    movetp = "fly",
    moveHeight = 30,
    moveFloor = 30,
    spd = 0,
    turnRate = 3.00,
    weapsOn = 0,
    race = "other",
    fused = 0,
    sight = 250,
    nsight = 250,
    Builds = "",
    upgrades = "",
    maxPitch = 0,
    maxRoll = 0,
})

-- #隐身
_ability({
    _parent = "Apiv",
    Name = "F6S_ABILITY_INVISIBLE",
    Tip = "隐身",
    Ubertip = "隐身",
    Art = "",
    hero = 0,
    race = "other",
    DataA = { 0 },
    Dur = { 0 },
    HeroDur = { 0 },
})

--- #叹号警示圈 直径128px
_unit({
    _parent = "ogru",
    Name = "F6S_TEXTURE_ALERT_CIRCLE_EXCLAMATION",
    special = 1,
    abilList = "Avul,Aloc",
    upgrade = "",
    file = "Singluar\\sign_exclamation.mdl",
    unitShadow = "",
    collision = 0,
    Art = "",
    modelScale = 0.12,
    movetp = "",
    moveHeight = 0,
    moveFloor = 0.00,
    spd = 0,
    turnRate = 3.00,
    weapsOn = 0,
    race = "other",
    fused = 0,
    sight = 250,
    nsight = 250,
    Builds = "",
    upgrades = "",
    red = 255,
    blue = 255,
    green = 255,
})

--- #叉号警示圈 直径128px
_unit({
    _parent = "ogru",
    Name = "F6S_TEXTURE_ALERT_CIRCLE_X",
    special = 1,
    abilList = "Avul,Aloc",
    upgrade = "",
    file = "Singluar\\sign_x.mdl",
    unitShadow = "",
    collision = 0,
    Art = "",
    modelScale = 0.12,
    movetp = "",
    moveHeight = 0,
    moveFloor = 0.00,
    spd = 0,
    turnRate = 3.00,
    weapsOn = 0,
    race = "other",
    fused = 0,
    sight = 250,
    nsight = 250,
    Builds = "",
    upgrades = "",
    red = 255,
    blue = 255,
    green = 255,
})

--- #JAPI_DELAY
_ability({
    _parent = "Aamk",
    Name = "F6S_JAPI_DELAY",
    Art = "",
    hero = 0,
    race = "other",
    item = 1,
    levels = 1,
    DataA = { 0 },
    DataB = { 0 },
    DataC = { 0 },
    DataD = { 1 },
})

--- #回避(伤害)+
_ability({
    _parent = "AIlf",
    Name = "F6S_ABILITY_AVOID_ADD",
    Art = "",
    levels = 2,
    DataA = { 0, -10000000 }
})

--- #回避(伤害)-
_ability({
    _parent = "AIlf",
    Name = "F6S_ABILITY_AVOID_SUB",
    Art = "",
    levels = 2,
    DataA = { 0, 10000000 }
})

--- #视野
local sightBase = { 1, 2, 3, 4, 5 }
local i = 1
while (i <= 1000) do
    for _, v in ipairs(sightBase) do
        v = math.floor(v * i)
        -- #视野+
        _ability({
            _parent = "AIsi",
            Name = "F6S_ABILITY_SIGHT_ADD_" .. v,
            Art = "",
            levels = 1,
            DataA = { 1 * v },
        })
        -- #视野-
        _ability({
            _parent = "AIsi",
            Name = "F6S_ABILITY_SIGHT_SUB_" .. v,
            Art = "",
            levels = 1,
            DataA = { -1 * v },
        })
    end
    i = i * 10
end
