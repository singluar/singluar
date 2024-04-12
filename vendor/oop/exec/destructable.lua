---@type fun(this:Destructable,key:string,value:any)
local reset = function(this, key, value)
    local prev = this.prop(key)
    if (prev == nil) then
        return
    end
    local dataCur = {
        modelId = this.modelId(),
        x = this.x(),
        y = this.y(),
        z = this.z(),
        facing = this.facing(),
        scale = this.scale(),
        variation = this.variation(),
        isInvulnerable = J.IsDestructableInvulnerable(this.__HANDLE__)
    }
    if (key and value) then
        dataCur[key] = value
    end
    J.RemoveDestructable(this.__HANDLE__)
    href(this, J.CreateDestructableZ(dataCur.modelId, dataCur.x, dataCur.y, dataCur.z, dataCur.facing, dataCur.scale, dataCur.variation))
    if (dataCur.isInvulnerable) then
        J.SetDestructableInvulnerable(this.__HANDLE__, true)
    end
end

---@param this Destructable
---@param resultStr string
---@param resultNum number
Class("Destructable")
    .exec("modelAlias",
    function(this, resultStr)
        must(SINGLUAR_MODEL_D[resultStr] ~= nil, "modelAliasNotExist")
        local id = slk.n2i("　" .. resultStr .. "　")
        if (id == nil) then
            return
        end
        PropChange(this, "modelAlias", "std", resultStr, false)
        PropChange(this, "modelId", "std", c2i(id), false)
        reset(this)
    end)
    .exec("z",
    function(this, resultNum)
        reset(this, "z", resultNum)
    end)
    .exec("facing",
    function(this, resultNum)
        reset(this, "facing", resultNum)
    end)
    .exec("scale",
    function(this, resultNum)
        reset(this, "scale", resultNum)
    end)
    .exec("occluderHeight",
    function(this, resultNum)
        J.SetDestructableOccluderHeight(this.__HANDLE__, resultNum)
    end)
    .exec("hp",
    function(this, resultNum)
        ---@type Unit
        if (resultNum >= 1e9) then
            resultNum = 1e9
        elseif (resultNum < 1) then
            resultNum = 1
        end
        local hp = this.hp()
        if (type(hp) ~= "number") then
            this.hpCur(resultNum)
        elseif (hp >= 1) then
            local cur = this.hpCur() or resultNum
            local percent = math.trunc(cur / hp)
            local val = math.max(1, math.max(0, percent) * resultNum)
            this.hpCur(val)
        end
    end)
    .exec("hpCur",
    function(this, resultNum)
        J.SetDestructableLife(this.__HANDLE__, resultNum)
    end)