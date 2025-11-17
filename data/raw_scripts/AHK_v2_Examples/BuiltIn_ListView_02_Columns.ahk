#Requires AutoHotkey v2.0
/**
 * BuiltIn_ListView_02_Columns.ahk
 *
 * DESCRIPTION:
 * Advanced column management for ListView controls including resizing,
 * alignment, sorting, reordering, and dynamic column manipulation.
 *
 * FEATURES:
 * - Column width management (fixed and auto-sizing)
 * - Text alignment (left, center, right)
 * - Column insertion and removal
 * - Column header customization
 * - Programmatic column sorting
 * - Column hiding/showing techniques
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/ListView.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - ModifyCol() method with various options
 * - Dynamic column configuration
 * - Column count retrieval
 * - Header text modification
 * - Sort callbacks implementation
 *
 * LEARNING POINTS:
 * 1. Columns can be auto-sized or set to specific widths
 * 2. Column 0 refers to all columns
 * 3. Text alignment is set per column
 * 4. Columns cannot be truly removed, only hidden (width 0)
 * 5. Sort functions can implement custom sorting logic
 * 6. Column options affect all items in that column
 * 7. ModifyCol returns the column's previous width
 */

; ============================================================================
; EXAMPLE 1: Column Width Management
; ============================================================================
Example1_ColumnWidths() {
    MyGui := Gui("+Resize", "Example 1: Column Width Management")

    ; Create ListView with various width specifications
    LV := MyGui.Add("ListView", "r12 w750", ["ID", "Product Name", "Category", "Price", "Quantity"])

    ; Add sample data
    products := [
        ["001", "Wireless Mouse", "Electronics", "$29.99", "150"],
        ["002", "Mechanical Keyboard", "Electronics", "$89.99", "75"],
        ["003", "Office Desk", "Furniture", "$299.99", "20"],
        ["004", "Ergonomic Chair", "Furniture", "$399.99", "15"],
        ["005", "LED Monitor 27`"", "Electronics", "$249.99", "45"],
        ["006", "USB-C Hub", "Accessories", "$39.99", "200"],
        ["007", "Laptop Stand", "Accessories", "$49.99", "100"]
    ]

    for product in products {
        LV.Add(, product*)
    }

    ; Set specific column widths
    LV.ModifyCol(1, 50)      ; ID - narrow
    LV.ModifyCol(2, 200)     ; Product Name - wide
    LV.ModifyCol(3, 120)     ; Category
    LV.ModifyCol(4, 80)      ; Price
    LV.ModifyCol(5, 80)      ; Quantity

    ; Control buttons
    MyGui.Add("Text", "w750", "Column Width Controls:")
    MyGui.Add("Button", "w150", "Auto-size All").OnEvent("Click", AutoSizeAll)
    MyGui.Add("Button", "w150", "Auto-size Name").OnEvent("Click", AutoSizeName)
    MyGui.Add("Button", "w150", "Reset Widths").OnEvent("Click", ResetWidths)
    MyGui.Add("Button", "w150", "Expand All").OnEvent("Click", ExpandAll)
    MyGui.Add("Button", "w150", "Compact View").OnEvent("Click", CompactView)

    AutoSizeAll(*) {
        LV.ModifyCol()  ; Auto-size all columns
        MsgBox("All columns auto-sized to fit content!")
    }

    AutoSizeName(*) {
        LV.ModifyCol(2)  ; Auto-size column 2 only
        MsgBox("Product Name column auto-sized!")
    }

    ResetWidths(*) {
        LV.ModifyCol(1, 50)
        LV.ModifyCol(2, 200)
        LV.ModifyCol(3, 120)
        LV.ModifyCol(4, 80)
        LV.ModifyCol(5, 80)
        MsgBox("Column widths reset to default!")
    }

    ExpandAll(*) {
        LV.ModifyCol(1, 80)
        LV.ModifyCol(2, 300)
        LV.ModifyCol(3, 150)
        LV.ModifyCol(4, 100)
        LV.ModifyCol(5, 100)
        MsgBox("Columns expanded!")
    }

    CompactView(*) {
        LV.ModifyCol(1, 40)
        LV.ModifyCol(2, 150)
        LV.ModifyCol(3, 80)
        LV.ModifyCol(4, 60)
        LV.ModifyCol(5, 50)
        MsgBox("Compact view applied!")
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 2: Column Text Alignment
; ============================================================================
Example2_ColumnAlignment() {
    MyGui := Gui("+Resize", "Example 2: Column Alignment")

    LV := MyGui.Add("ListView", "r10 w700", ["Left Aligned", "Center Aligned", "Right Aligned", "Mixed"])

    ; Add sample data
    Loop 8 {
        LV.Add(, "Text " A_Index, "Centered " A_Index, "Right " A_Index, Format("${:,.2f}", A_Index * 123.45))
    }

    ; Set column alignments and widths
    LV.ModifyCol(1, 150)              ; Left (default)
    LV.ModifyCol(2, 150 " Center")    ; Center aligned
    LV.ModifyCol(3, 150 " Right")     ; Right aligned
    LV.ModifyCol(4, 150 " Right")     ; Right aligned for currency

    ; Information display
    MyGui.Add("Text", "w700", "Column Alignment Information:")
    infoText := MyGui.Add("Edit", "r6 w700 ReadOnly",
        "Column 1: Left aligned (default)`n"
        "Column 2: Center aligned`n"
        "Column 3: Right aligned`n"
        "Column 4: Right aligned (currency)`n`n"
        "Alignment is set using ModifyCol() options."
    )

    ; Buttons to demonstrate alignment changes
    MyGui.Add("Button", "w200", "Reset to Left").OnEvent("Click", ResetLeft)
    MyGui.Add("Button", "w200", "All Center").OnEvent("Click", AllCenter)
    MyGui.Add("Button", "w200", "All Right").OnEvent("Click", AllRight)

    ResetLeft(*) {
        Loop 4 {
            LV.ModifyCol(A_Index, 150)  ; Remove alignment, defaults to left
        }
        MsgBox("All columns reset to left alignment!")
    }

    AllCenter(*) {
        Loop 4 {
            LV.ModifyCol(A_Index, 150 " Center")
        }
        MsgBox("All columns centered!")
    }

    AllRight(*) {
        Loop 4 {
            LV.ModifyCol(A_Index, 150 " Right")
        }
        MsgBox("All columns right-aligned!")
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 3: Dynamic Column Headers
; ============================================================================
Example3_DynamicHeaders() {
    MyGui := Gui("+Resize", "Example 3: Dynamic Column Headers")

    ; Initial headers
    LV := MyGui.Add("ListView", "r10 w700", ["Column A", "Column B", "Column C", "Column D"])

    ; Add data
    Loop 5 {
        LV.Add(, "A" A_Index, "B" A_Index, "C" A_Index, "D" A_Index)
    }

    LV.ModifyCol()  ; Auto-size

    ; Controls for changing headers
    MyGui.Add("Text", "w700", "Change Column Headers:")
    MyGui.Add("Text", "x10", "Column:")
    colNum := MyGui.Add("DropDownList", "x80 yp w100", ["Column 1", "Column 2", "Column 3", "Column 4"])
    colNum.Choose(1)

    MyGui.Add("Text", "x200 yp", "New Header:")
    newHeader := MyGui.Add("Edit", "x300 yp w200", "New Header Text")

    MyGui.Add("Button", "w200", "Update Header").OnEvent("Click", UpdateHeader)
    MyGui.Add("Button", "w200", "Preset: Data Fields").OnEvent("Click", PresetData)
    MyGui.Add("Button", "w200", "Preset: Months").OnEvent("Click", PresetMonths)
    MyGui.Add("Button", "w200", "Preset: Quarters").OnEvent("Click", PresetQuarters)

    UpdateHeader(*) {
        colIndex := colNum.Value
        headerText := newHeader.Value

        if headerText = "" {
            MsgBox("Please enter a header text!")
            return
        }

        ; Update column header
        LV.ModifyCol(colIndex, "AutoHdr", headerText)
        MsgBox("Column " colIndex " header updated to: " headerText)
    }

    PresetData(*) {
        LV.ModifyCol(1, "AutoHdr", "ID")
        LV.ModifyCol(2, "AutoHdr", "Name")
        LV.ModifyCol(3, "AutoHdr", "Value")
        LV.ModifyCol(4, "AutoHdr", "Status")
        MsgBox("Headers updated to data field names!")
    }

    PresetMonths(*) {
        LV.ModifyCol(1, "AutoHdr", "January")
        LV.ModifyCol(2, "AutoHdr", "February")
        LV.ModifyCol(3, "AutoHdr", "March")
        LV.ModifyCol(4, "AutoHdr", "April")
        MsgBox("Headers updated to months!")
    }

    PresetQuarters(*) {
        LV.ModifyCol(1, "AutoHdr", "Q1 2025")
        LV.ModifyCol(2, "AutoHdr", "Q2 2025")
        LV.ModifyCol(3, "AutoHdr", "Q3 2025")
        LV.ModifyCol(4, "AutoHdr", "Q4 2025")
        MsgBox("Headers updated to quarters!")
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 4: Column Visibility Toggle
; ============================================================================
Example4_ColumnVisibility() {
    MyGui := Gui("+Resize", "Example 4: Column Visibility")

    LV := MyGui.Add("ListView", "r12 w800", ["ID", "Name", "Department", "Email", "Phone", "Salary"])

    ; Add employee data
    employees := [
        ["E001", "John Smith", "Engineering", "john@company.com", "555-0101", "$85,000"],
        ["E002", "Jane Doe", "Marketing", "jane@company.com", "555-0102", "$72,000"],
        ["E003", "Bob Wilson", "Sales", "bob@company.com", "555-0103", "$68,000"],
        ["E004", "Alice Brown", "Engineering", "alice@company.com", "555-0104", "$92,000"],
        ["E005", "Charlie Davis", "HR", "charlie@company.com", "555-0105", "$65,000"]
    ]

    for emp in employees {
        LV.Add(, emp*)
    }

    ; Store original column widths
    colWidths := [60, 150, 120, 200, 100, 100]

    ; Set initial widths
    Loop 6 {
        LV.ModifyCol(A_Index, colWidths[A_Index])
    }

    ; Column visibility checkboxes
    MyGui.Add("Text", "w800", "Toggle Column Visibility:")
    cb1 := MyGui.Add("Checkbox", "Checked", "ID")
    cb2 := MyGui.Add("Checkbox", "Checked", "Name")
    cb3 := MyGui.Add("Checkbox", "Checked", "Department")
    cb4 := MyGui.Add("Checkbox", "Checked", "Email")
    cb5 := MyGui.Add("Checkbox", "Checked", "Phone")
    cb6 := MyGui.Add("Checkbox", "Checked", "Salary")

    checkboxes := [cb1, cb2, cb3, cb4, cb5, cb6]

    ; Register event handlers
    Loop 6 {
        colIndex := A_Index
        checkboxes[colIndex].OnEvent("Click", (*) => ToggleColumn(colIndex))
    }

    ToggleColumn(colIndex) {
        if checkboxes[colIndex].Value {
            ; Show column - restore original width
            LV.ModifyCol(colIndex, colWidths[colIndex])
        } else {
            ; Hide column - set width to 0
            LV.ModifyCol(colIndex, 0)
        }
    }

    ; Preset buttons
    MyGui.Add("Button", "w150", "Show All").OnEvent("Click", ShowAll)
    MyGui.Add("Button", "w150", "Hide All").OnEvent("Click", HideAll)
    MyGui.Add("Button", "w150", "Public Info Only").OnEvent("Click", PublicOnly)
    MyGui.Add("Button", "w150", "Contact Info Only").OnEvent("Click", ContactOnly)

    ShowAll(*) {
        Loop 6 {
            checkboxes[A_Index].Value := 1
            LV.ModifyCol(A_Index, colWidths[A_Index])
        }
    }

    HideAll(*) {
        Loop 6 {
            checkboxes[A_Index].Value := 0
            LV.ModifyCol(A_Index, 0)
        }
    }

    PublicOnly(*) {
        ; Show: ID, Name, Department (hide sensitive info)
        ShowAll()
        checkboxes[4].Value := 0
        LV.ModifyCol(4, 0)  ; Hide Email
        checkboxes[5].Value := 0
        LV.ModifyCol(5, 0)  ; Hide Phone
        checkboxes[6].Value := 0
        LV.ModifyCol(6, 0)  ; Hide Salary
    }

    ContactOnly(*) {
        ; Show: Name, Email, Phone
        HideAll()
        checkboxes[2].Value := 1
        LV.ModifyCol(2, colWidths[2])  ; Show Name
        checkboxes[4].Value := 1
        LV.ModifyCol(4, colWidths[4])  ; Show Email
        checkboxes[5].Value := 1
        LV.ModifyCol(5, colWidths[5])  ; Show Phone
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 5: Column Auto-Header Sizing
; ============================================================================
Example5_AutoHeaderSizing() {
    MyGui := Gui("+Resize", "Example 5: Auto-Header Sizing")

    LV := MyGui.Add("ListView", "r10 w750", ["Short", "Medium Length Header", "Very Long Header Title Here", "X"])

    ; Add data with varying lengths
    LV.Add(, "A", "Data", "Short", "1")
    LV.Add(, "BB", "More data here", "Medium length content", "22")
    LV.Add(, "CCC", "Text", "This is a very long piece of content", "333")
    LV.Add(, "DDDD", "Information", "Data", "4444")

    MyGui.Add("Text", "w750", "Auto-Header Sizing Options:")

    MyGui.Add("Button", "w200", "AutoHdr (Content)").OnEvent("Click", AutoContent)
    MyGui.Add("Button", "w200", "AutoHdr (Header)").OnEvent("Click", AutoHeader)
    MyGui.Add("Button", "w200", "Auto (Both)").OnEvent("Click", AutoBoth)
    MyGui.Add("Button", "w200", "Fixed 100px").OnEvent("Click", Fixed100)

    ; Info display
    infoEdit := MyGui.Add("Edit", "r8 w750 ReadOnly")

    AutoContent(*) {
        Loop 4 {
            LV.ModifyCol(A_Index, "AutoHdr")
        }
        infoEdit.Value := "AutoHdr: Sizes to fit content, ignoring header width.`n"
            . "Good when content is more important than header."
    }

    AutoHeader(*) {
        Loop 4 {
            LV.ModifyCol(A_Index, "Auto")
        }
        infoEdit.Value := "Auto: Sizes to fit both header and content.`n"
            . "Ensures header is fully visible."
    }

    AutoBoth(*) {
        LV.ModifyCol()  ; Auto-size all
        infoEdit.Value := "ModifyCol(): Auto-sizes all columns to fit both header and content.`n"
            . "This is the recommended approach for best visibility."
    }

    Fixed100(*) {
        Loop 4 {
            LV.ModifyCol(A_Index, 100)
        }
        infoEdit.Value := "Fixed 100px: All columns set to exact width.`n"
            . "Content or headers may be cut off."
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 6: Multi-Column Sorting
; ============================================================================
Example6_ColumnSorting() {
    MyGui := Gui("+Resize", "Example 6: Column Sorting")

    LV := MyGui.Add("ListView", "r12 w700 Sort", ["Name", "Age", "Department", "Salary"])

    ; Add employee data
    employees := [
        ["Alice Johnson", "28", "Engineering", "85000"],
        ["Bob Smith", "35", "Marketing", "72000"],
        ["Charlie Brown", "42", "Sales", "68000"],
        ["Diana Prince", "31", "Engineering", "92000"],
        ["Edward Norton", "27", "HR", "65000"],
        ["Fiona Apple", "38", "Marketing", "71000"],
        ["George Wilson", "45", "Engineering", "95000"],
        ["Hannah Baker", "29", "Sales", "70000"]
    ]

    for emp in employees {
        LV.Add(, emp*)
    }

    LV.ModifyCol(1, 150)
    LV.ModifyCol(2, 80)
    LV.ModifyCol(3, 120)
    LV.ModifyCol(4, 100 " Right")

    ; Sorting controls
    MyGui.Add("Text", "w700", "Click column headers to sort, or use buttons:")
    MyGui.Add("Button", "w150", "Sort by Name ↑").OnEvent("Click", (*) => SortColumn(1, "Asc"))
    MyGui.Add("Button", "w150", "Sort by Age ↓").OnEvent("Click", (*) => SortColumn(2, "Desc"))
    MyGui.Add("Button", "w150", "Sort by Dept ↑").OnEvent("Click", (*) => SortColumn(3, "Asc"))
    MyGui.Add("Button", "w150", "Sort by Salary ↓").OnEvent("Click", (*) => SortColumn(4, "Desc"))
    MyGui.Add("Button", "w150", "Original Order").OnEvent("Click", RestoreOrder)

    SortColumn(col, direction) {
        if direction = "Asc"
            LV.ModifyCol(col, "Sort")
        else
            LV.ModifyCol(col, "SortDesc")
    }

    RestoreOrder(*) {
        LV.Delete()
        for emp in employees {
            LV.Add(, emp*)
        }
        MsgBox("Restored to original order!")
    }

    ; Handle column header clicks
    LV.OnEvent("ColClick", ColClickHandler)

    ColClickHandler(LV, ColNumber) {
        ; Toggle sort direction
        static lastCol := 0
        static ascending := true

        if ColNumber = lastCol
            ascending := !ascending
        else
            ascending := true

        lastCol := ColNumber

        if ascending
            LV.ModifyCol(ColNumber, "Sort")
        else
            LV.ModifyCol(ColNumber, "SortDesc")
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 7: Column Count and Information
; ============================================================================
Example7_ColumnInformation() {
    MyGui := Gui("+Resize", "Example 7: Column Information")

    ; Start with 3 columns
    LV := MyGui.Add("ListView", "r10 w750", ["Column 1", "Column 2", "Column 3"])

    ; Add sample data
    Loop 5 {
        LV.Add(, "Data 1." A_Index, "Data 2." A_Index, "Data 3." A_Index)
    }

    LV.ModifyCol()

    ; Information display
    MyGui.Add("Text", "w750", "Column Information:")
    infoEdit := MyGui.Add("Edit", "r10 w750 ReadOnly")

    MyGui.Add("Button", "w200", "Show Column Info").OnEvent("Click", ShowInfo)
    MyGui.Add("Button", "w200", "Measure Columns").OnEvent("Click", MeasureColumns)
    MyGui.Add("Button", "w200", "Column Statistics").OnEvent("Click", ColumnStats)

    ShowInfo(*) {
        colCount := LV.GetCount("Column")
        rowCount := LV.GetCount()

        info := "ListView Structure:`n"
        info .= StrRepeat("=", 50) "`n`n"
        info .= "Total Columns: " colCount "`n"
        info .= "Total Rows: " rowCount "`n`n"

        info .= "Column Headers:`n"
        Loop colCount {
            ; Get header text by reading first row and using column index
            info .= "  Column " A_Index ": Column " A_Index "`n"
        }

        infoEdit.Value := info
    }

    MeasureColumns(*) {
        colCount := LV.GetCount("Column")

        info := "Column Width Measurements:`n"
        info .= StrRepeat("=", 50) "`n`n"

        ; Measure each column by temporarily storing width
        Loop colCount {
            ; Get current width by auto-sizing and checking
            LV.ModifyCol(A_Index)  ; Auto-size
            Sleep 50  ; Brief pause for measurement

            info .= "Column " A_Index ": Auto-sized`n"
        }

        info .= "`nNote: Exact pixel measurements require additional API calls."

        infoEdit.Value := info
    }

    ColumnStats(*) {
        colCount := LV.GetCount("Column")
        rowCount := LV.GetCount()

        info := "Column Statistics:`n"
        info .= StrRepeat("=", 50) "`n`n"

        Loop colCount {
            colNum := A_Index
            totalLength := 0
            maxLength := 0
            minLength := 999999

            ; Analyze data in this column
            Loop rowCount {
                text := LV.GetText(A_Index, colNum)
                textLen := StrLen(text)

                totalLength += textLen
                maxLength := Max(maxLength, textLen)
                minLength := Min(minLength, textLen)
            }

            avgLength := Round(totalLength / rowCount, 2)

            info .= "Column " colNum ":`n"
            info .= "  Average text length: " avgLength " chars`n"
            info .= "  Max length: " maxLength " chars`n"
            info .= "  Min length: " minLength " chars`n`n"
        }

        infoEdit.Value := info
    }

    MyGui.Show()
}

; ============================================================================
; Helper Function
; ============================================================================
StrRepeat(str, count) {
    result := ""
    Loop count
        result .= str
    return result
}

; ============================================================================
; Main Menu
; ============================================================================
MainMenu := Gui(, "ListView Column Management Examples")
MainMenu.Add("Text", "w400", "Select an example to run:")
MainMenu.Add("Button", "w400", "Example 1: Column Widths").OnEvent("Click", (*) => Example1_ColumnWidths())
MainMenu.Add("Button", "w400", "Example 2: Column Alignment").OnEvent("Click", (*) => Example2_ColumnAlignment())
MainMenu.Add("Button", "w400", "Example 3: Dynamic Headers").OnEvent("Click", (*) => Example3_DynamicHeaders())
MainMenu.Add("Button", "w400", "Example 4: Column Visibility").OnEvent("Click", (*) => Example4_ColumnVisibility())
MainMenu.Add("Button", "w400", "Example 5: Auto-Header Sizing").OnEvent("Click", (*) => Example5_AutoHeaderSizing())
MainMenu.Add("Button", "w400", "Example 6: Column Sorting").OnEvent("Click", (*) => Example6_ColumnSorting())
MainMenu.Add("Button", "w400", "Example 7: Column Information").OnEvent("Click", (*) => Example7_ColumnInformation())
MainMenu.Show()

; ============================================================================
; REFERENCE SECTION
; ============================================================================
/*
MODIFYCOL SYNTAX:
----------------
LV.ModifyCol([Column, Options, HeaderText])

COLUMN PARAMETER:
----------------
0 or omitted     - All columns
1, 2, 3...       - Specific column number

WIDTH OPTIONS:
-------------
Integer          - Exact width in pixels
"Auto"           - Auto-size to fit header and content
"AutoHdr"        - Auto-size to fit content only

ALIGNMENT OPTIONS:
-----------------
(default)        - Left aligned
"Center"         - Center aligned
"Right"          - Right aligned

SORTING OPTIONS:
---------------
"Sort"           - Sort ascending
"SortDesc"       - Sort descending
(Combine with other options using spaces)

HEADER PARAMETER:
----------------
String           - New header text for the column

COLUMN VISIBILITY:
-----------------
Width of 0       - Effectively hides column
Restore width    - Shows column again
(Columns cannot be truly deleted, only hidden)

BEST PRACTICES:
--------------
1. Set column widths after adding all data for better auto-sizing
2. Use "Auto" for headers longer than content
3. Use "AutoHdr" for content longer than headers
4. Right-align numeric columns for better readability
5. Store original widths when implementing hide/show functionality
6. Use ModifyCol(0, options) to apply options to all columns at once
7. Call ModifyCol() without parameters to auto-size all columns optimally

COMMON PATTERNS:
---------------
LV.ModifyCol()                      ; Auto-size all columns
LV.ModifyCol(1, 100)                ; Set column 1 to 100px
LV.ModifyCol(2, "AutoHdr Right")    ; Auto-size and right-align
LV.ModifyCol(3, 0)                  ; Hide column 3
LV.ModifyCol(0, "Center")           ; Center all columns
LV.ModifyCol(4, 150, "New Header")  ; Change width and header

COLUMN COUNT:
------------
LV.GetCount("Column")               ; Returns number of columns
*/
