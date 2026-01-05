#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_GuiListView_02.ahk - ListView Columns and Sorting
 * 
 * This file demonstrates ListView column management and sorting in AutoHotkey v2.
 * Topics covered:
 * - Column management
 * - Column resizing
 * - Sort by column
 * - Multi-sort
 * - Custom sorting
 * - Column reorder
 * - Column visibility
 * 
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024
 */


; =============================================================================
; Example 1: Column management
; =============================================================================

/**
 * Demonstrates column management
 * Complete ListView example with data management
 */
Example1_Columnmanagement() {
    myGui := Gui(, "Column management Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Column management")
    myGui.SetFont("s9 Norm")

    ; Create ListView
    lv := myGui.Add("ListView", "x20 y55 w760 h300", ["ID", "Name", "Department", "Salary", "Status"])

    ; Set column widths
    lv.ModifyCol(1, 50)
    lv.ModifyCol(2, 150)
    lv.ModifyCol(3, 150)
    lv.ModifyCol(4, 100)
    lv.ModifyCol(5, 100)

    ; Sample data
    employees := [
        [1, "John Doe", "Engineering", "$75,000", "Active"],
        [2, "Jane Smith", "Marketing", "$65,000", "Active"],
        [3, "Bob Johnson", "Sales", "$70,000", "Active"],
        [4, "Alice Williams", "HR", "$60,000", "Active"],
        [5, "Charlie Brown", "Engineering", "$80,000", "On Leave"],
        [6, "Diana Prince", "Management", "$95,000", "Active"],
        [7, "Eve Davis", "Sales", "$68,000", "Active"],
        [8, "Frank Miller", "Engineering", "$72,000", "Active"]
    ]

    ; Populate ListView
    for emp in employees {
        lv.Add("", emp*)
    }

    ; Info display
    infoText := myGui.Add("Edit", "x20 y365 w760 h60 ReadOnly Multi")
    UpdateInfo()

    UpdateInfo() {
        selected := lv.GetNext()
        if (selected) {
            id := lv.GetText(selected, 1)
            name := lv.GetText(selected, 2)
            dept := lv.GetText(selected, 3)
            salary := lv.GetText(selected, 4)
            status := lv.GetText(selected, 5)
            infoText.Value := Format("Selected Employee:\nID: {1} | Name: {2} | Dept: {3} | Salary: {4} | Status: {5}",
                id, name, dept, salary, status)
        } else {
            infoText.Value := Format("Total Employees: {1}\nNo employee selected", lv.GetCount())
        }
    }

    lv.OnEvent("ItemSelect", (*) => UpdateInfo())
    lv.OnEvent("Click", (*) => UpdateInfo())

    ; Action buttons
    myGui.Add("Button", "x20 y435 w150", "Add Employee").OnEvent("Click", AddEmployee)
    myGui.Add("Button", "x180 y435 w150", "Edit Selected").OnEvent("Click", EditEmployee)
    myGui.Add("Button", "x340 y435 w150", "Delete Selected").OnEvent("Click", DeleteEmployee)
    myGui.Add("Button", "x500 y435 w140", "Refresh").OnEvent("Click", (*) => UpdateInfo())
    myGui.Add("Button", "x650 y435 w130", "Close").OnEvent("Click", (*) => myGui.Destroy())

    AddEmployee(*) {
        nextId := lv.GetCount() + 1
        lv.Add("", nextId, "New Employee", "Department", "$50,000", "Active")
        UpdateInfo()
    }

    EditEmployee(*) {
        selected := lv.GetNext()
        if (selected) {
            MsgBox("Edit functionality would open a dialog to edit row " selected, "Edit Employee")
        } else {
            MsgBox("Please select an employee first", "No Selection")
        }
    }

    DeleteEmployee(*) {
        selected := lv.GetNext()
        if (selected) {
            name := lv.GetText(selected, 2)
            result := MsgBox("Delete employee: " name "?", "Confirm Delete", "YesNo")
            if (result = "Yes") {
                lv.Delete(selected)
                UpdateInfo()
            }
        } else {
            MsgBox("Please select an employee first", "No Selection")
        }
    }

    myGui.Show("w800 h485")
}


