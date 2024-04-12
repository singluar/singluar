function ability.sight(whichUnit, diff)
    for _, gradient in ipairs(SINGLUAR_ID["sight_gradient"]) do
        J.UnitRemoveAbility(whichUnit, SINGLUAR_ID["sight"].add[gradient])
        J.UnitRemoveAbility(whichUnit, SINGLUAR_ID["sight"].sub[gradient])
    end
    local tempVal = math.round(math.abs(diff))
    local sight_gradient = table.clone(SINGLUAR_ID["sight_gradient"])
    if (tempVal ~= 0) then
        while (true) do
            local flag = false
            for i, v in ipairs(sight_gradient) do
                if (tempVal >= v) then
                    tempVal = math.round(tempVal - v)
                    table.remove(sight_gradient, i)
                    if (diff > 0) then
                        J.UnitAddAbility(whichUnit, SINGLUAR_ID["sight"].add[v])
                    else
                        J.UnitAddAbility(whichUnit, SINGLUAR_ID["sight"].sub[v])
                    end
                    flag = true
                    break
                end
            end
            if (flag == false) then
                break
            end
        end
    end
end