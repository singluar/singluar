---@class Ability:AbilityTpl
---@param tpl AbilityTpl
---@return Ability
function Ability(tpl)
    if (false == isObject(tpl, "AbilityTpl")) then
        return
    end
    return Object("Ability", {
        tpl = tpl,
    })
end