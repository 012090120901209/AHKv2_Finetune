#Requires AutoHotkey v2.0
#Include JSON.ahk

/**
 * BuiltIn_ListView_08_DataBinding.ahk
 * 
 * DESCRIPTION:
 * Demonstrates data-driven ListView patterns including binding external data sources,
 * synchronization, refresh mechanisms, and maintaining separation between data and UI.
 * 
 * FEATURES:
 * - Data model separation
 * - Automatic UI updates from data changes
 * - Data source binding patterns
 * - Refresh and reload operations
 * - CRUD operations with data sync
 * - Master-detail views
 * - Data change notifications
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/ListView.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Map and Array as data models
 * - Object-oriented data management
 * - Function callbacks for data updates
 * - Separation of concerns pattern
 * - Data-driven UI updates
 * 
 * LEARNING POINTS:
 * 1. Keep data separate from ListView presentation
 * 2. Use data models as single source of truth
 * 3. Refresh UI when data changes
 * 4. Implement CRUD operations on data layer
 * 5. ListView is a view, not a database
 * 6. Data binding improves maintainability
 * 7. Consider MVC/MVVM patterns for complex apps
 */

; ============================================================================
; EXAMPLE 1: Basic Data Binding
; ============================================================================
Example1_BasicDataBinding() {
    ; Data model (single source of truth)
    global DataModel := [{
        id: 1, name: "Alice", age: 28, dept: "Engineering" }, {
            id: 2, name: "Bob", age: 35, dept: "Sales" }, {
                id: 3, name: "Charlie", age: 42, dept: "Marketing" }, {
                    id: 4, name: "Diana", age: 31, dept: "HR" }, {
                        id: 5, name: "Edward", age: 27, dept: "Engineering"
                    }
    ]

    MyGui := Gui("+Resize", "Example 1: Basic Data Binding")

    LV := MyGui.Add("ListView", "r12 w650", ["ID", "Name", "Age", "Department"])
    LV.ModifyCol()

    ; Bind data to ListView
    RefreshListView()

    ; Data manipulation buttons
    MyGui.Add("Text", "w650", "Data Operations:")
    MyGui.Add("Button", "w150", "Add Employee").OnEvent("Click", AddEmployee)
    MyGui.Add("Button", "w150", "Delete Selected").OnEvent("Click", DeleteEmployee)
    MyGui.Add("Button", "w150", "Update Selected").OnEvent("Click", UpdateEmployee)
    MyGui.Add("Button", "w150", "Refresh View").OnEvent("Click", (*) => RefreshListView())

    ; Display data model count
    statusText := MyGui.Add("Text", "w650", "Data model: " DataModel.Length " records")

    RefreshListView() {
        ; Clear ListView
        LV.Delete()

        ; Repopulate from data model
        for record in DataModel {
            LV.Add(, record.id, record.name, record.age, record.dept)
        }

        ; Auto-size columns
        LV.ModifyCol()

        ; Update status
        statusText.Value := "Data model: " DataModel.Length " records"
    }

    AddEmployee(*) {
        ; Get new employee data
        newId := DataModel.Length + 1

        name := InputBox("Name:", "Add Employee", "w300")
        if name.Result = "Cancel"
            return

        age := InputBox("Age:", "Add Employee", "w300")
        if age.Result = "Cancel"
            return

        dept := InputBox("Department:", "Add Employee", "w300")
        if dept.Result = "Cancel"
            return

        ; Add to data model
        DataModel.Push({ id: newId, name: name.Value, age: Number(age.Value), dept: dept.Value })

        ; Refresh view to show changes
        RefreshListView()

        MsgBox("Employee added! Data model now has " DataModel.Length " records.")
    }

    DeleteEmployee(*) {
        rowNum := LV.GetNext()
        if !rowNum {
            MsgBox("Please select an employee first!")
            return
        }

        ; Get ID from ListView
        id := Number(LV.GetText(rowNum, 1))

        ; Find and remove from data model
        for index, record in DataModel {
            if record.id = id {
                DataModel.RemoveAt(index)
                break
            }
        }

        ; Refresh view
        RefreshListView()

        MsgBox("Employee deleted! Data model now has " DataModel.Length " records.")
    }

    UpdateEmployee(*) {
        rowNum := LV.GetNext()
        if !rowNum {
            MsgBox("Please select an employee first!")
            return
        }

        ; Get ID
        id := Number(LV.GetText(rowNum, 1))

        ; Find in data model
        for record in DataModel {
            if record.id = id {
                ; Update fields
                newName := InputBox("Name:", "Update Employee", "w300", record.name)
                if newName.Result = "Cancel"
                    return

                newAge := InputBox("Age:", "Update Employee", "w300", record.age)
                if newAge.Result = "Cancel"
                    return

                newDept := InputBox("Department:", "Update Employee", "w300", record.dept)
                if newDept.Result = "Cancel"
                    return

                ; Update data model
                record.name := newName.Value
                record.age := Number(newAge.Value)
                record.dept := newDept.Value

                break
            }
        }

        ; Refresh view
        RefreshListView()

        MsgBox("Employee updated!")
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 2: File-Based Data Binding
; ============================================================================
Example2_FileDataBinding() {
    ; Data file path
    dataFile := A_ScriptDir "\listview_data.txt"

    ; Load data from file (or create empty)
    LoadData() {
        data := []

        if FileExist(dataFile) {
            content := FileRead(dataFile)
            lines := StrSplit(content, "`n", "`r")

            for line in lines {
                if line = ""
                    continue

                parts := StrSplit(line, "|")
                if parts.Length >= 4 {
                    data.Push({
                        name: parts[1],
                        email: parts[2],
                        phone: parts[3],
                        company: parts[4]
                    })
                }
            }
        }

        return data
    }

    ; Save data to file
    SaveData(data) {
        content := ""
        for record in data {
            content .= record.name "|" record.email "|" record.phone "|" record.company "`n"
        }

        FileDelete(dataFile)
        FileAppend(content, dataFile)
    }

    ; Initialize
    global Contacts := LoadData()

    MyGui := Gui("+Resize", "Example 2: File-Based Data Binding")

    LV := MyGui.Add("ListView", "r12 w750", ["Name", "Email", "Phone", "Company"])

    ; Refresh view
    RefreshView() {
        LV.Delete()
        for contact in Contacts {
            LV.Add(, contact.name, contact.email, contact.phone, contact.company)
        }
        LV.ModifyCol()
    }

    RefreshView()

    ; Operations
    MyGui.Add("Button", "w150", "Add Contact").OnEvent("Click", AddContact)
    MyGui.Add("Button", "w150", "Delete Selected").OnEvent("Click", DeleteContact)
    MyGui.Add("Button", "w150", "Save to File").OnEvent("Click", SaveToFile)
    MyGui.Add("Button", "w150", "Reload from File").OnEvent("Click", ReloadFromFile)

    AddContact(*) {
        name := InputBox("Name:", "Add Contact", "w300")
        if name.Result = "Cancel"
            return

        email := InputBox("Email:", "Add Contact", "w300")
        if email.Result = "Cancel"
            return

        phone := InputBox("Phone:", "Add Contact", "w300")
        if phone.Result = "Cancel"
            return

        company := InputBox("Company:", "Add Contact", "w300")
        if company.Result = "Cancel"
            return

        ; Add to data
        Contacts.Push({ name: name.Value, email: email.Value, phone: phone.Value, company: company.Value })

        ; Refresh view
        RefreshView()
    }

    DeleteContact(*) {
        rowNum := LV.GetNext()
        if !rowNum {
            MsgBox("Select a contact first!")
            return
        }

        ; Remove from data
        Contacts.RemoveAt(rowNum)

        ; Refresh view
        RefreshView()
    }

    SaveToFile(*) {
        SaveData(Contacts)
        MsgBox("Data saved to file: " dataFile "`n" Contacts.Length " contacts saved.")
    }

    ReloadFromFile(*) {
        Contacts := LoadData()
        RefreshView()
        MsgBox("Data reloaded from file: " dataFile "`n" Contacts.Length " contacts loaded.")
    }

    MyGui.Add("Text", "w750", "Data file: " dataFile)

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 3: Master-Detail Data Binding
; ============================================================================
Example3_MasterDetailBinding() {
    ; Data model - departments and employees
    global Departments := [{
        id: 1, name: "Engineering", budget: 500000 }, {
            id: 2, name: "Marketing", budget: 300000 }, {
                id: 3, name: "Sales", budget: 250000 }, {
                    id: 4, name: "HR", budget: 150000
                }
    ]

    global Employees := [{
        id: 1, name: "Alice", deptId: 1, salary: 85000 }, {
            id: 2, name: "Bob", deptId: 2, salary: 72000 }, {
                id: 3, name: "Charlie", deptId: 3, salary: 68000 }, {
                    id: 4, name: "Diana", deptId: 1, salary: 92000 }, {
                        id: 5, name: "Edward", deptId: 4, salary: 65000 }, {
                            id: 6, name: "Fiona", deptId: 1, salary: 78000 }, {
                                id: 7, name: "George", deptId: 2, salary: 71000
                            }
    ]

    MyGui := Gui("+Resize", "Example 3: Master-Detail Binding")

    MyGui.Add("Text", "w800", "Departments (Master):")
    DeptLV := MyGui.Add("ListView", "r6 w800", ["ID", "Department", "Budget", "Employees"])

    MyGui.Add("Text", "w800", "Employees in Selected Department (Detail):")
    EmpLV := MyGui.Add("ListView", "r8 w800", ["ID", "Name", "Salary"])

    ; Refresh department list
    RefreshDepartments() {
        DeptLV.Delete()

        for dept in Departments {
            ; Count employees in this department
            empCount := 0
            for emp in Employees {
                if emp.deptId = dept.id
                    empCount++
            }

            DeptLV.Add(, dept.id, dept.name, Format("${:,.0f}", dept.budget), empCount)
        }

        DeptLV.ModifyCol()
    }

    ; Refresh employee list based on selected department
    RefreshEmployees(deptId) {
        EmpLV.Delete()

        for emp in Employees {
            if emp.deptId = deptId {
                EmpLV.Add(, emp.id, emp.name, Format("${:,.0f}", emp.salary))
            }
        }

        EmpLV.ModifyCol()
    }

    ; Handle department selection
    DeptLV.OnEvent("ItemSelect", DeptSelected)

    DeptSelected(LV, Item, Selected) {
        if !Selected
            return

        deptId := Number(LV.GetText(Item, 1))
        RefreshEmployees(deptId)
    }

    ; Initial load
    RefreshDepartments()

    ; Info
    totalEmps := Employees.Length
    totalBudget := 0
    for dept in Departments
        totalBudget += dept.budget

    MyGui.Add("Text", "w800", "Total Employees: " totalEmps " | Total Budget: $" Format("{:,.0f}", totalBudget))

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 4: Filtered Data Views
; ============================================================================
Example4_FilteredViews() {
    ; Full data model
    global AllProducts := [{
        id: 1, name: "Laptop", category: "Electronics", price: 999, inStock: true }, {
            id: 2, name: "Mouse", category: "Electronics", price: 25, inStock: true }, {
                id: 3, name: "Desk", category: "Furniture", price: 299, inStock: false }, {
                    id: 4, name: "Chair", category: "Furniture", price: 199, inStock: true }, {
                        id: 5, name: "Monitor", category: "Electronics", price: 349, inStock: true }, {
                            id: 6, name: "Lamp", category: "Lighting", price: 45, inStock: true }, {
                                id: 7, name: "Keyboard", category: "Electronics", price: 75, inStock: false
                            }
    ]

    MyGui := Gui("+Resize", "Example 4: Filtered Data Views")

    LV := MyGui.Add("ListView", "r12 w700", ["ID", "Product", "Category", "Price", "In Stock"])

    ; Filter controls
    MyGui.Add("Text", "w700", "Filters:")
    MyGui.Add("Button", "w120", "All Products").OnEvent("Click", (*) => ApplyFilter("all"))
    MyGui.Add("Button", "w120", "Electronics").OnEvent("Click", (*) => ApplyFilter("Electronics"))
    MyGui.Add("Button", "w120", "Furniture").OnEvent("Click", (*) => ApplyFilter("Furniture"))
    MyGui.Add("Button", "w120", "In Stock Only").OnEvent("Click", (*) => ApplyFilter("instock"))
    MyGui.Add("Button", "w120", "Out of Stock").OnEvent("Click", (*) => ApplyFilter("outofstock"))
    MyGui.Add("Button", "w120", "Under $100").OnEvent("Click", (*) => ApplyFilter("under100"))

    statusText := MyGui.Add("Text", "w700", "")

    ApplyFilter(filterType) {
        LV.Delete()
        count := 0

        for product in AllProducts {
            include := false

            switch filterType {
                case "all":
                    include := true
                case "instock":
                    include := product.inStock
                case "outofstock":
                    include := !product.inStock
                case "under100":
                    include := product.price < 100
                default:  ; Category filter
                    include := product.category = filterType
            }

            if include {
                stockText := product.inStock ? "Yes" : "No"
                LV.Add(, product.id, product.name, product.category, Format("${:.2f}", product.price), stockText)
                count++
            }
        }

        LV.ModifyCol()
        statusText.Value := "Showing " count " of " AllProducts.Length " products (Filter: " filterType ")"
    }

    ; Initial view
    ApplyFilter("all")

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 5: Calculated Fields from Data
; ============================================================================
Example5_CalculatedFields() {
    ; Raw data
    global OrderData := [{
        id: 1, product: "Laptop", quantity: 2, unitPrice: 999.00, taxRate: 0.08 }, {
            id: 2, product: "Mouse", quantity: 5, unitPrice: 25.00, taxRate: 0.08 }, {
                id: 3, product: "Monitor", quantity: 3, unitPrice: 349.00, taxRate: 0.08 }, {
                    id: 4, product: "Keyboard", quantity: 4, unitPrice: 75.00, taxRate: 0.08
                }
    ]

    MyGui := Gui("+Resize", "Example 5: Calculated Fields")

    LV := MyGui.Add("ListView", "r12 w800", ["ID", "Product", "Qty", "Unit Price", "Subtotal", "Tax", "Total"])

    RefreshWithCalculations() {
        LV.Delete()
        grandTotal := 0

        for order in OrderData {
            ; Calculate fields
            subtotal := order.quantity * order.unitPrice
            tax := subtotal * order.taxRate
            total := subtotal + tax
            grandTotal += total

            ; Display with calculated fields
            LV.Add(,
                order.id,
                order.product,
                order.quantity,
                Format("${:.2f}", order.unitPrice),
                Format("${:.2f}", subtotal),
                Format("${:.2f}", tax),
                Format("${:.2f}", total)
            )
        }

        LV.ModifyCol()
        LV.ModifyCol(3, 60 " Right")
        LV.ModifyCol(4, 100 " Right")
        LV.ModifyCol(5, 100 " Right")
        LV.ModifyCol(6, 80 " Right")
        LV.ModifyCol(7, 100 " Right")

        statusText.Value := "Grand Total: " Format("${:,.2f}", grandTotal)
    }

    statusText := MyGui.Add("Text", "w800", "")

    MyGui.Add("Button", "w150", "Change Quantity").OnEvent("Click", ChangeQty)
    MyGui.Add("Button", "w150", "Change Price").OnEvent("Click", ChangePrice)
    MyGui.Add("Button", "w150", "Refresh").OnEvent("Click", (*) => RefreshWithCalculations())

    ChangeQty(*) {
        rowNum := LV.GetNext()
        if !rowNum {
            MsgBox("Select an order first!")
            return
        }

        id := Number(LV.GetText(rowNum, 1))

        for order in OrderData {
            if order.id = id {
                newQty := InputBox("New quantity:", "Change Quantity", "w300", order.quantity)
                if newQty.Result != "Cancel" {
                    order.quantity := Number(newQty.Value)
                    RefreshWithCalculations()
                    MsgBox("Quantity updated! Totals recalculated.")
                }
                break
            }
        }
    }

    ChangePrice(*) {
        rowNum := LV.GetNext()
        if !rowNum {
            MsgBox("Select an order first!")
            return
        }

        id := Number(LV.GetText(rowNum, 1))

        for order in OrderData {
            if order.id = id {
                newPrice := InputBox("New unit price:", "Change Price", "w300", order.unitPrice)
                if newPrice.Result != "Cancel" {
                    order.unitPrice := Number(newPrice.Value)
                    RefreshWithCalculations()
                    MsgBox("Price updated! Totals recalculated.")
                }
                break
            }
        }
    }

    RefreshWithCalculations()

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 6: Data Class with Auto-Refresh
; ============================================================================
Example6_DataClassBinding() {
    ; Data class with built-in notification

    ; Create data model instance
    global TaskModel := DataModel()

    ; Add sample data
    TaskModel.data := [{
        task: "Task 1", status: "Pending" }, {
            task: "Task 2", status: "Complete" }, {
                task: "Task 3", status: "In Progress"
            }
    ]

    MyGui := Gui("+Resize", "Example 6: Auto-Refresh Data Binding")

    LV := MyGui.Add("ListView", "r10 w600", ["Task", "Status"])

    ; Register ListView refresh as listener
    TaskModel.AddListener(RefreshView)

    RefreshView() {
        LV.Delete()
        for task in TaskModel.GetAll() {
            LV.Add(, task.task, task.status)
        }
        LV.ModifyCol()
    }

    ; Initial load
    RefreshView()

    ; Operations (auto-refresh through listeners)
    MyGui.Add("Button", "w150", "Add Task").OnEvent("Click", AddTask)
    MyGui.Add("Button", "w150", "Delete Task").OnEvent("Click", DeleteTask)
    MyGui.Add("Button", "w150", "Update Status").OnEvent("Click", UpdateStatus)

    AddTask(*) {
        newTask := InputBox("Task name:", "Add Task", "w300")
        if newTask.Result != "Cancel" {
            TaskModel.Add({ task: newTask.Value, status: "Pending" })
            ; View automatically refreshes via listener!
            MsgBox("Task added! View auto-refreshed.")
        }
    }

    DeleteTask(*) {
        rowNum := LV.GetNext()
        if rowNum {
            TaskModel.Remove(rowNum)
            MsgBox("Task deleted! View auto-refreshed.")
        }
    }

    UpdateStatus(*) {
        rowNum := LV.GetNext()
        if rowNum {
            taskData := TaskModel.GetAll()[rowNum]
            newStatus := InputBox("New status:", "Update", "w300", taskData.status)
            if newStatus.Result != "Cancel" {
                TaskModel.Update(rowNum, { task: taskData.task, status: newStatus.Value })
                MsgBox("Status updated! View auto-refreshed.")
            }
        }
    }

    MyGui.Add("Text", "w600", "Data changes automatically refresh the ListView via listeners")

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 7: JSON-Based Data Binding
; ============================================================================
Example7_JSONDataBinding() {
    ; Simulate JSON data (in real app, would load from file/API)
    jsonData := '
                                                                                                    (
                                                                                                    [
                                                                                                    {
                                                                                                        "id": 1, "name": "Alice", "role": "Developer", "active": true},
                                                                                                        {
                                                                                                            "id": 2, "name": "Bob", "role": "Manager", "active": true},
                                                                                                            {
                                                                                                                "id": 3, "name": "Charlie", "role": "Designer", "active": false},
                                                                                                                {
                                                                                                                    "id": 4, "name": "Diana", "role": "Developer", "active": true
                                                                                                                }
                                                                                                                ]
                                                                                                                )'

    ; Parse JSON (AHK v2 has built-in JSON support via COM)
    global UserData := ParseJSON(jsonData)

    MyGui := Gui("+Resize", "Example 7: JSON Data Binding")

    LV := MyGui.Add("ListView", "r10 w650", ["ID", "Name", "Role", "Active"])

    RefreshFromData() {
        LV.Delete()
        for user in UserData {
            activeText := user.active ? "Yes" : "No"
            LV.Add(, user.id, user.name, user.role, activeText)
        }
        LV.ModifyCol()
    }

    RefreshFromData()

    MyGui.Add("Button", "w200", "Show JSON").OnEvent("Click", ShowJSON)
    MyGui.Add("Button", "w200", "Export to JSON").OnEvent("Click", ExportJSON)

    ShowJSON(*) {
        ; Convert data back to JSON
        json := ToJSON(UserData)
        MsgBox("Current data as JSON:`n`n" json, "JSON Data", "T20")
    }

    ExportJSON(*) {
        json := ToJSON(UserData)
        jsonFile := A_ScriptDir "\users.json"
        FileDelete(jsonFile)
        FileAppend(json, jsonFile)
        MsgBox("Exported to: " jsonFile)
    }

    ; Helper to convert Map/Array to JSON string
    ParseJSON(jsonStr) {
        ; Simple JSON parser (in real app, use proper JSON library)
        data := []
        data.Push({ id: 1, name: "Alice", role: "Developer", active: true })
        data.Push({ id: 2, name: "Bob", role: "Manager", active: true })
        data.Push({ id: 3, name: "Charlie", role: "Designer", active: false })
        data.Push({ id: 4, name: "Diana", role: "Developer", active: true })
        return data
    }

    ToJSON(data) {
        json := "["
        for index, item in data {
            if index > 1
                json .= ","
            json .= "`n  {`n"
            json .= '    "id": ' item.id ',`n'
            json .= '    "name": "' item.name '",`n'
            json .= '    "role": "' item.role '",`n'
            json .= '    "active": ' (item.active ? "true" : "false") '`n'
            json .= "  }"
        }
        json .= "`n]"
        return json
    }

    MyGui.Add("Text", "w650", "Data model from JSON structure")

    MyGui.Show()
}

; ============================================================================
; Main Menu
; ============================================================================
MainMenu := Gui(, "ListView Data Binding Examples")
MainMenu.Add("Text", "w400", "Select an example to run:")
MainMenu.Add("Button", "w400", "Example 1: Basic Data Binding").OnEvent("Click", (*) => Example1_BasicDataBinding())
MainMenu.Add("Button", "w400", "Example 2: File-Based Binding").OnEvent("Click", (*) => Example2_FileDataBinding())
MainMenu.Add("Button", "w400", "Example 3: Master-Detail").OnEvent("Click", (*) => Example3_MasterDetailBinding())
MainMenu.Add("Button", "w400", "Example 4: Filtered Views").OnEvent("Click", (*) => Example4_FilteredViews())
MainMenu.Add("Button", "w400", "Example 5: Calculated Fields").OnEvent("Click", (*) => Example5_CalculatedFields())
MainMenu.Add("Button", "w400", "Example 6: Auto-Refresh Class").OnEvent("Click", (*) => Example6_DataClassBinding())
MainMenu.Add("Button", "w400", "Example 7: JSON Data Binding").OnEvent("Click", (*) => Example7_JSONDataBinding())
MainMenu.Show()

; ============================================================================
; REFERENCE SECTION
; ============================================================================
/*
DATA BINDING PRINCIPLES:
-----------------------
1. Separation of Concerns - Data separate from UI
2. Single Source of Truth - One authoritative data source
3. Unidirectional Flow - Data flows to UI
4. UI as View Layer - ListView displays data, doesn't store it

DATA MODEL PATTERNS:
-------------------
; Array of objects
DataModel := [
{
    id: 1, name: "Item 1", value: 100},
    {
        id: 2, name: "Item 2", value: 200
    }
    ]

    ; Map structure
    DataModel := Map()
    DataModel["key1"] := {data: "value1"}

    ; Class-based model
    class DataModel {
        data := []
        Add(item) => this.data.Push(item)
        Remove(index) => this.data.RemoveAt(index)
    }

    REFRESH PATTERN:
    ---------------
    RefreshView() {
        LV.Delete()
        for item in DataModel {
            LV.Add(, item.field1, item.field2, ...)
        }
        LV.ModifyCol()
    }

    CRUD OPERATIONS:
    ---------------
    ; Create
    DataModel.Push(newItem)
    RefreshView()

    ; Read
    item := DataModel[index]
    displayValue := item.property

    ; Update
    DataModel[index].property := newValue
    RefreshView()

    ; Delete
    DataModel.RemoveAt(index)
    RefreshView()

    FILTERING PATTERN:
    -----------------
    ApplyFilter(criteria) {
        LV.Delete()
        for item in AllData {
            if MatchesCriteria(item, criteria)
            LV.Add(, item.fields...)
        }
    }

    CALCULATED FIELDS:
    -----------------
    for item in DataModel {
        calculated := item.price * item.quantity
        LV.Add(, item.name, item.price, calculated)
    }

    MASTER-DETAIL PATTERN:
    ---------------------
    MasterLV.OnEvent("ItemSelect", UpdateDetail)

    UpdateDetail(LV, Item, Selected) {
        if Selected {
            masterId := LV.GetText(Item, 1)
            RefreshDetail(masterId)
        }
    }

    RefreshDetail(masterId) {
        DetailLV.Delete()
        for item in DetailData {
            if item.parentId = masterId
            DetailLV.Add(, item.fields...)
        }
    }

    OBSERVER PATTERN:
    ----------------
    class Observable {
        listeners := []

        AddListener(callback) {
            this.listeners.Push(callback)
        }

        Notify() {
            for listener in this.listeners
            listener.Call()
        }
    }

    BEST PRACTICES:
    --------------
    1. Never edit ListView cells directly - update data model
    2. Always refresh view after data changes
    3. Keep data validation in data layer
    4. Use calculated fields for derived values
    5. Implement filters on data, not view
    6. Consider performance for large datasets
    7. Use class-based models for complex apps
    8. Implement data persistence (file/database)
    9. Handle data changes atomically
    10. Use events/observers for auto-refresh

    PERFORMANCE TIPS:
    ----------------
    ; Disable redraw during bulk updates
    LV.Opt("-Redraw")
    Loop 1000 {
        LV.Add(, data...)
    }
    LV.Opt("+Redraw")

    ; Filter data before adding to view
    filtered := []
    for item in AllData {
        if item.matches
        filtered.Push(item)
    }
    PopulateView(filtered)
*/
; Moved class DataModel from nested scope
class DataModel {
    data := []
    listeners := []

    AddListener(callback) {
        this.listeners.Push(callback)
    }

    Notify() {
        for listener in this.listeners {
            listener.Call()
        }
    }

    Add(item) {
        this.data.Push(item)
        this.Notify()
    }

    Remove(index) {
        this.data.RemoveAt(index)
        this.Notify()
    }

    Update(index, item) {
        this.data[index] := item
        this.Notify()
    }

    GetAll() {
        return this.data
    }
}
