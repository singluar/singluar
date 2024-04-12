package cmd

import (
	"fmt"
	"io/fs"
	"os"
	"sl/lib"
)

func New(singluarData lib.SingluarData) {
	projectName := ProjectName(singluarData)
	if projectName == "" {
		lib.Panic("不允许存在空名称项目")
	}
	if ProjectExist(singluarData) {
		lib.Panic("已存在同名项目，你可以输入“run " + projectName + "”命令直接测试，或者请使用其他名称")
	}
	var err error
	// if not projects build
	check := lib.IsDir(singluarData.Projects)
	if !check {
		err = os.Mkdir(singluarData.Projects, fs.ModePerm)
		if err != nil {
			lib.Panic(err)
		}
	}
	// build
	projectDir := singluarData.Projects + "/" + projectName
	err = os.Mkdir(projectDir, fs.ModePerm)
	// copy
	lib.CopyPath(singluarData.Vendor+"/lni/map", projectDir+"/w3x/map")
	lib.CopyPath(singluarData.Vendor+"/lni/table", projectDir+"/w3x/table")
	lib.CopyFile(singluarData.Vendor+"/lni/war3mapMap.blp", projectDir+"/w3x/war3mapMap.blp")
	// init
	lib.CopyPathEmbed(singluarData.Embeds, "embeds/new", projectDir)
	// backup
	Backup(singluarData)
	fmt.Println("项目创建完成！")
	fmt.Println("你可以输入“we " + projectName + "”编辑地图信息")
	fmt.Println("或可以输入“run " + projectName + "”命令直接调试")
}