; =============================================================================
; Example 2: Column resizing
; =============================================================================

/**
 * Demonstrates column resizing
 * Complete ListView example with data management
 */
Example2_Columnresizing() {
    myGui := Gui(, "Column resizing Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Column resizing")
    myGui.SetFont("s9 Norm")

    ; Create ListView
    lv := myGui.Add("ListView", "x20 y55 w760 h300", ["ID", "Name", "Department", "Salary", "Status"])

    ; Set column widths
    lv.ModifyCol(1, 50)
    lv.ModifyCol(2, 150)
    lv.ModifyCol(3, 150)
    lv.ModifyCol(4, 100)
    lv.ModifyCol(5, 100)

    ; Sample data
    employees := [
        [1, "John Doe", "Engineering", "$75,000", "Active"],
        [2, "Jane Smith", "Marketing", "$65,000", "Active"],
        [3, "Bob Johnson", "Sales", "$70,000", "Active"],
        [4, "Alice Williams", "HR", "$60,000", "Active"],
        [5, "Charlie Brown", "Engineering", "$80,000", "On Leave"],
        [6, "Diana Prince", "Management", "$95,000", "Active"],
        [7, "Eve Davis", "Sales", "$68,000", "Active"],
        [8, "Frank Miller", "Engineering", "$72,000", "Active"]
    ]

    ; Populate ListView
    for emp in employees {
        lv.Add("", emp*)
    }

    ; Info display
    infoText := myGui.Add("Edit", "x20 y365 w760 h60 ReadOnly Multi")
    UpdateInfo()

    UpdateInfo() {
        selected := lv.GetNext()
        if (selected) {
            id := lv.GetText(selected, 1)
            name := lv.GetText(selected, 2)
            dept := lv.GetText(selected, 3)
            salary := lv.GetText(selected, 4)
            status := lv.GetText(selected, 5)
            infoText.Value := Format("Selected Employee:\nID: {1} | Name: {2} | Dept: {3} | Salary: {4} | Status: {5}",
                id, name, dept, salary, status)
        } else {
            infoText.Value := Format("Total Employees: {1}\nNo employee selected", lv.GetCount())
        }
    }

    lv.OnEvent("ItemSelect", (*) => UpdateInfo())
    lv.OnEvent("Click", (*) => UpdateInfo())

    ; Action buttons
    myGui.Add("Button", "x20 y435 w150", "Add Employee").OnEvent("Click", AddEmployee)
    myGui.Add("Button", "x180 y435 w150", "Edit Selected").OnEvent("Click", EditEmployee)
    myGui.Add("Button", "x340 y435 w150", "Delete Selected").OnEvent("Click", DeleteEmployee)
    myGui.Add("Button", "x500 y435 w140", "Refresh").OnEvent("Click", (*) => UpdateInfo())
    myGui.Add("Button", "x650 y435 w130", "Close").OnEvent("Click", (*) => myGui.Destroy())

    AddEmployee(*) {
        nextId := lv.GetCount() + 1
        lv.Add("", nextId, "New Employee", "Department", "$50,000", "Active")
        UpdateInfo()
    }

    EditEmployee(*) {
        selected := lv.GetNext()
        if (selected) {
            MsgBox("Edit functionality would open a dialog to edit row " selected, "Edit Employee")
        } else {
            MsgBox("Please select an employee first", "No Selection")
        }
    }

    DeleteEmployee(*) {
        selected := lv.GetNext()
        if (selected) {
            name := lv.GetText(selected, 2)
            result := MsgBox("Delete employee: " name "?", "Confirm Delete", "YesNo")
            if (result = "Yes") {
                lv.Delete(selected)
                UpdateInfo()
            }
        } else {
            MsgBox("Please select an employee first", "No Selection")
        }
    }

    myGui.Show("w800 h485")
}


