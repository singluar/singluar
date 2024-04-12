--- 热更新
SLHT = function()
    local create = function(name)
        if package.loaded[name] ~= nil then
            return
        end
        local status, err = xpcall(require, debug.traceback, name)
        if (status ~= true) then
            print("[HOT]err: " .. err)
        else
            print("[HOT]load: " .. name)
        end
    end
    local reload = function(name)
        if package.loaded[name] then
            package.loaded[name] = nil
        end
        local status, err = xpcall(require, debug.traceback, name)
        if (status ~= true) then
            print("[HOT]err: " .. err)
        else
            print("[HOT]reload: " .. name)
            if (string.subPos(name, "oop.method.") == 1) then
                local o = string.replace(name, "oop.method.", "")
                local c = Class(o)
                if (c ~= nil) then
                    c.facades().forEach(function(id, _)
                        Method(i2o(id), o)
                    end)
                end
            end
        end
    end
    local slhc = function()
        local cr, err1 = io.open("slhc.txt", 'r+')
        if (err1 == nil) then
            local str = cr:read('a')
            cr:close()
            if (string.len(str) > 0) then
                local strs = string.explode('|', str)
                for _, s in ipairs(strs) do
                    create(s)
                end
            end
        end
    end
    local slht = function()
        local rl, err2 = io.open("slht.txt", 'r+')
        if (err2 == nil) then
            local str = rl:read('a')
            rl:close()
            rl, _ = io.open("slht.txt", 'w')
            rl:close()
            if (string.len(str) > 0) then
                local strs = string.explode('|', str)
                for _, s in ipairs(strs) do
                    reload(s)
                end
            end
        end
    end
    slhc()
    time.setInterval(1, function()
        slhc()
        slht()
    end)
end
Game().onEvent(EVENT.Game.Start, "SLHT", function() SLHT() end)