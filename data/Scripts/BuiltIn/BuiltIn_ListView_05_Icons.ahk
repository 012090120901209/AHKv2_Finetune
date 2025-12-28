#Requires AutoHotkey v2.0

/**
 * BuiltIn_ListView_05_Icons.ahk
 * 
 * DESCRIPTION:
 * Demonstrates how to use icons and image lists with ListView controls including
 * system icons, custom icons, icon states, and dynamic icon management.
 * 
 * FEATURES:
 * - Creating and attaching image lists
 * - Using system icons (shell32.dll icons)
 * - Custom icon files (.ico)
 * - Small and large icon views
 * - Setting icons for individual items
 * - Dynamic icon changes
 * - Icon overlays and states
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/ListView.htm
 * https://www.autohotkey.com/docs/v2/lib/IL_Create.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - IL_Create() for image list creation
 * - IL_Add() for adding icons
 * - ListView icon option syntax
 * - SetImageList() method
 * - Icon parameter in Add() and Modify()
 * 
 * LEARNING POINTS:
 * 1. Image lists must be created before adding to ListView
 * 2. Icons are referenced by 1-based index
 * 3. Shell32.dll contains many useful system icons
 * 4. Small icons (16x16) are standard for ListView
 * 5. Icon index 0 means no icon
 * 6. Image lists can be shared across controls
 * 7. Icons enhance visual data representation
 */

