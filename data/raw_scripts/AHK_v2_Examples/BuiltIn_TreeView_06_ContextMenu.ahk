#Requires AutoHotkey v2.0
/**
 * BuiltIn_TreeView_06_ContextMenu.ahk
 *
 * DESCRIPTION:
 * Demonstrates implementing context menus (right-click menus) for TreeView
 * controls with dynamic menu items based on selected nodes.
 *
 * FEATURES:
 * - Creating context menus for TreeView items
 * - Dynamic menu items based on selection
 * - Menu item handlers and callbacks
 * - Multi-level context menus
 * - Clipboard operations via context menu
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/TreeView.htm
 * https://www.autohotkey.com/docs/v2/lib/Menu.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - Menu object creation and management
 * - Context menu activation
 * - Dynamic menu modification
 * - Event-driven menu handlers
 *
 * LEARNING POINTS:
 * 1. Context menus shown via ContextMenu event or right-click
 * 2. Menu items can be added/removed dynamically
 * 3. Menu handlers receive item name as parameter
 * 4. Menus can have submenus for organization
 * 5. Check marks and icons enhance menu usability
 */

;=============================================================================
; EXAMPLE 1: Basic Context Menu
;=============================================================================
; Simple right-click context menu for TreeView

Example1_BasicContextMenu() {
    myGui := Gui("+Resize", "Example 1: Basic Context Menu")
    
    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h400")
    
    ; Build tree
    Root := TV.Add("My Files")
    Folder1 := TV.Add("Documents", Root)
    TV.Add("File1.txt", Folder1)
    TV.Add("File2.txt", Folder1)
    Folder2 := TV.Add("Pictures", Root)
    TV.Add("Photo1.jpg", Folder2)
    TV.Add("Photo2.jpg", Folder2)
    TV.Modify(Root, "Expand")
    
    ; Create context menu
    ContextMenu := Menu()
    ContextMenu.Add("Rename", MenuHandler)
    ContextMenu.Add("Delete", MenuHandler)
    ContextMenu.Add()  ; Separator
    ContextMenu.Add("Properties", MenuHandler)
    
    ; Handle right-click
    TV.OnEvent("ContextMenu", ShowContextMenu)
    
    ShowContextMenu(GuiCtrl, Item, IsRightClick, X, Y) {
        if (Item) {
            ; Select the item
            TV.Modify(Item, "Select")
            ; Show menu
            ContextMenu.Show(X, Y)
        }
    }
    
    MenuHandler(ItemName, ItemPos, MyMenu) {
        selected := TV.GetSelection()
        if (!selected)
            return
        
        itemText := TV.GetText(selected)
        
        switch ItemName {
            case "Rename":
                newName := InputBox("Enter new name:", "Rename", "w300 h100", itemText)
                if (newName.Result = "OK" && newName.Value)
                    TV.Modify(selected, newName.Value)
            
            case "Delete":
                result := MsgBox("Delete " . itemText . "?", "Confirm", "YesNo 32")
                if (result = "Yes")
                    TV.Delete(selected)
            
            case "Properties":
                parent := TV.GetParent(selected)
                parentText := parent ? TV.GetText(parent) : "None"
                childCount := 0
                child := TV.GetChild(selected)
                while (child) {
                    childCount++
                    child := TV.GetNext(child)
                }
                
                info := "Name: " . itemText . "`n"
                info .= "Parent: " . parentText . "`n"
                info .= "Children: " . childCount
                
                MsgBox(info, "Properties", 64)
        }
    }
    
    infoText := myGui.Add("Text", "xm y+10 w500",
        "Right-click on any item to show context menu with Rename, Delete, and Properties.")
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())
    
    myGui.Show()
}

;=============================================================================
; EXAMPLE 2: Dynamic Context Menu
;=============================================================================
; Context menu that changes based on selected item type

