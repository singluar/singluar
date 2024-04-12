--- 方便伤害类型引用 {value:string,label:string}
DAMAGE_TYPE.fire = nil
DAMAGE_TYPE.rock = nil
DAMAGE_TYPE.water = nil
DAMAGE_TYPE.ice = nil
DAMAGE_TYPE.wind = nil
DAMAGE_TYPE.light = nil
DAMAGE_TYPE.dark = nil
DAMAGE_TYPE.grass = nil
DAMAGE_TYPE.thunder = nil
DAMAGE_TYPE.poison = nil

-- 附魔设定
enchant.defined("fire", "火", {
    strengthen = 0,
    resistance = 0,
    append = {
        { attach = 'origin', effect = 'BreathOfFireDamage' },
        { attach = 'left hand', effect = 'BreathOfFireDamage' },
        { attach = 'right hand', effect = 'BreathOfFireDamage' },
        { attach = 'head', effect = 'BreathOfFireDamage' },
    },
    reaction = {
        grass = enchant.reaction(function(evtData)
            evtData.triggerUnit.hpRegen("-=200;5")
        end)
    },
})

enchant.defined("rock", "岩")
enchant.defined("water", "水")
enchant.defined("ice", "冰")
enchant.defined("wind", "风")
enchant.defined("light", "光")
enchant.defined("dark", "暗")
enchant.defined("grass", "草")
enchant.defined("thunder", "雷")
enchant.defined("poison", "毒")