#Requires AutoHotkey v2.0

/**
 * BuiltIn_GuiListView_01.ahk - Basic ListView Operations
 *
 * This file demonstrates fundamental ListView control usage in AutoHotkey v2.
 * Topics covered:
 * - ListView creation
 * - Adding data
 * - Getting values
 * - Row selection
 * - ListView iteration
 * - Basic formatting
 * - ListView events
 *
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024
 */



; =============================================================================
; Example 1: ListView creation
; =============================================================================

/**
 * Demonstrates listview creation
 * Complete ListView example with data management
 */
Example1_ListViewcreation() {
    myGui := Gui(, "ListView creation Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "ListView creation")
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
; Example 2: Adding data
; =============================================================================

/**
 * Demonstrates adding data
 * Complete ListView example with data management
 */
Example2_Addingdata() {
    myGui := Gui(, "Adding data Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Adding data")
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
; Example 3: Getting values
; =============================================================================

/**
 * Demonstrates getting values
 * Complete ListView example with data management
 */
Example3_Gettingvalues() {
    myGui := Gui(, "Getting values Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Getting values")
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
; Example 4: Row selection
; =============================================================================

/**
 * Demonstrates row selection
 * Complete ListView example with data management
 */
Example4_Rowselection() {
    myGui := Gui(, "Row selection Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Row selection")
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
; Example 5: ListView iteration
; =============================================================================

/**
 * Demonstrates listview iteration
 * Complete ListView example with data management
 */
Example5_ListViewiteration() {
    myGui := Gui(, "ListView iteration Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "ListView iteration")
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
; Example 6: Basic formatting
; =============================================================================

/**
 * Demonstrates basic formatting
 * Complete ListView example with data management
 */
Example6_Basicformatting() {
    myGui := Gui(, "Basic formatting Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "Basic formatting")
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
; Example 7: ListView events
; =============================================================================

/**
 * Demonstrates listview events
 * Complete ListView example with data management
 */
Example7_ListViewevents() {
    myGui := Gui(, "ListView events Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w760", "ListView events")
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
    menuGui := Gui(, "BuiltIn_GuiListView_01.ahk - Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "Basic ListView Operations")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    menuGui.Add("Button", "x20 y80 w360", "Example 1: ListView creation").OnEvent("Click", (*) => Example1_ListViewcreation())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: Adding data").OnEvent("Click", (*) => Example2_Addingdata())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: Getting values").OnEvent("Click", (*) => Example3_Gettingvalues())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Row selection").OnEvent("Click", (*) => Example4_Rowselection())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: ListView iteration").OnEvent("Click", (*) => Example5_ListViewiteration())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: Basic formatting").OnEvent("Click", (*) => Example6_Basicformatting())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: ListView events").OnEvent("Click", (*) => Example7_ListViewevents())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

; Show the main menu
ShowMainMenu()
