---@param this FrameBackdropTile
Class("FrameBackdropTile")
    .inherit("FrameCustom")
    .construct(
    function(_, options)
        options.fdfName = "SINGLUAR_BACKDROP_TILE"
        options.fdfType = "BACKDROP"
    end)
    .initial(
    function(this)
        this.texture("Singluar\\ui\\nil.tga")
    end)