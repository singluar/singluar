---@class texture 纹理（遮罩/警示圈）
texture = texture or {}

---@type table 纹理个数限制器
texture.limiter = texture.limiter or {}

---@private
function texture.cinematicFilterGeneric(duration, bmode, tex, red0, green0, blue0, trans0, red1, green1, blue1, trans1)
    J.SetCineFilterTexture(tex)
    J.SetCineFilterBlendMode(bmode)
    J.SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE)
    J.SetCineFilterStartUV(0, 0, 1, 1)
    J.SetCineFilterEndUV(0, 0, 1, 1)
    J.SetCineFilterStartColor(red0, green0, blue0, 255 - trans0)
    J.SetCineFilterEndColor(red1, green1, blue1, 255 - trans1)
    J.SetCineFilterDuration(duration)
    J.DisplayCineFilter(true)
end

--- 创建一个警示圈
---@param diameter number 直径范围(px)
---@param x number 坐标X
---@param y number 坐标Y
---@param duration number 持续时间，警示圈不允许永久存在，duration默认为3秒
---@param token number 马甲单位ID,默认叹号！马甲单位原始直径应为128px（刚好一小格）
---@param color number 警示圈马甲单位的颜色,仅支持玩家队伍色，参考 blizzard:^PLAYER_COLOR_?
---@param limit number 最大显示极限，默认 20
function texture.alertCircle(diameter, x, y, duration, token, color, limit)
    if (diameter == nil or diameter < 64 or token == nil or type(token) ~= "number") then
        return
    end
    limit = limit or 20
    duration = duration or 3
    if (duration <= 0) then
        duration = 3
    end
    local modelScale = slk.i2v(token, "slk", "modelScale")
    if (modelScale == nil) then
        return
    end
    if (texture.limiter[token] == nil) then
        texture.limiter[token] = {}
    end
    if (#texture.limiter[token] >= limit) then
        local first = texture.limiter[token][1]
        table.remove(texture.limiter[token], 1)
        first.timer.destroy()
        J.RemoveUnit(first.unit)
        J.handleUnRef(first.unit)
    end
    color = color or PLAYER_COLOR_RED
    modelScale = math.trunc(math.trunc(modelScale, 3) * (diameter / 128), 2)
    local tmp = {}
    tmp.unit = J.CreateUnit(J.Player(PLAYER_NEUTRAL_PASSIVE), token, x, y, 270)
    J.handleRef(tmp.unit)
    J.SetUnitColor(tmp.unit, color)
    J.SetUnitScale(tmp.unit, modelScale, modelScale, modelScale)
    tmp.timer = time.setTimeout(duration, function()
        for k, v in ipairs(texture.limiter[token]) do
            print(v.unit, tmp.unit)
            if (v.unit == tmp.unit) then
                table.remove(texture.limiter[token], k)
                break
            end
        end
        J.RemoveUnit(tmp.unit)
        J.handleUnRef(tmp.unit)
    end)
    table.insert(texture.limiter[token], tmp)
end

--- 创建一个系统默认叹号警示圈（最多7个）
--- 马甲默认叹号！单位原始直径应为128px（刚好一小格）
---@param diameter number 直径范围(px)
---@param x number 坐标X
---@param y number 坐标Y
---@param duration number 持续时间，警示圈不允许永久存在，duration默认为3秒
---@param color number 警示圈马甲单位的颜色,仅支持玩家队伍色，参考 blizzard:^PLAYER_COLOR_?
function texture.alertCircleExclamation(diameter, x, y, duration, color)
    texture.alertCircle(diameter, x, y, duration, SINGLUAR_ID["texture_alert_circle_exclamation"], color, 7)
end

--- 创建一个系统默认X号警示圈（最多7个）
--- 马甲默认X号！单位原始直径应为128px（刚好一小格）
---@param diameter number 直径范围(px)
---@param x number 坐标X
---@param y number 坐标Y
---@param duration number 持续时间，警示圈不允许永久存在，duration默认为3秒
---@param color number 警示圈马甲单位的颜色,仅支持玩家队伍色，参考 blizzard:^PLAYER_COLOR_?
function texture.alertCircleX(diameter, x, y, duration, color)
    texture.alertCircle(diameter, x, y, duration, SINGLUAR_ID["texture_alert_circle_x"], color, 7)
end