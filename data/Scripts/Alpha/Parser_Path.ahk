#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Path Parser - File path manipulation
; Demonstrates cross-platform path handling

class PathParser {
    ; Parse path into components
    static Parse(path) {
        result := Map()

        ; Normalize separators
        normalized := StrReplace(path, "/", "\")

        ; Root (drive letter or UNC)
        if RegExMatch(normalized, "^([A-Za-z]:)", &m) {
            result["root"] := m[1] "\"
            normalized := SubStr(normalized, 3)
        } else if SubStr(normalized, 1, 2) = "\\" {
            ; UNC path
            if RegExMatch(normalized, "^(\\\\[^\\]+\\[^\\]+)", &m) {
                result["root"] := m[1]
                normalized := SubStr(normalized, StrLen(m[1]) + 1)
            }
        } else {
            result["root"] := ""
        }

        ; Directory and filename
        lastSlash := 0
        Loop StrLen(normalized) {
            if SubStr(normalized, A_Index, 1) = "\"
                lastSlash := A_Index
        }

        if lastSlash {
            result["dir"] := result["root"] SubStr(normalized, 1, lastSlash - 1)
            result["base"] := SubStr(normalized, lastSlash + 1)
        } else {
            result["dir"] := result["root"]
            result["base"] := LTrim(normalized, "\")
        }

        ; Extension
        dotPos := 0
        base := result["base"]
        Loop StrLen(base) {
            if SubStr(base, A_Index, 1) = "."
                dotPos := A_Index
        }

        if dotPos > 1 {
            result["name"] := SubStr(base, 1, dotPos - 1)
            result["ext"] := SubStr(base, dotPos)
        } else {
            result["name"] := base
            result["ext"] := ""
        }

        return result
    }

    ; Join path segments
    static Join(parts*) {
        result := ""
        for part in parts {
            part := String(part)
            if part = ""
                continue

            ; Normalize separators
            part := StrReplace(part, "/", "\")

            if result = "" || RegExMatch(part, "^[A-Za-z]:|^\\\\") {
                result := part
            } else {
                result := RTrim(result, "\") "\" LTrim(part, "\")
            }
        }
        return result
    }

    ; Get directory name
    static DirName(path) {
        parsed := this.Parse(path)
        return parsed["dir"]
    }

    ; Get base name
    static BaseName(path, ext := "") {
        parsed := this.Parse(path)
        base := parsed["base"]
        if ext && SubStr(base, -StrLen(ext) + 1) = ext
            return SubStr(base, 1, StrLen(base) - StrLen(ext))
        return base
    }

    ; Get extension
    static ExtName(path) {
        parsed := this.Parse(path)
        return parsed["ext"]
    }

    ; Normalize path (resolve . and ..)
    static Normalize(path) {
        path := StrReplace(path, "/", "\")

        ; Extract root
        root := ""
        if RegExMatch(path, "^([A-Za-z]:\\|\\\\[^\\]+\\[^\\]+\\?)", &m) {
            root := m[1]
            path := SubStr(path, StrLen(root) + 1)
        }

        parts := StrSplit(path, "\")
        result := []

        for part in parts {
            if part = "" || part = "."
                continue

            if part = ".." {
                if result.Length > 0 && result[result.Length] != ".."
                    result.Pop()
                else if root = ""
                    result.Push("..")
            } else {
                result.Push(part)
            }
        }

        return root this.JoinArray(result, "\")
    }

    ; Check if path is absolute
    static IsAbsolute(path) {
        return RegExMatch(path, "^([A-Za-z]:|\\\\)")
    }

    ; Get relative path from one path to another
    static Relative(fromPath, toPath) {
        from := StrSplit(this.Normalize(fromPath), "\")
        to := StrSplit(this.Normalize(toPath), "\")

        ; Find common prefix
        common := 0
        minLen := Min(from.Length, to.Length)
        Loop minLen {
            if from[A_Index] != to[A_Index]
                break
            common := A_Index
        }

        ; Build relative path
        result := []
        Loop from.Length - common
            result.Push("..")
        Loop to.Length - common
            result.Push(to[common + A_Index])

        return result.Length ? this.JoinArray(result, "\") : "."
    }

    static JoinArray(arr, sep) {
        result := ""
        for i, v in arr
            result .= (i > 1 ? sep : "") v
        return result
    }
}

; Demo - Parse path
testPaths := [
    "C:\Users\Admin\Documents\file.txt",
    "D:\Projects\src\main.ahk",
    "\\server\share\folder\data.csv",
    "relative\path\to\file.json",
    "..\parent\file.md"
]

result := "Path Parsing:`n`n"
for path in testPaths {
    parsed := PathParser.Parse(path)
    result .= "Path: " path "`n"
    result .= "  root: " parsed["root"] "`n"
    result .= "  dir:  " parsed["dir"] "`n"
    result .= "  base: " parsed["base"] "`n"
    result .= "  name: " parsed["name"] "`n"
    result .= "  ext:  " parsed["ext"] "`n`n"
}

MsgBox(result)

; Demo - Path operations
result := "Path Operations:`n`n"

result .= "Join:`n"
result .= PathParser.Join("C:\Users", "Admin", "Documents", "file.txt") "`n"
result .= PathParser.Join("src", "..", "lib", "utils.ahk") "`n`n"

result .= "Normalize:`n"
result .= PathParser.Normalize("C:\Users\Admin\..\Bob\Documents\.\file.txt") "`n"
result .= PathParser.Normalize("src/../lib/./utils.ahk") "`n`n"

result .= "DirName: " PathParser.DirName("C:\Projects\src\main.ahk") "`n"
result .= "BaseName: " PathParser.BaseName("C:\Projects\src\main.ahk") "`n"
result .= "BaseName(.ahk): " PathParser.BaseName("main.ahk", ".ahk") "`n"
result .= "ExtName: " PathParser.ExtName("archive.tar.gz") "`n`n"

result .= "IsAbsolute:`n"
result .= "C:\path: " PathParser.IsAbsolute("C:\path") "`n"
result .= "relative: " PathParser.IsAbsolute("relative\path") "`n`n"

result .= "Relative:`n"
result .= "From C:\a\b to C:\a\c\d: " PathParser.Relative("C:\a\b", "C:\a\c\d")

MsgBox(result)
