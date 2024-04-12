---@param this FrameTooltips
Class("FrameTooltips")
    .inherit("FrameCustom")
    .construct(
    function(_, options)
        options.fdfName = "SINGLUAR_BACKDROP_TOOLTIP"
        options.fdfType = "BACKDROP"
    end)
    .initial(
    function(this)
        group.push(this)
        this.adaptive(true)
            .relation(FRAME_ALIGN_CENTER, this.parent(), FRAME_ALIGN_CENTER, 0, 0)
            .size(0.1, 0.1)
            .show(false)

        local txt = FrameText(this.frameIndex() .. "->childText", this)
        txt.relation(FRAME_ALIGN_CENTER, this, FRAME_ALIGN_CENTER, 0, 0)
           .textAlign(TEXT_ALIGN_LEFT)
           .fontSize(10)
        this.prop("childTxt", txt)

        local ics = {}
        for i = 1, 6 do
            local tmp = {}
            tmp.bg = FrameBackdrop(this.frameIndex() .. "->icon->bg->" .. i, this)
                .size(0.013, 0.013)
                .show(false)
            tmp.txt = FrameText(this.frameIndex() .. "->icon->txt->" .. i, tmp.bg)
                .relation(FRAME_ALIGN_LEFT, tmp.bg, FRAME_ALIGN_RIGHT, 0.004, 0)
                .textAlign(TEXT_ALIGN_LEFT)
            table.insert(ics, tmp)
        end
        this.prop("childIcons", ics)

        local brs = {}
        for i = 1, 3 do
            local b = FrameBar(this.frameIndex() .. "->bar->" .. i, this).show(false)
            table.insert(brs, b)
        end
        this.prop("childBars", brs)

        --- 功能菜单
        local cl = FrameList(this.frameIndex() .. '->list', this, 5)
            .relation(FRAME_ALIGN_LEFT_BOTTOM, this, FRAME_ALIGN_LEFT_BOTTOM, 0, 0)
            .direction("horizontal")
            .show(false)
        this.prop("childList", cl)

        --- 显隐策略
        this.onMouseLeave(function() if (this.show() == true) then this.show(false) end end)
            .onMouseEnter(function() if (this.show() == true) then this.show(true) end end)
    end)
    .destroy(
    function(this)
        group.remove(this)
    end)