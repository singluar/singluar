---@type Unit
local _

--- handle
---@return number
function _.handle() end

--- 剩余生命周期
---@return number
function _.periodRemain() end

--- 经验值[当前]
---@param modify number|nil
---@return self|number
function _.exp(modify) end

--- 获取英雄升级到某等级需要的总经验；根据Game的unitExpNeeds
---@param whichLevel number
---@return number
function _.expNeed(whichLevel) end

--- 是否自己
---@param Who Unit
---@return boolean
function _.isSelf(Who) end

--- 是否别人
---@param Who Unit
---@return boolean
function _.isOther(Who) end

--- 是否敌人玩家
---@param JudgePlayer Player
---@return boolean
function _.isEnemy(JudgePlayer) end

--- 是否友军玩家
---@param JudgePlayer Player
---@return boolean
function _.isAlly(JudgePlayer) end

--- 是否存活
---@return boolean
function _.isAlive() end

--- 是否死亡
---@return boolean
function _.isDead() end

--- 是否地面单位
---@return boolean
function _.isGround() end

--- 是否空中单位
---@return boolean
function _.isAir() end

--- 是否水里单位
---@return boolean
function _.isWater() end

--- 是否近战
---@return boolean
function _.isMelee() end

--- 是否远程
---@return boolean
function _.isRanged() end

--- 判断单位是否暂停
---@return boolean
function _.isPause() end

--- 判断单位是否显示
---@return boolean
function _.isShow() end

--- 判断单位是否允许碰撞
---@return boolean
function _.isCollision() end

--- 判断单位是否允许选择
---@return boolean
function _.isSelectable() end

--- 判断单位是否允许攻击
---@return boolean
function _.isAttackAble() end

--- 判断单位是否无敌
---@return boolean
function _.isInvulnerable() end

--- 判断单位是否隐身
---@return boolean
function _.isInvisible() end

--- 是否正在受伤
---@return boolean
function _.isHurting() end

--- 是否正在造成伤害
---@return boolean
function _.isDamaging() end

--- 是否眩晕中
---@return boolean
function _.isStunning() end

--- 是否硬直中
---@return boolean
function _.isPunishing() end

--- 是否被沉默
---@return boolean
function _.isSilencing() end

--- 是否被缴械
---@return boolean
function _.isUnArming() end

--- 是否被击飞
---@return boolean
function _.isCrackFlying() end

--- 是否冲锋中
---@return boolean
function _.isLeaping() end

--- 是否剑刃风暴中
---@return boolean
function _.isWhirlwind() end

--- 吟唱中
---@return boolean
function _.isAbilityChantCasting() end

--- 是否持续施法中
---@return self|boolean
function _.isAbilityKeepCasting() end

--- 判断单位是否处于施法中止态
--- 暂停不属于施法中止态
--- 施法中止态定义：被销毁、死亡、眩晕、击飞、冲锋、剑刃风暴、沉默等
---@return boolean
function _.isInterrupt() end

--- 判断单位是否拥有某种技能
---@param whichTpl AbilityTpl 使用TPL来判别类别
---@return boolean
function _.hasAbility(whichTpl) end

--- 判断单位是否拥有某种物品
---@param whichTpl ItemTpl 使用TPL来判别类别
---@return boolean
function _.hasItem(whichTpl) end

--- X坐标
---@return number
function _.x() end

--- Y坐标
---@return number
function _.y() end

--- Z坐标
---@return number
function _.z() end

--- H坐标[凌空]
---@return number
function _.h() end

--- 面向角度
---@param modify number|nil
---@return self|number
function _.facing(modify) end

--- 单位拥有者
---@param modify Player|nil
---@return self|Player
function _.owner(modify) end

--- 单位队伍颜色
--- 使用玩家索引1-12决定颜色值
---@param modify number|nil
---@return self|number
function _.teamColor(modify) end

--- 最后受伤来源
---@param modify Unit|nil
---@return self|nil
function _.lastHurtSource(modify) end

--- 最后伤害目标
---@param modify Unit|nil
---@return self|nil
function _.lastDamageTarget(modify) end

