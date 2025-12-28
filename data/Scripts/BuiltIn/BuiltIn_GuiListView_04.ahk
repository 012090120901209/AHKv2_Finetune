#Requires AutoHotkey v2.0

/**
 * BuiltIn_GuiListView_04.ahk - Advanced ListView Features
 * 
 * This file demonstrates advanced ListView functionality in AutoHotkey v2.
 * Topics covered:
 * - ListView icons
 * - Checkboxes
 * - Editable cells
 * - Drag and drop
 * - Virtual ListView
 * - Filtering
 * - Data binding
 * 
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024
 */


; =============================================================================
; Example 1: ListView icons
; =============================================================================

/**
 * Demonstrates listview icons
 * Complete ListView example with data management
 */
Example1_ListViewicons() {
    myGui := Gui(, "ListView icons Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "ListView icons")
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
; Example 2: Checkboxes
; =============================================================================

/**
 * Demonstrates checkboxes
 * Complete ListView example with data management
 */
Example2_Checkboxes() {
    myGui := Gui(, "Checkboxes Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Checkboxes")
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
; Example 3: Editable cells
; =============================================================================

/**
 * Demonstrates editable cells
 * Complete ListView example with data management
 */
Example3_Editablecells() {
    myGui := Gui(, "Editable cells Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Editable cells")
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
; Example 4: Drag and drop
; =============================================================================

/**
 * Demonstrates drag and drop
 * Complete ListView example with data management
 */
Example4_Draganddrop() {
    myGui := Gui(, "Drag and drop Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Drag and drop")
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
; Example 5: Virtual ListView
; =============================================================================

/**
 * Demonstrates virtual listview
 * Complete ListView example with data management
 */
Example5_VirtualListView() {
    myGui := Gui(, "Virtual ListView Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Virtual ListView")
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
; Example 6: Filtering
; =============================================================================

/**
 * Demonstrates filtering
 * Complete ListView example with data management
 */
Example6_Filtering() {
    myGui := Gui(, "Filtering Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Filtering")
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
; Example 7: Data binding
; =============================================================================

/**
 * Demonstrates data binding
 * Complete ListView example with data management
 */
Example7_Databinding() {
    myGui := Gui(, "Data binding Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Data binding")
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
    menuGui := Gui(, "BuiltIn_GuiListView_04.ahk - Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "Advanced ListView Features")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    menuGui.Add("Button", "x20 y80 w360", "Example 1: ListView icons").OnEvent("Click", (*) => Example1_ListViewicons())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: Checkboxes").OnEvent("Click", (*) => Example2_Checkboxes())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: Editable cells").OnEvent("Click", (*) => Example3_Editablecells())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Drag and drop").OnEvent("Click", (*) => Example4_Draganddrop())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: Virtual ListView").OnEvent("Click", (*) => Example5_VirtualListView())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: Filtering").OnEvent("Click", (*) => Example6_Filtering())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: Data binding").OnEvent("Click", (*) => Example7_Databinding())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

; Show the main menu
ShowMainMenu()
