#Requires AutoHotkey v2.0
#SingleInstance Force
; Clipboard History Manager
Persistent
global clipHistory := []
global maxHistory := 20

OnClipboardChange(ClipChanged)

^!v:: ShowHistory()

ClipChanged(Type) {
    if (Type = 1) {  ; Text
        text := A_Clipboard
        if (text != "") {
            clipHistory.InsertAt(1, text)
            if (clipHistory.Length > maxHistory)
                clipHistory.Pop()
        }
    }
}

ShowHistory() {
    if (clipHistory.Length = 0)
        return MsgBox("Clipboard history is empty", "Clipboard Manager")

    histGui := Gui()
    histGui.Title := "Clipboard History"
    LV := histGui.Add("ListView", "x10 y10 w500 h300", ["#", "Preview"])

    Loop clipHistory.Length {
        preview := SubStr(StrReplace(clipHistory[A_Index], "`n", " "), 1, 80)
        LV.Add(, A_Index, preview)
    }

    LV.ModifyCol()
    LV.OnEvent("DoubleClick", PasteItem)

    histGui.Add("Button", "x10 y320 w100", "Paste").OnEvent("Click", PasteItem)
    histGui.Add("Button", "x120 y320 w100", "Clear History").OnEvent("Click", ClearHist)
    histGui.Show("w520 h360")

    PasteItem(*) {
        row := LV.GetNext()
        if (row) {
            A_Clipboard := clipHistory[row]
            histGui.Destroy()
            Send("^v")
        }
    }

    ClearHist(*) {
        global clipHistory
        clipHistory := []
        histGui.Destroy()
    }
}
