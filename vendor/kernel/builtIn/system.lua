--- #单位 token
_unit({ _parent = "ogru" })

--- #单位死亡标志
_unit({ _parent = "ogru" })

-- #隐身
_ability({ _parent = "Apiv" })

--- #叹号警示圈 直径128px
_unit({ _parent = "ogru" })

--- #叉号警示圈 直径128px
_unit({ _parent = "ogru" })

--- #JAPI_DELAY
_ability({ _parent = "Aamk" })

--- #回避(伤害)+
_ability({ _parent = "AIlf" })
--- #回避(伤害)-
_ability({ _parent = "AIlf" })

--- #视野
local sightBase = { 1, 2, 3, 4, 5 }
local i = 1
while (i <= 1000) do
    for _ = 1, #sightBase do
        -- #视野+|-
        _ability({ _parent = "AIsi" })
        _ability({ _parent = "AIsi" })
    end
    i = i * 10
end