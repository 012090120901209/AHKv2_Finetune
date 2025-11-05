#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Advanced Loop Example: Recursive Functions and Directory Traversal
; Demonstrates: Recursion, file system traversal, data collection

; Recursive file search
SearchFiles(rootPath, pattern := "*.*", &results := "") {
    if (results = "")
        results := []

    ; Search files in current directory
    Loop Files, rootPath "\" pattern, "F"
    {
        results.Push(Map(
            "path", A_LoopFilePath,
            "name", A_LoopFileName,
            "size", A_LoopFileSize,
            "modified", A_LoopFileTimeModified,
            "type", "file"
        ))
    }

    ; Recursively search subdirectories
    Loop Files, rootPath "\*", "D"
    {
        SearchFiles(A_LoopFilePath, pattern, &results)
    }

    return results
}

; Recursive directory tree builder
BuildDirectoryTree(rootPath, indent := 0) {
    tree := ""

    ; Add current directory
    if (indent = 0) {
        tree .= rootPath "`n"
    }

    ; List files
    Loop Files, rootPath "\*.*", "F"
    {
        tree .= StrReplace(Format("{:" (indent + 1) * 2 "}", ""), " ", " ") "├─ 📄 " A_LoopFileName "`n"
    }

    ; List and recurse into subdirectories
    Loop Files, rootPath "\*", "D"
    {
        tree .= StrReplace(Format("{:" (indent + 1) * 2 "}", ""), " ", " ") "├─ 📁 " A_LoopFileName "`n"

        ; Recursively process subdirectory (limit depth)
        if (indent < 3) {
            tree .= BuildDirectoryTree(A_LoopFilePath, indent + 1)
        }
    }

    return tree
}

; Fibonacci sequence (classic recursion example)
Fibonacci(n) {
    if (n <= 1)
        return n
    return Fibonacci(n - 1) + Fibonacci(n - 2)
}

; Optimized Fibonacci with memoization
FibonacciMemo(n, &cache := "") {
    if (cache = "")
        cache := Map()

    if (n <= 1)
        return n

    if (cache.Has(n))
        return cache[n]

    result := FibonacciMemo(n - 1, &cache) + FibonacciMemo(n - 2, &cache)
    cache[n] := result

    return result
}

; Factorial (recursive)
Factorial(n) {
    if (n <= 1)
        return 1
    return n * Factorial(n - 1)
}

; Calculate directory size recursively
GetDirectorySize(path) {
    totalSize := 0

    ; Add file sizes
    Loop Files, path "\*.*", "F"
    {
        totalSize += A_LoopFileSize
    }

    ; Recursively add subdirectory sizes
    Loop Files, path "\*", "D"
    {
        totalSize += GetDirectorySize(A_LoopFilePath)
    }

    return totalSize
}

; GUI for recursive operations
myGui := Gui()
myGui.Title := "Recursive Operations Demo"

myGui.Add("Text", "x10 y10", "Recursion Examples:")

; File search section
myGui.Add("GroupBox", "x10 y35 w460 h90", "File Search")
myGui.Add("Text", "x20 y55", "Directory:")
pathInput := myGui.Add("Edit", "x100 y52 w250", A_ScriptDir)
myGui.Add("Button", "x360 y51 w100", "Browse").OnEvent("Click", BrowseDir)
myGui.Add("Text", "x20 y85", "Pattern:")
patternInput := myGui.Add("Edit", "x100 y82 w150", "*.ahk")
myGui.Add("Button", "x260 y81 w100", "Search Files").OnEvent("Click", DoSearch)

; Mathematical recursion
myGui.Add("GroupBox", "x10 y135 w460 h90", "Mathematical Recursion")
myGui.Add("Text", "x20 y160", "Calculate:")
myGui.Add("Button", "x100 y157 w100", "Fibonacci").OnEvent("Click", CalcFib)
myGui.Add("Button", "x210 y157 w100", "Factorial").OnEvent("Click", CalcFact)
myGui.Add("Text", "x20 y190", "n =")
mathInput := myGui.Add("Edit", "x60 y187 w50 Number", "10")
mathResult := myGui.Add("Edit", "x120 y187 w340 ReadOnly")

; Directory operations
myGui.Add("GroupBox", "x10 y235 w460 h70", "Directory Operations")
myGui.Add("Button", "x20 y260 w140", "Show Tree").OnEvent("Click", ShowTree)
myGui.Add("Button", "x170 y260 w140", "Calculate Size").OnEvent("Click", CalcSize)
sizeResult := myGui.Add("Edit", "x320 y260 w140 ReadOnly")

; Results
myGui.Add("Text", "x10 y315", "Results:")
results := myGui.Add("Edit", "x10 y335 w460 h200 ReadOnly Multi")

myGui.Show("w480 h550")

BrowseDir(*) {
    selected := DirSelect(, 3, "Select directory to search")
    if (selected)
        pathInput.Value := selected
}

DoSearch(*) {
    global results

    path := pathInput.Value
    pattern := patternInput.Value

    if (!DirExist(path)) {
        MsgBox("Directory does not exist!", "Error")
        return
    }

    results.Value := "Searching..."

    ; Perform recursive search
    fileList := []
    SearchFiles(path, pattern, &fileList)

    ; Display results
    output := "Found " fileList.Length " files matching '" pattern "':`n`n"

    for file in fileList {
        size := Round(file["size"] / 1024, 2)
        output .= file["name"] " (" size " KB)`n"
    }

    results.Value := output
}

CalcFib(*) {
    global mathResult

    n := Integer(mathInput.Value)

    if (n > 40) {
        MsgBox("Value too large for demo (use n ≤ 40)", "Warning")
        return
    }

    startTime := A_TickCount

    ; Use memoized version for better performance
    cache := Map()
    result := FibonacciMemo(n, &cache)

    elapsed := A_TickCount - startTime

    mathResult.Value := "Fibonacci(" n ") = " result " (calculated in " elapsed "ms)"
}

CalcFact(*) {
    global mathResult

    n := Integer(mathInput.Value)

    if (n > 20) {
        MsgBox("Value too large for demo (use n ≤ 20)", "Warning")
        return
    }

    result := Factorial(n)
    mathResult.Value := "Factorial(" n ") = " result
}

ShowTree(*) {
    global results

    path := pathInput.Value

    if (!DirExist(path)) {
        MsgBox("Directory does not exist!", "Error")
        return
    }

    results.Value := "Building directory tree...`n"

    tree := BuildDirectoryTree(path)
    results.Value := tree
}

CalcSize(*) {
    global sizeResult

    path := pathInput.Value

    if (!DirExist(path)) {
        MsgBox("Directory does not exist!", "Error")
        return
    }

    sizeResult.Value := "Calculating..."

    totalBytes := GetDirectorySize(path)
    totalMB := Round(totalBytes / 1024 / 1024, 2)

    sizeResult.Value := totalMB " MB"
}
