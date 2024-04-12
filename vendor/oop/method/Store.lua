---@param this Store
Class("Store")

    .public("name",
    function(this, modify)
        return this.prop("name", modify)
    end)

    .public("icon",
    function(this, modify)
        return this.prop("icon", modify)
    end)

    .public("salesPlayers",
    function(this, modify)
        if (modify ~= nil) then
            if (type(modify) ~= "table") then
                return this
            end
            this.prop("salesPlayers", modify)
        end
        return this.prop("salesPlayers")
    end)

    .public("salesGoods",
    function(this)
        return this.prop("salesGoods")
    end)

    .public("forEach",
    function(this, actionFunc)
        local goods = this.salesGoods()
        goods.forEach(function(key, value)
            promise(actionFunc, nil, nil, key, value)
        end)
    end)


    .public("push",
    function(this, goods, worth, stock, period, delay)
        local id = goods.id()
        if (worth == nil and isObject(goods, "ItemTpl")) then
            worth = goods.worth()
        end
        stock = math.floor(stock or 0)
        if (worth == nil or stock < 1) then
            return
        end
        period = period or 0
        delay = delay or 0
        ---@type Array
        local salesGoods = this.prop("salesGoods")
        salesGoods.set(id, {
            goods = goods,
            worth = worth,
            qty = stock,
            stock = stock,
            period = period,
            delay = delay,
        })
    end)

    .public("remove",
    function(this, goods)
        local id = goods.id()
        ---@type Array
        local salesGoods = this.prop("salesGoods")
        salesGoods.set(id, nil)
    end)

    .public("qty",
    function(this, goods, variety)
        local id = goods.id()
        ---@type Array
        local salesGoods = this.prop("salesGoods")
        local data = salesGoods.get(id)
        if (data ~= nil) then
            data.qty = math.cale(variety, data.qty)
            salesGoods.set(id, data)
            -- 只有自动补货需要补数量
            if (data.periodTimer == nil) then
                if (data.qty < data.stock and data.period > 0) then
                    data.periodTimer = time.setInterval(data.period, function(curTimer)
                        if (data.qty >= data.stock) then
                            curTimer.destroy()
                            data.periodTimer = nil
                            return
                        end
                        data.qty = data.qty + 1
                    end)
                end
            end
        end
    end)


    .public("sell",
    function(this, goods, qty, buyUnit)
        qty = math.floor(qty or 1)
        must(qty >= 1)
        must(isObject(buyUnit, "Unit"))
        local id = goods.id()
        ---@type Array
        local salesGoods = this.prop("salesGoods")
        local data = salesGoods.get(id)
        if (data == nil) then
            return
        end
        if (data.qty < qty) then
            buyUnit.owner().alert("可售数量不足", true)
            return
        end
        if (data.worth ~= nil) then
            if (Game().worthCompare(buyUnit.owner().worth(), data.worth) ~= true) then
                buyUnit.owner().alert("财力不足", true)
                return
            end
            -- 只有无限供应和自动补货需要扣数量
            if (data.period ~= 0) then
                this.qty("-=" .. qty)
            end
            buyUnit.owner().worth(data.worth, true)
        end
        event.trigger(this, EVENT.Store.Sell, { triggerStore = this, triggerUnit = buyUnit, qty = qty })
    end)