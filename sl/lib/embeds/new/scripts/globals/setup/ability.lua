-- 配置游戏 - 技能栏热键
-- A S H 被默认命令占用建议不使用
Game().abilityHotkey({ "Q", "W", "E", "R", "D", "F", "C", "V" })

Game().abilityUpgrade(99, 100, 1.00, 10000)

-- 定义技能描述体
-- [基础信息]
---@param this Ability
---@param options {level:number}
Game().defineDescription("abilityBase", function(this, options)
    local desc = {}
    local lv = math.floor(options.level or this.level())
    local tt = this.targetType()
    if (isObject(this, "Ability")) then
        if (tt ~= ABILITY_TARGET_TYPE.PAS) then
            table.insert(desc, this.name() .. ' - 等级 ' .. colour.hex(colour.gold, lv) .. '（' .. colour.hex(colour.gold, this.hotkey()) .. '）')
        else
            table.insert(desc, this.name() .. " - 等级 " .. colour.hex(colour.gold, lv))
        end
    else
        table.insert(desc, this.name())
    end
    table.insert(desc, '类型：' .. colour.hex(colour.gold, tt.label))
    if (tt ~= ABILITY_TARGET_TYPE.PAS) then
        local chantCast = this.castChant(lv)
        if (chantCast > 0) then
            table.insert(desc, '吟唱时间：' .. colour.hex(colour.skyblue, chantCast .. " 秒"))
        else
            table.insert(desc, '吟唱时间：' .. colour.hex(colour.skyblue, "瞬间施法"))
        end
        local keepCast = this.castKeep(lv)
        if (keepCast > 0) then
            table.insert(desc, '最大施法持续：' .. colour.hex(colour.skyblue, keepCast .. " 秒"))
        end
    end
    return desc
end)

-- [技能点信息]
---@param this Ability
Game().defineDescription("abilityLvPoint", function(this, _)
    if (this.levelUpNeedPoint() > 0) then
        return { colour.hex('EFBA16', '升级需要技能点: ' .. this.levelUpNeedPoint()) }
    end
end)