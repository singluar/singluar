--- 属性
enchant = enchant or {}

--- 附魔上身默认持续时间
---@type number
enchant.default_append_duration = 10

--- 附魔类型集
---@type Array
enchant.types = Array()

--- 附魔上身
---@param targetUnit Unit
---@param sourceUnit Unit
---@param enchantTypes string[]
function enchant.append(targetUnit, sourceUnit, enchantTypes)
    local enchantRemain = Array()
    for _, et in ipairs(enchantTypes) do
        local etg = enchant.types.get(et)
        if (type(etg) ~= "table") then
            return
        end
        local react = etg.reaction
        if (type(react) ~= "table") then
            -- 如果没有设计反应，记录到未反应区
            enchantRemain.set(et, 1)
        else
            local reacted = false
            enchant.types.forEach(function(ek, _)
                -- 判断所有种类的附魔，如果之前有附魔过则反应
                if (type(react[ek]) == "function") then
                    local lv = targetUnit.enchantAppend(ek) + (enchantRemain.get(ek) or 0)
                    if (lv > 0) then
                        -- 如果有反应式，先消除旧附魔元素
                        local buffs = BuffCatcher(targetUnit, {
                            key = "prop_<APPEND>e_" .. ek,
                            filter = function(enumBuff)
                                return enumBuff.duration() > 0
                            end,
                        })
                        if (#buffs > 0) then
                            for _, b in ipairs(buffs) do
                                b.destroy()
                            end
                        end
                        -- 反应
                        react[ek]({
                            triggerUnit = targetUnit,
                            sourceUnit = sourceUnit,
                            from = et,
                            to = ek,
                            level = lv,
                        })
                        enchantRemain.set(ek, 0)
                        reacted = true
                    end
                end
            end)
            -- 如果没有触发反应，记录到未反应区
            if (reacted == false) then
                enchantRemain.set(et, 1)
            end
        end
    end
    enchantRemain.forEach(function(ek, value)
        if (value > 0) then
            targetUnit.enchantAppend(ek, "+=" .. value .. ';' .. enchant.default_append_duration)
            local a = enchant.types.get(ek).append or nil
            if (a ~= nil) then
                for _, o in ipairs(a) do
                    targetUnit.attach(o.effect, o.attach, enchant.default_append_duration)
                end
            end
        end
    end)
    enchantRemain = nil
end

--- 附魔设定反应马甲函数，方便回调引用
---@alias noteEnchantReactionData {triggerUnit:Unit,sourceUnit:Unit,from:"触发附魔元素",to:"条件附魔元素",level:"层级"}
---@param callFunc fun(evtData:noteOnUnitEnchantData):void
function enchant.reaction(callFunc)
    return callFunc
end

--- 附魔设定
--[[
    strengthen 所有单位初始化时附带的该属性强化(%)，如5，默认0
    resistance 所有单位初始化时附带的该属性抵抗(%)，如-10，默认0
    attach 附着时的特效配置
    reaction 化学反应
]]
---@param key string
---@param label string 名字
---@param options {strengthen:number,resistance:number,append:table<number,{attach:string,effect:string}>,reaction:table<string,fun(evtData:noteOnUnitEnchantData)>}
---@return void
function enchant.defined(key, label, options)
    if (type(key) ~= "string" or type(label) ~= "string") then
        return
    end
    options = options or {}
    local strengthen = options.strengthen or 0
    local resistance = options.resistance or 0
    local append = options.append
    local reaction = options.reaction
    if (enchant.types.keyExists(key) == false) then
        --- key初次设定时，把属性注册到ATTR各类常量内
        -- 几率、抵抗
        table.insert(ATTR_ODDS, "e_" .. key)
        table.insert(ATTR_RESISTANCE, "e_" .. key)
        -- 伤害类型
        table.insert(DAMAGE_TYPE_KEYS, key)
    end
    DAMAGE_TYPE[key] = { value = key, label = label }
    enchant.types.set(key, {
        label = label,
        strengthen = strengthen,
        resistance = resistance,
        append = append,
        reaction = reaction,
    })
end