---@class
view = view or {}

-- 窗口大小修改绑定
view._adaptiveFrames = view._adaptiveFrames or nil
view._frameEventKeys = view._frameEventKeys or {
    "onMouseLeftClick", "onMouseLeftRelease",
    "onMouseRightClick", "onMouseRightRelease",
    "onMouseMove", "onMouseEnter", "onMouseLeave"
}

---@param whichFrame Frame
function view.isGameUI(whichFrame)
    if (FrameGameUI == nil) then
        return whichFrame.handle() == japi.DzGetGameUI()
    end
    return whichFrame.id() == FrameGameUI.id()
end

--- 锚指的是一个frame的中心，相对于屏幕左下角的{X,Y,W,H}(RX)
---@param whichFrame Frame
---@return noteAnchorData
function view.setAnchor(whichFrame)
    local relative = whichFrame.relation()
    local size = whichFrame.size()
    if (relative ~= nil and size ~= nil) then
        ---@type noteAnchorData
        local anchorParent = relative[2].anchor()
        if (anchorParent ~= nil) then
            local point = relative[1]
            local relativePoint = relative[3]
            -- 偏移度
            local aw
            local ah
            local pw
            local ph
            if (point == FRAME_ALIGN_LEFT_TOP or point == FRAME_ALIGN_LEFT or point == FRAME_ALIGN_LEFT_BOTTOM) then
                aw = 1
            elseif (point == FRAME_ALIGN_TOP or point == FRAME_ALIGN_CENTER or point == FRAME_ALIGN_BOTTOM) then
                aw = 0
            elseif (point == FRAME_ALIGN_RIGHT_TOP or point == FRAME_ALIGN_RIGHT or point == FRAME_ALIGN_RIGHT_BOTTOM) then
                aw = -1
            end
            if (point == FRAME_ALIGN_LEFT_TOP or point == FRAME_ALIGN_TOP or point == FRAME_ALIGN_RIGHT_TOP) then
                ah = -1
            elseif (point == FRAME_ALIGN_LEFT or point == FRAME_ALIGN_CENTER or point == FRAME_ALIGN_RIGHT) then
                ah = 0
            elseif (point == FRAME_ALIGN_LEFT_BOTTOM or point == FRAME_ALIGN_BOTTOM or point == FRAME_ALIGN_RIGHT_BOTTOM) then
                ah = 1
            end
            if (relativePoint == FRAME_ALIGN_LEFT_TOP or relativePoint == FRAME_ALIGN_LEFT or relativePoint == FRAME_ALIGN_LEFT_BOTTOM) then
                pw = -1
            elseif (relativePoint == FRAME_ALIGN_TOP or relativePoint == FRAME_ALIGN_CENTER or relativePoint == FRAME_ALIGN_BOTTOM) then
                pw = 0
            elseif (relativePoint == FRAME_ALIGN_RIGHT_TOP or relativePoint == FRAME_ALIGN_RIGHT or relativePoint == FRAME_ALIGN_RIGHT_BOTTOM) then
                pw = 1
            end
            if (relativePoint == FRAME_ALIGN_LEFT_TOP or relativePoint == FRAME_ALIGN_TOP or relativePoint == FRAME_ALIGN_RIGHT_TOP) then
                ph = 1
            elseif (relativePoint == FRAME_ALIGN_LEFT or relativePoint == FRAME_ALIGN_CENTER or relativePoint == FRAME_ALIGN_RIGHT) then
                ph = 0
            elseif (relativePoint == FRAME_ALIGN_LEFT_BOTTOM or relativePoint == FRAME_ALIGN_BOTTOM or relativePoint == FRAME_ALIGN_RIGHT_BOTTOM) then
                ph = -1
            end
            if (aw ~= nil and ah ~= nil and pw ~= nil and ph ~= nil) then
                local offsetX = relative[4]
                local offsetY = relative[5]
                local parentX = anchorParent[1]
                local parentY = anchorParent[2]
                local parentW = anchorParent[3]
                local parentH = anchorParent[4]
                local anchorX
                local anchorY
                local anchorW = size[1]
                local anchorH = size[2]
                local pwHalf = parentW / 2
                local phHalf = parentH / 2
                local awHalf = anchorW / 2
                local ahHalf = anchorH / 2
                anchorX = offsetX + parentX + pw * pwHalf + aw * awHalf
                anchorY = offsetY + parentY + ph * phHalf + ah * ahHalf
                anchorX = math.min(anchorX, 0.8 - awHalf)
                anchorX = math.max(anchorX, awHalf)
                anchorY = math.min(anchorY, 0.6 - ahHalf)
                anchorY = math.max(anchorY, ahHalf)
                whichFrame.prop("anchor", { anchorX, anchorY, anchorW, anchorH })
            end
        end
    end
    local lns = whichFrame.lowerNodes()
    if (isArray(lns)) then
        lns.forEach(function(_, c)
            view.setAnchor(c)
        end)
    end