--- 联合位移单位到X,Y坐标
---@param x number
---@param y number
---@return self
function _.position(x, y) end

--- 命令单位做动画动作，如 "attack"
--- 当动作为整型序号时，自动播放对应的序号行为(每种模型的序号并不一致)
---@param animate number|string
---@return self
function _.animate(animate) end

--- 单位添删动画动作
---@param animate string
---@param enable boolean
---@return self
function _.animateProperties(animate, enable) end

--- 杀死单位
---@return self
function _.kill() end

--- 以爆炸杀死单位
---@return self
function _.exploded() end

--- 单位发布停止命令
---@return self
function _.orderStop() end

--- 单位发布伫立命令
---@return self
function _.orderHold() end

--- 单位发布攻击命令
---@param x:number
---@param y:number
---@return self
function _.orderAttack(x, y) end

--- 单位发布命令跟随某目标单位
---@param targetUnit Unit
---@return self
function _.orderFollowTargetUnit(targetUnit) end

--- 单位发布命令攻击某目标单位
---@param targetUnit Unit
---@return self
function _.orderAttackTargetUnit(targetUnit) end

--- 单位发布移动命令
---@param x:number
---@param y:number
---@return self
function _.orderMove(x, y) end

--- 单位发布AI移动命令
---@param x:number
---@param y:number
---@return self
function _.orderAIMove(x, y) end

--- 单位发布巡逻移动命令
---@param x:number
---@param y:number
---@return self
function _.orderPatrol(x, y) end

--- 单位发布路线移动
--- 可以被中途阻扰，但依然会非常坚持的一直遵循后续路线坐标移动下去
--- 可以在每一段停顿点加入一个自定义函数来做出额外的动作（路线会被强行暂停，动作中需要手动恢复）
--- 使用 orderRoute 来执行路线行为
--- 使用 orderRouteSet 来修改路线
--- 使用 orderRoutePause 来暂停路线行为（但会继续走完以出发的路段）
--- 使用 orderRouteResume 来恢复路线行为（在暂停10秒后如还未恢复，路线会自动废除）
--- 使用 orderRoute 来消除路线行为
---@alias noteUnitRoute {number,number,fun(orderUnit:Unit)}
---@param isLoop boolean 是否循环
---@param routes noteUnitRoute[]
---@return self
function _.orderRoute(isLoop, routes) end

--- 设计单位已发布的路线某一段
--- index范围为(1,inf)，如果超出范围时，自动定义为尾部添加一个
--- 也就是可以可以替换删除原有的
---@param index number integer
---@param route noteUnitRoute|nil 当route为nil时，则为去掉该段区间路径
function _.orderRouteSet(index, route) end

--- 废弃单位发布的路线移动
---@return void
function _.orderRouteDestroy() end

--- 暂停单位发布的路线移动
---@return void
function _.orderRoutePause() end

--- 恢复单位发布的路线移动
---@return self
function _.orderRouteResume() end

--- 在单位位置创建特效
---@param model string
---@param duration number
---@return userdata
function _.effect(model, duration) end

--- 绑定特效
---@param model string
---@param attach string
---@param duration number
---@return userdata|nil
function _.attach(model, attach, duration) end

--- 单位技能栏
---@return AbilitySlot
function _.abilitySlot() end

--- 预备施法设定时间
---@return number
function _.abilityChantCastingSet() end

--- 预备施法剩余时间
---@return number
function _.abilityChantCastingRemain() end

--- 持续施法设定时间
---@return number
function _.abilityKeepCastingSet() end

--- 持续施法剩余时间
---@return number
function _.abilityKeepCastingRemain() end

--- 单位物品栏
---@return ItemSlot
function _.itemSlot() end

--- 单位距离过程
---@param target Unit|Item|{number,number}
---@param judgeDistance number
---@param callFunc fun():void
---@return void
function _.distanceAction(target, judgeDistance, callFunc) end

--- 单位捡物品（存在捡取过程）
---@param targetItem Item
---@return void
function _.pickItem(targetItem) end