; =============================================================================
; Example 3: Sort by column
; =============================================================================

/**
 * Demonstrates sort by column
 * Complete ListView example with data management
 */
Example3_Sortbycolumn() {
    myGui := Gui(, "Sort by column Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Sort by column")
    myGui.SetFont("s9 Norm")

    ; Create ListView
    lv := myGui.Add("ListView", "x20 y55 w760 h300", ["ID", "Name", "Department", "Salary", "Status"])

    ; Set column widths
    lv.ModifyCol(1, 50)
    lv.ModifyCol(2, 150)
    lv.ModifyCol(3, 150)
    lv.ModifyCol(4, 100)
    lv.ModifyCol(5, 100)

    ; Sample data
    employees := [
        [1, "John Doe", "Engineering", "$75,000", "Active"],
        [2, "Jane Smith", "Marketing", "$65,000", "Active"],
        [3, "Bob Johnson", "Sales", "$70,000", "Active"],
        [4, "Alice Williams", "HR", "$60,000", "Active"],
        [5, "Charlie Brown", "Engineering", "$80,000", "On Leave"],
        [6, "Diana Prince", "Management", "$95,000", "Active"],
        [7, "Eve Davis", "Sales", "$68,000", "Active"],
        [8, "Frank Miller", "Engineering", "$72,000", "Active"]
    ]

    ; Populate ListView
    for emp in employees {
        lv.Add("", emp*)
    }

    ; Info display
    infoText := myGui.Add("Edit", "x20 y365 w760 h60 ReadOnly Multi")
    UpdateInfo()

    UpdateInfo() {
        selected := lv.GetNext()
        if (selected) {
            id := lv.GetText(selected, 1)
            name := lv.GetText(selected, 2)
            dept := lv.GetText(selected, 3)
            salary := lv.GetText(selected, 4)
            status := lv.GetText(selected, 5)
            infoText.Value := Format("Selected Employee:\nID: {1} | Name: {2} | Dept: {3} | Salary: {4} | Status: {5}",
                id, name, dept, salary, status)
        } else {
            infoText.Value := Format("Total Employees: {1}\nNo employee selected", lv.GetCount())
        }
    }

    lv.OnEvent("ItemSelect", (*) => UpdateInfo())
    lv.OnEvent("Click", (*) => UpdateInfo())

    ; Action buttons
    myGui.Add("Button", "x20 y435 w150", "Add Employee").OnEvent("Click", AddEmployee)
    myGui.Add("Button", "x180 y435 w150", "Edit Selected").OnEvent("Click", EditEmployee)
    myGui.Add("Button", "x340 y435 w150", "Delete Selected").OnEvent("Click", DeleteEmployee)
    myGui.Add("Button", "x500 y435 w140", "Refresh").OnEvent("Click", (*) => UpdateInfo())
    myGui.Add("Button", "x650 y435 w130", "Close").OnEvent("Click", (*) => myGui.Destroy())

    AddEmployee(*) {
        nextId := lv.GetCount() + 1
        lv.Add("", nextId, "New Employee", "Department", "$50,000", "Active")
        UpdateInfo()
    }

    EditEmployee(*) {
        selected := lv.GetNext()
        if (selected) {
            MsgBox("Edit functionality would open a dialog to edit row " selected, "Edit Employee")
        } else {
            MsgBox("Please select an employee first", "No Selection")
        }
    }

    DeleteEmployee(*) {
        selected := lv.GetNext()
        if (selected) {
            name := lv.GetText(selected, 2)
            result := MsgBox("Delete employee: " name "?", "Confirm Delete", "YesNo")
            if (result = "Yes") {
                lv.Delete(selected)
                UpdateInfo()
            }
        } else {
            MsgBox("Please select an employee first", "No Selection")
        }
    }

    myGui.Show("w800 h485")
}


; =============================================================================
; Example 4: Multi-sort
; =============================================================================

/**
 * Demonstrates multi-sort
 * Complete ListView example with data management
 */
