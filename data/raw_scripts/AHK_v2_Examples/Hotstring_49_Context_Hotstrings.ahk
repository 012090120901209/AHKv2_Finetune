#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Context-Sensitive Hotstrings
 * Hotstrings that only work in specific applications
 */

; Only works in Notepad
#HotIf WinActive("ahk_exe notepad.exe")
::np::This hotstring only works in Notepad!
::header::=== HEADER ===
#HotIf

; Only works in browsers
#HotIf WinActive("ahk_exe chrome.exe") or WinActive("ahk_exe firefox.exe") or WinActive("ahk_exe msedge.exe")
::localhost::http://localhost:3000
::devtools::F12 to open DevTools
#HotIf

; Only in VS Code or text editors
#HotIf WinActive("ahk_exe Code.exe")
::log::console.log();
::func::function () {`n    `n}
::arrow::() =>
::imp::import  from '';
#HotIf

; Only in Excel
#HotIf WinActive("ahk_exe EXCEL.EXE")
::sum::=SUM()
::avg::=AVERAGE()
#HotIf

; Only in email clients
#HotIf WinActive("ahk_exe OUTLOOK.EXE")
::sig::
(
Best regards,
John Doe
Email: john@company.com
)
#HotIf

; Reset context
#HotIf
::global::This works everywhere!
#HotIf