Example2_DynamicMenu() {
    myGui := Gui("+Resize", "Example 2: Dynamic Context Menu")
    
    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h400")
    
    ; Build tree with different types
    Root := TV.Add("Project")
    
    Folders := TV.Add("Folders", Root)
    Folder1 := TV.Add("Source Code", Folders)
    TV.Add("main.ahk", Folder1)
    TV.Add("lib.ahk", Folder1)
    
    Folder2 := TV.Add("Documentation", Folders)
    TV.Add("README.md", Folder2)
    
    TV.Modify(Root, "Expand")
    TV.Modify(Folders, "Expand")
    
    ; Item types tracker
    itemTypes := Map()
    itemTypes[Root] := "root"
    itemTypes[Folders] := "category"
    itemTypes[Folder1] := "folder"
    itemTypes[Folder2] := "folder"
    
    ; Mark files
    MarkFilesRecursive(TV, Root, itemTypes)
    
    ; Create different menus
    FolderMenu := Menu()
    FolderMenu.Add("New File...", FolderMenuHandler)
    FolderMenu.Add("New Folder...", FolderMenuHandler)
    FolderMenu.Add()
    FolderMenu.Add("Rename", FolderMenuHandler)
    FolderMenu.Add("Delete Folder", FolderMenuHandler)
    
    FileMenu := Menu()
    FileMenu.Add("Open", FileMenuHandler)
    FileMenu.Add("Edit", FileMenuHandler)
    FileMenu.Add()
    FileMenu.Add("Rename", FileMenuHandler)
    FileMenu.Add("Delete", FileMenuHandler)
    FileMenu.Add()
    FileMenu.Add("Properties", FileMenuHandler)
    
    RootMenu := Menu()
    RootMenu.Add("New Folder...", RootMenuHandler)
    RootMenu.Add("Expand All", RootMenuHandler)
    RootMenu.Add("Collapse All", RootMenuHandler)
    
    ; Handle context menu
    TV.OnEvent("ContextMenu", ShowContextMenu)
    
    ShowContextMenu(GuiCtrl, Item, IsRightClick, X, Y) {
        if (!Item)
            return
        
        TV.Modify(Item, "Select")
        
        ; Determine item type and show appropriate menu
        itemType := itemTypes.Has(Item) ? itemTypes[Item] : "file"
        
        switch itemType {
            case "root", "category":
                RootMenu.Show(X, Y)
            case "folder":
                FolderMenu.Show(X, Y)
            case "file":
                FileMenu.Show(X, Y)
        }
    }
    
    FolderMenuHandler(ItemName, ItemPos, MyMenu) {
        selected := TV.GetSelection()
        if (!selected)
            return
        
        switch ItemName {
            case "New File...":
                name := InputBox("Enter file name:", "New File", "w300 h100")
                if (name.Result = "OK" && name.Value) {
                    newID := TV.Add(name.Value, selected)
                    itemTypes[newID] := "file"
                    TV.Modify(selected, "Expand")
                }
            
            case "New Folder...":
                name := InputBox("Enter folder name:", "New Folder", "w300 h100")
                if (name.Result = "OK" && name.Value) {
                    newID := TV.Add(name.Value, selected)
                    itemTypes[newID] := "folder"
                    TV.Modify(selected, "Expand")
                }
            
            case "Rename":
                oldName := TV.GetText(selected)
                newName := InputBox("Enter new name:", "Rename", "w300 h100", oldName)
                if (newName.Result = "OK" && newName.Value)
                    TV.Modify(selected, newName.Value)
            
            case "Delete Folder":
                result := MsgBox("Delete this folder and all contents?", "Confirm", "YesNo 32")
                if (result = "Yes")
                    TV.Delete(selected)
        }
    }
    
    FileMenuHandler(ItemName, ItemPos, MyMenu) {
        selected := TV.GetSelection()
        if (!selected)
            return
        
        itemText := TV.GetText(selected)
        
        switch ItemName {
            case "Open":
                MsgBox("Opening: " . itemText, "Open", 64)
            
            case "Edit":
                MsgBox("Editing: " . itemText, "Edit", 64)
            
            case "Rename":
                newName := InputBox("Enter new name:", "Rename", "w300 h100", itemText)
                if (newName.Result = "OK" && newName.Value)
                    TV.Modify(selected, newName.Value)
            
            case "Delete":
                TV.Delete(selected)
            
            case "Properties":
                MsgBox("File: " . itemText, "Properties", 64)
        }
    }
    
    RootMenuHandler(ItemName, ItemPos, MyMenu) {
        selected := TV.GetSelection()
        
        switch ItemName {
            case "New Folder...":
                name := InputBox("Enter folder name:", "New Folder", "w300 h100")
                if (name.Result = "OK" && name.Value) {
                    newID := TV.Add(name.Value, selected)
                    itemTypes[newID] := "folder"
                }
            
            case "Expand All":
                ExpandAll(TV, selected)
            
            case "Collapse All":
                CollapseAll(TV, selected)
        }
    }
    
    infoText := myGui.Add("Text", "xm y+10 w500",
        "Different items show different context menus (folders vs files).")
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())
    
    myGui.Show()
}

