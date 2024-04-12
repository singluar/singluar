local voice = {}
local voiceIdx = {}

---@class Vcm:Object
---@param alias string
---@return nil|Vcm
function Vcm(alias)
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
---@return Vcm
function VcmCreator(alias, duration)
    if (voice[alias] == nil) then
        voice[alias] = {}
        voiceIdx[alias] = 1
    end
    local new = Object("Vcm", {
        protect = true,
        alias = alias,
        duration = duration,
    })
    table.insert(voice[alias], new)
    return new
end