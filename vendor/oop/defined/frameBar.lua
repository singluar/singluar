---@param this FrameBar
Class("FrameBar")
    .inherit("FrameCustom")
    .construct(
    function(this, options)
        options.fdfName = options.fdfName or "SINGLUAR_BACKDROP"
        options.fdfType = "BACKDROP"
        options.borderOffset = options.borderOffset or 0
        PropChange(this, "borderOffset", "std", options.borderOffset, false)
    end)
    .initial(
    function(this)
        local fdfName = this.fdfName()
        if (fdfName == "SINGLUAR_BACKDROP") then
            japi.DzFrameSetTexture(this.__FRAME_ID__, "Singluar\\ui\\nil.tga", false)
        end
        --- 上下条层
        local t_value = FrameBackdrop(this.frameIndex() .. "->texture->value", this)
            .relation(FRAME_ALIGN_CENTER, this, FRAME_ALIGN_CENTER, 0, 0)
            .texture(TEAM_COLOR_BLP_BLUE)
        local t_mark = FrameBackdropTile(this.frameIndex() .. "->texture->mark", this)
            .relation(FRAME_ALIGN_RIGHT, t_value, FRAME_ALIGN_RIGHT, 0, 0)
            .texture(TEAM_COLOR_BLP_BLACK)
        this.prop("childTexture_value", t_value)
        this.prop("childTexture_mark", t_mark)
        --- 9方文本
        for i = 1, 9 do
            local txt = FrameText(this.frameIndex() .. "->childText->" .. i, this)
            txt.fontSize(10)
            if (i == LAYOUT_ALIGN_LEFT_TOP) then
                txt.textAlign(TEXT_ALIGN_LEFT).relation(FRAME_ALIGN_LEFT_BOTTOM, this, FRAME_ALIGN_LEFT_TOP, 0, 0.001)
            elseif (i == LAYOUT_ALIGN_TOP) then
                txt.textAlign(TEXT_ALIGN_CENTER).relation(FRAME_ALIGN_BOTTOM, this, FRAME_ALIGN_TOP, 0, 0.001)
            elseif (i == LAYOUT_ALIGN_RIGHT_TOP) then
                txt.textAlign(TEXT_ALIGN_RIGHT).relation(FRAME_ALIGN_RIGHT_BOTTOM, this, FRAME_ALIGN_RIGHT_TOP, 0, 0.001)

            elseif (i == LAYOUT_ALIGN_LEFT) then
                txt.textAlign(TEXT_ALIGN_LEFT).relation(FRAME_ALIGN_LEFT, this, FRAME_ALIGN_LEFT, 0, 0)
            elseif (i == LAYOUT_ALIGN_CENTER) then
                txt.textAlign(TEXT_ALIGN_CENTER).relation(FRAME_ALIGN_CENTER, this, FRAME_ALIGN_CENTER, 0, 0)
            elseif (i == LAYOUT_ALIGN_RIGHT) then
                txt.textAlign(TEXT_ALIGN_RIGHT).relation(FRAME_ALIGN_RIGHT, this, FRAME_ALIGN_RIGHT, 0, 0)

            elseif (i == LAYOUT_ALIGN_LEFT_BOTTOM) then
                txt.textAlign(TEXT_ALIGN_LEFT).relation(FRAME_ALIGN_LEFT_TOP, this, FRAME_ALIGN_LEFT_BOTTOM, 0, -0.001)
            elseif (i == LAYOUT_ALIGN_BOTTOM) then
                txt.textAlign(TEXT_ALIGN_CENTER).relation(FRAME_ALIGN_TOP, this, FRAME_ALIGN_BOTTOM, 0, -0.001)
            elseif (i == LAYOUT_ALIGN_RIGHT_BOTTOM) then
                txt.textAlign(TEXT_ALIGN_RIGHT).relation(FRAME_ALIGN_RIGHT_TOP, this, FRAME_ALIGN_RIGHT_BOTTOM, 0, -0.001)
            end
            this.prop("childTxt_" .. i, txt)
        end
    end)