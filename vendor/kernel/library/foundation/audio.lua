--- 音效播放
---@param v Vcm|V3d|Bgm
---@param whichPlayer Player|nil
---@param optCall fun(this:Vcm|V3d|Bgm):void
---@return void
function audio(v, whichPlayer, optCall)
    local f = function()
        if (isObject(v, "Vcm") or isObject(v, "V3d") or isObject(v, "Vwp")) then
            if (type(optCall) == "function") then
                optCall(v)
            end
            v.play()
        end
    end
    if (isObject(whichPlayer, "Player")) then
        async.call(whichPlayer, f)
    else
        f()
    end
end
