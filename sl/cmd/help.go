package cmd

import (
	"fmt"
)

func Help() {
	fmt.Println("┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	fmt.Println("┃ *:带星号的是必须的")
	fmt.Println("┃ ~:带波浪的是可选的")
	fmt.Println("┃ sl.exe new [:项目名] - 新建一个项目")
	fmt.Println("┃ sl.exe we [:项目名] - 打开WE编辑地形")
	fmt.Println("┃ sl.exe model [~参数] - 查看模型")
	fmt.Println("┃ sl.exe clear - 清理缓存")
	fmt.Println("┃ sl.exe multi [:数量] - 打开多个魔兽客户端")
	fmt.Println("┃ sl.exe kill - 关闭所有魔兽客户端")
	fmt.Println("┃ sl.exe run [:项目名] - 测试项目")
	fmt.Println("┃")
	fmt.Println("┃ @技术文档 https://afdian.net/a/hunzsig")
	fmt.Println("┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
}
