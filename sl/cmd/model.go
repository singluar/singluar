package cmd

import (
	"io/fs"
	"math"
	"os"
	"os/exec"
	"path/filepath"
	"regexp"
	"sl/lib"
	"strconv"
	"strings"
	"time"
)

var id int
var ids []string
var cvt36 string

func init() {
	id = 0
	cvt36 = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
}

func modelID() string {
	numStr := ""
	if id == 0 {
		numStr = "0"
	} else {
		i := id
		for {
			ii := i % 36
			i = i / 36
			numStr = cvt36[ii:ii+1] + numStr
			if i == 0 {
				break
			}
		}
	}
	l := len(numStr)
	if l == 3 {
		numStr = "m" + numStr
	} else if l == 2 {
		numStr = "m0" + numStr
	} else if l == 1 {
		numStr = "m00" + numStr
	}
	id += 1
	ids = append(ids, numStr)
	return numStr
}

func ModelMap(singluarData lib.SingluarData, class string, filter string, page int) {
	id = 0
	tempDir := singluarData.Temp + "/_model"
	tempPro := ""
	if strings.Index(class, "-p") == 0 {
		p2 := strings.Split(class, ":")
		if len(p2) != 2 {
			lib.ColorPrint(lib.FCRed, "-p参数 项目指向性错误")
			return
		}
		tempPro = p2[1]
	}
	if tempPro != "" {
		tempDir = tempDir + `/` + tempPro
		if filter != "" {
			tempDir = tempDir + `_` + filter
		}
	} else {
		if filter != "" {
			tempDir = tempDir + `/` + filter
		}
	}
	dstPath, _ := filepath.Abs(tempDir + "/resource")
	_ = os.RemoveAll(dstPath)
	var models []map[string]string
	count := 0
	checkTrouble := make(map[string]bool)
	batch := `<第` + strconv.Itoa(page+1) + `批>`
	if tempPro == "" {
		srcModelPath := singluarData.Pwd + "/assets/war3mapModel"
		srcTexturesPath := singluarData.Pwd + "/assets/war3mapTextures"
		if class == "-n" {
			srcModelPath = singluarData.Pwd + "/assetsNew/war3mapModel"
			srcTexturesPath = singluarData.Pwd + "/assetsNew/war3mapTextures"
		}
		if lib.IsDir(srcModelPath) {
			srcPath, _ := filepath.Abs(srcModelPath)
			err := filepath.Walk(srcModelPath, func(path string, info fs.FileInfo, err error) error {
				if err != nil {
					return err
				}
				pLen := len(path)
				if path[pLen-4:pLen] == ".mdx" {
					// 过滤
					if filter != "" {
						if strings.Index(path, filter) == -1 {
							return nil
						}
					}
					if count >= page*289 && count < (page+1)*289 {
						p := strings.Replace(path, srcPath+"\\", "", -1)
						lib.CopyFile(path, dstPath+"/war3mapModel/"+p)
						n := strings.Replace(p, ".mdx", "", -1)
						n = strings.Replace(n, "\\", "_", -1)
						p = strings.Replace(p, "\\", "\\\\", -1)
						m := make(map[string]string)
						m["id"] = modelID()
						m["name"] = n
						m["file"] = `war3mapModel\\` + p
						models = append(models, m)
						if checkTrouble[p] == false {
							checkTrouble[p] = true
						} else {
							lib.ColorPrint(lib.FCRed, "冲突："+m["file"]+" 已存在")
						}
					}
					count += 1
				}
				return nil
			})
			if err != nil {
				lib.Panic(err)
			}
		}
		if lib.IsDir(srcTexturesPath) {
			srcPath, _ := filepath.Abs(srcTexturesPath)
			err := filepath.Walk(srcTexturesPath, func(path string, info fs.FileInfo, err error) error {
				if err != nil {
					return err
				}
				pLen := len(path)
				if path[pLen-4:pLen] == ".blp" {
					p := strings.Replace(path, srcPath+"\\", "", -1)
					lib.CopyFile(path, dstPath+"/war3mapTextures/"+p)
				}
				return nil
			})
			if err != nil {
				lib.Panic(err)
			}
		}
	} else {
		projectAssetsPath := singluarData.Pwd + "/projects/" + tempPro + "/assets"
		if lib.IsDir(projectAssetsPath) {
			lib.ColorPrint(lib.FCBlue, batch+"Project:"+tempPro)
			srcPath, _ := filepath.Abs(projectAssetsPath)
			err := filepath.Walk(srcPath, func(path string, info fs.FileInfo, err error) error {
				if err != nil {
					return err
				}
				pLen := len(path)
				if path[pLen-4:pLen] == ".lua" {
					luaStr, _ := lib.FileGetContents(path)
					luaStr = strings.Replace(luaStr, "\r\n", "\n", -1)
					luaStr = strings.Replace(luaStr, "\r", "\n", -1)
					reg, _ := regexp.Compile("--(.*)\\[\\[[\\s\\S]*?\\]\\]")
					luaStr = reg.ReplaceAllString(luaStr, "")
					reg, _ = regexp.Compile("--(.*)")
					luaStr = reg.ReplaceAllString(luaStr, "")
					luaStrs := strings.Split(luaStr, "\n")
					for _, ls := range luaStrs {
						reg, _ = regexp.Compile(`(?ms)_assets_model\(\"(.*?)\"`)
						luaMs := reg.FindStringSubmatch(ls)
						if len(luaMs) >= 2 {
							// 过滤
							filterPass := (filter == "") || strings.Index(luaMs[1], filter) != -1
							if filterPass {
								res := strings.Replace(luaMs[1], "\\\\", "/", -1)
								name := ""
								file := ""
								if count >= page*289 && count < (page+1)*289 {
									if res[0:1] == ":" {
										name = res[1:]
										file = name
									} else {
										name = res
										file = `war3mapModel/` + name + `.mdx`
										modelFile := singluarData.Assets + `/` + file
										if lib.IsFile(modelFile) {
											lib.CopyFile(modelFile, dstPath+"/war3mapModel/"+name+".mdx")
											modelStr, _ := lib.FileGetContents(modelFile)
											modelStr = strings.Replace(modelStr, "\r", "", -1)
											reg, _ = regexp.Compile("(?i)war3mapTextures(.*?)(.blp)")
											textures := reg.FindAllString(modelStr, -1)
											if len(textures) > 0 {
												for _, t := range textures {
													t = strings.Replace(t, "war3mapTextures", "", -1)
													textureFile := singluarData.Assets + "/war3mapTextures" + t
													if lib.IsFile(textureFile) {
														lib.CopyFile(textureFile, dstPath+"/war3mapTextures"+t)
													} else {
														lib.ColorPrint(lib.FCRed, "失败【贴图】：文件不存在 "+t)
													}
												}
											}
										} else {
											lib.ColorPrint(lib.FCRed, "失败【模型】：文件不存在 "+name)
										}
									}
									name = strings.Replace(name, ".mdx", "", -1)
									name = strings.Replace(name, ".mdl", "", -1)
									name = strings.Replace(name, "/", "_", -1)
									file = strings.Replace(file, "/", "\\\\", -1)
									m := make(map[string]string)
									m["id"] = modelID()
									m["name"] = name
									m["file"] = file
									models = append(models, m)
									if checkTrouble[file] == false {
										checkTrouble[file] = true
									} else {
										lib.ColorPrint(lib.FCRed, "冲突："+m["file"]+" 已存在")
									}
								}
								count += 1
							}
						}
					}
				}
				return nil
			})
			if err != nil {
				lib.Panic(err)
			}
		}
	}
	if len(models) <= 0 {
		lib.ColorPrint(lib.FCLightGray, batch+"已无模型符合要求，停止处理")
		return
	}

	lib.ColorPrint(lib.FCPurple, batch+"开始构建虚构 "+filter)
	lib.CopyPath(singluarData.Vendor+"/lni/table", tempDir+"/table")
	lib.CopyPath(singluarData.Vendor+"/lni/w3x2lni", tempDir+"/w3x2lni")
	lib.CopyFile(singluarData.Vendor+"/lni/.w3x", tempDir+"/.w3x")
	lib.CopyPath(singluarData.Vendor+"/models", tempDir+"/map")
	lib.CopyFile(singluarData.Vendor+"/models/w3i.ini", tempDir+"/table/w3i.ini")

	unitIni := tempDir + "/table/unit.ini"
	unitIniContent := ""
	for _, v := range models {
		unitIniContent += "\n\n[" + v["id"] + "]\n_parent=\"nrwm\"\nfile=\"" + v["file"]
		unitIniContent += "\"\nName=\"" + v["id"] + ":" + v["name"] + "\"\nTip=\"" + v["name"] + "\""
		unitIniContent += "\nfused=0\nunitShadow=\"\"\nfmade=0\nrace=\"human\"\nmoveHeight=70"
		if strings.Contains(v["name"], "item_") {
			unitIniContent += "\nmodelScale=2.0"
		} else if strings.Contains(v["name"], "eff_") {
			unitIniContent += "\nmodelScale=0.75"
		} else {
			unitIniContent += "\nmodelScale=1.0"
		}
		if id%17 == 0 {
			unitIniContent += "\nArt=\"ReplaceableTextures\\\\CommandButtons\\\\BTNFootman.blp\""
		}
	}

	t1 := time.Now()
	allP := strconv.FormatFloat(math.Ceil(float64(count)/289), 'f', 0, 64)
	lib.ColorPrint(lib.FCGreen, batch+"已处理 "+strconv.Itoa(id)+"["+strconv.Itoa(page*289)+":"+strconv.Itoa((page+1)*289-1)+"]个模型，共"+allP+"批")
	err := lib.FilePutContents(unitIni, unitIniContent, fs.ModePerm)
	if err != nil {
		lib.Panic(err)
	}
	lib.ColorPrint(lib.FCGreen, batch+"处理完成("+time.Since(t1).String()+")")

	t2 := time.Now()
	wTmpDir := singluarData.Temp + "/_modelW3x"
	mTmpIs := lib.IsDir(wTmpDir)
	if mTmpIs == false {
		err = os.MkdirAll(wTmpDir, os.ModePerm)
		if err != nil {
			lib.Panic(err)
		}
	}
	w3xFire := wTmpDir + "/" + strconv.FormatInt(t2.UnixNano(), 10) + ".w3x"
	cmd := exec.Command(singluarData.W3x2lni+"/w2l.exe", "obj", tempDir, w3xFire)
	_, err = cmd.Output()
	if err != nil {
		lib.Panic(err)
	}
	// 检查标志
	lib.ColorPrint(lib.FCGreen, batch+"模型图已生成("+time.Since(t2).String()+")")
	cmd = exec.Command(singluarData.WE+"/WE.exe", "-loadfile", w3xFire)
	_, err = cmd.Output()
	if err != nil {
		lib.Panic(err)
	}
	lib.ColorPrint(lib.FCBlue, batch+"模型图正在打开："+w3xFire)
	ModelMap(singluarData, class, filter, page+1)
}

func Model(singluarData lib.SingluarData) {
	if len(os.Args) < 3 {
		lib.Panic("Params error!")
	}
	// 分类
	class := os.Args[2]
	// 搜索
	var filter []string
	if len(os.Args) >= 4 {
		filter = strings.Split(os.Args[3], ",")
	}
	lib.ColorPrint(lib.FCBlue, "虚构构建准备启动")
	if len(filter) > 0 {
		lib.ColorPrint(lib.FCPurple, "搜索路径带有："+os.Args[3])
		for _, f := range filter {
			ModelMap(singluarData, class, f, 0)
		}
	} else {
		ModelMap(singluarData, class, ``, 0)
	}
}
