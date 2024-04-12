---@private
_SET_UNIT = function(_v)
    _v._class = "unit"
    if (_v._parent == nil) then
        _v._parent = "hpea"
    end
    return _v
end

---@private
_SET_ABILITY = function(_v)
    _v._class = "ability"
    if (_v._parent == nil) then
        _v._parent = "ANcl"
    end
    return _v
end

---@private
_SET_DESTRUCTABLE = function(_v)
    _v._class = "destructable"
    if (_v._parent == nil) then
        _v._parent = "BTsc"
    end
    return _v
end
