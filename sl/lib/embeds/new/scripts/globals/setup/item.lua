-- 配置游戏 - 物品栏热键
-- 这里使用魔兽的 78 45 12
Game().itemHotkey({ "Numpad7", "Numpad8", "Numpad4", "Numpad5", "Numpad1", "Numpad2" })

Game().itemUpgrade(99, 100, 1.00, 10000)

-- 配置游戏 - 玩家仓库
Game().warehouseSlot(18)

-- 定义物品技能描述体
-- [基础信息]
---@param this Ability
Game().defineDescription("itemAbility", function(this, options)
    local str = { '', this.name() .. ': ' }
    local lv = math.floor(this.level())
    local tt = this.targetType()
    local indent = '    '
    table.insert(str, indent .. '类型：%s')
    table.insert(options, { 'ffcc00', tt.label })
    if (tt ~= ABILITY_TARGET_TYPE.PAS) then
        local chantCast = this.castChant(lv)
        if (chantCast > 0) then
            table.insert(str, indent .. '吟唱时间：%s 秒')
            table.insert(options, { 'ccffff', chantCast })
        else
            table.insert(str, indent .. '吟唱时间：%s')
            table.insert(options, { 'ccffff', '瞬间施法' })
        end
        local keepCast = this.castKeep(lv)
        if (keepCast > 0) then
            table.insert(str, indent .. '最大施法持续：%s 秒')
            table.insert(options, { 'ccffff', keepCast })
        end
    end
    return colour.format(string.implode('|n', str), 'ee82ee', options)
end)

-- 定义物品描述体
-- [基础信息]
---@param this Item
Game().defineDescription("itemBase", function(this, _)
    local desc = {}
    local name
    if (this.level() > 0) then
        name = this.name() .. '[' .. this.level() .. ' 级]'
    else
        name = this.name()
    end
    if (isObject(this.ability(), "Ability")) then
        local tt = this.ability().targetType()
        if (isObject(this, "Item")) then
            if (tt ~= ABILITY_TARGET_TYPE.PAS and this.hotkey() ~= nil) then
                name = name .. '（' .. colour.hex(colour.gold, this.hotkey()) .. '）'
            end
            table.insert(desc, name)
        else
            table.insert(desc, name)
        end
        desc = table.merge(desc, Game().combineDescription(this.ability(), nil, "itemAbility", "<D>", "attributes"))
        if (this.charges() > 0) then
            table.insert(desc, '')
            table.insert(desc, "剩余次数：" .. this.charges())
        end
    else
        table.insert(desc, name)
    end
    if (this.level() < this.levelMax()) then
        table.insert(desc, colour.format('最大可升级到 %s 级', 'c0c0c0', { { "ffcc00", this.levelMax() } }))
    end
    return desc
end)