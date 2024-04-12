---@param value number
Class("Ability")
    .formatter("levelMax", function(value) return math.floor(value) end)
    .formatter("levelUpNeedPoint", function(value) return math.floor(value) end)
    .formatter("level", function(value) return math.floor(value) end)