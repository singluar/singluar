---@class async
async = async or {}

---@private
async.index = async.index or 0

---@private
async.randPool = async.randPool or { i = {}, d = {} }

--- 限制必须异步
function async.must()
    must(async.index > 0, "asyncCheck")
end

--- 异步调用，使用此方法后回调强制异步
---@param asyncPlayer Player
---@param callFunc function
function async.call(asyncPlayer, callFunc)
    if (asyncPlayer.handle() == JassCommon["GetLocalPlayer"]()) then
        local asyncId = async.index
        async.index = asyncPlayer.index() -- 异步的
        callFunc()
        async.index = asyncId -- 异步的
    end
end

--- 异步随机
--- 此方法只能写于异步区
--- 当范围数据池未重新打包建立时只会返回固定值
---@param min number
---@param max number
---@return number integer
function async.rand(min, max)
    min = math.ceil(min)
    max = math.ceil(max)
    if (min == max or async.index <= 0) then
        return min
    end
    if (min > max) then
        min, max = max, min
    end
    local m = min .. '_' .. max
    local d = async.randPool.d[async.index][m]
    if (d == nil) then
        return min
    end
    local i = async.randPool.i[async.index][m]
    if (i >= #d) then
        i = 0
    end
    i = i + 1
    async.randPool.i[async.index][m] = i
    return d[i]
end