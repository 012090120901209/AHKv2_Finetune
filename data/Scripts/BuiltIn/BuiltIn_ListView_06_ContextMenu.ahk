#Requires AutoHotkey v2.0

/**
* BuiltIn_ListView_06_ContextMenu.ahk
*
* DESCRIPTION:
* Demonstrates right-click context menus for ListView controls including item-specific
* menus, multi-selection actions, and dynamic menu creation based on context.
*
* FEATURES:
* - Creating context menus for ListView items
* - Right-click event handling
* - Item-specific menu options
* - Multi-selection aware menus
* - Dynamic menu generation
* - Menu icons and separators
* - Clipboard operations from context menu
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/ListView.htm
* https://www.autohotkey.com/docs/v2/lib/Menu.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - ContextMenu event for ListView
* - Menu object creation and management
* - Menu.Add() method syntax
* - Dynamic menu item enabling/disabling
* - GetNext() for multi-selection handling
*
* LEARNING POINTS:
* 1. ContextMenu event provides row number and click position
* 2. Right-click on empty area returns row = 0
* 3. Menus can be created dynamically based on selected items
* 4. Menu items can be enabled/disabled contextually
* 5. Same menu object can be reused with modifications
* 6. GuiContextMenu event fires for all right-clicks
* 7. Context menus enhance user workflow significantly
*/

