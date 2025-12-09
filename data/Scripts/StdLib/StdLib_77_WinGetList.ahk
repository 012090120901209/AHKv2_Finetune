#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* WinGetList() - List all windows
*
* Returns an array of all window IDs matching criteria.
*/

windows := WinGetList(, , "Program Manager")

output := "Total windows: " windows.Length "`n`n"
count := 0

for id in windows {
    if (count >= 10)
    break

    title := WinGetTitle(id)
    if (title) {
        output .= title "`n"
        count++
    }
}

MsgBox(output)
