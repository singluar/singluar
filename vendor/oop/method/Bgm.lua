---@param this Bgm
Class("Bgm")

    .public("isPlaying",
    function(this)
        return this.prop("currentMusic") ~= nil and this.prop("currentMusic") ~= ""
    end)

    .public("volume",
    function(this, modify)
        return this.prop("volume", modify)
    end)

    .public("stop",
    function(this)
        this.prop("currentMusic", "")
    end)

    .public("play",
    function(this, musicAlias)
        musicAlias = ABgm(musicAlias)
        if (musicAlias == nil) then
            return
        end
        this.prop("currentMusic", musicAlias)
    end)