#Requires AutoHotkey v2.0
#SingleInstance Force

; Simple join helper that appends text to the passed-in buffer.
Join(text, &buffer) {
    buffer .= text
}

Str := "123"
Join("abc", &Str)
MsgBox(Str)