MarkFilesRecursive(TV, NodeID, itemTypes) {
    child := TV.GetChild(NodeID)
    while (child) {
        if (!TV.GetChild(child))
            itemTypes[child] := "file"
        else
            MarkFilesRecursive(TV, child, itemTypes)
        child := TV.GetNext(child)
    }
}

ExpandAll(TV, NodeID) {
    if (NodeID)
        TV.Modify(NodeID, "Expand")
    child := TV.GetChild(NodeID)
    while (child) {
        ExpandAll(TV, child)
        child := TV.GetNext(child)
    }
}

CollapseAll(TV, NodeID) {
    child := TV.GetChild(NodeID)
    while (child) {
        CollapseAll(TV, child)
        TV.Modify(child, "-Expand")
        child := TV.GetNext(child)
    }
}

;=============================================================================
; EXAMPLE 3: Multi-Level Context Menus
;=============================================================================
; Context menus with submenus

Example3_MultiLevelMenus() {
    myGui := Gui("+Resize", "Example 3: Multi-Level Menus")
    
    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h400")
    
    ; Build tree
    Root := TV.Add("Documents")
    Loop 5 {
        folder := TV.Add("Folder " . A_Index, Root)
        Loop 3 {
            TV.Add("File " . A_Index . ".txt", folder)
        }
    }
    TV.Modify(Root, "Expand")
    
    ; Create submenu for "New"
    NewMenu := Menu()
    NewMenu.Add("Text File", SubMenuHandler)
    NewMenu.Add("Folder", SubMenuHandler)
    NewMenu.Add("HTML File", SubMenuHandler)
    NewMenu.Add("Script File", SubMenuHandler)
    
    ; Create submenu for "Sort"
    SortMenu := Menu()
    SortMenu.Add("By Name (A-Z)", SubMenuHandler)
    SortMenu.Add("By Name (Z-A)", SubMenuHandler)
    SortMenu.Add("By Type", SubMenuHandler)
    
    ; Create submenu for "View"
    ViewMenu := Menu()
    ViewMenu.Add("Expand All", SubMenuHandler)
    ViewMenu.Add("Collapse All", SubMenuHandler)
    ViewMenu.Add()
    ViewMenu.Add("Show Hidden", SubMenuHandler)
    
    ; Main context menu with submenus
    ContextMenu := Menu()
    ContextMenu.Add("New", NewMenu)
    ContextMenu.Add("Sort By", SortMenu)
    ContextMenu.Add()
    ContextMenu.Add("Cut", MainMenuHandler)
    ContextMenu.Add("Copy", MainMenuHandler)
    ContextMenu.Add("Paste", MainMenuHandler)
    ContextMenu.Add()
    ContextMenu.Add("Delete", MainMenuHandler)
    ContextMenu.Add()
    ContextMenu.Add("View", ViewMenu)
    
    ; Show context menu
    TV.OnEvent("ContextMenu", ShowMenu)
    
    ShowMenu(GuiCtrl, Item, IsRightClick, X, Y) {
        if (Item)
            TV.Modify(Item, "Select")
        ContextMenu.Show(X, Y)
    }
    
    SubMenuHandler(ItemName, ItemPos, MyMenu) {
        selected := TV.GetSelection()
        
        switch ItemName {
            case "Text File":
                if (selected) {
                    newID := TV.Add("NewFile.txt", selected)
                    TV.Modify(selected, "Expand")
                    TV.Modify(newID, "Select")
                }
            
            case "Folder":
                if (selected) {
                    newID := TV.Add("New Folder", selected)
                    TV.Modify(selected, "Expand")
                    TV.Modify(newID, "Select")
                }
            
            case "HTML File":
                if (selected) {
                    newID := TV.Add("NewFile.html", selected)
                    TV.Modify(selected, "Expand")
                    TV.Modify(newID, "Select")
                }
            
            case "Script File":
                if (selected) {
                    newID := TV.Add("NewScript.ahk", selected)
                    TV.Modify(selected, "Expand")
                    TV.Modify(newID, "Select")
                }
            
            case "By Name (A-Z)":
                MsgBox("Sorting by name A-Z", "Sort", 64)
            
            case "By Name (Z-A)":
                MsgBox("Sorting by name Z-A", "Sort", 64)
            
            case "Expand All":
                if (selected)
                    ExpandAll(TV, selected)
            
            case "Collapse All":
                if (selected)
                    CollapseAll(TV, selected)
            
            case "Show Hidden":
                MsgBox("Toggle show hidden items", "View", 64)
        }
    }
    
    MainMenuHandler(ItemName, ItemPos, MyMenu) {
        selected := TV.GetSelection()
        if (!selected)
            return
        
        itemText := TV.GetText(selected)
        
        switch ItemName {
            case "Cut":
                MsgBox("Cut: " . itemText, "Cut", 64)
            
            case "Copy":
                MsgBox("Copy: " . itemText, "Copy", 64)
            
            case "Paste":
                MsgBox("Paste at: " . itemText, "Paste", 64)
            
            case "Delete":
                TV.Delete(selected)
        }
    }
    
    infoText := myGui.Add("Text", "xm y+10 w500",
        "Right-click to show context menu with submenus for New, Sort, and View.")
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())
    
    myGui.Show()
}

