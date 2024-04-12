package cmd

import (
	"embed"
	"encoding/json"
	"fmt"
	lua "github.com/yuin/gopher-lua"
	"io/fs"
	"os"
	"path/filepath"
	"reflect"
	"regexp"
	"sl/lib"
	"strconv"
	"strings"
	"time"
)

func require(L *lua.LState, file string) {
	err := L.DoFile(file)
	if err != nil {
		lib.Panic(err)
	}
}

func requireEmbed(L *lua.LState, e embed.FS, file string) {
	s, _ := e.ReadFile(file)
	err := L.DoString(string(s))
	if err != nil {
		lib.Panic(err)
	}
}

func asyncRandReg(asyncRandIn [][]string, lc string) [][]string {
	reg, _ := regexp.Compile(`async.rand\((.+?),(.+?)\)`)
	ar := reg.FindAllStringSubmatch(lc, -1)
	if len(ar) > 0 {
		for _, a := range ar {
			a[1] = strings.Trim(a[1], " ")
			a[2] = strings.Trim(a[2], " ")
			if a[1] != a[2] {
				asyncRandIn = append(asyncRandIn, []string{a[1], a[2]})
			}
		}
	}
	return asyncRandIn
}

func ini(file string) string {
	content, errIni := lib.FileGetContents(file)
	if errIni != nil {
		return ""
	}
	return content
}

