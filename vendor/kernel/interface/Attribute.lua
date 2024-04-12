---@type Attribute
local _

--- 获取优先级最高的特效箭矢对象
--- 特效箭矢对象的优先级比闪电箭矢对象低
---@return Missile|nil
function _.missile() end

--- 增加可选特效箭矢对象
---@param missile Missile
---@return self
function _.missilePush(missile) end

--- 删除可选特效箭矢对象
--- 根据特效箭矢对象ID删除(注意，相同ID会被全部删除)
---@param missileId string
---@return self
function _.missileRemove(missileId) end

--- 获取优先级最高的闪电箭矢对象
--- 闪电箭矢对象的优先级比特效箭矢对象高
---@return Lightning|nil
function _.lightning() end

--- 增加可选闪电对象
---@param lightning Lightning
---@return self
function _.lightningPush(lightning) end

--- 删除可选闪电箭矢对象
--- 根据闪电矢箭对象ID删除(注意，相同ID会被全部删除)
---@param lightningId string
---@return self
function _.lightningRemove(lightningId) end

--- 复活时间
--- 负数表示不能复活，建议不能复活设置-999以上，排除动态影响
---@param modify number
---@return self|number
function _.reborn(modify) end

--- HP
---@param modify number
---@return self|number
function _.hp(modify) end

--- HP[当前]
---@param modify number
---@return self|number
function _.hpCur(modify) end

--- HP[恢复]
---@param modify number
---@return self|number
function _.hpRegen(modify) end

--- 攻击吸HP
---@param modify number
---@return self|number
function _.hpSuckAttack(modify) end

--- 施法吸HP
---@param modify number
---@return self|number
function _.hpSuckAbility(modify) end

--- MP
---@param modify number
---@return self|number
function _.mp(modify) end

--- MP[当前]
---@param modify number
---@return self|number
function _.mpCur(modify) end

--- MP[恢复]
---@param modify number
---@return self|number
function _.mpRegen(modify) end

---攻击吸MP
---@param modify number
---@return self|number
function _.mpSuckAttack(modify) end

--- 施法吸MP
---@param modify number
---@return self|number
function _.mpSuckAbility(modify) end

--- 白昼视野
---@param modify number
---@return self|number
function _.sight(modify) end

--- 黑夜视野
---@param modify number
---@return self|number
function _.nsight(modify) end

--- 基础视野
---@param modify number
---@return self|number
function _.sightBase(modify) end

--- 昼夜视野差
---@param modify number
---@return self|number
function _.sightDiff(modify) end

--- 攻击
---@param modify number
---@return self|number
function _.attack(modify) end

--- 攻击基础频率
---@param modify number
---@return self|number
function _.attackSpaceBase(modify) end

--- 攻击频率[当前]
---@return number
function _.attackSpace() end

--- 攻击速度加成[%]
---@param modify number
---@return self|number
function _.attackSpeed(modify) end

--- 主动攻击范围
---@param modify number
---@return self|number
function _.attackRangeAcquire(modify) end

--- 主动范围
---@param modify number
---@return self|number
function _.attackRange(modify) end

--- 随机浮动动态攻击
---@param modify number
---@return self|number
function _.attackRipple(modify) end

--- 防御
--- 直接扣减伤害
---@param modify number
---@return self|number
function _.defend(modify) end

--- 移动
---@param modify number
---@return self|number
function _.move(modify) end

--- 力量
---@param modify number
---@return self|number
function _.str(modify) end

--- 敏捷
---@param modify number
---@return self|number
function _.agi(modify) end

--- 智力
---@param modify number
---@return self|number
function _.int(modify) end

--- 治疗加成[%]
---@param modify number
---@return self|number
function _.cure(modify) end

--- 回避[%]
---@param modify number
---@return self|number
function _.avoid(modify) end

--- 命中[%]
---@param modify number
---@return self|number
function _.aim(modify) end

--- 硬直
---@param modify number
---@return self|number
function _.punish(modify) end

--- 硬直[当前]
---@param modify number
---@return self|number
function _.punishCur(modify) end

--- 硬直[恢复]
---@param modify number
---@return self|number
function _.punishRegen(modify) end

--- 负重
---@param modify number
---@return self|number
function _.weight(modify) end

--- 负重[当前]
---@param modify number
---@return self|number
function _.weightCur(modify) end

--- 受伤加深[%]
---@param modify number
---@return self|number
function _.hurtIncrease(modify) end

--- 减伤比例[%]
---@param modify number
---@return self|number
function _.hurtReduction(modify) end

--- 受伤反弹比例[%]
---@param modify number
---@return self|number
function _.hurtRebound(modify) end

--- 伤害加深[%]
---@param modify number
---@return self|number
function _.damageIncrease(modify) end

--- 暴击[%]
---@param modify number
---@return self|number
function _.crit(modify) end

--- 技能消耗[%]
---@param modify number
---@return self|number
function _.cost(modify) end

--- 技能施法时间[%]
---@param modify number
---@return self|number
function _.castChant(modify) end

--- 技能冷却变化[%]
--- 负数则技能变快
---@param modify number
---@return self|number
function _.coolDown(modify) end

--- 技能冷却变化[秒]
--- 负数则技能变快
--- 秒后算
---@param modify number
---@return self|number
function _.coolDownSec(modify) end

--- 通用几率
---@param key string
---@param modify number
---@return self|number
function _.odds(key, modify) end

--- 通用抵抗
---@param key string
---@param modify number
---@return self|number
function _.resistance(key, modify) end

--- 附魔强化
---@param key string 附魔类型
---@param modify number
---@return self|number
function _.enchant(key, modify) end

--- 附魔抵抗
---@param key string 附魔类型
---@param modify number
---@return self|number
function _.enchantResistance(key, modify) end

--- 附魔武器
---@param key string 附魔类型
---@param modify number
---@return self|number
function _.enchantWeapon(key, modify) end

--- 附魔附着
---@param key string 附魔类型
---@param modify number
---@return self|number
function _.enchantAppend(key, modify) end
