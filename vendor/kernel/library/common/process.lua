---@type Array 流程空间
Processes = Processes or Array()
---@type Process
ProcessCurrent = ProcessCurrent or nil

---@return boolean
function isProcess(this)
    if (type(this) ~= "table") then
        return false
    end
    return this.__NAME__ == "Process"
end

---@return Process
function Process(name)
    if (type(name) ~= "string") then
        return
    end
    ---@class Process
    local this = Processes.get(name)
    if (this == nil) then
        this = {
            __NAME__ = "Process",
            __ID__ = bopID("Proc"),
            _name = name,
            _stage = Array(),
            _prev = nil,
            --
            _onStart = nil,
            _onActive = nil,
            _onOver = nil,
        }

        ---@type fun():string
        this.name = function()
            return this._name
        end

        ---@type fun(key:any, value:any):Array|any
        this.stage = function(key, value)
            if (key == nil and value == nil) then
                return this._stage
            end
            if (value == nil) then
                return this._stage.get(key)
            elseif (value == NIL) then
                value = nil
            end
            this._stage.set(key, value)
        end
        ---@type fun():Process|nil
        this.prev = function(process)
            if (process == nil) then
                return this._prev
            end
            this._prev = process
            return this
        end

        ---@type fun(callFunc:fun(this:Process)):self
        this.onStart = function(callFunc)
            this._onStart = callFunc
            return this
        end

        ---@type fun(callFunc:fun(this:Process)):self
        this.onOver = function(callFunc)
            this._onOver = callFunc
            return this
        end

        ---@type fun():void
        this.over = function()
            if (this == ProcessCurrent) then
                if (type(this._onOver) == "function") then
                    this._onOver(this)
                end
                ProcessCurrent = nil
            end
        end

        ---@type fun(nextStageName:string):void
        this.next = function(nextStageName)
            this.over()
            if (nextStageName ~= nil) then
                local n = Processes.get(nextStageName)
                if (n) then
                    n.prev(this)
                    this._stage.clone().forEach(function(key, value)
                        n._stage.set(key, value)
                    end)
                    n.start(this)
                end
            end
        end

        ---@type fun(nextStageName:string):self
        this.restart = function()
            this.over()
            this.start()
        end

        ---@type fun():void
        this.start = function()
            if (isProcess(ProcessCurrent)) then
                ProcessCurrent.over()
            end
            ProcessCurrent = this
            if (type(this._onStart) == "function") then
                this._onStart(this)
            end
        end

        Processes.set(name, this)
    end
    return this
end