; ============================================================================
; EXAMPLE 1: Basic Icon Usage with System Icons
; ============================================================================
Example1_BasicIcons() {
    MyGui := Gui("+Resize", "Example 1: Basic Icons from System")

    ; Create image list and populate with system icons
    ImageListID := IL_Create(10)  ; Create list for 10 icons

    ; Add common system icons from shell32.dll
    IL_Add(ImageListID, "shell32.dll", 3)   ; Folder icon
    IL_Add(ImageListID, "shell32.dll", 4)   ; Open folder
    IL_Add(ImageListID, "shell32.dll", 1)   ; File
    IL_Add(ImageListID, "shell32.dll", 71)  ; Check mark
    IL_Add(ImageListID, "shell32.dll", 78)  ; Warning
    IL_Add(ImageListID, "shell32.dll", 27)  ; Info
    IL_Add(ImageListID, "shell32.dll", 131) ; Network
    IL_Add(ImageListID, "shell32.dll", 16)  ; Computer

    ; Create ListView and attach image list
    LV := MyGui.Add("ListView", "r10 w600", ["Item", "Type", "Description"])
    LV.SetImageList(ImageListID)

    ; Add items with icons (icon parameter is the image list index)
    LV.Add("Icon1", "My Documents", "Folder", "User documents directory")
    LV.Add("Icon2", "Current Folder", "Open Folder", "Active directory")
    LV.Add("Icon3", "readme.txt", "File", "Text document")
    LV.Add("Icon4", "Task Complete", "Status", "Completed successfully")
    LV.Add("Icon5", "Warning Message", "Alert", "Requires attention")
    LV.Add("Icon6", "Information", "Info", "Additional details")
    LV.Add("Icon7", "Network Drive", "Network", "Shared resource")
    LV.Add("Icon8", "This Computer", "System", "Local machine")

    LV.ModifyCol()

    ; Information
    MyGui.Add("Text", "w600", "Icons are loaded from shell32.dll (Windows system icons)")
    MyGui.Add("Text", "w600", "Icon numbers: 3=Folder, 4=Open, 1=File, 71=Check, 78=Warn, 27=Info")

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 2: File Type Icons
; ============================================================================
Example2_FileTypeIcons() {
    MyGui := Gui("+Resize", "Example 2: File Type Icons")

    ; Create image list with various file type icons from shell32.dll
    ImageListID := IL_Create(15)

    IL_Add(ImageListID, "shell32.dll", 1)    ; Generic file
    IL_Add(ImageListID, "shell32.dll", 70)   ; Text file
    IL_Add(ImageListID, "shell32.dll", 147)  ; Image
    IL_Add(ImageListID, "shell32.dll", 165)  ; Video
    IL_Add(ImageListID, "shell32.dll", 116)  ; Audio
    IL_Add(ImageListID, "shell32.dll", 151)  ; Archive
    IL_Add(ImageListID, "shell32.dll", 14)   ; Executable
    IL_Add(ImageListID, "shell32.dll", 2)    ; Folder
    IL_Add(ImageListID, "shell32.dll", 71)   ; Document

    LV := MyGui.Add("ListView", "r12 w700", ["File Name", "Type", "Size", "Modified"])
    LV.SetImageList(ImageListID)

    ; Simulated file list with appropriate icons
    files := [
        ["readme.txt", "Text Document", "5 KB", "2025-11-01", 2],
        ["photo.jpg", "JPEG Image", "1.2 MB", "2025-11-05", 3],
        ["video.mp4", "MP4 Video", "45 MB", "2025-11-10", 4],
        ["music.mp3", "MP3 Audio", "4.5 MB", "2025-11-12", 5],
        ["archive.zip", "ZIP Archive", "15 MB", "2025-11-08", 6],
        ["setup.exe", "Application", "25 MB", "2025-10-28", 7],
        ["Documents", "Folder", "--", "2025-11-15", 8],
        ["report.pdf", "PDF Document", "850 KB", "2025-11-14", 9],
        ["script.ahk", "Script", "8 KB", "2025-11-16", 2]
    ]

    for file in files {
        LV.Add("Icon" file[5], file[1], file[2], file[3], file[4])
    }

    LV.ModifyCol()

    MyGui.Add("Text", "w700", "File icons visually indicate file types")
    MyGui.Add("Button", "w200", "Sort by Type").OnEvent("Click", (*) => LV.ModifyCol(2, "Sort"))
    MyGui.Add("Button", "w200", "Sort by Name").OnEvent("Click", (*) => LV.ModifyCol(1, "Sort"))

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 3: Status Icons
; ============================================================================
Example3_StatusIcons() {
    MyGui := Gui("+Resize", "Example 3: Status Icons")

    ; Create image list with status icons
    ImageListID := IL_Create(10)

    IL_Add(ImageListID, "shell32.dll", 297)  ; Green check (complete)
    IL_Add(ImageListID, "shell32.dll", 78)   ; Yellow warning (in progress)
    IL_Add(ImageListID, "shell32.dll", 28)   ; Red X (error)
    IL_Add(ImageListID, "shell32.dll", 244)  ; Blue clock (pending)
    IL_Add(ImageListID, "shell32.dll", 27)   ; Info icon

    LV := MyGui.Add("ListView", "r12 w750", ["Task", "Status", "Progress", "Assigned To"])
    LV.SetImageList(ImageListID)

    ; Task list with status icons
    tasks := [
        ["Write Documentation", "Complete", "100%", "Alice", 1],
        ["Fix Bug #123", "In Progress", "75%", "Bob", 2],
        ["Code Review", "Error", "0%", "Charlie", 3],
        ["Deploy to Staging", "Pending", "0%", "Diana", 4],
        ["Update Dependencies", "Complete", "100%", "Edward", 1],
        ["Write Tests", "In Progress", "50%", "Fiona", 2],
        ["Database Migration", "Pending", "0%", "George", 4],
        ["Security Audit", "Error", "25%", "Hannah", 3]
    ]

    for task in tasks {
        LV.Add("Icon" task[5], task[1], task[2], task[3], task[4])
    }

    LV.ModifyCol()

    ; Status update buttons
    MyGui.Add("Text", "w750", "Update Status (select a task):")
    MyGui.Add("Button", "w150", "Mark Complete").OnEvent("Click", MarkComplete)
    MyGui.Add("Button", "w150", "Set In Progress").OnEvent("Click", SetInProgress)
    MyGui.Add("Button", "w150", "Mark Error").OnEvent("Click", MarkError)
    MyGui.Add("Button", "w150", "Set Pending").OnEvent("Click", SetPending)

    MarkComplete(*) {
        rowNum := LV.GetNext()
        if rowNum {
            LV.Modify(rowNum, "Icon1", , "Complete", "100%")
            MsgBox("Task marked as complete!")
        } else {
            MsgBox("Please select a task first!")
        }
    }

    SetInProgress(*) {
        rowNum := LV.GetNext()
        if rowNum {
            LV.Modify(rowNum, "Icon2", , "In Progress", "50%")
            MsgBox("Task set to in progress!")
        } else {
            MsgBox("Please select a task first!")
        }
    }

    MarkError(*) {
        rowNum := LV.GetNext()
        if rowNum {
            LV.Modify(rowNum, "Icon3", , "Error")
            MsgBox("Task marked with error!")
        } else {
            MsgBox("Please select a task first!")
        }
    }

    SetPending(*) {
        rowNum := LV.GetNext()
        if rowNum {
            LV.Modify(rowNum, "Icon4", , "Pending", "0%")
            MsgBox("Task set to pending!")
        } else {
            MsgBox("Please select a task first!")
        }
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 4: Priority Icons
; ============================================================================
Example4_PriorityIcons() {
    MyGui := Gui("+Resize", "Example 4: Priority Icons")

    ImageListID := IL_Create(5)

    IL_Add(ImageListID, "shell32.dll", 78)   ; Critical (red warning)
    IL_Add(ImageListID, "shell32.dll", 234)  ; High (up arrow)
    IL_Add(ImageListID, "shell32.dll", 27)   ; Medium (info)
    IL_Add(ImageListID, "shell32.dll", 235)  ; Low (down arrow)
    IL_Add(ImageListID, "shell32.dll", 16)   ; None

    LV := MyGui.Add("ListView", "r14 w700", ["Issue", "Priority", "Severity", "Reporter"])
    LV.SetImageList(ImageListID)

    issues := [
        ["Server Down", "Critical", "Blocker", "System Monitor", 1],
        ["Login Failed", "High", "Major", "User Support", 2],
        ["UI Glitch", "Medium", "Minor", "QA Team", 3],
        ["Typo in Help", "Low", "Trivial", "Documentation", 4],
        ["Feature Request", "None", "Enhancement", "Customer", 5],
        ["Database Slow", "High", "Major", "DBA", 2],
        ["Missing Icon", "Low", "Minor", "Designer", 4],
        ["Security Hole", "Critical", "Blocker", "Security Team", 1]
    ]

    for issue in issues {
        LV.Add("Icon" issue[5], issue[1], issue[2], issue[3], issue[4])
    }

    LV.ModifyCol()

    ; Priority filter buttons
    MyGui.Add("Text", "w700", "Filter by Priority:")
    MyGui.Add("Button", "w120", "Critical Only").OnEvent("Click", (*) => FilterPriority("Critical", 1))
    MyGui.Add("Button", "w120", "High Priority").OnEvent("Click", (*) => FilterPriority("High", 2))
    MyGui.Add("Button", "w120", "Show All").OnEvent("Click", ShowAll)

    FilterPriority(priority, iconNum) {
        LV.Delete()
        for issue in issues {
            if issue[2] = priority {
                LV.Add("Icon" iconNum, issue[1], issue[2], issue[3], issue[4])
            }
        }
    }

    ShowAll(*) {
        LV.Delete()
        for issue in issues {
            LV.Add("Icon" issue[5], issue[1], issue[2], issue[3], issue[4])
        }
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 5: Dynamic Icon Changes
; ============================================================================
Example5_DynamicIcons() {
    MyGui := Gui("+Resize", "Example 5: Dynamic Icon Changes")

    ImageListID := IL_Create(6)

    IL_Add(ImageListID, "shell32.dll", 238)  ; Play
    IL_Add(ImageListID, "shell32.dll", 242)  ; Pause
    IL_Add(ImageListID, "shell32.dll", 240)  ; Stop
    IL_Add(ImageListID, "shell32.dll", 297)  ; Complete
    IL_Add(ImageListID, "shell32.dll", 78)   ; Warning
    IL_Add(ImageListID, "shell32.dll", 28)   ; Error

    LV := MyGui.Add("ListView", "r10 w650", ["Process", "Status", "Time"])
    LV.SetImageList(ImageListID)

    ; Add process list
    processes := [
        ["Data Import", "Stopped", "0:00"],
        ["File Sync", "Stopped", "0:00"],
        ["Backup Task", "Stopped", "0:00"],
        ["Report Gen", "Stopped", "0:00"],
        ["Email Send", "Stopped", "0:00"]
    ]

    for proc in processes {
        LV.Add("Icon3", proc*)  ; Start with stop icon
    }

    LV.ModifyCol()

    ; Control buttons
    MyGui.Add("Text", "w650", "Process Control (select a process):")
    MyGui.Add("Button", "w120", "Start/Play").OnEvent("Click", StartProcess)
    MyGui.Add("Button", "w120", "Pause").OnEvent("Click", PauseProcess)
    MyGui.Add("Button", "w120", "Stop").OnEvent("Click", StopProcess)
    MyGui.Add("Button", "w120", "Complete").OnEvent("Click", CompleteProcess)

    MyGui.Add("Button", "w120", "Simulate All").OnEvent("Click", SimulateAll)

    StartProcess(*) {
        rowNum := LV.GetNext()
        if rowNum {
            LV.Modify(rowNum, "Icon1", , "Running")
            MsgBox("Process started (Play icon)")
        }
    }

    PauseProcess(*) {
        rowNum := LV.GetNext()
        if rowNum {
            LV.Modify(rowNum, "Icon2", , "Paused")
            MsgBox("Process paused")
        }
    }

    StopProcess(*) {
        rowNum := LV.GetNext()
        if rowNum {
            LV.Modify(rowNum, "Icon3", , "Stopped", "0:00")
            MsgBox("Process stopped")
        }
    }

    CompleteProcess(*) {
        rowNum := LV.GetNext()
        if rowNum {
            LV.Modify(rowNum, "Icon4", , "Complete")
            MsgBox("Process completed!")
        }
    }

    SimulateAll(*) {
        ; Animate through states
        Loop LV.GetCount() {
            ; Start
            LV.Modify(A_Index, "Icon1", , "Running", "0:00")
        }
        Sleep 1000

        Loop LV.GetCount() {
            ; Progress
            LV.Modify(A_Index, , , , Random(1, 5) ":00")
        }
        Sleep 1000

        Loop LV.GetCount() {
            ; Complete or error randomly
            if Random(0, 1)
                LV.Modify(A_Index, "Icon4", , "Complete", Random(2, 8) ":00")
            else
                LV.Modify(A_Index, "Icon6", , "Error", Random(1, 3) ":00")
        }

        MsgBox("Simulation complete!")
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 6: Custom Icon Numbers Reference
; ============================================================================
Example6_IconReference() {
    MyGui := Gui("+Resize", "Example 6: Shell32 Icon Reference")

    ImageListID := IL_Create(50)

    ; Add a range of commonly used shell32.dll icons
    iconNumbers := [1, 2, 3, 4, 5, 8, 14, 16, 21, 22, 27, 28, 43, 54, 70, 71, 78,
        116, 131, 147, 151, 165, 234, 235, 238, 240, 242, 244, 297]

    for iconNum in iconNumbers {
        IL_Add(ImageListID, "shell32.dll", iconNum)
    }

    LV := MyGui.Add("ListView", "r16 w500", ["Icon #", "Index", "Common Use"])
    LV.SetImageList(ImageListID)

    ; Add reference entries
    descriptions := [
        [1, 1, "Generic file"],
        [2, 2, "Folder/Directory"],
        [3, 3, "Closed folder"],
        [4, 4, "Open folder"],
        [5, 5, "Drive"],
        [8, 6, "Hard drive"],
        [14, 7, "Executable/Program"],
        [16, 8, "Computer/Desktop"],
        [21, 9, "Search/Find"],
        [22, 10, "Help"],
        [27, 11, "Information"],
        [28, 12, "Error/Critical"],
        [43, 13, "Settings/Tools"],
        [54, 14, "Delete/Trash"],
        [70, 15, "Text file"],
        [71, 16, "Success/Check"],
        [78, 17, "Warning/Alert"],
        [116, 18, "Music/Audio"],
        [131, 19, "Network"],
        [147, 20, "Image/Picture"],
        [151, 21, "Archive/ZIP"],
        [165, 22, "Video"],
        [234, 23, "Up arrow/High"],
        [235, 24, "Down arrow/Low"],
        [238, 25, "Play"],
        [240, 26, "Stop"],
        [242, 27, "Pause"],
        [244, 28, "Clock/Time"],
        [297, 29, "Check/Complete"]
    ]

    for desc in descriptions {
        LV.Add("Icon" desc[2], desc[1], desc[2], desc[3])
    }

    LV.ModifyCol()

    MyGui.Add("Text", "w500", "Reference: Common shell32.dll icon numbers")
    MyGui.Add("Text", "w500", "Use these numbers with IL_Add(ImageList, 'shell32.dll', Number)")

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 7: Multiple Image Lists
; ============================================================================
Example7_MultipleImageLists() {
    MyGui := Gui("+Resize", "Example 7: Small vs Large Icons")

    ; Create both small and large image lists
    ImageListSmall := IL_Create(5, , false)  ; Small icons (16x16)
    ImageListLarge := IL_Create(5, , true)   ; Large icons (32x32)

    ; Add same icons to both lists
    iconNumbers := [3, 4, 71, 78, 27]
    for iconNum in iconNumbers {
        IL_Add(ImageListSmall, "shell32.dll", iconNum)
        IL_Add(ImageListLarge, "shell32.dll", iconNum)
    }

    MyGui.Add("Text", "w700", "Small Icons (16x16) - Default:")
    LV1 := MyGui.Add("ListView", "r6 w700", ["Item", "Type"])
    LV1.SetImageList(ImageListSmall)

    LV1.Add("Icon1", "Folder", "Directory")
    LV1.Add("Icon2", "Open Folder", "Active")
    LV1.Add("Icon3", "Complete", "Success")
    LV1.Add("Icon4", "Warning", "Alert")
    LV1.Add("Icon5", "Info", "Information")
    LV1.ModifyCol()

    MyGui.Add("Text", "w700", "Large Icons (32x32) - Icon View:")
    LV2 := MyGui.Add("ListView", "r6 w700 Icon", ["Item", "Type"])
    LV2.SetImageList(ImageListLarge, 1)  ; 1 = large icons

    LV2.Add("Icon1", "Folder", "Directory")
    LV2.Add("Icon2", "Open Folder", "Active")
    LV2.Add("Icon3", "Complete", "Success")
    LV2.Add("Icon4", "Warning", "Alert")
    LV2.Add("Icon5", "Info", "Information")
    LV2.ModifyCol()

    MyGui.Add("Text", "w700", "Note: Large icons work best with Icon view mode")

    MyGui.Show()
}

; ============================================================================
; Main Menu
; ============================================================================
MainMenu := Gui(, "ListView Icon Examples")
MainMenu.Add("Text", "w400", "Select an example to run:")
MainMenu.Add("Button", "w400", "Example 1: Basic System Icons").OnEvent("Click", (*) => Example1_BasicIcons())
MainMenu.Add("Button", "w400", "Example 2: File Type Icons").OnEvent("Click", (*) => Example2_FileTypeIcons())
MainMenu.Add("Button", "w400", "Example 3: Status Icons").OnEvent("Click", (*) => Example3_StatusIcons())
MainMenu.Add("Button", "w400", "Example 4: Priority Icons").OnEvent("Click", (*) => Example4_PriorityIcons())
MainMenu.Add("Button", "w400", "Example 5: Dynamic Icon Changes").OnEvent("Click", (*) => Example5_DynamicIcons())
MainMenu.Add("Button", "w400", "Example 6: Icon Reference Guide").OnEvent("Click", (*) => Example6_IconReference())
MainMenu.Add("Button", "w400", "Example 7: Small vs Large Icons").OnEvent("Click", (*) => Example7_MultipleImageLists())
MainMenu.Show()

; ============================================================================
; REFERENCE SECTION
; ============================================================================
/*
IMAGE LIST FUNCTIONS:
--------------------
IL_Create([InitialCount, GrowCount, LargeIcons])  - Create image list
IL_Add(ImageListID, Filename [, IconNumber])      - Add icon to list
IL_Destroy(ImageListID)                           - Destroy image list

LISTVIEW IMAGE LIST METHODS:
----------------------------
LV.SetImageList(ImageListID [, IconType])         - Attach image list to ListView
IconType: 0 or omitted = small icons, 1 = large icons, 2 = state icons

ADDING ITEMS WITH ICONS:
------------------------
LV.Add("Icon" IconIndex, Col1, Col2, ...)         - Add row with icon
LV.Modify(Row, "Icon" IconIndex, ...)             - Change row icon

ICON SOURCES:
------------
shell32.dll     - Windows system icons (most common)
imageres.dll    - Additional Windows icons (Vista+)
*.ico           - Custom icon files
*.exe           - Extract icons from executables
*.dll           - Extract icons from DLLs

COMMON SHELL32.DLL ICONS:
------------------------
1    - Generic file
2-4  - Folder icons
14   - Program/Exe
16   - Computer
27   - Information (blue i)
28   - Error (red X)
71   - Success (green check)
78   - Warning (yellow triangle)
131  - Network
234  - Up arrow
235  - Down arrow
238  - Play
240  - Stop
242  - Pause
244  - Clock
297  - Green check circle

BEST PRACTICES:
--------------
1. Create image list before adding items to ListView
2. Icon indices start at 1, not 0
3. Icon 0 or omitted = no icon
4. Destroy image lists when GUI closes to free memory
5. Use small icons (16x16) for detail view
6. Use large icons (32x32) for icon/tile view
7. Keep icon meanings consistent across application

COMMON PATTERNS:
---------------
; Create and populate image list
ImageListID := IL_Create(10)
IL_Add(ImageListID, "shell32.dll", 3)
IL_Add(ImageListID, "shell32.dll", 71)

; Attach to ListView
LV.SetImageList(ImageListID)

; Add items with icons
LV.Add("Icon1", "Folder", "Directory")
LV.Add("Icon2", "Success", "Complete")

; Change icon dynamically
LV.Modify(RowNum, "Icon3")
*/

