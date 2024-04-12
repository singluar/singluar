local isDef = function(path)
    local i = string.find(path, ":")
    return i == 1
end

---@private
---@param _v{Name,Description,Tip,Ubertip,Hotkey,level,race,type,goldcost,lumbercost,manaN,regenMana,mana0,HP,regenHP,regenType,fmade,fused,stockStart,stockRegen,stockMax,sight,nsight,collision,modelScale,file,fileVerFlags,scaleBull,scale,selZ,selCircOnWater,red,green,blue,occH,maxPitch,maxRoll,impactZ,impactSwimZ,launchX,launchY,launchZ,launchSwimZ,unitSound,RandomSoundLabel,MovementSoundLabel,LoopingSoundFadeOut,LoopingSoundFadeIn,auto,abilList,Sellitems,Sellunits,Markitems,Builds,Buttonpos_1,Buttonpos_2,Art,Specialart,unitShadow,buildingShadow,shadowH,shadowW,shadowX,shadowY,shadowOnWater,death,deathType,movetp,moveHeight,moveFloor,spd,maxSpd,minSpd,turnRate,acquire,minRange,weapsOn,Missileart_1,Missilespeed_1,Missilearc_1,MissileHoming_1,targs1,atkType1,weapTp1,weapType1,spillRadius1,spillDist1,damageLoss1,showUI1,backSw1,dmgpt1,rangeN1,RngBuff1,dmgplus1,dmgUp1,sides1,dice1,splashTargs1,cool1,Farea1,targCount1,Qfact1,Qarea1,Hfact1,Harea1,Missileart_2,Missilespeed_2,Missilearc_2,MissileHoming_2,targs2,atkType2,weapTp2,weapType2,spillRadius2,spillDist2,damageLoss2,showUI2,backSw2,dmgpt2,rangeN2,RngBuff2,dmgplus2,dmgUp2,sides2,dice2,splashTargs2,cool2,Farea2,targCount2,Qfact2,Qarea2,Hfact2,Harea2,defType,defUp,def,armor,targType,Propernames,nameCount,Awakentip,Revivetip,Primary,STR,STRplus,AGI,AGIplus,INT,INTplus,heroAbilList,hideHeroMinimap,hideHeroBar,hideHeroDeathMsg,Requiresacount,Requires1,Requires2,Requires3,Requires4,Requires5,Requires6,Requires7,Requires8,Reviveat,buffRadius,buffType,Revive,Trains,Upgrade,requirePlace,preventPlace,requireWaterRadius,pathTex,uberSplat,nbrandom,nbmmlcon,canBuildOn,isBuildOn,tilesets,special,campaign,inEditor,dropItems,hostilePal,useClickHelper,tilesetSpecific,Requires,Requiresamount,DependencyOr,Researches,upgrades,EditorSuffix,Casterupgradename,Casterupgradetip,Castrerupgradeart,ScoreScreenIcon,animProps,Attachmentanimprops,Attachmentlinkprops,Boneprops,castpt,castbsw,blend,run,walk,propWin,orientInterp,teamColor,customTeamColor,elevPts,elevRad,fogRad,fatLOS,repulse,repulsePrio,repulseParam,repulseGroup,isbldg,bldtm,bountyplus,bountysides,bountydice,goldRep,lumberRep,reptm,lumberbountyplus,lumberbountysides,lumberbountydice,cargoSize,hideOnMinimap,points,prio,formation,canFlee,canSleep,_id_force,_class,_type,_parent,_attr}
_unit = function(_v)
    _v = _SET_UNIT(_v)
    _v._id = SLK_ID(_v)
    SLK_GO_SET(_v)
    return _v
end

---@private
---@param _v{checkDep,Requires,Requiresamount,Effectsound,Effectsoundlooped,EditorSuffix,Name,Untip,Unubertip,Tip,Ubertip,Researchtip,Researchubertip,Unorder,Orderon,Order,Orderoff,Unhotkey,Hotkey,Researchhotkey,UnButtonpos_1,UnButtonpos_2,Buttonpos_1,Buttonpos_2,Researchbuttonpos1,Researchbuttonpos2,Unart,Researchart,Art,SpecialArt,Specialattach,Missileart_1,Missilespeed_1,Missilearc_1,MissileHoming_1,LightningEffect,EffectArt,TargetArt,Targetattachcount,Targetattach,Targetattach1,Targetattach2,Targetattach3,Targetattach4,Targetattach5,Areaeffectart,Animnames,CasterArt,Casterattachcount,Casterattach,Casterattach1,hero,item,race,levels,reqLevel,priority,BuffID,EfctID,Tip,Ubertip,targs,DataA,DataB,DataC,DataD,DataE,DataF,Cast,Cool,Dur,HeroDur,Cost,Rng,Area,_id_force,_class,_type,_parent,_desc,_attr,_ring,_remarks,_lv,_onSkillStudy,_onSkillEffect,_onRing}
_ability = function(_v)
    _v = _SET_ABILITY(_v)
    _v._id = SLK_ID(_v)
    SLK_GO_SET(_v)
    return _v