;=============================================================================
; EXAMPLE 4: Clipboard Operations via Context Menu
;=============================================================================
; Cut/Copy/Paste operations using context menu

Example4_ClipboardOperations() {
    myGui := Gui("+Resize", "Example 4: Clipboard Operations")
    
    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h350")
    
    ; Build tree
    Root := TV.Add("Files")
    Folder1 := TV.Add("Folder 1", Root)
    TV.Add("Item A", Folder1)
    TV.Add("Item B", Folder1)
    Folder2 := TV.Add("Folder 2", Root)
    TV.Add("Item C", Folder2)
    TV.Modify(Root, "Expand")
    
    ; Clipboard state
    clipboard := {active: false, itemText: "", operation: "", sourceParent: 0}
    
    ; Create context menu
    ContextMenu := Menu()
    ContextMenu.Add("Cut", MenuHandler)
    ContextMenu.Add("Copy", MenuHandler)
    ContextMenu.Add("Paste", MenuHandler)
    ContextMenu.Add()
    ContextMenu.Add("Delete", MenuHandler)
    
    ; Status display
    statusText := myGui.Add("Text", "xm y+10 w500 Border", "Ready")
    
    ; Show menu
    TV.OnEvent("ContextMenu", ShowMenu)
    
    ShowMenu(GuiCtrl, Item, IsRightClick, X, Y) {
        if (Item) {
            TV.Modify(Item, "Select")
            
            ; Enable/disable Paste based on clipboard state
            if (clipboard.active && TV.GetChild(Item) != 0 || Item = Root)
                ContextMenu.Enable("Paste")
            else
                ContextMenu.Disable("Paste")
            
            ContextMenu.Show(X, Y)
        }
    }
    
    MenuHandler(ItemName, ItemPos, MyMenu) {
        selected := TV.GetSelection()
        if (!selected)
            return
        
        switch ItemName {
            case "Cut":
                clipboard.active := true
                clipboard.itemText := TV.GetText(selected)
                clipboard.operation := "cut"
                clipboard.sourceID := selected
                clipboard.sourceParent := TV.GetParent(selected)
                TV.Modify(selected, "Bold")
                statusText.Value := "Cut: " . clipboard.itemText . " (Paste into a folder)"
            
            case "Copy":
                clipboard.active := true
                clipboard.itemText := TV.GetText(selected)
                clipboard.operation := "copy"
                clipboard.sourceID := selected
                statusText.Value := "Copied: " . clipboard.itemText . " (Paste into a folder)"
            
            case "Paste":
                if (!clipboard.active)
                    return
                
                ; Paste into selected folder
                if (clipboard.operation = "cut") {
                    ; Move item
                    TV.Delete(clipboard.sourceID)
                    newID := TV.Add(clipboard.itemText, selected)
                    TV.Modify(selected, "Expand")
                    TV.Modify(newID, "Select")
                    statusText.Value := "Moved: " . clipboard.itemText
                    clipboard.active := false
                } else {
                    ; Copy item
                    newID := TV.Add(clipboard.itemText, selected)
                    TV.Modify(selected, "Expand")
                    TV.Modify(newID, "Select")
                    statusText.Value := "Pasted: " . clipboard.itemText
                    ; Keep clipboard active for multiple pastes
                }
            
            case "Delete":
                itemText := TV.GetText(selected)
                TV.Delete(selected)
                statusText.Value := "Deleted: " . itemText
                clipboard.active := false
        }
    }
    
    infoText := myGui.Add("Text", "xm y+10 w500",
        "Use Cut/Copy/Paste from context menu to move or copy items between folders.")
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())
    
    myGui.Show()
}