; ============================================================================
; EXAMPLE 1: Basic Context Menu
; ============================================================================
Example1_BasicContextMenu() {
    MyGui := Gui("+Resize", "Example 1: Basic Context Menu")

    LV := MyGui.Add("ListView", "r12 w650", ["File Name", "Type", "Size"])

    files := [
    ["document.txt", "Text", "5 KB"],
    ["image.jpg", "Image", "1.2 MB"],
    ["video.mp4", "Video", "45 MB"],
    ["script.ahk", "Script", "8 KB"],
    ["data.csv", "Data", "125 KB"],
    ["archive.zip", "Archive", "15 MB"],
    ["photo.png", "Image", "2.1 MB"]
    ]

    for file in files {
        LV.Add(, file*)
    }

    LV.ModifyCol()

    ; Create context menu
    ContextMenu := Menu()
    ContextMenu.Add("&Open", MenuHandler)
    ContextMenu.Add("Open &With...", MenuHandler)
    ContextMenu.Add()  ; Separator
    ContextMenu.Add("&Copy", MenuHandler)
    ContextMenu.Add("&Delete", MenuHandler)
    ContextMenu.Add()  ; Separator
    ContextMenu.Add("P&roperties", MenuHandler)

    ; Attach context menu to ListView
    LV.OnEvent("ContextMenu", ShowContextMenu)

    ShowContextMenu(GuiCtrl, Item, IsRightClick, X, Y) {
        if Item = 0 {
            MsgBox("Right-clicked on empty area")
            return
        }

        ; Show menu at click position
        ContextMenu.Show(X, Y)
    }

    MenuHandler(ItemName, ItemPos, MyMenu) {
        rowNum := LV.GetNext()
        if !rowNum {
            MsgBox("No item selected!")
            return
        }

        fileName := LV.GetText(rowNum, 1)
        MsgBox("Action: " ItemName "`nFile: " fileName)
    }

    MyGui.Add("Text", "w650", "Right-click on any item to see context menu")

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 2: Item-Specific Context Menus
; ============================================================================
Example2_ItemSpecificMenus() {
    MyGui := Gui("+Resize", "Example 2: Item-Specific Menus")

    LV := MyGui.Add("ListView", "r12 w700", ["Item", "Type", "Status"])

    items := [
    ["Project A", "Project", "Active"],
    ["Document 1", "File", "Locked"],
    ["Meeting Notes", "File", "Editable"],
    ["Budget 2025", "File", "Locked"],
    ["Project B", "Project", "Archived"],
    ["Report Q1", "File", "Editable"]
    ]

    for item in items {
        LV.Add(, item*)
    }

    LV.ModifyCol()

    ; Create different menus for different item types
    ProjectMenu := Menu()
    ProjectMenu.Add("Open Project", MenuHandler)
    ProjectMenu.Add("Project Settings", MenuHandler)
    ProjectMenu.Add()
    ProjectMenu.Add("Archive Project", MenuHandler)
    ProjectMenu.Add("Delete Project", MenuHandler)

    FileMenu := Menu()
    FileMenu.Add("Open", MenuHandler)
    FileMenu.Add("Edit", MenuHandler)
    FileMenu.Add("Rename", MenuHandler)
    FileMenu.Add()
    FileMenu.Add("Lock", MenuHandler)
    FileMenu.Add("Unlock", MenuHandler)
    FileMenu.Add()
    FileMenu.Add("Delete", MenuHandler)

    LV.OnEvent("ContextMenu", ShowContextMenu)

    ShowContextMenu(GuiCtrl, Item, IsRightClick, X, Y) {
        if Item = 0
        return

        itemType := LV.GetText(Item, 2)
        status := LV.GetText(Item, 3)

        ; Choose menu based on item type
        if itemType = "Project" {
            ProjectMenu.Show(X, Y)
        } else {
            ; Enable/disable menu items based on status
            if status = "Locked" {
                try FileMenu.Disable("Edit")
                try FileMenu.Disable("Lock")
                try FileMenu.Enable("Unlock")
            } else {
                try FileMenu.Enable("Edit")
                try FileMenu.Enable("Lock")
                try FileMenu.Disable("Unlock")
            }

            FileMenu.Show(X, Y)
        }
    }

    MenuHandler(ItemName, ItemPos, MyMenu) {
        rowNum := LV.GetNext()
        if rowNum {
            itemName := LV.GetText(rowNum, 1)
            MsgBox("Action: " ItemName "`nItem: " itemName)
        }
    }

    MyGui.Add("Text", "w700", "Different context menus based on item type and status")

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 3: Multi-Selection Context Menu
; ============================================================================
Example3_MultiSelectionMenu() {
    MyGui := Gui("+Resize", "Example 3: Multi-Selection Context Menu")

    LV := MyGui.Add("ListView", "r12 w700", ["File", "Size", "Type"])

    files := [
    ["file1.txt", "5 KB", "Text"],
    ["file2.txt", "3 KB", "Text"],
    ["image1.jpg", "1.2 MB", "Image"],
    ["image2.png", "800 KB", "Image"],
    ["video.mp4", "25 MB", "Video"],
    ["document.pdf", "450 KB", "PDF"],
    ["script.ahk", "12 KB", "Script"],
    ["data.csv", "85 KB", "Data"]
    ]

    for file in files {
        LV.Add(, file*)
    }

    LV.ModifyCol()

    ; Context menu with multi-selection options
    ContextMenu := Menu()
    ContextMenu.Add("Open", OpenFiles)
    ContextMenu.Add("Open All Selected", OpenFiles)
    ContextMenu.Add()
    ContextMenu.Add("Copy Selected", CopyFiles)
    ContextMenu.Add("Delete Selected", DeleteFiles)
    ContextMenu.Add()
    ContextMenu.Add("Select All Same Type", SelectSameType)
    ContextMenu.Add()
    ContextMenu.Add("Properties", ShowProperties)

    LV.OnEvent("ContextMenu", ShowContextMenu)

    ShowContextMenu(GuiCtrl, Item, IsRightClick, X, Y) {
        if Item = 0 {
            ; Clicked on empty area - show limited menu
            return
        }

        selectedCount := LV.GetCount("Selected")

        ; Update menu based on selection count
        if selectedCount <= 1 {
            try ContextMenu.Disable("Open All Selected")
            try ContextMenu.Enable("Open")
        } else {
            try ContextMenu.Enable("Open All Selected")
            try ContextMenu.Disable("Open")
        }

        ContextMenu.Show(X, Y)
    }

    OpenFiles(ItemName, ItemPos, MyMenu) {
        count := 0
        fileList := ""
        rowNum := 0

        Loop {
            rowNum := LV.GetNext(rowNum)
            if !rowNum
            break

            count++
            fileList .= LV.GetText(rowNum, 1) "`n"
        }

        MsgBox("Opening " count " file(s):`n`n" fileList)
    }

    CopyFiles(ItemName, ItemPos, MyMenu) {
        count := LV.GetCount("Selected")
        MsgBox("Copied " count " file(s) to clipboard")
    }

    DeleteFiles(ItemName, ItemPos, MyMenu) {
        count := LV.GetCount("Selected")
        result := MsgBox("Delete " count " selected file(s)?", "Confirm Delete", "YesNo Icon!")

        if result = "Yes" {
            ; Delete in reverse order
            Loop LV.GetCount() {
                rowNum := LV.GetCount() - A_Index + 1
                if LV.GetNext(rowNum - 1) = rowNum
                LV.Delete(rowNum)
            }
            MsgBox(count " file(s) deleted!")
        }
    }

    SelectSameType(*) {
        rowNum := LV.GetNext()
        if !rowNum
        return

        fileType := LV.GetText(rowNum, 3)

        ; Select all items of same type
        Loop LV.GetCount() {
            if LV.GetText(A_Index, 3) = fileType
            LV.Modify(A_Index, "Select")
        }
    }

    ShowProperties(*) {
        count := LV.GetCount("Selected")
        totalSize := 0
        types := Map()

        rowNum := 0
        Loop {
            rowNum := LV.GetNext(rowNum)
            if !rowNum
            break

            fileType := LV.GetText(rowNum, 3)
            if !types.Has(fileType)
            types[fileType] := 0
            types[fileType]++
        }

        info := "Selected: " count " file(s)`n`nTypes:`n"
        for type, count in types {
            info .= "  " type ": " count "`n"
        }

        MsgBox(info, "Selection Properties")
    }

    MyGui.Add("Text", "w700", "Select multiple items and right-click (Ctrl+Click for multi-select)")

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 4: Context Menu with Submenus
; ============================================================================
Example4_SubmenuContext() {
    MyGui := Gui("+Resize", "Example 4: Context Menu with Submenus")

    LV := MyGui.Add("ListView", "r10 w700", ["Task", "Priority", "Status"])

    tasks := [
    ["Write Report", "High", "Pending"],
    ["Review Code", "Medium", "In Progress"],
    ["Fix Bug", "Critical", "Pending"],
    ["Update Docs", "Low", "Completed"],
    ["Team Meeting", "Medium", "Pending"]
    ]

    for task in tasks {
        LV.Add(, task*)
    }

    LV.ModifyCol()

    ; Create submenus
    PriorityMenu := Menu()
    PriorityMenu.Add("Critical", SetPriority)
    PriorityMenu.Add("High", SetPriority)
    PriorityMenu.Add("Medium", SetPriority)
    PriorityMenu.Add("Low", SetPriority)

    StatusMenu := Menu()
    StatusMenu.Add("Pending", SetStatus)
    StatusMenu.Add("In Progress", SetStatus)
    StatusMenu.Add("Completed", SetStatus)
    StatusMenu.Add("Blocked", SetStatus)

    ; Main context menu
    ContextMenu := Menu()
    ContextMenu.Add("Edit Task", EditTask)
    ContextMenu.Add()
    ContextMenu.Add("Set Priority", PriorityMenu)
    ContextMenu.Add("Set Status", StatusMenu)
    ContextMenu.Add()
    ContextMenu.Add("Delete Task", DeleteTask)

    LV.OnEvent("ContextMenu", (*) => ContextMenu.Show())

    SetPriority(ItemName, *) {
        rowNum := LV.GetNext()
        if rowNum {
            LV.Modify(rowNum, , , ItemName)
            MsgBox("Priority set to: " ItemName)
        }
    }

    SetStatus(ItemName, *) {
        rowNum := LV.GetNext()
        if rowNum {
            LV.Modify(rowNum, , , , ItemName)
            MsgBox("Status set to: " ItemName)
        }
    }

    EditTask(*) {
        rowNum := LV.GetNext()
        if rowNum {
            taskName := LV.GetText(rowNum, 1)
            MsgBox("Editing task: " taskName)
        }
    }

    DeleteTask(*) {
        rowNum := LV.GetNext()
        if rowNum {
            LV.Delete(rowNum)
            MsgBox("Task deleted!")
        }
    }

    MyGui.Add("Text", "w700", "Right-click to access hierarchical menu options")

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 5: Dynamic Context Menu Generation
; ============================================================================
Example5_DynamicMenus() {
    MyGui := Gui("+Resize", "Example 5: Dynamic Context Menus")

    LV := MyGui.Add("ListView", "r12 w750", ["Product", "Category", "Price", "Stock"])

    products := [
    ["Laptop", "Electronics", "$999", "5"],
    ["Mouse", "Electronics", "$25", "150"],
    ["Desk", "Furniture", "$299", "8"],
    ["Chair", "Furniture", "$199", "12"],
    ["Monitor", "Electronics", "$349", "25"],
    ["Lamp", "Lighting", "$45", "40"],
    ["Keyboard", "Electronics", "$75", "85"]
    ]

    for product in products {
        LV.Add(, product*)
    }

    LV.ModifyCol()

    LV.OnEvent("ContextMenu", BuildDynamicMenu)

    BuildDynamicMenu(GuiCtrl, Item, IsRightClick, X, Y) {
        if Item = 0
        return

        ; Create fresh menu each time
        DynamicMenu := Menu()

        product := LV.GetText(Item, 1)
        category := LV.GetText(Item, 2)
        price := LV.GetText(Item, 3)
        stock := Number(LV.GetText(Item, 4))

        ; Add item-specific title
        DynamicMenu.Add("Product: " product, (*) => "")
        DynamicMenu.Disable("Product: " product)
        DynamicMenu.Add()

        ; Add category-specific options
        DynamicMenu.Add("View All " category, (*) => FilterCategory(category))

        ; Stock-dependent options
        if stock > 50 {
            DynamicMenu.Add("High Stock - Run Promotion", (*) => MsgBox("Promotion for: " product))
        } else if stock < 10 {
            DynamicMenu.Add("Low Stock - Reorder!", (*) => MsgBox("Reordering: " product))
        }

        DynamicMenu.Add()
        DynamicMenu.Add("Edit Product", (*) => MsgBox("Editing: " product))
        DynamicMenu.Add("Delete Product", (*) => DeleteProduct(Item))

        DynamicMenu.Show(X, Y)
    }

    FilterCategory(category) {
        MsgBox("Filtering to show only: " category)
    }

    DeleteProduct(row) {
        product := LV.GetText(row, 1)
        result := MsgBox("Delete " product "?", "Confirm", "YesNo")
        if result = "Yes"
        LV.Delete(row)
    }

    MyGui.Add("Text", "w750", "Context menu changes based on item properties")

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 6: Clipboard Operations via Context Menu
; ============================================================================
Example6_ClipboardMenu() {
    MyGui := Gui("+Resize", "Example 6: Clipboard Context Menu")

    LV := MyGui.Add("ListView", "r12 w700", ["Name", "Email", "Phone", "Department"])

    contacts := [
    ["John Smith", "john@company.com", "555-0101", "Engineering"],
    ["Jane Doe", "jane@company.com", "555-0102", "Marketing"],
    ["Bob Wilson", "bob@company.com", "555-0103", "Sales"],
    ["Alice Brown", "alice@company.com", "555-0104", "Engineering"],
    ["Charlie Davis", "charlie@company.com", "555-0105", "HR"]
    ]

    for contact in contacts {
        LV.Add(, contact*)
    }

    LV.ModifyCol()

    ; Clipboard menu
    ContextMenu := Menu()
    ContextMenu.Add("Copy Name", CopyField)
    ContextMenu.Add("Copy Email", CopyField)
    ContextMenu.Add("Copy Phone", CopyField)
    ContextMenu.Add()
    ContextMenu.Add("Copy Full Row (Tab-Delimited)", CopyRow)
    ContextMenu.Add("Copy All Selected (CSV)", CopySelectedCSV)
    ContextMenu.Add()
    ContextMenu.Add("Copy Entire List", CopyAll)

    LV.OnEvent("ContextMenu", (*) => ContextMenu.Show())

    CopyField(ItemName, *) {
        rowNum := LV.GetNext()
        if !rowNum
        return

        col := (ItemName = "Copy Name") ? 1 : (ItemName = "Copy Email") ? 2 : 3
        value := LV.GetText(rowNum, col)
        A_Clipboard := value
        ToolTip("Copied: " value)
        SetTimer(() => ToolTip(), -2000)
    }

    CopyRow(*) {
        rowNum := LV.GetNext()
        if !rowNum
        return

        row := LV.GetText(rowNum, 1) "`t"
        . LV.GetText(rowNum, 2) "`t"
        . LV.GetText(rowNum, 3) "`t"
        . LV.GetText(rowNum, 4)

        A_Clipboard := row
        ToolTip("Row copied to clipboard")
        SetTimer(() => ToolTip(), -2000)
    }

    CopySelectedCSV(*) {
        output := ""
        rowNum := 0

        Loop {
            rowNum := LV.GetNext(rowNum)
            if !rowNum
            break

            output .= LV.GetText(rowNum, 1) ","
            . LV.GetText(rowNum, 2) ","
            . LV.GetText(rowNum, 3) ","
            . LV.GetText(rowNum, 4) "`n"
        }

        if output != "" {
            A_Clipboard := output
            ToolTip("Copied " LV.GetCount("Selected") " rows as CSV")
            SetTimer(() => ToolTip(), -2000)
        }
    }

    CopyAll(*) {
        output := "Name,Email,Phone,Department`n"  ; Header

        Loop LV.GetCount() {
            output .= LV.GetText(A_Index, 1) ","
            . LV.GetText(A_Index, 2) ","
            . LV.GetText(A_Index, 3) ","
            . LV.GetText(A_Index, 4) "`n"
        }

        A_Clipboard := output
        ToolTip("Copied entire list (" LV.GetCount() " rows)")
        SetTimer(() => ToolTip(), -2000)
    }

    MyGui.Add("Text", "w700", "Right-click for clipboard copy options")

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 7: Advanced Context Menu with Icons
; ============================================================================
Example7_MenuWithIcons() {
    MyGui := Gui("+Resize", "Example 7: Context Menu with Icons")

    ; Note: Menu icons require icon files or system icons
    ; This example shows the structure

    LV := MyGui.Add("ListView", "r10 w650", ["File", "Type", "Modified"])

    files := [
    ["document.docx", "Document", "2025-11-15"],
    ["image.jpg", "Image", "2025-11-14"],
    ["video.mp4", "Video", "2025-11-10"],
    ["script.ahk", "Script", "2025-11-16"]
    ]

    for file in files {
        LV.Add(, file*)
    }

    LV.ModifyCol()

    ; Create context menu with icons
    ContextMenu := Menu()

    ; Add menu items
    ContextMenu.Add("Open", OpenFile)
    ContextMenu.Add("Edit", EditFile)
    ContextMenu.Add("Rename", RenameFile)
    ContextMenu.Add()
    ContextMenu.Add("Copy", CopyFile)
    ContextMenu.Add("Cut", CutFile)
    ContextMenu.Add("Paste", PasteFile)
    ContextMenu.Add()
    ContextMenu.Add("Delete", DeleteFile)
    ContextMenu.Add()
    ContextMenu.Add("Properties", ShowProps)

    ; Set icons for menu items (using shell32.dll icons)
    try {
        ContextMenu.SetIcon("Open", "shell32.dll", 3)
        ContextMenu.SetIcon("Edit", "shell32.dll", 70)
        ContextMenu.SetIcon("Delete", "shell32.dll", 31)
        ContextMenu.SetIcon("Properties", "shell32.dll", 21)
    }

    LV.OnEvent("ContextMenu", (*) => ContextMenu.Show())

    OpenFile(*) {
        rowNum := LV.GetNext()
        if rowNum {
            fileName := LV.GetText(rowNum, 1)
            MsgBox("Opening: " fileName)
        }
    }

    EditFile(*) {
        rowNum := LV.GetNext()
        if rowNum {
            fileName := LV.GetText(rowNum, 1)
            MsgBox("Editing: " fileName)
        }
    }

    RenameFile(*) {
        rowNum := LV.GetNext()
        if rowNum {
            oldName := LV.GetText(rowNum, 1)
            result := InputBox("New name:", "Rename", "w300", oldName)
            if result.Result != "Cancel"
            LV.Modify(rowNum, , result.Value)
        }
    }

    CopyFile(*) => MsgBox("Copy: Not implemented")
    CutFile(*) => MsgBox("Cut: Not implemented")
    PasteFile(*) => MsgBox("Paste: Not implemented")

    DeleteFile(*) {
        rowNum := LV.GetNext()
        if rowNum {
            result := MsgBox("Delete this file?", "Confirm", "YesNo Icon!")
            if result = "Yes"
            LV.Delete(rowNum)
        }
    }

    ShowProps(*) {
        rowNum := LV.GetNext()
        if rowNum {
            info := "File: " LV.GetText(rowNum, 1) "`n"
            . "Type: " LV.GetText(rowNum, 2) "`n"
            . "Modified: " LV.GetText(rowNum, 3)
            MsgBox(info, "Properties")
        }
    }

    MyGui.Add("Text", "w650", "Context menu with icons from shell32.dll")

    MyGui.Show()
}

; ============================================================================
; Main Menu
; ============================================================================
MainMenu := Gui(, "ListView Context Menu Examples")
MainMenu.Add("Text", "w400", "Select an example to run:")
MainMenu.Add("Button", "w400", "Example 1: Basic Context Menu").OnEvent("Click", (*) => Example1_BasicContextMenu())
MainMenu.Add("Button", "w400", "Example 2: Item-Specific Menus").OnEvent("Click", (*) => Example2_ItemSpecificMenus())
MainMenu.Add("Button", "w400", "Example 3: Multi-Selection Menu").OnEvent("Click", (*) => Example3_MultiSelectionMenu())
MainMenu.Add("Button", "w400", "Example 4: Submenus").OnEvent("Click", (*) => Example4_SubmenuContext())
MainMenu.Add("Button", "w400", "Example 5: Dynamic Menus").OnEvent("Click", (*) => Example5_DynamicMenus())
MainMenu.Add("Button", "w400", "Example 6: Clipboard Operations").OnEvent("Click", (*) => Example6_ClipboardMenu())
MainMenu.Add("Button", "w400", "Example 7: Menu with Icons").OnEvent("Click", (*) => Example7_MenuWithIcons())
MainMenu.Show()

; ============================================================================
; REFERENCE SECTION
; ============================================================================
/*
CONTEXT MENU EVENT:
------------------
LV.OnEvent("ContextMenu", Callback)

Callback parameters:
- GuiCtrl: The ListView control
- Item: Row number (0 if clicked on empty area)
- IsRightClick: True for right-click, False for Apps/Menu key
- X, Y: Screen coordinates of click

MENU CREATION:
-------------
MyMenu := Menu()
MyMenu.Add(ItemName, Callback)
MyMenu.Add()  ; Separator
MyMenu.Add(ItemName, SubmenuObject)  ; Submenu

MENU METHODS:
------------
Menu.Show([X, Y])          - Display menu at coordinates
Menu.Delete([ItemName])    - Remove menu item
Menu.Enable(ItemName)      - Enable menu item
Menu.Disable(ItemName)     - Disable menu item
Menu.Check(ItemName)       - Check menu item
Menu.Uncheck(ItemName)     - Uncheck menu item
Menu.SetIcon(Item, File, IconNum)  - Set menu icon

COMMON PATTERNS:
---------------
; Basic context menu
ContextMenu := Menu()
ContextMenu.Add("Item 1", Handler)
LV.OnEvent("ContextMenu", ShowMenu)

ShowMenu(GuiCtrl, Item, IsRightClick, X, Y) {
    if Item = 0
    return  ; Ignore empty area
    ContextMenu.Show(X, Y)
}

; Dynamic menu based on item
BuildMenu(GuiCtrl, Item, IsRightClick, X, Y) {
    if Item = 0
    return

    MyMenu := Menu()
    itemType := LV.GetText(Item, 1)

    if itemType = "File"
    MyMenu.Add("Open", OpenHandler)
    else
    MyMenu.Add("Execute", ExecuteHandler)

    MyMenu.Show(X, Y)
}

; Multi-selection aware
if LV.GetCount("Selected") > 1
Menu.Enable("Delete All Selected")
else
Menu.Disable("Delete All Selected")

BEST PRACTICES:
--------------
1. Check if Item = 0 to handle clicks on empty area
2. Enable/disable items based on selection state
3. Use separators to group related operations
4. Provide keyboard shortcuts in menu text (&Letter)
5. Show item count in menu for multi-selection operations
6. Use submenus to organize complex operations
7. Add icons to make menus more intuitive
8. Create dynamic menus based on item properties
9. Handle multi-selection appropriately
10. Provide common clipboard operations

KEYBOARD SHORTCUTS:
-----------------
&File    - Alt+F activates
E&xit    - Alt+X activates
&Copy`tCtrl+C  - Shows Ctrl+C hint (visual only)
*/
