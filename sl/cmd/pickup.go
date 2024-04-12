package cmd

import (
	"fmt"
	"io/fs"
	"os"
	"sl/lib"
)

func Pickup(singluarData lib.SingluarData) {
	projectName := ProjectName(singluarData)
	tempDir := singluarData.Temp + "/" + projectName
	w3xDir := singluarData.Projects + "/" + projectName + "/w3x"
	// Build project directory
	check := lib.IsDir(w3xDir + "/table")
	if !check {
		_ = os.Mkdir(w3xDir+"/table", fs.ModePerm)
	}
	// Check for temp
	if lib.IsDir(tempDir) == false {
		// If not, build a new temp
		lib.CopyPath(w3xDir+"/map", tempDir+"/map")
		fmt.Println("构建临时区[w3x(map)->map]")
		lib.CopyPath(w3xDir+"/table", tempDir+"/table")
		fmt.Println("构建临时区[w3x(table)->table]")
		lib.CopyPath(singluarData.Vendor+"/lni/w3x2lni", tempDir+"/w3x2lni")
		fmt.Println("构建临时区[lni(w3x2lni)->w3x2lni]")
		lib.CopyFile(singluarData.Vendor+"/lni/.w3x", tempDir+"/.w3x")
		fmt.Println("构建临时区[lni(.w3x)->.w3x]")
	}
	lniResource := singluarData.Vendor + "/lni/resource"
	// map
	_ = os.RemoveAll(tempDir + "/map/")
	lib.CopyPath(w3xDir+"/map", tempDir+"/map")
	_ = os.Remove(tempDir + "/map/war3mapMap.blp")
	fmt.Println("覆盖同步[w3x(map)->map]")
	// 物编ini判定
	if lib.GetModTime(w3xDir+"/table") > lib.GetModTime(tempDir+"/table") {
		_ = os.RemoveAll(tempDir + "/table")
		lib.CopyPath(w3xDir+"/table", tempDir+"/table")
		fmt.Println("更新同步[w3x(table)->table]")
	}
	// 资源覆盖
	_ = os.RemoveAll(tempDir + "/resource")
	lib.CopyPath(lniResource, tempDir+"/resource")
	fmt.Println("覆盖同步[lni(resource)->resource]")
	if lib.IsDir(w3xDir + "/resource") {
		lib.CopyPath(w3xDir+"/resource", tempDir+"/resource")
		fmt.Println("额外资源[w3x(resource)->resource]")
	}
	// 小地图判定
	if lib.GetModTime(w3xDir+"/war3mapMap.blp") > lib.GetModTime(tempDir+"/resource/war3mapMap.blp") {
		_ = os.Remove(tempDir + "/resource/war3mapMap.blp")
		lib.CopyFile(w3xDir+"/war3mapMap.blp", tempDir+"/resource/war3mapMap.blp")
		fmt.Println("更新同步[w3x(war3mapMap)->resource/war3mapMap]")
	}
}
