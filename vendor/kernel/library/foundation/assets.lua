local isDef = function(path)
    local i = string.find(path, ":")
    return i == 1
end

---@return string
function AUIKit(kit, path, suffix)
    if (kit ~= nil and path ~= nil) then
        if (string.subPos(path, "ReplaceableTextures\\") ~= 1
            and string.subPos(path, "Abilities\\") ~= 1
            and string.subPos(path, "units\\") ~= 1
            and string.subPos(path, "buildings\\") ~= 1
            and string.subPos(path, "war3map") ~= 1
            and string.subPos(path, "Singluar\\") ~= 1) then
            path = string.gsub(path, "/", "\\")
            path = "war3mapUI\\" .. kit .. "\\assets\\" .. path
            if (suffix) then
                path = path .. "." .. suffix
            end
        end
    end
    return path
end

---@return string
function AIcon(alias)
    if (alias ~= nil and SINGLUAR_ICON[alias]) then
        local path = SINGLUAR_ICON[alias]
        if (isDef(path)) then
            alias = string.sub(path, 2)
        else
            alias = string.gsub(alias, "/", "\\")
            alias = "war3mapIcon\\" .. alias
        end
        alias = alias .. ".tga"
    end
    return alias
end

---@return string
function AModel(alias)
    if (alias ~= nil and SINGLUAR_MODEL[alias]) then
        local path = SINGLUAR_MODEL[alias]
        if (isDef(path)) then
            alias = string.sub(path, 2)
        else
            alias = string.gsub(alias, "/", "\\")
            alias = "war3mapModel\\" .. alias
        end
        alias = alias .. ".mdl"
    end
    return alias
end

---@return string
function ABgm(alias)
    if (alias ~= nil and SINGLUAR_SOUND.bgm[alias]) then
        alias = string.gsub(alias, "/", "\\")
        alias = "resource\\war3mapSound\\bgm\\" .. alias .. ".mp3"
    end
    return alias
end

---@return string
function AVcm(alias)
    if (alias ~= nil and SINGLUAR_SOUND.vcm[alias]) then
        alias = string.gsub(alias, "/", "\\")
        alias = "resource\\war3mapSound\\vcm\\" .. alias .. ".mp3"
    end
    return alias
end

---@return string
function AV3d(alias)
    if (alias ~= nil and SINGLUAR_SOUND.v3d[alias]) then
        alias = string.gsub(alias, "/", "\\")
        alias = "resource\\war3mapSound\\v3d\\" .. alias .. ".mp3"
    end
    return alias
end

---@return string
function AVwp(alias)
    local a = string.explode("_", alias)
    local ag = {}
    for i = 1, (#a - 2), 1 do
        ag[#ag + 1] = a[i]
    end
    a = string.implode("_", ag)
    if (alias ~= nil and SINGLUAR_SOUND.vwp[a]) then
        alias = string.gsub(alias, "/", "\\")
        alias = "resource\\war3mapSound\\vwp\\" .. alias .. ".mp3"
    end
    return alias
end