;=============================================================================
; EXAMPLE 5: Context Menu with Checkmarks
;=============================================================================
; Toggle options with checkmarks in context menu

Example5_MenuCheckmarks() {
    myGui := Gui("+Resize", "Example 5: Menu Checkmarks")
    
    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h400")
    
    ; Build tree
    Root := TV.Add("Project Files")
    Loop 10 {
        TV.Add("File " . A_Index . ".txt", Root)
    }
    TV.Modify(Root, "Expand")
    
    ; View options
    viewOptions := Map(
        "ShowHidden", false,
        "ShowExtensions", true,
        "SortAscending", true
    )
    
    ; Create context menu
    ContextMenu := Menu()
    ContextMenu.Add("Refresh", MenuHandler)
    ContextMenu.Add()
    ContextMenu.Add("Show Hidden Files", MenuHandler)
    ContextMenu.Add("Show File Extensions", MenuHandler)
    ContextMenu.Add("Sort Ascending", MenuHandler)
    ContextMenu.Add()
    ContextMenu.Add("Properties", MenuHandler)
    
    ; Set initial checkmarks
    if (viewOptions["ShowExtensions"])
        ContextMenu.Check("Show File Extensions")
    if (viewOptions["SortAscending"])
        ContextMenu.Check("Sort Ascending")
    
    ; Show menu
    TV.OnEvent("ContextMenu", ShowMenu)
    
    ShowMenu(GuiCtrl, Item, IsRightClick, X, Y) {
        ContextMenu.Show(X, Y)
    }
    
    MenuHandler(ItemName, ItemPos, MyMenu) {
        switch ItemName {
            case "Show Hidden Files":
                viewOptions["ShowHidden"] := !viewOptions["ShowHidden"]
                if (viewOptions["ShowHidden"])
                    ContextMenu.Check(ItemName)
                else
                    ContextMenu.Uncheck(ItemName)
                UpdateStatus()
            
            case "Show File Extensions":
                viewOptions["ShowExtensions"] := !viewOptions["ShowExtensions"]
                if (viewOptions["ShowExtensions"])
                    ContextMenu.Check(ItemName)
                else
                    ContextMenu.Uncheck(ItemName)
                UpdateStatus()
            
            case "Sort Ascending":
                viewOptions["SortAscending"] := !viewOptions["SortAscending"]
                if (viewOptions["SortAscending"])
                    ContextMenu.Check(ItemName)
                else
                    ContextMenu.Uncheck(ItemName)
                UpdateStatus()
            
            case "Refresh":
                MsgBox("Refreshing view...", "Refresh", 64)
            
            case "Properties":
                MsgBox("View properties", "Properties", 64)
        }
    }
    
    ; Status display
    statusText := myGui.Add("Text", "xm y+10 w500", "")
    
    UpdateStatus() {
        status := "View Options: "
        status .= "Hidden=" . (viewOptions["ShowHidden"] ? "On" : "Off") . " | "
        status .= "Extensions=" . (viewOptions["ShowExtensions"] ? "On" : "Off") . " | "
        status .= "Sort=" . (viewOptions["SortAscending"] ? "Asc" : "Desc")
        statusText.Value := status
    }
    
    UpdateStatus()
    
    infoText := myGui.Add("Text", "xm y+5 w500",
        "Right-click to toggle view options. Checkmarks show current state.")
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())
    
    myGui.Show()
}

