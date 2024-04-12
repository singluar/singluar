package cmd

import (
	"fmt"
	"os"
	"os/exec"
	"sl/lib"
	"strconv"
	"time"
)

func runMulti(singluarData lib.SingluarData, max int, cur int) {
	for i := cur; i <= max; i++ {
		cmd := exec.Command(singluarData.WE+"/bin/WEconfig.exe", "-launchwar3")
		_ = cmd.Run()
		fmt.Println("第" + strconv.Itoa(i) + "个魔兽尝试启动中")
	}
	ticker := time.NewTicker(time.Second)
	fmt.Println(<-ticker.C)
	exes := []string{"war3.exe"}
	cur = lib.ExeRunningQty(exes)
	if cur >= max {
		lib.ColorPrint(lib.FCGreen, "测试地图一般存放在 "+singluarData.War3+"\\Maps\\Test\\WorldEditTestMap.w3x ")
	} else {
		lib.ColorPrint(lib.FCRed, "部分启动失败，1秒后重试")
		time.Sleep(time.Second)
		runMulti(singluarData, max, cur+1)
	}
}

func Multi(singluarData lib.SingluarData) {
	max := 2
	if len(os.Args) == 3 {
		max, _ = strconv.Atoi(os.Args[2])
	}
	if max > 9 {
		max = 9
		fmt.Println("最大只支持9个客户端同时开启")
	}
	runMulti(singluarData, max, 1)
}
