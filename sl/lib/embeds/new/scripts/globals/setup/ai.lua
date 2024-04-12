--- AI配置

------ [游荡移动型AI]
--- 每隔3秒选择移动到附近350范围内随机坐标
AI("loiter")
    .period(3)
    .action(
    function(linkUnit)
        local x, y = math.polar(linkUnit.x(), linkUnit.y(), math.rand(50, 350), math.rand(0, 359))
        linkUnit.orderAIMove(x, y)
    end)