;=============================================================================
; EXAMPLE 6: Context Menu with Icons
;=============================================================================
; Enhanced context menu with icons

Example6_MenuIcons() {
    myGui := Gui("+Resize", "Example 6: Menu with Icons")
    
    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h400")
    
    ; Build tree
    Root := TV.Add("Documents")
    Folder1 := TV.Add("Work", Root)
    TV.Add("Report.docx", Folder1)
    Folder2 := TV.Add("Personal", Root)
    TV.Add("Photo.jpg", Folder2)
    TV.Modify(Root, "Expand")
    
    ; Create context menu with icons
    ContextMenu := Menu()
    
    ; Add items with icons from shell32.dll
    ContextMenu.Add("New Folder", MenuHandler)
    ContextMenu.SetIcon("New Folder", "shell32.dll", 4)
    
    ContextMenu.Add("Delete", MenuHandler)
    ContextMenu.SetIcon("Delete", "shell32.dll", 131)
    
    ContextMenu.Add()
    
    ContextMenu.Add("Cut", MenuHandler)
    ContextMenu.SetIcon("Cut", "shell32.dll", 262)
    
    ContextMenu.Add("Copy", MenuHandler)
    ContextMenu.SetIcon("Copy", "shell32.dll", 135)
    
    ContextMenu.Add("Paste", MenuHandler)
    ContextMenu.SetIcon("Paste", "shell32.dll", 261)
    
    ContextMenu.Add()
    
    ContextMenu.Add("Properties", MenuHandler)
    ContextMenu.SetIcon("Properties", "shell32.dll", 166)
    
    ; Show menu
    TV.OnEvent("ContextMenu", ShowMenu)
    
    ShowMenu(GuiCtrl, Item, IsRightClick, X, Y) {
        if (Item)
            TV.Modify(Item, "Select")
        ContextMenu.Show(X, Y)
    }
    
    MenuHandler(ItemName, ItemPos, MyMenu) {
        selected := TV.GetSelection()
        if (!selected)
            return
        
        itemText := TV.GetText(selected)
        
        switch ItemName {
            case "New Folder":
                newID := TV.Add("New Folder", selected)
                TV.Modify(selected, "Expand")
                TV.Modify(newID, "Select")
            
            case "Delete":
                TV.Delete(selected)
            
            case "Cut", "Copy", "Paste":
                MsgBox(ItemName . ": " . itemText, ItemName, 64)
            
            case "Properties":
                MsgBox("Properties of: " . itemText, "Properties", 64)
        }
    }
    
    infoText := myGui.Add("Text", "xm y+10 w500",
        "Context menu with icons from shell32.dll for better visual feedback.")
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())
    
    myGui.Show()
}

;=============================================================================
; EXAMPLE 7: Complete Context Menu System
;=============================================================================
; Full-featured context menu with all features combined

