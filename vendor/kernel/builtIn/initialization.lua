INITIALIZATION = function()

    -- SINGLUAR_ID
    SINGLUAR_ID = {
        ["unit_token"] = c2i(slk.n2i("F6S_UNIT_TOKEN")),
        ["unit_death_token"] = c2i(slk.n2i("F6S_UNIT_TOKEN_DEATH")), --- 死亡时间圈
        ["ability_invulnerable"] = c2i("Avul"), -- 默认无敌技能
        ["ability_locust"] = c2i("Aloc"), -- 蝗虫技能
        ["ability_fly"] = c2i("Arav"), -- 风暴之鸦技能
        ["ability_invisible"] = c2i(slk.n2i("F6S_ABILITY_INVISIBLE")),
        ["texture_alert_circle_exclamation"] = c2i(slk.n2i("F6S_TEXTURE_ALERT_CIRCLE_EXCLAMATION")), --- 警示圈模型!
        ["texture_alert_circle_x"] = c2i(slk.n2i("F6S_TEXTURE_ALERT_CIRCLE_X")), --- 警示圈模型X
        ["japi_delay"] = c2i(slk.n2i("F6S_JAPI_DELAY")),
    }
    SINGLUAR_ID["avoid"] = {}
    SINGLUAR_ID["avoid"].add = c2i(slk.n2i("F6S_ABILITY_AVOID_ADD"))
    SINGLUAR_ID["avoid"].sub = c2i(slk.n2i("F6S_ABILITY_AVOID_SUB"))
    -- 视野
    SINGLUAR_ID["sight"] = { add = {}, sub = {} }
    SINGLUAR_ID["sight_gradient"] = {}
    local sightBase = { 1, 2, 3, 4, 5 }
    local si = 1
    while (si <= 1000) do
        for _, v in ipairs(sightBase) do
            v = math.floor(v * si)
            table.insert(SINGLUAR_ID["sight_gradient"], v)
            SINGLUAR_ID["sight"].add[v] = c2i(slk.n2i("F6S_ABILITY_SIGHT_ADD_" .. v))
            SINGLUAR_ID["sight"].sub[v] = c2i(slk.n2i("F6S_ABILITY_SIGHT_SUB_" .. v))
        end
        si = si * 10
    end
    table.sort(SINGLUAR_ID["sight_gradient"], function(a, b)
        return a > b
    end)

    SINGLUAR_VOICE_INIT()

    --- 只支持自定义UI
    japi.DzEnableWideScreen(true)
    japi.DzFrameHideInterface()
    japi.DzLoadToc("UI\\singluar_frame.toc")
    --- 预读技能
    local u = JassGlobals["prevReadToken"]
    for _, v in ipairs(SINGLUAR_ID["sight_gradient"]) do
        J.UnitAddAbility(u, SINGLUAR_ID["sight"].add[v])
        J.UnitAddAbility(u, SINGLUAR_ID["sight"].sub[v])
        J.UnitRemoveAbility(u, SINGLUAR_ID["sight"].add[v])
        J.UnitRemoveAbility(u, SINGLUAR_ID["sight"].sub[v])
    end
    J.RemoveUnit(u)

    --- 默认区域
    local wb = J.GetWorldBounds()
    J.handleRef(wb)
    local w = J.GetRectMaxX(wb) - J.GetRectMinX(wb)
    local h = J.GetRectMaxY(wb) - J.GetRectMinY(wb)
    local x = J.GetRectCenterX(wb)
    local y = J.GetRectCenterY(wb)
    RectWorld = Rect("wb", "square", x, y, w, h)
    RectWorld.__HANDLE__ = wb

    w = (J.GetCameraBoundMaxX() + J.GetCameraMargin(CAMERA_MARGIN_RIGHT)) - (J.GetCameraBoundMinX() - J.GetCameraMargin(CAMERA_MARGIN_LEFT))
    h = (J.GetCameraBoundMaxY() + J.GetCameraMargin(CAMERA_MARGIN_TOP)) - (J.GetCameraBoundMinY() - J.GetCameraMargin(CAMERA_MARGIN_BOTTOM))
    x = (J.GetCameraBoundMinX() - J.GetCameraMargin(CAMERA_MARGIN_LEFT)) + w / 2
    y = (J.GetCameraBoundMinY() - J.GetCameraMargin(CAMERA_MARGIN_BOTTOM)) + h / 2
    RectPlayable = Rect("playable", "square", x, y, w, h)
    w = J.GetCameraBoundMaxX() - J.GetCameraBoundMinX()
    h = J.GetCameraBoundMaxY() - J.GetCameraBoundMinY()
    x = J.GetCameraBoundMinX() + w / 2
    y = J.GetCameraBoundMinY() + h / 2
    RectCamera = Rect("camera", "square", x, y, w, h)

    --- Z
    local xMax = RectWorld.xMax()
    local yMax = RectWorld.yMax()
    x = RectWorld.xMin()
    local loc = J.Location(0, 0)
    J.handleRef(loc)
    while (x < xMax) do
        y = RectWorld.yMin()
        while (y < yMax) do
            J.MoveLocation(loc, x, y)
            local z = J.GetLocationZ(loc)
            local xi = math.floor(x / SL_CACHE["ZI"])
            local yi = math.floor(y / SL_CACHE["ZI"])
            local zi = math.ceil(z)
            if (zi ~= 0) then
                if (SL_CACHE["Z"][xi] == nil) then
                    SL_CACHE["Z"][xi] = {}
                end
                SL_CACHE["Z"][xi][yi] = zi
            end
            z = nil
            y = y + SL_CACHE["ZI"]
        end
        x = x + SL_CACHE["ZI"]
    end
    J.RemoveLocation(loc)
    J.handleUnRef(loc)

    --- 游戏UI
    ---@type Frame
    FrameGameUI = Frame("UI_GAME", japi.DzGetGameUI(), nil)

    --- 玩家初始化
    PlayerAggressive = Player(PLAYER_NEUTRAL_AGGRESSIVE + 1)
    PlayerVictim = Player(PLAYER_NEUTRAL_VICTIM + 1)
    PlayerExtra = Player(PLAYER_NEUTRAL_EXTRA + 1)
    PlayerPassive = Player(PLAYER_NEUTRAL_PASSIVE + 1)
    for i = 1, BJ_MAX_PLAYER_SLOTS, 1 do Player(i) end

    --- 音乐
    Bgm()

    --- 镜头
    Camera()

    --- IsTyping
    keyboard.onRelease(KEYBOARD["Enter"], "IsTyping", function(evtData)
        local pi = evtData.triggerPlayer.index()
        SL_CACHE["IsTyping"][pi] = ((SL_CACHE["IsTyping"][pi] or false) == false)
    end)
    keyboard.onRelease(KEYBOARD["Esc"], "IsTyping", function(evtData)
        local pi = evtData.triggerPlayer.index()
        if (SL_CACHE["IsTyping"][pi] == true) then
            SL_CACHE["IsTyping"][pi] = false
        end
    end)
    mouse.onLeftRelease("IsTyping", function(evtData)
        local pi = evtData.triggerPlayer.index()
        if (SL_CACHE["IsTyping"][pi] == true) then
            SL_CACHE["IsTyping"][pi] = false
        end
    end)

    --- 异步随机池
    for i = 1, BJ_MAX_PLAYER_SLOTS do
        async.randPool.d[i] = {}
        async.randPool.i[i] = {}
    end

    --- UIKits setup
    UIKits.forEach(function(_, value)
        value.setup()
    end)

    --- UI - tooltips
    for i = 0, FRAME_OBJ_MAX_TOOLTIPS do
        FrameTooltips(i)
    end

    --- 初始化指针
    Cursor()

    --- 地形可破坏物
    J.EnumDestructablesInRect(RectWorld.handle(), nil, function()
        event.pool(destructable.evtDead, function(tgr)
            J.TriggerRegisterDeathEvent(tgr, J.GetEnumDestructable())
        end)
    end)

    --- 默认游戏同步操作
    sync.receive("G_GAME_SYNC", function(syncData)
        local syncPlayer = syncData.syncPlayer
        local command = syncData.transferData[1]
        if (command == "ability_effective") then
            local abId = syncData.transferData[2]
            ---@type Ability
            local ab = i2o(abId)
            if (isObject(ab, "Ability")) then
                ab.effective()
            end
        elseif (command == "ability_effective_u") then
            local abId = syncData.transferData[2]
            local uId = syncData.transferData[3]
            ---@type Ability
            local ab = i2o(abId)
            local u = i2o(uId)
            if (isObject(ab, "Ability") and isObject(u, "Unit")) then
                ab.effective({ targetUnit = u })
            end
        elseif (command == "ability_effective_xyz") then
            local abId = syncData.transferData[2]
            local x = tonumber(syncData.transferData[3])
            local y = tonumber(syncData.transferData[4])
            local z = tonumber(syncData.transferData[5])
            if (x == nil or y == nil or z == nil) then
                return
            end
            ---@type Ability
            local ab = i2o(abId)
            if (isObject(ab, "Ability")) then
                ab.effective({ targetX = x, targetY = y, targetZ = z })
            end
        elseif (command == "ability_level_up") then
            local abId = syncData.transferData[2]
            ---@type Ability
            local ab = i2o(abId)
            if (isObject(ab, "Ability")) then
                if (ab.level() < ab.levelMax()) then
                    local bu = ab.bindUnit()
                    if (isObject(bu, "Unit")) then
                        ab.bindUnit().abilityPoint('-=' .. ab.levelUpNeedPoint())
                        ab.level('+=1')
                    end
                end
            end
        elseif (command == "item_pawn") then
            local itId = syncData.transferData[2]
            ---@type Item
            local it = i2o(itId)
            if (isObject(it, "Item")) then
                it.pawn()
            end
        elseif (command == "item_drop") then
            local itId = syncData.transferData[2]
            local mx = tonumber(syncData.transferData[3])
            local my = tonumber(syncData.transferData[4])
            ---@type Item
            local it = i2o(itId)
            if (isObject(it, "Item")) then
                it.drop(mx, my)
            end
        elseif (command == "item_drop_cursor") then
            async.call(syncPlayer, function()
                local followData = Cursor().prop("followData") or {}
                ---@type FrameCustom
                local frame = followData.frame
                if (instanceof(frame, "FrameCustom")) then
                    japi.DzFrameSetAlpha(frame.handle(), frame.alpha())
                end
            end)
            local itId = syncData.transferData[2]
            local mx = tonumber(syncData.transferData[3])
            local my = tonumber(syncData.transferData[4])
            ---@type Item
            local it = i2o(itId)
            if (isObject(it, "Item")) then
                local eff
                if (syncPlayer.handle() == JassCommon["GetLocalPlayer"]()) then
                    eff = 'UI\\Feedback\\Confirmation\\Confirmation.mdl'
                else
                    eff = ''
                end
                effect.xyz(eff, mx, my, 2 + japi.Z(mx, my))
                it.drop(mx, my)
            end
        elseif (command == "item_deliver_cursor") then
            async.call(syncPlayer, function()
                local followData = Cursor().prop("followData") or {}
                ---@type FrameCustom
                local frame = followData.frame
                if (instanceof(frame, "FrameCustom")) then
                    japi.DzFrameSetAlpha(frame.handle(), frame.alpha())
                end
            end)
            local itId = syncData.transferData[2]
            local uId = syncData.transferData[3]
            ---@type Item
            local it = i2o(itId)
            if (isObject(it, "Item")) then
                it.deliver(i2o(uId))
            end
        elseif (command == "item_to_warehouse") then
            local itId = syncData.transferData[2]
            ---@type Item
            local it = i2o(itId)
            if (isObject(it, "Item")) then
                syncPlayer.selection().itemSlot().remove(it.itemSlotIndex())
                syncPlayer.warehouseSlot().push(it)
                audio(Vcm("war3_dropItem"), syncPlayer)
            end
        elseif (command == "warehouse_to_item") then
            local itId = syncData.transferData[2]
            ---@type Item
            local it = i2o(itId)
            if (isObject(it, "Item")) then
                syncPlayer.warehouseSlot().remove(it.warehouseSlotIndex())
                syncPlayer.selection().itemSlot().push(it)
                audio(Vcm("war3_pickItem"), syncPlayer)
            end
        end
    end)
end

--- 游戏开始
Game().onEvent(EVENT.Game.Start, "SINGLUAR_GAME_START", function()
    --- 全局时钟
    local t = J.CreateTimer()
    J.handleRef(t)
    J.TimerStart(t, 0.01, true, time.clock)
    --- UIKits refresh
    UIKits.forEach(function(_, value)
        value.start()
    end)
end)