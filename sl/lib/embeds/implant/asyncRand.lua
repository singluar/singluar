--- 异步随机池
AYRD = function(min, max)
    min = math.ceil(min)
    max = math.ceil(max)
    if (min == max) then
        return
    end
    if (min > max) then
        min, max = max, min
    end
    local t = table.section(min, max)
    local m = min .. '_' .. max
    for i = 1, BJ_MAX_PLAYER_SLOTS do
        async.randPool.d[i][m] = table.rand(t, #t)
        async.randPool.i[i][m] = math.rand(1, #async.randPool.d[i][m])
    end
end
Game().onEvent(EVENT.Game.Start, "AYRD", function() RAL_ASYNC_RAND = 20220608 end)