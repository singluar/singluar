---@param this Cursor
Class("Cursor")

    .public("uiKit",
    function(this, modify)
        return this.prop("uiKit", modify)
    end)

    .public("textureAim",
    function(this, modify)
        if (type(modify) == "table" and modify.normal and modify.ally and modify.enemy) then
            modify.normal = AUIKit(this.uiKit(), modify.normal, "tga")
            modify.ally = AUIKit(this.uiKit(), modify.ally, "tga")
            modify.enemy = AUIKit(this.uiKit(), modify.enemy, "tga")
        end
        return this.prop("textureAim", modify)
    end)

    .public("textureCircle",
    function(this, modify)
        if (modify and modify.allow) then
            modify.alpha = modify.alpha or 255
            modify.allow = AUIKit(this.uiKit(), modify.allow, "tga")
            modify.ban = AUIKit(this.uiKit(), modify.ban, "tga")
        end
        return this.prop("textureCircle", modify)
    end)

    .public("textureSquare",
    function(this, modify)
        if (modify and modify.allow) then
            modify.alpha = modify.alpha or 255
            modify.allow = AUIKit(this.uiKit(), modify.allow, "tga")
            modify.ban = AUIKit(this.uiKit(), modify.ban, "tga")
        end
        return this.prop("textureSquare", modify)
    end)

    .public("sizeRate",
    function(this, modify)
        return this.prop("sizeRate", modify)
    end)

    .public("banBorders",
    function(this, modify)
        return this.prop("banBorders", modify)
    end)

    .public("isSave",
    function(this, rx, ry)
        local isSave = true
        local banBorders = this.prop("banBorders")
        if (type(banBorders) ~= "table" or type(rx) ~= "number" or type(ry) ~= "number") then
            return isSave
        end
        if (rx < 0.02 or rx > 0.78 or ry < 0.02 or ry > 0.58) then
            return false
        end
        for _, b in ipairs(banBorders) do
            if (instanceof(b, "Frame")) then
                if (b.show() == true) then
                    local anchor = b.anchor()
                    if (anchor ~= nil) then
                        local x = anchor[1]
                        local y = anchor[2]
                        local w = anchor[3]
                        local h = anchor[4]
                        local xMin = x - w / 2
                        local xMax = x + w / 2
                        local yMin = y - h / 2
                        local yMax = y + h / 2
                        if (rx < xMax and rx > xMin and ry < yMax and ry > yMin) then
                            isSave = false
                            break
                        end
                    end
                end
            end
        end
        return isSave
    end)

    .public("tooltips",
    function(this, modify)
        if (type(modify) == "function") then
            this.prop("tooltips", modify)
            return this
        end
        return this.prop("tooltips")
    end)

    .public("selectionHook",
    function(this, whichUnit)
        if (isObject(whichUnit, "Unit")) then
            J.EnableSelect(false, false)
            time.setTimeout(0, function()
                J.SelectUnit(whichUnit.handle(), true)
            end)
            local s = 72 * whichUnit.prop("scale")
            this.prop("childSelection")
                .position(whichUnit.x(), whichUnit.y())
                .size(s, s)
                .show(true)
            this.prop("selectionHooker", whichUnit)
        end
    end)

    .public("selectionHooking",
    function(this)
        local u = this.prop("selectionHooker")
        if (isObject(u, "Unit")) then
            if (u.isDead()) then
                this.selectionUnHook()
                return
            end
            this.prop("childSelection").position(u.x(), u.y())
        end
    end)

    .public("selectionUnHook",
    function(this, callFunc)
        ---@type Unit
        local u = this.prop("selectionHooker")
        if (isObject(u, "Unit")) then
            this.prop("selectionHooker", NIL)
            local i = 0
            time.setInterval(0.03, function(curTimer)
                i = i + 1
                if (i >= 5 or u.isDead()) then
                    curTimer.destroy()
                    this.prop("childSelection").show(false)
                    J.EnableSelect(true, true)
                    if (type(callFunc) == "function") then
                        callFunc()
                    end
                    return
                end
                this.prop("childSelection").position(u.x(), u.y())
            end)
        end
    end)

    .public("ability",
    function(this, modify)
        if (modify ~= nil) then
            this.prop("curAimClosest", NIL)
            this.prop("curSize", NIL)
            this.prop("curUnits", NIL)
            if (isObject(modify, "Ability")) then
                local selection = PlayerLocal().selection()
                if (selection == nil or selection.owner().id() ~= PlayerLocal().id()) then
                    return this
                end
                if (selection.isInterrupt() or selection.isPause() or selection.isAbilityChantCasting() or selection.isAbilityKeepCasting()) then
                    return this
                end
                local at = modify.targetType()
                if (at == nil or at == ABILITY_TARGET_TYPE.PAS or at == ABILITY_TARGET_TYPE.TAG_E) then
                    return
                else
                    this.selectionHook(modify.bindUnit())
                    this.prop("ability", modify)
                    japi.Refresh("SL_CursorAbility", function()
                        ---@type Ability
                        local ab = this.prop("ability")
                        if (isObject(ab, "Ability") == false) then
                            japi.Refresh("SL_CursorAbility", nil)
                            return
                        end

                        local tt = ab.targetType()
                        local bu = ab.bindUnit()
                        if (tt == ABILITY_TARGET_TYPE.TAG_U or tt == ABILITY_TARGET_TYPE.TAG_L or tt == ABILITY_TARGET_TYPE.TAG_C) then
                            this.selectionHooking()
                        end
                        local rx = japi.MouseRX()
                        local ry = japi.MouseRY()
                        if (true ~= this.isSave(rx, ry)) then
                            this.prop("childAim").show(false)
                            this.prop("childArea").show(false)
                            return
                        end

                        local p = PlayerLocal()
                        local isProhibiting = ab.isProhibiting()
                        local coolDownRemain = ab.coolDownRemain()
                        if (isProhibiting or coolDownRemain > 0 or isObject(bu, "Unit") == false) then
                            this.abilityStop()
                            return
                        end
                        local tx = japi.DzGetMouseTerrainX()
                        local ty = japi.DzGetMouseTerrainY()
                        if (tt == ABILITY_TARGET_TYPE.TAG_U or tt == ABILITY_TARGET_TYPE.TAG_L) then
                            this.prop("childArea").show(false)
                            local isBan = bu.isInterrupt() or bu.isPause() or bu.isAbilityChantCasting() or bu.isAbilityKeepCasting()
                            local asset = this.textureAim()
                            if (asset == nil) then
                                asset = {
                                    normal = "Singluar\\ui\\aimWhite.tga",
                                    ally = "Singluar\\ui\\aimGreen.tga",
                                    enemy = "Singluar\\ui\\aimRed.tga"
                                }
                            end
                            local alpha = 255
                            local texture = asset.normal
                            if (isBan) then
                                alpha = 100
                            end
                            local closest = group.closest({
                                key = "Unit",
                                x = tx,
                                y = ty,
                                radius = 120,
                                limit = 5,
                                ---@param enumUnit Unit
                                filter = function(enumUnit)
                                    return ab.isCastTarget(enumUnit)
                                end
                            })
                            local curAimClosest = this.prop("curAimClosest")
                            if (isObject(curAimClosest, "Unit") and curAimClosest ~= closest) then
                                J.SetUnitVertexColor(curAimClosest.handle(), table.unpack(curAimClosest.rgba()))
                            end
                            if (isObject(closest, "Unit")) then
                                if (closest.isEnemy(p)) then
                                    texture = asset.enemy
                                else
                                    texture = asset.ally
                                end
                                local red = 255
                                local green = 255
                                local blue = 255
                                if (closest.isEnemy(p)) then
                                    green = 0
                                    blue = 0
                                elseif (closest.isAlly(p)) then
                                    red = 127
                                    blue = 0
                                end
                                if ((red ~= 255 or green ~= 255 or blue ~= 255)) then
                                    J.SetUnitVertexColor(closest.handle(), red, green, blue, closest.rgba()[4] or 255)
                                end
                                this.prop("curAimClosest", closest)
                            end
                            this.prop("childAim")
                                .texture(texture)
                                .alpha(alpha)
                                .relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_LEFT_BOTTOM, rx, ry)
                                .show(true)
                        elseif (tt == ABILITY_TARGET_TYPE.TAG_C) then
                            this.prop("childAim").show(false)
                            local castRadius = ab.castRadius()
                            local asset = this.textureCircle()
                            if (asset == nil) then
                                local skin = p.race()
                                if (RACE_SELECTION_SPELL_AREA_OF_EFFECT[skin]) then
                                    asset = {
                                        alpha = 255,
                                        allow = RACE_SELECTION_SPELL_AREA_OF_EFFECT[skin],
                                        ban = nil,
                                    }
                                else
                                    asset = {
                                        alpha = 180,
                                        allow = TEAM_COLOR_BLP_YELLOW,
                                        ban = TEAM_COLOR_BLP_RED,
                                    }
                                end
                            end
                            local sizeRate = this.prop("sizeRate")
                            local curSize = this.prop("curSize")
                            if (sizeRate <= 0 or curSize == nil or curSize == castRadius) then
                                curSize = castRadius
                            elseif (curSize < castRadius) then
                                curSize = math.min(castRadius, curSize + sizeRate)
                            elseif (curSize > castRadius) then
                                curSize = math.max(castRadius, curSize - sizeRate)
                            end
                            this.prop("curSize", curSize)
                            local prevUnit = this.prop("curUnits")
                            local newUnits = group.catch({
                                key = "Unit",
                                x = tx,
                                y = ty,
                                radius = castRadius,
                                limit = 30,
                                ---@param enumUnit Unit
                                filter = function(enumUnit)
                                    return ab.isCastTarget(enumUnit)
                                end
                            })
                            local renderAllow = {}
                            for _, u in ipairs(newUnits) do
                                renderAllow[u.id()] = true
                            end
                            if (type(prevUnit) == "table") then
                                for _, u in ipairs(prevUnit) do
                                    if (renderAllow[u.id()] == nil) then
                                        J.SetUnitVertexColor(u.handle(), table.unpack(u.rgba()))
                                    end
                                end
                            end
                            local texture
                            if (ab.isBanCursor({ x = tx, y = ty, radius = curSize, units = newUnits })) then
                                texture = asset.ban or asset.allow
                            else
                                texture = asset.allow
                            end
                            this.prop("curUnits", newUnits)
                            if (#newUnits > 0) then
                                for _, ru in ipairs(newUnits) do
                                    local red = 255
                                    local green = 255
                                    local blue = 255
                                    if (ru.owner().isNeutral()) then
                                        green = 230
                                        blue = 0
                                    elseif (ru.isEnemy(p)) then
                                        green = 0
                                        blue = 0
                                    elseif (ru.isAlly(p)) then
                                        red = 127
                                        blue = 0
                                    end
                                    if ((red ~= 255 or green ~= 255 or blue ~= 255)) then
                                        J.SetUnitVertexColor(ru.handle(), red, green, blue, ru.rgba()[4] or 255)
                                    end
                                end
                                newUnits = nil
                            end
                            this.prop("childArea")
                                .rgba(255, 255, 255, asset.alpha)
                                .texture(texture)
                                .size(curSize * 2, curSize * 2)
                                .position(tx, ty)
                                .show(true)
                        elseif (tt == ABILITY_TARGET_TYPE.TAG_S) then
                            this.prop("childAim").show(false)
                            local castWidth = ab.castWidth()
                            local castHeight = ab.castHeight()
                            local asset = this.textureSquare()
                            if (asset == nil) then
                                asset = {
                                    alpha = 150,
                                    allow = TEAM_COLOR_BLP_LIGHT_BLUE,
                                    ban = TEAM_COLOR_BLP_RED,
                                }
                            end
                            local sizeRate = this.prop("sizeRate")
                            local w_h = castWidth / castHeight
                            local curWidth = 0
                            local curHeight = this.prop("curSize")
                            if (sizeRate <= 0 or curHeight == nil or curHeight == castHeight) then
                                curHeight = castHeight
                                curWidth = castWidth
                            elseif (curHeight < castHeight) then
                                curHeight = math.min(castHeight, curHeight + sizeRate)
                                curWidth = w_h * curHeight
                            elseif (curHeight > castHeight) then
                                curHeight = math.max(castHeight, curHeight - sizeRate)
                                curWidth = w_h * curHeight
                            end
                            this.prop("curSize", curHeight)
                            local prevUnit = this.prop("curUnits")
                            local newUnits = group.catch({
                                key = "Unit",
                                limit = 30,
                                x = tx,
                                y = ty,
                                width = curWidth,
                                height = curHeight,
                                ---@param enumUnit Unit
                                filter = function(enumUnit)
                                    return ab.isCastTarget(enumUnit)
                                end
                            })
                            local renderAllow = {}
                            for _, u in ipairs(newUnits) do
                                renderAllow[u.id()] = true
                            end
                            if (type(prevUnit) == "table") then
                                for _, u in ipairs(prevUnit) do
                                    if (renderAllow[u.id()] == nil) then
                                        J.SetUnitVertexColor(u.handle(), table.unpack(u.rgba()))
                                    end
                                end
                            end
                            local texture
                            if (ab.isBanCursor({ x = tx, y = ty, width = curWidth, height = curHeight, units = newUnits })) then
                                texture = asset.ban or asset.allow
                            else
                                texture = asset.allow
                            end
                            this.prop("curUnits", newUnits)
                            if (#newUnits > 0) then
                                for _, ru in ipairs(newUnits) do
                                    local red = 255
                                    local green = 255
                                    local blue = 255
                                    if (ru.isEnemy(p)) then
                                        green = 0
                                        blue = 0
                                    elseif (ru.isAlly(p)) then
                                        red = 127
                                        blue = 0
                                    end
                                    if ((red ~= 255 or green ~= 255 or blue ~= 255)) then
                                        J.SetUnitVertexColor(ru.handle(), red, green, blue, ru.rgba()[4] or 255)
                                    end
                                end
                                newUnits = nil
                            end
                            this.prop("childArea")
                                .rgba(255, 255, 255, asset.alpha)
                                .texture(texture)
                                .size(curWidth, curHeight)
                                .position(tx, ty)
                                .show(true)
                        end
                    end)
                    mouse.onLeftRelease("SL_CursorAbilityLeftRelease", function(evtData)
                        local ab = this.prop("ability")
                        if (isObject(ab, "Ability") == false) then
                            mouse.onLeftRelease("SL_CursorAbilityLeftRelease", nil)
                            return
                        end
                        local ttc = ab.targetType()
                        if (ttc == ABILITY_TARGET_TYPE.TAG_U) then
                            ---@type Unit
                            local targetUnit = this.prop("curAimClosest")
                            if (isObject(targetUnit, "Unit")) then
                                if (ab.isCastTarget(targetUnit) == false) then
                                    evtData.triggerPlayer.alert(colour.hex(colour.gold, '目标不允许'))
                                else
                                    sync.send("G_GAME_SYNC", { "ability_effective_u", ab.id(), targetUnit.id() })
                                end
                            end
                        elseif (ttc == ABILITY_TARGET_TYPE.TAG_L or
                            ttc == ABILITY_TARGET_TYPE.TAG_C or
                            ttc == ABILITY_TARGET_TYPE.TAG_S) then
                            if (true ~= this.isSave(japi.MouseRX(), japi.MouseRY())) then
                                return
                            end
                            local cond = {
                                x = japi.DzGetMouseTerrainX(),
                                y = japi.DzGetMouseTerrainY(),
                            }
                            if (ttc == ABILITY_TARGET_TYPE.TAG_C) then
                                cond.radius = this.prop("curSize") or ab.castRadius()
                                cond.units = this.prop("curUnits")
                            elseif (ttc == ABILITY_TARGET_TYPE.TAG_S) then
                                local cs = this.prop("curSize")
                                if (cs) then
                                    cond.height = this.prop("curSize") or ab.castHeight()
                                    cond.width = ab.castWidth() / ab.castHeight() * cond.height
                                else
                                    cond.height = ab.castHeight()
                                    cond.width = ab.castWidth()
                                end
                                cond.units = this.prop("curUnits")
                            end
                            if (ab.isBanCursor(cond)) then
                                PlayerLocal().alert(colour.hex(colour.red, '无效目标'))
                                return
                            end
                            sync.send("G_GAME_SYNC", { "ability_effective_xyz", ab.id(), cond.x, cond.y, japi.DzGetMouseTerrainZ() })
                        end
                    end)
                end
            end
            return this
        end
        return this.prop("ability")
    end)

    .public("abilityStop",
    function(this)
        japi.Refresh("SL_CursorAbility", nil)
        mouse.onLeftRelease("SL_CursorAbilityLeftRelease", nil)
        this.prop("childAim").show(false)
        this.prop("childArea").show(false)
        local prevRadiusUnit = this.prop("curUnits")
        if (type(prevRadiusUnit) == "table") then
            for _, u in ipairs(prevRadiusUnit) do
                J.SetUnitVertexColor(u.handle(), table.unpack(u.rgba()))
            end
        end
        local curAimClosest = this.prop("curAimClosest")
        if (isObject(curAimClosest, "Unit")) then
            J.SetUnitVertexColor(curAimClosest.handle(), table.unpack(curAimClosest.rgba()))
            this.prop("curAimClosest", NIL)
        end
        this.prop("curSize", NIL)
        this.prop("curUnits", NIL)
        local ab = this.prop("ability")
        if (isObject(ab, "Ability")) then
            this.selectionUnHook(function()
                time.setTimeout(0, function()
                    this.prop("ability", NIL)
                end)
            end)
        end
    end)

    .public("abilityQuote",
    function(this, whichAbility)
        if (this.following()) then
            return
        end
        if (isObject(whichAbility, "Ability")) then
            local p = PlayerLocal()
            if (table.equal(whichAbility.bindUnit().owner(), p) == false) then
                return
            end
            local tt = whichAbility.targetType()
            if (tt == nil or tt == ABILITY_TARGET_TYPE.PAS) then
                return
            end
            if (whichAbility.isProhibiting() == true) then
                p.alert(colour.hex(colour.gold, whichAbility.prohibitReason()))
                return
            end
            if (whichAbility.bindUnit().isInterrupt() or whichAbility.bindUnit().isPause()) then
                p.alert(colour.hex(colour.red, '无法行动'))
                return
            end
            if (whichAbility.bindUnit().isAbilityChantCasting() or whichAbility.bindUnit().isAbilityKeepCasting()) then
                p.alert(colour.hex(colour.gold, '施法中'))
                return
            end
            audio(Vcm("war3_click1"))
            if (tt == ABILITY_TARGET_TYPE.TAG_E) then
                sync.send("G_GAME_SYNC", { "ability_effective", whichAbility.id() })
                return
            elseif (tt == ABILITY_TARGET_TYPE.TAG_U and whichAbility == Cursor().ability()) then
                local u = whichAbility.bindUnit()
                if (whichAbility.isCastTarget(u)) then
                    sync.send("G_GAME_SYNC", { "ability_effective_u", whichAbility.id(), whichAbility.bindUnit().id() })
                    return
                end
            end
            Cursor().ability(whichAbility)
        end
    end)

    .public("itemQuote",
    function(this, whichItem)
        if (this.following()) then
            return
        end
        if (isObject(whichItem, "Item")) then
            if (whichItem.charges() <= 0 and whichItem.consumable()) then
                return
            end
            this.abilityQuote(whichItem.ability())
        end
    end)

    .public("followObj",
    function(this)
        return this.prop("followObj")
    end)

    .public("following",
    function(this)
        return nil ~= this.followObj()
    end)

    .public("followCall",
    function(this, obj, data, stopFunc)
        if (obj ~= nil) then
            this.abilityStop()
            data = data or {}
            local texture = data.texture
            local size = data.size
            if (data.frame) then
                if (texture == nil) then
                    if (data.frame.texture) then
                        texture = data.frame.texture()
                    end
                end
                if (size == nil) then
                    if (data.frame.size) then
                        size = data.frame.size()
                    end
                end
            end
            ---@type FrameBackdrop
            local childFollow = this.prop("childFollow")
            childFollow
                .texture(texture)
                .size(size[1], size[2])
                .relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_LEFT_BOTTOM, japi.MouseRX(), japi.MouseRY())
                .alpha(150)
                .show(true)

            local selection = PlayerLocal().selection()
            this.selectionHook(PlayerLocal().selection())
            japi.Refresh("SL_CursorFollow", function()
                local prevObj = this.prop("followObj")
                if (false == table.equal(obj, prevObj)) then
                    japi.Refresh("SL_CursorFollow", nil)
                    this.followStop(stopFunc)
                    return
                end
                local siz = childFollow.size()
                local mx = japi.MouseRX()
                local my = japi.MouseRY()
                if (siz ~= nil) then
                    local hw = siz[1] / 2
                    local hh = siz[2] / 2
                    if (mx - hw < 0) then
                        mx = hw
                    end
                    if (mx + hw > 0.8) then
                        mx = 0.8 - hw
                    end
                    if (my - hh < 0) then
                        my = hh
                    end
                    if (my + hh > 0.6) then
                        my = 0.6 - hh
                    end
                end
                childFollow.relation(FRAME_ALIGN_CENTER, FrameGameUI, FRAME_ALIGN_LEFT_BOTTOM, mx, my)
                this.selectionHooking()
            end)
            mouse.onLeftRelease("SL_CursorFollowDrop", function()
                local o = this.prop("followObj")
                if (isObject(o, "Item") and this.isSave(japi.MouseRX(), japi.MouseRY())) then
                    local tx, ty = japi.DzGetMouseTerrainX(), japi.DzGetMouseTerrainY()
                    local closest = group.closest({
                        key = "Unit",
                        x = tx,
                        y = ty,
                        radius = 150,
                        limit = 5,
                        ---@param enumUnit Unit
                        filter = function(enumUnit)
                            return enumUnit ~= selection and enumUnit.isAlive() and enumUnit.owner() == selection.owner()
                        end
                    })
                    if (isObject(closest, "Unit")) then
                        sync.send("G_GAME_SYNC", { "item_deliver_cursor", o.id(), closest.id() })
                    else
                        sync.send("G_GAME_SYNC", { "item_drop_cursor", o.id(), tx, ty })
                    end
                    this.followStop()
                end
            end)
            this.prop("followObj", obj)
            this.prop("followData", data)
        end
    end)

    .public("followStop",
    function(this, stopFunc)
        japi.Refresh("SL_CursorFollow", nil)
        mouse.onLeftRelease("SL_CursorFollowDrop", nil)
        this.selectionUnHook()
        ---@type FrameBackdrop
        local childFollow = this.prop("childFollow")
        childFollow.alpha(0).show(false)
        local followData = this.prop("followData") or {}
        followData.followObj = this.prop("followObj")
        if (type(stopFunc) == "function") then
            stopFunc(followData)
        end
        this.prop("followObj", NIL)
    end)
