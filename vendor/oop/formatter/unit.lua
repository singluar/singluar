---@param value number
Class("Unit")
    .formatter("levelMax", function(value) return math.floor(value) end)
    .formatter("level", function(value) return math.floor(value) end)