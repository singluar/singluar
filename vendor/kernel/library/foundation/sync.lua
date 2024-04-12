---@class sync
sync = sync or {}

sync._isInit = sync._isInit or nil
sync._callback = sync._callback or {}
sync._timer = sync._timer or {}
sync._queue = sync._queue or {}

--- 限制必须同步
function sync.must()
    must(async.index == 0, "syncCheck")
end

---@private
function sync.data(key, data)
    data = data or {}
    if (type(data) ~= "table") then
        data = {}
    end
    return string.implode("|", table.merge({ key }, data))
end
---@private
function sync.exec(syncKey, syncData, syncPlayer)
    if (type(sync._callback[syncKey]) ~= "function") then
        return
    end
    sync._callback[syncKey]({ syncPlayer = syncPlayer, syncKey = syncKey, transferData = syncData })
end

---@private
---@return boolean
function sync.query(aid)
    local ss = ""
    for q, _ in pairs(sync._queue[aid]) do
        if (ss == "") then
            ss = ss .. q
        else
            ss = ss .. "||" .. q
        end
        sync._queue[aid][q] = nil
        if (string.len(ss) > 512) then
            break
        end
    end
    local act = ss ~= ""
    if (act) then
        japi.DzSyncDataImmediately('ssync', ss)
    end
    return act
end

--- 发起同步,发送执行一般消息同步操作
--- 与onSync配套，this.onSync 接数据
---@param key string
---@param data table<number,any>
---@return number
function sync.send(key, data)
    if (key) then
        local aid = async.index
        if (Game().playingQuantityStart() > 1) then
            must(aid > 0)
            aid = tostring(aid)
            if (sync._queue[aid] == nil) then
                sync._queue[aid] = {}
            end
            if (sync._timer[aid] == nil) then
                sync.query(aid)
                sync._timer[aid] = time.setInterval(0.15, function(curTimer)
                    if (false == sync.query(aid)) then
                        curTimer.destroy()
                        sync._timer[aid] = nil
                    end
                end)
            end
            local sData = sync.data(key, data)
            sync._queue[aid][sData] = 0
        else
            async.index = 0
            sync.exec(key, data, Player1st())
            async.index = aid
        end
    end
end

--- 当收到同步操作
--- 与 send 配套
--- 此方法不能异步调用
---@alias noteOnHSync fun(syncData:{syncPlayer:Player,syncKey:"触发索引",transferData:"传输的数据"}):void
---@param key string
---@param callback noteOnHSync
---@return number
function sync.receive(key, callback)
    if (sync._isInit ~= true) then
        sync._isInit = true
        local tgr = J.CreateTrigger()
        J.handleRef(tgr)
        japi.DzTriggerRegisterSyncData(tgr, "ssync", false)
        J.TriggerAddAction(tgr, function()
            local pid = 1 + J.GetPlayerId(japi.DzGetTriggerSyncPlayer())
            for _, v in ipairs(string.explode("||", japi.DzGetTriggerSyncData())) do
                local trData = string.explode("|", v)
                local k = trData[1]
                table.remove(trData, 1)
                sync.exec(k, trData, Player(pid))
            end
        end)
    end
    if (key) then
        if (type(callback) == "function") then
            sync._callback[key] = callback
        else
            sync._callback[key] = nil
        end
    end
end