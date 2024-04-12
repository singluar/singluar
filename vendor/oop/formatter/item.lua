---@param value number
Class("Item")
    .formatter("levelMax", function(value) return math.floor(value) end)
    .formatter("level", function(value) return math.floor(value) end)