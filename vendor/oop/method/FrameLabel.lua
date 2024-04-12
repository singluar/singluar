Class("FrameLabel")

    .public("autoSize",
    function(this, modify)
        return this.prop("autoSize", modify)
    end)

    .public("size",
    function(this, w, h)
        if (w ~= nil and h ~= nil) then
            if (this.autoSize() == true) then
                local tw = mbstring.viewWidth(this.childLabel().text(), this.childLabel().fontSize())
                if (tw <= 0) then
                    w = 0.03
                else
                    w = tw + h + 0.002
                end
            end
            CLink(this, "Frame", "size", w, h)
            local iw = h
            if (this.adaptive() ~= true) then
                iw = iw * 0.75
            end
            this.childHighLight().size(w, h)
            this.childIcon().size(iw, h)
            this.childLabel().size(w - iw - 0.001, h)
            return this
        end
        return CLink(this, "Frame", "size")
    end)

    .public("childHighLight",
    function(this)
        return this.prop("childHighLight")
    end)

    .public("childIcon",
    function(this)
        return this.prop("childIcon")
    end)

    .public("childLabel",
    function(this)
        return this.prop("childLabel")
    end)

    .public("side",
    function(this, modify)
        if (modify ~= nil) then
            if (modify == LAYOUT_ALIGN_RIGHT) then
                local ct = this.childIcon()
                ct.relation(FRAME_ALIGN_RIGHT_TOP, this, FRAME_ALIGN_RIGHT_TOP, 0, 0)
                this.childLabel().relation(FRAME_ALIGN_RIGHT, ct, FRAME_ALIGN_LEFT, -0.001, 0)
            else
                modify = LAYOUT_ALIGN_LEFT
                local ct = this.childIcon()
                ct.relation(FRAME_ALIGN_LEFT_TOP, this, FRAME_ALIGN_LEFT_TOP, 0, 0)
                this.childLabel().relation(FRAME_ALIGN_LEFT, ct, FRAME_ALIGN_RIGHT, 0.001, 0)
            end
            local _, updated = PROP(this, "side", modify)
            if (updated) then
                local s = this.prop("unAdaptiveSize")
                if (s ~= nil) then
                    this.size(s[1], s[2])
                end
            end
            return this
        end
        return this.prop("side")
    end)

    .public("texture",
    function(this, modify)
        return this.prop("texture", modify)
    end)

    .public("icon",
    function(this, modify)
        if (modify) then
            this.childIcon().texture(modify)
            return this
        end
        return this.childIcon().texture()
    end)

    .public("textAlign",
    function(this, modify)
        if (modify ~= nil) then
            this.childLabel().textAlign(modify)
            return this
        end
        return this.childLabel().textAlign()
    end)

    .public("fontSize",
    function(this, modify)
        if (modify ~= nil) then
            this.childLabel().fontSize(modify)
            return this
        end
        return this.childLabel().fontSize()
    end)

    .public("text",
    function(this, modify)
        if (modify ~= nil) then
            local _, updated = PROP(this.childLabel(), "text", modify)
            if (updated) then
                local s = this.prop("unAdaptiveSize")
                if (s ~= nil) then
                    this.size(s[1], s[2])
                end
            end
            return this
        end
        return this.childLabel().text()
    end)
