--[[
    剑刃风暴
    sourceUnit [必须]中心单位，同时也是伤害来源
    animateAppend = "Spin", --附加动作
    radius [必须]半径范围
    frequency [必须]伤害频率
    duration [必须]持续时间
    filter [可选]作用范围内的单位筛选器,nil则自动选择单位的敌对势力
    centerModel [可选]中心单位特效
    centerAttach 中心单位特效串附加位
    enumModel 选取单位特效串[瞬间0]
    damage 伤害
    damageSrc 伤害来源
    damageType 伤害类型
    breakArmor 破防类型
]]
---@param options {sourceUnit:Unit,animateAppend:string,radius:number,frequency:number,duration:number,filter:fun(enumUnit:Unit),damage:number,damageSrc:DAMAGE_SRC,damageType:table<string,DAMAGE_TYPE>,breakArmor:table}
function ability.whirlwind(options)

    must(isObject(options.sourceUnit, "Unit"))

    local frequency = options.frequency or 0
    local duration = options.duration or 0

    must(frequency > 0)
    must(duration > 0)
    must(duration >= frequency)

    if (options.sourceUnit.isWhirlwind()) then
        return
    end

    options.centerAttach = options.centerAttach or "origin"
    options.sourceUnit.superposition("whirlwind", "+=1")
    if (options.centerModel ~= nil) then
        options.sourceUnit.attach(options.centerModel, options.centerAttach, duration)
    end
    local animateAppend = options.animateAppend or "Spin"
    J.AddUnitAnimationProperties(options.sourceUnit.handle(), animateAppend, true)
    local ti = 0
    local filter = options.filter or function(enumUnit)
        return enumUnit.isAlive() and enumUnit.isEnemy(options.sourceUnit.owner())
    end
    local radius = options.radius or 0
    local damage = options.damage or 0
    local dmgSrc = options.damageSrc or DAMAGE_SRC.ability
    local dmgType = options.damageType or { DAMAGE_TYPE.common }
    local breakArmor = options.breakArmor or { BREAK_ARMOR.avoid }
    if (radius <= 0 or damage > 0) then
        time.setInterval(frequency, function(curTimer)
            ti = ti + frequency
            if (ti >= duration) then
                curTimer.destroy()
                J.AddUnitAnimationProperties(options.sourceUnit.handle(), animateAppend, false)
                options.sourceUnit.superposition("whirlwind", "-=1")
                return
            end
            local enumUnits = group.catch({
                key = "Unit",
                x = options.sourceUnit.x(), y = options.sourceUnit.y(),
                radius = radius,
                filter = filter
            })
            for _, eu in ipairs(enumUnits) do
                if (options.enumModel ~= nil) then
                    eu.effect(options.enumModel, 0)
                end
                ability.damage({
                    sourceUnit = options.sourceUnit,
                    targetUnit = eu,
                    damage = damage,
                    damageSrc = dmgSrc,
                    damageType = dmgType,
                    breakArmor = breakArmor
                })
            end
        end)
    end
end