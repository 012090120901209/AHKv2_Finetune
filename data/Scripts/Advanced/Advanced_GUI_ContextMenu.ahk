#Requires AutoHotkey v2.0
#SingleInstance Force
; Advanced GUI Example: ListView with Context Menu
; Demonstrates: Context menus, right-click handling, menu creation

myGui := Gui()
myGui.Title := "File Manager with Context Menu"

LV := myGui.Add("ListView", "x10 y10 w480 h300", ["Name", "Type", "Size", "Modified"])

; Add sample data
LV.Add(, "Document.txt", "Text File", "2.5 KB", "2025-01-15 10:30")
LV.Add(, "Image.png", "Image", "145 KB", "2025-01-14 15:20")
LV.Add(, "Script.ahk", "AutoHotkey Script", "8.3 KB", "2025-01-16 09:15")
LV.Add(, "Data.csv", "CSV File", "52 KB", "2025-01-13 14:45")
LV.Add(, "Report.pdf", "PDF Document", "1.2 MB", "2025-01-12 16:00")

LV.ModifyCol()  ; Auto-size columns
LV.ModifyCol(3, "50")  ; Size column width

; Create context menu
contextMenu := Menu()
contextMenu.Add("Open", MenuHandler)
contextMenu.Add("Edit", MenuHandler)
contextMenu.Add()  ; Separator
contextMenu.Add("Copy Name", MenuHandler)
contextMenu.Add("Copy Path", MenuHandler)
contextMenu.Add()  ; Separator
contextMenu.Add("Properties", MenuHandler)
contextMenu.Add("Delete", MenuHandler)

; Register context menu
LV.OnEvent("ContextMenu", ShowContextMenu)

; Bottom buttons
myGui.Add("Button", "x10 y320 w100", "Refresh").OnEvent("Click", RefreshList)
myGui.Add("Button", "x120 y320 w100", "Add File").OnEvent("Click", AddFile)
infoText := myGui.Add("Text", "x230 y325 w260", "Right-click items for options")

myGui.Show("w500 h360")

ShowContextMenu(GuiCtrl, Item, IsRightClick, X, Y) {
    if (Item) {  ; Only show menu if an item was clicked
        ; Select the row
        LV.Modify(Item, "Select Focus")
        contextMenu.Show(X, Y)
    }
}

MenuHandler(ItemName, ItemPos, MyMenu) {
    row := LV.GetNext()
    if (!row)
        return

    name := LV.GetText(row, 1)
    type := LV.GetText(row, 2)

    Switch ItemName {
        case "Open":
            MsgBox("Opening: " name, "Open File")
        case "Edit":
            MsgBox("Editing: " name, "Edit File")
        case "Copy Name":
            A_Clipboard := name
            infoText.Value := "Copied: " name
        case "Copy Path":
            A_Clipboard := "C:\Files\" name
            infoText.Value := "Copied path to clipboard"
        case "Properties":
            props := "Name: " name "`n"
            props .= "Type: " type "`n"
            props .= "Size: " LV.GetText(row, 3) "`n"
            props .= "Modified: " LV.GetText(row, 4)
            MsgBox(props, "Properties")
        case "Delete":
            result := MsgBox("Delete " name "?", "Confirm Delete", "YesNo Icon?")
            if (result = "Yes") {
                LV.Delete(row)
                infoText.Value := "Deleted: " name
            }
    }
}

RefreshList(*) {
    infoText.Value := "List refreshed"
    LV.ModifyCol()
}

AddFile(*) {
    result := InputBox("Enter file name:", "Add File")
    if (result.Result = "OK" && result.Value != "") {
        timestamp := FormatTime(, "yyyy-MM-dd HH:mm")
        LV.Add(, result.Value, "Unknown", "0 KB", timestamp)
        LV.ModifyCol()
        infoText.Value := "Added: " result.Value
    }
}
