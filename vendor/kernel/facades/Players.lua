---@param indexes number[]
---@return Player[]
function Players(indexes)
    local ps = {}
    if (#indexes > 0) then
        for _, i in ipairs(indexes) do
            if (isObject(Player(i), "Player")) then
                table.insert(ps, Player(i))
            end
        end
    end
    return ps
end