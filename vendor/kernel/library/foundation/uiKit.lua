---@c Array UI套件管理
UIKits = UIKits or Array()

---@return UIKit
function UIKit(kit)
    if (type(kit) ~= "string") then
        return
    end
    ---@class UIKit
    local this = UIKits.get(kit)
    if (this == nil) then
        this = {
            ---@private
            __NAME__ = "UIKit",
            ---@private
            _isRefreshing = false,
            ---@private
            _refresher = nil,
            ---@private
            _onSetup = nil,
            ---@private
            _onStart = nil,
            ---@private
            _onRefresh = nil,
            ---@private
            _stage = {},
            ---@private
            _frequency = nil,
        }
        ---@type fun():table
        this.stage = function()
            return this._stage
        end
        ---@alias noteUIKitCall fun()
        ---@type fun(callFunc:noteUIKitCall):self
        this.onSetup = function(callFunc)
            this._onSetup = callFunc
            if (this._isRefreshing == true) then
                this._onSetup()
            end
            return this
        end
        ---@type fun(callFunc:noteUIKitCall):self
        this.onStart = function(callFunc)
            this._onStart = callFunc
            if (this._isRefreshing == true) then
                this._onStart()
            end
            return this
        end
        ---@type fun(frequency:number,callFunc:noteUIKitCall):self
        this.onRefresh = function(frequency, callFunc)
            if (type(frequency) == "number") then
                this._frequency = frequency
            else
                this._frequency = 1
            end
            this._onRefresh = callFunc
            if (this._isRefreshing == true) then
                if (isObject(this._refresher, "Timer")) then
                    this._refresher.destroy()
                end
                this._refresher = time.setInterval(this._frequency, function()
                    this._onRefresh()
                end)
            end
        end

        this.setup = function()
            if (type(this._onSetup) == "function") then
                this._onSetup()
            end
        end

        this.start = function()
            if (type(this._onStart) == "function") then
                this._onStart()
            end
            if (type(this._onRefresh) == "function") then
                this._onRefresh()
                this._refresher = time.setInterval(this._frequency, function()
                    this._onRefresh()
                end)
            end
            this._isRefreshing = true
        end

        UIKits.set(kit, this)
    end
    return this
end