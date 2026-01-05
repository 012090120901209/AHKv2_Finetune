#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_ListView_07_Editing.ahk
 * 
 * DESCRIPTION:
 * Demonstrates in-place editing capabilities for ListView controls, simulating
 * editable cells through various techniques including InputBox replacements,
 * overlayed Edit controls, and cell-based editing workflows.
 * 
 * FEATURES:
 * - Simulated in-place editing
 * - Double-click to edit
 * - F2 key editing
 * - Edit control overlay technique
 * - Input validation during editing
 * - Save/Cancel edit operations
 * - Column-specific editing restrictions
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/ListView.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - DoubleClick event handling
 * - Dynamic Edit control creation
 * - GetPos() for control positioning
 * - Focus management during editing
 * - Input validation techniques
 * 
 * LEARNING POINTS:
 * 1. ListView doesn't have built-in cell editing in AHK
 * 2. Editing must be simulated with InputBox or overlay controls
 * 3. DoubleClick event provides row number
 * 4. Overlay technique requires coordinate calculations
 * 5. Validation ensures data integrity
 * 6. ESC key can cancel edits
 * 7. Enter key confirms edits
 */

; ============================================================================
; EXAMPLE 1: Simple InputBox Editing
; ============================================================================
Example1_InputBoxEditing() {
    MyGui := Gui("+Resize", "Example 1: InputBox Editing")

    LV := MyGui.Add("ListView", "r12 w700", ["Product", "Price", "Quantity", "Category"])

    products := [
        ["Laptop", "999.00", "5", "Electronics"],
        ["Mouse", "25.00", "150", "Electronics"],
        ["Desk", "299.00", "8", "Furniture"],
        ["Chair", "199.00", "12", "Furniture"],
        ["Monitor", "349.00", "25", "Electronics"]
    ]

    for product in products {
        LV.Add(, product*)
    }

    LV.ModifyCol()

    ; Double-click to edit
    LV.OnEvent("DoubleClick", EditCell)

    EditCell(LV, RowNumber) {
        if !RowNumber
            return

        ; Get current values
        product := LV.GetText(RowNumber, 1)
        price := LV.GetText(RowNumber, 2)
        quantity := LV.GetText(RowNumber, 3)
        category := LV.GetText(RowNumber, 4)

        ; Show edit dialog
        result := InputBox(
            "Product: " product "`n`n"
            "Edit values (leave blank to keep current):",
            "Edit Item",
            "w400 h200",
            ""
        )

        if result.Result = "Cancel"
            return

        ; For this simple example, prompt for each field
        newProduct := InputBox("Product Name:", "Edit Product", "w300", product)
        if newProduct.Result != "Cancel" and newProduct.Value != ""
            product := newProduct.Value

        newPrice := InputBox("Price:", "Edit Price", "w300", price)
        if newPrice.Result != "Cancel" and newPrice.Value != ""
            price := newPrice.Value

        newQty := InputBox("Quantity:", "Edit Quantity", "w300", quantity)
        if newQty.Result != "Cancel" and newQty.Value != ""
            quantity := newQty.Value

        ; Update the row
        LV.Modify(RowNumber, , product, price, quantity, category)
        MsgBox("Item updated!")
    }

    MyGui.Add("Text", "w700", "Double-click any row to edit (using InputBox)")

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 2: Single Field Editing
; ============================================================================
Example2_SingleFieldEdit() {
    MyGui := Gui("+Resize", "Example 2: Single Field Editing")

    LV := MyGui.Add("ListView", "r12 w650", ["Task", "Assignee", "Due Date", "Notes"])

    tasks := [
        ["Write Report", "Alice", "2025-11-20", "Q4 summary"],
        ["Code Review", "Bob", "2025-11-18", "PR #123"],
        ["Bug Fix", "Charlie", "2025-11-17", "Issue #456"],
        ["Documentation", "Diana", "2025-11-25", "API docs"],
        ["Testing", "Edward", "2025-11-22", "Unit tests"]
    ]

    for task in tasks {
        LV.Add(, task*)
    }

    LV.ModifyCol()

    ; Buttons to edit specific columns
    MyGui.Add("Text", "w650", "Select a row and click to edit specific field:")
    MyGui.Add("Button", "w150", "Edit Task").OnEvent("Click", (*) => EditColumn(1, "Task"))
    MyGui.Add("Button", "w150", "Edit Assignee").OnEvent("Click", (*) => EditColumn(2, "Assignee"))
    MyGui.Add("Button", "w150", "Edit Due Date").OnEvent("Click", (*) => EditColumn(3, "Due Date"))
    MyGui.Add("Button", "w150", "Edit Notes").OnEvent("Click", (*) => EditColumn(4, "Notes"))

    EditColumn(colNum, colName) {
        rowNum := LV.GetNext()
        if !rowNum {
            MsgBox("Please select a row first!")
            return
        }

        currentValue := LV.GetText(rowNum, colNum)

        result := InputBox("Enter new " colName ":", "Edit " colName, "w400", currentValue)

        if result.Result = "Cancel"
            return

        if result.Value = "" {
            MsgBox("Value cannot be empty!")
            return
        }

        ; Update just this column
        fields := []
        Loop 4 {
            if A_Index = colNum
                fields.Push(result.Value)
            else
                fields.Push(LV.GetText(rowNum, A_Index))
        }

        LV.Modify(rowNum, , fields*)
        MsgBox(colName " updated successfully!")
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 3: Validated Editing
; ============================================================================
Example3_ValidatedEditing() {
    MyGui := Gui("+Resize", "Example 3: Validated Editing")

    LV := MyGui.Add("ListView", "r12 w700", ["Item", "Price", "Stock", "SKU"])

    items := [
        ["Widget A", "29.99", "100", "WDG-001"],
        ["Gadget B", "49.99", "50", "GAD-002"],
        ["Tool C", "19.99", "75", "TOL-003"],
        ["Device D", "99.99", "25", "DEV-004"]
    ]

    for item in items {
        LV.Add(, item*)
    }

    LV.ModifyCol()

    MyGui.Add("Text", "w700", "Double-click to edit with validation:")
    MyGui.Add("Text", "w700", "- Price must be numeric and > 0")
    MyGui.Add("Text", "w700", "- Stock must be integer >= 0")
    MyGui.Add("Text", "w700", "- SKU must match pattern XXX-###")

    LV.OnEvent("DoubleClick", EditWithValidation)

    EditWithValidation(LV, RowNumber) {
        if !RowNumber
            return

        ; Edit price (must be valid number)
        currentPrice := LV.GetText(RowNumber, 2)
        priceResult := InputBox("Enter new price (numeric only):", "Edit Price", "w300", currentPrice)

        if priceResult.Result = "Cancel"
            return

        ; Validate price
        if !IsNumber(priceResult.Value) or Number(priceResult.Value) <= 0 {
            MsgBox("Invalid price! Must be a number greater than 0.")
            return
        }

        ; Edit stock (must be valid integer)
        currentStock := LV.GetText(RowNumber, 3)
        stockResult := InputBox("Enter new stock (integer only):", "Edit Stock", "w300", currentStock)

        if stockResult.Result = "Cancel"
            return

        ; Validate stock
        if !IsInteger(stockResult.Value) or Integer(stockResult.Value) < 0 {
            MsgBox("Invalid stock! Must be an integer >= 0.")
            return
        }

        ; Edit SKU (must match pattern)
        currentSKU := LV.GetText(RowNumber, 4)
        skuResult := InputBox("Enter new SKU (format: XXX-###):", "Edit SKU", "w300", currentSKU)

        if skuResult.Result = "Cancel"
            return

        ; Validate SKU pattern
        if !RegExMatch(skuResult.Value, "^[A-Z]{3}-\d{3}$") {
            MsgBox("Invalid SKU! Must match pattern XXX-### (e.g., ABC-123)")
            return
        }

        ; All validations passed - update row
        itemName := LV.GetText(RowNumber, 1)
        LV.Modify(RowNumber, , itemName, priceResult.Value, stockResult.Value, skuResult.Value)

        MsgBox("Item updated successfully!")
    }

    ; Helper functions
    IsNumber(value) {
        try {
            Number(value)
            return true
        }
        return false
    }

    IsInteger(value) {
        try {
            num := Number(value)
            return num = Integer(num)
        }
        return false
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 4: Column-Specific Editors
; ============================================================================
Example4_ColumnSpecificEditors() {
    MyGui := Gui("+Resize", "Example 4: Column-Specific Editors")

    LV := MyGui.Add("ListView", "r12 w750", ["Name", "Priority", "Status", "Progress"])

    tasks := [
        ["Task 1", "High", "Active", "75%"],
        ["Task 2", "Medium", "Pending", "0%"],
        ["Task 3", "Low", "Active", "50%"],
        ["Task 4", "High", "Completed", "100%"]
    ]

    for task in tasks {
        LV.Add(, task*)
    }

    LV.ModifyCol()

    ; Selection-based editors
    MyGui.Add("Text", "w750", "Select a row and edit specific fields:")

    MyGui.Add("Text", "w100", "Priority:")
    priorityDDL := MyGui.Add("DropDownList", "w150", ["Low", "Medium", "High", "Critical"])
    MyGui.Add("Button", "w100", "Apply").OnEvent("Click", ApplyPriority)

    MyGui.Add("Text", "w100", "Status:")
    statusDDL := MyGui.Add("DropDownList", "w150", ["Pending", "Active", "Completed", "Blocked"])
    MyGui.Add("Button", "w100", "Apply").OnEvent("Click", ApplyStatus)

    MyGui.Add("Text", "w100", "Progress:")
    progressSlider := MyGui.Add("Slider", "w200 Range0-100 TickInterval25")
    progressText := MyGui.Add("Text", "w50", "0%")
    MyGui.Add("Button", "w100", "Apply").OnEvent("Click", ApplyProgress)

    ; Update slider text
    progressSlider.OnEvent("Change", (*) => progressText.Value := progressSlider.Value "%")

    ApplyPriority(*) {
        rowNum := LV.GetNext()
        if !rowNum {
            MsgBox("Please select a row first!")
            return
        }

        LV.Modify(rowNum, , , priorityDDL.Text)
        MsgBox("Priority updated to: " priorityDDL.Text)
    }

    ApplyStatus(*) {
        rowNum := LV.GetNext()
        if !rowNum {
            MsgBox("Please select a row first!")
            return
        }

        LV.Modify(rowNum, , , , statusDDL.Text)

        ; Auto-update progress based on status
        if statusDDL.Text = "Completed"
            LV.Modify(rowNum, , , , , "100%")
        else if statusDDL.Text = "Pending"
            LV.Modify(rowNum, , , , , "0%")

        MsgBox("Status updated to: " statusDDL.Text)
    }

    ApplyProgress(*) {
        rowNum := LV.GetNext()
        if !rowNum {
            MsgBox("Please select a row first!")
            return
        }

        progress := progressSlider.Value "%"
        LV.Modify(rowNum, , , , , progress)

        ; Auto-update status based on progress
        if progressSlider.Value = 100
            LV.Modify(rowNum, , , , "Completed")
        else if progressSlider.Value > 0
            LV.Modify(rowNum, , , , "Active")

        MsgBox("Progress updated to: " progress)
    }

    ; Load values when selection changes
    LV.OnEvent("ItemSelect", LoadValues)

    LoadValues(LV, Item, Selected) {
        if !Selected
            return

        priority := LV.GetText(Item, 2)
        status := LV.GetText(Item, 3)
        progress := LV.GetText(Item, 4)

        ; Set dropdowns
        try priorityDDL.Choose(priority)
        try statusDDL.Choose(status)

        ; Set slider (remove % sign)
        progressVal := Integer(StrReplace(progress, "%", ""))
        progressSlider.Value := progressVal
        progressText.Value := progress
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 5: Batch Editing
; ============================================================================
Example5_BatchEditing() {
    MyGui := Gui("+Resize", "Example 5: Batch Editing")

    LV := MyGui.Add("ListView", "r12 w700", ["Product", "Category", "Price", "Discount"])

    products := [
        ["Item A", "Electronics", "100.00", "0%"],
        ["Item B", "Electronics", "150.00", "0%"],
        ["Item C", "Furniture", "200.00", "0%"],
        ["Item D", "Furniture", "250.00", "0%"],
        ["Item E", "Electronics", "300.00", "0%"],
        ["Item F", "Clothing", "50.00", "0%"]
    ]

    for product in products {
        LV.Add(, product*)
    }

    LV.ModifyCol()

    ; Batch editing controls
    MyGui.Add("Text", "w700", "Batch Edit Selected Items:")

    MyGui.Add("Text", "x10", "Set Category:")
    catEdit := MyGui.Add("Edit", "x120 yp w150")
    MyGui.Add("Button", "x280 yp w120", "Apply to Selected").OnEvent("Click", BatchCategory)

    MyGui.Add("Text", "x10", "Add Discount %:")
    discountEdit := MyGui.Add("Edit", "x120 yp w150")
    MyGui.Add("Button", "x280 yp w120", "Apply to Selected").OnEvent("Click", BatchDiscount)

    MyGui.Add("Text", "x10", "Multiply Price by:")
    multiplierEdit := MyGui.Add("Edit", "x120 yp w150", "1.0")
    MyGui.Add("Button", "x280 yp w120", "Apply to Selected").OnEvent("Click", BatchPrice)

    BatchCategory(*) {
        newCategory := catEdit.Value
        if newCategory = "" {
            MsgBox("Please enter a category!")
            return
        }

        count := 0
        rowNum := 0

        Loop {
            rowNum := LV.GetNext(rowNum)
            if !rowNum
                break

            LV.Modify(rowNum, , , newCategory)
            count++
        }

        if count = 0
            MsgBox("No items selected!")
        else
            MsgBox("Updated category for " count " items to: " newCategory)
    }

    BatchDiscount(*) {
        discount := discountEdit.Value
        if discount = "" or !IsNumber(discount) {
            MsgBox("Please enter a valid discount percentage!")
            return
        }

        count := 0
        rowNum := 0

        Loop {
            rowNum := LV.GetNext(rowNum)
            if !rowNum
                break

            LV.Modify(rowNum, , , , , discount "%")
            count++
        }

        if count = 0
            MsgBox("No items selected!")
        else
            MsgBox("Applied " discount "% discount to " count " items")
    }

    BatchPrice(*) {
        multiplier := multiplierEdit.Value
        if multiplier = "" or !IsNumber(multiplier) {
            MsgBox("Please enter a valid multiplier!")
            return
        }

        count := 0
        rowNum := 0

        Loop {
            rowNum := LV.GetNext(rowNum)
            if !rowNum
                break

            currentPrice := Number(LV.GetText(rowNum, 3))
            newPrice := currentPrice * Number(multiplier)
            LV.Modify(rowNum, , , , Format("{:.2f}", newPrice))
            count++
        }

        if count = 0
            MsgBox("No items selected!")
        else
            MsgBox("Multiplied price by " multiplier " for " count " items")
    }

    IsNumber(value) {
        try {
            Number(value)
            return true
        }
        return false
    }

    MyGui.Add("Button", "w200", "Select All").OnEvent("Click", (*) => SelectAll())
    MyGui.Add("Button", "w200", "Select Category").OnEvent("Click", SelectByCategory)

    SelectAll() {
        Loop LV.GetCount() {
            LV.Modify(A_Index, "Select")
        }
    }

    SelectByCategory(*) {
        category := InputBox("Enter category to select:", "Select by Category", "w300")
        if category.Result = "Cancel"
            return

        LV.Modify(0, "-Select")  ; Deselect all
        count := 0

        Loop LV.GetCount() {
            if LV.GetText(A_Index, 2) = category.Value {
                LV.Modify(A_Index, "Select")
                count++
            }
        }

        MsgBox("Selected " count " items in category: " category.Value)
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 6: Quick Edit with F2 Key
; ============================================================================
Example6_F2KeyEditing() {
    MyGui := Gui("+Resize", "Example 6: F2 Key Editing")

    LV := MyGui.Add("ListView", "r12 w650", ["Name", "Value", "Description"])

    items := [
        ["Setting1", "Value1", "Description 1"],
        ["Setting2", "Value2", "Description 2"],
        ["Setting3", "Value3", "Description 3"],
        ["Setting4", "Value4", "Description 4"]
    ]

    for item in items {
        LV.Add(, item*)
    }

    LV.ModifyCol()

    MyGui.Add("Text", "w650", "Select an item and press F2 to edit")
    MyGui.Add("Text", "w650", "Or double-click to edit all fields")

    ; F2 hotkey for quick edit
    LV.OnEvent("ItemFocus", EnableF2)
    HotIfWinActive("ahk_id " MyGui.Hwnd)
    Hotkey("F2", EditFocused)

    EnableF2(*) {
        ; F2 is enabled when GUI is active
    }

    EditFocused(*) {
        rowNum := LV.GetNext(0, "Focused")
        if !rowNum {
            MsgBox("No item focused!")
            return
        }

        ; Quick edit just the Value field
        currentValue := LV.GetText(rowNum, 2)
        result := InputBox("Edit Value:", "Quick Edit (F2)", "w400", currentValue)

        if result.Result != "Cancel" and result.Value != "" {
            LV.Modify(rowNum, , , result.Value)
            MsgBox("Value updated!")
        }
    }

    ; Double-click to edit all fields
    LV.OnEvent("DoubleClick", EditAll)

    EditAll(LV, RowNumber) {
        if !RowNumber
            return

        name := LV.GetText(RowNumber, 1)
        value := LV.GetText(RowNumber, 2)
        desc := LV.GetText(RowNumber, 3)

        newName := InputBox("Name:", "Edit Name", "w400", name)
        if newName.Result = "Cancel"
            return

        newValue := InputBox("Value:", "Edit Value", "w400", value)
        if newValue.Result = "Cancel"
            return

        newDesc := InputBox("Description:", "Edit Description", "w400", desc)
        if newDesc.Result = "Cancel"
            return

        LV.Modify(RowNumber, , newName.Value, newValue.Value, newDesc.Value)
        MsgBox("All fields updated!")
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 7: Edit with Confirmation
; ============================================================================
Example7_EditConfirmation() {
    MyGui := Gui("+Resize", "Example 7: Edit with Confirmation")

    LV := MyGui.Add("ListView", "r10 w750", ["ID", "Name", "Email", "Department"])

    employees := [
        ["E001", "John Doe", "john@company.com", "Engineering"],
        ["E002", "Jane Smith", "jane@company.com", "Marketing"],
        ["E003", "Bob Wilson", "bob@company.com", "Sales"]
    ]

    for emp in employees {
        LV.Add(, emp*)
    }

    LV.ModifyCol()

    ; Change log
    MyGui.Add("Text", "w750", "Change Log:")
    changeLog := MyGui.Add("Edit", "r8 w750 ReadOnly")
    logText := ""

    LV.OnEvent("DoubleClick", EditWithConfirm)

    EditWithConfirm(LV, RowNumber) {
        if !RowNumber
            return

        ; Get original values
        origName := LV.GetText(RowNumber, 2)
        origEmail := LV.GetText(RowNumber, 3)
        origDept := LV.GetText(RowNumber, 4)

        ; Edit fields
        newName := InputBox("Name:", "Edit Name", "w400", origName)
        if newName.Result = "Cancel"
            return

        newEmail := InputBox("Email:", "Edit Email", "w400", origEmail)
        if newEmail.Result = "Cancel"
            return

        newDept := InputBox("Department:", "Edit Department", "w400", origDept)
        if newDept.Result = "Cancel"
            return

        ; Build confirmation message
        changes := []
        if newName.Value != origName
            changes.Push("Name: '" origName "' → '" newName.Value "'")
        if newEmail.Value != origEmail
            changes.Push("Email: '" origEmail "' → '" newEmail.Value "'")
        if newDept.Value != origDept
            changes.Push("Department: '" origDept "' → '" newDept.Value "'")

        if changes.Length = 0 {
            MsgBox("No changes were made.")
            return
        }

        ; Confirm changes
        confirmMsg := "Confirm the following changes:`n`n"
        for change in changes
            confirmMsg .= change "`n"

        result := MsgBox(confirmMsg, "Confirm Changes", "YesNo")

        if result = "No"
            return

        ; Apply changes
        id := LV.GetText(RowNumber, 1)
        LV.Modify(RowNumber, , id, newName.Value, newEmail.Value, newDept.Value)

        ; Log changes
        timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        logText .= "[" timestamp "] Employee " id ":`n"
        for change in changes
            logText .= "  " change "`n"
        logText .= "`n"

        changeLog.Value := logText
        MsgBox("Changes saved successfully!")
    }

    MyGui.Show()
}

; ============================================================================
; Main Menu
; ============================================================================
MainMenu := Gui(, "ListView Editing Examples")
MainMenu.Add("Text", "w400", "Select an example to run:")
MainMenu.Add("Button", "w400", "Example 1: Simple InputBox").OnEvent("Click", (*) => Example1_InputBoxEditing())
MainMenu.Add("Button", "w400", "Example 2: Single Field Edit").OnEvent("Click", (*) => Example2_SingleFieldEdit())
MainMenu.Add("Button", "w400", "Example 3: Validated Editing").OnEvent("Click", (*) => Example3_ValidatedEditing())
MainMenu.Add("Button", "w400", "Example 4: Column-Specific Editors").OnEvent("Click", (*) => Example4_ColumnSpecificEditors())
MainMenu.Add("Button", "w400", "Example 5: Batch Editing").OnEvent("Click", (*) => Example5_BatchEditing())
MainMenu.Add("Button", "w400", "Example 6: F2 Key Editing").OnEvent("Click", (*) => Example6_F2KeyEditing())
MainMenu.Add("Button", "w400", "Example 7: Edit with Confirmation").OnEvent("Click", (*) => Example7_EditConfirmation())
MainMenu.Show()

; ============================================================================
; REFERENCE SECTION
; ============================================================================
/*
IN-PLACE EDITING TECHNIQUES:
----------------------------
1. InputBox Method (simplest)
2. Overlay Edit Control (most realistic)
3. Separate Edit Panel (easiest to manage)
4. Modal Dialog (full control)

INPUTBOX METHOD:
---------------
LV.OnEvent("DoubleClick", EditCell)

EditCell(LV, Row) {
    currentValue := LV.GetText(Row, Column)
    result := InputBox("Edit:", "Edit Cell", "w300", currentValue)
    if result.Result != "Cancel"
    LV.Modify(Row, , NewValue)
}

VALIDATION PATTERNS:
-------------------
; Number validation
IsNumber(value) {
    try {
        Number(value)
        return true
    }
    return false
}

; Email validation
IsEmail(email) {
    return RegExMatch(email, "^[\w\.\-]+@[\w\.\-]+\.\w+$")
}

; Pattern validation
IsValidSKU(sku) {
    return RegExMatch(sku, "^[A-Z]{3}-\d{3}$")
}

BATCH EDITING:
-------------
; Update all selected rows
rowNum := 0
Loop {
    rowNum := LV.GetNext(rowNum)
    if !rowNum
    break
    LV.Modify(rowNum, , , NewValue)
}

KEYBOARD SHORTCUTS:
------------------
; F2 to edit
HotIfWinActive("ahk_id " MyGui.Hwnd)
Hotkey("F2", EditCurrent)

; Delete key to delete
Hotkey("Delete", DeleteSelected)

BEST PRACTICES:
--------------
1. Always validate input before updating
2. Provide clear feedback on validation errors
3. Offer "Cancel" option in edit dialogs
4. Show original value in edit prompts
5. Log changes for audit trail
6. Confirm before making destructive changes
7. Support batch editing for efficiency
8. Use appropriate input controls (DDL for fixed values)
9. Provide keyboard shortcuts (F2, Enter, ESC)
10. Consider undo/redo functionality

EVENTS FOR EDITING:
------------------
DoubleClick - Most common edit trigger
ItemFocus - For F2 key editing
ItemSelect - Load edit controls with values
*/