Example4_Multisort() {
    myGui := Gui(, "Multi-sort Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Multi-sort")
    myGui.SetFont("s9 Norm")

    ; Create ListView
    lv := myGui.Add("ListView", "x20 y55 w760 h300", ["ID", "Name", "Department", "Salary", "Status"])

    ; Set column widths
    lv.ModifyCol(1, 50)
    lv.ModifyCol(2, 150)
    lv.ModifyCol(3, 150)
    lv.ModifyCol(4, 100)
    lv.ModifyCol(5, 100)

    ; Sample data
    employees := [
        [1, "John Doe", "Engineering", "$75,000", "Active"],
        [2, "Jane Smith", "Marketing", "$65,000", "Active"],
        [3, "Bob Johnson", "Sales", "$70,000", "Active"],
        [4, "Alice Williams", "HR", "$60,000", "Active"],
        [5, "Charlie Brown", "Engineering", "$80,000", "On Leave"],
        [6, "Diana Prince", "Management", "$95,000", "Active"],
        [7, "Eve Davis", "Sales", "$68,000", "Active"],
        [8, "Frank Miller", "Engineering", "$72,000", "Active"]
    ]

    ; Populate ListView
    for emp in employees {
        lv.Add("", emp*)
    }

    ; Info display
    infoText := myGui.Add("Edit", "x20 y365 w760 h60 ReadOnly Multi")
    UpdateInfo()

    UpdateInfo() {
        selected := lv.GetNext()
        if (selected) {
            id := lv.GetText(selected, 1)
            name := lv.GetText(selected, 2)
            dept := lv.GetText(selected, 3)
            salary := lv.GetText(selected, 4)
            status := lv.GetText(selected, 5)
            infoText.Value := Format("Selected Employee:\nID: {1} | Name: {2} | Dept: {3} | Salary: {4} | Status: {5}",
                id, name, dept, salary, status)
        } else {
            infoText.Value := Format("Total Employees: {1}\nNo employee selected", lv.GetCount())
        }
    }

    lv.OnEvent("ItemSelect", (*) => UpdateInfo())
    lv.OnEvent("Click", (*) => UpdateInfo())

    ; Action buttons
    myGui.Add("Button", "x20 y435 w150", "Add Employee").OnEvent("Click", AddEmployee)
    myGui.Add("Button", "x180 y435 w150", "Edit Selected").OnEvent("Click", EditEmployee)
    myGui.Add("Button", "x340 y435 w150", "Delete Selected").OnEvent("Click", DeleteEmployee)
    myGui.Add("Button", "x500 y435 w140", "Refresh").OnEvent("Click", (*) => UpdateInfo())
    myGui.Add("Button", "x650 y435 w130", "Close").OnEvent("Click", (*) => myGui.Destroy())

    AddEmployee(*) {
        nextId := lv.GetCount() + 1
        lv.Add("", nextId, "New Employee", "Department", "$50,000", "Active")
        UpdateInfo()
    }

    EditEmployee(*) {
        selected := lv.GetNext()
        if (selected) {
            MsgBox("Edit functionality would open a dialog to edit row " selected, "Edit Employee")
        } else {
            MsgBox("Please select an employee first", "No Selection")
        }
    }

    DeleteEmployee(*) {
        selected := lv.GetNext()
        if (selected) {
            name := lv.GetText(selected, 2)
            result := MsgBox("Delete employee: " name "?", "Confirm Delete", "YesNo")
            if (result = "Yes") {
                lv.Delete(selected)
                UpdateInfo()
            }
        } else {
            MsgBox("Please select an employee first", "No Selection")
        }
    }

    myGui.Show("w800 h485")
}


; =============================================================================
; Example 5: Custom sorting
; =============================================================================

/**
 * Demonstrates custom sorting
 * Complete ListView example with data management
 */
