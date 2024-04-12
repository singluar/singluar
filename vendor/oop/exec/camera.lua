---@param this Camera
---@param resultNum string
---@param resultUnit Unit
Class("Camera")
    .exec("farZ",
    function(_, resultNum)
        J.SetCameraField(CAMERA_FIELD_FARZ, resultNum, 0)
    end)
    .exec("zOffset",
    function(_, resultNum)
        J.SetCameraField(CAMERA_FIELD_ZOFFSET, resultNum, 0)
    end)
    .exec("fov",
    function(_, resultNum)
        J.SetCameraField(CAMERA_FIELD_FIELD_OF_VIEW, resultNum, 0)
    end)
    .exec("xTra",
    function(_, resultNum)
        J.SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, resultNum, 0)
    end)
    .exec("yTra",
    function(_, resultNum)
        J.SetCameraField(CAMERA_FIELD_ROLL, resultNum, 0)
    end)
    .exec("zTra",
    function(_, resultNum)
        J.SetCameraField(CAMERA_FIELD_ROTATION, resultNum, 0)
    end)
    .exec("distance",
    function(_, resultNum)
        J.SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, resultNum, 0)
    end)
    .exec("follow",
    function(_, resultUnit)
        J.SetCameraTargetController(resultUnit.__HANDLE__, 0, 0, false)
    end)