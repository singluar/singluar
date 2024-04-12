---@param this Cursor
Class("Cursor")
    .initial(
    function(this)
        this.prop("childFollow", FrameBackdrop("SL_CursorFollow", FrameGameUI).show(false))
        this.prop("childAim", FrameBackdrop("SL_CursorAim", FrameGameUI).size(0.03, 0.04).show(false))
        this.prop("childArea", Image("Singluar\\ui\\nil.tga", 16, 16).show(false))
        this.prop("childSelection", Image("ReplaceableTextures\\Selection\\SelectionCircleLarge.blp", 72, 72).rgba(0, 255, 0, 255).show(false))
        this.prop("sizeRate", 0)
        this.prop("tooltips", function(obj)
            local str = {}
            if (isObject(obj, "Item")) then
                table.insert(str, obj.level() .. "级")
                table.insert(str, obj.name())
            end
            return {
                tips = string.implode("|n", str),
            }
        end)

        mouse.onMove("SL_CursorTooltips", function()
            local under = japi.DzGetUnitUnderMouse()
            local o = h2u(under)
            if (isObject(o, "Item")) then
                local rx = japi.MouseRX()
                local ry = japi.MouseRY()
                rx = japi.FrameDisAdaptive(rx)
                FrameTooltips(0)
                    .relation(FRAME_ALIGN_BOTTOM, FrameGameUI, FRAME_ALIGN_LEFT_BOTTOM, rx, ry + 0.024)
                    .content(this.tooltips()(o))
                    .show(true)
            else
                FrameTooltips(0).show(false)
            end
        end)
    end)