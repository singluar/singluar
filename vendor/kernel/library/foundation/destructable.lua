---@class
destructable = destructable or {}

destructable.evtDead = J.Condition(function()
    local deadDest = J.GetTriggerDestructable()
    if (deadDest == nil) then
        return
    end
    event.trigger(RectWorld, EVENT.Destructable.Dead, {
        triggerDestructable = deadDest,
        name = J.GetDestructableName(deadDest),
        x = J.GetDestructableX(deadDest),
        y = J.GetDestructableY(deadDest),
    })
end)