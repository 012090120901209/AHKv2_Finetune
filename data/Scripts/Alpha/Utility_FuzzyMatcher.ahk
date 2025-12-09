#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Fuzzy Matcher - Approximate string matching
; Demonstrates fuzzy search algorithms

class FuzzyMatcher {
    ; Simple fuzzy match (characters in order, not necessarily consecutive)
    static Match(pattern, str, caseSensitive := false) {
        if !caseSensitive {
            pattern := StrLower(pattern)
            str := StrLower(str)
        }

        patternIdx := 1
        patternLen := StrLen(pattern)
        strLen := StrLen(str)

        Loop strLen {
            if patternIdx > patternLen
                break
            
            if SubStr(str, A_Index, 1) = SubStr(pattern, patternIdx, 1)
                patternIdx++
        }

        return patternIdx > patternLen
    }

    ; Score a match (higher is better)
    static Score(pattern, str, caseSensitive := false) {
        if !this.Match(pattern, str, caseSensitive)
            return 0

        origStr := str
        if !caseSensitive {
            pattern := StrLower(pattern)
            str := StrLower(str)
        }

        score := 0
        patternIdx := 1
        consecutive := 0
        lastMatch := 0

        Loop StrLen(str) {
            if patternIdx > StrLen(pattern)
                break

            if SubStr(str, A_Index, 1) = SubStr(pattern, patternIdx, 1) {
                score += 1
                
                ; Bonus for consecutive matches
                if A_Index = lastMatch + 1 {
                    consecutive++
                    score += consecutive * 2
                } else {
                    consecutive := 0
                }
                
                ; Bonus for matching at start
                if A_Index = 1
                    score += 10
                
                ; Bonus for matching after separator
                if A_Index > 1 {
                    prev := SubStr(str, A_Index - 1, 1)
                    if InStr(" _-./\", prev)
                        score += 5
                }
                
                ; Bonus for matching uppercase in original (camelCase)
                origChar := SubStr(origStr, A_Index, 1)
                if origChar = SubStr(pattern, patternIdx, 1) && RegExMatch(origChar, "[A-Z]")
                    score += 3

                lastMatch := A_Index
                patternIdx++
            }
        }

        ; Penalty for length difference
        score -= (StrLen(str) - StrLen(pattern)) * 0.1

        return score
    }

    ; Find best matches in a list
    static Find(pattern, items, options := "") {
        limit := options.Has("limit") ? options["limit"] : 10
        threshold := options.Has("threshold") ? options["threshold"] : 0
        caseSensitive := options.Has("caseSensitive") ? options["caseSensitive"] : false
        key := options.Has("key") ? options["key"] : ""

        results := []

        for item in items {
            str := key ? item[key] : item
            score := this.Score(pattern, str, caseSensitive)
            
            if score > threshold
                results.Push(Map("item", item, "score", score))
        }

        ; Sort by score descending
        this._sort(results)

        ; Limit results
        if results.Length > limit
            results.RemoveAt(limit + 1, results.Length - limit)

        return results
    }

    static _sort(arr) {
        ; Simple bubble sort by score
        Loop arr.Length - 1 {
            i := A_Index
            Loop arr.Length - i {
                j := i + A_Index
                if arr[j]["score"] > arr[i]["score"] {
                    temp := arr[i]
                    arr[i] := arr[j]
                    arr[j] := temp
                }
            }
        }
    }

    ; Highlight matched characters
    static Highlight(pattern, str, openTag := "<b>", closeTag := "</b>") {
        if !this.Match(pattern, str)
            return str

        patternLower := StrLower(pattern)
        strLower := StrLower(str)
        patternIdx := 1
        result := ""

        Loop StrLen(str) {
            char := SubStr(str, A_Index, 1)
            charLower := SubStr(strLower, A_Index, 1)
            patternChar := SubStr(patternLower, patternIdx, 1)

            if patternIdx <= StrLen(pattern) && charLower = patternChar {
                result .= openTag char closeTag
                patternIdx++
            } else {
                result .= char
            }
        }

        return result
    }
}

; Demo - Basic matching
patterns := ["fb", "fzb", "fuzbar", "xyz"]
str := "FuzzyBarMatch"

result := "Fuzzy Match Demo:`n`n"
result .= "String: " str "`n`n"

for pattern in patterns {
    matches := FuzzyMatcher.Match(pattern, str)
    score := FuzzyMatcher.Score(pattern, str)
    result .= Format("'{}'  match: {}  score: {:.1f}`n", pattern, matches, score)
}

MsgBox(result)

; Demo - Search list
files := [
    "ApplicationController.ahk",
    "UserService.ahk",
    "DataManager.ahk",
    "AppConfig.ahk",
    "UserModel.ahk",
    "DatabaseConnection.ahk",
    "Logger.ahk",
    "AppSettings.ahk",
    "UserValidator.ahk"
]

searchPattern := "us"

results := FuzzyMatcher.Find(searchPattern, files, Map("limit", 5))

result := "Search for '" searchPattern "':`n`n"
for r in results {
    highlighted := FuzzyMatcher.Highlight(searchPattern, r["item"], "[", "]")
    result .= Format("{:.1f}  {}`n", r["score"], highlighted)
}

MsgBox(result)

; Demo - Search objects with key
commands := [
    Map("name", "File: Open", "shortcut", "Ctrl+O"),
    Map("name", "File: Save", "shortcut", "Ctrl+S"),
    Map("name", "File: Save As", "shortcut", "Ctrl+Shift+S"),
    Map("name", "Edit: Copy", "shortcut", "Ctrl+C"),
    Map("name", "Edit: Paste", "shortcut", "Ctrl+V"),
    Map("name", "View: Fullscreen", "shortcut", "F11"),
    Map("name", "Format: Document", "shortcut", "Ctrl+Shift+F")
]

searchPattern := "fop"
results := FuzzyMatcher.Find(searchPattern, commands, Map("key", "name", "limit", 3))

result := "Command Palette Search for '" searchPattern "':`n`n"
for r in results {
    cmd := r["item"]
    highlighted := FuzzyMatcher.Highlight(searchPattern, cmd["name"], "*", "*")
    result .= Format("{:.1f}  {} ({})`n", r["score"], highlighted, cmd["shortcut"])
}

MsgBox(result)
