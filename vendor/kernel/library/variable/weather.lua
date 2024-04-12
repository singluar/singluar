---@class WEATHER_TYPE 天气类型
---@desc 特性1、天气类型非handle类型，[视觉区]指曾看到的区域，是虚构的概念实际上不存在，但可粗略理解为Rect
---@desc 特性2、迷雾类型指：薄雾/厚雾/风/大风；光束类型指：日光/月光；雨水类型指：雨/大雨
---@desc 特性3、同一片区域可以多次设置天气（但非常不建议，详情见特性6/7）
---@desc 特性4、同一片区域多次设置同一天气后，在视觉效果上不会有什么差异
---@desc 特性5、同源类型（如迷雾/光束），不能同时显示在同一片视觉区，会被抢先生成的占领视觉区，即使使用不同Rect也无效
---@desc 特性6、同一Rect，只添加最多1种天气时，此天气添加[迷雾|光束|雨水类型]后，可后续修改为其他[迷雾|光束|雨水类型](但依然遵循 特性5)
---@desc 特性7、同一Rect，曾添加过2种以上天气后，则该视觉区在添加1次[迷雾|光束|雨水类型]后，则该视觉区的[其他][迷雾|光束|雨水类型]功能将被废且锁死，无法生效
WEATHER_TYPE = WEATHER_TYPE or {}
WEATHER_TYPE.sun = { value = "LRaa", label = "日光" }
WEATHER_TYPE.moon = { value = "LRma", label = "月光" }
WEATHER_TYPE.shield = { value = "MEds", label = "紫光盾" }
WEATHER_TYPE.rain = { value = "RAlr", label = "雨" }
WEATHER_TYPE.rainstorm = { value = "RAhr", label = "大雨" }
WEATHER_TYPE.snow = { value = "SNls", label = "雪" }
WEATHER_TYPE.snowstorm = { value = "SNhs", label = "大雪" }
WEATHER_TYPE.wind = { value = "WOlw", label = "风" }
WEATHER_TYPE.windstorm = { value = "WNcw", label = "大风" }
WEATHER_TYPE.mistWhiteLight = { value = "FDwl", label = "薄白雾" }
WEATHER_TYPE.mistWhiteHeave = { value = "FDwh", label = "厚白雾" }
WEATHER_TYPE.mistGreenLight = { value = "FDgl", label = "薄绿雾" }
WEATHER_TYPE.mistGreenHeave = { value = "FDgh", label = "厚绿雾" }
WEATHER_TYPE.mistBlueLight = { value = "FDbl", label = "薄蓝雾" }
WEATHER_TYPE.mistBlueHeave = { value = "FDbh", label = "厚蓝雾" }
WEATHER_TYPE.mistRedLight = { value = "FDrl", label = "薄红雾" }
WEATHER_TYPE.mistRedHeave = { value = "FDrh", label = "厚红雾" }