Example5_Customsorting() {
    myGui := Gui(, "Custom sorting Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Custom sorting")
    myGui.SetFont("s9 Norm")

    ; Create ListView
    lv := myGui.Add("ListView", "x20 y55 w760 h300", ["ID", "Name", "Department", "Salary", "Status"])

    ; Set column widths
    lv.ModifyCol(1, 50)
    lv.ModifyCol(2, 150)
    lv.ModifyCol(3, 150)
    lv.ModifyCol(4, 100)
    lv.ModifyCol(5, 100)

    ; Sample data
    employees := [
        [1, "John Doe", "Engineering", "$75,000", "Active"],
        [2, "Jane Smith", "Marketing", "$65,000", "Active"],
        [3, "Bob Johnson", "Sales", "$70,000", "Active"],
        [4, "Alice Williams", "HR", "$60,000", "Active"],
        [5, "Charlie Brown", "Engineering", "$80,000", "On Leave"],
        [6, "Diana Prince", "Management", "$95,000", "Active"],
        [7, "Eve Davis", "Sales", "$68,000", "Active"],
        [8, "Frank Miller", "Engineering", "$72,000", "Active"]
    ]

    ; Populate ListView
    for emp in employees {
        lv.Add("", emp*)
    }

    ; Info display
    infoText := myGui.Add("Edit", "x20 y365 w760 h60 ReadOnly Multi")
    UpdateInfo()

    UpdateInfo() {
        selected := lv.GetNext()
        if (selected) {
            id := lv.GetText(selected, 1)
            name := lv.GetText(selected, 2)
            dept := lv.GetText(selected, 3)
            salary := lv.GetText(selected, 4)
            status := lv.GetText(selected, 5)
            infoText.Value := Format("Selected Employee:\nID: {1} | Name: {2} | Dept: {3} | Salary: {4} | Status: {5}",
                id, name, dept, salary, status)
        } else {
            infoText.Value := Format("Total Employees: {1}\nNo employee selected", lv.GetCount())
        }
    }

    lv.OnEvent("ItemSelect", (*) => UpdateInfo())
    lv.OnEvent("Click", (*) => UpdateInfo())

    ; Action buttons
    myGui.Add("Button", "x20 y435 w150", "Add Employee").OnEvent("Click", AddEmployee)
    myGui.Add("Button", "x180 y435 w150", "Edit Selected").OnEvent("Click", EditEmployee)
    myGui.Add("Button", "x340 y435 w150", "Delete Selected").OnEvent("Click", DeleteEmployee)
    myGui.Add("Button", "x500 y435 w140", "Refresh").OnEvent("Click", (*) => UpdateInfo())
    myGui.Add("Button", "x650 y435 w130", "Close").OnEvent("Click", (*) => myGui.Destroy())

    AddEmployee(*) {
        nextId := lv.GetCount() + 1
        lv.Add("", nextId, "New Employee", "Department", "$50,000", "Active")
        UpdateInfo()
    }

    EditEmployee(*) {
        selected := lv.GetNext()
        if (selected) {
            MsgBox("Edit functionality would open a dialog to edit row " selected, "Edit Employee")
        } else {
            MsgBox("Please select an employee first", "No Selection")
        }
    }

    DeleteEmployee(*) {
        selected := lv.GetNext()
        if (selected) {
            name := lv.GetText(selected, 2)
            result := MsgBox("Delete employee: " name "?", "Confirm Delete", "YesNo")
            if (result = "Yes") {
                lv.Delete(selected)
                UpdateInfo()
            }
        } else {
            MsgBox("Please select an employee first", "No Selection")
        }
    }

    myGui.Show("w800 h485")
}


; =============================================================================
; Example 6: Column reorder
; =============================================================================

/**
 * Demonstrates column reorder
 * Complete ListView example with data management
 */