Example7_CompleteSystem() {
    myGui := Gui("+Resize", "Example 7: Complete Context Menu System")
    
    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h350")
    
    ; Build tree
    Root := TV.Add("Project")
    Src := TV.Add("src", Root)
    TV.Add("main.ahk", Src)
    TV.Add("lib.ahk", Src)
    Docs := TV.Add("docs", Root)
    TV.Add("README.md", Docs)
    TV.Modify(Root, "Expand")
    
    ; Clipboard
    clipboard := {active: false, itemText: "", operation: ""}
    
    ; Create comprehensive menu structure
    NewMenu := Menu()
    NewMenu.Add("File", SubMenuHandler)
    NewMenu.SetIcon("File", "shell32.dll", 1)
    NewMenu.Add("Folder", SubMenuHandler)
    NewMenu.SetIcon("Folder", "shell32.dll", 4)
    
    ViewMenu := Menu()
    ViewMenu.Add("Expand All", SubMenuHandler)
    ViewMenu.Add("Collapse All", SubMenuHandler)
    ViewMenu.Add()
    ViewMenu.Add("Refresh", SubMenuHandler)
    
    ContextMenu := Menu()
    ContextMenu.Add("New", NewMenu)
    ContextMenu.SetIcon("New", "shell32.dll", 259)
    ContextMenu.Add()
    ContextMenu.Add("Cut", MainHandler)
    ContextMenu.SetIcon("Cut", "shell32.dll", 262)
    ContextMenu.Add("Copy", MainHandler)
    ContextMenu.SetIcon("Copy", "shell32.dll", 135)
    ContextMenu.Add("Paste", MainHandler)
    ContextMenu.SetIcon("Paste", "shell32.dll", 261)
    ContextMenu.Add()
    ContextMenu.Add("Rename", MainHandler)
    ContextMenu.Add("Delete", MainHandler)
    ContextMenu.SetIcon("Delete", "shell32.dll", 131)
    ContextMenu.Add()
    ContextMenu.Add("View", ViewMenu)
    ContextMenu.Add("Properties", MainHandler)
    ContextMenu.SetIcon("Properties", "shell32.dll", 166)
    
    ; Show menu
    TV.OnEvent("ContextMenu", ShowMenu)
    
    ShowMenu(GuiCtrl, Item, IsRightClick, X, Y) {
        if (Item) {
            TV.Modify(Item, "Select")
            
            ; Enable/disable Paste
            if (clipboard.active && (TV.GetChild(Item) || Item = Root))
                ContextMenu.Enable("Paste")
            else
                ContextMenu.Disable("Paste")
            
            ContextMenu.Show(X, Y)
        }
    }
    
    SubMenuHandler(ItemName, ItemPos, MyMenu) {
        selected := TV.GetSelection()
        if (!selected)
            return
        
        switch ItemName {
            case "File":
                name := InputBox("File name:", "New File", "w300", "newfile.txt")
                if (name.Result = "OK" && name.Value) {
                    newID := TV.Add(name.Value, selected)
                    TV.Modify(selected, "Expand")
                }
            
            case "Folder":
                name := InputBox("Folder name:", "New Folder", "w300", "newfolder")
                if (name.Result = "OK" && name.Value) {
                    newID := TV.Add(name.Value, selected)
                    TV.Modify(selected, "Expand")
                }
            
            case "Expand All":
                ExpandAll(TV, selected)
            
            case "Collapse All":
                CollapseAll(TV, selected)
            
            case "Refresh":
                UpdateStatus("Refreshed")
        }
    }
    
    MainHandler(ItemName, ItemPos, MyMenu) {
        selected := TV.GetSelection()
        if (!selected)
            return
        
        itemText := TV.GetText(selected)
        
        switch ItemName {
            case "Cut":
                clipboard.active := true
                clipboard.itemText := itemText
                clipboard.operation := "cut"
                clipboard.sourceID := selected
                UpdateStatus("Cut: " . itemText)
            
            case "Copy":
                clipboard.active := true
                clipboard.itemText := itemText
                clipboard.operation := "copy"
                clipboard.sourceID := selected
                UpdateStatus("Copied: " . itemText)
            
            case "Paste":
                if (!clipboard.active)
                    return
                if (clipboard.operation = "cut") {
                    TV.Delete(clipboard.sourceID)
                    clipboard.active := false
                }
                newID := TV.Add(clipboard.itemText, selected)
                TV.Modify(selected, "Expand")
                UpdateStatus("Pasted: " . clipboard.itemText)
            
            case "Rename":
                newName := InputBox("New name:", "Rename", "w300", itemText)
                if (newName.Result = "OK" && newName.Value)
                    TV.Modify(selected, newName.Value)
            
            case "Delete":
                TV.Delete(selected)
                UpdateStatus("Deleted: " . itemText)
            
            case "Properties":
                ShowProperties(selected)
        }
    }
    
    ShowProperties(itemID) {
        text := TV.GetText(itemID)
        parent := TV.GetParent(itemID)
        parentText := parent ? TV.GetText(parent) : "None"
        childCount := 0
        child := TV.GetChild(itemID)
        while (child) {
            childCount++
            child := TV.GetNext(child)
        }
        
        info := "Name: " . text . "`n"
        info .= "Parent: " . parentText . "`n"
        info .= "Children: " . childCount
        
        MsgBox(info, "Properties", 64)
    }
    
    ; Status
    statusText := myGui.Add("Text", "xm y+10 w500 Border", "Ready")
    
    UpdateStatus(msg) {
        statusText.Value := msg
    }
    
    infoText := myGui.Add("Text", "xm y+5 w500",
        "Complete context menu system with icons, submenus, and clipboard operations.")
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())
    
    myGui.Show()
}

