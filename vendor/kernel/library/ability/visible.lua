--- 隐身
---@param whichUnit Unit
---@param duration number
---@param model string
function ability.invisible(whichUnit, duration, model)
    if (isObject(whichUnit, "Unit") == false or whichUnit.isDead()) then
        return
    end
    duration = duration or 0
    if (model ~= nil) then
        whichUnit.effect(model, 0)
    end
    Buff(whichUnit, "invisible", duration, 0,
        function(buffObj)
            whichUnit.superposition("invisible", "+=1")
        end,
        function(buffObj)
            whichUnit.superposition("invisible", "-=1")
        end).purpose()
end

--- 现形(反隐身)
---@param whichUnit Unit
---@param duration number
---@param model string
function ability.visible(whichUnit, duration, model)
    if (isObject(whichUnit, "Unit") == false or whichUnit.isDead()) then
        return
    end
    duration = duration or 0
    if (model ~= nil) then
        whichUnit.effect(model, 0)
    end
    Buff(whichUnit, "invisible", duration, 0,
        function(buffObj)
            whichUnit.superposition("invisible", "-=1")
        end,
        function(buffObj)
            whichUnit.superposition("invisible", "+=1")
        end).purpose()
end