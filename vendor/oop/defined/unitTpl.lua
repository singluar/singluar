---@param this UnitTpl
Class("UnitTpl")
    .inherit("Attribute")
    .construct(
    function(this, options)
        local modelAlias = this.prop("modelAlias")
        if (modelAlias == nil) then
            modelAlias = options.modelAlias
            PropChange(this, "modelAlias", "std", modelAlias, false)
        end
        local id = slk.n2i(modelAlias .. "|U")
        local uSlk = slk.i2v(id)
        local movetp = UNIT_MOVE_TYPE.foot
        if (uSlk.slk.movetp == "amph") then
            movetp = UNIT_MOVE_TYPE.amphibious
        elseif (uSlk.slk.movetp == "fly") then
            movetp = UNIT_MOVE_TYPE.fly
        elseif (uSlk.slk.movetp == "float") then
            movetp = UNIT_MOVE_TYPE.float
        end
        local name = modelAlias
        PropChange(this, "hp", "std", this.prop("hp") or 1e4, false)
        PropChange(this, "hpCur", "std", this.prop("hpCur") or 1e4, false)
        PropChange(this, "mp", "std", this.prop("mp") or 1e4, false)
        PropChange(this, "mpCur", "std", this.prop("mpCur") or 1e4, false)
        PropChange(this, "attackPoint", "std", this.prop("attackPoint") or 0.8, false)
        PropChange(this, "animateScale", "std", this.prop("animateScale") or 1, false)
        PropChange(this, "turnSpeed", "std", this.prop("turnSpeed") or 1, false)
        PropChange(this, "properName", "std", this.prop("properName") or "", false)
        PropChange(this, "material", "std", this.prop("material") or UNIT_MATERIAL.flesh, false)
        PropChange(this, "stature", "std", this.prop("stature") or 50, false)
        PropChange(this, "period", "std", this.prop("period") or -1, false)
        PropChange(this, "levelMax", "std", this.prop("levelMax") or Game().unitLevelMax(), false)
        PropChange(this, "level", "std", this.prop("level") or 0, false)
        PropChange(this, "abilityPoint", "std", this.prop("abilityPoint") or 0, false)
        PropChange(this, "sightBase", "std", this.prop("sightBase") or math.floor(uSlk.slk.sight), false)
        PropChange(this, "sightDiff", "std", this.prop("sightDiff") or math.floor(uSlk.slk.sight - math.floor(uSlk.slk.nsight)), false)
        PropChange(this, "sight", "std", this.prop("sight") or math.floor(uSlk.slk.sight), false)
        PropChange(this, "nsight", "std", this.prop("nsight") or math.floor(uSlk.slk.nsight), false)
        PropChange(this, "attackSpaceBase", "std", this.prop("attackSpaceBase") or math.floor(uSlk.slk.cool1 or 0), false)
        PropChange(this, "attackRangeAcquire", "std", this.prop("attackRangeAcquire") or math.floor(uSlk.slk.acquire), false)
        PropChange(this, "attackRange", "std", this.prop("attackRange") or math.floor(uSlk.slk.rangeN1 or 0), false)
        PropChange(this, "move", "std", this.prop("move") or math.floor(uSlk.slk.spd or 0), false)
        PropChange(this, "modelId", "std", this.prop("modelId") or c2i(id), false)
        PropChange(this, "modelScale", "std", this.prop("modelScale") or math.trunc(uSlk.slk.modelScale or 1, 2), false)
        PropChange(this, "name", "std", this.prop("name") or name, false)
        PropChange(this, "rgba", "std", this.prop("rgba") or { math.floor(uSlk.slk.red), math.floor(uSlk.slk.green), math.floor(uSlk.slk.blue), 255 }, false)
        PropChange(this, "moveType", "std", this.prop("moveType") or movetp, false)
        PropChange(this, "flyHeight", "std", this.prop("flyHeight") or math.floor(uSlk.slk.moveHeight or 0), false)
        PropChange(this, "collision", "std", this.prop("collision") or math.floor(uSlk.slk.collision or 0), false)
        PropChange(this, "icon", "std", this.prop("icon") or uSlk.slk.Art or "Singluar\\ui\\default.tga", false)
        PropChange(this, "scale", "std", this.prop("scale") or math.trunc(uSlk.slk.scale or 1, 2), false)
        PropChange(this, "isAttackAble", "std", true, false)
        PropChange(this, "weaponSoundMode", "std", this.prop("weaponSoundMode") or 1, false)
        PropChange(this, "weaponLength", "std", this.prop("weaponLength") or 50, false)
        PropChange(this, "weaponHeight", "std", this.prop("weaponHeight") or 30, false)
        --叠加态(叠加态可以轻松管理可叠层的状态控制)
        local s = "<SUPERPOSITION>"
        PropChange(this, s .. "collision", "std", this.prop(s .. "collision") or 1, false) --可碰撞
        PropChange(this, s .. "attack", "std", this.prop(s .. "attack") or 1, false) --可攻击
        PropChange(this, s .. "select", "std", this.prop(s .. "select") or 1, false) --可选择
        PropChange(this, s .. "invulnerable", "std", this.prop(s .. "invulnerable") or 0, false) --无敌
        PropChange(this, s .. "invisible", "std", this.prop(s .. "invisible") or 0, false) --隐身
        PropChange(this, s .. "pause", "std", this.prop(s .. "pause") or 0, false) --暂停态
        PropChange(this, s .. "show", "std", this.prop(s .. "show") or 1, false) --显示态
        PropChange(this, s .. "hurt", "std", this.prop(s .. "hurt") or 0, false) --受到伤害态
        PropChange(this, s .. "damage", "std", this.prop(s .. "damage") or 0, false) --造成伤害态
        PropChange(this, s .. "stun", "std", this.prop(s .. "stun") or 0, false) --眩晕态
        PropChange(this, s .. "punish", "std", this.prop(s .. "punish") or 0, false) --硬直态
        PropChange(this, s .. "silent", "std", this.prop(s .. "silent") or 0, false) --沉默态
        PropChange(this, s .. "unArm", "std", this.prop(s .. "unArm") or 0, false) --缴械态
        PropChange(this, s .. "crackFly", "std", this.prop(s .. "crackFly") or 0, false) --击飞态
        PropChange(this, s .. "leap", "std", this.prop(s .. "leap") or 0, false) --冲锋态
        PropChange(this, s .. "whirlwind", "std", this.prop(s .. "whirlwind") or 0, false) --剑刃风暴态
    end)