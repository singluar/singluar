local voice = {}
local voiceIdx = {}

---@class V3d:Object
---@param alias string
---@return nil|V3d
function V3d(alias)
    if (voice[alias] == nil) then
        return
    end
    local v = voice[alias][voiceIdx[alias]]
    voiceIdx[alias] = voiceIdx[alias] + 1
    if (voiceIdx[alias] >= #voice[alias]) then
        voiceIdx[alias] = 1
    end
    return v
end

---@private
---@param alias string
---@return V3d
function V3dCreator(alias, duration)
    if (voice[alias] == nil) then
        voice[alias] = {}
        voiceIdx[alias] = 1
    end
    local new = Object("V3d", {
        protect = true,
        alias = alias,
        duration = duration,
    })
    table.insert(voice[alias], new)
    return new
end