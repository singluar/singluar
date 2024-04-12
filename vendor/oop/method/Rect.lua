---@param this Rect
Class("Rect")

    .public("handle",
    function(this)
        local h = this.__HANDLE__
        if (h == nil) then
            h = J.Rect(this.xMin(), this.yMin(), this.xMax(), this.yMax())
            href(this, h)
        end
        return h
    end)

    .public("isInside",
    function(this, ix, iy)
        if (this.prop("shape") == "square") then
            return (ix < this.xMax() and ix > this.xMin() and iy < this.yMax() and iy > this.yMin())
        elseif (this.prop("shape") == "round") then
            return 1 >= (((this.x() - ix) ^ 2) / ((this.width()) ^ 2) + ((this.y() - iy) ^ 2) / ((this.height() / 2) ^ 2))
        end
        return false
    end)

    .public("isBorder",
    function(this, ix, iy)
        if (this.prop("shape") == "square") then
            return ix >= this.xMax() or ix <= this.xMin() or iy >= this.yMax() or iy <= this.yMin()
        elseif (this.prop("shape") == "round") then
            return 1 < (((this.x() - ix) ^ 2) / ((this.width()) ^ 2) + ((this.y() - iy) ^ 2) / ((this.height() / 2) ^ 2))
        end
        return false
    end)
--
    .public("xMin",
    function(this)
        return this.prop("xMin")
    end)
    .public("yMin",
    function(this)
        return this.prop("yMin")
    end)
    .public("xMax",
    function(this)
        return this.prop("xMax")
    end)
    .public("yMax",
    function(this)
        return this.prop("yMax")
    end)

    .public("name",
    function(this, modify)
        return this.prop("name", modify)
    end)

    .public("shape",
    function(this, modify)
        return this.prop("shape", modify)
    end)

    .public("x",
    function(this, modify)
        local res = this.prop("x", modify)
        this.reset()
        return res
    end)

    .public("y",
    function(this, modify)
        local res = this.prop("y", modify)
        this.reset()
        return res
    end)

    .public("width",
    function(this, modify)
        local res = this.prop("width", modify)
        this.reset()
        return res
    end)

    .public("height",
    function(this, modify)
        local res = this.prop("height", modify)
        this.reset()
        return res
    end)

    .public("weather",
    function(this, weatherType, status)
        must(type(status) == "boolean")
        ---@type Weather[]
        local ws = this.prop("weathers")
        if (ws == nil) then
            if (status == false) then
                return
            end
            ws = {}
            this.prop("weathers", ws)
        end
        if (status) then
            must(type(weatherType) == "table")
            local w = Weather(this, weatherType)
            w.enable(true)
            table.insert(ws, w)
            return w
        else
            if (#ws > 0) then
                for i = #ws, 1, -1 do
                    local wv = ws[i]
                    if (weatherType == nil) then
                        table.remove(ws, i)
                        wv.destroy()
                    elseif (weatherType == wv.weatherType()) then
                        table.remove(ws, i)
                        wv.destroy()
                        break
                    end
                end
            end
            return this
        end
    end)