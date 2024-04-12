package main

import (
	"fmt"
	"sl/cmd"
	"sl/lib"
)

func main() {
	singluarData := lib.GetSdkData()
	if len(singluarData.Args) < 2 {
		lib.ColorPrint(lib.FCRed, "无效操作！")
		return
	}
	switch singluarData.Args[1] {
	case "help":
		cmd.Help()
	case "new":
		cmd.New(singluarData)
	case "we":
		cmd.WE(singluarData)
	case "model":
		cmd.Model(singluarData)
	case "clear":
		cmd.Clear(singluarData)
	case "run":
		cmd.Run(singluarData)
	case "multi":
		cmd.Multi(singluarData)
	case "kill":
		cmd.Kill(singluarData)
	default:
		fmt.Println("命令: <" + singluarData.Args[1] + "> 不存在! 使用 'help' 查询帮助")
	}
}
