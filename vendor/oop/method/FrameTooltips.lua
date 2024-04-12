---@param this FrameTooltips
Class("FrameTooltips")

    .public("kit",
    function(this, modify)
        return this.prop("kit", modify)
    end)

    .public("childText",
    function(this)
        return this.prop("childTxt")
    end)

    .public("childIcons",
    function(this)
        return this.prop("childIcons")
    end)

    .public("childBars",
    function(this)
        return this.prop("childBars")
    end)

    .public("childList",
    function(this)
        return this.prop("childList")
    end)

    .public("textAlign",
    function(this, align)
        this.childText().textAlign(align)
        return this
    end)

    .public("fontSize",
    function(this, fontSize)
        this.childText().fontSize(fontSize)
        return this
    end)

    .public("onMouseLeftClick",
    function(this, ...)
        this.childList().onMouseLeftClick(...)
        return this
    end)

    .public("content",
    function(this, data)
        if (type(data) == "string") then
            data = { tips = data }
        end
        local icons = data.icons
        local bars = data.bars
        local list = data.list
        local tips = data.tips
        local fs = this.childText().fontSize()
        if (type(tips) == "string") then
            tips = string.explode("|n", tips)
        end
        ---@type table<number,{bg:FrameBackdrop,txt:FrameText}>
        local childIcons = this.childIcons()
        ---@type FrameBar[]
        local childBars = this.childBars()
        ---@type FrameList
        local childList = this.childList()

        local kit = this.kit()

        local temp = {}
        local w = 0
        local xEx = 0
        local paddingX = 0.012
        local paddingY = 0.008
        if (type(icons) == "table" and #icons > 0) then
            -- 当有顶部图标时，tooltips自动调节为左对齐
            japi.DzFrameSetTextAlignment(this.childText().handle(), TEXT_ALIGN_LEFT)
            this.childText().relation(FRAME_ALIGN_CENTER, this, FRAME_ALIGN_CENTER, paddingX, 0)
            xEx = xEx + paddingX
            --
            table.insert(temp, '')
            table.insert(temp, '')
        elseif (type(tips) == "table" and #tips == 1) then
            -- 当只有一行文本时，tooltips自动调节为居中
            japi.DzFrameSetTextAlignment(this.childText().handle(), TEXT_ALIGN_CENTER)
            this.childText().relation(FRAME_ALIGN_CENTER, this, FRAME_ALIGN_CENTER, 0, 0)
        else
            -- 多行文本时，tooltips以代码为标准
            local ag = this.childText().textAlign()
            japi.DzFrameSetTextAlignment(this.childText().handle(), ag)
            local ox = 0
            local oy = 0
            if (ag == TEXT_ALIGN_LEFT_TOP or ag == TEXT_ALIGN_LEFT or ag == TEXT_ALIGN_LEFT_BOTTOM) then
                ox = paddingX
                xEx = xEx + paddingX
            end
            if (ag == TEXT_ALIGN_RIGHT_TOP or ag == TEXT_ALIGN_RIGHT or ag == TEXT_ALIGN_RIGHT_BOTTOM) then
                ox = -paddingX
            end
            if (ag == TEXT_ALIGN_LEFT_TOP or ag == TEXT_ALIGN_TOP or ag == TEXT_ALIGN_RIGHT_TOP) then
                oy = -paddingY
            end
            if (ag == TEXT_ALIGN_LEFT_BOTTOM or ag == TEXT_ALIGN_BOTTOM or ag == TEXT_ALIGN_RIGHT_BOTTOM) then
                oy = paddingY
            end
            this.childText().relation(FRAME_ALIGN_CENTER, this, FRAME_ALIGN_CENTER, ox, oy)
        end
        local wic = 0
        for i = 1, #childIcons, 1 do
            if (type(icons) ~= "table" or icons[i] == nil) then
                childIcons[i].bg.show(false)
            else
                if (i <= 1) then
                    childIcons[i].bg.relation(FRAME_ALIGN_LEFT_TOP, this, FRAME_ALIGN_LEFT_TOP, xEx, -mbstring.viewHeight(1.2, fs))
                else
                    childIcons[i].bg.relation(FRAME_ALIGN_LEFT, childIcons[i - 1].txt, FRAME_ALIGN_RIGHT, 0.01, 0)
                end
                childIcons[i].txt.text(icons[i].text).fontSize(fs - 1)
                childIcons[i].bg.texture(AUIKit(kit, icons[i].texture, "tga"))
                childIcons[i].bg.show(true)
                -- 宽高计算
                wic = wic + paddingX + 0.01 + mbstring.viewWidth(icons[i].text, fs)
            end
        end
        w = math.max(w, wic)
        for i = 1, #childBars, 1 do
            if (type(bars) ~= "table" or bars[i] == nil) then
                childBars[i].show(false)
            else
                if (i <= 1) then
                    if (type(icons) == "table" and icons[1] ~= nil) then
                        childBars[i].relation(FRAME_ALIGN_LEFT_TOP, childIcons[1].bg, FRAME_ALIGN_LEFT_BOTTOM, 0.001, -mbstring.viewHeight(2.4 - 0.6, fs))
                    else
                        childBars[i].relation(FRAME_ALIGN_LEFT_TOP, this, FRAME_ALIGN_LEFT_TOP, xEx, -mbstring.viewHeight(2.4, fs))
                    end
                else
                    childBars[i].relation(FRAME_ALIGN_LEFT_TOP, childBars[i - 1], FRAME_ALIGN_LEFT_BOTTOM, 0, -mbstring.viewHeight(1.8, fs))
                end
                childBars[i].text(LAYOUT_ALIGN_LEFT_TOP, bars[i].text)
                childBars[i].fontSize(LAYOUT_ALIGN_LEFT_TOP, fs - 1)
                childBars[i].texture("value", AUIKit(kit, bars[i].texture, "tga"))
                childBars[i].value(bars[i].ratio, bars[i].width, bars[i].height)
                childBars[i].show(true)
                -- 宽高计算
                table.insert(temp, '')
                table.insert(temp, '')
                w = math.max(w, bars[i].width or 0)
            end
        end
        if (type(tips) == "table" and #tips > 0) then
            for _, s in ipairs(tips) do
                local vw = mbstring.viewWidth(s, fs)
                if (vw > w) then
                    w = vw
                end
                table.insert(temp, s)
            end
        end
        if (type(list) ~= "table" or #list <= 0) then
            childList.show(false)
        else
            for _, l in ipairs(list) do
                l.texture = AUIKit(kit, l.texture, "tga")
            end
            childList
                .relation(FRAME_ALIGN_LEFT_BOTTOM, this, FRAME_ALIGN_LEFT_BOTTOM, xEx, paddingY * 1.4)
                .fontSize(fs - 1)
                .content(list)
                .show(true)
            -- 宽高计算
            table.insert(temp, '')
            table.insert(temp, '')
            table.insert(temp, '')
            local lSize = childList.prop("unAdaptiveSize")
            w = math.max(w, lSize[1] or 0)
        end
        local h = mbstring.viewHeight(#temp, fs)
        w = paddingX * 2 + w
        h = paddingY * 2 + h
        this.size(w, h)
        this.childText()
            .size(w, h)
            .text(string.implode("|n", temp))
        return this
    end)
