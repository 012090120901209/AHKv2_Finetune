#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * AHK v2 Utility Functions - Corrected
 * 
 * Binary search, borderless window mode, and window dragging
 */

/**
 * Binary search algorithm - finds element in sorted array
 * 
 * @param {Array} arr - Sorted array to search
 * @param {Any} match - Value to find
 * @param {Integer} r - Right index (defaults to array length)
 * @param {Integer} l - Left index (defaults to 0)
 * @returns {Integer} Index of match (1-based), or -1 if not found
 * 
 * Example: index := binSearch([1, 3, 5, 7, 9, 11], 7)
 */
binSearch(arr, match, r := "", l := 0) {
    ; Set default right index to array length
    if (r = "")
        r := arr.Length

    ; Base case: invalid range
    if (l > r)
        return -1

    ; Calculate middle index
    mid := (l + r) // 2

    ; Check if we found the match
    if (arr[mid] = match)
        return mid

    ; Search left half if match is smaller
    if (arr[mid] > match)
        return binSearch(arr, match, mid - 1, l)

    ; Search right half if match is larger
    if (arr[mid] < match)
        return binSearch(arr, match, r, mid + 1)

    return -1
}

/**
 * Toggle borderless mode for a window (removes title bar and borders)
 * 
 * @param {String} winId - Window identifier (default: "A" for active)
 * @param {String} onOff - "t" = toggle, 1/true = on, 0/false = off
 * 
 * Example: borderlessMode("A", "t")
 */
borderlessMode(winId := "A", onOff := "t") {
    winId := winId ? winId : "A"

    ; Toggle or set borderless mode
    if (onOff = "t") {
        ; Toggle always on top and style
        WinSetAlwaysOnTop(-1, winId)
        WinSetStyle("^0xC40000", winId)  ; Toggle caption and border
    } else if (onOff = 1 || onOff = true || onOff = "On") {
        ; Enable borderless
        WinSetAlwaysOnTop(1, winId)
        WinSetStyle("-0xC40000", winId)  ; Remove caption and border
    } else {
        ; Disable borderless
        WinSetAlwaysOnTop(0, winId)
        WinSetStyle("+0xC40000", winId)  ; Add caption and border
    }

    ; Refresh window to apply changes
    try {
        WinGetPos(&x, &y, &winw, &winh, winId)
        WinMove(x, y, winw + 1, winh, winId)
        WinMove(x, y, winw, winh, winId)
    }
}

/**
 * Enable click-and-drag to move a borderless window
 * 
 * @param {String} winId - Window identifier (default: "A")
 * @param {String} key - Mouse button to use (default: "LButton")
 * 
 * Example: borderlessMove("A", "LButton")
 * Usage: Hold left mouse button and drag to move window
 */
borderlessMove(winId := "A", key := "LButton") {
    winId := winId ? winId : "A"

    ; Wait for window to be active (short timeout)
    if !WinWaitActive(winId, , 0.2)
        return

    ; Check if window is borderless
    try {
        style := WinGetStyle("A")
        WinGetPos(, , &ww, &wh, "A")

        ; Don't move if has border or is fullscreen
        if (style & 0xC40000) || (ww = A_ScreenWidth && wh = A_ScreenHeight)
            return
    } catch {
        return
    }

    ; Get initial mouse position
    MouseGetPos(&mx, &my)

    ; Move window while key is held
    while (GetKeyState(key, "P") && WinActive(winId)) {
        MouseGetPos(&mmx, &mmy)

        ; Only move if mouse position changed
        if (mmx != mx || mmy != my) {
            try {
                WinGetPos(&vlx, &vly, , , "A")
                WinMove(vlx - (mx - mmx), vly - (my - mmy), , , "A")
                mx := mmx
                my := mmy
                Sleep(0)  ; Yield to other threads
            } catch {
                break
            }
        } else {
            Sleep(10)
        }
    }
}

/**
 * Example 1: Binary search demonstrations
 */
BinarySearchExample() {
    ; Test with numbers
    numbers := [1, 3, 5, 7, 9, 11, 13, 15, 17, 19]

    result1 := binSearch(numbers, 7)
    result2 := binSearch(numbers, 15)
    result3 := binSearch(numbers, 8)  ; Not in array

    MsgBox("Searching in: " numbers.Join(", ")
        . "`n`nSearching for 7: Found at index " result1
        . "`nSearching for 15: Found at index " result2
        . "`nSearching for 8: " (result3 = -1 ? "Not found" : "Found at " result3))

    ; Test with strings (must be sorted)
    words := ["apple", "banana", "cherry", "date", "elderberry"]

    result := binSearch(words, "cherry")
    MsgBox("Searching for 'cherry' in: " words.Join(", ")
        . "`n`nFound at index: " result
        . "`nValue: " words[result])
}

