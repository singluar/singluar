local voice = {}
local voiceIdx = {}

---@class Vwp:Object
---@param sourceUnit Unit
---@param targetUnit Unit
---@return nil|Vwp
function Vwp(sourceUnit, targetUnit)
    if (not isObject(sourceUnit, "Unit") or not isObject(targetUnit, "Unit")) then
        return
    end
    local weaponSound = sourceUnit.weaponSound()
    if (weaponSound == nil) then
        return
    end
    local unitMaterial = targetUnit.material()
    if (unitMaterial == nil) then
        unitMaterial = "any"
    else
        unitMaterial = unitMaterial.value
    end
    local r = math.rand(1, 3)
    local alias = weaponSound .. "_" .. unitMaterial .. "_" .. r
    if (voice[alias] == nil) then
        alias = weaponSound .. "_any_" .. r
        if (voice[alias] == nil) then
            return
        end
    end
    local v = voice[alias][voiceIdx[alias]]
    voiceIdx[alias] = voiceIdx[alias] + 1
    if (voiceIdx[alias] >= #voice[alias]) then
        voiceIdx[alias] = 1
    end
    v.prop("targetUnit", targetUnit)
    return v
end

---@private
---@param alias string
---@return V3d
function VwpCreator(alias, duration)
    if (voice[alias] == nil) then
        voice[alias] = {}
        voiceIdx[alias] = 1
    end
    local new = Object("Vwp", {
        protect = true,
        alias = alias,
        duration = duration,
    })
    table.insert(voice[alias], new)
    return new
end