end

---@protected
---@param whichFrame Frame
---@param key string|nil
function view.registerFrameEvent(whichFrame, evt, key)
    if (whichFrame == nil or evt == nil or key == nil) then
        return
    end
    ---@type table<string,Array>
    local list = whichFrame.prop("evtList")
    local isShow = whichFrame.show() and (false == whichFrame.isDestroy())
    if (isArray(list[evt])) then
        local func = list[evt].get(key)
        local ek = whichFrame.id() .. key
        if (isShow == false or type(func) ~= "function") then
            if (evt == "onMouseLeftClick") then
                mouse.onLeftRelease(ek, nil)
            elseif (evt == "onMouseRightClick") then
                mouse.onRightRelease(ek, nil)
            elseif (evt == "onMouseMove") then
                mouse.onMove(ek, 1, nil)
            elseif (evt == "onMouseEnter") then
                mouse.onMove(ek .. '_E', nil)
            elseif (evt == "onMouseLeave") then
                mouse.onMove(ek .. '_L', nil)
            end
        else
            if (evt == "onMouseLeftClick") then
                mouse.onLeftRelease(ek, function(evtData)
                    local anchor = whichFrame.anchor()
                    if (anchor ~= nil) then
                        local x = anchor[1]
                        local y = anchor[2]
                        local w = anchor[3]
                        local h = anchor[4]
                        local xMin = x - w / 2
                        local xMax = x + w / 2
                        local yMin = y - h / 2
                        local yMax = y + h / 2
                        local rx = japi.MouseRX()
                        local ry = japi.MouseRY()
                        if (rx < xMax and rx > xMin and ry < yMax and ry > yMin) then
                            func({ triggerFrame = whichFrame, triggerPlayer = evtData.triggerPlayer })
                        end
                    end
                end)
            elseif (evt == "onMouseRightClick") then
                mouse.onRightRelease(ek, function(evtData)
                    local anchor = whichFrame.anchor()
                    if (anchor ~= nil) then
                        local x = anchor[1]
                        local y = anchor[2]
                        local w = anchor[3]
                        local h = anchor[4]
                        local xMin = x - w / 2
                        local xMax = x + w / 2
                        local yMin = y - h / 2
                        local yMax = y + h / 2
                        local rx = japi.MouseRX()
                        local ry = japi.MouseRY()
                        if (rx < xMax and rx > xMin and ry < yMax and ry > yMin) then
                            func({ triggerFrame = whichFrame, triggerPlayer = evtData.triggerPlayer })
                        end
                    end
                end)
            elseif (evt == "onMouseMove") then
                mouse.onMove(ek, function(evtData)
                    local anchor = whichFrame.anchor()
                    if (anchor ~= nil) then
                        local x = anchor[1]
                        local y = anchor[2]
                        local w = anchor[3]
                        local h = anchor[4]
                        local xMin = x - w / 2
                        local xMax = x + w / 2
                        local yMin = y - h / 2
                        local yMax = y + h / 2
                        local rx = japi.MouseRX()
                        local ry = japi.MouseRY()
                        if (rx < xMax and rx > xMin and ry < yMax and ry > yMin) then
                            func({ triggerFrame = whichFrame, triggerPlayer = evtData.triggerPlayer })
                        end
                    end
                end)
            elseif (evt == "onMouseEnter") then
                mouse.onMove(ek .. '_E', function(evtData)
                    local entering = whichFrame.prop("mouseEntering" .. key) or 0
                    if (entering > 1) then
                        return
                    end
                    local anchor = whichFrame.anchor()
                    if (anchor ~= nil) then
                        local x = anchor[1]
                        local y = anchor[2]
                        local w = anchor[3]
                        local h = anchor[4]
                        local xMin = x - w / 2
                        local xMax = x + w / 2
                        local yMin = y - h / 2
                        local yMax = y + h / 2
                        local rx = japi.MouseRX()
                        local ry = japi.MouseRY()
                        if (rx < xMax and rx > xMin and ry < yMax and ry > yMin) then
                            whichFrame.prop("mouseEntering" .. key, entering + 1)
                            func({ triggerFrame = whichFrame, triggerPlayer = evtData.triggerPlayer })
                        end
                    end
                end)
            elseif (evt == "onMouseLeave") then
                mouse.onMove(ek .. '_L', function(evtData)
                    local entering = whichFrame.prop("mouseEntering" .. key) or 0
                    if (entering == 0) then
                        return
                    end
                    local anchor = whichFrame.anchor()
                    if (anchor ~= nil) then
                        local x = anchor[1]
                        local y = anchor[2]
                        local w = anchor[3]
                        local h = anchor[4]
                        local xMin = x - w / 2
                        local xMax = x + w / 2
                        local yMin = y - h / 2
                        local yMax = y + h / 2
                        local rx = japi.MouseRX()
                        local ry = japi.MouseRY()
                        if (rx > xMax or rx < xMin or ry > yMax or ry < yMin) then
                            whichFrame.prop("mouseEntering" .. key, NIL)
                            func({ triggerFrame = whichFrame, triggerPlayer = evtData.triggerPlayer })
                        end
                    end
                end)
            end
        end
    end
