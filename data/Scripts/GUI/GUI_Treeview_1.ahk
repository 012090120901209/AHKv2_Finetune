#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Graphical User Interfaces/Treeview_1.ah2

myGui := Gui()
myGui.OnEvent("Close", GuiClose)
ogcTreeView := myGui.Add("TreeView")
P1 := ogcTreeView.Add("First parent")
P1C1 := ogcTreeView.Add("Parent 1's first child", P1) ; Specify P1 to be this item's parent.
P2 := ogcTreeView.Add("Second parent")
P2C1 := ogcTreeView.Add("Parent 2's first child", P2)
P2C2 := ogcTreeView.Add("Parent 2's second child", P2)
P2C2C1 := ogcTreeView.Add("Child 2's first child", P2C2) myGui.Show() ; Show the window and its TreeView.
GuiClose: ; Exit the script when the user closes the TreeView's GUI window.
    GuiClose()
    ExitApp()
    GuiClose(*) {
        ExitApp()
    }
