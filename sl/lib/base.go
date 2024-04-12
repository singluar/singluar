package lib

import (
	"embed"
	gonanoid "github.com/matoous/go-nanoid"
	"github.com/mitchellh/go-ps"
	"github.com/tcolgate/mp3"
	"io/ioutil"
	"math/rand"
	"os"
	"path/filepath"
	"reflect"
	"runtime"
	"strconv"
	"strings"
	"time"
)

var charChao map[string]string
var charChaoAnti map[string]string

func stack() string {
	var buf [2 << 10]byte
	res := string(buf[:runtime.Stack(buf[:], true)])
	res = strings.Replace(res, "Z:/Workspace/war3/singluar/singluar", "", -1)
	return res
}

func Panic(what interface{}) {
	t := reflect.TypeOf(what)
	switch t.Kind() {
	case reflect.String:
		ColorPrint(FCRed, "<EStr>", what)
	case reflect.Ptr:
		ColorPrint(FCRed, "<EPtr>", what)
		ColorPrint(FCRed, "<STACK>", stack())
	default:
		ColorPrint(FCRed, "<KIND>", t.Kind())
	}
	os.Exit(0)
}

// IsFile is_file()
func IsFile(filename string) bool {
	_, err := os.Stat(filename)
	if err != nil || os.IsNotExist(err) {
		return false
	}
	return true
}

// IsDir is_dir()
func IsDir(filename string) bool {
	fd, err := os.Stat(filename)
	if err != nil {
		return false
	}
	fm := fd.Mode()
	return fm.IsDir()
}

// FileSize filesize()
func FileSize(filename string) (int64, error) {
	info, err := os.Stat(filename)
	if err != nil && os.IsNotExist(err) {
		return 0, err
	}
	return info.Size(), nil
}

// FilePutContents file_put_contents()
func FilePutContents(filename string, data string, mode os.FileMode) error {
	return ioutil.WriteFile(filename, []byte(data), mode)
}

// FileGetContents file_get_contents()
func FileGetContents(filename string) (string, error) {
	d, err := ioutil.ReadFile(filename)
	return string(d), err
}

// FileGetContentsEmbeds file_get_contents()
func FileGetContentsEmbeds(f embed.FS, filename string) (string, error) {
	d, err := f.ReadFile(filename)
	return string(d), err
}

// GetModTime 获取文件(架)修改时间 返回unix时间戳
func GetModTime(path string) int64 {
	modTime := int64(0)
	err := filepath.Walk(path, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return nil
		}
		u := info.ModTime().Unix()
		if u > modTime {
			modTime = u
		}
		return nil
	})
	if err != nil {
		return 0
	}
	return modTime
}

// Rand rand()
// Range: [0, 2147483647]
func Rand(min, max int) int {
	if min > max {
		panic("min: min cannot be greater than max")
	}
	// PHP: getrandmax()
	if int31 := 1<<31 - 1; max > int31 {
		panic("max: max can not be greater than " + strconv.Itoa(int31))
	}
	if min == max {
		return min
	}
	r := rand.New(rand.NewSource(time.Now().UnixNano()))
	return r.Intn(max+1-min) + min
}

// InArray in_array()
// haystack supported types: slice, array or map
func InArray(needle interface{}, haystack interface{}) bool {
	val := reflect.ValueOf(haystack)
	switch val.Kind() {
	case reflect.Slice, reflect.Array:
		for i := 0; i < val.Len(); i++ {
			if reflect.DeepEqual(needle, val.Index(i).Interface()) {
				return true
			}
		}
	case reflect.Map:
		for _, k := range val.MapKeys() {
			if reflect.DeepEqual(needle, val.MapIndex(k).Interface()) {
				return true
			}
		}
	default:
		panic("haystack: haystack type muset be slice, array or map")
	}

	return false
}

func ExeRunningQty(names []string) int {
	qty := 0
	pa, _ := ps.Processes()
	for _, p := range pa {
		for _, n := range names {
			if strings.ToLower(p.Executable()) == strings.ToLower(n) {
				qty += 1
			}
		}
	}
	return qty
}

func Shuffle(s []string) []string {
	ns := []string{}
	for _, v := range s {
		ns = append(ns, v)
	}
	length := len(ns) - 1
	times := length
	for {
		if times < 0 {
			break
		}
		random := Rand(0, length)
		temp := ns[times]
		ns[times] = ns[random]
		ns[random] = temp
		times -= 1
	}
	return ns
}

func Nano(n int) string {
	if n < 1 {
		return ""
	}
	var err error
	s1 := ""
	s2 := ""
	if n > 5 {
		s1, err = gonanoid.Generate("_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", 5)
		if err != nil {
			Panic(err)
		}
		s2, err = gonanoid.Generate("_0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", n-5)
		if err != nil {
			Panic(err)
		}
	} else {
		s1, err = gonanoid.Generate("_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", n)
		if err != nil {
			Panic(err)
		}
	}
	return s1 + s2
}

func NanoOL(n int) string {
	s, err := gonanoid.Generate("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", n)
	if err != nil {
		Panic(err)
	}
	return s
}

func Zebra(n int) string {
	letterStr := "abcdefghijklmnopqrstuvwxyxzABCDEFGHIJKLMNOPQRSTUVWXYXZ"
	numberStr := "0123456789"
	if n < 4 {
		n = 4
	}
	if n%2 != 0 {
		n = n + 1
	}
	r := ""
	for j := 0; j < n; j++ {
		if j%2 == 0 {
			k := rand.Intn(len(letterStr) - 1)
			r += letterStr[k:(k + 1)]
		} else {
			k := rand.Intn(len(numberStr) - 1)
			r += numberStr[k:(k + 1)]
		}
	}
	return r
}

func RequireLua(s string) string {
	return "require(\"" + s + "\")"
}

func VoiceDuration(soundFile string) int {
	skipped := 0
	r, err := os.Open(soundFile)
	defer r.Close()
	if err != nil {
		Panic(err)
		return 0
	}
	d := mp3.NewDecoder(r)
	var f mp3.Frame
	dur := 0
	for {
		if err := d.Decode(&f, &skipped); err != nil {
			if err.Error() == "EOF" {
				break
			} else {
				Panic(err)
				return 0
			}
		}
		dur += int(float64(time.Millisecond) * (1000 / float64(f.Header().SampleRate())) * float64(f.Samples()))
	}
	dur = dur / 1000000
	return dur
}

func CharRand() string {
	allStr := "01234abcdefghijklmnopqrstuvwxyxzABCDEFGHIJKLMNOPQRSTUVWXYXZ56789"
	i := rand.Intn(len(allStr) - 1)
	return allStr[i:(i + 1)]
}

func CharChao() (map[string]string, map[string]string) {
	if charChao == nil {
		charChao = make(map[string]string)
		charChaoAnti = make(map[string]string)
		allStr := "01234abcdefghijklmnopqrstuvwxyxz._:!,-ABCDEFGHIJKLMNOPQRSTUVWXYXZ56789"
		for i := 0; i < len(allStr); i++ {
			r := Zebra(10)
			charChao[allStr[i:(i+1)]] = r
			charChaoAnti[r] = allStr[i:(i + 1)]
		}
	}
	return charChao, charChaoAnti
}
