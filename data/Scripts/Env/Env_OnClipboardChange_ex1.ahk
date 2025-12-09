#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Environment_OnClipboardChange_ex1.ah2

Persistent
OnClipboardChange(ClipChanged)
ClipChanged(Type) {
    ToolTip("Clipboard data type: " Type)
    Sleep(1000)
    ToolTip()
}