end

---@protected
---@param whichFrame Frame
---@param key string|nil
---@param evt string|nil
function view.clearFrameEvent(whichFrame)
    ---@type table<string,Array>
    local list = whichFrame.prop("evtList")
    if (list ~= nil) then
        local es = view._frameEventKeys
        for _, e in ipairs(es) do
            if (isArray(list[e])) then
                list[e].forEach(function(key)
                    list[e].set(key, nil)
                    view.registerFrameEvent(whichFrame, e, key)
                end, true)
            end
        end
        whichFrame:clear("evtList")
    end
end

---@protected
---@param whichFrame Frame
---@param key string|nil
---@param evt string|nil
function view.triggerFrameEvent(whichFrame, evt)
    if (whichFrame == nil) then
        return
    end
    if (whichFrame.isDestroy()) then
        return
    end
    ---@type table<string,Array>
    local list = whichFrame.prop("evtList")
    if (evt) then
        if (isArray(list[evt])) then
            list[evt].forEach(function(key)
                view.registerFrameEvent(whichFrame, evt, key)
            end)
        end
    else
        local es = view._frameEventKeys
        for _, e in ipairs(es) do
            if (isArray(list[e])) then
                list[e].forEach(function(key)
                    view.registerFrameEvent(whichFrame, e, key)
                end)
            end
        end
    end
    local child = whichFrame.children()
    if (isArray(child)) then
        child.forEach(function(_, c)
            view.triggerFrameEvent(c, evt)
        end)
    end
end