#Requires AutoHotkey v2.0
/**
 * BuiltIn_ListView_01_BasicUsage.ahk
 *
 * DESCRIPTION:
 * Demonstrates fundamental ListView control operations including creation, adding items,
 * accessing columns, and basic event handling in AutoHotkey v2.
 *
 * FEATURES:
 * - Creating ListView controls with columns
 * - Adding and removing rows programmatically
 * - Reading selected items
 * - Basic item modification
 * - Row counting and navigation
 * - Event handling for selections
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/ListView.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - GUI object-oriented approach
 * - ListView.Add() method syntax
 * - Property access (ListView.GetCount())
 * - Event callbacks with bound functions
 * - Array iteration for data population
 *
 * LEARNING POINTS:
 * 1. ListView controls require column definition before adding rows
 * 2. Items are 1-indexed in AutoHotkey ListViews
 * 3. GetNext() method is used for retrieving selected rows
 * 4. Modify() method updates existing row data
 * 5. Delete() can remove specific rows or all rows
 * 6. Events like ItemSelect provide row information
 * 7. Col parameter in Add() must match column count
 */

; ============================================================================
; EXAMPLE 1: Creating a Simple ListView with Static Data
; ============================================================================
Example1_SimpleListView() {
    ; Create a GUI window
    MyGui := Gui("+Resize", "Example 1: Simple ListView")

    ; Add a ListView control with 3 columns
    LV := MyGui.Add("ListView", "r10 w600", ["Name", "Age", "City"])

    ; Add some rows
    LV.Add(, "Alice Johnson", "28", "New York")
    LV.Add(, "Bob Smith", "35", "Los Angeles")
    LV.Add(, "Charlie Brown", "42", "Chicago")
    LV.Add(, "Diana Prince", "31", "San Francisco")
    LV.Add(, "Edward Norton", "27", "Seattle")

    ; Auto-size columns to fit content
    LV.ModifyCol()  ; Auto-size all columns

    ; Add a button to show row count
    MyGui.Add("Button", "w600", "Show Row Count").OnEvent("Click", ShowCount)

    ShowCount(*) {
        rowCount := LV.GetCount()
        MsgBox("The ListView contains " rowCount " rows.")
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 2: Adding Items from an Array
; ============================================================================
Example2_ArrayPopulation() {
    ; Sample data structure
    employees := [
        {name: "Sarah Connor", dept: "Engineering", salary: 85000},
        {name: "John Doe", dept: "Marketing", salary: 72000},
        {name: "Jane Smith", dept: "Sales", salary: 68000},
        {name: "Michael Johnson", dept: "Engineering", salary: 92000},
        {name: "Emily Davis", dept: "HR", salary: 65000},
        {name: "David Wilson", dept: "Finance", salary: 78000},
        {name: "Lisa Anderson", dept: "Marketing", salary: 71000}
    ]

    MyGui := Gui("+Resize", "Example 2: Array Population")
    LV := MyGui.Add("ListView", "r12 w700", ["Employee Name", "Department", "Salary"])

    ; Populate ListView from array
    for employee in employees {
        LV.Add(, employee.name, employee.dept, "$" Format("{:,.0f}", employee.salary))
    }

    ; Configure columns
    LV.ModifyCol(1, "200")  ; Name column width
    LV.ModifyCol(2, "150")  ; Department column width
    LV.ModifyCol(3, "150 Right")  ; Salary column right-aligned

    ; Add statistics button
    MyGui.Add("Button", "w700", "Calculate Average Salary").OnEvent("Click", CalcAverage)

    CalcAverage(*) {
        total := 0
        count := LV.GetCount()

        ; Loop through all rows
        Loop count {
            ; Get salary text (remove $ and commas)
            salaryText := LV.GetText(A_Index, 3)
            salary := StrReplace(StrReplace(salaryText, "$", ""), ",", "")
            total += Number(salary)
        }

        average := total / count
        MsgBox("Average Salary: $" Format("{:,.2f}", average))
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 3: Reading and Displaying Selected Items
; ============================================================================
Example3_SelectionHandling() {
    MyGui := Gui("+Resize", "Example 3: Selection Handling")
    LV := MyGui.Add("ListView", "r10 w600", ["Product", "Price", "Stock"])

    ; Add product data
    products := [
        ["Laptop", "$999", "15"],
        ["Mouse", "$25", "150"],
        ["Keyboard", "$75", "85"],
        ["Monitor", "$299", "42"],
        ["Headphones", "$149", "67"],
        ["Webcam", "$89", "34"],
        ["USB Drive", "$19", "200"]
    ]

    for product in products {
        LV.Add(, product[1], product[2], product[3])
    }

    LV.ModifyCol()  ; Auto-size columns

    ; Add buttons
    MyGui.Add("Button", "w600", "Show Selected Items").OnEvent("Click", ShowSelected)
    MyGui.Add("Button", "w600", "Select All").OnEvent("Click", SelectAll)
    MyGui.Add("Button", "w600", "Deselect All").OnEvent("Click", DeselectAll)

    ShowSelected(*) {
        selectedItems := ""
        rowNumber := 0

        ; Loop through selected rows
        Loop {
            rowNumber := LV.GetNext(rowNumber)
            if !rowNumber
                break

            product := LV.GetText(rowNumber, 1)
            price := LV.GetText(rowNumber, 2)
            stock := LV.GetText(rowNumber, 3)
            selectedItems .= product " - " price " (Stock: " stock ")`n"
        }

        if selectedItems = ""
            MsgBox("No items selected!")
        else
            MsgBox("Selected Items:`n`n" selectedItems, "Selection Info")
    }

    SelectAll(*) {
        ; Select all rows
        Loop LV.GetCount() {
            LV.Modify(A_Index, "Select")
        }
    }

    DeselectAll(*) {
        ; Deselect all rows
        Loop LV.GetCount() {
            LV.Modify(A_Index, "-Select")
        }
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 4: Modifying Existing Items
; ============================================================================
Example4_ItemModification() {
    MyGui := Gui("+Resize", "Example 4: Item Modification")
    LV := MyGui.Add("ListView", "r10 w650", ["Task", "Status", "Priority", "Due Date"])

    ; Add initial tasks
    LV.Add(, "Write Report", "In Progress", "High", "2025-11-20")
    LV.Add(, "Team Meeting", "Pending", "Medium", "2025-11-18")
    LV.Add(, "Code Review", "Not Started", "High", "2025-11-19")
    LV.Add(, "Update Documentation", "In Progress", "Low", "2025-11-25")
    LV.Add(, "Bug Fixes", "Not Started", "Critical", "2025-11-17")

    LV.ModifyCol()

    ; Control panel
    MyGui.Add("Text", "w650", "Select a task and change its status:")
    statusDDL := MyGui.Add("DropDownList", "w200", ["Not Started", "In Progress", "Completed", "Blocked"])
    statusDDL.Choose(1)

    MyGui.Add("Button", "w200", "Update Status").OnEvent("Click", UpdateStatus)
    MyGui.Add("Button", "w200", "Mark as Complete").OnEvent("Click", MarkComplete)
    MyGui.Add("Button", "w200", "Delete Task").OnEvent("Click", DeleteTask)

    UpdateStatus(*) {
        rowNum := LV.GetNext()
        if !rowNum {
            MsgBox("Please select a task first!")
            return
        }

        newStatus := statusDDL.Text
        taskName := LV.GetText(rowNum, 1)
        LV.Modify(rowNum, , , newStatus)  ; Modify only the status column
        MsgBox("Updated task '" taskName "' to: " newStatus)
    }

    MarkComplete(*) {
        rowNum := LV.GetNext()
        if !rowNum {
            MsgBox("Please select a task first!")
            return
        }

        LV.Modify(rowNum, , , "Completed")
        MsgBox("Task marked as completed!")
    }

    DeleteTask(*) {
        rowNum := LV.GetNext()
        if !rowNum {
            MsgBox("Please select a task first!")
            return
        }

        taskName := LV.GetText(rowNum, 1)
        result := MsgBox("Delete task '" taskName "'?", "Confirm Delete", "YesNo")
        if result = "Yes" {
            LV.Delete(rowNum)
            MsgBox("Task deleted!")
        }
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 5: Dynamic Item Addition with User Input
; ============================================================================
Example5_DynamicAddition() {
    MyGui := Gui("+Resize", "Example 5: Dynamic Item Addition")
    LV := MyGui.Add("ListView", "r12 w700", ["Contact Name", "Email", "Phone"])
    LV.ModifyCol(1, 200)
    LV.ModifyCol(2, 250)
    LV.ModifyCol(3, 150)

    ; Input fields
    MyGui.Add("Text", "w700", "Add New Contact:")
    MyGui.Add("Text", "x10", "Name:")
    nameEdit := MyGui.Add("Edit", "x70 yp w200")

    MyGui.Add("Text", "x10", "Email:")
    emailEdit := MyGui.Add("Edit", "x70 yp w300")

    MyGui.Add("Text", "x10", "Phone:")
    phoneEdit := MyGui.Add("Edit", "x70 yp w150")

    ; Buttons
    MyGui.Add("Button", "w150", "Add Contact").OnEvent("Click", AddContact)
    MyGui.Add("Button", "w150", "Clear Fields").OnEvent("Click", ClearFields)
    MyGui.Add("Button", "w150", "Export to Text").OnEvent("Click", ExportData)

    AddContact(*) {
        name := nameEdit.Value
        email := emailEdit.Value
        phone := phoneEdit.Value

        ; Validation
        if name = "" {
            MsgBox("Please enter a name!")
            return
        }

        if email = "" {
            MsgBox("Please enter an email!")
            return
        }

        ; Add to ListView
        LV.Add(, name, email, phone)

        ; Clear input fields
        nameEdit.Value := ""
        emailEdit.Value := ""
        phoneEdit.Value := ""

        ; Focus back to name field
        nameEdit.Focus()

        MsgBox("Contact added successfully!")
    }

    ClearFields(*) {
        nameEdit.Value := ""
        emailEdit.Value := ""
        phoneEdit.Value := ""
        nameEdit.Focus()
    }

    ExportData(*) {
        if LV.GetCount() = 0 {
            MsgBox("No contacts to export!")
            return
        }

        output := "Contact List`n" StrRepeat("=", 60) "`n`n"

        Loop LV.GetCount() {
            name := LV.GetText(A_Index, 1)
            email := LV.GetText(A_Index, 2)
            phone := LV.GetText(A_Index, 3)
            output .= "Name: " name "`nEmail: " email "`nPhone: " phone "`n`n"
        }

        MsgBox(output, "Contact Export", "T20")
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 6: ListView with Event Handling
; ============================================================================
Example6_EventHandling() {
    MyGui := Gui("+Resize", "Example 6: Event Handling")
    LV := MyGui.Add("ListView", "r10 w650", ["Item", "Category", "Value"])

    ; Add sample data
    LV.Add(, "Coffee Maker", "Appliances", "79.99")
    LV.Add(, "Office Chair", "Furniture", "199.99")
    LV.Add(, "Notebook", "Stationery", "4.99")
    LV.Add(, "Desk Lamp", "Lighting", "34.99")
    LV.Add(, "Bookshelf", "Furniture", "149.99")

    LV.ModifyCol()

    ; Event log
    MyGui.Add("Text", "w650", "Event Log:")
    logEdit := MyGui.Add("Edit", "r8 w650 ReadOnly")

    ; Register events
    LV.OnEvent("ItemSelect", ItemSelectHandler)
    LV.OnEvent("DoubleClick", DoubleClickHandler)

    ItemSelectHandler(LV, Item, Selected) {
        if Selected {
            itemName := LV.GetText(Item, 1)
            category := LV.GetText(Item, 2)
            value := LV.GetText(Item, 3)

            logText := FormatTime(, "HH:mm:ss") " - Selected: " itemName
            logText .= " (Category: " category ", Value: $" value ")`n"
            logEdit.Value .= logText
        }
    }

    DoubleClickHandler(LV, RowNumber) {
        if RowNumber {
            itemName := LV.GetText(RowNumber, 1)
            logText := FormatTime(, "HH:mm:ss") " - Double-clicked: " itemName "`n"
            logEdit.Value .= logText

            MsgBox("You double-clicked on: " itemName, "Item Action")
        }
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 7: Clearing and Rebuilding ListView
; ============================================================================
Example7_ClearAndRebuild() {
    MyGui := Gui("+Resize", "Example 7: Clear and Rebuild")
    LV := MyGui.Add("ListView", "r12 w600", ["Number", "Square", "Cube"])
    LV.ModifyCol(1, 150)
    LV.ModifyCol(2, 150)
    LV.ModifyCol(3, 150)

    ; Initial population
    PopulateTable(10)

    ; Controls
    MyGui.Add("Text", "w600", "Enter range (1-100):")
    rangeEdit := MyGui.Add("Edit", "w100 Number", "10")

    MyGui.Add("Button", "w200", "Rebuild Table").OnEvent("Click", Rebuild)
    MyGui.Add("Button", "w200", "Clear All").OnEvent("Click", ClearAll)
    MyGui.Add("Button", "w200", "Reset to Default").OnEvent("Click", ResetDefault)

    Rebuild(*) {
        maxNum := Integer(rangeEdit.Value)
        if maxNum < 1 or maxNum > 100 {
            MsgBox("Please enter a number between 1 and 100!")
            return
        }
        PopulateTable(maxNum)
    }

    ClearAll(*) {
        LV.Delete()  ; Delete all rows
        MsgBox("ListView cleared!")
    }

    ResetDefault(*) {
        rangeEdit.Value := "10"
        PopulateTable(10)
    }

    PopulateTable(maxNum) {
        LV.Delete()  ; Clear existing data

        Loop maxNum {
            num := A_Index
            square := num * num
            cube := num * num * num
            LV.Add(, num, square, cube)
        }

        MsgBox("Table rebuilt with " maxNum " rows!")
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
; Main Menu - Run Examples
; ============================================================================
MainMenu := Gui(, "ListView Basic Usage Examples")
MainMenu.Add("Text", "w400", "Select an example to run:")
MainMenu.Add("Button", "w400", "Example 1: Simple ListView").OnEvent("Click", (*) => Example1_SimpleListView())
MainMenu.Add("Button", "w400", "Example 2: Array Population").OnEvent("Click", (*) => Example2_ArrayPopulation())
MainMenu.Add("Button", "w400", "Example 3: Selection Handling").OnEvent("Click", (*) => Example3_SelectionHandling())
MainMenu.Add("Button", "w400", "Example 4: Item Modification").OnEvent("Click", (*) => Example4_ItemModification())
MainMenu.Add("Button", "w400", "Example 5: Dynamic Addition").OnEvent("Click", (*) => Example5_DynamicAddition())
MainMenu.Add("Button", "w400", "Example 6: Event Handling").OnEvent("Click", (*) => Example6_EventHandling())
MainMenu.Add("Button", "w400", "Example 7: Clear and Rebuild").OnEvent("Click", (*) => Example7_ClearAndRebuild())
MainMenu.Show()

; ============================================================================
; REFERENCE SECTION
; ============================================================================
/*
LISTVIEW METHODS:
-----------------
LV.Add([Options, Field1, Field2, ...])     - Add a new row
LV.Delete([RowNumber])                      - Delete row(s)
LV.GetCount([Mode])                         - Get row or column count
LV.GetNext([StartRow, RowType])            - Get next selected/focused row
LV.GetText(Row, Column)                     - Get cell text
LV.Modify(Row [, Options, Field1, ...])    - Modify existing row
LV.ModifyCol([Column, Options, Title])     - Modify column properties

COMMON OPTIONS FOR MODIFY:
-------------------------
"Select"        - Select the row
"-Select"       - Deselect the row
"Focus"         - Give keyboard focus to row
"Check"         - Check the row (if checkboxes enabled)
"-Check"        - Uncheck the row

COMMON LISTVIEW OPTIONS:
-----------------------
"r10"           - 10 rows visible
"w600"          - Width of 600 pixels
"Multi"         - Allow multiple selection (default)
"-Multi"        - Single selection only
"Checked"       - Add checkboxes to rows
"Grid"          - Show grid lines
"Sort"          - Allow column sorting
"ReadOnly"      - Prevent editing

EVENTS:
-------
ItemSelect      - Fired when item selection changes
DoubleClick     - Fired on double-click
ItemEdit        - Fired when item is edited
ItemFocus       - Fired when item gets focus
ColClick        - Fired when column header clicked

GETCOUNT MODES:
--------------
No parameter    - Returns number of rows
"Selected"      - Returns number of selected rows
"Column"        - Returns number of columns

BEST PRACTICES:
--------------
1. Always define columns before adding rows
2. Use ModifyCol() without parameters to auto-size all columns
3. Use GetNext() in a loop to process all selected items
4. Delete rows in reverse order when deleting multiple rows
5. Use LV.Opt("-Redraw") before bulk operations, then LV.Opt("+Redraw")
6. Always validate row numbers before accessing with GetText/Modify
*/
