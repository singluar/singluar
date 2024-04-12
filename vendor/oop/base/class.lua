---@type table
Classes = Classes or {}

---@protected
---@param this Object
---@param name string
---@param method string
function CLink(this, name, method, ...)
    if (name == nil or method == nil) then
        return
    end
    return Class(name).public().get(method)(this, ...)
end

---@param name table|string
---@return Class
function Class(name)

    if (type(name) == "table") then
        name = name.__NAME__
    end
    if (type(name) ~= "string") then
        return
    end
    ---@class Class
    local this = Classes[name]
    if (this == nil) then
        this = {
            ---@private
            __NAME__ = name,
            ---@private
            __INHERIT__ = nil,
            ---@private
            __CONSTRUCT__ = nil,
            ---@private
            __INITIAL__ = nil,
            ---@private
            __PUBLIC__ = nil,
            ---@private
            __PRIVATE__ = nil,
            ---@private
            __FACADES__ = Array(),
            ---@private
            __DESTROY__ = nil,
            ---@private
            __EXEC__ = nil,
            ---@private
            __FORMATTER__ = nil,
            ---@private
            __LIMITER__ = nil,
        }
        Classes[name] = this

        ---@type fun():string
        this.name = function()
            return this.__NAME__
        end

        ---@type fun():Array
        this.facades = function()
            return this.__FACADES__
        end

        ---@type fun(modify:function):self
        this.inherit = function(modify)
            if (type(modify) == "string") then
                this.__INHERIT__ = modify
                return this
            end
            return this.__INHERIT__
        end

        ---@type fun(modify:function):self
        this.construct = function(modify)
            if (type(modify) == "function") then
                this.__CONSTRUCT__ = modify
                return this
            end
            return this.__CONSTRUCT__
        end

        ---@type fun(key:string,modify:fun(this:self,result:any):void):self|Array
        this.public = function(key, modify)
            if (type(key) == "string" and type(modify) == "function") then
                if (this.__PUBLIC__ == nil) then
                    this.__PUBLIC__ = Array()
                end
                this.__PUBLIC__.set(key, modify)
                return this
            end
            return this.__PUBLIC__
        end

        ---@type fun(key:string,modify:fun(this:self,result:any):void):self|Array
        this.private = function(key, modify)
            if (type(key) == "string" and type(modify) == "function") then
                if (this.__PRIVATE__ == nil) then
                    this.__PRIVATE__ = Array()
                end
                this.__PRIVATE__.set(key, modify)
                return this
            end
            return this.__PRIVATE__
        end

        ---@type fun(modify:function):self
        this.initial = function(modify)
            if (type(modify) == "function") then
                this.__INITIAL__ = modify
                return this
            end
            return this.__INITIAL__
        end

        ---@type fun(modify:function):self
        this.destroy = function(modify)
            if (type(modify) == "function") then
                this.__DESTROY__ = modify
                return this
            end
            return this.__DESTROY__
        end

        ---@type fun(key:string,modify:fun(this:self,result:any):void):self|Array
        this.exec = function(key, modify)
            if (type(key) == "string" and type(modify) == "function") then
                if (this.__EXEC__ == nil) then
                    this.__EXEC__ = Array()
                end
                this.__EXEC__.set(key, modify)
                return this
            end
            return this.__EXEC__
        end

        ---@type fun(key:string,modify:fun(value:number):number):self|table
        this.formatter = function(key, modify)
            if (type(key) == "string" and type(modify) == "function") then
                if (this.__FORMATTER__ == nil) then
                    this.__FORMATTER__ = {}
                end
                this.__FORMATTER__[key] = modify
                return this
            end
            return this.__FORMATTER__
        end

        ---@type fun(key:string,modify:fun(this:self,value:number):number):self|table
        this.limiter = function(key, modify)
            if (type(key) == "string" and type(modify) == "function") then
                if (this.__LIMITER__ == nil) then
                    this.__LIMITER__ = {}
                end
                this.__LIMITER__[key] = modify
                return this
            end
            return this.__LIMITER__
        end

    end

    return this
end