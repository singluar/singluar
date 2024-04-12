package cmd

import (
	"fmt"
	"os"
	"sl/lib"
)

func Clear(singluarData lib.SingluarData) {
	if singluarData.War3 != "" {
		_ = os.Remove(singluarData.War3 + "/dz_w3_plugin.ini")
		fmt.Println(`清理魔兽存档完毕`)
	}
	_ = os.RemoveAll(singluarData.Temp)
	fmt.Println(`清理临时区完毕`)
}
