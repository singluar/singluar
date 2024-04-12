---@param this Quest
---@param resultStr string
---@param resultBool boolean
Class("Quest")
    .exec("title",
    function(this, resultStr)
        J.QuestSetTitle(this.__HANDLE__, resultStr)
    end)
    .exec("icon",
    function(this, resultStr)
        J.QuestSetIconPath(this.__HANDLE__, AIcon(resultStr))
    end)
    .exec("side",
    function(this, resultStr)
        local questType
        if (resultStr == "left") then
            questType = BJ_QUESTTYPE_REQ_DISCOVERED
        elseif (resultStr == "right") then
            questType = BJ_QUESTTYPE_OPT_DISCOVERED
        end
        if (questType ~= nil) then
            local required = questType == BJ_QUESTTYPE_REQ_DISCOVERED or questType == BJ_QUESTTYPE_REQ_UNDISCOVERED
            local discovered = questType == BJ_QUESTTYPE_REQ_DISCOVERED or questType == BJ_QUESTTYPE_OPT_DISCOVERED
            J.QuestSetRequired(this.__HANDLE__, required)
            J.QuestSetDiscovered(this.__HANDLE__, discovered)
        end
    end)
    .exec("content",
    function(this, resultStr)
        J.QuestSetDescription(this.__HANDLE__, resultStr)
    end)
    .exec("complete",
    function(this, resultStr)
        J.QuestSetCompleted(this.__HANDLE__, resultStr)
    end)
    .exec("fail",
    function(this, resultBool)
        J.QuestSetFailed(this.__HANDLE__, resultBool)
    end)
    .exec("discover",
    function(this, resultBool)
        J.QuestSetDiscovered(this.__HANDLE__, resultBool)
    end)