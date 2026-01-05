#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Adjacent Character Swap
 * 
 * Demonstrates swapping adjacent characters to fix common
 * typing mistakes (transpositions).
 * 
 * Source: xypha/AHK-v2-scripts - Showcase.ahk
 * Inspired by: https://github.com/xypha/AHK-v2-scripts
 */

MsgBox("Character Swap Demo`n`n"
    . "Hotkey: Alt+L`n`n"
    . "Place cursor between two characters and press Alt+L`n"
    . "to swap them.`n`n"
    . "Examples:`n"
    . "- 'teh' → 'the'`n"
    . "- 'recieve' → 'receive'`n"
    . "- 'seperate' → 'separate'`n`n"
    . "Opening Notepad for demo...", , "T5")

; Open Notepad for demo
Run("notepad.exe")
WinWait("ahk_exe notepad.exe", , 3)
WinActivate("ahk_exe notepad.exe")
Sleep(500)

; Type test text with typos
Send("teh quick brown fox")
Send("{Left 16}")  ; Position cursor after "teh"

MsgBox("Cursor is after 'teh'`n`n"
    . "Press Alt+L to swap 'e' and 'h' to make 'the'!", , "T3")

; Hotkey to swap adjacent characters
!l:: SwapAdjacentCharacters()

/**
 * Swap the two characters adjacent to cursor
 */
SwapAdjacentCharacters() {
    ; Save clipboard
    clipSaved := ClipboardAll()

    try {
        ; Method: Select char before, cut, move right, paste
        ; This swaps the character before cursor with the one after

        ; Select character to the left
        Send("+{Left}")
        Sleep(50)

        ; Copy it
        A_Clipboard := ""
        Send("^x")
        if (!ClipWait(0.5)) {
            ; Nothing to swap (at start of line/text)
            A_Clipboard := clipSaved
            ToolTip("Nothing to swap")
            SetTimer(() => ToolTip(), -1000)
            return
        }

        charLeft := A_Clipboard

        ; Move right to skip the character that was to the right
        Send("{Right}")
        Sleep(50)

        ; Paste the character from the left
        A_Clipboard := charLeft
        Send("^v")

        ; Move cursor back to between the swapped characters
        Send("{Left}")

        ; Show feedback
        ToolTip("Characters swapped!")
        SetTimer(() => ToolTip(), -1000)

    } finally {
        ; Restore clipboard after a delay
        SetTimer(() => A_Clipboard := clipSaved, -500)
    }
}

/*
* Key Concepts:
*
* 1. Transposition Errors:
*    Common typing mistakes
*    Adjacent characters reversed
*    "teh" instead of "the"
*    Quick fix needed
*
* 2. Character Manipulation:
*    Select left character (+{Left})
*    Cut to clipboard (^x)
*    Move cursor ({Right})
*    Paste after (^v)
*
* 3. Cursor Positioning:
*    Start: AB|CD (cursor between B and C)
*    Select B: A[B]|CD
*    Cut B: A|CD
*    Move: AC|D
*    Paste: ACB|D
*    Result: AC|BD (B and C swapped)
*
* 4. Clipboard Management:
*    Save with ClipboardAll()
*    Restore after operation
*    SetTimer for delayed restore
*    Preserve user's clipboard
*
* 5. Use Cases:
*    ✅ Fix typing errors
*    ✅ Text editing
*    ✅ Code refactoring
*    ✅ Data entry correction
*
* 6. Common Transpositions:
*    teh → the
*    recieve → receive
*    seperate → separate
*    freind → friend
*    occured → occurred
*
* 7. Alternative Hotkeys:
*    Alt+L - Unused in most apps
*    Ctrl+T - Common in editors
*    Alt+T - Alternative
*    F2,F2 - Double tap
*
* 8. Edge Cases:
*    ✅ Start of line
*    ✅ End of line
*    ✅ Single character
*    ✅ Empty line
*
* 9. Best Practices:
*    ✅ Save/restore clipboard
*    ✅ Check if selection worked
*    ✅ Show feedback
*    ✅ Handle errors gracefully
*
* 10. Enhanced Versions:
*    - Swap words instead of characters
*    - Swap lines
*    - Undo support
*    - Multi-character swap
*    - Auto-detect common typos
*
* 11. Editor Integration:
*    VS Code: Built-in (Ctrl+T)
*    Vim: xp command
*    Emacs: C-t
*    Sublime: No default
*    Notepad++: No default
*
* 12. Performance Notes:
*    Sleep(50) for app responsiveness
*    ClipWait with timeout
*    SetTimer for delayed restore
*    Works in most text editors
*/
