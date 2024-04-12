---@param this FrameModel
Class("FrameModel")

    .public("model",
    function(this, modify)
        if (modify) then
            modify = AModel(modify)
        end
        return this.prop("model", modify)
    end)

    .public("animate",
    function(this, animId, autoCast)
        if (animId and type(autoCast) == "boolean") then
            return this.prop("animate", { animId, autoCast })
        end
        return this.prop("animate")
    end)