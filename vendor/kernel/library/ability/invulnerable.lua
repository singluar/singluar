--- 无敌
---@param whichUnit Unit
---@param duration number
---@param model string
---@param attach string
function ability.invulnerable(whichUnit, duration, model, attach)
    if (isObject(whichUnit, "Unit") == false or whichUnit.isDead()) then
        return
    end
    duration = duration or 0
    if (duration <= 0) then
        return
    end
    attach = attach or "origin"
    local eff
    if (model ~= nil) then
        eff = whichUnit.attach(model, attach, duration)
    end
    Buff(whichUnit, "invulnerable", duration, 0,
        function(buffObj)
            buffObj.superposition("invulnerable", "+=1")
        end,
        function(buffObj)
            buffObj.superposition("invulnerable", "-=1")
            if (eff) then
                effect.destroy(eff)
            end
        end).purpose()
end