---@class Unit:UnitTpl
---@param tpl UnitTpl
---@param owner Player
---@param x number 坐标X[可选:0]
---@param x number 坐标Y[可选:0]
---@param facing number 面向角度[可选:270]
---@return Unit
function Unit(tpl, owner, x, y, facing)
    if (false == isObject(tpl, "UnitTpl") or false == isObject(owner, "Player")) then
        return
    end
    return Object("Unit", {
        tpl = tpl,
        owner = owner,
        x = x,
        y = y,
        facing = facing,
    })
end