/**
 * Example 2: Borderless mode demonstration
 */
BorderlessModeExample() {
    ; Open Notepad
    if !WinExist("ahk_class Notepad")
        Run("notepad.exe")

    WinWait("ahk_class Notepad", , 3)
    WinActivate("ahk_class Notepad")

    MsgBox("Watch Notepad become borderless...")

    ; Enable borderless mode
    borderlessMode("ahk_class Notepad", 1)
    Sleep(2000)

    MsgBox("Now it will return to normal...")

    ; Disable borderless mode
    borderlessMode("ahk_class Notepad", 0)

    MsgBox("Demo complete!")
}

/**
 * Example 3: Borderless move setup
 */
BorderlessMoveExample() {
    MsgBox("This will create a borderless window you can drag.`n`n"
        . "Instructions:`n"
        . "1. A test window will appear`n"
        . "2. The title bar will be removed`n"
        . "3. Hold left mouse button and drag to move`n"
        . "4. Press Escape to end demo")

    ; Create test GUI
    testGui := Gui("+AlwaysOnTop", "Draggable Window")
    testGui.Add("Text", "w300 h50", "Hold left mouse button and drag anywhere to move this window!`n`nPress Escape to exit.")
    testGui.Show()

    ; Make it borderless
    Sleep(500)
    borderlessMode(testGui.Hwnd, 1)

    ; Enable dragging with LButton
    Hotkey("~LButton", (*) => borderlessMove(testGui.Hwnd, "LButton"))
    Hotkey("Escape", (*) => (Hotkey("~LButton", "Off"), testGui.Destroy()))

    MsgBox("Try dragging the window now!")
}

/**
 * Example 4: Performance test for binary search
 */
BinarySearchPerformanceExample() {
    ; Create large sorted array
    largeArray := []
    loop 10000
        largeArray.Push(A_Index * 2)

    ; Measure search time
    startTime := A_TickCount

    ; Search for middle element
    result := binSearch(largeArray, 10000)

    endTime := A_TickCount
    elapsed := endTime - startTime

    MsgBox("Binary Search Performance Test`n`n"
        . "Array size: " largeArray.Length " elements`n"
        . "Searching for: 10000`n"
        . "Found at index: " result "`n"
        . "Time taken: " elapsed " ms`n`n"
        . "Binary search is O(log n) - very fast!")
}

/**
 * Example 5: Compare linear vs binary search
 */
SearchComparisonExample() {
    ; Create sorted array
    arr := []
    loop 1000
        arr.Push(A_Index * 10)

    target := 5000

    ; Linear search
    startTime := A_TickCount
    linearResult := -1
    for index, value in arr {
        if (value = target) {
            linearResult := index
            break
        }
    }
    linearTime := A_TickCount - startTime

    ; Binary search
    startTime := A_TickCount
    binaryResult := binSearch(arr, target)
    binaryTime := A_TickCount - startTime

    MsgBox("Search Comparison (1000 elements)`n`n"
        . "Looking for: " target "`n`n"
        . "Linear Search:`n"
        . "  Result: Index " linearResult "`n"
        . "  Time: " linearTime " ms`n`n"
        . "Binary Search:`n"
        . "  Result: Index " binaryResult "`n"
        . "  Time: " binaryTime " ms`n`n"
        . "Binary search is " Round(linearTime / binaryTime, 2) "x faster!")
}

/**
 * Example 6: Borderless mode with hotkey
 */
BorderlessHotkeyExample() {
    MsgBox("Borderless Mode Hotkey Demo`n`n"
        . "Press Win+B to toggle borderless mode on active window`n"
        . "Press Escape to end demo")

    ; Setup hotkey
    Hotkey("#b", (*) => borderlessMode("A", "t"))
    Hotkey("Escape", (*) => (Hotkey("#b", "Off"), Hotkey("Escape", "Off"), MsgBox("Demo ended")))

    MsgBox("Hotkey active! Try it on Notepad or any window.")
}

MsgBox("Utility Functions Loaded`n`n"
    . "Available Examples:`n"
    . "- BinarySearchExample()`n"
    . "- BorderlessModeExample()`n"
    . "- BorderlessMoveExample()`n"
    . "- BinarySearchPerformanceExample()`n"
    . "- SearchComparisonExample()`n"
    . "- BorderlessHotkeyExample()")

; Uncomment to test:
; BinarySearchExample()
; BorderlessModeExample()
; BorderlessMoveExample()
; BinarySearchPerformanceExample()
; SearchComparisonExample()
; BorderlessHotkeyExample()

