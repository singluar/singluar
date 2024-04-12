package cmd

import (
	"fmt"
	"os"
	"os/exec"
	"sl/lib"
	"time"
)

func runTest(singluarData lib.SingluarData, mode string, w3xFire string, projectName string, times int) {
	cmd := exec.Command(singluarData.WE+"/bin/WEconfig.exe", "-launchwar3", "-loadfile", w3xFire)
	_ = cmd.Run()
	fmt.Println("尝试启动中")
	ticker := time.NewTicker(time.Second)
	fmt.Println(<-ticker.C)
	exes := []string{"war3.exe"}
	if lib.ExeRunningQty(exes) > 0 {
		lib.ColorPrint(lib.FCGreen, "War3已启动 "+singluarData.War3)
		if mode == "-h" {
			// hot update
			if singluarData.War3 != "" {
				singluarData.ProjectName = projectName
				lib.Hot(singluarData)
			}
		}
	} else {
		if times >= 3 {
			lib.ColorPrint(lib.FCRed, "War3启动失败，请检查环境")
			return
		} else {
			lib.ColorPrint(lib.FCYellow, "War3启动失败,1秒后再次重试")
		}
		time.Sleep(time.Second)
		runTest(singluarData, mode, w3xFire, projectName, times+1)
	}
}

func Run(singluarData lib.SingluarData) {
	projectName := ProjectName(singluarData)
	if !ProjectExist(singluarData) {
		if projectName != "" {
			lib.Panic("项目不存在：" + projectName)
		}
	}
	// mode
	cache := false
	mode := "-h"
	modeName := ""
	modeLni := "slk"
	if len(os.Args) >= 4 {
		if len(os.Args[3]) == 3 {
			mode = os.Args[3][0:2]
			if os.Args[3][2:3] == "~" {
				cache = true
			}
		} else if len(os.Args[3]) == 2 {
			mode = os.Args[3]
		}
	}
	if mode == "-t" {
		modeName = "_test"
		modeLni = "obj"
		cache = false
	} else if mode == "-h" {
		modeName = "_hot"
		modeLni = "obj"
	} else if mode == "-b" {
		modeName = "_build"
	} else if mode == "-d" {
		modeName = "_dist"
	} else if mode == "-r" {
		modeName = "_release"
	} else {
		lib.Panic("模式错误：" + mode)
	}
	temProjectDir := singluarData.Temp + "/" + projectName
	temProjectW3xFire := singluarData.Temp + "/" + projectName + ".w3x"
	runProjectDir := singluarData.Temp + "/" + modeName
	runProjectW3xFire := runProjectDir + "/" + modeName + ".w3x"
	if cache == false {
		buoyFire := singluarData.Temp + "/" + projectName + "/.we"
		mtW := lib.GetModTime(temProjectW3xFire)
		mtB := lib.GetModTime(buoyFire)
		if mtW > mtB {
			// If the map file is newer than when we opened
			// (it indicates that it has been saved additionally),
			// unpack and synchronize the saved file
			cmd := exec.Command(singluarData.W3x2lni+"/w2l.exe", "lni", temProjectW3xFire)
			_, err := cmd.Output()
			if err != nil {
				lib.Panic(err)
			}
			_ = os.Remove(buoyFire)
			lib.CopyFile(singluarData.Vendor+"/lni/.we", buoyFire)
			Backup(singluarData) // we
			fmt.Println("同步完毕[检测到有新的地图保存行为，以‘WE’为主版本]")
		} else {
			Pickup(singluarData) // project
			fmt.Println("同步完毕[检测到没有新的地图保存行为，以‘project’为主版本]")
		}
		// Copy a copy of the latest temporary file
		_ = os.RemoveAll(runProjectDir)
		lib.CopyPath(temProjectDir, runProjectDir)
		fmt.Println("构建完毕：" + modeName)

		// Adjust the code to support war3
		t1 := time.Now()
		War3(singluarData, modeName)
		fmt.Println("资源及代码处理完成，耗时：" + time.Since(t1).String())
		fmt.Println("准备打包地图")

		// Generate map
		t2 := time.Now()
		cmd := exec.Command(singluarData.W3x2lni+"/w2l.exe", modeLni, runProjectDir, runProjectW3xFire)
		_, err := cmd.Output()
		if err != nil {
			lib.Panic(err)
		}
		// Inspection mark
		fmt.Println(`打包地图完成[` + modeLni + `]，耗时` + time.Since(t2).String())
		if mode == "-t" {
			fmt.Println(`>>> 临时地图已生成，位置:` + runProjectW3xFire + ` <<<`)
			return
		}
	} else {
		// Generate map
		t2 := time.Now()
		cmd := exec.Command(singluarData.W3x2lni+"/w2l.exe", modeLni, runProjectDir, runProjectW3xFire)
		_, err := cmd.Output()
		if err != nil {
			lib.Panic(err)
		}
		fmt.Println(`使用最后一次[` + modeName + `]资源缓存`)
		fmt.Println(`打包地图完成[` + modeLni + `]，耗时` + time.Since(t2).String())
	}
	if singluarData.War3 != "" {
		_ = os.Remove(singluarData.War3 + "/slht.txt")
		_ = os.Remove(singluarData.War3 + "/slhc.txt")
		_ = os.Remove(singluarData.War3 + "/dz_w3_plugin.dll")
		_ = os.Remove(singluarData.War3 + "/version.dll")
		wtPath := singluarData.War3 + "/Maps/Test"
		if !lib.IsDir(wtPath) {
			_ = os.Mkdir(wtPath, os.ModePerm)
		}
	}
	fmt.Println("即将准备地图测试")
	exes := []string{"war3.exe"}
	if lib.ExeRunningQty(exes) > 0 {
		fmt.Println(">>> 请先关闭当前war3!!! <<<")
		return
	}
	// run
	runTest(singluarData, mode, runProjectW3xFire, projectName, 0)
}
