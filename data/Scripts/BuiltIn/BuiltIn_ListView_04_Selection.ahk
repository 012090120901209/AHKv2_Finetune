#Requires AutoHotkey v2.0

/**
* BuiltIn_ListView_04_Selection.ahk
*
* DESCRIPTION:
* Comprehensive guide to selection handling in ListView controls including single/multi
* selection modes, programmatic selection, selection events, and focused items.
*
* FEATURES:
* - Single and multi-selection modes
* - Programmatic selection/deselection
* - Getting selected items and their data
* - Focus management
* - Selection events and callbacks
* - Select all/none operations
* - Range selection
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/ListView.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - GetNext() for iteration through selected items
* - Modify() with Select/Focus options
* - ItemSelect event handling
* - GetCount("Selected") method
* - Single selection mode (-Multi option)
*
* LEARNING POINTS:
* 1. Default ListView allows multiple selection
* 2. GetNext() returns 0 when no more selected items
* 3. Selection != Focus (can have focus without selection)
* 4. ItemSelect event fires for each item selection change
* 5. Use GetNext() in loop to process all selected items
* 6. -Multi option restricts to single selection only
* 7. Selection persists across sorting and filtering
*/

; ============================================================================
; EXAMPLE 1: Single vs Multi-Selection Modes
; ============================================================================
Example1_SelectionModes() {
    ; Multi-selection ListView
    MyGui := Gui("+Resize", "Example 1: Selection Modes")

    MyGui.Add("Text", "w700", "Multi-Selection ListView (Ctrl+Click, Shift+Click):")
    LV1 := MyGui.Add("ListView", "r8 w700", ["Item", "Description"])

    Loop 10 {
        LV1.Add(, "Item " A_Index, "This is item number " A_Index)
    }
    LV1.ModifyCol()

    MyGui.Add("Text", "w700", "Single-Selection ListView (-Multi option):")
    LV2 := MyGui.Add("ListView", "r8 w700 -Multi", ["Item", "Description"])

    Loop 10 {
        LV2.Add(, "Item " A_Index, "This is item number " A_Index)
    }
    LV2.ModifyCol()

    ; Buttons to test selection
    MyGui.Add("Button", "w200", "Count Multi Selected").OnEvent("Click", CountMulti)
    MyGui.Add("Button", "w200", "Count Single Selected").OnEvent("Click", CountSingle)
    MyGui.Add("Button", "w200", "Try Select Multiple").OnEvent("Click", TryMultiple)

    CountMulti(*) {
        count := LV1.GetCount("Selected")
        MsgBox("Multi-Select ListView has " count " items selected.`n`n"
        . "Try Ctrl+Click or Shift+Click to select multiple items!")
    }

    CountSingle(*) {
        count := LV2.GetCount("Selected")
        MsgBox("Single-Select ListView has " count " items selected.`n`n"
        . "This ListView only allows one selection at a time.")
    }

    TryMultiple(*) {
        ; Select multiple items in both ListViews
        LV1.Modify(2, "Select")
        LV1.Modify(5, "Select")
        LV1.Modify(8, "Select")

        LV2.Modify(2, "Select")
        LV2.Modify(5, "Select")  ; This will deselect item 2
        LV2.Modify(8, "Select")  ; This will deselect item 5

        MsgBox("Attempted to select items 2, 5, and 8 in both ListViews.`n`n"
        . "Multi-Select: All three selected`n"
        . "Single-Select: Only last one (8) remains selected")
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 2: Getting Selected Items
; ============================================================================
Example2_GettingSelection() {
    MyGui := Gui("+Resize", "Example 2: Getting Selected Items")

    LV := MyGui.Add("ListView", "r12 w700", ["ID", "Product", "Price", "Quantity"])

    ; Add products
    products := [
    ["P001", "Laptop", "$999", "5"],
    ["P002", "Mouse", "$25", "50"],
    ["P003", "Keyboard", "$75", "30"],
    ["P004", "Monitor", "$299", "15"],
    ["P005", "Headphones", "$149", "25"],
    ["P006", "Webcam", "$89", "40"],
    ["P007", "Microphone", "$129", "12"],
    ["P008", "USB Hub", "$35", "60"],
    ["P009", "Laptop Stand", "$49", "20"],
    ["P010", "Mouse Pad", "$15", "100"]
    ]

    for product in products {
        LV.Add(, product*)
    }

    LV.ModifyCol()

    ; Selection action buttons
    MyGui.Add("Text", "w700", "Select items and use these functions:")
    MyGui.Add("Button", "w200", "Show Selected IDs").OnEvent("Click", ShowIDs)
    MyGui.Add("Button", "w200", "Calculate Total Value").OnEvent("Click", CalcTotal)
    MyGui.Add("Button", "w200", "List Selected Products").OnEvent("Click", ListProducts)
    MyGui.Add("Button", "w200", "Export Selected").OnEvent("Click", ExportSelected)

    ; Result display
    resultEdit := MyGui.Add("Edit", "r6 w700 ReadOnly")

    ShowIDs(*) {
        ids := ""
        rowNum := 0

        Loop {
            rowNum := LV.GetNext(rowNum)
            if !rowNum
            break
            ids .= LV.GetText(rowNum, 1) ", "
        }

        if ids = ""
        resultEdit.Value := "No items selected!"
        else
        resultEdit.Value := "Selected IDs: " SubStr(ids, 1, -2)
    }

    CalcTotal(*) {
        totalValue := 0
        totalItems := 0
        rowNum := 0

        Loop {
            rowNum := LV.GetNext(rowNum)
            if !rowNum
            break

            ; Extract price (remove $ and convert to number)
            priceText := LV.GetText(rowNum, 3)
            price := Number(SubStr(priceText, 2))  ; Remove $

            ; Get quantity
            qty := Number(LV.GetText(rowNum, 4))

            totalValue += price * qty
            totalItems += qty
        }

        if totalItems = 0
        resultEdit.Value := "No items selected!"
        else
        resultEdit.Value := "Selected Items: " totalItems "`n"
        . "Total Value: $" Format("{:,.2f}", totalValue)
    }

    ListProducts(*) {
        list := "Selected Products:`n" StrRepeat("=", 50) "`n`n"
        rowNum := 0
        count := 0

        Loop {
            rowNum := LV.GetNext(rowNum)
            if !rowNum
            break

            count++
            product := LV.GetText(rowNum, 2)
            price := LV.GetText(rowNum, 3)
            qty := LV.GetText(rowNum, 4)

            list .= count ". " product " - " price " (Qty: " qty ")`n"
        }

        if count = 0
        resultEdit.Value := "No items selected!"
        else
        resultEdit.Value := list
    }

    ExportSelected(*) {
        output := "Product Export`n"
        output .= StrRepeat("=", 60) "`n`n"

        rowNum := 0
        count := 0

        Loop {
            rowNum := LV.GetNext(rowNum)
            if !rowNum
            break

            count++
            id := LV.GetText(rowNum, 1)
            product := LV.GetText(rowNum, 2)
            price := LV.GetText(rowNum, 3)
            qty := LV.GetText(rowNum, 4)

            output .= "ID: " id "`n"
            output .= "Product: " product "`n"
            output .= "Price: " price "`n"
            output .= "Quantity: " qty "`n`n"
        }

        if count = 0
        resultEdit.Value := "No items selected!"
        else {
            resultEdit.Value := output . "Total: " count " items exported"
            MsgBox(output, "Export Complete")
        }
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 3: Programmatic Selection
; ============================================================================
Example3_ProgrammaticSelection() {
    MyGui := Gui("+Resize", "Example 3: Programmatic Selection")

    LV := MyGui.Add("ListView", "r14 w700", ["Row", "Status", "Value", "Category"])

    ; Add data
    categories := ["A", "B", "C", "A", "B", "C", "A", "B", "C", "A", "B", "C"]
    Loop 12 {
        status := (Mod(A_Index, 2) = 0) ? "Active" : "Inactive"
        LV.Add(, A_Index, status, Random(100, 999), categories[A_Index])
    }

    LV.ModifyCol()

    ; Selection control buttons
    MyGui.Add("Text", "w700", "Selection Controls:")
    MyGui.Add("Button", "w150", "Select All").OnEvent("Click", SelectAll)
    MyGui.Add("Button", "w150", "Deselect All").OnEvent("Click", DeselectAll)
    MyGui.Add("Button", "w150", "Invert Selection").OnEvent("Click", InvertSelection)

    MyGui.Add("Button", "w150", "Select Even Rows").OnEvent("Click", SelectEven)
    MyGui.Add("Button", "w150", "Select Odd Rows").OnEvent("Click", SelectOdd)
    MyGui.Add("Button", "w150", "Select First 5").OnEvent("Click", SelectFirst5)

    MyGui.Add("Button", "w150", "Select Active").OnEvent("Click", SelectActive)
    MyGui.Add("Button", "w150", "Select Category A").OnEvent("Click", SelectCategoryA)
    MyGui.Add("Button", "w150", "Select Range 3-7").OnEvent("Click", SelectRange)

    ; Status display
    statusText := MyGui.Add("Text", "w700", "0 items selected")

    ; Update status on any selection change
    LV.OnEvent("ItemSelect", (*) => UpdateStatus())

    UpdateStatus() {
        count := LV.GetCount("Selected")
        statusText.Value := count " items selected"
    }

    SelectAll(*) {
        Loop LV.GetCount() {
            LV.Modify(A_Index, "Select")
        }
    }

    DeselectAll(*) {
        Loop LV.GetCount() {
            LV.Modify(A_Index, "-Select")
        }
    }

    InvertSelection(*) {
        Loop LV.GetCount() {
            ; Check if currently selected
            LV.Modify(A_Index, "Focus")  ; Temporarily focus to check
            if LV.GetNext(A_Index - 1) = A_Index
            LV.Modify(A_Index, "-Select")
            else
            LV.Modify(A_Index, "Select")
        }
    }

    SelectEven(*) {
        DeselectAll()
        Loop LV.GetCount() {
            if Mod(A_Index, 2) = 0
            LV.Modify(A_Index, "Select")
        }
    }

    SelectOdd(*) {
        DeselectAll()
        Loop LV.GetCount() {
            if Mod(A_Index, 2) = 1
            LV.Modify(A_Index, "Select")
        }
    }

    SelectFirst5(*) {
        DeselectAll()
        Loop Min(5, LV.GetCount()) {
            LV.Modify(A_Index, "Select")
        }
    }

    SelectActive(*) {
        DeselectAll()
        Loop LV.GetCount() {
            if LV.GetText(A_Index, 2) = "Active"
            LV.Modify(A_Index, "Select")
        }
    }

    SelectCategoryA(*) {
        DeselectAll()
        Loop LV.GetCount() {
            if LV.GetText(A_Index, 4) = "A"
            LV.Modify(A_Index, "Select")
        }
    }

    SelectRange(*) {
        DeselectAll()
        Loop 5 {  ; Rows 3-7 (5 rows)
        LV.Modify(A_Index + 2, "Select")
    }
}

MyGui.Show()
}

; ============================================================================
; EXAMPLE 4: Focus vs Selection
; ============================================================================
Example4_FocusVsSelection() {
    MyGui := Gui("+Resize", "Example 4: Focus vs Selection")

    LV := MyGui.Add("ListView", "r10 w700", ["Item", "Selection", "Focus"])

    Loop 10 {
        LV.Add(, "Item " A_Index, "Not Selected", "No Focus")
    }

    LV.ModifyCol()

    MyGui.Add("Text", "w700", "Focus Control:")
    MyGui.Add("Button", "w200", "Focus Row 5").OnEvent("Click", FocusRow5)
    MyGui.Add("Button", "w200", "Select Row 3").OnEvent("Click", SelectRow3)
    MyGui.Add("Button", "w200", "Focus + Select Row 7").OnEvent("Click", FocusSelectRow7)

    MyGui.Add("Text", "w700", "Information:")
    MyGui.Add("Button", "w200", "Show Focused Row").OnEvent("Click", ShowFocused)
    MyGui.Add("Button", "w200", "Show Selected Rows").OnEvent("Click", ShowSelected)
    MyGui.Add("Button", "w200", "Update Display").OnEvent("Click", UpdateDisplay)

    infoEdit := MyGui.Add("Edit", "r5 w700 ReadOnly")

    FocusRow5(*) {
        LV.Modify(5, "Focus")
        UpdateDisplay()
        infoEdit.Value := "Row 5 now has keyboard focus (dotted border).`n"
        . "Focus does not mean selected!"
    }

    SelectRow3(*) {
        LV.Modify(3, "Select")
        UpdateDisplay()
        infoEdit.Value := "Row 3 is now selected (highlighted).`n"
        . "Selection does not automatically give focus!"
    }

    FocusSelectRow7(*) {
        LV.Modify(7, "Focus Select")
        UpdateDisplay()
        infoEdit.Value := "Row 7 now has both focus AND selection.`n"
        . "This is the most common combination."
    }

    ShowFocused(*) {
        ; Find focused row using GetNext with "Focused" parameter
        focusedRow := LV.GetNext(0, "Focused")
        if focusedRow
        infoEdit.Value := "Focused row: " focusedRow "`n"
        . "Item: " LV.GetText(focusedRow, 1)
        else
        infoEdit.Value := "No row has focus."
    }

    ShowSelected(*) {
        selected := []
        rowNum := 0

        Loop {
            rowNum := LV.GetNext(rowNum)
            if !rowNum
            break
            selected.Push(rowNum)
        }

        if selected.Length = 0
        infoEdit.Value := "No rows selected."
        else
        infoEdit.Value := "Selected rows: " selected.Length "`n"
        . "Row numbers: " ArrayToString(selected)
    }

    UpdateDisplay(*) {
        ; Update all rows to show their state
        Loop LV.GetCount() {
            row := A_Index

            ; Check if selected
            isSelected := false
            checkRow := 0
            Loop {
                checkRow := LV.GetNext(checkRow)
                if !checkRow
                break
                if checkRow = row {
                    isSelected := true
                    break
                }
            }

            ; Check if focused
            isFocused := (LV.GetNext(0, "Focused") = row)

            ; Update display
            selText := isSelected ? "Selected" : "Not Selected"
            focText := isFocused ? "Has Focus" : "No Focus"
            LV.Modify(row, , , selText, focText)
        }
    }

    ArrayToString(arr) {
        result := ""
        for item in arr
        result .= item ", "
        return SubStr(result, 1, -2)
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 5: Selection Events
; ============================================================================
Example5_SelectionEvents() {
    MyGui := Gui("+Resize", "Example 5: Selection Events")

    LV := MyGui.Add("ListView", "r10 w700", ["Name", "Type", "Size"])

    files := [
    ["document.txt", "Text", "5 KB"],
    ["image.jpg", "Image", "1.2 MB"],
    ["video.mp4", "Video", "45 MB"],
    ["script.ahk", "Script", "8 KB"],
    ["data.csv", "Data", "125 KB"]
    ]

    for file in files {
        LV.Add(, file*)
    }

    LV.ModifyCol()

    ; Event log
    MyGui.Add("Text", "w700", "Event Log:")
    logEdit := MyGui.Add("Edit", "r10 w700 ReadOnly")
    eventLog := ""

    ; Register selection event
    LV.OnEvent("ItemSelect", ItemSelectHandler)
    LV.OnEvent("ItemFocus", ItemFocusHandler)

    ItemSelectHandler(LV, Item, Selected) {
        timestamp := FormatTime(, "HH:mm:ss")
        itemName := LV.GetText(Item, 1)

        if Selected {
            eventLog .= timestamp " - SELECTED: Row " Item " (" itemName ")`n"
        } else {
            eventLog .= timestamp " - DESELECTED: Row " Item " (" itemName ")`n"
        }

        logEdit.Value := eventLog
        ; Auto-scroll to bottom
        logEdit.Enabled := false
        logEdit.Enabled := true
    }

    ItemFocusHandler(LV, Item) {
        timestamp := FormatTime(, "HH:mm:ss")
        itemName := LV.GetText(Item, 1)
        eventLog .= timestamp " - FOCUSED: Row " Item " (" itemName ")`n"
        logEdit.Value := eventLog
    }

    MyGui.Add("Button", "w200", "Clear Log").OnEvent("Click", (*) => (eventLog := "", logEdit.Value := ""))

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 6: Selection-Based Actions
; ============================================================================
Example6_SelectionActions() {
    MyGui := Gui("+Resize", "Example 6: Selection-Based Actions")

    LV := MyGui.Add("ListView", "r12 w750", ["Task", "Status", "Priority", "Assignee"])

    tasks := [
    ["Update Documentation", "Pending", "Low", "Alice"],
    ["Fix Login Bug", "In Progress", "Critical", "Bob"],
    ["Add Dark Mode", "Pending", "Medium", "Charlie"],
    ["Optimize Database", "Completed", "High", "Diana"],
    ["Write Tests", "Pending", "Medium", "Edward"],
    ["Code Review", "In Progress", "High", "Fiona"],
    ["Deploy to Staging", "Pending", "High", "George"],
    ["Update Dependencies", "Completed", "Low", "Hannah"]
    ]

    for task in tasks {
        LV.Add(, task*)
    }

    LV.ModifyCol()

    ; Action buttons (enabled/disabled based on selection)
    MyGui.Add("Text", "w750", "Actions on Selected Tasks:")
    btnMarkComplete := MyGui.Add("Button", "w170 Disabled", "Mark Complete")
    btnSetPriority := MyGui.Add("Button", "w170 Disabled", "Set High Priority")
    btnReassign := MyGui.Add("Button", "w170 Disabled", "Reassign Task")
    btnDelete := MyGui.Add("Button", "w170 Disabled", "Delete Tasks")

    btnMarkComplete.OnEvent("Click", MarkComplete)
    btnSetPriority.OnEvent("Click", SetPriority)
    btnReassign.OnEvent("Click", ReassignTask)
    btnDelete.OnEvent("Click", DeleteTasks)

    statusText := MyGui.Add("Text", "w750", "Select one or more tasks to enable actions")

    ; Update button states on selection change
    LV.OnEvent("ItemSelect", UpdateButtons)

    UpdateButtons(*) {
        count := LV.GetCount("Selected")

        if count > 0 {
            btnMarkComplete.Enabled := true
            btnSetPriority.Enabled := true
            btnReassign.Enabled := true
            btnDelete.Enabled := true
            statusText.Value := count " task(s) selected"
        } else {
            btnMarkComplete.Enabled := false
            btnSetPriority.Enabled := false
            btnReassign.Enabled := false
            btnDelete.Enabled := false
            statusText.Value := "Select one or more tasks to enable actions"
        }
    }

    MarkComplete(*) {
        rowNum := 0
        count := 0

        Loop {
            rowNum := LV.GetNext(rowNum)
            if !rowNum
            break

            LV.Modify(rowNum, , , "Completed")
            count++
        }

        MsgBox("Marked " count " task(s) as completed!")
    }

    SetPriority(*) {
        rowNum := 0
        count := 0

        Loop {
            rowNum := LV.GetNext(rowNum)
            if !rowNum
            break

            LV.Modify(rowNum, , , , "Critical")
            count++
        }

        MsgBox("Set priority to Critical for " count " task(s)!")
    }

    ReassignTask(*) {
        newAssignee := InputBox("Reassign selected tasks to:", "Reassign Tasks", "w300 h100")
        if newAssignee.Result = "Cancel"
        return

        rowNum := 0
        count := 0

        Loop {
            rowNum := LV.GetNext(rowNum)
            if !rowNum
            break

            LV.Modify(rowNum, , , , , newAssignee.Value)
            count++
        }

        MsgBox("Reassigned " count " task(s) to " newAssignee.Value "!")
    }

    DeleteTasks(*) {
        count := LV.GetCount("Selected")
        result := MsgBox("Delete " count " selected task(s)?", "Confirm Delete", "YesNo Icon!")

        if result = "No"
        return

        ; Delete in reverse order to maintain row numbers
        Loop LV.GetCount() {
            rowNum := LV.GetCount() - A_Index + 1
            if LV.GetNext(rowNum - 1) = rowNum
            LV.Delete(rowNum)
        }

        MsgBox(count " task(s) deleted!")
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 7: Advanced Selection Techniques
; ============================================================================
Example7_AdvancedSelection() {
    MyGui := Gui("+Resize", "Example 7: Advanced Selection Techniques")

    LV := MyGui.Add("ListView", "r14 w750", ["ID", "Name", "Score", "Grade", "Status"])

    ; Generate test data
    Loop 20 {
        id := Format("{:03}", A_Index)
        name := "Student " A_Index
        score := Random(50, 100)
        grade := (score >= 90) ? "A" : (score >= 80) ? "B" : (score >= 70) ? "C" : (score >= 60) ? "D" : "F"
        status := (score >= 70) ? "Pass" : "Fail"
        LV.Add(, id, name, score, grade, status)
    }

    LV.ModifyCol()

    ; Advanced selection operations
    MyGui.Add("Text", "w750", "Advanced Selection Operations:")
    MyGui.Add("Button", "w200", "Select by Score >80").OnEvent("Click", SelectHighScores)
    MyGui.Add("Button", "w200", "Select Failing Students").OnEvent("Click", SelectFailing)
    MyGui.Add("Button", "w200", "Select Every 3rd Row").OnEvent("Click", SelectEvery3rd)
    MyGui.Add("Button", "w200", "Random Selection (5)").OnEvent("Click", SelectRandom)
    MyGui.Add("Button", "w200", "Select Visible Rows").OnEvent("Click", SelectVisible)
    MyGui.Add("Button", "w200", "Expand Selection").OnEvent("Click", ExpandSelection)

    statusEdit := MyGui.Add("Edit", "r4 w750 ReadOnly")

    SelectHighScores(*) {
        LV.Modify(0, "-Select")  ; Deselect all
        count := 0

        Loop LV.GetCount() {
            score := Number(LV.GetText(A_Index, 3))
            if score > 80 {
                LV.Modify(A_Index, "Select")
                count++
            }
        }

        statusEdit.Value := "Selected " count " students with score > 80"
    }

    SelectFailing(*) {
        LV.Modify(0, "-Select")
        count := 0

        Loop LV.GetCount() {
            if LV.GetText(A_Index, 5) = "Fail" {
                LV.Modify(A_Index, "Select")
                count++
            }
        }

        statusEdit.Value := "Selected " count " failing students"
    }

    SelectEvery3rd(*) {
        LV.Modify(0, "-Select")
        count := 0

        Loop LV.GetCount() {
            if Mod(A_Index, 3) = 0 {
                LV.Modify(A_Index, "Select")
                count++
            }
        }

        statusEdit.Value := "Selected every 3rd row (" count " total)"
    }

    SelectRandom(*) {
        LV.Modify(0, "-Select")
        selected := Map()

        ; Select 5 random rows
        Loop 5 {
            Loop {
                randomRow := Random(1, LV.GetCount())
                if !selected.Has(randomRow) {
                    selected[randomRow] := true
                    LV.Modify(randomRow, "Select")
                    break
                }
            }
        }

        statusEdit.Value := "Selected 5 random rows"
    }

    SelectVisible(*) {
        ; In a real app, this would select only visible rows after filtering
        ; For this demo, select first 10
        LV.Modify(0, "-Select")
        Loop 10 {
            LV.Modify(A_Index, "Select")
        }

        statusEdit.Value := "Selected first 10 (visible) rows"
    }

    ExpandSelection(*) {
        ; Expand current selection by 1 row above and below each selected item
        selectedRows := []
        rowNum := 0

        ; Collect currently selected rows
        Loop {
            rowNum := LV.GetNext(rowNum)
            if !rowNum
            break
            selectedRows.Push(rowNum)
        }

        ; Expand selection
        for row in selectedRows {
            if row > 1
            LV.Modify(row - 1, "Select")
            if row < LV.GetCount()
            LV.Modify(row + 1, "Select")
        }

        newCount := LV.GetCount("Selected")
        statusEdit.Value := "Expanded selection from " selectedRows.Length " to " newCount " rows"
    }

    MyGui.Show()
}

; ============================================================================
; Helper Functions
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
MainMenu := Gui(, "ListView Selection Handling Examples")
MainMenu.Add("Text", "w400", "Select an example to run:")
MainMenu.Add("Button", "w400", "Example 1: Selection Modes").OnEvent("Click", (*) => Example1_SelectionModes())
MainMenu.Add("Button", "w400", "Example 2: Getting Selection").OnEvent("Click", (*) => Example2_GettingSelection())
MainMenu.Add("Button", "w400", "Example 3: Programmatic Selection").OnEvent("Click", (*) => Example3_ProgrammaticSelection())
MainMenu.Add("Button", "w400", "Example 4: Focus vs Selection").OnEvent("Click", (*) => Example4_FocusVsSelection())
MainMenu.Add("Button", "w400", "Example 5: Selection Events").OnEvent("Click", (*) => Example5_SelectionEvents())
MainMenu.Add("Button", "w400", "Example 6: Selection-Based Actions").OnEvent("Click", (*) => Example6_SelectionActions())
MainMenu.Add("Button", "w400", "Example 7: Advanced Selection").OnEvent("Click", (*) => Example7_AdvancedSelection())
MainMenu.Show()

; ============================================================================
; REFERENCE SECTION
; ============================================================================
/*
SELECTION METHODS:
-----------------
LV.GetNext([StartRow, RowType])          - Get next selected/focused row
LV.Modify(Row, "Select")                 - Select row
LV.Modify(Row, "-Select")                - Deselect row
LV.Modify(0, "-Select")                  - Deselect all rows
LV.GetCount("Selected")                  - Count selected rows

SELECTION OPTIONS:
-----------------
"Multi" (default)    - Allow multiple selection
"-Multi"             - Single selection only
"Select"             - Select the row
"-Select"            - Deselect the row

FOCUS OPTIONS:
-------------
"Focus"              - Give keyboard focus
"-Focus"             - Remove focus
LV.GetNext(0, "Focused")  - Get focused row

COMMON PATTERNS:
---------------
; Loop through all selected items
rowNum := 0
Loop {
    rowNum := LV.GetNext(rowNum)
    if !rowNum
    break
    ; Process row
}

; Select all items
Loop LV.GetCount() {
    LV.Modify(A_Index, "Select")
}

; Deselect all items
LV.Modify(0, "-Select")

; Delete selected items (reverse order!)
Loop LV.GetCount() {
    rowNum := LV.GetCount() - A_Index + 1
    if LV.GetNext(rowNum - 1) = rowNum
    LV.Delete(rowNum)
}

EVENTS:
------
ItemSelect(LV, Item, Selected)   - Fired when selection changes
ItemFocus(LV, Item)               - Fired when focus changes

BEST PRACTICES:
--------------
1. Always use GetNext() in a loop for multiple selections
2. Delete items in reverse order to maintain indices
3. Check GetCount("Selected") before operations
4. Use Modify(0, "-Select") to deselect all efficiently
5. Remember: Selection != Focus
6. Handle ItemSelect events for real-time updates
7. Store row numbers before deletion if needed later
*/
