#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Diff and Patch - Text differencing algorithm
; Demonstrates LCS-based diff generation

class Diff {
    ; Generate diff between two arrays/strings
    static Compare(a, b) {
        if !IsObject(a)
            a := StrSplit(a, "`n")
        if !IsObject(b)
            b := StrSplit(b, "`n")

        ; Get LCS table
        lcs := this._LCSTable(a, b)
        
        ; Generate diff from LCS
        return this._GenerateDiff(a, b, lcs)
    }

    static _LCSTable(a, b) {
        m := a.Length
        n := b.Length
        
        ; Initialize table
        table := []
        Loop m + 1 {
            row := []
            Loop n + 1
                row.Push(0)
            table.Push(row)
        }

        ; Fill table
        Loop m {
            i := A_Index
            Loop n {
                j := A_Index
                if a[i] = b[j]
                    table[i + 1][j + 1] := table[i][j] + 1
                else
                    table[i + 1][j + 1] := Max(table[i][j + 1], table[i + 1][j])
            }
        }

        return table
    }

    static _GenerateDiff(a, b, lcs) {
        changes := []
        i := a.Length
        j := b.Length

        while i > 0 || j > 0 {
            if i > 0 && j > 0 && a[i] = b[j] {
                changes.InsertAt(1, Map("type", "equal", "line", a[i], "oldIndex", i, "newIndex", j))
                i--, j--
            } else if j > 0 && (i = 0 || lcs[i + 1][j] >= lcs[i][j + 1]) {
                changes.InsertAt(1, Map("type", "add", "line", b[j], "newIndex", j))
                j--
            } else if i > 0 {
                changes.InsertAt(1, Map("type", "remove", "line", a[i], "oldIndex", i))
                i--
            }
        }

        return changes
    }

    ; Generate unified diff format
    static Unified(a, b, options := "") {
        oldName := options.Has("oldName") ? options["oldName"] : "a"
        newName := options.Has("newName") ? options["newName"] : "b"
        context := options.Has("context") ? options["context"] : 3

        if !IsObject(a)
            a := StrSplit(a, "`n")
        if !IsObject(b)
            b := StrSplit(b, "`n")

        changes := this.Compare(a, b)
        
        result := "--- " oldName "`n"
        result .= "+++ " newName "`n"

        ; Group changes into hunks
        hunks := this._CreateHunks(changes, context)
        
        for hunk in hunks {
            result .= Format("@@ -{},{} +{},{} @@`n",
                            hunk["oldStart"], hunk["oldCount"],
                            hunk["newStart"], hunk["newCount"])
            
            for change in hunk["changes"] {
                switch change["type"] {
                    case "equal": result .= " " change["line"] "`n"
                    case "add": result .= "+" change["line"] "`n"
                    case "remove": result .= "-" change["line"] "`n"
                }
            }
        }

        return result
    }

    static _CreateHunks(changes, contextLines) {
        hunks := []
        currentHunk := ""
        lastChangeIndex := 0

        for i, change in changes {
            if change["type"] != "equal" {
                if !currentHunk {
                    currentHunk := Map(
                        "changes", [],
                        "oldStart", change.Has("oldIndex") ? change["oldIndex"] : 0,
                        "newStart", change.Has("newIndex") ? change["newIndex"] : 0,
                        "oldCount", 0,
                        "newCount", 0
                    )
                    
                    ; Add leading context
                    start := Max(1, i - contextLines)
                    Loop i - start {
                        if start + A_Index - 1 <= changes.Length {
                            c := changes[start + A_Index - 1]
                            if c["type"] = "equal"
                                currentHunk["changes"].Push(c)
                        }
                    }
                }

                currentHunk["changes"].Push(change)
                lastChangeIndex := i
                
                if change["type"] = "remove"
                    currentHunk["oldCount"]++
                else if change["type"] = "add"
                    currentHunk["newCount"]++

            } else if currentHunk {
                ; Context after change
                if i - lastChangeIndex <= contextLines {
                    currentHunk["changes"].Push(change)
                    currentHunk["oldCount"]++
                    currentHunk["newCount"]++
                } else {
                    ; Close hunk
                    hunks.Push(currentHunk)
                    currentHunk := ""
                }
            }
        }

        if currentHunk
            hunks.Push(currentHunk)

        return hunks
    }

    ; Apply patch to text
    static Patch(original, diff) {
        if !IsObject(original)
            original := StrSplit(original, "`n")

        result := original.Clone()
        offset := 0

        for change in diff {
            if change["type"] = "remove" {
                idx := change["oldIndex"] + offset
                if idx <= result.Length
                    result.RemoveAt(idx)
                offset--
            } else if change["type"] = "add" {
                idx := change.Has("newIndex") ? change["newIndex"] + offset : result.Length + 1
                result.InsertAt(idx, change["line"])
                offset++
            }
        }

        return result
    }
}

; Demo
oldText := "
(
Line 1
Line 2
Line 3
Line 4
Line 5
)"

newText := "
(
Line 1
Line 2 modified
Line 3
New Line
Line 5
)"

; Generate diff
oldLines := StrSplit(Trim(oldText, "`n"), "`n")
newLines := StrSplit(Trim(newText, "`n"), "`n")

changes := Diff.Compare(oldLines, newLines)

result := "Diff Changes:`n"
for change in changes {
    prefix := change["type"] = "add" ? "+" : (change["type"] = "remove" ? "-" : " ")
    result .= prefix " " change["line"] "`n"
}

MsgBox(result)

; Unified diff
unified := Diff.Unified(oldLines, newLines, Map("oldName", "old.txt", "newName", "new.txt"))
MsgBox("Unified Diff:`n`n" unified)

; Apply patch
patched := Diff.Patch(oldLines, changes)
result := "Patched Result:`n"
for line in patched
    result .= line "`n"

MsgBox(result)
