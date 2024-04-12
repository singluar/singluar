bop = bop or {}

bop.oid = bop.oid or {}
bop.static = bop.static or {}
bop.h2o = bop.h2o or {}
bop.i2o = bop.i2o or setmetatable({}, { __mode = "v" })

---@param prefix string
---@return string
function bopID(prefix)
    prefix = prefix or '_'
    if (bop.oid[prefix] == nil) then
        bop.oid[prefix] = {}
    end
    local aid = async.index
    if (bop.oid[prefix][aid] == nil) then
        bop.oid[prefix][aid] = 0
    end
    bop.oid[prefix][aid] = bop.oid[prefix][aid] + 1
    return string.format('%s:%s:%s', prefix, time.inc or '?', bop.oid[prefix][aid])
end