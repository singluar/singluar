package cmd

import (
	"sl/lib"
)

func ProjectExist(singluarData lib.SingluarData) bool {
	if len(singluarData.Args) <= 2 {
		return false
	}
	projectName := singluarData.Args[2]
	if projectName[:1] == "_" {
		lib.Panic("项目名不合法(下划线“_”开始的名称已被禁用)")
	}
	projectDir := singluarData.Projects + "/" + projectName
	return lib.IsDir(projectDir)
}

func ProjectName(singluarData lib.SingluarData) string {
	if singluarData.ProjectName != "" {
		return singluarData.ProjectName
	}
	if len(singluarData.Args) >= 3 {
		return singluarData.Args[2]
	}
	return ""
}
