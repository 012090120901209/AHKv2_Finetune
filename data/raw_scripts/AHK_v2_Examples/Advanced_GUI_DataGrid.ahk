#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Advanced GUI Example: Editable Data Grid with Sorting
; Demonstrates: ListView sorting, editing, column clicking, data manipulation

myGui := Gui()
myGui.Title := "Employee Database Editor"

; Toolbar buttons
myGui.Add("Button", "x10 y10 w80", "Add").OnEvent("Click", AddEmployee)
myGui.Add("Button", "x100 y10 w80", "Edit").OnEvent("Click", EditEmployee)
myGui.Add("Button", "x190 y10 w80", "Delete").OnEvent("Click", DeleteEmployee)
myGui.Add("Button", "x280 y10 w80", "Export").OnEvent("Click", ExportData)

; Search box
myGui.Add("Text", "x380 y13", "Search:")
searchBox := myGui.Add("Edit", "x430 y10 w150")
searchBox.OnEvent("Change", SearchData)

; ListView with sortable columns
LV := myGui.Add("ListView", "x10 y45 w570 h350 Grid", ["ID", "Name", "Department", "Salary", "Hire Date"])

; Add sample data
employees := [
    {id: 1001, name: "John Smith", dept: "IT", salary: 75000, hired: "2020-03-15"},
    {id: 1002, name: "Jane Doe", dept: "HR", salary: 65000, hired: "2019-07-22"},
    {id: 1003, name: "Bob Johnson", dept: "Sales", salary: 70000, hired: "2021-01-10"},
    {id: 1004, name: "Alice Williams", dept: "IT", salary: 80000, hired: "2018-11-05"},
    {id: 1005, name: "Charlie Brown", dept: "Marketing", salary: 68000, hired: "2022-02-28"}
]

LoadData()

; Status bar
statusBar := myGui.Add("StatusBar")
UpdateStatus()

; Column click for sorting
LV.OnEvent("ColClick", SortColumn)

myGui.Show("w590 h425")

LoadData() {
    global LV, employees
    LV.Delete()
    for emp in employees {
        LV.Add(, emp.id, emp.name, emp.dept, "$" Format("{:,}", emp.salary), emp.hired)
    }
    LV.ModifyCol()
    UpdateStatus()
}

AddEmployee(*) {
    addGui := Gui()
    addGui.Title := "Add Employee"

    addGui.Add("Text", "x10 y10", "ID:")
    idEdit := addGui.Add("Edit", "x100 y7 w150 Number")

    addGui.Add("Text", "x10 y40", "Name:")
    nameEdit := addGui.Add("Edit", "x100 y37 w150")

    addGui.Add("Text", "x10 y70", "Department:")
    deptDDL := addGui.Add("DropDownList", "x100 y67 w150", ["IT", "HR", "Sales", "Marketing", "Finance"])
    deptDDL.Choose(1)

    addGui.Add("Text", "x10 y100", "Salary:")
    salaryEdit := addGui.Add("Edit", "x100 y97 w150 Number")

    addGui.Add("Text", "x10 y130", "Hire Date:")
    dateEdit := addGui.Add("Edit", "x100 y127 w150", FormatTime(, "yyyy-MM-dd"))

    addGui.Add("Button", "x70 y165 w80", "Add").OnEvent("Click", (*) => SaveEmployee(addGui))
    addGui.Add("Button", "x160 y165 w80", "Cancel").OnEvent("Click", (*) => addGui.Destroy())

    addGui.Show("w270 h205")

    SaveEmployee(gui) {
        global employees

        newEmp := {
            id: Integer(idEdit.Value),
            name: nameEdit.Value,
            dept: deptDDL.Text,
            salary: Integer(salaryEdit.Value),
            hired: dateEdit.Value
        }

        if (newEmp.id && newEmp.name && newEmp.salary) {
            employees.Push(newEmp)
            LoadData()
            gui.Destroy()
            MsgBox("Employee added successfully!", "Success")
        } else {
            MsgBox("Please fill all fields!", "Error")
        }
    }
}

EditEmployee(*) {
    global LV, employees

    row := LV.GetNext()
    if (!row) {
        MsgBox("Please select an employee to edit!", "Warning")
        return
    }

    id := Integer(LV.GetText(row, 1))

    ; Find employee
    for emp in employees {
        if (emp.id = id) {
            ; Create edit dialog (similar to add, but pre-filled)
            MsgBox("Edit dialog for: " emp.name "`n(Not fully implemented in this example)", "Edit")
            break
        }
    }
}

DeleteEmployee(*) {
    global LV, employees

    row := LV.GetNext()
    if (!row) {
        MsgBox("Please select an employee to delete!", "Warning")
        return
    }

    name := LV.GetText(row, 2)
    result := MsgBox("Delete employee: " name "?", "Confirm", "YesNo Icon?")

    if (result = "Yes") {
        id := Integer(LV.GetText(row, 1))

        ; Remove from array
        for i, emp in employees {
            if (emp.id = id) {
                employees.RemoveAt(i)
                break
            }
        }

        LoadData()
    }
}

SearchData(*) {
    global searchBox, LV, employees

    query := Trim(searchBox.Value)
    LV.Delete()

    if (query = "") {
        LoadData()
        return
    }

    ; Filter employees
    for emp in employees {
        if (InStr(emp.name, query) || InStr(emp.dept, query)) {
            LV.Add(, emp.id, emp.name, emp.dept, "$" Format("{:,}", emp.salary), emp.hired)
        }
    }

    LV.ModifyCol()
    UpdateStatus()
}

SortColumn(GuiCtrl, ColNum) {
    global LV
    LV.ModifyCol(ColNum, "Sort")
}

ExportData(*) {
    global employees

    csv := "ID,Name,Department,Salary,Hire Date`n"
    for emp in employees {
        csv .= emp.id "," emp.name "," emp.dept "," emp.salary "," emp.hired "`n"
    }

    filename := "employees_" FormatTime(, "yyyyMMdd_HHmmss") ".csv"
    FileAppend(csv, filename)
    MsgBox("Data exported to: " filename, "Success")
}

UpdateStatus() {
    global statusBar, LV
    count := LV.GetCount()
    statusBar.SetText("  Total Employees: " count)
}
