package cmd

import (
	"fmt"
	"os"
	"os/exec"
	"sl/lib"
)

func WE(singluarData lib.SingluarData) {
	projectName := ProjectName(singluarData)
	if !ProjectExist(singluarData) {
		lib.Panic("项目" + projectName + "不存在")
	}
	w3xDir := singluarData.Temp + "/" + projectName
	w3xFire := singluarData.Temp + "/" + projectName + ".w3x"
	// 检查上一次we的修改数据是否未保存
	buoyFire := singluarData.Temp + "/" + projectName + "/.we"
	mtW := lib.GetModTime(w3xFire)
	mtB := lib.GetModTime(buoyFire)
	if mtW > mtB {
		// 如果地图文件比we打开时新（说明有额外保存过）把保存后的文件拆包并同步
		cmd := exec.Command(singluarData.W3x2lni+"/w2l.exe", "lni", w3xFire)
		_, err := cmd.Output()
		if err != nil {
			lib.Panic(err)
		}
		Backup(singluarData) // 以编辑器为主版本
		fmt.Println("同步完毕[检测到之前有过使用we命令进行地图保存行为，正在进行同步备份]")
	}
	_ = os.Remove(buoyFire)
	//
	Pickup(singluarData)
	cmd := exec.Command(singluarData.W3x2lni+"/w2l.exe", "obj", w3xDir, w3xFire)
	_, err := cmd.Output()
	if err != nil {
		lib.Panic(err)
	}
	lib.CopyFile(singluarData.Vendor+"/lni/.we", buoyFire)
	exes := []string{"worldeditydwe.exe"}
	if lib.ExeRunningQty(exes) > 0 {
		fmt.Println("提示：检测到已有WE开启中，如果你是重复调用了we命令，请保留一个进行修改!")
	}
	cmd = exec.Command(singluarData.WE+"/WE.exe", "-loadfile", w3xFire)
	_, err = cmd.Output()
	if err != nil {
		lib.Panic(err)
	}
	fmt.Println("WE正在配图并打开")
}
