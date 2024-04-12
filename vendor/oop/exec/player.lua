---@param this Player
---@param resultStr string
---@param resultNum number
Class("Player")
    .exec("name",
    function(this, resultStr)
        J.SetPlayerName(this.__HANDLE__, resultStr)
    end)
    .exec("teamColor",
    function(this, resultNum)
        J.SetPlayerColor(this.__HANDLE__, PLAYER_COLOR[resultNum])
        group.forEach({
            key = "Unit",
            func = function(enumUnit)
                return enumUnit.isAlive() and this.id() == enumUnit.owner().id()
            end
        }, function(enumUnit)
            enumUnit.teamColor(resultNum)
        end)
    end)