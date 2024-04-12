package lib

import (
	"fmt"
	"syscall"
)

var (
	kernel32      *syscall.LazyDLL  = syscall.NewLazyDLL(`kernel32.dll`)
	proc          *syscall.LazyProc = kernel32.NewProc(`SetConsoleTextAttribute`)
	CloseHandle   *syscall.LazyProc = kernel32.NewProc(`CloseHandle`)
	FCBlack       int               = 0
	FCBlue        int               = 1
	FCGreen       int               = 2
	FCCyan        int               = 3
	FCRed         int               = 4
	FCPurple      int               = 5
	FCYellow                        = 6
	FCLightGray   int               = 7
	FCGray        int               = 8
	FCLightBlue   int               = 9
	FCLightGreen  int               = 10
	FCLightCyan   int               = 11
	FCLightRed    int               = 12
	FCLightPurple int               = 13
	FCLightYellow int               = 14
	FCWhite       int               = 15
)

func ColorPrint(i int, s ...interface{}) {
	handle, _, _ := proc.Call(uintptr(syscall.Stdout), uintptr(i))
	fmt.Println(s)
	handle, _, _ = proc.Call(uintptr(syscall.Stdout), uintptr(7))
	CloseHandle.Call(handle)
}
