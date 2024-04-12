---@param this FrameBar
Class("FrameBar")

    .public("childTexture",
    function(this, side)
        return this.prop("childTexture_" .. side)
    end)

    .public("childText",
    function(this, layout)
        return this.prop("childTxt_" .. layout)
    end)

    .public("value",
    function(this, ratio, width, height)
        local w
        local h
        if (width or height or ratio or w or h) then
            if (width and height) then
                this.size(width, height)
                w = width - this.prop("borderOffset")
                h = height - this.prop("borderOffset")
                this.childTexture("value").size(w, h)
            end
            if (ratio and w and h) then
                ratio = math.min(1, ratio)
                ratio = math.max(0, ratio)
                if (ratio <= 0) then
                    this.childTexture("value").show(false)
                    this.childTexture("mark").size(w, h).show(true)
                else
                    local wv = w * (1 - ratio)
                    this.childTexture("value").show(true)
                    this.childTexture("mark").size(wv, h).show(wv > 0)
                end
            end
            return this
        end
        return this.prop("valueRatio") or 0
    end)

    .public("texture",
    function(this, side, modify)
        if (side == nil) then
            return this
        end
        if (side and modify) then
            this.childTexture(side).texture(modify)
            return this
        end
        return this.childTexture(side).texture()
    end)

    .public("textAlign",
    function(this, layout, modify)
        if (layout == nil) then
            return this
        end
        if (layout and modify) then
            this.childText(layout).textAlign(modify)
            return this
        end
        return this.childText(layout).textAlign()
    end)

    .public("fontSize",
    function(this, layout, modify)
        if (layout == nil) then
            return this
        end
        if (layout and modify) then
            this.childText(layout).fontSize(modify)
            return this
        end
        return this.childText(layout).fontSize()
    end)

    .public("text",
    function(this, layout, modify)
        if (layout == nil) then
            return this
        end
        if (layout and modify) then
            this.childText(layout).text(modify)
            return this
        end
        return this.childText(layout).text()
    end)
