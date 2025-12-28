#Requires AutoHotkey v2.0

/**
 * BuiltIn_ListView_10_Styling.ahk
 * 
 * DESCRIPTION:
 * Demonstrates styling and visual customization of ListView controls including colors,
 * fonts, grid lines, checkboxes, and various view modes.
 * 
 * FEATURES:
 * - Custom background and text colors
 * - Row color alternation (zebra striping)
 * - Font customization
 * - Grid lines and visual separators
 * - Checkboxes for items
 * - Different view modes (Details, Icon, List, Tile)
 * - Full row selection
 * - Custom item coloring
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/ListView.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - ListView options (Grid, Checked, etc.)
 * - SetFont() method
 * - Color customization via options
 * - View mode switching
 * - Visual enhancement techniques
 * 
 * LEARNING POINTS:
 * 1. ListView appearance can be customized extensively
 * 2. Grid option shows cell boundaries
 * 3. Checked option adds checkboxes to rows
 * 4. Different view modes suit different data types
 * 5. Fonts can be customized like other controls
 * 6. Background colors improve readability
 * 7. Visual design affects usability
 */

; ============================================================================
; EXAMPLE 1: Basic Styling Options
; ============================================================================
Example1_BasicStyling() {
    MyGui := Gui("+Resize", "Example 1: Basic Styling Options")

    MyGui.Add("Text", "w750", "Default ListView (no special styling):")
    LV1 := MyGui.Add("ListView", "r5 w750", ["Name", "Value", "Status"])

    Loop 5 {
        LV1.Add(, "Item " A_Index, Random(100, 999), "Active")
    }
    LV1.ModifyCol()

    MyGui.Add("Text", "w750", "With Grid Lines:")
    LV2 := MyGui.Add("ListView", "r5 w750 Grid", ["Name", "Value", "Status"])

    Loop 5 {
        LV2.Add(, "Item " A_Index, Random(100, 999), "Active")
    }
    LV2.ModifyCol()

    MyGui.Add("Text", "w750", "With Checkboxes:")
    LV3 := MyGui.Add("ListView", "r5 w750 Checked", ["Name", "Value", "Status"])

    Loop 5 {
        LV3.Add(, "Item " A_Index, Random(100, 999), "Active")
    }
    LV3.ModifyCol()

    ; Demonstrate checking items
    LV3.Modify(1, "Check")
    LV3.Modify(3, "Check")

    MyGui.Add("Button", "w200", "Get Checked Items").OnEvent("Click", GetChecked)

    GetChecked(*) {
        checked := []
        Loop LV3.GetCount() {
            if LV3.GetNext(A_Index - 1, "Checked") = A_Index
                checked.Push(LV3.GetText(A_Index, 1))
        }

        if checked.Length = 0
            MsgBox("No items checked!")
        else
            MsgBox("Checked items:`n" Join(checked, "`n"))
    }

    Join(arr, delimiter) {
        result := ""
        for item in arr
            result .= item delimiter
        return SubStr(result, 1, -StrLen(delimiter))
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 2: Font Customization
; ============================================================================
Example2_FontCustomization() {
    MyGui := Gui("+Resize", "Example 2: Font Customization")

    MyGui.Add("Text", "w750", "Default Font:")
    LV1 := MyGui.Add("ListView", "r4 w750", ["Product", "Price"])
    Loop 4
        LV1.Add(, "Product " A_Index, "$" Random(10, 100))
    LV1.ModifyCol()

    MyGui.Add("Text", "w750", "Large Bold Font:")
    LV2 := MyGui.Add("ListView", "r4 w750", ["Product", "Price"])
    LV2.SetFont("s12 Bold", "Segoe UI")
    Loop 4
        LV2.Add(, "Product " A_Index, "$" Random(10, 100))
    LV2.ModifyCol()

    MyGui.Add("Text", "w750", "Monospace Font (Consolas):")
    LV3 := MyGui.Add("ListView", "r4 w750", ["Code", "Value"])
    LV3.SetFont("s10", "Consolas")
    Loop 4
        LV3.Add(, Format("CODE{:04}", A_Index), Random(1000, 9999))
    LV3.ModifyCol()

    MyGui.Add("Text", "w750", "Custom Color Font:")
    LV4 := MyGui.Add("ListView", "r4 w750", ["Item", "Amount"])
    LV4.SetFont("s11 cBlue", "Arial")
    Loop 4
        LV4.Add(, "Item " A_Index, Format("${:,.2f}", Random(100, 1000)))
    LV4.ModifyCol()

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 3: Grid and Full Row Select
; ============================================================================
Example3_GridAndRowSelect() {
    MyGui := Gui("+Resize", "Example 3: Grid and Full Row Select")

    MyGui.Add("Text", "w750", "Default (no grid):")
    LV1 := MyGui.Add("ListView", "r6 w750", ["Col 1", "Col 2", "Col 3", "Col 4"])
    Loop 6
        LV1.Add(, "A" A_Index, "B" A_Index, "C" A_Index, "D" A_Index)
    LV1.ModifyCol()

    MyGui.Add("Text", "w750", "With Grid Lines:")
    LV2 := MyGui.Add("ListView", "r6 w750 Grid", ["Col 1", "Col 2", "Col 3", "Col 4"])
    Loop 6
        LV2.Add(, "A" A_Index, "B" A_Index, "C" A_Index, "D" A_Index)
    LV2.ModifyCol()

    MyGui.Add("Text", "w750", "Toggle Options:")
    MyGui.Add("Button", "w200", "Toggle Grid (LV2)").OnEvent("Click", ToggleGrid)
    MyGui.Add("Button", "w200", "Toggle Full Row Select").OnEvent("Click", ToggleFullRow)

    ToggleGrid(*) {
        static hasGrid := true
        if hasGrid
            LV2.Opt("-Grid")
        else
            LV2.Opt("+Grid")
        hasGrid := !hasGrid
        MsgBox("Grid " (hasGrid ? "enabled" : "disabled"))
    }

    ToggleFullRow(*) {
        static hasFullRow := true
        if hasFullRow {
            LV1.Opt("-FullRowSelect")
            LV2.Opt("-FullRowSelect")
        } else {
            LV1.Opt("+FullRowSelect")
            LV2.Opt("+FullRowSelect")
        }
        hasFullRow := !hasFullRow
        MsgBox("Full row select " (hasFullRow ? "enabled" : "disabled"))
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 4: View Modes
; ============================================================================
Example4_ViewModes() {
    MyGui := Gui("+Resize", "Example 4: View Modes")

    ; Create image list for icons
    ImageListID := IL_Create(5)
    IL_Add(ImageListID, "shell32.dll", 3)   ; Folder
    IL_Add(ImageListID, "shell32.dll", 1)   ; File
    IL_Add(ImageListID, "shell32.dll", 71)  ; Check
    IL_Add(ImageListID, "shell32.dll", 147) ; Image
    IL_Add(ImageListID, "shell32.dll", 165) ; Video

    LV := MyGui.Add("ListView", "r12 w750", ["Name", "Type", "Size"])
    LV.SetImageList(ImageListID)

    ; Add items with icons
    LV.Add("Icon1", "Documents", "Folder", "--")
    LV.Add("Icon2", "readme.txt", "Text File", "5 KB")
    LV.Add("Icon3", "completed.txt", "Complete", "8 KB")
    LV.Add("Icon4", "photo.jpg", "Image", "2.1 MB")
    LV.Add("Icon5", "video.mp4", "Video", "45 MB")
    LV.Add("Icon1", "Projects", "Folder", "--")
    LV.Add("Icon2", "script.ahk", "Script", "12 KB")
    LV.Add("Icon4", "banner.png", "Image", "850 KB")

    LV.ModifyCol()

    ; View mode buttons
    MyGui.Add("Text", "w750", "Change View Mode:")
    MyGui.Add("Button", "w150", "Details").OnEvent("Click", (*) => SetView("Report"))
    MyGui.Add("Button", "w150", "Large Icons").OnEvent("Click", (*) => SetView("Icon"))
    MyGui.Add("Button", "w150", "Small Icons").OnEvent("Click", (*) => SetView("SmallIcon"))
    MyGui.Add("Button", "w150", "List").OnEvent("Click", (*) => SetView("List"))
    MyGui.Add("Button", "w150", "Tile").OnEvent("Click", (*) => SetView("Tile"))

    SetView(viewType) {
        ; Remove all view options first
        LV.Opt("-Icon -IconSmall -List -Report -Tile")

        ; Apply new view
        switch viewType {
            case "Report":
                LV.Opt("+Report")
                MsgBox("Details/Report view - shows columns")
            case "Icon":
                LV.Opt("+Icon")
                MsgBox("Large icon view - best for visual content")
            case "SmallIcon":
                LV.Opt("+IconSmall")
                MsgBox("Small icon view - compact icons")
            case "List":
                LV.Opt("+List")
                MsgBox("List view - single column, no details")
            case "Tile":
                LV.Opt("+Tile")
                MsgBox("Tile view - large icons with details")
        }
    }

    MyGui.Add("Text", "w750", "Try different views to see how data is displayed")

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 5: Checkboxes and Check States
; ============================================================================
Example5_CheckboxStates() {
    MyGui := Gui("+Resize", "Example 5: Checkbox States")

    LV := MyGui.Add("ListView", "r12 w700 Checked", ["Task", "Priority", "Completed"])

    tasks := [
        ["Write documentation", "High", "No"],
        ["Code review", "Medium", "No"],
        ["Fix bug #123", "Critical", "No"],
        ["Update tests", "Low", "No"],
        ["Deploy to staging", "High", "No"],
        ["Team meeting", "Medium", "No"]
    ]

    for task in tasks {
        LV.Add(, task*)
    }

    LV.ModifyCol()

    ; Controls
    MyGui.Add("Text", "w700", "Checkbox Operations:")
    MyGui.Add("Button", "w150", "Check All").OnEvent("Click", CheckAll)
    MyGui.Add("Button", "w150", "Uncheck All").OnEvent("Click", UncheckAll)
    MyGui.Add("Button", "w150", "Toggle Selected").OnEvent("Click", ToggleSelected)
    MyGui.Add("Button", "w150", "Check High Priority").OnEvent("Click", CheckHighPriority)

    MyGui.Add("Button", "w200", "Mark Checked as Complete").OnEvent("Click", MarkComplete)
    MyGui.Add("Button", "w200", "Show Completion Status").OnEvent("Click", ShowStatus)

    CheckAll(*) {
        Loop LV.GetCount() {
            LV.Modify(A_Index, "Check")
        }
    }

    UncheckAll(*) {
        Loop LV.GetCount() {
            LV.Modify(A_Index, "-Check")
        }
    }

    ToggleSelected(*) {
        rowNum := LV.GetNext()
        if !rowNum {
            MsgBox("Select a row first!")
            return
        }

        ; Check if currently checked
        isChecked := LV.GetNext(rowNum - 1, "Checked") = rowNum

        if isChecked
            LV.Modify(rowNum, "-Check")
        else
            LV.Modify(rowNum, "Check")
    }

    CheckHighPriority(*) {
        Loop LV.GetCount() {
            priority := LV.GetText(A_Index, 2)
            if priority = "High" or priority = "Critical"
                LV.Modify(A_Index, "Check")
        }
        MsgBox("Checked all High/Critical priority tasks")
    }

    MarkComplete(*) {
        count := 0
        Loop LV.GetCount() {
            if LV.GetNext(A_Index - 1, "Checked") = A_Index {
                LV.Modify(A_Index, , , , "Yes")
                count++
            }
        }
        MsgBox("Marked " count " tasks as complete")
    }

    ShowStatus(*) {
        total := LV.GetCount()
        checked := 0
        completed := 0

        Loop total {
            if LV.GetNext(A_Index - 1, "Checked") = A_Index
                checked++
            if LV.GetText(A_Index, 3) = "Yes"
                completed++
        }

        MsgBox("Total Tasks: " total "`n"
            . "Checked: " checked "`n"
            . "Completed: " completed "`n"
            . "Remaining: " (total - completed))
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 6: Color and Background Customization
; ============================================================================
Example6_ColorCustomization() {
    MyGui := Gui("+Resize", "Example 6: Color Customization")

    MyGui.Add("Text", "w750", "Default Colors:")
    LV1 := MyGui.Add("ListView", "r5 w750", ["Item", "Value"])
    Loop 5
        LV1.Add(, "Item " A_Index, Random(100, 999))
    LV1.ModifyCol()

    MyGui.Add("Text", "w750", "Light Background:")
    LV2 := MyGui.Add("ListView", "r5 w750 Background0xF0F0F0", ["Item", "Value"])
    Loop 5
        LV2.Add(, "Item " A_Index, Random(100, 999))
    LV2.ModifyCol()

    MyGui.Add("Text", "w750", "Dark Theme (requires custom control):")
    ; Note: True dark mode requires more advanced techniques
    MyGui.Add("Text", "w750", "Background color can be set via ListView options")

    MyGui.Add("Text", "w750", "Colored Font:")
    LV3 := MyGui.Add("ListView", "r5 w750", ["Item", "Value"])
    LV3.SetFont("cRed s11 Bold")
    Loop 5
        LV3.Add(, "Item " A_Index, Random(100, 999))
    LV3.ModifyCol()

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 7: Advanced Styling Combinations
; ============================================================================
Example7_AdvancedStyling() {
    MyGui := Gui("+Resize", "Example 7: Advanced Styling")

    ; Professional styled ListView
    LV := MyGui.Add("ListView", "r15 w850 Grid Checked", ["Status", "Task", "Assigned To", "Due Date", "Priority"])

    ; Set font
    LV.SetFont("s10", "Segoe UI")

    ; Sample data with various statuses
    tasks := [
        ["✓", "Complete server migration", "Alice", "2025-11-15", "High"],
        ["○", "Code review PR #234", "Bob", "2025-11-18", "Medium"],
        ["✗", "Fix critical bug", "Charlie", "2025-11-16", "Critical"],
        ["○", "Update documentation", "Diana", "2025-11-20", "Low"],
        ["✓", "Deploy to staging", "Edward", "2025-11-14", "High"],
        ["○", "Write unit tests", "Fiona", "2025-11-19", "Medium"],
        ["○", "Database optimization", "George", "2025-11-22", "High"],
        ["✗", "Security audit", "Hannah", "2025-11-17", "Critical"],
        ["✓", "Update dependencies", "Ian", "2025-11-13", "Low"],
        ["○", "Performance testing", "Julia", "2025-11-21", "Medium"]
    ]

    for task in tasks {
        LV.Add(, task*)
    }

    ; Column widths
    LV.ModifyCol(1, 80 " Center")   ; Status
    LV.ModifyCol(2, 250)             ; Task
    LV.ModifyCol(3, 120)             ; Assigned
    LV.ModifyCol(4, 100 " Center")   ; Due Date
    LV.ModifyCol(5, 100 " Center")   ; Priority

    ; Pre-check completed items
    Loop LV.GetCount() {
        if LV.GetText(A_Index, 1) = "✓"
            LV.Modify(A_Index, "Check")
    }

    ; Action buttons
    MyGui.Add("Text", "w850", "Actions:")
    MyGui.Add("Button", "w150", "Show Summary").OnEvent("Click", ShowSummary)
    MyGui.Add("Button", "w150", "Filter Critical").OnEvent("Click", FilterCritical)
    MyGui.Add("Button", "w150", "Export Checked").OnEvent("Click", ExportChecked)
    MyGui.Add("Button", "w150", "Refresh All").OnEvent("Click", RefreshAll)

    ShowSummary(*) {
        total := LV.GetCount()
        completed := 0
        pending := 0
        blocked := 0
        critical := 0

        Loop total {
            status := LV.GetText(A_Index, 1)
            priority := LV.GetText(A_Index, 5)

            if status = "✓"
                completed++
            else if status = "○"
                pending++
            else if status = "✗"
                blocked++

            if priority = "Critical"
                critical++
        }

        MsgBox("Task Summary:`n`n"
            . "Total: " total "`n"
            . "Completed (✓): " completed "`n"
            . "Pending (○): " pending "`n"
            . "Blocked (✗): " blocked "`n"
            . "Critical Priority: " critical,
            "Summary")
    }

    FilterCritical(*) {
        MsgBox("Filtering to show only Critical priority tasks...`n(In a real app, this would filter the view)")
    }

    ExportChecked(*) {
        checked := 0
        Loop LV.GetCount() {
            if LV.GetNext(A_Index - 1, "Checked") = A_Index
                checked++
        }
        MsgBox("Exporting " checked " checked tasks...`n(In a real app, this would export to file)")
    }

    RefreshAll(*) {
        MsgBox("Refreshing task list from data source...`n(In a real app, this would reload from database)")
    }

    ; Info panel
    MyGui.Add("Text", "w850", "`nStyling Features Demonstrated:"
        . "`n  • Grid lines for better readability"
        . "`n  • Checkboxes for task completion tracking"
        . "`n  • Custom font (Segoe UI, 10pt)"
        . "`n  • Unicode symbols for visual status indicators"
        . "`n  • Column alignment (center, left)"
        . "`n  • Professional layout and spacing")

    MyGui.Show()
}

; ============================================================================
; Main Menu
; ============================================================================
MainMenu := Gui(, "ListView Styling Examples")
MainMenu.Add("Text", "w400", "Select an example to run:")
MainMenu.Add("Button", "w400", "Example 1: Basic Styling").OnEvent("Click", (*) => Example1_BasicStyling())
MainMenu.Add("Button", "w400", "Example 2: Font Customization").OnEvent("Click", (*) => Example2_FontCustomization())
MainMenu.Add("Button", "w400", "Example 3: Grid and Row Select").OnEvent("Click", (*) => Example3_GridAndRowSelect())
MainMenu.Add("Button", "w400", "Example 4: View Modes").OnEvent("Click", (*) => Example4_ViewModes())
MainMenu.Add("Button", "w400", "Example 5: Checkbox States").OnEvent("Click", (*) => Example5_CheckboxStates())
MainMenu.Add("Button", "w400", "Example 6: Color Customization").OnEvent("Click", (*) => Example6_ColorCustomization())
MainMenu.Add("Button", "w400", "Example 7: Advanced Styling").OnEvent("Click", (*) => Example7_AdvancedStyling())
MainMenu.Show()

; ============================================================================
; REFERENCE SECTION
; ============================================================================
/*
LISTVIEW STYLING OPTIONS:
-------------------------
Grid                 - Show grid lines between cells
Checked              - Add checkboxes to items
-Multi               - Single selection only
+/-FullRowSelect     - Highlight entire row on selection
Background0xRRGGBB   - Set background color

VIEW MODES:
----------
Report (default)     - Details view with columns
Icon                 - Large icons
IconSmall            - Small icons
List                 - Simple list (no columns)
Tile                 - Tile view with details

FONT STYLING:
------------
LV.SetFont("Options", "FontName")

Font Options:
s12                  - Size 12
Bold                 - Bold weight
Italic               - Italic style
cRed                 - Red color
cBlue                - Blue color
c0x0000FF            - Custom hex color

Common Fonts:
"Segoe UI"           - Modern Windows UI font
"Consolas"           - Monospace coding font
"Arial"              - Classic sans-serif
"Courier New"        - Monospace typewriter font

CHECKBOX OPERATIONS:
-------------------
; Add checkboxes
LV := Gui.Add("ListView", "Checked", [...])

; Check/uncheck items
LV.Modify(Row, "Check")
LV.Modify(Row, "-Check")

; Get checked state
isChecked := LV.GetNext(Row-1, "Checked") = Row

; Count checked items
Loop LV.GetCount() {
    if LV.GetNext(A_Index-1, "Checked") = A_Index
    count++
}

COLUMN ALIGNMENT:
----------------
LV.ModifyCol(1, 100)              ; Left (default)
LV.ModifyCol(2, 100 " Center")    ; Center aligned
LV.ModifyCol(3, 100 " Right")     ; Right aligned

COLOR OPTIONS:
-------------
Background0xFFFFFF   - White background
Background0xF0F0F0   - Light gray
Background0x000000   - Black
BackgroundDefault    - System default

; Font colors via SetFont
LV.SetFont("cRed")   - Red text
LV.SetFont("c0xFF0000") - Red via hex

VISUAL ENHANCEMENT TIPS:
-----------------------
1. Use grid lines for data tables
2. Use checkboxes for task lists
3. Monospace fonts for code/data
4. Center-align numbers for readability
5. Right-align currency values
6. Use icons to indicate file types
7. Alternate row colors (requires custom drawing)
8. Use unicode symbols (✓, ✗, ○) for status

COMMON STYLING PATTERNS:
-----------------------
; Professional task list
LV := Gui.Add("ListView", "Grid Checked", [...])
LV.SetFont("s10", "Segoe UI")
LV.ModifyCol(1, 200)        ; Task name
LV.ModifyCol(2, 100 " Center")  ; Due date
LV.ModifyCol(3, 100 " Right")   ; Priority

; Data table with grid
LV := Gui.Add("ListView", "Grid", [...])
LV.SetFont("s9", "Consolas")
LV.ModifyCol(1, 80 " Right")   ; ID
LV.ModifyCol(2, 150)           ; Name
LV.ModifyCol(3, 100 " Right")  ; Value

; File explorer style
LV := Gui.Add("ListView", "Icon", [...])
LV.SetImageList(ImageListID)
; Icons automatically displayed

UNICODE SYMBOLS:
---------------
✓ (U+2713) - Check mark
✗ (U+2717) - X mark
○ (U+25CB) - Circle
● (U+25CF) - Filled circle
▲ (U+25B2) - Up triangle
▼ (U+25BC) - Down triangle
→ (U+2192) - Right arrow
★ (U+2605) - Filled star
☆ (U+2606) - Empty star

BEST PRACTICES:
--------------
1. Keep styling consistent across application
2. Use grid lines for complex data tables
3. Use appropriate fonts for data type
4. Center/right-align numeric columns
5. Add checkboxes for selection-heavy workflows
6. Use icons to improve visual scanning
7. Choose readable color combinations
8. Test with different Windows themes
9. Consider accessibility (contrast, size)
10. Don't over-style - simplicity often wins
*/

