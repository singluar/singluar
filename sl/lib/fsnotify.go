package lib

import (
	"fmt"
	"github.com/fsnotify/fsnotify"
	"io/fs"
	"strings"
	"sync"
)

import (
	"os"
	"path/filepath"
)

type NotifyFile struct {
	watch *fsnotify.Watcher
}

var (
	modTimes sync.Map
	notifyC  []string
)

func NewNotifyFile() *NotifyFile {
	w := new(NotifyFile)
	w.watch, _ = fsnotify.NewWatcher()
	return w
}

// WatchDir 监控目录
func (this *NotifyFile) WatchDir(dir string, singluarData SingluarData) {
	filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if info.IsDir() {
			if strings.Index(path, ".git") > 0 {
				return nil
			}
			path, err := filepath.Abs(path)
			if err != nil {
				return err
			}
			err = this.watch.Add(path)
			if err != nil {
				return err
			}
		}
		return nil
	})
	go this.WatchEvent(singluarData) //协程
}

func getName(name string, singluarData SingluarData) string {
	if name[len(name)-4:] != ".lua" {
		return ""
	}
	name = strings.Replace(name, singluarData.Pwd+"\\", "", -1)
	name = strings.Replace(name, ".lua", "", -1)
	name = strings.Replace(name, "\\", "/", -1)
	if strings.Index(name, "builtIn") > 0 {
		// 跳过builtIn
		return ""
	} else if strings.Index(name, "vendor/kernel/library") == 0 {
		name = strings.Replace(name, "vendor/kernel/", "", -1)
		name = strings.Replace(name, "/", ".", -1)
	} else if strings.Index(name, "projects") == 0 {
		name = strings.Replace(name, "projects/"+singluarData.ProjectName+"/", "", -1)
		name = strings.Replace(name, "/", ".", -1)
	} else if strings.Index(name, "assets/war3mapUI") == 0 {
		name = strings.Replace(name, "assets/war3mapUI/", "", -1)
		name = strings.Replace(name, "/", ".", -1)
	} else {
		return ""
	}
	return name
}

func create(name string, singluarData SingluarData) {
	exes := []string{"war3.exe"}
	if ExeRunningQty(exes) < 1 {
		os.Exit(0)
		return
	}
	name = getName(name, singluarData)
	if name == "" {
		return
	}
	if !InArray(name, notifyC) {
		f := singluarData.War3 + "/slhc.txt"
		notifyC = append(notifyC, name)
		err := FilePutContents(f, strings.Join(notifyC, "|"), fs.ModePerm)
		if err != nil {
			fmt.Println(err.Error())
		}
	}
}

func modify(name string, singluarData SingluarData) {
	exes := []string{"war3.exe"}
	if ExeRunningQty(exes) < 1 {
		os.Exit(0)
		return
	}
	mt, _ := modTimes.Load(name)
	if mt != nil && mt.(int64) > 0 && mt.(int64) != GetModTime(name) {
		name = getName(name, singluarData)
		if name == "" {
			return
		}
		f := singluarData.War3 + "/slht.txt"
		var cons []string
		if IsFile(f) {
			con, err := FileGetContents(f)
			if err != nil {
				fmt.Println(err.Error())
				return
			}
			if len(con) > 0 {
				cons = strings.Split(con, "|")
			}
		}
		if !InArray(name, cons) {
			cons = append(cons, name)
			err := FilePutContents(f, strings.Join(cons, "|"), fs.ModePerm)
			if err != nil {
				fmt.Println(err.Error())
				return
			}
		}
	}
	modTimes.Store(name, GetModTime(name))
}

func remove(name string, singluarData SingluarData) {
	exes := []string{"war3.exe"}
	if ExeRunningQty(exes) < 1 {
		os.Exit(0)
		return
	}
	name = getName(name, singluarData)
	if name == "" {
		return
	}
	for k, v := range notifyC {
		if v == name {
			notifyC = append(notifyC[:k], notifyC[(k+1):]...)
			break
		}
	}
	f := singluarData.War3 + `/` + "slhc.txt"
	if IsFile(f) {
		err := FilePutContents(f, strings.Join(notifyC, "|"), fs.ModePerm)
		if err != nil {
			fmt.Println(err.Error())
		}
	}
}

func (this *NotifyFile) WatchEvent(singluarData SingluarData) {
	defer this.watch.Close()
	for {
		select {
		case ev := <-this.watch.Events:
			{
				if ev.Op&fsnotify.Create == fsnotify.Create {
					//获取新创建文件的信息，如果是目录，则加入监控中
					file, err := os.Stat(ev.Name)
					if err == nil {
						if file.IsDir() {
							this.watch.Add(ev.Name)
						} else {
							create(ev.Name, singluarData)
						}
					}
				}

				if ev.Op&fsnotify.Write == fsnotify.Write {
					modify(ev.Name, singluarData)
				}

				if ev.Op&fsnotify.Remove == fsnotify.Remove || ev.Op&fsnotify.Rename == fsnotify.Rename {
					//如果删除或重名文件是目录，则移除监控
					fi, err := os.Stat(ev.Name)
					if err == nil && fi.IsDir() {
						this.watch.Remove(ev.Name)
					} else {
						remove(ev.Name, singluarData)
					}
				}

				//if ev.Op&fsnotify.Chmod == fsnotify.Chmod {
				//	fmt.Println("修改权限 : ", ev.Name)
				//}
			}
		case err := <-this.watch.Errors:
			{
				fmt.Println("error : ", err)
				return
			}
		}
	}
}

func Hot(singluarData SingluarData) {
	if singluarData.War3 == "" {
		return
	}
	ColorPrint(FCGreen, "全局热更新生效中...")
	watch := NewNotifyFile()
	watch.WatchDir(singluarData.Pwd+"/vendor/kernel/library", singluarData)
	watch.WatchDir(singluarData.Pwd+"/assets/war3mapUI", singluarData)
	watch.WatchDir(singluarData.Pwd+"/projects/"+singluarData.ProjectName, singluarData)
	select {}
}
