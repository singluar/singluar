---@private
---@return {_id}
_unit = function(_v) SINGLUAR_SETTING(_SET_UNIT(_v)) end

---@private
---@return {_id}
_ability = function(_v) SINGLUAR_SETTING(_SET_ABILITY(_v)) end

---@private
---@return {_id}
_destructable = function(_v) SINGLUAR_SETTING(_SET_DESTRUCTABLE(_v)) end

--- 只支持组件包
---@type fun(typeName:string):void
_assets_selection = function(typeName) end

--- 只支持ttf
---@type fun(ttfName:string):void
_assets_font = function(ttfName) end

--- 只支持tga
---@type fun(tga:string):void
_assets_loading = function(tga) end

--- 只支持tga
---@type fun(tga:string):void
_assets_preview = function(tga) end

--- 原生首符号加:冒号
--- 只支持tga
---@type fun(path:string, alias:string|nil):void
_assets_icon = function(path, alias)
    if (path) then
        path = string.trim(string.gsub(path, "%.tga", ""))
        alias = alias or path
        SINGLUAR_ICON[alias] = path
    end
end

--- 原生首符号加:冒号
--- 只支持mdx,自动贴图路径必须war3mapTextures开头，文件放入assets/war3mapTextures内
---@alias noteAssetsModelUnitOptions {unitSound:string,scale:number,modelScale:number,dmgpt1:number,backSw1:number,movetp:string,moveHeight:number,sight:number,cool1:number,targs1:string,Art:string}
---@alias noteAssetsModelItemOptions {unitSound:string,scale:number,modelScale:number,Art:string,movetp:string,moveHeight:number,sight:number}
---@alias noteAssetsModelDestOptions {fogVis:number,showInMM:number,occH:number,colorR:number,colorG:number,colorB:number,minScale:number,maxScale:number,numVal:number,selectable:boolean}
---@type fun(path:string, alias:string|nil, class:string|nil|"'unit'"|"'item'"|"'destructable'", options:noteAssetsModelUnitOptions|noteAssetsModelItemOptions|noteAssetsModelDestOptions):void
_assets_model = function(path, alias, class, options)
    if (path) then
        class = class or "common"
        path = string.gsub(path, "%.mdx", "")
        path = string.gsub(path, "%.mdl", "")
        path = string.trim(path)
        alias = alias or path
        SINGLUAR_MODEL[alias] = path
        if (class == "unit") then
            options = options or {}
            if (options.Art ~= nil) then
                local pa = string.trim(string.gsub(options.Art, "%.tga", ""))
                if (SINGLUAR_ICON[pa] == nil) then
                    _assets_icon(options.Art)
                end
            end
            _unit({})
            SINGLUAR_MODEL_U[alias] = path
        elseif (class == "item") then
            options = options or {}
            if (options.Art ~= nil) then
                local pa = string.trim(string.gsub(options.Art, "%.tga", ""))
                if (SINGLUAR_ICON[pa] == nil) then
                    _assets_icon(options.Art)
                end
            end
            _unit({})
            SINGLUAR_MODEL_I[alias] = path
        elseif (class == "destructable") then
            _destructable({})
            SINGLUAR_MODEL_D[alias] = path
        end
    end
end

--- 不支持原生音频！
--- 只支持mp3，不建议使用推荐以外其他规格否则质量下降且有可能无法播放
--- 音效荐：48000HZ 192K 单
--- 音乐荐：48000HZ 320K 单
---@type fun(path:string, alias:string|nil, soundType:string | "vcm"| "v3d" | "bgm" | "vwp"):void
_assets_sound = function(path, alias, soundType)
    if (path) then
        path = string.trim(string.gsub(path, "%.mp3", ""))
        alias = alias or path
        SINGLUAR_SOUND[soundType][alias] = path
    end
end

--- 只支持UI套件
--- UI套件需按要求写好才能被正确调用！
---@type fun(kit:string):void
_assets_ui = function(kit) end
