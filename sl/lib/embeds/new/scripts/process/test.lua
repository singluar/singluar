local process = Process("test")

process.onStart(function(this)

    print("Hello, World!")
    echo("你好，世界！")

    local effEcho = effect.xyz("Echo", 0, 0, 100, 10)

    local music = Bgm()
    music.stop()
    async.call(Player(1), function()
        music.play("China")
    end)

    local race = time.setInterval(1, function(_)
        local r = table.rand({ RACE_HUMAN_NAME, RACE_ORC_NAME, RACE_NIGHTELF_NAME, RACE_UNDEAD_NAME })
        Player(1)
            .race(r)
            .alert(string.rand(10))
    end)

    local footman = Unit(TPL_UNIT.Footman, Player(1), 0, 0, 270)
    footman.orderRoute(true, {
        {
            -500, -500,
            ---@param orderUnit Unit
            function(orderUnit)
                orderUnit.effect("HCancelDeath")
                orderUnit.orderRouteResume()
            end
        },
        {
            500, -500,
            ---@param orderUnit Unit
            function(orderUnit)
                ability.leap({
                    sourceUnit = orderUnit,
                    targetPoint = { 0, -1000, 0 },
                    speed = 3000,
                    height = 500,
                    reflex = 2,
                    onEnd = function(options)
                        options.sourceUnit.orderRouteResume()
                    end
                })
            end
        },
        {
            500, -1000,
            ---@param orderUnit Unit
            function(orderUnit)
                ability.crackFly({
                    targetUnit = orderUnit,
                    distance = 300,
                    height = 500,
                    bounce = { qty = 3 },
                    onEnd = function(options)
                        options.targetUnit.orderRouteResume()
                    end
                })
            end
        },
        { -500, -1000 },
    })

    this.stage("effEcho", effEcho)
    this.stage("music", music)
    this.stage("race", race)
    this.stage("footman", footman)

    local footman2 = Unit(TPL_UNIT.Footman, PlayerPassive, 0, 0, 270)
    AI("loiter").link(footman2)
    this.stage("footman2", footman2)

end)

process.onOver(function(this)
    effect.destroy(this.stage("effEcho"))
    this.stage("music").stop()
    this.stage("race").destroy()
    this.stage("footman").destroy()
    this.stage("footman2").destroy()
end)

