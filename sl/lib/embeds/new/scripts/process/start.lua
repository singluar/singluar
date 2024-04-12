local process = Process("start")

process.onStart(function(this)

    -- 调试自动去除迷雾
    Game().fog(not DEBUGGING).mark(not DEBUGGING)

    this.next("test")

end)
