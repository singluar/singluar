--- 地形
terrain = terrain or {}

--- 获取x，y坐标的地形地表贴图类型
---@see variable TERRAIN_?
---@param x number
---@param y number
---@return boolean
terrain.type = function(x, y)
    return J.GetTerrainType(x, y)
end

--- 是否某类型
---@param x number
---@param y number
---@see variable TERRAIN_?
---@param whichType number
---@return boolean
terrain.isType = function(x, y, whichType)
    return whichType == terrain.type(x, y)
end

--- 是否荒芜地表
---@param x number
---@param y number
---@return boolean
terrain.isBlighted = function(x, y)
    return J.IsPointBlighted(x, y)
end

--- 是否可通行
---@param x number
---@param y number
---@return boolean
terrain.isWalkable = function(x, y)
    return not J.IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
end

--- 是否飞行可通行
---@param x number
---@param y number
---@return boolean
terrain.isWalkableFly = function(x, y)
    return not J.IsTerrainPathable(x, y, PATHING_TYPE_FLYABILITY)
end

--- 是否水(海)面可通行
---@param x number
---@param y number
---@return boolean
terrain.isWalkableWater = function(x, y)
    return not J.IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY)
end

--- 是否两栖可通行
---@param x number
---@param y number
---@return boolean
terrain.isWalkableAmphibious = function(x, y)
    return not J.IsTerrainPathable(x, y, PATHING_TYPE_AMPHIBIOUSPATHING)
end

--- 是否荒芜可通行
---@param x number
---@param y number
---@return boolean
terrain.isWalkableBlight = function(x, y)
    return not J.IsTerrainPathable(x, y, PATHING_TYPE_BLIGHTPATHING)
end

--- 是否建造可通行
---@param x number
---@param y number
---@return boolean
terrain.isWalkableBuild = function(x, y)
    return not J.IsTerrainPathable(x, y, PATHING_TYPE_BUILDABILITY)
end

--- 是否采集时可通行
---@param x number
---@param y number
---@return boolean
terrain.isWalkablePeonHarvest = function(x, y)
    return not J.IsTerrainPathable(x, y, PATHING_TYPE_PEONHARVESTPATHING)
end

--- 是否处在水面
---@param x number
---@param y number
---@return boolean
terrain.isWater = function(x, y)
    return terrain.isWalkableWater(x, y)
end

--- 是否处于地面
--- 这里实际上判断的是非水区域
---@param x number
---@param y number
---@return boolean
terrain.isGround = function(x, y)
    return not terrain.isWalkableWater(x, y)
end