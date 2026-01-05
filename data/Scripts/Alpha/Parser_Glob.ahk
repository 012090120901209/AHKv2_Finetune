#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Glob Pattern Matcher - File path pattern matching
; Demonstrates wildcard and glob pattern support

class Glob {
    static Match(pattern, str, caseSensitive := false) {
        regex := this.ToRegex(pattern)
        return RegExMatch(str, (caseSensitive ? "" : "i)") regex)
    }

    static ToRegex(pattern) {
        result := "^"
        i := 1
        len := StrLen(pattern)

        while i <= len {
            char := SubStr(pattern, i, 1)
            next := i < len ? SubStr(pattern, i + 1, 1) : ""

            if char = "*" {
                if next = "*" {
                    ; ** matches any path including separators
                    result .= ".*"
                    i++
                } else {
                    ; * matches anything except path separators
                    result .= "[^/\\]*"
                }
            } else if char = "?" {
                ; ? matches single character except path separators
                result .= "[^/\\]"
            } else if char = "[" {
                ; Character class
                classEnd := InStr(pattern, "]", , i + 1)
                if classEnd {
                    classContent := SubStr(pattern, i + 1, classEnd - i - 1)
                    ; Handle negation
                    if SubStr(classContent, 1, 1) = "!"
                        classContent := "^" SubStr(classContent, 2)
                    result .= "[" classContent "]"
                    i := classEnd
                } else {
                    result .= "\["
                }
            } else if char = "{" {
                ; Brace expansion
                braceEnd := InStr(pattern, "}", , i + 1)
                if braceEnd {
                    alternatives := SubStr(pattern, i + 1, braceEnd - i - 1)
                    parts := StrSplit(alternatives, ",")
                    escaped := []
                    for part in parts
                        escaped.Push(this.EscapeRegex(part))
                    result .= "(?:" this.JoinArray(escaped, "|") ")"
                    i := braceEnd
                } else {
                    result .= "\{"
                }
            } else if InStr(".+^$()|\", char) {
                ; Escape regex special characters
                result .= "\" char
            } else {
                result .= char
            }
            i++
        }

        return result "$"
    }

    static EscapeRegex(str) {
        special := ".+*?^$()[]{}|\"
        result := ""
        Loop StrLen(str) {
            char := SubStr(str, A_Index, 1)
            result .= InStr(special, char) ? "\" char : char
        }
        return result
    }

    static JoinArray(arr, sep) {
        result := ""
        for i, v in arr
            result .= (i > 1 ? sep : "") v
        return result
    }

    ; Filter array of paths by glob pattern
    static Filter(patterns, paths, caseSensitive := false) {
        if !IsObject(patterns)
            patterns := [patterns]

        result := []
        for path in paths {
            for pattern in patterns {
                if this.Match(pattern, path, caseSensitive) {
                    result.Push(path)
                    break
                }
            }
        }
        return result
    }
}

; Demo - Basic patterns
patterns := [
    ["*.ahk", "test.ahk", true],
    ["*.ahk", "test.txt", false],
    ["test?.ahk", "test1.ahk", true],
    ["test?.ahk", "test12.ahk", false],
    ["**/*.ahk", "src/lib/utils.ahk", true],
    ["[abc].txt", "a.txt", true],
    ["[abc].txt", "d.txt", false],
    ["[!abc].txt", "d.txt", true],
    ["{foo,bar}.txt", "foo.txt", true],
    ["{foo,bar}.txt", "baz.txt", false]
]

result := "Glob Pattern Matching:`n`n"
for test in patterns {
    pattern := test[1]
    str := test[2]
    expected := test[3]
    matched := Glob.Match(pattern, str)
    status := matched = expected ? "✓" : "✗"
    result .= status " Pattern '" pattern "' vs '" str "': " (matched ? "match" : "no match") "`n"
}

MsgBox(result)

; Demo - Path filtering
files := [
    "src/main.ahk",
    "src/utils.ahk",
    "src/lib/helper.ahk",
    "tests/test_main.ahk",
    "docs/readme.md",
    "config.json",
    "build.ahk"
]

result := "Path Filtering:`n`nAll files: " files.Length "`n`n"

; Filter by pattern
ahkFiles := Glob.Filter("*.ahk", files)
result .= "*.ahk: " ahkFiles.Length " files`n"
for f in ahkFiles
    result .= "  " f "`n"

srcFiles := Glob.Filter("src/**/*.ahk", files)
result .= "`nsrc/**/*.ahk: " srcFiles.Length " files`n"
for f in srcFiles
    result .= "  " f "`n"

testFiles := Glob.Filter("tests/*.ahk", files)
result .= "`ntests/*.ahk: " testFiles.Length " files`n"
for f in testFiles
    result .= "  " f "`n"

MsgBox(result)

; Demo - Regex conversion
patterns := ["*.txt", "src/**/*.ahk", "test[0-9].ahk", "{foo,bar,baz}.json"]

result := "Glob to Regex Conversion:`n`n"
for pattern in patterns
    result .= pattern " → " Glob.ToRegex(pattern) "`n"

MsgBox(result)