;=============================================================================
; REFERENCE SECTION
;=============================================================================
/*
CONTEXT MENU CREATION:
- MyMenu := Menu() - Create new menu
- MyMenu.Add(ItemName, CallbackOrSubmenu) - Add menu item
- MyMenu.Add() - Add separator
- MyMenu.Show(X, Y) - Show menu at coordinates

MENU METHODS:
- MyMenu.Check(ItemName) - Add checkmark
- MyMenu.Uncheck(ItemName) - Remove checkmark
- MyMenu.Enable(ItemName) - Enable item
- MyMenu.Disable(ItemName) - Disable item
- MyMenu.Delete([ItemName]) - Delete item or all items
- MyMenu.SetIcon(ItemName, FileName, IconNumber) - Set icon

CONTEXT MENU EVENT:
- GuiCtrl.OnEvent("ContextMenu", Callback)
- Callback(GuiCtrl, Item, IsRightClick, X, Y)
- Item = TreeView item ID clicked
- X, Y = Screen coordinates for menu position

MENU HANDLER SIGNATURE:
- Handler(ItemName, ItemPos, MyMenu)
- ItemName = Name of clicked menu item
- ItemPos = Position in menu (1-based)
- MyMenu = Menu object that contains the item

SUBMENUS:
- Create submenu: SubMenu := Menu()
- Add to main menu: MainMenu.Add("Name", SubMenu)
- Handler works same way for submenu items

BEST PRACTICES:
1. Show menu at cursor position (X, Y parameters)
2. Select item before showing menu
3. Enable/disable items based on context
4. Use icons for better UX
5. Group related actions with separators
6. Use submenus to organize many options
7. Provide keyboard shortcuts where applicable

COMMON PATTERNS:
- Dynamic menus based on selection
- Clipboard operations (Cut/Copy/Paste)
- File operations (New/Delete/Rename)
- View options with checkmarks
- Multi-level hierarchical menus
*/

; Uncomment to run examples:
; Example1_BasicContextMenu()
; Example2_DynamicMenu()
; Example3_MultiLevelMenus()
; Example4_ClipboardOperations()
; Example5_MenuCheckmarks()
; Example6_MenuIcons()
; Example7_CompleteSystem()
