package cmd

import (
	"fmt"
	"os/exec"
	"path/filepath"
	"sl/lib"
)

func Kill(singluarData lib.SingluarData) {
	bat, err := filepath.Abs(singluarData.WE + "/bin/kill.bat")
	if err != nil {
		lib.Panic(err)
	}
	cmd := exec.Command(bat)
	err = cmd.Run()
	if err != nil {
		lib.Panic(err)
	}
	fmt.Println("已尝试关闭所有魔兽客户端")
}
