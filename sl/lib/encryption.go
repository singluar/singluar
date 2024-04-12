package lib

import (
	"fmt"
	"github.com/samber/lo"
	"math/rand"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"time"
)

// LuaZip zip lua
func LuaZip(src string) string {
	content, err := FileGetContents(src)
	if err != nil {
		content = src
	}
	content = strings.Replace(content, "\r\n", "\n", -1)
	content = strings.Replace(content, "\r", "\n", -1)
	reg, _ := regexp.Compile("\\s*--.*\\[\\[[\\s\\S]*?\\]\\]")
	content = reg.ReplaceAllString(content, "")
	reg, _ = regexp.Compile("\\s*--.*")
	content = reg.ReplaceAllString(content, "")
	cta := strings.Split(content, "\n")
	var ctn []string
	for _, c := range cta {
		c = strings.Trim(c, " ")
		if len(c) > 0 {
			ctn = append(ctn, c)
		}
	}
	return strings.Join(ctn, " ")
}

// LuaEncryption
func LuaEncryption(data []map[string]string) []map[string]string {
	codeSpilt := ` 0X0X0X0X0X0X0 `
	var _codesBuilder strings.Builder
	for _, v := range data {
		_codesBuilder.WriteString(v["code"] + codeSpilt)
	}
	content := _codesBuilder.String()
	fmt.Println("启动低效弱化混淆加密...")
	fmt.Println("准备数学算术简单异化...")
	reg, _ := regexp.Compile(` ([1-9]{1}[0-9]*) `)
	nu := reg.FindAllStringSubmatch(content, -1)
	var ns []int
	for _, n := range nu {
		if len(n) == 2 {
			ni, errn := strconv.Atoi(n[1])
			if errn == nil {
				ns = append(ns, ni)
			}
		}
	}
	ns = lo.Uniq[int](ns)
	sort.Slice(ns, func(i, j int) bool {
		return ns[i] > ns[j]
	})
	nums := make(map[string]string)
	rand.Seed(time.Now().UnixNano())
	for _, n := range ns {
		r := rand.Intn(100)
		r1 := 7 + rand.Intn(9999)
		r2 := -1 * (7 + rand.Intn(9999))
		var vs string
		if r < 50 {
			vs = strconv.Itoa(n+r1-r2) + " + " + strconv.Itoa(r2) + " - " + strconv.Itoa(r1)
		} else {
			vs = strconv.Itoa(n+r2-r1) + " + " + strconv.Itoa(r1) + " - " + strconv.Itoa(r2)
		}
		k := strconv.Itoa(n)
		nums[k] = `(` + vs + `)`
	}
	for _, n := range ns {
		k := strconv.Itoa(n)
		if nums[k] != "" {
			v := nums[k]
			content = strings.Replace(content, "= "+k+")", "= "+v+")", -1)
			content = strings.Replace(content, "= "+k+" ", "= "+v+" ", -1)
			content = strings.Replace(content, " "+k+")", " "+v+")", -1)
			content = strings.Replace(content, " "+k+",", " "+v+",", -1)
			content = strings.Replace(content, ", "+k+" ", ", "+v+" ", -1)
			content = strings.Replace(content, ", "+k+")", ", "+v+")", -1)
			content = strings.Replace(content, "("+k+",", "("+v+",", -1)
		}
	}
	fmt.Println("数学算术简单异化已处理 " + strconv.Itoa(len(ns)) + " 个数据")
	//
	fmt.Println("准备字串弱能等效置换...")
	var strs []string
	reg, _ = regexp.Compile(`"[0-9A-Za-z._:!,-]{2,}"`)
	m := reg.FindAllString(content, -1)
	if len(m) > 0 {
		for _, s := range m {
			strs = append(strs, s)
		}
	}
	fmt.Println("字串弱能等效置换已处理 " + strconv.Itoa(len(strs)) + " 个数据")
	fmt.Println("准备字串混淆加密...")
	parseStrs := make(map[string]string)
	for _, str := range strs {
		ess := strings.Split(str[1:len(str)-1], "")
		est := strings.Join(ess, "")
		chao, _ := CharChao()
		for k, e := range ess {
			chae := strings.Split(chao[e], "")
			for x, y := 0, len(chae)-1; x < y; x, y = x+1, y-1 {
				chae[x], chae[y] = chae[y], chae[x]
			}
			ess[k] = strings.Join(chae, "")
		}
		for i, j := 0, len(ess)-1; i < j; i, j = i+1, j-1 {
			ess[i], ess[j] = ess[j], ess[i]
		}
		mysterious := Zebra(12)
		esd := "___('" + mysterious + strings.Join(ess, mysterious) + "')"
		parseStrs[est] = esd
	}
	for k, v := range parseStrs {
		content = strings.Replace(content, `"`+k+`"`, v, -1)
	}
	fmt.Println("字串混淆加密已处理 " + strconv.Itoa(len(strs)) + " 个数据")
	fmt.Println("准备覆盖部分词根...")

	wi := 0
	for _, w := range EncryptionDel {
		content = strings.Replace(content, w, "", -1)
		wi += 1
	}
	for _, ww := range EncryptionWords {
		for _, w := range ww {
			wn := NanoOL(Rand(7, 13))
			content = strings.Replace(content, w, wn, -1)
			wi += 1
		}
	}
	for _, w := range EncryptionWordsStrict {
		wn := NanoOL(Rand(7, 13))
		reg, _ = regexp.Compile(`\b` + w + `\b`)
		content = reg.ReplaceAllString(content, wn)
		wi += 1
	}
	fmt.Println("字串部分词根已覆盖 " + strconv.Itoa(wi) + " 个数据")
	contents := strings.Split(content, codeSpilt)
	for i, v := range data {
		v["code"] = contents[i]
	}
	return data
}
