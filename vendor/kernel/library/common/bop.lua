---@param obj Object
---@param objectName string
---@return boolean
function isObject(obj, objectName)
    if (obj == nil or objectName == nil) then
        return false
    end
    if (type(obj) ~= "table") then
        return false
    end
    return obj.__NAME__ == objectName
end

---@param obj Object
---@param objectName string
---@return boolean
function instanceof(obj, objectName)
    local is = isObject(obj, objectName)
    if (is) then
        return is
    end
    local c = Class(obj)
    while (c ~= nil and c.inherit() ~= nil) do
        if (c.inherit() == objectName) then
            is = true
            break
        else
            c = Class(c.inherit())
        end
    end
    return is
end

---@param id string
---@return Object|nil
function i2o(id)
    if (id == nil) then
        return nil
    end
    return bop.i2o[id]
end

---@param this Object
---@param handle number
---@return void
function href(this, handle)
    if (this.__ID__ ~= nil) then
        local un = function()
            if (this.__HANDLE__ ~= nil) then
                if (this.__NAME__ == "Unit") then
                    J.RemoveUnit(this.__HANDLE__)
                elseif (this.__NAME__ == "Item") then
                    J.RemoveUnit(this.__HANDLE__)
                elseif (this.__NAME__ == "Player") then
                    J.RemovePlayer(this.__HANDLE__, PLAYER_GAME_RESULT_DEFEAT)
                elseif (this.__NAME__ == "Destructable") then
                    J.SetDestructableInvulnerable(this.__HANDLE__, true)
                    J.RemoveDestructable(this.__HANDLE__)
                elseif (this.__NAME__ == "Dialog") then
                    ---@type Array
                    local buttons = this.prop("buttons")
                    local keys = buttons.keys()
                    if (#keys > 0) then
                        for _, k in ipairs(keys) do
                            J.handleUnRef(k)
                        end
                    end
                    buttons = nil
                    J.DialogClear(this.__HANDLE__)
                    J.DialogDestroy(this.__HANDLE__)
                elseif (this.__NAME__ == "Quest") then
                    J.DestroyQuest(this.__HANDLE__)
                elseif (this.__NAME__ == "Rect") then
                    J.RemoveRect(this.__HANDLE__)
                end
                J.handleUnRef(this.__HANDLE__)
                bop.h2o[this.__HANDLE__] = nil
                this.__HANDLE__ = nil
            end
        end
        if (handle ~= nil and handle > 0) then
            un()
            J.handleRef(handle)
            this.__HANDLE__ = handle
            bop.h2o[this.__HANDLE__] = this
        else
            un()
        end
    end
end

---@param handle number
---@return Player|nil
function h2p(handle)
    return bop.h2o[handle]
end

---@param handle number
---@return Unit|nil
function h2u(handle)
    return bop.h2o[handle]
end

---@param handle number
---@return Item|nil
function h2i(handle)
    return bop.h2o[handle]
end

---@param handle number
---@return Dialog|nil
function h2d(handle)
    return bop.h2o[handle]
end