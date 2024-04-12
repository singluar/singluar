---@class japi JAPI
japi = japi or {}

function japi.DzAPI_Map_ChangeStoreItemCoolDown(...)
    return J.ExecJAPI("DzAPI_Map_ChangeStoreItemCoolDown", ...)
end

function japi.DzAPI_Map_ChangeStoreItemCount(...)
    return J.ExecJAPI("DzAPI_Map_ChangeStoreItemCount", ...)
end

---@return string
function japi.DzAPI_Map_GetActivityData()
    return J.ExecJAPI("DzAPI_Map_GetActivityData")
end

--- 获取当前游戏时间
--- 获取创建地图的游戏时间
--- 时间换算为时间戳
---@return number
function japi.DzAPI_Map_GetGameStartTime()
    return J.ExecJAPI("DzAPI_Map_GetGameStartTime")
end

--- 获取公会名称
---@param whichPlayer number
---@return string
function japi.DzAPI_Map_GetGuildName(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_GetGuildName", whichPlayer)
end

--- 获取公会职责
--- 获取公会职责 Member=10 Admin=20 Leader=30
---@param whichPlayer number
---@return number
function japi.DzAPI_Map_GetGuildRole(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_GetGuildRole", whichPlayer)
end

--- 获取天梯等级
--- 取值1~25，青铜V是1级
---@param whichPlayer number
---@return number
function japi.DzAPI_Map_GetLadderLevel(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_GetLadderLevel", whichPlayer)
end

--- 获取天梯排名
--- 排名>1000的获取值为0
---@param whichPlayer number
---@return number
function japi.DzAPI_Map_GetLadderRank(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_GetLadderRank", whichPlayer)
end

--- 获取全局服务器存档值
---@param key string
---@return number
function japi.DzAPI_Map_GetMapConfig(key)
    return J.ExecJAPI("DzAPI_Map_GetMapConfig", key)
end

--- 获取玩家地图等级
--- 获取玩家地图等级【RPG大厅限定】
---@param whichPlayer number
---@return number
function japi.DzAPI_Map_GetMapLevel(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_GetMapLevel", whichPlayer)
end

--- 获取玩家地图等级排名
--- 排名>100的获取值为0
---@param whichPlayer number
---@return number
function japi.DzAPI_Map_GetMapLevelRank(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_GetMapLevelRank", whichPlayer)
end

--- 获取天梯和匹配的模式
--- 返回数值与作者之家设置对应
function japi.DzAPI_Map_GetMatchType()
    return J.ExecJAPI("DzAPI_Map_GetMatchType")
end

--- 获取玩家平台VIP标志
---@param whichPlayer number
---@return number
function japi.DzAPI_Map_GetPlatformVIP(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_GetPlatformVIP", whichPlayer)
end

--- 读取公共服务器存档组数据
--- 服务器存档组有100个KEY，每个KEY64个字符长度，可以多张地图读取和保存，使用前先在作者之家服务器存档组设置
---@param whichPlayer number
---@param key string
---@return string
function japi.DzAPI_Map_GetPublicArchive(whichPlayer, key)
    return J.ExecJAPI("DzAPI_Map_GetPublicArchive", whichPlayer, key)
end

--- 读取服务器Boss掉落装备类型
---@param whichPlayer number
---@param key string
---@return string
function japi.DzAPI_Map_GetServerArchiveDrop(whichPlayer, key)
    return J.ExecJAPI("DzAPI_Map_GetServerArchiveDrop", whichPlayer, key)
end

---@param whichPlayer number
---@param key string
---@return number
function japi.DzAPI_Map_GetServerArchiveEquip(whichPlayer, key)
    return J.ExecJAPI("DzAPI_Map_GetServerArchiveEquip", whichPlayer, key)
end

--- 获取服务器存档
---@param whichPlayer number
---@param key string
---@return any
function japi.DzAPI_Map_GetServerValue(whichPlayer, key)
    return J.ExecJAPI("DzAPI_Map_GetServerValue", whichPlayer, key)
end

---@param whichPlayer number
---@return number
function japi.DzAPI_Map_GetServerValueErrorCode(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_GetServerValueErrorCode", whichPlayer)
end

function japi.DzAPI_Map_GetUserID(...)
    return J.ExecJAPI("DzAPI_Map_GetUserID", ...)
end

--- 玩家是否拥有该商城道具（平台地图商城）
--- 平台地图商城玩家拥有该道具返还true
---@param whichPlayer number
---@param key string
---@return boolean
function japi.DzAPI_Map_HasMallItem(whichPlayer, key)
    return J.ExecJAPI("DzAPI_Map_HasMallItem", whichPlayer, key)
end

--- 判断是否是蓝V
---@param whichPlayer number
---@return boolean
function japi.DzAPI_Map_IsBlueVIP(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_IsBlueVIP", whichPlayer)
end

--- 判断地图是否在RPG天梯
---@return boolean
function japi.DzAPI_Map_IsRPGLadder()
    return J.ExecJAPI("DzAPI_Map_IsRPGLadder")
end

--- 判断当前地图是否rpg大厅来的
---@return boolean
function japi.DzAPI_Map_IsRPGLobby()
    return J.ExecJAPI("DzAPI_Map_IsRPGLobby")
end

--- 判断是否是红V
---@param whichPlayer number
---@return boolean
function japi.DzAPI_Map_IsRedVIP(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_IsRedVIP", whichPlayer)
end

---@param whichPlayer number
---@param key string
---@param value string
function japi.DzAPI_Map_Ladder_SetPlayerStat(whichPlayer, key, value)
    return J.ExecJAPI("DzAPI_Map_Ladder_SetPlayerStat", whichPlayer, key, value)
end

--- 天梯提交字符串数据
---@param whichPlayer number
---@param key string
---@param value string
function japi.DzAPI_Map_Ladder_SetStat(whichPlayer, key, value)
    return J.ExecJAPI("DzAPI_Map_Ladder_SetStat", whichPlayer, key, value)
end

--- 活动完成
--- 完成平台活动[RPG大厅限定]
---@param whichPlayer number
---@param key string
---@param value string
function japi.DzAPI_Map_MissionComplete(whichPlayer, key, value)
    return J.ExecJAPI("DzAPI_Map_MissionComplete", whichPlayer, key, value)
end

--- 触发boss击杀
---@param whichPlayer number
---@param key string
function japi.DzAPI_Map_OrpgTrigger(whichPlayer, key)
    return J.ExecJAPI("DzAPI_Map_OrpgTrigger", whichPlayer, key)
end

--- 服务器公共存档组保存
--- 存储服务器存档组，服务器存档组有100个KEY，每个KEY64个字符串长度，使用前请在作者之家服务器存档组进行设置
---@param whichPlayer number
---@param key string
---@param value string
function japi.DzAPI_Map_SavePublicArchive(whichPlayer, key, value)
    return J.ExecJAPI("DzAPI_Map_SavePublicArchive", whichPlayer, key, value)
end

--- 保存服务器存档
---@param whichPlayer number
---@param key string
---@param value string
function japi.DzAPI_Map_SaveServerValue(whichPlayer, key, value)
    return J.ExecJAPI("DzAPI_Map_SaveServerValue", whichPlayer, key, value)
end

--- 设置房间显示的数据
--- 为服务器存档显示的数据，对应作者之家的房间key
---@param whichPlayer number
---@param key string
---@param value string
function japi.DzAPI_Map_Stat_SetStat(whichPlayer, key, value)
    return J.ExecJAPI("DzAPI_Map_Stat_SetStat", whichPlayer, key, value)
end

--- 平台统计
--- 一般用于统计游戏里某些事件的触发次数，可在作者之家查看。【第二个子key是以后备用暂时不要填】
---@param whichPlayer number
---@param eventKey string
---@param eventType string
---@param value number integer
function japi.DzAPI_Map_Statistics(whichPlayer, eventKey, eventType, value)
    return J.ExecJAPI("DzAPI_Map_Statistics", whichPlayer, eventKey, eventType, value)
end

function japi.DzAPI_Map_ToggleStore(...)
    return J.ExecJAPI("DzAPI_Map_ToggleStore", ...)
end

function japi.DzAPI_Map_UpdatePlayerHero(...)
    return J.ExecJAPI("DzAPI_Map_UpdatePlayerHero", ...)
end

--- 局数消耗商品调用
--- 仅对局数消耗型商品有效
---@param whichPlayer number
---@param key string
function japi.DzAPI_Map_UseConsumablesItem(whichPlayer, key)
    return J.ExecJAPI("DzAPI_Map_UseConsumablesItem", whichPlayer, key)
end

--- 转换世界坐标
---@param x number
---@param y number
---@param z number
---@return number,number
function japi.DzConvertWorldPosition(x, y, z)
    return J.ExecJAPI("DzConvertWorldPosition_", x, y, z)
end

--- 新建Frame
--- 名字为fdf文件中的名字，ID默认填0。重复创建同名Frame会导致游戏退出时显示崩溃消息，如需避免可以使用Tag创建
---@param frame string
---@param parent number integer
---@param id number integer
---@return number integer
function japi.DzCreateFrame(frame, parent, id)
    return J.ExecJAPI("DzCreateFrame", frame, parent, id)
end

--- 新建Frame[Tag]
--- 此处名字可以自定义，类型和模版填写fdf文件中的内容。通过此函数创建的Frame无法获取到子Frame
---@param frameType string
---@param name string
---@param parent number integer
---@param template string
---@param id number integer
---@return number integer
function japi.DzCreateFrameByTagName(frameType, name, parent, template, id)
    return J.ExecJAPI("DzCreateFrameByTagName", frameType, name, parent, template, id) or 0
end

---@param frame string
---@param parent number integer
---@param id number integer
---@return number integer
function japi.DzCreateSimpleFrame(frame, parent, id)
    return J.ExecJAPI("DzCreateSimpleFrame", frame, parent, id)
end

--- 销毁
--- 销毁一个被重复创建过的Frame会导致游戏崩溃，重复创建同名Frame请使用Tag创建
---@param frameId number integer
function japi.DzDestroyFrame(frameId)
    return J.ExecJAPI("DzDestroyFrame", frameId)
end

--- 设置可破坏物位置
---@param d number destructable
---@param x number floor(2)
---@param y number floor(2)
function japi.DzDestructablePosition(d, x, y)
    return J.ExecJAPI("DzDestructablePosition", d, x, y)
end

--- 原生 - 使用宽屏模式
---@param enable boolean
function japi.DzEnableWideScreen(enable)
    return J.ExecJAPI("DzEnableWideScreen_", enable)
end

--- 异步执行函数
---@param funcName string
function japi.DzExecuteFunc(funcName)
    return J.ExecJAPI("DzExecuteFunc", funcName)
end

--- 限制鼠标移动，在frame内
---@param frame number integer
---@param enable boolean
function japi.DzFrameCageMouse(frame, enable)
    return J.ExecJAPI("DzFrameCageMouse", frame, enable)
end

--- 清空frame所有锚点
---@param frame number integer
function japi.DzFrameClearAllPoints(frame)
    return J.ExecJAPI("DzFrameClearAllPoints", frame)
end

--- 修改游戏渲染黑边: 上方高度:topHeight,下方高度:bottomHeight
--- 上下加起来不要大于0.6
---@param topHeight number floor(4)
---@param bottomHeight number floor(4)
function japi.DzFrameEditBlackBorders(topHeight, bottomHeight)
    return J.ExecJAPI("DzFrameEditBlackBorders_", topHeight, bottomHeight)
end

--- 获取名字为name的子FrameID:Id"
--- ID默认填0，同名时优先获取最后被创建的。非Simple类的Frame类型都用此函数来获取子Frame
---@param name string
---@param id number integer
---@return number integer
function japi.DzFrameFindByName(name, id)
    return J.ExecJAPI("DzFrameFindByName", name, id)
end

--- 获取Frame的透明度(0-255)
---@param frame number integer
---@return number integer
function japi.DzFrameGetAlpha(frame)
    return J.ExecJAPI("DzFrameGetAlpha", frame)
end

--- 原生 - 玩家聊天信息框
---@return number integer
function japi.DzFrameGetChatMessage()
    return J.ExecJAPI("DzFrameGetChatMessage")
end

--- 原生 - 技能按钮
--- 技能按钮:(row, column)
--- 参考物编中的技能按钮(x,y)坐标
--- (x,y)对应(column,row)反一下
---@param row number integer
---@param column number integer
---@return number integer
function japi.DzFrameGetCommandBarButton(row, column)
    return J.ExecJAPI("DzFrameGetCommandBarButton", row, column)
end

--- frame控件是否启用
---@param frame number integer
---@return boolean
function japi.DzFrameGetEnable(frame)
    return J.ExecJAPI("DzFrameGetEnable", frame)
end

--- 获取Frame的高度
---@param frame number integer
---@return number floor
function japi.DzFrameGetHeight(frame)
    return J.ExecJAPI("DzFrameGetHeight", frame)
end

--- 原生 - 英雄按钮
--- 左侧的英雄头像，参数表示第N+1个英雄，索引从0开始
---@param buttonId number integer
---@return number integer
function japi.DzFrameGetHeroBarButton(buttonId)
    return J.ExecJAPI("DzFrameGetHeroBarButton", buttonId)
end

--- 原生 - 英雄血条
--- 左侧的英雄头像下的血条，参数表示第N+1个英雄，索引从0开始
---@param buttonId number integer
---@return number integer
function japi.DzFrameGetHeroHPBar(buttonId)
    return J.ExecJAPI("DzFrameGetHeroHPBar", buttonId)
end

--- 原生 - 英雄蓝条
--- 左侧的英雄头像下的蓝条，参数表示第N+1个英雄，索引从0开始
---@param buttonId number integer
---@return number integer
function japi.DzFrameGetHeroManaBar(buttonId)
    return J.ExecJAPI("DzFrameGetHeroManaBar", buttonId)
end

--- 原生 - 物品栏按钮
--- 索引从0开始
---@param buttonId number integer
---@return number integer
function japi.DzFrameGetItemBarButton(buttonId)
    return J.ExecJAPI("DzFrameGetItemBarButton", buttonId)
end

--- 原生 - 小地图
---@return number integer
function japi.DzFrameGetMinimap()
    return J.ExecJAPI("DzFrameGetMinimap")
end

--- 原生 - 小地图按钮
--- 小地图右侧竖排按钮，索引从0开始
---@param buttonId number integer
---@return number integer
function japi.DzFrameGetMinimapButton(buttonId)
    return J.ExecJAPI("DzFrameGetMinimapButton", buttonId)
end

--- 获取 Frame 的名称
---@param frame number integer
---@return string
function japi.DzFrameGetName(frame)
    return J.ExecJAPI("DzFrameGetName", frame)
end

--- 获取 Frame 的 Parent
---@param frame number integer
---@return number integer
function japi.DzFrameGetParent(frame)
    return J.ExecJAPI("DzFrameGetParent", frame)
end

--- 原生 - 单位大头像
--- 小地图右侧的大头像
---@return number integer
function japi.DzFrameGetPortrait()
    return J.ExecJAPI("DzFrameGetPortrait")
end

--- 获取 Frame 内的文字
--- 支持EditBox, TextFrame, TextArea, SimpleFontString
---@param frame number integer
---@return string
function japi.DzFrameGetText(frame)
    return J.ExecJAPI("DzFrameGetText", frame)
end

--- 获取 Frame 的字数限制
--- 支持EditBox
---@param frame number integer
---@return number integer
function japi.DzFrameGetTextSizeLimit(frame)
    return J.ExecJAPI("DzFrameGetTextSizeLimit", frame)
end

--- 原生 - 鼠标提示
--- 鼠标移动到物品或技能按钮上显示的提示窗，初始位于技能栏上方
---@return number integer
function japi.DzFrameGetTooltip()
    return J.ExecJAPI("DzFrameGetTooltip")
end

--- 原生 - 上方消息框
--- 高维修费用 等消息
---@return number integer
function japi.DzFrameGetTopMessage()
    return J.ExecJAPI("DzFrameGetTopMessage")
end

--- 原生 - 系统消息框
--- 包含显示消息给玩家 及 显示Debug消息等
---@return number integer
function japi.DzFrameGetUnitMessage()
    return J.ExecJAPI("DzFrameGetUnitMessage")
end

--- 原生 - 界面按钮
--- 左上的菜单等按钮，索引从0开始
---@param buttonId number integer
---@return number integer
function japi.DzFrameGetUpperButtonBarButton(buttonId)
    return J.ExecJAPI("DzFrameGetUpperButtonBarButton", buttonId)
end

--- 获取frame当前值
--- 支持Slider、SimpleStatusBar、StatusBar
---@param frame number integer
---@return number floor
function japi.DzFrameGetValue(frame)
    return J.ExecJAPI("DzFrameGetValue", frame)
end

--- 原生 - 隐藏界面元素
--- 不再在地图初始化时调用则会残留小地图和时钟模型
function japi.DzFrameHideInterface()
    return J.ExecJAPI("DzFrameHideInterface")
end

--- 设置绝对位置
--- 设置 frame 的 Point 锚点 在 (x, y)
---@param frame number integer
---@param point number integer
---@param x number floor(3)
---@param y number floor(3)
function japi.DzFrameSetAbsolutePoint(frame, point, x, y)
    return J.ExecJAPI("DzFrameSetAbsolutePoint", frame, point, x, y)
end

--- 移动所有锚点到Frame
--- 移动 frame 的 所有锚点 到 relativeFrame 上
---@param frame number integer
---@param relativeFrame number integer
---@return boolean
function japi.DzFrameSetAllPoints(frame, relativeFrame)
    return J.ExecJAPI("DzFrameSetAllPoints", frame, relativeFrame)
end

--- 设置frame的透明度(0-255)
---@param frame number integer
---@param alpha number integer
function japi.DzFrameSetAlpha(frame, alpha)
    return J.ExecJAPI("DzFrameSetAlpha", frame, alpha)
end

--- 设置动画
---@param frame number integer
---@param animId number integer 播放序号的动画
---@param autoCast boolean 自动播放
function japi.DzFrameSetAnimate(frame, animId, autoCast)
    return J.ExecJAPI("DzFrameSetAnimate", frame, animId, autoCast)
end

--- 设置动画进度
--- 自动播放为false时可用
---@param frame number integer
---@param offset number float(3) 进度
function japi.DzFrameSetAnimateOffset(frame, offset)
    return J.ExecJAPI("DzFrameSetAnimateOffset", frame, offset)
end

--- 启用/禁用 frame
---@param frame number integer
---@param enable boolean
function japi.DzFrameSetEnable(frame, enable)
    return J.ExecJAPI("DzFrameSetEnable", frame, enable)
end

--- 设置frame获取焦点
---@param frame number integer
---@param enable boolean
---@return boolean
function japi.DzFrameSetFocus(frame, enable)
    return J.ExecJAPI("DzFrameSetFocus", frame, enable)
end

--- 设置字体
--- 设置 frame 的字体为 font, 大小 height, flag flag
--- 支持EditBox、SimpleFontString、SimpleMessageFrame以及非SimpleFrame类型的例如TEXT，flag作用未知
---@param frame number integer
---@param fileName string
---@param height number float(5)
---@param flag number integer
function japi.DzFrameSetFont(frame, fileName, height, flag)
    return J.ExecJAPI("DzFrameSetFont", frame, fileName, height, flag)
end

--- 设置最大/最小值
--- 设置 frame 的 最小值为 Min 最大值为 Max
--- 支持Slider、SimpleStatusBar、StatusBar
---@param frame number integer
---@param minValue number float(5)
---@param maxValue number float(5)
function japi.DzFrameSetMinMaxValue(frame, minValue, maxValue)
    return J.ExecJAPI("DzFrameSetMinMaxValue", frame, minValue, maxValue)
end

--- 设置模型
--- 设置 frame 的模型文件为 modelFile ModelType:modelType Flag:flag
---@param frame number integer
---@param modelFile string
---@param modelType number integer
---@param flag number integer
function japi.DzFrameSetModel(frame, modelFile, modelType, flag)
    return J.ExecJAPI("DzFrameSetModel", frame, modelFile, modelType, flag)
end

--- 设置父窗口
--- 设置 frame 的父窗口为 parent
---@param frame number integer
---@param parent number integer
function japi.DzFrameSetParent(frame, parent)
    return J.ExecJAPI("DzFrameSetParent", frame, parent)
end

--- 设置相对位置
--- 设置 frame 的 Point 锚点 (跟随relativeFrame 的 relativePoint 锚点) 偏移(x, y)
---@param frame number integer
---@param point number integer
---@param relativeFrame number integer
---@param relativePoint number integer
---@param x number float(5)
---@param y number float(5)
function japi.DzFrameSetPoint(frame, point, relativeFrame, relativePoint, x, y)
    return J.ExecJAPI("DzFrameSetPoint", frame, point, relativeFrame, relativePoint, x, y)
end

--- 设置优先级
--- 设置 frame 优先级:int
---@param frame number integer
---@param priority number integer
function japi.DzFrameSetPriority(frame, priority)
    return J.ExecJAPI("DzFrameSetPriority", frame, priority)
end

--- 设置缩放
--- 设置 frame 的缩放 scale
---@param frame number integer
---@param scale number float(5)
function japi.DzFrameSetScale(frame, scale)
    return J.ExecJAPI("DzFrameSetScale", frame, scale)
end

--- 设置frame大小
---@param frame number integer
---@param w number float(5) 宽
---@param h number float(5) 高
function japi.DzFrameSetSize(frame, w, h)
    return J.ExecJAPI("DzFrameSetSize", frame, w, h)
end

--- 设置frame步进值
--- 支持Slider
---@param frame number integer
---@param step number float(3) 步进
function japi.DzFrameSetStepValue(frame, step)
    return J.ExecJAPI("DzFrameSetStepValue", frame, step)
end

--- 设置frame文本
--- 支持EditBox, TextFrame, TextArea, SimpleFontString、GlueEditBoxWar3、SlashChatBox、TimerTextFrame、TextButtonFrame、GlueTextButton
---@param frame number integer
---@param text string
function japi.DzFrameSetText(frame, text)
    return J.ExecJAPI("DzFrameSetText", frame, text)
end

--- 设置frame文本对齐方式
--- 支持TextFrame、SimpleFontString、SimpleMessageFrame
---@param frame number integer
---@param align number integer ，参考blizzard:^TEXT_ALIGN
function japi.DzFrameSetTextAlignment(frame, align)
    return J.ExecJAPI("DzFrameSetTextAlignment", frame, align)
end

---@param frame number integer
---@param color number integer
function japi.DzFrameSetTextColor(frame, color)
    return J.ExecJAPI("DzFrameSetTextColor", frame, color)
end

--- 设置frame字数限制
---@param frame number integer
---@param limit number integer
function japi.DzFrameSetTextSizeLimit(frame, limit)
    return J.ExecJAPI("DzFrameSetTextSizeLimit", frame, limit)
end

--- 设置frame贴图
--- 支持Backdrop、SimpleStatusBar
---@param frame number integer
---@param texture string 贴图路径
---@param flag number integer 是否平铺
function japi.DzFrameSetTexture(frame, texture, flag)
    return J.ExecJAPI("DzFrameSetTexture", frame, texture, flag)
end

--- 设置提示
--- 设置 frame 的提示Frame为 tooltip
--- 设置tooltip
---@param frame number integer
---@param tooltip number integer
function japi.DzFrameSetTooltip(frame, tooltip)
    return J.ExecJAPI("DzFrameSetTooltip", frame, tooltip)
end

--- 设置frame当前值
--- 支持Slider、SimpleStatusBar、StatusBar
---@param frame number integer
---@param value number float(5)
function japi.DzFrameSetValue(frame, value)
    return J.ExecJAPI("DzFrameSetValue", frame, value)
end

--- 设置frame颜色
---@param frame number integer
---@param vertexColor number integer
function japi.DzFrameSetVertexColor(frame, vertexColor)
    return J.ExecJAPI("DzFrameSetVertexColor", frame, vertexColor)
end

--- 设置frame显示与否
---@param frame number integer
---@param enable boolean
function japi.DzFrameShow(frame, enable)
    return J.ExecJAPI("DzFrameShow", frame, enable)
end

function japi.DzGetClientHeight(...)
    return J.ExecJAPI("DzGetClientHeight", ...)
end

function japi.DzGetClientWidth(...)
    return J.ExecJAPI("DzGetClientWidth", ...)
end

--- 取 RGBA 色值
--- 返回一个整数，用于设置Frame颜色
---@param r number integer
---@param g number integer
---@param b number integer
---@param a number integer
---@return number integer
function japi.DzGetColor(r, g, b, a)
    return J.ExecJAPI("DzGetColor", r, g, b, a)
end

--- 原生 - 游戏UI
--- 一般用作创建自定义UI的父节点
---@return number integer
function japi.DzGetGameUI()
    return J.ExecJAPI("DzGetGameUI")
end

--- 获取客户端语言
--- 对不同语言客户端返回不同
---@return string
function japi.DzGetLocale()
    return J.ExecJAPI("DzGetLocale")
end

--- 鼠标所在的Frame控件指针
--- 不是所有类型的Frame都能响应鼠标，能响应的有BUTTON，TEXT等
---@return number integer
function japi.DzGetMouseFocus()
    return J.ExecJAPI("DzGetMouseFocus")
end

--- 获取鼠标在游戏内的坐标X
---@return number
function japi.DzGetMouseTerrainX()
    return J.ExecJAPI("DzGetMouseTerrainX")
end

--- 获取鼠标在游戏内的坐标Y
---@return number
function japi.DzGetMouseTerrainY()
    return J.ExecJAPI("DzGetMouseTerrainY")
end

--- 获取鼠标在游戏内的坐标Z
---@return number
function japi.DzGetMouseTerrainZ()
    return J.ExecJAPI("DzGetMouseTerrainZ")
end

--- 获取鼠标在屏幕的坐标X
---@return number
function japi.DzGetMouseX()
    return J.ExecJAPI("DzGetMouseX")
end

--- 获取鼠标游戏窗口坐标X
---@return number integer
function japi.DzGetMouseXRelative()
    return J.ExecJAPI("DzGetMouseXRelative")
end

--- 获取鼠标在屏幕的坐标Y
---@return number
function japi.DzGetMouseY()
    return J.ExecJAPI("DzGetMouseY")
end

--- 获取鼠标游戏窗口坐标Y
---@return number integer
function japi.DzGetMouseYRelative()
    return J.ExecJAPI("DzGetMouseYRelative")
end

--- 事件响应 - 获取触发的按键
--- 响应 [硬件] - 按键事件
---@return number integer
function japi.DzGetTriggerKey()
    return J.ExecJAPI("DzGetTriggerKey")
end

--- 事件响应 - 获取触发硬件事件的玩家
--- 响应 [硬件] - 按键事件 滚轮事件 窗口大小变化事件
---@return number player
function japi.DzGetTriggerKeyPlayer()
    return J.ExecJAPI("DzGetTriggerKeyPlayer")
end

--- 事件响应 - 获取同步的数据
--- 响应 [同步] - 同步消息事件
---@return string
function japi.DzGetTriggerSyncData()
    return J.ExecJAPI("DzGetTriggerSyncData")
end

--- 事件响应 - 获取同步数据的玩家
--- 响应 [同步] - 同步消息事件
---@return number player
function japi.DzGetTriggerSyncPlayer()
    return J.ExecJAPI("DzGetTriggerSyncPlayer")
end

--- 获取升级所需经验
--- 获取单位 unit 的 level级 升级所需经验
---@param whichUnit number
---@param level number integer
---@return number integer
function japi.DzGetUnitNeededXP(whichUnit, level)
    return J.ExecJAPI("DzGetUnitNeededXP", whichUnit, level)
end

--- 获取鼠标指向的单位
---@return number unit
function japi.DzGetUnitUnderMouse()
    return J.ExecJAPI("DzGetUnitUnderMouse")
end

--- 事件响应 - 获取滚轮变化值
--- 响应 [硬件] - 鼠标滚轮事件，正负区分上下
---@return number integer
function japi.DzGetWheelDelta()
    return J.ExecJAPI("DzGetWheelDelta")
end

--- 获取魔兽窗口高度
---@return number integer
function japi.DzGetWindowHeight()
    return J.ExecJAPI("DzGetWindowHeight")
end

--- 获取魔兽窗口宽度
---@return number integer
function japi.DzGetWindowWidth()
    return J.ExecJAPI("DzGetWindowWidth")
end

--- 获取魔兽窗口X坐标
---@return number integer
function japi.DzGetWindowX()
    return J.ExecJAPI("DzGetWindowX")
end

--- 获取魔兽窗口Y坐标
---@return number integer
function japi.DzGetWindowY()
    return J.ExecJAPI("DzGetWindowY")
end

--- 判断按键是否按下
---@param iKey number integer 参考blizzard:^GAME_KEY
---@return boolean
function japi.DzIsKeyDown(iKey)
    return J.ExecJAPI("DzIsKeyDown", iKey)
end

--- 鼠标是否在游戏内
---@return boolean
function japi.DzIsMouseOverUI()
    return J.ExecJAPI("DzIsMouseOverUI")
end

--- 判断游戏窗口是否处于活动状态
---@return boolean
function japi.DzIsWindowActive()
    return J.ExecJAPI("DzIsWindowActive")
end

--- 加载Toc文件列表
--- 加载--> file.toc
--- 载入自己的fdf列表文件
---@return boolean
function japi.DzLoadToc(tocFilePath)
    return J.ExecJAPI("DzLoadToc_", tocFilePath)
end

---@param enable boolean
function japi.DzOriginalUIAutoResetPoint(enable)
    return J.ExecJAPI("DzOriginalUIAutoResetPoint", enable)
end

--- 原生 - 修改屏幕比例(FOV)
---@param value number float(5)
function japi.DzSetCustomFovFix(value)
    return J.ExecJAPI("DzSetCustomFovFix", value)
end

--- 设置内存数值
--- 设置内存数据 address=value
---@param address number integer
---@param value number float(5)
function japi.DzSetMemory(address, value)
    return J.ExecJAPI("DzSetMemory", address, value)
end

--- 设置鼠标的坐标
---@param x number integer
---@param y number integer
function japi.DzSetMousePos(x, y)
    return J.ExecJAPI("DzSetMousePos", x, y)
end

--- 替换单位类型
--- 替换whichUnit的单位类型为:id
--- 不会替换大头像中的模型
---@param whichUnit number
---@param id number|string
function japi.DzSetUnitID(whichUnit, id)
    return J.ExecJAPI("DzSetUnitID", whichUnit, id)
end

--- 替换单位模型
--- 替换whichUnit的模型:path
--- 不会替换大头像中的模型
---@param whichUnit number
---@param model string
function japi.DzSetUnitModel(whichUnit, model)
    return J.ExecJAPI("DzSetUnitModel", whichUnit, model)
end

--- 设置单位位置 - 本地调用
---@param whichUnit number
---@param x number float(2)
---@param y number float(2)
function japi.DzSetUnitPosition(whichUnit, x, y)
    return J.ExecJAPI("DzSetUnitPosition", whichUnit, x, y)
end

--- 替换单位贴图
--- 只能替换模型中有Replaceable ID x 贴图的模型，ID为索引。不会替换大头像中的模型
---@param whichUnit number
---@param path string
---@param texId number integer
function japi.DzSetUnitTexture(whichUnit, path, texId)
    return J.ExecJAPI("DzSetUnitTexture", whichUnit, path, texId)
end

--- 原生 - 设置小地图背景贴图
---@param blp string
function japi.DzSetWar3MapMap(blp)
    return J.ExecJAPI("DzSetWar3MapMap", blp)
end

--- 获取子SimpleFontString
--- ID默认填0，同名时优先获取最后被创建的。SimpleFontString为fdf中的Frame类型
---@param name string
---@param id number integer
function japi.DzSimpleFontStringFindByName(name, id)
    return J.ExecJAPI("DzSimpleFontStringFindByName", name, id)
end

--- 获取子SimpleFrame
--- ID默认填0，同名时优先获取最后被创建的。SimpleFrame为fdf中的Frame类型
---@param name string
---@param id number integer
function japi.DzSimpleFrameFindByName(name, id)
    return J.ExecJAPI("DzSimpleFrameFindByName", name, id)
end

--- 获取子SimpleTexture
--- ID默认填0，同名时优先获取最后被创建的。SimpleTexture为fdf中的Frame类型
---@param name string
---@param id number integer
function japi.DzSimpleTextureFindByName(name, id)
    return J.ExecJAPI("DzSimpleTextureFindByName", name, id)
end

function japi.DzSyncBuffer(...)
    return J.ExecJAPI("DzSyncBuffer", ...)
end

--- 同步游戏数据
--- 同步 标签：prefix  发送数据：data
---@param prefix string
---@param data string
function japi.DzSyncData(prefix, data)
    return J.ExecJAPI("DzSyncData", prefix, data)
end

--- 同步游戏数据(立刻)
--- 同步 标签：prefix  发送数据：data
---@param prefix string
---@param data string
function japi.DzSyncDataImmediately(prefix, data)
    return J.ExecJAPI("DzSyncDataImmediately", prefix, data)
end

--- 数据同步
--- 标签为 prefix 的数据被同步 | 来自平台:server
--- 来自平台的参数填false
---@param trig number
---@param prefix string
---@param server boolean
function japi.DzTriggerRegisterSyncData(trig, prefix, server)
    return J.ExecJAPI("DzTriggerRegisterSyncData", trig, prefix, server)
end

function japi.DzUnitDisableAttack(...)
    return J.ExecJAPI("DzUnitDisableAttack", ...)
end

function japi.DzUnitDisableInventory(...)
    return J.ExecJAPI("DzUnitDisableInventory", ...)
end

function japi.DzUnitSilence(...)
    return J.ExecJAPI("DzUnitSilence", ...)
end

function japi.EXBlendButtonIcon(...)
    return J.ExecJAPI("EXBlendButtonIcon", ...)
end

function japi.EXDclareButtonIcon(...)
    return J.ExecJAPI("EXDclareButtonIcon", ...)
end

function japi.EXDisplayChat(...)
    return J.ExecJAPI("EXDisplayChat", ...)
end

--- 重置特效变换
--- 重置 effect
--- 清空所有的旋转和缩放，重置为初始状态
---@param effect number
function japi.EXEffectMatReset(effect)
    return J.ExecJAPI("EXEffectMatReset", effect)
end

--- 特效绕X轴旋转
--- effect 绕X轴旋转 angle 度
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态
---@param effect number
---@param angle number float(3)
function japi.EXEffectMatRotateX(effect, angle)
    return J.ExecJAPI("EXEffectMatRotateX", effect, angle)
end

--- 特效绕Y轴旋转
--- effect 绕Y轴旋转 angle 度
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态
---@param effect number
---@param angle number float(3)
function japi.EXEffectMatRotateY(effect, angle)
    return J.ExecJAPI("EXEffectMatRotateY", effect, angle)
end

--- 特效绕Z轴旋转
--- effect 绕Z轴旋转 angle 度
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态
---@param effect number
---@param angle number float(3)
function japi.EXEffectMatRotateZ(effect, angle)
    return J.ExecJAPI("EXEffectMatRotateZ", effect, angle)
end

--- 缩放特效
--- 设置 effect 的X轴缩放，Y轴缩放，Z轴缩放
--- 多次调用，效果会叠加，不想叠加需要先重置为初始状态。设置为2,2,2时相当于大小变为2倍。设置为负数时，就是镜像翻转
---@param effect number
---@param x number float(3)
---@param y number float(3)
---@param z number float(3)
function japi.EXEffectMatScale(effect, x, y, z)
    return J.ExecJAPI("EXEffectMatScale", effect, x, y, z)
end

---@param script string
function japi.EXExecuteScript(script)
    return J.ExecJAPI("EXExecuteScript", script)
end

---@param abil number ability
---@param level number integer
---@param dataType number integer
---@return number integer
function japi.EXGetAbilityDataInteger(abil, level, dataType)
    return J.ExecJAPI("EXGetAbilityDataInteger", abil, level, dataType)
end

---@param abil number ability
---@param level number integer
---@param dataType number integer
---@return number float
function japi.EXGetAbilityDataReal(abil, level, dataType)
    return J.ExecJAPI("EXGetAbilityDataReal", abil, level, dataType)
end

---@param abil number ability
---@param level number integer
---@param dataType number integer
---@return string
function japi.EXGetAbilityDataString(abil, level, dataType)
    return J.ExecJAPI("EXGetAbilityDataString", abil, level, dataType)
end

---@param abil number ability
---@return number integer
function japi.EXGetAbilityId(abil)
    return J.ExecJAPI("EXGetAbilityId", abil)
end

---@param abil number ability
---@param stateType number integer
---@return number float
function japi.EXGetAbilityState(abil, stateType)
    return J.ExecJAPI("EXGetAbilityState", abil, stateType)
end

function japi.EXGetAbilityString(...)
    return J.ExecJAPI("EXGetAbilityString", ...)
end

---@param buffCode number integer
---@param dataType number integer
---@return string
function japi.EXGetBuffDataString(buffCode, dataType)
    return J.ExecJAPI("EXGetBuffDataString", buffCode, dataType)
end

--- 获取特效大小
---@param effect number
---@return number float
function japi.EXGetEffectSize(effect)
    return J.ExecJAPI("EXGetEffectSize", effect)
end

--- 获取特效X轴坐标
---@param effect number
---@return number float
function japi.EXGetEffectX(effect)
    return J.ExecJAPI("EXGetEffectX", effect)
end

--- 获取特效Y轴坐标
---@param effect number
---@return number float
function japi.EXGetEffectY(effect)
    return J.ExecJAPI("EXGetEffectY", effect)
end

--- 获取特效Z轴坐标
---@param effect number
---@return number float
function japi.EXGetEffectZ(effect)
    return J.ExecJAPI("EXGetEffectZ", effect)
end

---@param eddType number integer
---@return number integer
function japi.EXGetEventDamageData(eddType)
    return J.ExecJAPI("EXGetEventDamageData", eddType)
end

---@param itemCode number integer
---@param dataType number integer
---@return string
function japi.EXGetItemDataString(itemCode, dataType)
    return J.ExecJAPI("EXGetItemDataString", itemCode, dataType)
end

---@param whichUnit number
---@param abilityID number string|integer
function japi.EXGetUnitAbility(whichUnit, abilityID)
    return J.ExecJAPI("EXGetUnitAbility_", whichUnit, abilityID)
end

---@param whichUnit number
---@param index number integer
function japi.EXGetUnitAbilityByIndex(whichUnit, index)
    return J.ExecJAPI("EXGetUnitAbilityByIndex", whichUnit, index)
end

function japi.EXGetUnitArrayString(...)
    return J.ExecJAPI("EXGetUnitArrayString", ...)
end

function japi.EXGetUnitInteger(...)
    return J.ExecJAPI("EXGetUnitInteger", ...)
end

function japi.EXGetUnitReal(...)
    return J.ExecJAPI("EXGetUnitReal", ...)
end

function japi.EXGetUnitString(...)
    return J.ExecJAPI("EXGetUnitString", ...)
end

---@param whichUnit number
---@param enable boolean
function japi.EXPauseUnit(whichUnit, enable)
    return J.ExecJAPI("EXPauseUnit", whichUnit, enable)
end

function japi.EXSetAbilityAEmeDataA(...)
    return J.ExecJAPI("EXSetAbilityAEmeDataA", ...)
end

function japi.EXSetAbilityDataInteger(...)
    return J.ExecJAPI("EXSetAbilityDataInteger", ...)
end

function japi.EXSetAbilityDataReal(...)
    return J.ExecJAPI("EXSetAbilityDataReal", ...)
end

function japi.EXSetAbilityDataString(...)
    return J.ExecJAPI("EXSetAbilityDataString", ...)
end

---@param ability number
---@param stateType number integer
---@param value number floor(3)
function japi.EXSetAbilityState(ability, stateType, value)
    return J.ExecJAPI("EXSetAbilityState", ability, stateType, value)
end

function japi.EXSetAbilityString(...)
    return J.ExecJAPI("EXSetAbilityString", ...)
end

---@param buffCode number integer
---@param dataType number integer
---@param value string
function japi.EXSetBuffDataString(buffCode, dataType, value)
    return J.ExecJAPI("EXSetBuffDataString", buffCode, dataType, value)
end

--- 设置特效大小
---@param e number
---@param size number float(3)
function japi.EXSetEffectSize(e, size)
    return J.ExecJAPI("EXSetEffectSize", e, size)
end

--- 设置特效动画速度
---@param e number
---@param speed number float(5)
function japi.EXSetEffectSpeed(e, speed)
    return J.ExecJAPI("EXSetEffectSpeed", e, speed)
end

--- 移动特效到坐标
---@param e number
---@param x number float(3)
---@param y number float(3)
function japi.EXSetEffectXY(e, x, y)
    return J.ExecJAPI("EXSetEffectXY", e, x, y)
end

---设置特效高度
---@param e number
---@param z number float(3)
function japi.EXSetEffectZ(e, z)
    return J.ExecJAPI("EXSetEffectZ", e, z)
end

---@param amount number float(3)
---@return boolean
function japi.EXSetEventDamage(amount)
    return J.ExecJAPI("EXSetEventDamage", amount)
end

---@param itemCode number integer
---@param dataType number integer
---@param value string
---@return boolean
function japi.EXSetItemDataString(itemCode, dataType, value)
    return J.ExecJAPI("EXSetItemDataString", itemCode, dataType, value)
end

function japi.EXSetUnitArrayString(...)
    return J.ExecJAPI("EXSetUnitArrayString", ...)
end

--- 设置单位的碰撞类型
--- 启用/禁用 单位u 对 t 的碰撞
---@param enable boolean
---@param u number
---@param t number integer 碰撞类型，参考blizzard:^COLLISION_TYPE
function japi.EXSetUnitCollisionType(enable, u, t)
    return J.ExecJAPI("EXSetUnitCollisionType", enable, u, t)
end

--- 设置单位面向角度
--- 立即转身
---@param u number
---@param angle number float(2)
function japi.EXSetUnitFacing(u, angle)
    return J.ExecJAPI("EXSetUnitFacing", u, angle)
end

function japi.EXSetUnitInteger(...)
    return J.ExecJAPI("EXSetUnitInteger", ...)
end

--- 设置单位的移动类型
---@param u number
---@param t number integer 移动类型，参考blizzard:^MOVE_TYPE
function japi.EXSetUnitMoveType(u, t)
    return J.ExecJAPI("EXSetUnitMoveType", u, t)
end

function japi.EXSetUnitReal(...)
    return J.ExecJAPI("EXSetUnitReal", ...)
end

function japi.EXSetUnitString(...)
    return J.ExecJAPI("EXSetUnitString", ...)
end

--- 伤害值
---@return number
function japi.GetEventDamage()
    return J.ExecJAPI("GetEventDamage")
end

---@param whichUnit number
---@param state number unitstate
---@return number
function japi.GetUnitState(whichUnit, state)
    return J.ExecJAPI("GetUnitState", whichUnit, state)
end

---@param dataType number integer
---@param whichPlayer number
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return boolean
function japi.RequestExtraBooleanData(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return J.ExecJAPI("RequestExtraBooleanData", dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
end

---@param dataType number integer
---@param whichPlayer number
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return number integer
function japi.RequestExtraIntegerData(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return J.ExecJAPI("RequestExtraIntegerData", dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
end

---@param dataType number integer
---@param whichPlayer number
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return number
function japi.RequestExtraRealData(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return J.ExecJAPI("RequestExtraRealData", dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
end

---@param dataType number integer
---@param whichPlayer number
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 number integer
---@param param5 number integer
---@param param6 number integer
---@return string
function japi.RequestExtraStringData(dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
    return J.ExecJAPI("RequestExtraStringData", dataType, whichPlayer, param1, param2, param3, param4, param5, param6)
end

--- 设置单位属性
---@param whichUnit number
---@param state number unitstate
---@param value number
function japi.SetUnitState(whichUnit, state, value)
    J.ExecJAPI("SetUnitState_", whichUnit, state, value)
end

--------------------------------------------------------------------------

--- 玩家是否平台VIP
---@param whichPlayer number
---@return boolean
function japi.DzAPI_Map_IsPlatformVIP(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_IsPlatformVIP_", whichPlayer)
end

--- 天梯提交玩家排名
---@param whichPlayer number
---@param value number
function japi.DzAPI_Map_Ladder_SubmitPlayerRank(whichPlayer, value)
    return J.ExecJAPI("DzAPI_Map_Ladder_SubmitPlayerRank_", whichPlayer, value)
end

--- 天梯提交获得称号
---@param whichPlayer number
---@param value string
function japi.DzAPI_Map_Ladder_SubmitTitle(whichPlayer, value)
    return J.ExecJAPI("DzAPI_Map_Ladder_SubmitTitle_", whichPlayer, value)
end

--- 设置玩家额外分
---@param whichPlayer number
---@param value string
function japi.DzAPI_Map_Ladder_SubmitPlayerExtraExp(whichPlayer, value)
    return J.ExecJAPI("DzAPI_Map_Ladder_SubmitPlayerExtraExp_", whichPlayer, value)
end

--- 注册实时购买商品事件
--- 玩家在游戏中购买商城道具触发，可以配合打开商城界面使用，读取用实时购买玩家和实时购买商品
function japi.DzTriggerRegisterMallItemSyncData(trig)
    J.ExecJAPI("DzTriggerRegisterMallItemSyncData_", trig)
end

--- 全局存档变化事件
--- 本局游戏或其他游戏保存的全局存档都会触发这个事件，请使用[同步]分类下的获取同步数据来获得发生变化的全局存档KEY值
function japi.DzAPI_Map_Global_ChangeMsg(trig)
    J.ExecJAPI("DzAPI_Map_Global_ChangeMsg_", trig)
end

--- 判断是否是匹配模式
--- 判断玩家是否是通过匹配模式进入游戏
--- 具体模式ID使用 获取天梯和匹配的模式 获取
---@return boolean
function japi.DzAPI_Map_IsRPGQuickMatch()
    return J.ExecJAPI("DzAPI_Map_IsRPGQuickMatch_")
end

--- 获取商城道具数量
--- 获取玩家 key 商品剩余库存次数
--- 仅对次数消耗型商品有效
---@param whichPlayer number
---@param key string
---@return number integer
function japi.DzAPI_Map_GetMallItemCount(whichPlayer, key)
    return J.ExecJAPI("DzAPI_Map_GetMallItemCount_", whichPlayer, key)
end

--- 使用商城道具（次数型）
--- 使用玩家 key 商城道具 value 次
--- 仅对次数消耗型商品有效，只能使用不能恢复，请谨慎使用
---@param whichPlayer number
---@param key string
---@param value number integer
---@return boolean
function japi.DzAPI_Map_ConsumeMallItem(whichPlayer, key, value)
    return J.ExecJAPI("DzAPI_Map_ConsumeMallItem_", whichPlayer, key, value)
end

--- 修改平台功能设置
---@param whichPlayer number
---@param option number integer;1为锁定镜头距离、2为显示血、蓝条、3为智能施法
---@param enable boolean
---@return boolean
function japi.DzAPI_Map_EnablePlatformSettings(whichPlayer, option, enable)
    return J.ExecJAPI("DzAPI_Map_EnablePlatformSettings_", whichPlayer, option, enable)
end

--- 玩家是否购买了重制版
---@param whichPlayer number
---@return boolean
function japi.DzAPI_Map_IsBuyReforged(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_IsBuyReforged_", whichPlayer)
end

--- 获取玩家中游戏局数
---@param whichPlayer number
---@return number
function japi.DzAPI_Map_PlayedGames(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_PlayedGames_", whichPlayer)
end

--- 获取玩家的评论次数
--- 该功能已失效，始终返回1
---@param whichPlayer number
---@return number|1
function japi.DzAPI_Map_CommentCount(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_CommentCount_", whichPlayer)
end

--- 获取玩家平台好友数量
---@param whichPlayer number
---@return number
function japi.DzAPI_Map_FriendCount(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_FriendCount_", whichPlayer)
end

--- 玩家是鉴赏家
--- 评论里的鉴赏家
---@param whichPlayer number
---@return boolean
function japi.DzAPI_Map_IsConnoisseur(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_IsConnoisseur_", whichPlayer)
end

--- 玩家登录的是战网账号
---@param whichPlayer number
---@return boolean
function japi.DzAPI_Map_IsBattleNetAccount(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_IsBattleNetAccount_", whichPlayer)
end

--- 玩家是地图作者
---@param whichPlayer number
---@return boolean
function japi.DzAPI_Map_IsAuthor(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_IsAuthor_", whichPlayer)
end

--- 地图评论次数
--- 获取该图总评论次数
---@return number integer
function japi.DzAPI_Map_CommentTotalCount()
    return J.ExecJAPI("DzAPI_Map_CommentTotalCount_")
end

--- 获取自定义排行榜玩家排名
--- 100名以外的玩家排名为0
--- 该功能适用于作者之家-服务器存档-自定义排行榜
--- 等同 DzAPI_Map_CommentTotalCount1
---@param whichPlayer number
---@param id number integer
---@return number integer
function japi.DzAPI_Map_CustomRanking(whichPlayer, id)
    return J.ExecJAPI("DzAPI_Map_CustomRanking_", whichPlayer, id)
end

--- 玩家当前是平台回流用户
--- 超过7天未玩地图的用户再次登录被称为地图回流用户，地图回流BUFF会存在7天，7天后消失。平台回流用户的BUFF存在15天，15天后消失。建议设置奖励，鼓励玩家回来玩地图！
---@param whichPlayer number
---@return boolean
function japi.DzAPI_Map_IsPlatformReturn(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_IsPlatformReturn_", whichPlayer)
end

--- 玩家当前是地图回流用户
--- 超过7天未玩地图的用户再次登录被称为地图回流用户，地图回流BUFF会存在7天，7天后消失。平台回流用户的BUFF存在15天，15天后消失。建议设置奖励，鼓励玩家回来玩地图！
---@param whichPlayer number
---@return boolean
function japi.DzAPI_Map_IsMapReturn(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_IsMapReturn_", whichPlayer)
end

--- 玩家曾经是平台回流用户
--- 超过7天未玩地图的用户再次登录被称为地图回流用户，地图回流BUFF会存在7天，7天后消失。平台回流用户的BUFF存在15天，15天后消失。建议设置奖励，鼓励玩家回来玩地图！
---@param whichPlayer number
---@return boolean
function japi.DzAPI_Map_IsPlatformReturnUsed(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_IsPlatformReturnUsed_", whichPlayer)
end

--- 玩家曾经是地图回流用户
--- 超过7天未玩地图的用户再次登录被称为地图回流用户，地图回流BUFF会存在7天，7天后消失。平台回流用户的BUFF存在15天，15天后消失。建议设置奖励，鼓励玩家回来玩地图！
---@param whichPlayer number
---@return boolean
function japi.DzAPI_Map_IsMapReturnUsed(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_IsMapReturnUsed_", whichPlayer)
end

--- 玩家收藏过地图
---@param whichPlayer number
---@return boolean
function japi.DzAPI_Map_IsCollected(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_IsCollected_", whichPlayer)
end

--- 签到系统
--- 玩家每天登录游戏后，自动签到
---@param whichPlayer number
---@return number integer
function japi.DzAPI_Map_ContinuousCount(whichPlayer, id)
    return J.ExecJAPI("DzAPI_Map_ContinuousCount_", whichPlayer, id)
end

--- 玩家是真实玩家
--- 用于区别平台AI玩家。现在平台已经添加虚拟电脑玩家，不用再担心匹配没人问题了！如果你的地图有AI，试试在作者之家开启这个功能吧！
---@param whichPlayer number
---@return boolean
function japi.DzAPI_Map_IsPlayer(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_IsPlayer_", whichPlayer)
end

--- 所有地图的总游戏时长
---@param whichPlayer number
---@return number
function japi.DzAPI_Map_MapsTotalPlayed(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_MapsTotalPlayed_", whichPlayer)
end

--- 指定地图的地图等级
--- 可以在作者之家看到指定地图的id
---@param whichPlayer number
---@param mapId number integer
---@return number
function japi.DzAPI_Map_MapsLevel(whichPlayer, mapId)
    return J.ExecJAPI("DzAPI_Map_MapsLevel_", whichPlayer, mapId)
end

--- 指定地图的平台金币消耗
--- 可以在作者之家看到指定地图的id
---@param whichPlayer number
---@param mapId number integer
---@return number
function japi.DzAPI_Map_MapsConsumeGold(whichPlayer, mapId)
    return J.ExecJAPI("DzAPI_Map_MapsConsumeGold_", whichPlayer, mapId)
end

--- 指定地图的平台木头消耗
--- 可以在作者之家看到指定地图的id
---@param whichPlayer number
---@param mapId number integer
---@return number
function japi.DzAPI_Map_MapsConsumeLumber(whichPlayer, mapId)
    return J.ExecJAPI("DzAPI_Map_MapsConsumeLumber_", whichPlayer, mapId)
end

--- 指定地图消费在（1~199）区间
---@param whichPlayer number
---@param mapId number
---@return boolean
function japi.DzAPI_Map_MapsConsume_1_199(whichPlayer, mapId)
    return J.ExecJAPI("DzAPI_Map_MapsConsume_1_199_", whichPlayer, mapId)
end

--- 指定地图消费在（200~499）区间
---@param whichPlayer number
---@param mapId number
---@return boolean
function japi.DzAPI_Map_MapsConsume_200_499(whichPlayer, mapId)
    return J.ExecJAPI("DzAPI_Map_MapsConsume_200_499_", whichPlayer, mapId)
end

--- 指定地图消费在（500~999）区间
---@param whichPlayer number
---@param mapId number
---@return boolean
function japi.DzAPI_Map_MapsConsume_500_999(whichPlayer, mapId)
    return J.ExecJAPI("DzAPI_Map_MapsConsume_500_999_", whichPlayer, mapId)
end

--- 指定地图消费在（1000+）以上
---@param whichPlayer number
---@param mapId number
---@return boolean
function japi.DzAPI_Map_MapsConsume_1000(whichPlayer, mapId)
    return J.ExecJAPI("DzAPI_Map_MapsConsume_1000_", whichPlayer, mapId)
end

--- 获取论坛数据
--- 是否发过贴子,是否版主时，返回为1代表肯定
---@param whichPlayer number
---@param data number integer 0=累计获得赞数，1=精华帖数量，2=发表回复次数，3=收到的欢乐数，4=是否发过贴子，5=是否版主，6=主题数量
---@return boolean
function japi.DzAPI_Map_GetForumData(whichPlayer, data)
    return J.ExecJAPI("DzAPI_Map_GetForumData_", whichPlayer, data)
end

--- 游戏中弹出商城道具购买界面
--- 可以在游戏里打开指定商城道具购买界面（包括下架商品）,商品购买之后，请配合实时购买触发功能使用
---@param whichPlayer number
---@param key string
---@return boolean
function japi.DzAPI_Map_OpenMall(whichPlayer, key)
    return J.ExecJAPI("DzAPI_Map_OpenMall_", whichPlayer, key)
end

--- 玩家最近一次上安利墙时间
--- 获取玩家最近一次在当前地图的优质评论被推荐上安利墙的时间
---@param whichPlayer number
---@return number int 时间戳
function japi.DzAPI_Map_GetLastRecommendTime(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_GetLastRecommendTime_", whichPlayer)
end

--- 获取玩家在当前地图的宝箱累计抽取次数
---@param whichPlayer number
---@return number int
function japi.DzAPI_Map_GetLotteryUsedCount(whichPlayer)
    return J.ExecJAPI("DzAPI_Map_GetLotteryUsedCount_", whichPlayer)
end

--- 上报本局游戏玩家数据
--- 上报本局游戏的玩家数据，比如战斗力、杀敌数等。
--- 以下数据项 key 由平台统一定义，请勿随意自行上传：
--- RankIndex: 乱斗模式排名
--- InnerGameMode: 地图模式名称
--- GameResult: 游戏结果（上报后立即结束游戏），1=胜利，0=失败
--- GameResultNoEnd: 游戏结果（上报后不会立即结束游戏），1=胜利，0=失败
---@param whichPlayer number
---@param key string
---@param value string
---@return number int
function japi.DzAPI_Map_GameResult_CommitData(whichPlayer, key, value)
    return J.ExecJAPI("DzAPI_Map_GameResult_CommitData_", whichPlayer, key, value)
end

--- 本局游戏是否处于平台自测服
---@return boolean
function japi.DzAPI_Map_IsMapTest()
    return J.ExecJAPI("DzAPI_Map_IsMapTest_")
end

--------------------------------------------------------------------------

--- 读取游戏运行FPS
---@return number
function japi.FPS()
    return J.ExecJAPI("FPS_")
end

--- 读取玩家服务器存档成功
--- 如果返回false代表读取失败,反之成功,之后游戏里平台不会再发送“服务器保存失败”的信息，所以希望地图作者在游戏开始给玩家发下信息服务器存档是否正确读取。
---@param whichPlayer number
---@return boolean
function japi.ServerAlready(whichPlayer)
    return J.ExecJAPI("ServerAlready_", whichPlayer)
end

--- 保存服务器存档
---@param whichPlayer number
---@param key string
---@param value string
function japi.ServerSaveValue(whichPlayer, key, value)
    J.ExecJAPI("ServerSaveValue_", whichPlayer, key, value)
end

--- 获取服务器存档
---@param whichPlayer number
---@param key string
---@return any
function japi.ServerLoadValue(whichPlayer, key)
    return J.ExecJAPI("ServerLoadValue_", whichPlayer, key)
end

--- 设置房间显示的数据
--- 为服务器存档显示的数据，对应作者之家的房间key
---@param whichPlayer number
---@param key string
---@param value string
function japi.ServerSaveRoom(whichPlayer, key, value)
    J.ExecJAPI("ServerSaveRoom_", whichPlayer, key, value)
end

--- 获得游戏渲染的：离顶黑边高、离底黑边高、中间显示高、
---@return number,number,number
function japi.GetFrameBorders()
    return J.ExecJAPI("GetFrameBorders_")
end

--- 是否宽屏模式
---@return boolean
function japi.IsWideScreen()
    return J.ExecJAPI("IsWideScreen_")
end

--- 是物理伤害
--- 响应'受到伤害'单位事件,不能用在等待之后
---@return boolean
function japi.IsEventPhysicalDamage()
    return J.ExecJAPI("IsEventPhysicalDamage_")
end

--- 是攻击伤害
--- 响应'受到伤害'单位事件,不能用在等待之后
---@return boolean
function japi.IsEventAttackDamage()
    return J.ExecJAPI("IsEventAttackDamage_")
end

--- 是远程伤害
--- 响应'受到伤害'单位事件,不能用在等待之后
---@return boolean
function japi.IsEventRangedDamage()
    return J.ExecJAPI("IsEventRangedDamage_")
end

--- 单位所受伤害的伤害类型是 damageType
--- 响应'受到伤害'单位事件,不能用在等待之后
---@param damageType number 参考 blizzard:^DAMAGE_TYPE
---@return boolean
function japi.IsEventDamageType(damageType)
    return J.ExecJAPI("IsEventDamageType_", damageType)
end

--- 单位所受伤害的武器类型是 是 weaponType
--- 响应'受到伤害'单位事件,不能用在等待之后
---@param weaponType number 参考 blizzard:^WEAPON_TYPE
---@return boolean
function japi.IsEventWeaponType(weaponType)
    return J.ExecJAPI("IsEventWeaponType_", weaponType)
end

--- 单位所受伤害的攻击类型是 是 attackType
--- 响应'受到伤害'单位事件,不能用在等待之后
---@param attackType number 参考 blizzard:^ATTACK_TYPE
---@return boolean
function japi.IsEventAttackType(attackType)
    return J.ExecJAPI("IsEventAttackType_", attackType)
end

--- 玩家是否正在聊天框输入
---@return boolean
function japi.IsTyping()
    return J.ExecJAPI("IsTyping_")
end

--- 新建一个Tag索引
---@return string
function japi.FrameTagIndex()
    return J.ExecJAPI("FrameTagIndex_")
end

--- 获取某个坐标的Z轴高度
--- 可异步使用
---@param x number
---@param y number
---@return number
function japi.Z(x, y)
    return J.ExecJAPI("Z_", x, y)
end

--- X比例 转 像素
---@param x number
---@return number
function japi.PX(x)
    return J.ExecJAPI("PX_", x)
end

--- Y比例 转 像素
---@param y number
---@return number
function japi.PY(y)
    return J.ExecJAPI("PY_", y)
end

--- X像素 转 比例
---@param x number
---@return number
function japi.RX(x)
    return J.ExecJAPI("RX_", x)
end

--- Y像素 转 比例
---@param y number
---@return number
function japi.RY(y)
    return J.ExecJAPI("RY_", y)
end

--- 鼠标客户端内X像素
---@return number
function japi.MousePX()
    return J.ExecJAPI("MousePX_")
end

--- 鼠标客户端内Y像素
---@return number
function japi.MousePY()
    return J.ExecJAPI("MousePY_")
end

--- 鼠标X像素 转 比例
---@return number
function japi.MouseRX()
    return J.ExecJAPI("MouseRX_")
end

--- 鼠标Y像素 转 比例
---@return number
function japi.MouseRY()
    return J.ExecJAPI("MouseRY_")
end

--- 判断XY是否在客户端内
---@param rx number
---@param ry number
---@return boolean
function japi.InWindow(rx, ry)
    return J.ExecJAPI("InWindow_", rx, ry)
end

--- 判断鼠标是否在客户端内
---@return boolean
function japi.InWindowMouse()
    return J.ExecJAPI("InWindowMouse_")
end

--- 自适应frame大小
--- 以流行尺寸作为基准比例，以高为基准结合魔兽4:3计算自动调节宽度的自适应规则
---@param w number 宽
---@return number
function japi.FrameAdaptive(w)
    return J.ExecJAPI("FrameAdaptive_", w)
end

--- 自适应frame大小反算
--- 以流行尺寸作为基准比例，以高为基准结合魔兽4:3计算自动调节宽度的自适应规则
---@param w number 宽
---@return number
function japi.FrameDisAdaptive(w)
    return J.ExecJAPI("FrameDisAdaptive_", w)
end

--- 异步执行刷新
---@param key string
---@param callFunc function|nil
---@return void
function japi.Refresh(key, callFunc)
    return J.ExecJAPI("Refresh_", key, callFunc)
end