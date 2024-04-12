SL_FPS = 60
Game().onEvent(EVENT.Game.Start, "SL_FPS", function()
    SL_FPS_I = 0
    SL_FPS_D = time.inc
    japi.Refresh("SL_FPS", function()
        SL_FPS_I = SL_FPS_I + 1
        if (SL_FPS_I >= 30 and time.inc > SL_FPS_D) then
            SL_FPS = math.min(70, 30 / 0.01 / (time.inc - SL_FPS_D))
            SL_FPS_I = 0
            SL_FPS_D = time.inc
        end
    end)
end)