end

---@private
---@param _v{file,}
_destructable = function(_v)
    _v = _SET_DESTRUCTABLE(_v)
    _v._id = SLK_ID(_v)
    SLK_GO_SET(_v)
    return _v
end

function _assets_check(typ, path, alias)
    if (typ) then
        if (path) then
            local k = typ .. path
            if (GO_CHECK.path[k] == 1) then
                print("Duplicate path: <" .. typ .. ">" .. k)
            end
            GO_CHECK.path[k] = 1
        end
        if (alias) then
            local k = typ .. alias
            if (GO_CHECK.alias[k] == 1) then
                print("Duplicate alias: <" .. typ .. ">" .. k)
            end
            GO_CHECK.alias[k] = 1
        end
    end
end

_assets_selection = function(typeName)
    if (type(typeName) == "string") then
        GO_RESULT.selection = string.trim(typeName)
    end
end

_assets_font = function(ttfName)
    if (type(ttfName) == "string") then
        ttfName = string.trim(string.gsub(ttfName, "%.ttf", ""))
        GO_RESULT.font = ttfName
    end
end

_assets_loading = function(tga)
    if (type(tga) == "string") then
        tga = string.trim(string.gsub(tga, "%.tga", ""))
        GO_RESULT.loading = tga
    end
end

_assets_preview = function(tga)
    if (type(tga) == "string") then
        tga = string.trim(string.gsub(tga, "%.tga", ""))
        GO_RESULT.preview = tga
    end
end

_assets_icon = function(path, alias)
    if (path) then
        path = string.trim(string.gsub(path, "%.tga", ""))
        alias = alias or path
        if (not isDef(path)) then
            _assets_check("_assets_icon", path, alias)
            table.insert(GO_RESULT.icons, { path, alias })
        end
    end
end

_assets_model = function(path, alias, class, options)
    if (path) then
        class = class or "common"
        path = string.gsub(path, "%.mdx", "")
        path = string.gsub(path, "%.mdl", "")
        path = string.trim(path)
        alias = alias or path
        local _is = isDef(path)
        if (not _is) then
            _assets_check("_assets_model", path, alias)
            table.insert(GO_RESULT.model, { path, alias })
        else
            _assets_check("_assets_model", nil, alias)
        end
        if (class ~= "common") then
            options = options or {}
            if (options.Art ~= nil) then
                local pa = string.trim(string.gsub(options.Art, "%.tga", ""))
                local k = "_assets_icon" .. pa
                if (GO_CHECK.path[k] ~= 1) then
                    _assets_icon(options.Art)
                end
                if (isDef(options.Art)) then
                    options.Art = string.sub(options.Art, 2)
                else
                    options.Art = "war3mapIcon\\" .. string.replace(options.Art, "/", "\\", -1) .. ".tga"
                end
            end
            local file
            if (_is) then
                file = string.sub(path, 2)
            else
                file = "war3mapModel\\" .. alias .. ".mdl"
            end
            if (class == "unit") then
                local v = {
                    isDef = _is,
                    weapsOn = 1,
                    file = file,
                    Name = alias .. "|U",
                }
                _unit(table.merge(v, options))
            elseif (class == "item") then
                _unit(table.merge(options, {
                    isDef = _is,
                    _parent = "nbse",
                    targType = "item",
                    type = "",
                    collision = 0,
                    pathTex = "",
                    buildingShadow = "",
                    selCircOnWater = 1,
                    occH = 0,
                    uberSplat = "",
                    canFlee = 0,
                    campaign = 0,
                    weapsOn = 0,
                    file = file,
                    Name = alias .. "|I",
                    EditorSuffix = "",
                    abilList = "Avul",
                    movetp = "",
                    spd = 0,
                    sight = 100,
                    nsight = 100,
                    hideOnMinimap = 1,
                }))
            elseif (class == "destructable") then
                _destructable(table.merge(options, {
                    file = file,
                    portraitmodel = file,
                    Name = "　" .. alias .. "　",
                }))
            end
        end
    end
end

_assets_sound = function(path, alias, soundType)
    if (path) then
        path = string.trim(string.gsub(path, "%.mp3", ""))
        alias = alias or path
        _assets_check("_assets_sound", path, alias)
        table.insert(GO_RESULT.sound, { path, alias, soundType })
    end
end

_assets_ui = function(kit)
    if (kit) then
        _assets_check("_assets_ui", kit)
        table.insert(GO_RESULT.ui, kit)
    end
end