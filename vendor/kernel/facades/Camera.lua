---@class Camera:Object
---@return Camera
function Camera()
    return Object("Camera", {
        protect = true,
        static = { "Game", "Camera" },
    })
end