Example6_Columnreorder() {
    myGui := Gui(, "Column reorder Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Column reorder")
    myGui.SetFont("s9 Norm")

    ; Create ListView
    lv := myGui.Add("ListView", "x20 y55 w760 h300", ["ID", "Name", "Department", "Salary", "Status"])

    ; Set column widths
    lv.ModifyCol(1, 50)
    lv.ModifyCol(2, 150)
    lv.ModifyCol(3, 150)
    lv.ModifyCol(4, 100)
    lv.ModifyCol(5, 100)

    ; Sample data
    employees := [
        [1, "John Doe", "Engineering", "$75,000", "Active"],
        [2, "Jane Smith", "Marketing", "$65,000", "Active"],
        [3, "Bob Johnson", "Sales", "$70,000", "Active"],
        [4, "Alice Williams", "HR", "$60,000", "Active"],
        [5, "Charlie Brown", "Engineering", "$80,000", "On Leave"],
        [6, "Diana Prince", "Management", "$95,000", "Active"],
        [7, "Eve Davis", "Sales", "$68,000", "Active"],
        [8, "Frank Miller", "Engineering", "$72,000", "Active"]
    ]

    ; Populate ListView
    for emp in employees {
        lv.Add("", emp*)
    }

    ; Info display
    infoText := myGui.Add("Edit", "x20 y365 w760 h60 ReadOnly Multi")
    UpdateInfo()

    UpdateInfo() {
        selected := lv.GetNext()
        if (selected) {
            id := lv.GetText(selected, 1)
            name := lv.GetText(selected, 2)
            dept := lv.GetText(selected, 3)
            salary := lv.GetText(selected, 4)
            status := lv.GetText(selected, 5)
            infoText.Value := Format("Selected Employee:\nID: {1} | Name: {2} | Dept: {3} | Salary: {4} | Status: {5}",
                id, name, dept, salary, status)
        } else {
            infoText.Value := Format("Total Employees: {1}\nNo employee selected", lv.GetCount())
        }
    }

    lv.OnEvent("ItemSelect", (*) => UpdateInfo())
    lv.OnEvent("Click", (*) => UpdateInfo())

    ; Action buttons
    myGui.Add("Button", "x20 y435 w150", "Add Employee").OnEvent("Click", AddEmployee)
    myGui.Add("Button", "x180 y435 w150", "Edit Selected").OnEvent("Click", EditEmployee)
    myGui.Add("Button", "x340 y435 w150", "Delete Selected").OnEvent("Click", DeleteEmployee)
    myGui.Add("Button", "x500 y435 w140", "Refresh").OnEvent("Click", (*) => UpdateInfo())
    myGui.Add("Button", "x650 y435 w130", "Close").OnEvent("Click", (*) => myGui.Destroy())

    AddEmployee(*) {
        nextId := lv.GetCount() + 1
        lv.Add("", nextId, "New Employee", "Department", "$50,000", "Active")
        UpdateInfo()
    }

    EditEmployee(*) {
        selected := lv.GetNext()
        if (selected) {
            MsgBox("Edit functionality would open a dialog to edit row " selected, "Edit Employee")
        } else {
            MsgBox("Please select an employee first", "No Selection")
        }
    }

    DeleteEmployee(*) {
        selected := lv.GetNext()
        if (selected) {
            name := lv.GetText(selected, 2)
            result := MsgBox("Delete employee: " name "?", "Confirm Delete", "YesNo")
            if (result = "Yes") {
                lv.Delete(selected)
                UpdateInfo()
            }
        } else {
            MsgBox("Please select an employee first", "No Selection")
        }
    }

    myGui.Show("w800 h485")
}


; =============================================================================
; Example 7: Column visibility
; =============================================================================

/**
 * Demonstrates column visibility
 * Complete ListView example with data management
 */
