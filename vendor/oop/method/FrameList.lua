---@param this FrameList
Class("FrameList")

    .public("show",
    function(this, modify)
        if (type(modify) == "boolean") then
            for _, t in ipairs(this.childTexts()) do
                local sgOpt = t.prop("showGradient")
                if (type(sgOpt) == "table") then
                    t.showGradient(modify, sgOpt)
                else
                    t.show(modify)
                end
            end
            return CLink(this, "Frame", "show", modify)
        end
        return CLink(this, "Frame", "show")
    end)

    .public("childTexts",
    function(this, index)
        local ct = this.prop("childTexts")
        if (type(index) == "number") then
            return ct[index]
        end
        return ct
    end)

    .public("childButtons",
    function(this, index)
        local cb = this.prop("childButtons")
        if (type(index) == "number") then
            return cb[index]
        end
        return cb
    end)

    .public("max",
    function(this)
        return this.prop("max")
    end)

    .public("direction",
    function(this, modify)
        return this.prop("direction", modify)
    end)

    .public("fontSize",
    function(this, modify)
        if (modify ~= nil) then
            for _, t in ipairs(this.childTexts()) do
                t.fontSize(modify)
            end
            this.prop("fontSize", modify)
            return this
        end
        return this.prop("fontSize")
    end)

    .public("onMouseLeftClick",
    function(this, ...)
        local key, func = datum.keyFunc(...)
        for i, b in ipairs(this.childButtons()) do
            if (type(func) == "function") then
                b.onMouseLeftClick(key, function(evtData)
                    evtData.key = b.prop("key") or i
                    func(evtData)
                end)
            else
                b.onMouseLeftClick(key, nil)
            end
        end
        return this
    end)

    .public("onMouseEnter",
    function(this, ...)
        local key, func = datum.keyFunc(...)
        for i, b in ipairs(this.childButtons()) do
            if (type(func) == "function") then
                b:onMouseEnter(key, function(evtData)
                    evtData.key = b.prop("key") or i
                    func(evtData)
                end)
            else
                b.onMouseEnter(key, nil)
            end
        end
        return this
    end)

    .public("onMouseLeave",
    function(this, ...)
        local key, func = datum.keyFunc(...)
        for i, b in ipairs(this.childButtons()) do
            if (type(func) == "function") then
                b:onMouseLeave(key, function(evtData)
                    evtData.key = b.prop("key") or i
                    func(evtData)
                end)
            else
                b.onMouseLeave(key, nil)
            end
        end
        return this
    end)

    .public("content",
    function(this, data)
        if (type(data) ~= "table") then
            return
        end
        local _max = this.max()
        local fs = this.fontSize()
        local lineWidth = 0
        local lineHeight = mbstring.viewHeight(1, fs)
        local tr = {}
        local mi = 0
        for i = 1, _max, 1 do
            tr[i] = ''
            if (data[i] ~= nil and type(data[i].text) == "string" and data[i].text ~= '') then
                mi = mi + 1
                tr[i] = data[i].text
                local vw = mbstring.viewWidth(tr[i], fs)
                if (vw > lineWidth) then
                    lineWidth = vw
                end
            end
        end
        local dct = this.direction()
        if (dct == "horizontal") then
            this.size(lineWidth * mi, lineHeight)
        else
            this.size(lineWidth, lineHeight * _max)
        end
        for i = 1, _max, 1 do
            local txt = this.childTexts(i)
            local btn = this.childButtons(i)
            if (data[i] == nil) then
                txt.text("")
                btn.show(false)
            else
                if (data[i].showGradient ~= nil) then
                    txt.prop("showGradient", data[i].showGradient)
                else
                    txt.prop("showGradient", NIL)
                end
                if (data[i].key ~= nil) then
                    btn.prop("key", data[i].key)
                else
                    btn.prop("key", NIL)
                end
                if (type(data[i].texture) == "string") then
                    btn.texture(data[i].texture)
                else
                    btn.texture("Singluar\\ui\\nil.tga")
                end
                if (type(data[i].textAlign) == "number") then
                    txt.textAlign(data[i].textAlign)
                end
                txt.text(tr[i])
                txt.size(lineWidth, lineHeight)
                if (dct == "horizontal") then
                    txt.relation(FRAME_ALIGN_LEFT, this, FRAME_ALIGN_LEFT, lineWidth * (i - 1), 0)
                else
                    txt.relation(FRAME_ALIGN_TOP, this, FRAME_ALIGN_TOP, 0, -lineHeight * (i - 1))
                end
                btn.size(lineWidth, lineHeight)
                btn.show(true)
            end
        end
        return this
    end)