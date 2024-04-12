-- 虚空态
NIL = "__SNIL__"

-- 玩家状态
PLAYER_STATUS = {
    empty = { value = "empty", label = "空置" },
    playing = { value = "playing", label = "在线" },
    leave = { value = "leave", label = "离线" },
}

-- 技能目标类型
ABILITY_TARGET_TYPE = {
    PAS = { value = "PAS", label = "被动" },
    TAG_E = { value = "TAG_E", label = "无目标" },
    TAG_U = { value = "TAG_U", label = "单位目标" },
    TAG_L = { value = "TAG_L", label = "点目标" },
    TAG_C = { value = "TAG_C", label = "圆形范围目标" },
    TAG_S = { value = "TAG_S", label = "方形范围目标" },
}

---@class LIGHTNING_TYPE 闪电效果
LIGHTNING_TYPE = {
    thunder = { value = "CLPB", label = "闪电链主", effect = "BoltImpact" },
    thunderLite = { value = "CLSB", label = "闪电链次", effect = "BoltImpact" },
    thunderShot = { value = "CHIM", label = "闪电攻击", effect = "BoltImpact" },
    thunderFork = { value = "FORK", label = "叉状闪电", effect = "Abilities\\Spells\\Orc\\Purge\\PurgeBuffTarget.mdl" },
    thunderRed = { value = "AFOD", label = "死亡之指", effect = "Abilities\\Spells\\Demon\\DemonBoltImpact\\DemonBoltImpact.mdl" },
    suck = { value = "DRAB", label = "汲取", effect = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl" },
    suckGreen = { value = "DRAL", label = "生命汲取", effect = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl" },
    suckBlue = { value = "DRAM", label = "魔法汲取", effect = "Abilities\\Spells\\Human\\Feedback\\ArcaneTowerAttack.mdl" },
    cure = { value = "HWPB", label = "医疗波主", effect = "Abilities\\Spells\\Orc\\HealingWave\\HealingWaveTarget.mdl" },
    cureLite = { value = "HWSB", label = "医疗波次", effect = "Abilities\\Spells\\Orc\\HealingWave\\HealingWaveTarget.mdl" },
    soul = { value = "SPLK", label = "灵魂锁链", effect = "Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl" },
    manaBurn = { value = "MBUR", label = "法力燃烧", effect = "Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl" },
    manaFrame = { value = "MFPB", label = "魔力之焰", effect = "Abilities\\Spells\\Human\\ManaFlare\\ManaFlareBoltImpact.mdl" },
    manaChain = { value = "LEAS", label = "魔法镣铐", effect = "Abilities\\Spells\\Human\\Feedback\\SpellBreakerAttack.mdl" },
}

-- <ODDS>
ATTR_ODDS = { 'hurtRebound', 'crit', 'stun' }

-- <RESISTANCE>
ATTR_RESISTANCE = {
    'hpSuckAttack', 'hpSuckAbility',
    'mpSuckAttack', 'mpSuckAbility',
    'punish', 'hurtRebound', 'crit', 'stun', 'split', 'silent', 'unArm', 'fetter', 'lightningChain', 'crackFly'
}

--- 材质
UNIT_MATERIAL = {
    flesh = { value = "flesh", label = "肉体" },
    metal = { value = "metal", label = "金属" },
    rock = { value = "rock", label = "石头" },
    wood = { value = "wood", label = "木头" },
}

--- 单位移动类型
UNIT_MOVE_TYPE = {
    foot = { value = "foot", label = "步行" },
    fly = { value = "fly", label = "飞行" },
    float = { value = "float", label = "漂浮" },
    amphibious = { value = "amphibious", label = "两栖" },
}

UNIT_PRIMARY = {
    str = { value = "str", label = "力量" },
    agi = { value = "agi", label = "敏捷" },
    int = { value = "int", label = "智力" },
}

---@class DAMAGE_SRC 伤害来源
---@type table<string,{value:string,label:string}>
DAMAGE_SRC = {
    common = { value = "common", label = "常规" },
    attack = { value = "attack", label = "攻击" },
    ability = { value = "ability", label = "技能" },
    item = { value = "item", label = "物品" },
    rebound = { value = "rebound", label = "反伤" },
}

---@class DAMAGE_TYPE 伤害类型
---@type table<string,{value:string,label:string}>
DAMAGE_TYPE = {
    common = { value = "common", label = "常规" },
}
DAMAGE_TYPE_KEYS = { "common" }

---@class BREAK_ARMOR 无视防御种类
---@type table<string,{value:string,label:string}>
BREAK_ARMOR = {
    defend = { value = "defend", label = "防御" },
    avoid = { value = "avoid", label = "回避" },
    invincible = { value = "invincible", label = "无敌" },
}