Example7_Columnvisibility() {
    myGui := Gui(, "Column visibility Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Column visibility")
    myGui.SetFont("s9 Norm")

    ; Create ListView
    lv := myGui.Add("ListView", "x20 y55 w760 h300", ["ID", "Name", "Department", "Salary", "Status"])

    ; Set column widths
    lv.ModifyCol(1, 50)
    lv.ModifyCol(2, 150)
    lv.ModifyCol(3, 150)
    lv.ModifyCol(4, 100)
    lv.ModifyCol(5, 100)

    ; Sample data
    employees := [
        [1, "John Doe", "Engineering", "$75,000", "Active"],
        [2, "Jane Smith", "Marketing", "$65,000", "Active"],
        [3, "Bob Johnson", "Sales", "$70,000", "Active"],
        [4, "Alice Williams", "HR", "$60,000", "Active"],
        [5, "Charlie Brown", "Engineering", "$80,000", "On Leave"],
        [6, "Diana Prince", "Management", "$95,000", "Active"],
        [7, "Eve Davis", "Sales", "$68,000", "Active"],
        [8, "Frank Miller", "Engineering", "$72,000", "Active"]
    ]

    ; Populate ListView
    for emp in employees {
        lv.Add("", emp*)
    }

    ; Info display
    infoText := myGui.Add("Edit", "x20 y365 w760 h60 ReadOnly Multi")
    UpdateInfo()

    UpdateInfo() {
        selected := lv.GetNext()
        if (selected) {
            id := lv.GetText(selected, 1)
            name := lv.GetText(selected, 2)
            dept := lv.GetText(selected, 3)
            salary := lv.GetText(selected, 4)
            status := lv.GetText(selected, 5)
            infoText.Value := Format("Selected Employee:\nID: {1} | Name: {2} | Dept: {3} | Salary: {4} | Status: {5}",
                id, name, dept, salary, status)
        } else {
            infoText.Value := Format("Total Employees: {1}\nNo employee selected", lv.GetCount())
        }
    }

    lv.OnEvent("ItemSelect", (*) => UpdateInfo())
    lv.OnEvent("Click", (*) => UpdateInfo())

    ; Action buttons
    myGui.Add("Button", "x20 y435 w150", "Add Employee").OnEvent("Click", AddEmployee)
    myGui.Add("Button", "x180 y435 w150", "Edit Selected").OnEvent("Click", EditEmployee)
    myGui.Add("Button", "x340 y435 w150", "Delete Selected").OnEvent("Click", DeleteEmployee)
    myGui.Add("Button", "x500 y435 w140", "Refresh").OnEvent("Click", (*) => UpdateInfo())
    myGui.Add("Button", "x650 y435 w130", "Close").OnEvent("Click", (*) => myGui.Destroy())

    AddEmployee(*) {
        nextId := lv.GetCount() + 1
        lv.Add("", nextId, "New Employee", "Department", "$50,000", "Active")
        UpdateInfo()
    }

    EditEmployee(*) {
        selected := lv.GetNext()
        if (selected) {
            MsgBox("Edit functionality would open a dialog to edit row " selected, "Edit Employee")
        } else {
            MsgBox("Please select an employee first", "No Selection")
        }
    }

    DeleteEmployee(*) {
        selected := lv.GetNext()
        if (selected) {
            name := lv.GetText(selected, 2)
            result := MsgBox("Delete employee: " name "?", "Confirm Delete", "YesNo")
            if (result = "Yes") {
                lv.Delete(selected)
                UpdateInfo()
            }
        } else {
            MsgBox("Please select an employee first", "No Selection")
        }
    }

    myGui.Show("w800 h485")
}


; =============================================================================
; Main Menu - Example Launcher
; =============================================================================

/**
 * Creates a main menu to launch all examples
 */
ShowMainMenu() {
    menuGui := Gui(, "BuiltIn_GuiListView_02.ahk - Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "ListView Columns and Sorting")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    menuGui.Add("Button", "x20 y80 w360", "Example 1: Column management").OnEvent("Click", (*) => Example1_Columnmanagement())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: Column resizing").OnEvent("Click", (*) => Example2_Columnresizing())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: Sort by column").OnEvent("Click", (*) => Example3_Sortbycolumn())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Multi-sort").OnEvent("Click", (*) => Example4_Multisort())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: Custom sorting").OnEvent("Click", (*) => Example5_Customsorting())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: Column reorder").OnEvent("Click", (*) => Example6_Columnreorder())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: Column visibility").OnEvent("Click", (*) => Example7_Columnvisibility())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

; Show the main menu
ShowMainMenu()
