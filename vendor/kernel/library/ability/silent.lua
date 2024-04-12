--- 沉默
---@param whichUnit Unit
---@param duration number
---@param model string
---@param attach string
function ability.silent(whichUnit, duration, model, attach)
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
    ---@param buffObj Unit
    Buff(whichUnit, "silent", duration, 0,
        function(buffObj)
            buffObj.superposition("silent", "+=1")
        end,
        function(buffObj)
            buffObj.superposition("silent", "-=1")
            if (eff) then
                effect.destroy(eff)
            end
        end)
        .purpose()
end