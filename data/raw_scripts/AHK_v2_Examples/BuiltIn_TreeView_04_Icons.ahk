#Requires AutoHotkey v2.0
/**
 * BuiltIn_TreeView_04_Icons.ahk
 *
 * DESCRIPTION:
 * Demonstrates using icons in TreeView controls including image lists,
 * custom icons, system icons, and dynamic icon changes.
 *
 * FEATURES:
 * - Creating and managing image lists
 * - Adding system shell icons
 * - Custom icon files
 * - Dynamic icon updates
 * - State-based icon changes
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/TreeView.htm
 * https://www.autohotkey.com/docs/v2/lib/ListView.htm#IL
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - IL_Create for image list creation
 * - IL_Add for adding icons
 * - GuiControl.SetImageList method
 * - Dynamic icon manipulation
 *
 * LEARNING POINTS:
 * 1. Image lists must be created before associating with TreeView
 * 2. Icons are referenced by 1-based index
 * 3. Each node can have normal and selected state icons
 * 4. System shell icons provide familiar file/folder icons
 * 5. Icons enhance visual hierarchies and status indication
 */

;=============================================================================
; EXAMPLE 1: Basic Icon Usage
;=============================================================================
; Demonstrates adding basic icons to TreeView nodes

Example1_BasicIcons() {
    myGui := Gui("+Resize", "Example 1: Basic Icons")

    ; Create an image list
    ImageListID := IL_Create(10)  ; Create space for 10 icons

    ; Add icons from shell32.dll (system icons)
    FolderIcon := IL_Add(ImageListID, "shell32.dll", 4)       ; Folder icon
    FileIcon := IL_Add(ImageListID, "shell32.dll", 1)         ; Generic file
    DocumentIcon := IL_Add(ImageListID, "shell32.dll", 71)    ; Document
    SettingsIcon := IL_Add(ImageListID, "shell32.dll", 22)    ; Settings
    NetworkIcon := IL_Add(ImageListID, "shell32.dll", 13)     ; Network

    ; Create TreeView and assign image list
    TV := myGui.Add("TreeView", "w500 h400 ImageList" . ImageListID)

    ; Add items with icons
    ; Format: TV.Add(Text, ParentID, "Icon" . IconNumber)
    Root := TV.Add("My Computer", 0, "Icon" . FolderIcon)

    ; System folders
    System := TV.Add("System Files", Root, "Icon" . FolderIcon)
    TV.Add("config.sys", System, "Icon" . FileIcon)
    TV.Add("autoexec.bat", System, "Icon" . FileIcon)
    TV.Add("settings.ini", System, "Icon" . SettingsIcon)

    ; Documents
    Docs := TV.Add("Documents", Root, "Icon" . FolderIcon)
    TV.Add("report.docx", Docs, "Icon" . DocumentIcon)
    TV.Add("presentation.pptx", Docs, "Icon" . DocumentIcon)
    TV.Add("spreadsheet.xlsx", Docs, "Icon" . DocumentIcon)

    ; Network
    Network := TV.Add("Network", Root, "Icon" . NetworkIcon)
    TV.Add("Server1", Network, "Icon" . NetworkIcon)
    TV.Add("Server2", Network, "Icon" . NetworkIcon)

    TV.Modify(Root, "Expand")

    ; Info text
    infoText := myGui.Add("Text", "xm y+10 w500",
        "Icons are loaded from shell32.dll and assigned to each node.`n" .
        "Different icon numbers represent different icon types.")

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    ; Clean up image list when GUI is destroyed
    myGui.OnEvent("Close", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
}

;=============================================================================
; EXAMPLE 2: File System Icons
;=============================================================================
; Creates a file browser with appropriate file type icons

Example2_FileSystemIcons() {
    myGui := Gui("+Resize", "Example 2: File System Icons")

    ; Create image list
    ImageListID := IL_Create(15)

    ; Add various file system icons from shell32.dll
    Icons := Map(
        "Folder", IL_Add(ImageListID, "shell32.dll", 4),
        "OpenFolder", IL_Add(ImageListID, "shell32.dll", 5),
        "Drive", IL_Add(ImageListID, "shell32.dll", 9),
        "Document", IL_Add(ImageListID, "shell32.dll", 71),
        "Text", IL_Add(ImageListID, "shell32.dll", 70),
        "Image", IL_Add(ImageListID, "shell32.dll", 72),
        "Music", IL_Add(ImageListID, "shell32.dll", 108),
        "Video", IL_Add(ImageListID, "shell32.dll", 238),
        "Zip", IL_Add(ImageListID, "shell32.dll", 165),
        "Exe", IL_Add(ImageListID, "shell32.dll", 2)
    )

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h450 ImageList" . ImageListID)

    ; Build file system tree
    Computer := TV.Add("This PC", 0, "Icon" . Icons["Drive"])

    ; C Drive
    CDrive := TV.Add("Local Disk (C:)", Computer, "Icon" . Icons["Drive"])

    ; Windows folder
    Windows := TV.Add("Windows", CDrive, "Icon" . Icons["Folder"])
    TV.Add("System32", Windows, "Icon" . Icons["Folder"])
    TV.Add("notepad.exe", Windows, "Icon" . Icons["Exe"])
    TV.Add("win.ini", Windows, "Icon" . Icons["Text"])

    ; Program Files
    Program := TV.Add("Program Files", CDrive, "Icon" . Icons["Folder"])
    TV.Add("Application1", Program, "Icon" . Icons["Folder"])
    TV.Add("Application2", Program, "Icon" . Icons["Folder"])

    ; Users folder
    Users := TV.Add("Users", CDrive, "Icon" . Icons["Folder"])

    ; User Documents
    UserFolder := TV.Add("John", Users, "Icon" . Icons["Folder"])

    Documents := TV.Add("Documents", UserFolder, "Icon" . Icons["Folder"])
    TV.Add("Report.docx", Documents, "Icon" . Icons["Document"])
    TV.Add("Notes.txt", Documents, "Icon" . Icons["Text"])

    Pictures := TV.Add("Pictures", UserFolder, "Icon" . Icons["Folder"])
    TV.Add("photo1.jpg", Pictures, "Icon" . Icons["Image"])
    TV.Add("photo2.png", Pictures, "Icon" . Icons["Image"])

    Music := TV.Add("Music", UserFolder, "Icon" . Icons["Folder"])
    TV.Add("song1.mp3", Music, "Icon" . Icons["Music"])
    TV.Add("song2.wav", Music, "Icon" . Icons["Music"])

    Videos := TV.Add("Videos", UserFolder, "Icon" . Icons["Folder"])
    TV.Add("movie.mp4", Videos, "Icon" . Icons["Video"])

    Downloads := TV.Add("Downloads", UserFolder, "Icon" . Icons["Folder"])
    TV.Add("installer.exe", Downloads, "Icon" . Icons["Exe"])
    TV.Add("archive.zip", Downloads, "Icon" . Icons["Zip"])

    TV.Modify(Computer, "Expand")
    TV.Modify(CDrive, "Expand")

    ; Change folder icon when expanded/collapsed
    TV.OnEvent("ItemExpand", OnExpand)

    OnExpand(GuiCtrl, ItemID) {
        itemText := TV.GetText(ItemID)
        ; Check if it's a folder (has children)
        if (TV.GetChild(ItemID)) {
            isExpanded := TV.Get(ItemID, "Expand")
            newIcon := isExpanded ? Icons["OpenFolder"] : Icons["Folder"]
            TV.Modify(ItemID, "Icon" . newIcon)
        }
    }

    infoText := myGui.Add("Text", "xm y+10 w500",
        "Icons change based on file type. Folders show open/closed states.")

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    myGui.OnEvent("Close", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
}

;=============================================================================
; EXAMPLE 3: Dynamic Icon Changes
;=============================================================================
; Demonstrates changing icons dynamically based on state

Example3_DynamicIcons() {
    myGui := Gui("+Resize", "Example 3: Dynamic Icon Changes")

    ; Create image list
    ImageListID := IL_Create(10)

    ; Add status icons
    Icons := Map(
        "Pending", IL_Add(ImageListID, "shell32.dll", 238),    ; Clock
        "InProgress", IL_Add(ImageListID, "shell32.dll", 165), ; Gear
        "Complete", IL_Add(ImageListID, "shell32.dll", 297),   ; Checkmark
        "Error", IL_Add(ImageListID, "shell32.dll", 131),      ; X mark
        "Warning", IL_Add(ImageListID, "shell32.dll", 78),     ; Warning
        "Folder", IL_Add(ImageListID, "shell32.dll", 4)
    )

    ; Create TreeView with checkboxes
    TV := myGui.Add("TreeView", "w500 h350 ImageList" . ImageListID . " Checked")

    ; Build task tree
    Project := TV.Add("Project Alpha", 0, "Icon" . Icons["Folder"])

    ; Phase 1
    Phase1 := TV.Add("Phase 1: Planning", Project, "Icon" . Icons["Complete"])
    TV.Add("Requirements", Phase1, "Icon" . Icons["Complete"])
    TV.Add("Design", Phase1, "Icon" . Icons["Complete"])
    TV.Add("Approval", Phase1, "Icon" . Icons["Complete"])

    ; Phase 2
    Phase2 := TV.Add("Phase 2: Development", Project, "Icon" . Icons["InProgress"])
    TV.Add("Frontend", Phase2, "Icon" . Icons["Complete"])
    TV.Add("Backend", Phase2, "Icon" . Icons["InProgress"])
    TV.Add("Database", Phase2, "Icon" . Icons["Pending"])

    ; Phase 3
    Phase3 := TV.Add("Phase 3: Testing", Project, "Icon" . Icons["Pending"])
    TV.Add("Unit Tests", Phase3, "Icon" . Icons["Pending"])
    TV.Add("Integration Tests", Phase3, "Icon" . Icons["Pending"])
    TV.Add("UAT", Phase3, "Icon" . Icons["Pending"])

    TV.Modify(Project, "Expand")

    ; Controls
    myGui.Add("Text", "xm y+10", "Change Status:")

    pendingBtn := myGui.Add("Button", "xm y+5 w100", "⏳ Pending")
    pendingBtn.OnEvent("Click", (*) => ChangeStatus(Icons["Pending"]))

    progressBtn := myGui.Add("Button", "x+5 yp w100", "⚙️ In Progress")
    progressBtn.OnEvent("Click", (*) => ChangeStatus(Icons["InProgress"]))

    completeBtn := myGui.Add("Button", "x+5 yp w100", "✓ Complete")
    completeBtn.OnEvent("Click", (*) => ChangeStatus(Icons["Complete"]))

    errorBtn := myGui.Add("Button", "x+5 yp w100", "✗ Error")
    errorBtn.OnEvent("Click", (*) => ChangeStatus(Icons["Error"]))

    warningBtn := myGui.Add("Button", "x+5 yp w100", "⚠ Warning")
    warningBtn.OnEvent("Click", (*) => ChangeStatus(Icons["Warning"]))

    ChangeStatus(IconIndex) {
        if (selected := TV.GetSelection()) {
            TV.Modify(selected, "Icon" . IconIndex)
            UpdateSummary()
        }
    }

    ; Summary display
    summaryText := myGui.Add("Text", "xm y+20 w500", "")

    UpdateSummary() {
        counts := Map(
            "Complete", 0,
            "InProgress", 0,
            "Pending", 0,
            "Error", 0,
            "Warning", 0
        )

        CountIcons(Project, Icons, counts)

        summary := "Status Summary: "
        summary .= "✓" . counts["Complete"] . " "
        summary .= "⚙" . counts["InProgress"] . " "
        summary .= "⏳" . counts["Pending"] . " "
        summary .= "✗" . counts["Error"] . " "
        summary .= "⚠" . counts["Warning"]

        summaryText.Value := summary
    }

    CountIcons(NodeID, Icons, counts) {
        if (NodeID) {
            ; Get current icon (this is simplified - would need proper icon tracking)
            ; In real implementation, you'd track icon assignments
        }

        ChildID := TV.GetChild(NodeID)
        while (ChildID) {
            CountIcons(ChildID, Icons, counts)
            ChildID := TV.GetNext(ChildID)
        }
    }

    UpdateSummary()

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    myGui.OnEvent("Close", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
}

;=============================================================================
; EXAMPLE 4: Custom Icon Files
;=============================================================================
; Loading icons from custom icon files and resources

Example4_CustomIcons() {
    myGui := Gui("+Resize", "Example 4: Custom Icon Files")

    ; Create image list (larger icons)
    ImageListID := IL_Create(20, 5, 1)  ; Initial: 20, Grow: 5, Large icons: true

    ; Add icons from various system sources
    Icons := Map()

    ; Shell32.dll icons (common system icons)
    Icons["Folder"] := IL_Add(ImageListID, "shell32.dll", 4)
    Icons["File"] := IL_Add(ImageListID, "shell32.dll", 1)
    Icons["Computer"] := IL_Add(ImageListID, "shell32.dll", 16)
    Icons["Network"] := IL_Add(ImageListID, "shell32.dll", 13)
    Icons["Recycle"] := IL_Add(ImageListID, "shell32.dll", 32)
    Icons["Search"] := IL_Add(ImageListID, "shell32.dll", 23)
    Icons["Help"] := IL_Add(ImageListID, "shell32.dll", 24)
    Icons["Settings"] := IL_Add(ImageListID, "shell32.dll", 22)

    ; imageres.dll icons (Windows Vista+ icons)
    Icons["User"] := IL_Add(ImageListID, "imageres.dll", 5)
    Icons["Lock"] := IL_Add(ImageListID, "imageres.dll", 1)
    Icons["Shield"] := IL_Add(ImageListID, "imageres.dll", 78)

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h450 ImageList" . ImageListID)

    ; Build tree with various icons
    Root := TV.Add("System Overview", 0, "Icon" . Icons["Computer"])

    ; User section
    UserSection := TV.Add("Users", Root, "Icon" . Icons["User"])
    TV.Add("Administrator", UserSection, "Icon" . Icons["Shield"])
    TV.Add("Guest", UserSection, "Icon" . Icons["User"])
    TV.Add("John Doe", UserSection, "Icon" . Icons["User"])

    ; System section
    SystemSection := TV.Add("System", Root, "Icon" . Icons["Settings"])
    TV.Add("Control Panel", SystemSection, "Icon" . Icons["Settings"])
    TV.Add("Device Manager", SystemSection, "Icon" . Icons["Computer"])
    TV.Add("Network Connections", SystemSection, "Icon" . Icons["Network"])

    ; Utilities section
    UtilSection := TV.Add("Utilities", Root, "Icon" . Icons["Folder"])
    TV.Add("Search", UtilSection, "Icon" . Icons["Search"])
    TV.Add("Help", UtilSection, "Icon" . Icons["Help"])
    TV.Add("Recycle Bin", UtilSection, "Icon" . Icons["Recycle"])

    ; Security section
    SecuritySection := TV.Add("Security", Root, "Icon" . Icons["Lock"])
    TV.Add("User Accounts", SecuritySection, "Icon" . Icons["User"])
    TV.Add("Windows Defender", SecuritySection, "Icon" . Icons["Shield"])
    TV.Add("Firewall", SecuritySection, "Icon" . Icons["Lock"])

    TV.Modify(Root, "Expand")

    ; Icon source info
    infoText := myGui.Add("Edit", "xm y+10 w500 h100 ReadOnly",
        "Icon Sources:`n" .
        "- shell32.dll: Classic Windows icons`n" .
        "- imageres.dll: Modern Windows Vista+ icons`n" .
        "- You can also load from .ico files or .exe resources`n" .
        "- Format: IL_Add(ImageListID, ""path\file"", IconNumber)")

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    myGui.OnEvent("Close", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
}

;=============================================================================
; EXAMPLE 5: Icon Selection and Preview
;=============================================================================
; Interactive icon browser and selector

Example5_IconBrowser() {
    myGui := Gui("+Resize", "Example 5: Icon Browser")

    ; Create image list with many icons
    ImageListID := IL_Create(50)

    ; Add a range of shell32 icons
    IconCount := 50
    Loop IconCount {
        IL_Add(ImageListID, "shell32.dll", A_Index)
    }

    ; Create TreeView
    TV := myGui.Add("TreeView", "w600 h400 ImageList" . ImageListID)

    ; Build tree with various icons
    Root := TV.Add("Icon Gallery", 0, "Icon1")

    ; Add items for each icon
    Loop IconCount {
        iconNum := A_Index
        parentNode := Root

        ; Group icons
        if (iconNum <= 10)
            groupText := "Icons 1-10"
        else if (iconNum <= 20)
            groupText := "Icons 11-20"
        else if (iconNum <= 30)
            groupText := "Icons 21-30"
        else if (iconNum <= 40)
            groupText := "Icons 31-40"
        else
            groupText := "Icons 41-50"

        ; Find or create group
        groupID := FindOrCreateGroup(TV, Root, groupText, iconNum)

        TV.Add("Icon #" . iconNum, groupID, "Icon" . iconNum)
    }

    ; Expand first group
    firstGroup := TV.GetChild(Root)
    TV.Modify(firstGroup, "Expand")

    ; Info display
    infoText := myGui.Add("Edit", "xm y+10 w600 h120 ReadOnly")

    ; Update info on selection
    TV.OnEvent("ItemSelect", UpdateInfo)

    UpdateInfo(*) {
        if (selected := TV.GetSelection()) {
            text := TV.GetText(selected)

            info := "Selected: " . text . "`n`n"
            info .= "Shell32.dll contains many built-in Windows icons.`n"
            info .= "Icon numbers vary by Windows version.`n"
            info .= "Common icons: Folders (3-5), Files (1-2), System (15-20)`n`n"
            info .= "To use in your script:`n"
            info .= 'IconNum := IL_Add(ImageListID, "shell32.dll", ' . RegExReplace(text, "\D") . ")"

            infoText.Value := info
        }
    }

    UpdateInfo()

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    myGui.OnEvent("Close", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
}

; Helper to find or create group node
FindOrCreateGroup(TV, ParentID, GroupText, IconNum) {
    ; Search for existing group
    ChildID := TV.GetChild(ParentID)
    while (ChildID) {
        if (TV.GetText(ChildID) = GroupText)
            return ChildID
        ChildID := TV.GetNext(ChildID)
    }

    ; Create new group
    return TV.Add(GroupText, ParentID, "Icon" . Max(1, IconNum - 5))
}

;=============================================================================
; EXAMPLE 6: Icon States (Normal and Selected)
;=============================================================================
; Demonstrating different icons for normal and selected states

Example6_IconStates() {
    myGui := Gui("+Resize", "Example 6: Icon States")

    ; Create image list
    ImageListID := IL_Create(20)

    ; Add icon pairs (normal and selected states)
    Icons := Map(
        "FolderClosed", IL_Add(ImageListID, "shell32.dll", 4),
        "FolderOpen", IL_Add(ImageListID, "shell32.dll", 5),
        "FileClosed", IL_Add(ImageListID, "shell32.dll", 71),
        "FileOpen", IL_Add(ImageListID, "shell32.dll", 70),
        "Unchecked", IL_Add(ImageListID, "shell32.dll", 47),
        "Checked", IL_Add(ImageListID, "shell32.dll", 297)
    )

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h400 ImageList" . ImageListID)

    ; Add items with different normal/selected icons
    Root := TV.Add("Documents", 0, "Icon" . Icons["FolderClosed"])

    Folder1 := TV.Add("Work Files", Root, "Icon" . Icons["FolderClosed"])
    TV.Add("Document1.txt", Folder1, "Icon" . Icons["FileClosed"])
    TV.Add("Document2.txt", Folder1, "Icon" . Icons["FileClosed"])

    Folder2 := TV.Add("Personal", Root, "Icon" . Icons["FolderClosed"])
    TV.Add("Photo1.jpg", Folder2, "Icon" . Icons["FileClosed"])
    TV.Add("Photo2.jpg", Folder2, "Icon" . Icons["FileClosed"])

    TV.Modify(Root, "Expand")

    ; Change icons on selection
    TV.OnEvent("ItemSelect", OnSelect)

    lastSelected := 0

    OnSelect(GuiCtrl, ItemID) {
        ; Restore previous selection's icon
        if (lastSelected) {
            if (TV.GetChild(lastSelected))
                TV.Modify(lastSelected, "Icon" . Icons["FolderClosed"])
            else
                TV.Modify(lastSelected, "Icon" . Icons["FileClosed"])
        }

        ; Change new selection's icon
        if (ItemID) {
            if (TV.GetChild(ItemID))
                TV.Modify(ItemID, "Icon" . Icons["FolderOpen"])
            else
                TV.Modify(ItemID, "Icon" . Icons["FileOpen"])

            lastSelected := ItemID
        }
    }

    infoText := myGui.Add("Text", "xm y+10 w500",
        "Icons change when items are selected.`n" .
        "Folders show open/closed icons, files show selected state.")

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    myGui.OnEvent("Close", (*) => (IL_Destroy(ImageListID), myGui.Destroy()))
}

;=============================================================================
; EXAMPLE 7: Icon Management System
;=============================================================================
; Complete icon management with dynamic loading and caching

Example7_IconManagement() {
    myGui := Gui("+Resize", "Example 7: Icon Management")

    ; Icon manager class
    class IconManager {
        __New() {
            this.ImageListID := IL_Create(100)
            this.IconCache := Map()
        }

        GetIcon(source, index) {
            key := source . ":" . index
            if (this.IconCache.Has(key))
                return this.IconCache[key]

            iconNum := IL_Add(this.ImageListID, source, index)
            this.IconCache[key] := iconNum
            return iconNum
        }

        Destroy() {
            IL_Destroy(this.ImageListID)
        }
    }

    ; Create icon manager
    iconMgr := IconManager()

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h400 ImageList" . iconMgr.ImageListID)

    ; Build tree using icon manager
    Root := TV.Add("Icon Library", 0, "Icon" . iconMgr.GetIcon("shell32.dll", 4))

    ; Shell32 section
    Shell32 := TV.Add("Shell32.dll", Root, "Icon" . iconMgr.GetIcon("shell32.dll", 166))
    TV.Add("Folder Icons", Shell32, "Icon" . iconMgr.GetIcon("shell32.dll", 4))
    TV.Add("File Icons", Shell32, "Icon" . iconMgr.GetIcon("shell32.dll", 71))
    TV.Add("Computer Icons", Shell32, "Icon" . iconMgr.GetIcon("shell32.dll", 16))

    ; Imageres section
    Imageres := TV.Add("Imageres.dll", Root, "Icon" . iconMgr.GetIcon("imageres.dll", 1))
    TV.Add("User Icons", Imageres, "Icon" . iconMgr.GetIcon("imageres.dll", 5))
    TV.Add("Security Icons", Imageres, "Icon" . iconMgr.GetIcon("imageres.dll", 78))

    TV.Modify(Root, "Expand")

    ; Statistics
    statsText := myGui.Add("Edit", "xm y+10 w500 h150 ReadOnly")

    UpdateStats() {
        stats := "ICON MANAGER STATISTICS:`n`n"
        stats .= "Cached Icons: " . iconMgr.IconCache.Count . "`n"
        stats .= "TreeView Items: " . TV.GetCount() . "`n`n"
        stats .= "Cached Icon Sources:`n"

        sources := Map()
        for key, value in iconMgr.IconCache {
            parts := StrSplit(key, ":")
            source := parts[1]
            if (!sources.Has(source))
                sources[source] := 0
            sources[source]++
        }

        for source, count in sources
            stats .= "  " . source . ": " . count . " icons`n"

        statsText.Value := stats
    }

    UpdateStats()

    ; Control buttons
    refreshBtn := myGui.Add("Button", "xm y+10 w120", "Refresh Stats")
    refreshBtn.OnEvent("Click", (*) => UpdateStats())

    closeBtn := myGui.Add("Button", "x+10 yp w100", "Close")
    closeBtn.OnEvent("Click", CloseApp)

    CloseApp(*) {
        iconMgr.Destroy()
        myGui.Destroy()
    }

    myGui.Show()

    myGui.OnEvent("Close", CloseApp)
}

;=============================================================================
; REFERENCE SECTION
;=============================================================================
/*
IMAGE LIST FUNCTIONS:
- IL_Create([InitialCount, GrowCount, LargeIcons]) - Create image list
- IL_Add(ImageListID, Filename [, IconNumber, ResizeNonIcon]) - Add icon
- IL_Destroy(ImageListID) - Destroy image list

ICON SOURCES:
- shell32.dll - Classic Windows icons (200+ icons)
- imageres.dll - Modern Windows Vista+ icons
- .ico files - Individual icon files
- .exe files - Executable resources
- .dll files - DLL resources

TREEVIEW ICON SYNTAX:
- TV.Add(Text, Parent, "Icon" . IconNumber) - Set icon
- TV.Modify(ItemID, "Icon" . IconNumber) - Change icon
- IconNumber is 1-based index from IL_Add

COMMON SHELL32.DLL ICONS:
- 1: Generic file
- 2: Program/executable
- 4: Closed folder
- 5: Open folder
- 9: Hard drive
- 13: Network
- 16: Computer
- 22: Settings/gear
- 23: Search/magnifying glass
- 71: Document
- 165: Compressed folder/zip

BEST PRACTICES:
1. Create image list before TreeView
2. Assign image list with ImageList option
3. Destroy image list when done
4. Cache icon numbers for reuse
5. Use appropriate icon sizes
6. Test icons across Windows versions
7. Provide fallback for missing icons

PERFORMANCE TIPS:
- Reuse image lists when possible
- Cache frequently used icons
- Use appropriate InitialCount
- Destroy unused image lists
- Consider memory with large icon counts
*/

; Uncomment to run examples:
; Example1_BasicIcons()
; Example2_FileSystemIcons()
; Example3_DynamicIcons()
; Example4_CustomIcons()
; Example5_IconBrowser()
; Example6_IconStates()
; Example7_IconManagement()
