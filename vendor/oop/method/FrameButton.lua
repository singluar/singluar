---@param this FrameButton
Class("FrameButton")

    .public("size",
    function(this, w, h)
        if (w ~= nil and h ~= nil) then
            CLink(this, "Frame", "size", w, h)
            this.childHighLight().size(w, h)
            this.childBorder().size(w, h)
            this.maskValue(this.maskValue())
        end
        return CLink(this, "Frame", "size", w, h)
    end)

    .public("texture",
    function(this, modify)
        if (modify) then
            modify = AUIKit(this.kit(), modify, "tga")
        end
        return this.prop("texture", modify)
    end)

    .public("childHighLight",
    function(this)
        return this.prop("childHighLight")
    end)

    .public("childBorder",
    function(this)
        return this.prop("childBorder")
    end)

    .public("childMask",
    function(this)
        return this.prop("childMask")
    end)

    .public("childText",
    function(this)
        return this.prop("childText")
    end)

    .public("childHotkey",
    function(this)
        return this.prop("childHotkey")
    end)

    .public("border",
    function(this, modify)
        if (modify ~= nil) then
            this.childBorder().texture(modify)
            return this
        end
        return this.childBorder().texture()
    end)

    .public("mask",
    function(this, modify)
        if (modify ~= nil) then
            this.childMask().texture(modify)
            return this
        end
        return this.childMask().texture()
    end)

    .public("maskValue",
    function(this, modify)
        local s
        if (modify ~= nil) then
            s = this.prop("unAdaptiveSize")
            if (modify <= 0) then
                this.childMask().show(false)
            elseif (s ~= nil) then
                this.childMask().size(s[1], s[2] * modify).show(true)
            end
            return this
        end
        s = this.childMask().prop("unAdaptiveSize")
        if (s == nil) then
            return 0
        end
        return s[2] or 0
    end)

    .public("text",
    function(this, modify)
        if (modify ~= nil) then
            this.childText().text(modify)
            return this
        end
        return this.childText().text()
    end)

    .public("fontSize",
    function(this, modify)
        if (modify ~= nil) then
            this.childText().fontSize(modify)
            return this
        end
        return this.childText().fontSize()
    end)

    .public("hotkey",
    function(this, modify)
        if (modify ~= nil) then
            this.childHotkey().text(modify)
            return this
        end
        return this.childHotkey().text()
    end)

    .public("hotkeyFontSize",
    function(this, modify)
        if (modify ~= nil) then
            this.childHotkey().fontSize(modify)
            return this
        end
        return this.childHotkey().fontSize()
    end)