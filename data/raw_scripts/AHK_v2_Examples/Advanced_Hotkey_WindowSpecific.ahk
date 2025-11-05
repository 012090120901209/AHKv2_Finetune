#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Advanced Hotkey Example: Window-Specific Hotkeys
; Demonstrates: #HotIf with window detection, context-sensitive behavior

; Chrome/Browser-specific hotkeys
#HotIf WinActive("ahk_exe chrome.exe") || WinActive("ahk_exe firefox.exe") || WinActive("ahk_exe msedge.exe")

; Ctrl+Shift+T reopens last closed tab (enhanced)
^+t::
{
    Send("^+t")
    Sleep(100)
    Send("^l")  ; Focus address bar
}

; Quick search with selected text
^+s::
{
    savedClip := A_Clipboard
    A_Clipboard := ""
    Send("^c")
    if !ClipWait(0.5)
        return

    searchText := A_Clipboard
    A_Clipboard := savedClip

    ; Open new tab and search
    Send("^t")
    Sleep(100)
    SendText(searchText)
    Send("{Enter}")
}

; Close all tabs to the right
^+w::
{
    Send("^+{PgDn}")  ; Focus last tab
    Loop 50 {  ; Close up to 50 tabs
        Send("^w")
        Sleep(20)
    }
}

#HotIf

; VS Code / Text Editor specific hotkeys
#HotIf WinActive("ahk_exe Code.exe") || WinActive("ahk_exe notepad++.exe")

; Duplicate line
^d::
{
    Send("{Home}{Shift Down}{End}{Shift Up}")
    Send("^c")
    Send("{End}{Enter}")
    Send("^v")
}

; Delete line
^+k::
{
    Send("{Home}{Shift Down}{Down}{Shift Up}")
    Send("{Delete}")
}

; Insert timestamp comment
^+;::
{
    timestamp := FormatTime(, "yyyy-MM-dd HH:mm")
    SendText("; " timestamp " - ")
}

#HotIf

; Excel-specific hotkeys
#HotIf WinActive("ahk_exe EXCEL.EXE")

; Quick sum formula
^=::
{
    Send("=SUM(){Left}")
}

; Quick average formula
^+a::
{
    Send("=AVERAGE(){Left}")
}

; Auto-fit columns
^+f::
{
    Send("^{Space}")  ; Select column
    Send("!hoi")      ; Format > Column > AutoFit
}

#HotIf

; Outlook-specific hotkeys
#HotIf WinActive("ahk_exe OUTLOOK.EXE")

; Quick reply with template
^+r::
{
    Send("^r")  ; Reply
    Sleep(200)
    template := "Thank you for your email. I will review this and get back to you shortly.`n`nBest regards"
    SendText(template)
}

; Move to Archive folder
^+e::
{
    Send("^+v")  ; Move to folder
    Sleep(100)
    SendText("Archive")
    Send("{Enter}")
}

#HotIf

; File Explorer specific hotkeys
#HotIf WinActive("ahk_class CabinetWClass")

; Open command prompt in current directory
^+c::
{
    Send("!d")  ; Focus address bar
    Sleep(50)
    Send("cmd{Enter}")
}

; Copy file path
^+p::
{
    Send("!d")  ; Focus address bar
    Sleep(50)
    Send("^c")  ; Copy path
    Send("{Escape}")
    ToolTip("Path copied to clipboard")
    SetTimer(() => ToolTip(), -1000)
}

; Create new file
^+n::
{
    Send("!h")  ; Home ribbon
    Send("w")   ; New item
    Send("t")   ; Text document
    Sleep(200)
    ; Automatically ready to type filename
}

#HotIf

; Notepad-specific hotkeys
#HotIf WinActive("ahk_exe notepad.exe")

; Quick save with timestamp
^+s::
{
    currentTime := FormatTime(, "yyyy-MM-dd HH:mm:ss")
    SendText("`n`nLast modified: " currentTime)
    Send("^s")  ; Save
}

; Insert separator line
^+l::
{
    SendText("`n" StrReplace(Format("{:80}", ""), " ", "-") "`n")
}

#HotIf

; Global productivity hotkeys (work everywhere)

; Show active window info
^!i::
{
    WinGetTitle(&title, "A")
    WinGetClass(&class, "A")
    WinGetProcessName(&process, "A")

    info := "Active Window Info:`n`n"
    info .= "Title: " title "`n"
    info .= "Class: " class "`n"
    info .= "Process: " process

    MsgBox(info, "Window Info")
}

; Quick window transparency toggle
^!t::
{
    static isTransparent := false

    if (isTransparent) {
        WinSetTransparent("Off", "A")
        isTransparent := false
    } else {
        WinSetTransparent(200, "A")
        isTransparent := true
    }
}
