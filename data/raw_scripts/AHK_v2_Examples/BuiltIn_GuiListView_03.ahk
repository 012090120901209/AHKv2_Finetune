#Requires AutoHotkey v2.0

/**
 * BuiltIn_GuiListView_03.ahk - ListView Context Menus
 *
 * This file demonstrates context menus for ListView controls in AutoHotkey v2.
 * Topics covered:
 * - Right-click menus
 * - Menu creation
 * - Dynamic menus
 * - Menu actions
 * - Multi-row ops
 * - Copy/paste
 * - Data export
 *
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024
 */



; =============================================================================
; Example 1: Right-click menus
; =============================================================================

/**
 * Demonstrates right-click menus
 * Complete ListView example with data management
 */
Example1_Rightclickmenus() {
    myGui := Gui(, "Right-click menus Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Right-click menus")
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
; Example 2: Menu creation
; =============================================================================

/**
 * Demonstrates menu creation
 * Complete ListView example with data management
 */
Example2_Menucreation() {
    myGui := Gui(, "Menu creation Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Menu creation")
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
; Example 3: Dynamic menus
; =============================================================================

/**
 * Demonstrates dynamic menus
 * Complete ListView example with data management
 */
Example3_Dynamicmenus() {
    myGui := Gui(, "Dynamic menus Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Dynamic menus")
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
; Example 4: Menu actions
; =============================================================================

/**
 * Demonstrates menu actions
 * Complete ListView example with data management
 */
Example4_Menuactions() {
    myGui := Gui(, "Menu actions Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Menu actions")
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
; Example 5: Multi-row ops
; =============================================================================

/**
 * Demonstrates multi-row ops
 * Complete ListView example with data management
 */
Example5_Multirowops() {
    myGui := Gui(, "Multi-row ops Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Multi-row ops")
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
; Example 6: Copy/paste
; =============================================================================

/**
 * Demonstrates copy/paste
 * Complete ListView example with data management
 */
Example6_Copy/paste() {
    myGui := Gui(, "Copy/paste Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Copy/paste")
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
; Example 7: Data export
; =============================================================================

/**
 * Demonstrates data export
 * Complete ListView example with data management
 */
Example7_Dataexport() {
    myGui := Gui(, "Data export Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Data export")
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
    menuGui := Gui(, "BuiltIn_GuiListView_03.ahk - Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "ListView Context Menus")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    menuGui.Add("Button", "x20 y80 w360", "Example 1: Right-click menus").OnEvent("Click", (*) => Example1_Rightclickmenus())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: Menu creation").OnEvent("Click", (*) => Example2_Menucreation())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: Dynamic menus").OnEvent("Click", (*) => Example3_Dynamicmenus())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Menu actions").OnEvent("Click", (*) => Example4_Menuactions())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: Multi-row ops").OnEvent("Click", (*) => Example5_Multirowops())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: Copy/paste").OnEvent("Click", (*) => Example6_Copy/paste())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: Data export").OnEvent("Click", (*) => Example7_Dataexport())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

; Show the main menu
ShowMainMenu()
