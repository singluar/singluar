---@param this UnitTpl
---@param resultNum number
Class("UnitTpl")
    .exec("flyHeight",
    function(this, resultNum)
        if (resultNum > 0) then
            PropChange(this, "moveType", "std", UNIT_MOVE_TYPE.fly, false)
        end
    end)
    .exec("punish",
    function(this, resultNum)
        PropChange(this, "punishCur", "std", resultNum, false)
    end)
    .exec("hp",
    function(this, resultNum)
        PropChange(this, "hpCur", "std", resultNum, false)
    end)
    .exec("mp",
    function(this, resultNum)
        PropChange(this, "mpCur", "std", resultNum, false)
    end)
    .exec("<SUPERPOSITION>attack",
    function(this, resultNum)
        this.prop("isAttackAble", resultNum > 0)
    end)