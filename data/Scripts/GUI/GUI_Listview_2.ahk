#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Graphical User Interfaces/Listview_2.ah2

myGui := Gui()
myGui.OnEvent("Close", GuiClose)
ogcListViewIconNumberDescription := myGui.Add("ListView", "h200 w180", ["Icon & Number", "Description"]) ; Create a ListView.
ImageListID := IL_Create(10) ; Create an ImageList to hold 10 small icons.
ogcListViewIconNumberDescription.SetImageList(ImageListID) ; Assign the above ImageList to the current ListView.
loop 10 { ; Load the ImageList with a series of icons from the DLL.
    IL_Add(ImageListID, "shell32.dll", A_Index)
}
loop 10 { ; Add rows to the ListView (for demonstration purposes, one for each icon).
    ogcListViewIconNumberDescription.Add("Icon" . A_Index, A_Index, "n/a")
}
ogcListViewIconNumberDescription.ModifyCol("Hdr") ; Auto-adjust the column widths.
myGui.Show()

GuiClose(*) {
    ExitApp()
}