// Lua lua
func Lua(singluarData lib.SingluarData, createSrc string) string {
	isTest := createSrc == "_hot" || createSrc == "_test"
	isBuild := createSrc == "_build" || createSrc == "_dist"
	isRelease := createSrc == "_release"
	projectName := ProjectName(singluarData)
	tmpMapDir := singluarData.Temp + "/" + createSrc + "/map"
	war3mapUIPath, _ := filepath.Abs(singluarData.Pwd + "/assets/war3mapUI")
	fmt.Println("请稍候...")
	//
	var scriptIn []string
	var builtIn []map[string]string
	var asyncRandIn [][]string
	var settingMap map[string]string
	if isTest {
		scriptIn = append(scriptIn, "package.path = package.path .. \";"+strings.Replace(war3mapUIPath, "\\", "/", -1)+"/?.lua\"")
		scriptIn = append(scriptIn, "package.path = package.path .. \";"+strings.Replace(singluarData.Kernel, "\\", "/", -1)+"/?.lua\"")
		scriptIn = append(scriptIn, "package.path = package.path .. \";"+strings.Replace(singluarData.Vendor, "\\", "/", -1)+"/?.lua\"")
		scriptIn = append(scriptIn, "package.path = package.path .. \";"+strings.Replace(singluarData.Projects, "\\", "/", -1)+"/"+projectName+"/?.lua\"")
	}
	// 字串数字化
	chao, _ := lib.CharChao()
	sLua := "____={"
	for k, v := range chao {
		i := 3
		nPrev := lib.Nano(lib.Rand(20, 36))
		for {
			if i == 0 {
				sLua += nPrev + "='" + k + "',"
				break
			}
			if i == 3 {
				sLua += v + "='" + nPrev + "',"
			} else {
				nCur := lib.Nano(lib.Rand(20, 36))
				sLua += nPrev + "='" + nCur + "',"
				nPrev = nCur
			}
			i = i - 1
		}
	}
	sLua += "}"
	scriptIn = append(scriptIn, sLua)
	// Inner-Engine
	builtInSort1 := []string{"engine"}
	if isTest {
		builtInSort1 = append(builtInSort1, "console/test")
	} else if isBuild {
		builtInSort1 = append(builtInSort1, "console/build")
	} else if isRelease {
		builtInSort1 = append(builtInSort1, "console/release")
	}
	builtInSort1 = append(builtInSort1, "blizzard", "setting")
	for _, v := range builtInSort1 {
		src := singluarData.Vendor + "/kernel/builtIn/" + v + ".lua"
		name := ""
		code := ""
		dst := ""
		if isTest {
			r1 := lib.Nano(4)
			r2 := strings.Replace(v, "/", "_", -1)[0:2]
			r3 := lib.Nano(4)
			fname := r1 + "_" + r2 + "_" + r3
			name = "vuln." + fname
			dst = tmpMapDir + "/vuln/" + fname + ".lua"
		} else if isBuild {
			r1 := lib.Nano(4)
			r2 := strings.Replace(v, "/", "_", -1)[0:2]
			r3 := lib.Nano(4)
			fname := r1 + "_" + r2 + "_" + r3
			name = "vuln." + fname
			dst = tmpMapDir + "/vuln/" + fname + ".lua"
		} else if isRelease {
			name = lib.Nano(30)
			dst = tmpMapDir + "/" + name + ".lua"
		}
		if v == "engine" {
			code = lib.LuaZip(src)
			s, _ := singluarData.Embeds.ReadFile("embeds/implant/engine.lua")
			implantCodes := string(s)
			if implantCodes != "" {
				code = lib.LuaZip(code + "\n" + implantCodes)
			}
		} else {
			code = lib.LuaZip(src)
		}
		m := map[string]string{
			"name": name,
			"dst":  dst,
			"code": code,
		}
		builtIn = append(builtIn, m)
		if v == "setting" {
			settingMap = m
		}
	}
	// library
	librarySort := []string{"variable", "common", "foundation", "ability"}
	for _, n := range librarySort {
		lsf, _ := filepath.Abs(singluarData.Kernel + `/library/` + n)
		err := filepath.Walk(lsf, func(path string, info fs.FileInfo, err error) error {
			if err != nil {
				return err
			}
			pLen := len(path)
			if path[pLen-4:pLen] == ".lua" {
				name := ""
				dst := ""
				code := ""
				if isTest {
					requireRelation := strings.Replace(path, lsf, "", 1)
					requireRelation = requireRelation[1:]
					requireRelation = strings.Replace(requireRelation, ".lua", "", -1)
					requireRelation = strings.Replace(requireRelation, "\\", ".", -1)
					requireRelation = strings.Replace(requireRelation, "/", ".", -1)
					name = "library." + strings.Replace(n, `/`, `.`, -1) + "." + requireRelation
				} else if isBuild {
					requireRelation := strings.Replace(path, lsf, "", 1)
					requireRelation = requireRelation[1:]
					requireRelation = strings.Replace(requireRelation, ".lua", "", -1)
					requireRelation = strings.Replace(requireRelation, "\\", ".", -1)
					requireRelation = strings.Replace(requireRelation, "/", ".", -1)
					requireFile := strings.Replace(requireRelation, ".", "/", -1)
					dst = tmpMapDir + "/library/" + n + "/" + requireFile + ".lua"
					name = "library." + strings.Replace(n, `/`, `.`, -1) + "." + requireRelation
					code = lib.LuaZip(path)
				} else if isRelease {
					thisSha1 := lib.Nano(30)
					dst = tmpMapDir + "/" + thisSha1 + ".lua"
					name = thisSha1
					code = lib.LuaZip(path)
				}
				builtIn = append(builtIn, map[string]string{
					"name": name,
					"dst":  dst,
					"code": code,
				})
			}
			return nil
		})
		if err != nil {
			lib.Panic(err)
		}
	}
	// oop
	oopDir, _ := filepath.Abs(singluarData.Vendor + "/oop")
	if lib.IsDir(oopDir) {
		err := filepath.Walk(oopDir, func(path string, info fs.FileInfo, err error) error {
			if err != nil {
				return err
			}
			pLen := len(path)
			if path[pLen-4:pLen] == ".lua" {
				name := ""
				dst := ""
				code := ""
				if isTest {
					requireRelation := strings.Replace(path, oopDir, "", 1)
					requireRelation = requireRelation[1:]
					requireRelation = strings.Replace(requireRelation, ".lua", "", -1)
					requireRelation = strings.Replace(requireRelation, "\\", ".", -1)
					requireRelation = strings.Replace(requireRelation, "/", ".", -1)
					name = "oop." + requireRelation
				} else if isBuild {
					requireRelation := strings.Replace(path, oopDir, "", 1)
					requireRelation = requireRelation[1:]
					requireRelation = strings.Replace(requireRelation, ".lua", "", -1)
					requireRelation = strings.Replace(requireRelation, "\\", ".", -1)
					requireRelation = strings.Replace(requireRelation, "/", ".", -1)
					requireFile := strings.Replace(requireRelation, ".", "/", -1)
					name = "oop." + requireRelation
					dst = tmpMapDir + "/oop/" + requireFile + ".lua"
					code = lib.LuaZip(path)
				} else if isRelease {
					name = lib.Nano(30)
					dst = tmpMapDir + "/" + name + ".lua"
					code = lib.LuaZip(path)
				}
				builtIn = append(builtIn, map[string]string{
					"name": name,
					"dst":  dst,
					"code": code,
				})
			}
			return nil
		})
		if err != nil {
			lib.Panic(err)
		}
	} else {
		lib.CopyPathEmbed(singluarData.Embeds, "embeds/bop", tmpMapDir+"/btmp")
		bopcDir, _ := filepath.Abs(tmpMapDir + "/btmp")
		err := filepath.Walk(bopcDir, func(path string, info fs.FileInfo, err error) error {
			if err != nil {
				return err
			}
			pLen := len(path)
			if path[pLen-4:pLen] == ".lua" {
				name := ""
				dst := ""
				code := ""
				if isTest {
					requireRelation := strings.Replace(path, bopcDir, "", 1)
					requireRelation = requireRelation[1:]
					requireRelation = strings.Replace(requireRelation, ".lua", "", -1)
					requireRelation = strings.Replace(requireRelation, "\\", ".", -1)
					requireRelation = strings.Replace(requireRelation, "/", ".", -1)
					requireFiles := strings.Split(requireRelation, ".")
					r1 := lib.Nano(4)
					r2 := requireFiles[len(requireFiles)-1][0:2]
					r3 := lib.Nano(4)
					fname := r1 + "_" + r2 + "_" + r3
					name = "vuln." + fname
					dst = tmpMapDir + "/vuln/" + fname + ".lua"
					code = lib.LuaZip(path)
				} else if isBuild {
					requireRelation := strings.Replace(path, bopcDir, "", 1)
					requireRelation = requireRelation[1:]
					requireRelation = strings.Replace(requireRelation, ".lua", "", -1)
					requireRelation = strings.Replace(requireRelation, "\\", ".", -1)
					requireRelation = strings.Replace(requireRelation, "/", ".", -1)
					requireFiles := strings.Split(requireRelation, ".")
					r1 := lib.Nano(4)
					r2 := requireFiles[len(requireFiles)-1][0:2]
					r3 := lib.Nano(4)
					fname := r1 + "_" + r2 + "_" + r3
					name = "vuln." + fname
					dst = tmpMapDir + "/vuln/" + fname + ".lua"
					code = lib.LuaZip(path)
				} else if isRelease {
					name = lib.Nano(30)
					dst = tmpMapDir + "/" + name + ".lua"
					code = lib.LuaZip(path)
				}
				builtIn = append(builtIn, map[string]string{
					"name": name,
					"dst":  dst,
					"code": code,
				})
			}
			return nil
		})
		if err != nil {
			lib.Panic(err)
		}
		err = os.RemoveAll(bopcDir)
		if err != nil {
			lib.Panic(err)
		}
	}
	// facades
	facades, _ := filepath.Abs(singluarData.Kernel + "/facades")
	err := filepath.Walk(facades, func(path string, info fs.FileInfo, err error) error {
		if err != nil {
			return err
		}
		pLen := len(path)
		if path[pLen-4:pLen] == ".lua" {
			name := ""
			dst := ""
			code := ""
			if isTest {
				requireRelation := strings.Replace(path, facades, "", 1)
				requireRelation = requireRelation[1:]
				requireRelation = strings.Replace(requireRelation, ".lua", "", -1)
				requireRelation = strings.Replace(requireRelation, "\\", ".", -1)
				requireRelation = strings.Replace(requireRelation, "/", ".", -1)
				name = "facades." + requireRelation
			} else if isBuild {
				requireRelation := strings.Replace(path, facades, "", 1)
				requireRelation = requireRelation[1:]
				requireRelation = strings.Replace(requireRelation, ".lua", "", -1)
				requireRelation = strings.Replace(requireRelation, "\\", ".", -1)
				requireRelation = strings.Replace(requireRelation, "/", ".", -1)
				requireFile := strings.Replace(requireRelation, ".", "/", -1)
				name = "facades." + requireRelation
				dst = tmpMapDir + "/facades/" + requireFile + ".lua"
				code = lib.LuaZip(path)
			} else if isRelease {
				name = lib.Nano(30)
				dst = tmpMapDir + "/" + name + ".lua"
				code = lib.LuaZip(path)
			}
			builtIn = append(builtIn, map[string]string{
				"name": name,
				"dst":  dst,
				"code": code,
			})
		}
		return nil
	})
	if err != nil {
		lib.Panic(err)
	}
	builtInSort2 := []string{"slk", "union", "system", "initialization"}
	for _, v := range builtInSort2 {
		src := singluarData.Vendor + "/kernel/builtIn/" + v + ".lua"
		name := ""
		dst := ""
		code := ""
		if isTest {
			name = "builtIn." + v
		} else if isBuild {
			name = "builtIn." + v
			dst = tmpMapDir + "/" + strings.Replace(name, `.`, `/`, -1) + ".lua"
			code = lib.LuaZip(src)
		} else if isRelease {
			thisSha1 := lib.Nano(30)
			name = thisSha1
			dst = tmpMapDir + "/" + name + ".lua"
			code = lib.LuaZip(src)
		}
		builtIn = append(builtIn, map[string]string{
			"name": name,
			"dst":  dst,
			"code": code,
		})
	}
	//------------------------------

	L := lua.NewState()
	defer L.Close()
	//
	require(L, singluarData.Kernel+"/builtIn/console/go.lua")
	err = filepath.Walk(singluarData.Kernel+"/library/common", func(path string, info fs.FileInfo, err error) error {
		if err != nil {
			return err
		}
		pLen := len(path)
		if path[pLen-4:pLen] == ".lua" {
			require(L, path)
		}
		return nil
	})
	if err != nil {
		lib.Panic(err)
	}
	// embeds
	requireEmbed(L, singluarData.Embeds, "embeds/builtIn/json.lua")
	requireEmbed(L, singluarData.Embeds, "embeds/builtIn/go.lua")
	requireEmbed(L, singluarData.Embeds, "embeds/builtIn/slkOriData.lua")
	requireEmbed(L, singluarData.Embeds, "embeds/builtIn/slk.lua")
	requireEmbed(L, singluarData.Embeds, "embeds/builtIn/union.lua")

	// require singluar slk
	requireEmbed(L, singluarData.Embeds, "embeds/builtIn/system.lua")

	// require project assets
	project := singluarData.Projects + "/" + projectName
	assetsDir, _ := filepath.Abs(project + "/assets")
	hasAssets := lib.IsDir(assetsDir)
	if hasAssets {
		err = filepath.Walk(assetsDir, func(path string, info fs.FileInfo, err error) error {
			if err != nil {
				return err
			}
			pLen := len(path)
			if path[pLen-4:pLen] == ".lua" {
				require(L, path)
				name := ""
				dst := ""
				code := ""
				if isTest {
					requireRelation := strings.Replace(path, assetsDir, "", 1)
					requireRelation = requireRelation[1:]
					requireRelation = strings.Replace(requireRelation, ".lua", "", -1)
					requireRelation = strings.Replace(requireRelation, "\\", ".", -1)
					requireRelation = strings.Replace(requireRelation, "/", ".", -1)
					name = "assets." + requireRelation
				} else if isBuild {
					requireRelation := strings.Replace(path, assetsDir, "", 1)
					requireRelation = requireRelation[1:]
					requireRelation = strings.Replace(requireRelation, ".lua", "", -1)
					requireRelation = strings.Replace(requireRelation, "\\", ".", -1)
					requireRelation = strings.Replace(requireRelation, "/", ".", -1)
					requireFile := strings.Replace(requireRelation, ".", "/", -1)
					name = "assets." + requireRelation
					dst = tmpMapDir + "/assets/" + requireFile + ".lua"
					code = lib.LuaZip(path)
				} else if isRelease {
					name = lib.Nano(30)
					dst = tmpMapDir + "/" + name + ".lua"
					code = lib.LuaZip(path)
				}
				builtIn = append(builtIn, map[string]string{
					"name": name,
					"dst":  dst,
					"code": code,
				})
			}
			return nil
		})
		if err != nil {
			lib.Panic(err)
		}
	}

	tempPath := singluarData.Temp + "/" + createSrc

	// UI
	lib.CopyPath(singluarData.Vendor+"/lni/assets/UI", tempPath+"/map/UI")

	// SELECTION
	fn := L.GetGlobal("GO_RESULT_SELECTION")
	if err = L.CallByParam(lua.P{Fn: fn, NRet: 1, Protect: true}); err != nil {
		lib.Panic(err)
	}
	selection := L.ToString(-1)
	selectionDir := singluarData.Assets + "/war3mapSelection/" + selection
	selectionDirIs := lib.IsDir(selectionDir)
	if false == selectionDirIs {
		selectionDir = singluarData.Vendor + "/lni/assets/Selection"
		selection = "Lni"
	}
	lib.CopyPath(selectionDir, tempPath+"/resource/ReplaceableTextures/Selection")
	lib.ColorPrint(lib.FCLightBlue, "引入【选择圈】："+selection)

	// FONT
	fn = L.GetGlobal("GO_RESULT_FONT")
	if err = L.CallByParam(lua.P{Fn: fn, NRet: 1, Protect: true}); err != nil {
		lib.Panic(err)
	}
	font := L.ToString(-1)
	fontFile := singluarData.Assets + "/war3mapFont/" + font + ".ttf"
	if false == lib.IsFile(fontFile) {
		font = "default"
	}
	if font == "default" {
		fontFile = ""
		_ = os.Remove(tempPath + "/map/war3mapSkin.txt")
		lib.ColorPrint(lib.FCGray, "忽略【字体】")
	}
	if fontFile != "" {
		skinFile := singluarData.Vendor + "/lni/assets/war3mapSkin.txt"
		lib.CopyFile(skinFile, tempPath+"/map/war3mapSkin.txt")
		lib.CopyFile(fontFile, tempPath+"/map/fonts.ttf")
		lib.ColorPrint(lib.FCBlue, "引入【字体】："+font)
	}

	// LOADING
	fn = L.GetGlobal("GO_RESULT_LOADING")
	if err := L.CallByParam(lua.P{Fn: fn, NRet: 1, Protect: true}); err != nil {
		lib.Panic(err)
	}
	_ = os.Remove(tempPath + "/resource/Singluar/LoadingScreen.mdx")
	loading := L.ToString(-1)
	loadingPath := singluarData.Assets + "/war3MapLoading/" + loading
	loadingFile := singluarData.Assets + "/war3MapLoading/" + loading + ".tga"
	loaded := false
	if lib.IsDir(loadingPath) {
		lib.CopyFile(singluarData.Vendor+"/lni/assets/LoadingScreenDir.mdx", tempPath+"/resource/Singluar/LoadingScreen.mdx")
		loadingSites := []string{"bg", "bc", "pic"}
		for _, s := range loadingSites {
			loadingFile = loadingPath + "/" + s + ".tga"
			if lib.IsFile(loadingFile) {
				lib.CopyFile(loadingFile, tempPath+"/resource/Singluar/LoadingScreen"+s+".tga")
			} else {
				lib.ColorPrint(lib.FCCyan, "引入【载入图碎片】："+s+" 不存在")
			}
		}
		loaded = true
	} else if lib.IsFile(loadingFile) {
		lib.CopyFile(singluarData.Vendor+"/lni/assets/LoadingScreenFire.mdx", tempPath+"/resource/Singluar/LoadingScreen.mdx")
		lib.CopyFile(loadingFile, tempPath+"/resource/Singluar/LoadingScreen.tga")
		loaded = true
	}
	if loaded {
		w3i, _ := lib.FileGetContents(tempPath + "/table/w3i.ini")
		w3i = strings.Replace(w3i, "\r\n", "\n", -1)
		w3i = strings.Replace(w3i, "\r", "\n", -1)
		w3ia := strings.Split(w3i, "\n")
		canReplace := false
		for k, v := range w3ia {
			if strings.Index(v, "[载入图]") != -1 {
				canReplace = true
			}
			if canReplace && strings.Index(v, "路径") != -1 {
				w3ia[k] = `路径 = "Singluar\\LoadingScreen.mdx"`
				break
			}
		}
		err = lib.FilePutContents(tempPath+"/table/w3i.ini", strings.Join(w3ia, "\r\n"), fs.ModePerm)
		if err != nil {
			lib.Panic(err)
		}
		lib.ColorPrint(lib.FCCyan, "引入【载入图】："+loading)
	} else {
		lib.ColorPrint(lib.FCRed, "失败【载入图】："+loading+" 不存在")
	}

	// PREVIEW
	fn = L.GetGlobal("GO_RESULT_PREVIEW")
	if err := L.CallByParam(lua.P{Fn: fn, NRet: 1, Protect: true}); err != nil {
		lib.Panic(err)
	}
	preview := L.ToString(-1)
	previewFile := singluarData.Assets + "/war3mapPreview/" + preview + ".tga"
	if lib.IsFile(previewFile) {
		lib.CopyFile(previewFile, tempPath+"/resource/war3mapPreview.tga")
		lib.ColorPrint(lib.FCLightCyan, "引入【预览图】："+preview)
	}

	// UI
	fn = L.GetGlobal("GO_RESULT_UI")
	if err = L.CallByParam(lua.P{Fn: fn, NRet: 1, Protect: true}); err != nil {
		lib.Panic(err)
	}
	uis := L.ToString(-1)
	var uiData []string
	err = json.Unmarshal([]byte(uis), &uiData)
	if err != nil {
		lib.Panic(err)
	}
	var fdfs []string
	for _, i := range uiData {
		uiPath := singluarData.Assets + "/war3mapUI/" + i
		isP := lib.IsDir(uiPath)
		if isP {
			mainLua := uiPath + "/main.lua"
			if !lib.IsFile(mainLua) {
				lib.ColorPrint(lib.FCRed, "失败【套件】："+i+" 核心main.lua未定义")
			} else {
				lib.ColorPrint(lib.FCLightPurple, "引入【套件】："+i)
				fdf := uiPath + "/main.fdf"
				if lib.IsFile(fdf) {
					fdfs = append(fdfs, "UI\\"+i+".fdf")
					lib.CopyFile(fdf, tempPath+"/map/UI/"+i+".fdf")
				}
				uiAssets := uiPath + "/assets"
				isA := lib.IsDir(uiAssets)
				if isA {
					lib.CopyPath(uiAssets, tempPath+"/resource/war3mapUI/"+i+"/assets")
					lib.ColorPrint(lib.FCGray, "自动【套资】："+i+"/assets")
				}
				// scripts
				if lib.IsDir(uiPath + "/scripts") {
					uiScripts, _ := filepath.Abs(uiPath + "/scripts")
					err = filepath.Walk(uiScripts, func(path string, info fs.FileInfo, err error) error {
						if err != nil {
							return err
						}
						pLen := len(path)
						if path[pLen-4:pLen] == ".lua" {
							name := ""
							dst := ""
							code := ""
							lc := lib.LuaZip(path)
							if isTest {
								requireRelation := strings.Replace(path, uiScripts, "", 1)
								requireRelation = requireRelation[1:]
								requireRelation = strings.Replace(requireRelation, ".lua", "", -1)
								requireRelation = strings.Replace(requireRelation, "\\", ".", -1)
								requireRelation = strings.Replace(requireRelation, "/", ".", -1)
								name = i + ".scripts." + requireRelation
							} else if isBuild {
								requireRelation := strings.Replace(path, uiScripts, "", 1)
								requireRelation = requireRelation[1:]
								requireRelation = strings.Replace(requireRelation, ".lua", "", -1)
								requireRelation = strings.Replace(requireRelation, "\\", ".", -1)
								requireRelation = strings.Replace(requireRelation, "/", ".", -1)
								requireFile := strings.Replace(requireRelation, ".", "/", -1)
								name = "war3mapUI." + i + ".scripts." + requireRelation
								dst = tmpMapDir + "/war3mapUI/" + i + "/scripts/" + requireFile + ".lua"
								code = lc
							} else if isRelease {
								name = lib.Nano(30)
								dst = tmpMapDir + "/" + name + ".lua"
								code = lc
							}
							builtIn = append(builtIn, map[string]string{
								"name": name,
								"dst":  dst,
								"code": code,
							})
							asyncRandIn = asyncRandReg(asyncRandIn, lc)
						}
						return nil
					})
					if err != nil {
						lib.Panic(err)
					}
					lib.ColorPrint(lib.FCGray, "自动【套码】："+i+"/scripts")
				}
				// main
				name := ""
				dst := ""
				code := ""
				if isTest {
					name = i + ".main"
				} else if isBuild {
					name = "war3mapUI." + i + ".main"
					dst = tmpMapDir + "/war3mapUI/" + i + "/main.lua"
					code = lib.LuaZip(mainLua)
				} else if isRelease {
					name = lib.Nano(30)
					dst = tmpMapDir + "/" + name + ".lua"
					code = lib.LuaZip(mainLua)
				}
				builtIn = append(builtIn, map[string]string{
					"name": name,
					"dst":  dst,
					"code": code,
				})
			}
		} else {
			lib.ColorPrint(lib.FCRed, "失败【套件】："+i+" 不存在")
		}
	}

	// ICONS
	fn = L.GetGlobal("GO_RESULT_ICONS")
	if err = L.CallByParam(lua.P{Fn: fn, NRet: 1, Protect: true}); err != nil {
		lib.Panic(err)
	}
	icons := L.ToString(-1)
	var iData [][]string
	err = json.Unmarshal([]byte(icons), &iData)
	if err != nil {
		lib.Panic(err)
	}
	si := 0
	for _, i := range iData {
		iconFile := singluarData.Assets + "/war3mapIcon/" + i[0] + ".tga"
		dstFile := tempPath + "/resource/war3mapIcon/" + i[1] + ".tga"
		if lib.IsFile(dstFile) {
			lib.ColorPrint(lib.FCRed, "警告【重复】："+i[0]+`->`+i[1]+"(降速提示)")
			time.Sleep(time.Second)
			continue
		}
		if lib.IsFile(iconFile) {
			lib.CopyFile(iconFile, dstFile)
			si += 1
		} else {
			lib.ColorPrint(lib.FCRed, "失败【图标】：文件不存在 "+i[0])
		}
	}
	lib.ColorPrint(lib.FCGreen, "引入【图标】："+strconv.Itoa(si))

	// MODEL
	fn = L.GetGlobal("GO_RESULT_MODEL")
	if err = L.CallByParam(lua.P{Fn: fn, NRet: 1, Protect: true}); err != nil {
		lib.Panic(err)
	}
	models := L.ToString(-1)
	var mData [][]string
	err = json.Unmarshal([]byte(models), &mData)
	if err != nil {
		lib.Panic(err)
	}
	for _, i := range mData {
		modelFile := singluarData.Assets + "/war3mapModel/" + i[0] + ".mdx"
		if lib.IsFile(modelFile) {
			dstFile := tempPath + "/resource/war3mapModel/" + i[1] + ".mdx"
			if lib.IsFile(dstFile) {
				lib.ColorPrint(lib.FCRed, "警告【重复】："+i[0]+`->`+i[1]+"(降速提示)")
				time.Sleep(time.Second)
				continue
			}
			lib.CopyFile(modelFile, dstFile)
			hasPortrait := false
			modelPortraitFile := singluarData.Assets + "/war3mapModel/" + i[0] + "_Portrait.mdx"
			if lib.IsFile(modelPortraitFile) {
				lib.CopyFile(modelPortraitFile, tempPath+"/resource/war3mapModel/"+i[1]+"_Portrait.mdx")
				hasPortrait = true
			}
			modelStr, _ := lib.FileGetContents(modelFile)
			modelStr = strings.Replace(modelStr, "\r", "", -1)
			modelStr = strings.Replace(modelStr, "\r", "", -1)
			reg, _ := regexp.Compile("(?i)war3mapTextures(.*?)(.blp)")
			textures := reg.FindAllString(modelStr, -1)
			if len(textures) > 0 {
				si = 0
				for _, t := range textures {
					t = strings.Replace(t, "war3mapTextures", "", -1)
					textureFile := singluarData.Assets + "/war3mapTextures" + t
					if lib.IsFile(textureFile) {
						lib.CopyFile(textureFile, tempPath+"/resource/war3mapTextures"+t)
						si += 1
					} else {
						lib.ColorPrint(lib.FCRed, "失败【贴图】：文件不存在 "+t)
					}
				}
				if hasPortrait {
					lib.ColorPrint(lib.FCPurple, "引入【模型】："+i[0]+" >>> "+i[1]+", 自动贴图("+strconv.Itoa(si)+"), 带<Portrait>")
				} else {
					lib.ColorPrint(lib.FCPurple, "引入【模型】："+i[0]+" >>> "+i[1]+", 自动贴图("+strconv.Itoa(si)+")")
				}
			} else {
				if hasPortrait {
					lib.ColorPrint(lib.FCPurple, "引入【模型】："+i[0]+" >>> "+i[1]+", 带<Portrait>")
				} else {
					lib.ColorPrint(lib.FCPurple, "引入【模型】："+i[0]+" >>> "+i[1])
				}
			}
		} else {
			lib.ColorPrint(lib.FCRed, "失败【模型】：文件不存在 "+i[0])
		}
	}
	// SOUND
	fn = L.GetGlobal("GO_RESULT_SOUND")
	if err = L.CallByParam(lua.P{Fn: fn, NRet: 1, Protect: true}); err != nil {
		lib.Panic(err)
	}
	sounds := L.ToString(-1)
	var sData [][]string
	err = json.Unmarshal([]byte(sounds), &sData)
	if err != nil {
		lib.Panic(err)
	}
	voiceData := make(map[string]map[string]string)
	voiceData["vcm"] = make(map[string]string)
	voiceData["v3d"] = make(map[string]string)
	voiceData["vwp"] = make(map[string]string)
	for _, i := range sData {
		if i[2] == "vcm" || i[2] == "v3d" || i[2] == "bgm" {
			soundFile := singluarData.Assets + "/war3mapSound/" + i[0] + ".mp3"
			if lib.IsFile(soundFile) {
				lib.CopyFile(soundFile, tempPath+"/resource/war3mapSound/"+i[2]+"/"+i[1]+".mp3")
				if i[2] == "vcm" {
					lib.ColorPrint(lib.FCLightBlue, "引入【音效】：<"+i[2]+"> "+i[0]+" >>> "+i[1])
					voiceData["vcm"][i[1]] = strconv.Itoa(lib.VoiceDuration(soundFile))
				} else if i[2] == "v3d" {
					lib.ColorPrint(lib.FCBlue, "引入【音效】：<"+i[2]+"> "+i[0]+" >>> "+i[1])
					voiceData["v3d"][i[1]] = strconv.Itoa(lib.VoiceDuration(soundFile))
				} else if i[2] == "bgm" {
					lib.ColorPrint(lib.FCPurple, "引入【乐曲】：<"+i[2]+"> "+i[0]+" >>> "+i[1])
				} else {
					lib.ColorPrint(lib.FCRed, "失败【声乐】：无效类型 "+i[2])
				}
			} else {
				lib.ColorPrint(lib.FCRed, "失败【声乐】：文件不存在 "+i[0])
			}
		} else if i[2] == "vwp" {
			wPath, _ := filepath.Abs(singluarData.Assets + "/war3mapSound/weapon/" + i[0])
			isWPathDir := lib.IsDir(wPath)
			if isWPathDir {
				err = filepath.Walk(wPath, func(path string, info fs.FileInfo, err error) error {
					if err != nil {
						return err
					}
					pLen := len(path)
					if path[pLen-4:pLen] == ".mp3" {
						mp3Relation := strings.Replace(path, wPath, "", 1)
						mp3Relation = strings.Replace(mp3Relation, "\\", "/", -1)
						soundFile := wPath + mp3Relation
						if lib.IsFile(soundFile) {
							mp3Relation = strings.Replace(mp3Relation, "/", "_", -1)
							lib.CopyFile(soundFile, tempPath+"/resource/war3mapSound/"+i[2]+"/"+i[1]+mp3Relation)
							mp3Relation = strings.Replace(mp3Relation, ".mp3", "", -1)
							voiceData["vwp"][i[1]+mp3Relation] = strconv.Itoa(lib.VoiceDuration(soundFile))
						}
					}
					return nil
				})
				if err != nil {
					lib.Panic(err)
				}
				lib.ColorPrint(lib.FCGreen, "引入【打声】：<"+i[2]+"> "+i[0]+" >>> "+i[1])
			} else {
				lib.ColorPrint(lib.FCRed, "失败【打声】：套件不存在 "+i[0])
			}
		}
	}
	// toc
	tocFile := tempPath + "/map/UI/singluar_frame.toc"
	if !lib.IsFile(tocFile) {
		lib.Panic("tocFile not exist")
	}
	toc, err2 := lib.FileGetContents(tocFile)
	if err2 != nil {
		lib.Panic(err2)
	}
	if len(fdfs) > 0 {
		toc += "\r\n" + strings.Join(fdfs, "\r\n")
	}
	err = lib.FilePutContents(tocFile, toc+"\r\n", fs.ModePerm)
	if err != nil {
		lib.Panic(err)
	}
	//
	fn = L.GetGlobal("GO_RESULT_SLK")
	if err = L.CallByParam(lua.P{Fn: fn, NRet: 1, Protect: true}); err != nil {
		lib.Panic(err)
	}
	// get lua function results
	slkData := L.ToString(-1)
	var slData []map[string]interface{}
	err = json.Unmarshal([]byte(slkData), &slData)
	if err != nil {
		lib.Panic(err)
	}
	// lni codes
	iniKeys := []string{"ability", "unit", "destructable"}
	iniF6 := make(map[string]string)
	reg, _ := regexp.Compile("\\[[A-Za-z][A-Za-z\\d]{3}]")
	var idIni []string
	for _, k := range iniKeys {
		iniF6[k] = ini(singluarData.Temp + "/" + projectName + "/table/" + k + ".ini")
		matches := reg.FindAllString(iniF6[k], -1)
		for _, v := range matches {
			v = strings.Replace(v, "[", "", 1)
			v = strings.Replace(v, "]", "", 1)
			idIni = append(idIni, v)
		}
	}
	idIniByte, _ := json.Marshal(idIni)
	fn = L.GetGlobal("SLK_GO_INI")
	if err = L.CallByParam(lua.P{
		Fn:      fn,
		NRet:    0,
		Protect: true,
	}, lua.LString(idIniByte)); err != nil {
		lib.Panic(err)
	}
	slkIniBuilder := make(map[string]*strings.Builder)
	for _, k := range iniKeys {
		slkIniBuilder[k] = &strings.Builder{}
	}
	var idCli []string
	for _, sda := range slData {
		_slk := make(map[string]string)
		_hash := make(map[string]interface{})
		_id := ""
		_parent := ""
		for key, val := range sda {
			if key[:1] == "_" {
				_hash[key] = val
				if key == "_id" {
					switch v := val.(type) {
					case string:
						_id = v
					}
				} else if key == "_parent" {
					switch v := val.(type) {
					case string:
						_parent = "\"" + strings.Replace(v, "\\", "\\\\", -1) + "\""
					}
				}
			} else {
				var newVal string
				v := reflect.ValueOf(val)
				valType := reflect.TypeOf(val).Kind()
				switch valType {
				case reflect.String:
					newVal = "\"" + strings.Replace(v.String(), "\\", "\\\\", -1) + "\""
				case reflect.Int, reflect.Int8, reflect.Int16, reflect.Int32, reflect.Int64,
					reflect.Uint, reflect.Uint8, reflect.Uint16, reflect.Uint32, reflect.Uint64:
					newVal = strconv.FormatInt(v.Int(), 10)
				case reflect.Float32, reflect.Float64:
					d := fmt.Sprintf("%v", v)
					if -1 == strings.Index(d, ".") {
						newVal = strconv.FormatInt(int64(v.Float()), 10)
					} else {
						newVal = strconv.FormatFloat(v.Float(), 'f', 2, 64)
					}
				case reflect.Slice, reflect.Array:
					newVal = "{"
					for i := 0; i < v.Len(); i++ {
						var n string
						vv := v.Index(i)
						ve := vv.Elem()
						d := fmt.Sprintf("%v", vv)
						switch ve.Kind() {
						case reflect.String:
							n = "\"" + d + "\""
						case reflect.Float64:
							if -1 == strings.Index(d, ".") {
								n = strconv.FormatInt(int64(ve.Float()), 10)
							} else {
								n = strconv.FormatFloat(ve.Float(), 'f', 2, 64)
							}
						}
						if newVal == "{" {
							newVal += n
						} else {
							newVal += "," + n
						}
					}
					newVal += "}"
				}
				_slk[key] = newVal
			}
		}
		if _id != "" && _parent != "" && len(_slk) > 0 {
			idCli = append(idCli, _id)
			_class := _hash["_class"].(string)
			sbr := slkIniBuilder[_class]
			sbr.WriteString("[" + _id + "]")
			sbr.WriteString("\n_parent=" + _parent)
			for k, v := range _slk {
				sbr.WriteString("\n" + k + "=" + v)
			}
			sbr.WriteString("\n\n")
		}
	}
	// merge ini
	csTableDir := singluarData.Temp + "/" + createSrc + "/table"
	for k, v := range slkIniBuilder {
		if iniF6[k] == "" {
			err = lib.FilePutContents(csTableDir+"/"+k+".ini", v.String(), fs.ModePerm)

		} else {
			err = lib.FilePutContents(csTableDir+"/"+k+".ini", iniF6[k]+"\n\n"+v.String(), fs.ModePerm)
		}
		if err != nil {
			lib.Panic(err)
		}
	}
	// fill setting: SLK ID
	settingContent, _ := settingMap["code"]
	if len(idCli) > 0 {
		for k, v := range idCli {
			idCli[k] = "'" + v + "'"
		}
		idCliStrs := strings.Join(idCli, ",")
		settingContent = strings.Replace(settingContent, "SINGLUAR_GO_IDS = {}", "SINGLUAR_GO_IDS = {"+idCliStrs+"}", 1)
	}
	// fill: font
	settingContent = strings.Replace(settingContent, "SINGLUAR_FONT = ''", "SINGLUAR_FONT = '"+font+"'", 1)
	// fill: voice
	var voiceCreator []string
	for k, v := range voiceData {
		for alias, dur := range v {
			switch k {
			case "vcm":
				voiceCreator = append(voiceCreator, `VcmCreator("`+alias+`",`+dur+`)`)
			case "v3d":
				voiceCreator = append(voiceCreator, `V3dCreator("`+alias+`",`+dur+`)`)
			case "vwp":
				voiceCreator = append(voiceCreator, `VwpCreator("`+alias+`",`+dur+`)`)
			}
		}
	}
	settingContent = strings.Replace(settingContent, "__SINGLUAR_VOICE_INIT__ = 7", strings.Join(voiceCreator, "\n"), 1)
	// map name
	wj, _ := lib.FileGetContents(singluarData.Temp + "/" + createSrc + "/map/war3map.j")
	reg, _ = regexp.Compile("SetMapName\\(\"(.*)\"\\)")
	sm := reg.FindAllStringSubmatch(wj, 1)
	if len(sm) > 0 {
		mapName := sm[0][1]
		settingContent = strings.Replace(settingContent, "SINGLUAR_MAP_NAME = ''", "SINGLUAR_MAP_NAME = '"+mapName+"'", 1)
	}
	// save setting
	settingMap["code"] = settingContent

	// scripts
	sDir, _ := filepath.Abs(project + "/scripts")
	err = filepath.Walk(sDir, func(path string, info fs.FileInfo, err error) error {
		if err != nil {
			return err
		}
		pLen := len(path)
		if path[pLen-4:pLen] == ".lua" {
			name := ""
			dst := ""
			code := ""
			lc := lib.LuaZip(path)
			if isTest {
				requireRelation := strings.Replace(path, sDir, "", 1)
				requireRelation = requireRelation[1:]
				requireRelation = strings.Replace(requireRelation, ".lua", "", -1)
				requireRelation = strings.Replace(requireRelation, "\\", ".", -1)
				requireRelation = strings.Replace(requireRelation, "/", ".", -1)
				name = "scripts." + requireRelation
			} else if isBuild {
				requireRelation := strings.Replace(path, sDir, "", 1)
				requireRelation = requireRelation[1:]
				requireRelation = strings.Replace(requireRelation, ".lua", "", -1)
				requireRelation = strings.Replace(requireRelation, "\\", ".", -1)
				requireRelation = strings.Replace(requireRelation, "/", ".", -1)
				requireFile := strings.Replace(requireRelation, ".", "/", -1)
				name = "scripts." + requireRelation
				dst = tmpMapDir + "/scripts/" + requireFile + ".lua"
				code = lc
			} else if isRelease {
				name = lib.Nano(30)
				dst = tmpMapDir + "/" + name + ".lua"
				code = lc
			}
			builtIn = append(builtIn, map[string]string{
				"name": name,
				"dst":  dst,
				"code": code,
			})
			asyncRandIn = asyncRandReg(asyncRandIn, lc)
		}
		return nil
	})
	if err != nil {
		lib.Panic(err)
	}

	// 处理代码
	for _, v := range builtIn {
		if v["name"] == "" {
			fmt.Println(v)
			lib.Panic("builtIn")
		}
		scriptIn = append(scriptIn, lib.RequireLua(v["name"]))
	}

	// 植入 implant
	// hot
	hotCodes := ""
	if isTest && singluarData.War3 != "" {
		s, _ := singluarData.Embeds.ReadFile("embeds/implant/hot.lua")
		hotCodes = string(s)
		if hotCodes != "" {
			scriptIn = append(scriptIn, hotCodes)
		}
	}
	// hook
	hookCodes := ""
	hs, _ := singluarData.Embeds.ReadFile("embeds/implant/hook.lua")
	hookCodes = string(hs)
	if hookCodes != "" {
		scriptIn = append(scriptIn, hookCodes)
	}
	// async rand
	if len(asyncRandIn) > 0 {
		asyncRandCodes := ""
		var randCodes strings.Builder
		for _, ar := range asyncRandIn {
			randCodes.WriteString("AYRD(" + ar[0] + "," + ar[1] + ") ")
		}
		s, _ := singluarData.Embeds.ReadFile("embeds/implant/asyncRand.lua")
		asyncRandCodes = string(s)
		asyncRandCodes = strings.Replace(asyncRandCodes, "RAL_ASYNC_RAND = 20220608", randCodes.String(), 1)
		if asyncRandCodes != "" {
			scriptIn = append(scriptIn, asyncRandCodes)
		}
	}
	// refresh
	refreshCodes := ""
	s, _ := singluarData.Embeds.ReadFile("embeds/implant/refresh.lua")
	refreshCodes = string(s)
	if refreshCodes != "" {
		scriptIn = append(scriptIn, refreshCodes)
	}
	// fps
	if !isRelease {
		fpsCodes := ""
		x, _ := singluarData.Embeds.ReadFile("embeds/implant/fps.lua")
		fpsCodes = string(x)
		if fpsCodes != "" {
			scriptIn = append(scriptIn, fpsCodes)
		}
	}

	// singluar
	var singluarMap map[string]string
	singluarName := "singluar"
	if isRelease {
		singluarName = lib.Nano(30)
	}
	singluarDst := tmpMapDir + "/" + singluarName + ".lua"
	singluarCode, _ := lib.FileGetContentsEmbeds(singluarData.Embeds, "embeds/builtIn/singluar.lua")
	singluarCode = strings.Replace(singluarCode, "--SINGLUAR_REQUIRE", strings.Join(scriptIn, "\n"), -1)
	singluarCode = lib.LuaZip(singluarCode)
	singluarMap = map[string]string{
		"name": singluarName,
		"dst":  singluarDst,
		"code": singluarCode,
	}
	builtIn = append(builtIn, singluarMap)

	if isBuild || isRelease {
		builtIn = lib.LuaEncryption(builtIn)
	}
	for _, v := range builtIn {
		if v["dst"] != "" {
			lib.DirCheck(v["dst"])
			err = lib.FilePutContents(v["dst"], v["code"], os.ModePerm)
			if err != nil {
				lib.Panic(err)
			}
		}
	}
	return singluarMap["name"]
}
