#Requires AutoHotkey v2.0
#SingleInstance Force
; Source: External Libraries/VarSetCapacity_ex11.ah2

myGui := Gui()
myGui.OnEvent("Close", GuiClose)
myGui.OnEvent("Escape", GuiClose)
myGui.Add("Text", , "Type a key name and click Convert.")
ogcEditKeyName := myGui.Add("Edit", "vKeyName w50", "vk4C")
ogcButtonConvert := myGui.Add("Button", "Default", "Convert")
ogcButtonConvert.OnEvent("Click", ButtonConvert.Bind("Normal"))
myGui.Show()

GetKeyChar(Key, WinTitle := 0) {
    thread := WinTitle = 0 ? 0 : DllCall("GetWindowThreadProcessId", "ptr", WinExist(WinTitle), "ptr", 0)
    hkl := DllCall("GetKeyboardLayout", "uint", thread, "ptr")
    vk := GetKeyVK(Key)
    sc := GetKeySC(Key)
    state := Buffer(256, 0)
    ; if 'state' is a UTF-16 string, use 'VarSetStrCapacity(&state, 256)' and replace all instances of 'state.Ptr' with 'StrPtr(state)'
    char := Buffer(4, 0)
    ; if 'char' is a UTF-16 string, use 'VarSetStrCapacity(&char, 4)' and replace all instances of 'char.Ptr' with 'StrPtr(char)'
    n := DllCall("ToUnicodeEx", "uint", vk, "uint", sc, "ptr", state.Ptr, "ptr", char.Ptr, "int", 2, "uint", 0, "ptr",
        hkl)
    return StrGet(char.Ptr, n, "utf-16")
}

ButtonConvert(A_GuiEvent := "", A_GuiControl := "", Info := "", *) {
    oSaved := myGui.Submit(0)
    KeyName := oSaved.KeyName
    MsgBox("GetKeyName: " GetKeyName(KeyName) . "`nGetKeyChar: " GetKeyChar(KeyName))
}

GuiClose(*) {
    GuiEscape()
}

GuiEscape() {
    ExitApp()
}
