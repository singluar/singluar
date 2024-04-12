---@param this Timer
Class("Timer")

    .private("kernel",
    function(this)
        local aid
        local asyncId = this.prop("asyncId")
        if (asyncId == 0) then
            aid = asyncId
        else
            aid = async.index
            must(aid == asyncId)
        end
        return time.kernel[aid]
    end)

    .public("remain",
    function(this, modify)
        local remain = this.prop("pause") or -1
        local l = this.prop("link") or 0
        if (remain == -1) then
            if (l > 0) then
                remain = (l - time.inc) / 100
            end
        end
        if (modify) then
            remain = math.cale(modify, remain)
            local kl = this.kernel()
            if (kl[l] ~= nil and kl[l].keyExists(this.id())) then
                kl[l].set(this.id(), nil)
                time.penetrate(this, math.min(this.prop("period"), math.max(0, remain)))
            end
            return this
        end
        return remain
    end)

    .public("period",
    function(this, modify)
        if (modify) then
            this.prop("period", modify)
            local l = this.prop("link")
            if (l > 0) then
                local p = this.prop("period")
                if (this.remain() > p) then
                    this.kernel()[l].set(this.id(), nil)
                    time.penetrate(this, p)
                end
            end
            return this
        end
        return this.prop("period") or -1
    end)

    .public("elapsed",
    function(this)
        return math.max(0, this.period() - this.remain())
    end)

    .public("pause",
    function(this)
        if (this.isDestroy() == false) then
            local l = this.prop("link")
            if (l > time.inc) then
                local kl = this.kernel()
                kl[l].set(this.id(), nil)
            end
            this.prop("pause", (l - time.inc) / 100)
            this.prop("link", NIL)
        end
        return this
    end)

    .public("resume",
    function(this)
        if (this.isDestroy() == false and this.prop("pause") ~= nil) then
            time.penetrate(this, this.prop("pause"))
            this.prop("pause", NIL)
        end
        return this
    end)