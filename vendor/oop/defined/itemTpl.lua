---@param this ItemTpl
Class("ItemTpl")
    .construct(
    function(this, options)
        local modelAlias = this.prop("modelAlias")
        if (modelAlias == nil) then
            modelAlias = options.modelAlias
            PropChange(this, "modelAlias", "std", modelAlias, false)
        end
        local id = slk.n2i(modelAlias .. "|I")
        local uSlk = slk.i2v(id)
        local name = modelAlias
        PropChange(this, "modelId", "std", this.prop("modelId") or c2i(id), false)
        PropChange(this, "modelScale", "std", this.prop("modelScale") or math.trunc(uSlk.slk.modelScale or 1, 2), false)
        PropChange(this, "animateScale", "std", this.prop("animateScale") or 1, false)
        PropChange(this, "collision", "std", this.prop("collision") or math.floor(uSlk.slk.scale * 50), false)
        PropChange(this, "class", "std", this.prop("class") or name, false)
        PropChange(this, "name", "std", this.prop("name") or name, false)
        PropChange(this, "icon", "std", this.prop("icon") or uSlk.slk.Art or "Singluar\\ui\\default.tga", false)
        PropChange(this, "period", "std", this.prop("period") or -1, false)
        PropChange(this, "charges", "std", this.prop("charges") or 0, false)
        PropChange(this, "levelMax", "std", this.prop("levelMax") or 1, false)
        PropChange(this, "level", "std", this.prop("level") or 1, false)
        if (type(this.prop("instance")) ~= "boolean") then
            PropChange(this, "instance", "std", false, false)
        end
        if (type(this.prop("consumable")) ~= "boolean") then
            PropChange(this, "consumable", "std", false, false)
        end
        if (type(this.prop("pawnable")) ~= "boolean") then
            PropChange(this, "pawnable", "std", true, false)
        end
        if (type(this.prop("dropable")) ~= "boolean") then
            PropChange(this, "dropable", "std", true, false)
        end
    end)
