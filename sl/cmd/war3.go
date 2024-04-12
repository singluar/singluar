package cmd

import (
	"bufio"
	"io"
	"io/fs"
	"os"
	"regexp"
	"sl/lib"
	"strings"
)

// 处理 war3map.j 文件
func war3mapJ(singluarData lib.SingluarData, createSrc string, name string) {
	war3mapJass := singluarData.Temp + "/" + createSrc + "/map/war3map.j"
	if lib.IsFile(war3mapJass) {
		var war3mapContentBuilder strings.Builder
		jassFile, err := os.OpenFile(war3mapJass, os.O_RDONLY, 0666)
		defer jassFile.Close()
		if err != nil {
			lib.Panic(err)
		}
		srcReader := bufio.NewReader(jassFile)
		for {
			str, err := srcReader.ReadString('\n')
			if err != nil {
				if err == io.EOF {
					break
				} else {
					lib.Panic(err)
				}
			}
			if strings.Trim(str, " ")[0:2] == "//" {
				continue
			}
			if strings.HasSuffix(str, " \r\n") {
				continue
			}
			if strings.HasPrefix(str, "\r\n") {
				continue
			}
			war3mapContentBuilder.WriteString(str)
		}
		war3mapContent := war3mapContentBuilder.String()
		// 处理J
		execGlobals := []string{"unit prevReadToken = null"}
		execLua := []string{}
		execSingluarSha1 := []string{}

		nLen := 996
		lua := "exec-lua:"
		luas := strings.Split(lua, "")
		for _, v := range luas {
			nn := lib.NanoOL(nLen)
			execGlobals = append(execGlobals, "string "+nn+"=\""+v+"\"")
			execLua = append(execLua, nn)
		}
		singluarSha1s := strings.Split(name, "")
		for _, v := range singluarSha1s {
			nn := lib.NanoOL(nLen)
			execGlobals = append(execGlobals, "string "+nn+"=\""+v+"\"")
			execSingluarSha1 = append(execSingluarSha1, nn)
		}
		gi := 10
		for {
			if gi <= 0 {
				break
			}
			nn := lib.NanoOL(nLen)
			execGlobals = append(execGlobals, "string "+nn+"=\""+lib.CharRand()+"\"")
			gi -= 1
		}
		execGlobals = lib.Shuffle(execGlobals)
		reContent := strings.Join(execGlobals, "\r\n") + "\r\nendglobals"
		reg, _ := regexp.Compile("endglobals")
		war3mapContent = reg.ReplaceAllString(war3mapContent, reContent)
		reLua := "call Cheat(" + strings.Join(execLua, "+") + "+\"\\\"\"+" + strings.Join(execSingluarSha1, "+") + "+\"\\\"\")"
		reContent = "function InitGlobals takes nothing returns nothing\r\n    " + "set prevReadToken = CreateUnit(Player(15),'hfoo',0,0,0)\r\n    " + reLua
		reg, _ = regexp.Compile("function InitGlobals takes nothing returns nothing")
		war3mapContent = reg.ReplaceAllString(war3mapContent, reContent)
		// merge
		err = lib.FilePutContents(war3mapJass, war3mapContent, fs.ModePerm)
		if err != nil {
			lib.Panic(err)
		}
	}
}

func War3(singluarData lib.SingluarData, createSrc string) {
	war3 := Lua(singluarData, createSrc)
	war3mapJ(singluarData, createSrc, war3)
}
