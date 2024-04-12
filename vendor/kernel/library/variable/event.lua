-- 事件定义
EVENT = {
    Game = {
        --- 开始游戏(此事件游戏开始后会自动销毁)
        ---@alias noteOnGameStartData nil
        Start = "gameStart",
        --- 进入凌晨
        ---@alias noteOnGameDawnData nil
        Dawn = "gameDawn",
        --- 进入正午
        ---@alias noteOnGameDayData nil
        Day = "gameDay",
        --- 进入正午
        ---@alias noteOnGameNoonData nil
        Noon = "gameNoon",
        --- 进入黑夜
        ---@alias noteOnGameNightData nil
        Night = "gameNight",
    },
    ---@alias noteOnPropBase {key:"对应属性key", old:"旧值", new:"新值"}
    ---@alias noteOnPropGame noteOnPropBase|{triggerObject:Game}
    ---@alias noteOnPropPlayer noteOnPropBase|{triggerObject:Player}
    ---@alias noteOnPropUnit noteOnPropBase|{triggerObject:Unit}
    ---@alias noteOnPropAbility noteOnPropBase|{triggerObject:Ability}
    ---@alias noteOnPropItem noteOnPropBase|{triggerObject:Item}
    Prop = {
        --- 游戏参数改变前
        BeforeChange = "propBeforeChange",
        --- 游戏参数改变后
        Change = "propChange",
    },
    ---@alias noteOnPlayerBase {triggerPlayer:Player}
    Player = {
        --- 玩家聊天
        ---@alias noteOnPlayerChatData noteOnPlayerBase|{chatString:"聊天的内容",matchedString:"匹配命中的内容"}
        Chat = "playerChat",
        --- 玩家按下Esc
        ---@alias noteOnPlayerEscData noteOnPlayerBase
        Esc = "playerEsc",
        --- 玩家选中单位
        ---@alias noteOnPlayerSelectUnitData noteOnPlayerBase|{triggerUnit:Unit}
        SelectUnit = "playerSelectUnit",
        --- 玩家取消选择单位
        ---@alias noteOnPlayerDeSelectUnitData noteOnPlayerBase|{triggerUnit:Unit}
        DeSelectUnit = "playerDeSelectUnit",
        --- 玩家选中物品
        ---@alias noteOnPlayerSelectItemData noteOnPlayerBase|{triggerItem:Item}
        SelectItem = "playerSelectItem",
        --- 玩家取消选择物品
        ---@alias noteOnPlayerDeSelectItemData noteOnPlayerBase|{triggerUnit:Unit}
        DeSelectItem = "playerDeSelectItem",
        --- 玩家离开游戏
        ---@alias noteOnPlayerQuitData noteOnPlayerBase
        Quit = "playerQuit",
    },


    ---@alias noteOnUnitBase {triggerUnit:Unit,triggerAbility:Ability,triggerItem:Item}
    Unit = {
        --- 准备攻击
        ---@alias noteOnUnitBeforeAttackData noteOnUnitBase|{targetUnit:Unit}
        BeforeAttack = "unitBeforeAttack",
        --- 攻击
        ---@alias noteOnUnitAttackData noteOnUnitBase|{targetUnit:Unit,damage:"攻击伤害值"}
        Attack = "unitAttack",
        --- 回避
        ---@alias noteOnUnitAvoidData noteOnUnitBase|{sourceUnit:Unit}
        Avoid = "unitAvoid",
        --- 破防
        ---@alias noteOnUnitBreakArmorData noteOnUnitBase|{targetUnit:Unit,breakType:"无视类型"}
        BreakArmor = "unitBreakArmor",
        --- 击飞目标
        ---@alias noteOnUnitCrackFlyData noteOnUnitBase|{targetUnit:Unit,distance:"击退距离",height:"击飞高度",duration:"凌空时长"}
        CrackFly = "unitCrackFly",
        --- 暴击目标
        ---@alias noteOnUnitCritData noteOnUnitBase|{targetUnit:Unit}
        Crit = "unitCrit",
        --- 造成伤害
        ---@alias noteOnUnitDamageData noteOnUnitBase|{targetUnit:Unit,damage:"伤害值",damageSrc:"伤害来源"}
        Damage = "unitDamage",
        --- 单位出生
        ---@alias noteOnUnitBornData noteOnUnitBase
        Born = "unitBorn",
        --- 单位死亡
        ---@alias noteOnUnitDeadData noteOnUnitBase|{sourceUnit:Unit}
        Dead = "unitDead",
        --- 单位假死（可以复活的单位被击杀时触发）
        ---@alias noteOnUnitFeignDeadData noteOnUnitDeadData
        FeignDead = "unitFeignDead",
        --- 复活
        ---@alias noteOnUnitRebornData noteOnUnitBase
        Reborn = "unitReborn",
        --- 附魔反应
        ---@alias noteOnUnitEnchantData noteOnUnitBase|{sourceUnit:Unit,enchantType:"附魔类型",radio:"伤害占比",damage:"伤害值",addition:"加成百分比"}
        Enchant = "unitEnchant",
        --- 攻击吸血
        ---@alias noteOnUnitHPSuckAttackData noteOnUnitBase|{targetUnit:Unit,value:"吸血值",percent:"吸血百分比"}
        HPSuckAttack = "unitHPSuckAttack",
        --- 技能吸血
        ---@alias noteOnUnitHPSuckAbilityData noteOnUnitBase|{targetUnit:Unit,value:"吸血值",percent:"吸血百分比"}
        HPSuckAbility = "unitHPSuckAbility",
        --- 候住命令
        ---@alias noteOnUnitStopData noteOnUnitBase
        Hold = "unitHold",
        --- 单位受伤
        ---@alias noteOnUnitHurtData noteOnUnitBase|{sourceUnit:Unit,targetUnit:Unit,damage:"伤害值",damageSrc:"伤害来源",damageType:"伤害类型"}
        Hurt = "unitHurt",
        --- 单位受伤前
        ---@alias noteOnUnitBeforeHurtData noteOnUnitHurtData
        BeforeHurt = "unitBeforeHurt",
        --- 全抵抗[防御]
        ---@alias noteOnUnitImmuneDefendData noteOnUnitBase|{sourceUnit:Unit}
        ImmuneDefend = "unitImmuneDefend",
        --- 全抵抗[无敌]
        ---@alias noteOnUnitImmuneInvincibleData noteOnUnitBase|{sourceUnit:Unit}
        ImmuneInvincible = "unitImmuneInvincible",
        --- 全抵抗[减伤]
        ---@alias noteOnUnitImmuneReductionData noteOnUnitBase|{sourceUnit:Unit}
        ImmuneReduction = "unitImmuneReduction",
        --- 单位杀敌
        ---@alias noteOnUnitKillData noteOnUnitBase|{targetUnit:Unit}
        Kill = "unitKill",
        --- 单位等级改变
        ---@alias noteOnUnitLevelChangeData noteOnUnitBase|{value:"变值差额"}
        LevelChange = "unitLevelChange",
        --- 闪电链击中目标
        ---@alias noteOnUnitLightningChainData noteOnUnitBase|{targetUnit:Unit,index:"链索引"}
        LightningChain = "unitLightningChain",
        --- 攻击吸魔
        ---@alias noteOnUnitMPSuckAttackData noteOnUnitBase|{targetUnit:Unit,value:"吸魔值",percent:"吸魔百分比"}
        MPSuckAttack = "unitMPSuckAttack",
        --- 技能吸魔
        ---@alias noteOnUnitMPSuckAbilityData noteOnUnitBase|{targetUnit:Unit,value:"吸魔值",percent:"吸魔百分比"}
        MPSuckAbility = "unitMPSuckAbility",
        --- 移动开始
        ---@alias noteOnUnitMoveStartData noteOnUnitBase|{x:"目标X",y:"目标Y"}
        MoveStart = "unitMoveStart",
        --- 移动停止
        ---@alias noteOnUnitMoveStopData noteOnUnitBase
        MoveStop = "unitMoveStop",
        --- 移动转向
        ---@alias noteOnUnitMoveTurnData noteOnUnitBase|{x:"当前X",y:"当前Y"}
        MoveTurn = "unitMoveTurn",
        --- 移动中
        ---@alias noteOnUnitMovingData noteOnUnitBase|{x:"当前X",y:"当前Y",step:"第几步"}
        Moving = "unitMoving",
        --- 移动路由
        ---@alias noteOnUnitMoveRouteData noteOnUnitBase|{x:"当前X",y:"当前Y"}
        MoveRoute = "unitMoveRoute",
        --- 硬直
        ---@alias noteOnUnitPunishData noteOnUnitBase|{sourceUnit:Unit,percent:"硬直程度",duration:"持续时间"}
        Punish = "unitPunish",
        --- 反伤
        ---@alias noteOnUnitReboundData noteOnUnitBase|{targetUnit:Unit,damage:"反伤伤害值"}
        Rebound = "unitRebound",
        --- 打断[不大于0.05秒的眩晕]
        ---@alias noteOnUnitShockData noteOnUnitBase|{targetUnit:Unit,duration:number}
        Shock = "unitShock",
        --- 分裂
        ---@alias noteOnUnitSplitData noteOnUnitBase|{targetUnit:Unit,radius:number}
        Split = "unitSplit",
        --- 停止命令
        ---@alias noteOnUnitStopData noteOnUnitBase
        Stop = "unitStop",
        --- 眩晕[大于0.05秒的眩晕]
        ---@alias noteOnUnitStunData noteOnUnitBase|{targetUnit:Unit,duration:number}
        Stun = "unitStun",
        Be = {
            --- 被准备攻击
            ---@alias noteOnUnitBeBeforeAttackData noteOnUnitBase|{sourceUnit:Unit}
            BeforeAttack = "be:unitBeforeAttack",
            --- 被攻击
            ---@alias noteOnUnitBeAttackData noteOnUnitHurtData
            Attack = "be:unitAttack",
            --- 被回避
            ---@alias noteOnUnitBeAvoidData noteOnUnitBase|{targetUnit:Unit}
            Avoid = "be:unitAvoid",
            --- 被破防
            ---@alias noteOnUnitBeBreakArmorData noteOnUnitBase|{sourceUnit:Unit,breakType:"无视类型"}
            BreakArmor = "be:unitBreakArmor",
            --- 被击飞
            ---@alias noteOnUnitBeCrackFlyData noteOnUnitBase|{sourceUnit:Unit,distance:"击退距离",height:"击飞高度",duration:"凌空时长"}
            CrackFly = "be:unitCrackFly",
            --- 被暴击
            ---@alias noteOnUnitBeCritData noteOnUnitBase|{sourceUnit:Unit}
            Crit = "be:unitCrit",
            --- 被攻击吸血
            ---@alias noteOnUnitBeHPSuckAttackData noteOnUnitBase|{sourceUnit:Unit,value:"吸血值",percent:"吸血百分比"}
            HPSuckAttack = "be:unitHPSuckAttack",
            --- 被技能吸血
            ---@alias noteOnUnitBeHPSuckAbilityData noteOnUnitBase|{sourceUnit:Unit,value:"吸血值",percent:"吸血百分比"}
            HPSuckAbility = "be:unitHPSuckAbility",
            --- 被闪电链击中
            ---@alias noteOnUnitBeLightningChainData noteOnUnitBase|{sourceUnit:Unit,index:"链索引"}
            LightningChain = "be:unitLightningChain",
            --- 被攻击吸魔
            ---@alias noteOnUnitBeMPSuckAttackData noteOnUnitBase|{sourceUnit:Unit,value:"吸魔值",percent:"吸魔百分比"}
            MPSuckAttack = "be:unitMPSuckAttack",
            --- 被技能吸魔
            ---@alias noteOnUnitBeMPSuckAbilityData noteOnUnitBase|{sourceUnit:Unit,value:"吸魔值",percent:"吸魔百分比"}
            MPSuckAbility = "be:unitMPSuckAbility",
            --- 被反伤
            ---@alias noteOnUnitBeReboundData noteOnUnitHurtData
            Rebound = "be:unitRebound",
            --- 被打断[不大于0.05秒的眩晕]
            ---@alias noteOnUnitBeShockData noteOnUnitBase|{sourceUnit:Unit,duration:number}
            Shock = "be:unitShock",
            --- 被分裂[核心型]
            ---@alias noteOnUnitBeSplitData noteOnUnitBase|{sourceUnit:Unit,radius:number}
            Split = "be:unitSplit",
            --- 被分裂[扩散型]
            ---@alias noteOnUnitBeSplitSpreadData noteOnUnitBase|{sourceUnit:Unit}
            SplitSpread = "be:unitSplitSpread",
            --- 被眩晕[大于0.05秒的眩晕]
            ---@alias noteOnUnitBeStunData noteOnUnitBase|{sourceUnit:Unit,duration:number}
            Stun = "be:unitStun",
        }
    },
    ---@alias noteOnAbilityBase {triggerAbility:Ability,triggerUnit:Unit}
    Ability = {
        -- 当单位获得技能
        ---@alias noteOnAbilityGetData noteOnAbilityBase
        Get = "abilityGet",
        --- 单位失去技能
        ---@alias noteOnAbilityLoseData noteOnAbilityBase
        Lose = "abilityLose",
        --- 单位开始施放技能（施法瞬间）
        ---@alias noteOnAbilitySpellData noteOnAbilityBase|{triggerItem:Item,targetUnit:Unit,targetX:number,targetY:number,targetZ:number}
        Spell = "abilitySpell",
        --- 技能生效
        ---@alias noteOnAbilityEffectiveData noteOnAbilityBase|{triggerItem:Item,targetUnit:Unit,targetX:number,targetY:number,targetZ:number}
        Effective = "abilityEffective",
        --- 技能持续施法每周期时（动作时）
        ---@alias noteOnAbilityCastingData noteOnAbilityBase|{triggerItem:Item,targetUnit:Unit,targetX:number,targetY:number,targetZ:number}
        Casting = "abilityCasting",
        --- 施放技能结束（只有持续施法有结束状态）
        ---@alias noteOnAbilityStopData noteOnAbilityBase
        Stop = "abilityStop",
        --- 停止施放技能（吟唱、持续施法有停止状态）
        ---@alias noteOnAbilityOverData noteOnAbilityBase
        Over = "abilityOver",
        --- 技能等级改变
        ---@alias noteOnAbilityLevelChangeData noteOnAbilityBase|{value:"变值差额"}
        LevelChange = "abilityLevelChange",
    },
    ---@alias noteOnItemBase {triggerItem:Item,triggerUnit:Unit}
    Item = {
        --- 获得物品
        ---@alias noteOnItemGetData noteOnItemBase
        Get = "itemGet",
        --- 失去物品
        ---@alias noteOnItemLoseData noteOnItemBase
        Lose = "itemLose",
        --- 使用物品
        ---@alias noteOnItemUsedData noteOnItemBase|noteOnAbilityEffectiveData
        Used = "itemUsed",
        --- 丢弃物品
        ---@alias noteOnItemDropData noteOnItemBase
        Drop = "itemDrop",
        --- 传递物品
        ---@alias noteOnItemDeliverData noteOnItemBase|{targetUnit:Unit}
        Deliver = "itemDeliver",
        --- 抵押物品（持有人售出）
        ---@alias noteOnItemPawnData noteOnItemBase
        Pawn = "itemPawn",
        --- 合成物品
        ---@alias noteOnItemSynthesisData noteOnItemBase
        Synthesis = "itemSynthesis",
        --- 拆分物品
        ---@alias noteOnItemSeparateData noteOnItemBase
        Separate = "itemSeparate",
        --- 物品等级改变
        ---@alias noteOnItemLevelChangeData noteOnItemBase|{value:"变值差额"}
        LevelChange = "itemLevelChange",
    },
    ---@alias noteOnStoreBase {triggerStore:Store}
    Store = {
        --- 卖出货品
        ---@alias noteOnStoreSellData noteOnStoreBase|{qty:"卖出数量"}
        Sell = "storeSell",
    },
    ---@alias noteOnDestructableBase {triggerDeco:Destructable}
    Destructable = {
        --- 装饰物被破坏
        ---@alias noteOnDecoDestroyData noteOnDestructableBase
        Destroy = "destructableDestroy",
    },
    ---@alias noteOnAIBase {triggerAI:AI}
    AI = {
        --- AI毁灭
        ---@alias noteOnAIDestroyData noteOnAIBase
        Destroy = "aiDestroy",
        --- 关连单位
        ---@alias noteOnAILinkData noteOnAIBase|{triggerUnit:Unit}
        Link = "aiLink",
        --- 断连单位
        ---@alias noteOnAIUnlinkData noteOnAIBase|{triggerUnit:Unit}
        Unlink = "aiUnlink",
    }
}