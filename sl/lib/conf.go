package lib

import (
	"embed"
	"fmt"
	"os"
	"path/filepath"
	"regexp"
	"strings"
)

//go:embed embeds
var embedFS embed.FS

type SingluarData struct {
	IsAdmin     bool
	Args        []string
	Pwd         string
	War3        string
	Temp        string
	Assets      string
	Projects    string
	ProjectName string
	Vendor      string
	Kernel      string
	W3x2lni     string
	WE          string
	Embeds      embed.FS
}

var (
	data SingluarData
)

func GetSdkData() SingluarData {
	if data.Pwd == "" {
		data.Embeds = embedFS
		if !IsFile("./conf") {
			CopyEmbed(data.Embeds, "embeds/conf.example", "./conf")
			fmt.Println("配置<conf>文件已构建")
			os.Exit(0)
		}
		c, err := os.ReadFile("./conf")
		if err != nil {
			Panic(err)
		}
		content := string(c)
		reg, _ := regexp.Compile("#(.*)")
		content = reg.ReplaceAllString(content, "")
		content = strings.Replace(content, "\r\n", "\n", -1)
		content = strings.Replace(content, "\r", "\n", -1)
		split := strings.Split(content, "\n")
		conf := make(map[string]string)
		for _, iniItem := range split {
			if len(iniItem) > 0 {
				itemSplit := strings.Split(iniItem, "=")
				itemKey := strings.Trim(itemSplit[0], " ")
				itemKey = strings.ToLower(strings.Trim(itemSplit[0], " "))
				conf[itemKey] = strings.Trim(itemSplit[1], " ")
			}
		}
		if conf["root"] != "" {
			data.Pwd = conf["root"]
		}
		if data.Pwd == "" {
			data.Pwd, _ = os.Getwd()
		}
		data.Pwd, _ = filepath.Abs(data.Pwd)
		abs1, _ := filepath.Abs(data.Pwd)
		abs2, _ := filepath.Abs("./")
		data.IsAdmin = abs1 != abs2
		data.Projects = data.Pwd + "/projects"
		data.Temp = data.Pwd + "/temp"
		data.Assets = data.Pwd + "/assets"
		data.Vendor = data.Pwd + "/vendor"
		data.Kernel = data.Vendor + "/kernel"
		data.W3x2lni = data.Vendor + "/w3x2lni"
		data.WE = data.Vendor + "/WE"
		data.Args = os.Args
		if !IsDir(data.Vendor) || !IsDir(data.Kernel) || !IsDir(data.W3x2lni) || !IsDir(data.WE) {
			fmt.Println("请使用官方正版框架！")
			os.Exit(0)
		}
		if !IsDir(data.Assets) {
			fmt.Println("资源库丢失！")
			os.Exit(0)
		}
		if conf["war3"] != "" {
			data.War3 = conf["war3"]
			if !IsFile(data.War3 + "/War3.exe") {
				fmt.Println("请正确配置<conf>文件中的魔兽客户端路径")
				fmt.Println("当前魔兽路径无效:" + data.War3)
				os.Exit(0)
			}
		} else {
			fmt.Println("请配置<conf>文件中的魔兽客户端路径")
			fmt.Println("可参考<conf.example>复制一个<conf>进行配置")
			os.Exit(0)
		}
	}
	return data
}
