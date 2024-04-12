--- 任务
Quest("gg")
    .title("主动投降")
    .side("right")
    .icon("ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp")
    .content("-gg 投降并退出")

Quest("apm")
    .title("查看你的APM数值")
    .side("right")
    .icon("ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp")
    .content("-apm 查看你的APM数值")

Quest("fov")
    .title("调整你的视距")
    .side("right")
    .icon("ReplaceableTextures\\CommandButtons\\BTNTomeOfRetraining.blp")
    .content({ "-d +[number] 增加视距", "-d -[number] 减少视距", "-d =[number] 设置视距" })