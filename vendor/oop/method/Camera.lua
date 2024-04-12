---@param this Camera
Class("Camera")

    .public("x",
    function()
        return J.GetCameraTargetPositionX()
    end)
    .public("y",
    function()
        return J.GetCameraTargetPositionY()
    end)
    .public("z",
    function()
        return J.GetCameraTargetPositionZ()
    end)

    .public("isShaking",
    function(this)
        return this.superposition("shake") > 0
    end)

    .public("isQuaking",
    function(this)
        return this.superposition("quake") > 0
    end)

    .public("reset",
    function(this, duration)
        J.CameraSetSourceNoise(0, 0)
        J.CameraSetTargetNoise(0, 0)
        J.ResetToGameCamera(duration)
        return this
    end)

    .public("spacePosition",
    function(_, x, y)
        J.SetCameraQuickPosition(x, y)
    end)

    .public("to",
    function(_, x, y, duration)
        duration = duration or 0
        J.PanCameraToTimed(x, y, duration)
    end)

    .public("farZ",
    function(this, modify)
        local v = J.GetCameraField(CAMERA_FIELD_FARZ)
        if (modify) then
            PropChange(this, "farZ", "std", v, false)
            return this.prop("farZ", modify)
        end
        return v
    end)

    .public("zOffset",
    function(this, modify)
        local v = J.GetCameraField(CAMERA_FIELD_ZOFFSET)
        if (modify) then
            PropChange(this, "zOffset", "std", v, false)
            return this.prop("zOffset", modify)
        end
        return v
    end)

    .public("fov",
    function(this, modify)
        local v = J.GetCameraField(CAMERA_FIELD_FIELD_OF_VIEW)
        if (modify) then
            PropChange(this, "fov", "std", v, false)
            return this.prop("fov", modify)
        end
        return math._r2d * v
    end)

    .public("xTra",
    function(this, modify)
        local v = J.GetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK)
        if (modify) then
            PropChange(this, "xTra", "std", v, false)
            return this.prop("xTra", modify)
        end
        return math._r2d * v
    end)

    .public("yTra",
    function(this, modify)
        local v = J.GetCameraField(CAMERA_FIELD_ROLL)
        if (modify) then
            PropChange(this, "yTra", "std", v, false)
            return this.prop("yTra", modify)
        end
        return math._r2d * v
    end)

    .public("zTra",
    function(this, modify)
        local v = J.GetCameraField(CAMERA_FIELD_ROTATION)
        if (modify) then
            PropChange(this, "zTra", "std", v, false)
            return this.prop("zTra", modify)
        end
        return math._r2d * v
    end)

    .public("distance",
    function(this, modify)
        local v = math.floor(J.GetCameraField(CAMERA_FIELD_TARGET_DISTANCE))
        if (modify) then
            PropChange(this, "distance", "std", v, false)
            return this.prop("distance", modify)
        end
        return v
    end)

    .public("follow",
    function(this, whichUnit)
        return this.prop("follow", whichUnit)
    end)

    .public("shake",
    function(this, magnitude, velocity, duration)
        magnitude = magnitude or 0
        velocity = velocity or 0
        duration = math.trunc(duration or 0, 2)
        if (magnitude <= 0 or velocity <= 0 or duration <= 0) then
            return
        end
        this.superposition("shake", "+=1")
        J.CameraSetTargetNoise(magnitude, velocity)
        time.setTimeout(duration, function()
            this.superposition("shake", "-=1")
            if (false == this.isShaking()) then
                J.CameraSetTargetNoise(0, 0)
            end
        end)
    end)

    .public("quake",
    function(this, magnitude, duration)
        magnitude = magnitude or 0
        duration = math.trunc(duration or 0, 2)
        if (magnitude <= 0 or duration <= 0) then
            return
        end
        local richter = magnitude
        if (richter > 5) then
            richter = 5
        end
        if (richter < 2) then
            richter = 2
        end
        this.superposition("quake", "+=1")
        J.CameraSetTargetNoiseEx(magnitude * 2, magnitude * (10 ^ richter), true)
        J.CameraSetSourceNoiseEx(magnitude * 2, magnitude * (10 ^ richter), true)
        time.setTimeout(duration, function()
            this.superposition("quake", "-=1")
            if (false == this.isQuaking()) then
                J.CameraSetSourceNoise(0, 0)
                if (false == this.isShaking()) then
                    J.CameraSetTargetNoise(0, 0)
                end
            end
        end)
    end)