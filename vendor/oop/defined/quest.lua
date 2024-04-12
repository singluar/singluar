---@param this Quest
Class("Quest")
    .construct(
    function(this, options)
        href(this, J.CreateQuest())
        PropChange(this, "key", "std", options.key, false)
        PropChange(this, "title", "std", options.title or "title", false)
        PropChange(this, "side", "std", options.side or "right", false)
        PropChange(this, "icon", "std", "ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp", false)
        PropChange(this, "content", "std", "", false)
        PropChange(this, "complete", "std", false, false)
        PropChange(this, "fail", "std", false, false)
        PropChange(this, "discover", "std", true, false)
    end)