--- 冻结|时间停止
---@param whichUnit Unit
---@param duration number
function ability.freeze(whichUnit, duration, red, green, blue, alpha)
    if (whichUnit == nil) then
        return
    end
    if (not isObject(whichUnit, "Unit") or whichUnit.isDead()) then
        return
    end
    duration = duration or 0
    if (duration <= 0) then
        -- 假如没有设置时间，忽略
        return
    end
    red = red or 255
    green = green or 255
    blue = blue or 255
    alpha = alpha or 255
    Buff(whichUnit, "freeze", duration, 0,
        function(buffObj)
            buffObj.rgba(red, green, blue, alpha, duration)
            buffObj.superposition("pause", "+=1")
            buffObj.animateScale("-=1")
        end,
        function(buffObj)
            buffObj.animateScale("+=1")
            buffObj.superposition("pause", "-=1")
        end)
        .purpose()
end