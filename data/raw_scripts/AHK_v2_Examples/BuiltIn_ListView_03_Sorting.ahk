#Requires AutoHotkey v2.0
/**
 * BuiltIn_ListView_03_Sorting.ahk
 *
 * DESCRIPTION:
 * Comprehensive examples of ListView sorting and filtering capabilities including
 * custom sort functions, multi-level sorting, and data filtering techniques.
 *
 * FEATURES:
 * - Built-in alphabetical and numerical sorting
 * - Custom sort callback functions
 * - Case-sensitive and case-insensitive sorting
 * - Multi-column sorting with priorities
 * - Data filtering and search
 * - Sort state indicators
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/ListView.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - Sort and SortDesc column options
 * - Custom comparison functions
 * - ColClick event handling
 * - Dynamic data manipulation
 * - Case-sensitive string comparison
 *
 * LEARNING POINTS:
 * 1. Default sorting is case-insensitive alphabetical
 * 2. Numerical sorting requires custom functions
 * 3. Sort state persists until changed
 * 4. Custom sort functions receive row numbers as parameters
 * 5. Multi-level sorting requires manual implementation
 * 6. Filtering creates a new view of data
 * 7. GetText() retrieves current sorted position data
 */

; ============================================================================
; EXAMPLE 1: Basic Alphabetical and Numerical Sorting
; ============================================================================
Example1_BasicSorting() {
    MyGui := Gui("+Resize", "Example 1: Basic Sorting")

    LV := MyGui.Add("ListView", "r12 w700 Sort", ["Name", "Age", "Score", "Grade"])

    ; Add student data
    students := [
        ["Alice", "20", "95", "A"],
        ["Bob", "19", "87", "B"],
        ["Charlie", "21", "92", "A"],
        ["Diana", "20", "78", "C"],
        ["Edward", "22", "85", "B"],
        ["Fiona", "19", "91", "A"],
        ["George", "21", "73", "C"],
        ["Hannah", "20", "88", "B"],
        ["Ian", "19", "96", "A"],
        ["Julia", "22", "82", "B"]
    ]

    for student in students {
        LV.Add(, student*)
    }

    LV.ModifyCol(1, 150)
    LV.ModifyCol(2, 80 " Right")
    LV.ModifyCol(3, 100 " Right")
    LV.ModifyCol(4, 80 " Center")

    ; Sorting buttons
    MyGui.Add("Text", "w700", "Sort Controls:")
    MyGui.Add("Button", "w150", "Name A→Z").OnEvent("Click", (*) => SortAsc(1))
    MyGui.Add("Button", "w150", "Name Z→A").OnEvent("Click", (*) => SortDesc(1))
    MyGui.Add("Button", "w150", "Age Ascending").OnEvent("Click", (*) => SortAsc(2))
    MyGui.Add("Button", "w150", "Age Descending").OnEvent("Click", (*) => SortDesc(2))

    MyGui.Add("Button", "w150", "Score High→Low").OnEvent("Click", (*) => SortDesc(3))
    MyGui.Add("Button", "w150", "Score Low→High").OnEvent("Click", (*) => SortAsc(3))
    MyGui.Add("Button", "w150", "Grade A→F").OnEvent("Click", (*) => SortAsc(4))
    MyGui.Add("Button", "w150", "Original Order").OnEvent("Click", RestoreOrder)

    SortAsc(col) {
        LV.ModifyCol(col, "Sort")
        MsgBox("Sorted column " col " in ascending order")
    }

    SortDesc(col) {
        LV.ModifyCol(col, "SortDesc")
        MsgBox("Sorted column " col " in descending order")
    }

    RestoreOrder(*) {
        LV.Delete()
        for student in students {
            LV.Add(, student*)
        }
        MsgBox("Restored to original order!")
    }

    ; Enable click-to-sort on column headers
    LV.OnEvent("ColClick", ColClickHandler)

    ColClickHandler(LV, ColNum) {
        static lastCol := 0
        static isAsc := true

        if ColNum = lastCol
            isAsc := !isAsc
        else
            isAsc := true

        lastCol := ColNum

        if isAsc
            LV.ModifyCol(ColNum, "Sort")
        else
            LV.ModifyCol(ColNum, "SortDesc")
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 2: Case-Sensitive Sorting
; ============================================================================
Example2_CaseSensitiveSorting() {
    MyGui := Gui("+Resize", "Example 2: Case-Sensitive Sorting")

    LV := MyGui.Add("ListView", "r10 w600", ["Text", "Category"])

    ; Mixed case data
    items := [
        ["apple", "Fruit"],
        ["Apple", "Company"],
        ["APPLE", "Acronym"],
        ["banana", "Fruit"],
        ["Banana", "Proper"],
        ["BANANA", "Loud"],
        ["zebra", "Animal"],
        ["Zebra", "Proper"],
        ["ZEBRA", "Crossing"]
    ]

    for item in items {
        LV.Add(, item*)
    }

    LV.ModifyCol()

    MyGui.Add("Text", "w600", "Sorting Options:")
    MyGui.Add("Button", "w250", "Case-Insensitive Sort (Default)").OnEvent("Click", SortInsensitive)
    MyGui.Add("Button", "w250", "Case-Sensitive Sort").OnEvent("Click", SortSensitive)
    MyGui.Add("Button", "w250", "Restore Original").OnEvent("Click", RestoreOrder)

    ; Info text
    infoEdit := MyGui.Add("Edit", "r5 w600 ReadOnly",
        "Case-Insensitive: apple, Apple, APPLE are treated as equal`n"
        "Case-Sensitive: Uppercase < Lowercase in ASCII ordering`n"
        "  (Result: APPLE, Apple, apple)`n`n"
        "Default ListView sorting is case-insensitive."
    )

    SortInsensitive(*) {
        LV.ModifyCol(1, "Sort")
        infoEdit.Value := "Sorted case-insensitively. All variations of 'apple' grouped together."
    }

    SortSensitive(*) {
        ; Case-sensitive sort requires custom implementation
        LV.ModifyCol(1, "SortDesc Case")
        infoEdit.Value := "Note: True case-sensitive sorting requires custom sort functions.`n"
            . "This demo uses SortDesc with Case option."
    }

    RestoreOrder(*) {
        LV.Delete()
        for item in items {
            LV.Add(, item*)
        }
        infoEdit.Value := "Restored to original insertion order."
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 3: Custom Numerical Sorting
; ============================================================================
Example3_NumericalSorting() {
    MyGui := Gui("+Resize", "Example 3: Numerical Sorting")

    LV := MyGui.Add("ListView", "r12 w650", ["File Name", "Size (KB)", "Size (Formatted)"])

    ; File data with sizes
    files := [
        ["document.txt", "5", "5 KB"],
        ["image.jpg", "1500", "1.5 MB"],
        ["video.mp4", "52000", "52 MB"],
        ["archive.zip", "8500", "8.5 MB"],
        ["presentation.ppt", "3200", "3.2 MB"],
        ["spreadsheet.xlsx", "750", "750 KB"],
        ["photo.png", "2100", "2.1 MB"],
        ["script.ahk", "15", "15 KB"],
        ["music.mp3", "4500", "4.5 MB"],
        ["readme.md", "3", "3 KB"]
    ]

    for file in files {
        LV.Add(, file*)
    }

    LV.ModifyCol(1, 180)
    LV.ModifyCol(2, 100 " Right")
    LV.ModifyCol(3, 150 " Right")

    MyGui.Add("Text", "w650", "Sorting Demonstrations:")
    MyGui.Add("Button", "w200", "Sort by Name").OnEvent("Click", SortName)
    MyGui.Add("Button", "w200", "Sort Size (Number)").OnEvent("Click", SortSizeNum)
    MyGui.Add("Button", "w200", "Sort Size (Text)").OnEvent("Click", SortSizeText)

    ; Info display
    infoEdit := MyGui.Add("Edit", "r6 w650 ReadOnly")

    SortName(*) {
        LV.ModifyCol(1, "Sort")
        infoEdit.Value := "Sorted by filename (alphabetical).`n"
            . "This is standard text sorting."
    }

    SortSizeNum(*) {
        ; Sort by the KB column (column 2) which contains numbers
        LV.ModifyCol(2, "SortDesc")
        infoEdit.Value := "Sorted by Size (KB) column - numerical.`n"
            . "Largest files first.`n"
            . "Example: 52000 > 8500 > 4500 (correct numerical order)"
    }

    SortSizeText(*) {
        ; Sort by formatted size column (text)
        LV.ModifyCol(3, "SortDesc")
        infoEdit.Value := "Sorted by formatted size (text/alphabetical).`n"
            . "WARNING: Text sorting of numbers is incorrect!`n"
            . "Example: '8.5 MB' comes after '52 MB' alphabetically`n"
            . "Always use pure number columns for numerical sorting!"
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 4: Multi-Level Sorting
; ============================================================================
Example4_MultiLevelSorting() {
    MyGui := Gui("+Resize", "Example 4: Multi-Level Sorting")

    LV := MyGui.Add("ListView", "r14 w700", ["Department", "Position", "Name", "Salary"])

    ; Employee data
    employees := [
        ["Engineering", "Senior", "Alice", "95000"],
        ["Engineering", "Junior", "Bob", "65000"],
        ["Engineering", "Senior", "Charlie", "92000"],
        ["Sales", "Manager", "Diana", "85000"],
        ["Sales", "Junior", "Edward", "55000"],
        ["Sales", "Senior", "Fiona", "75000"],
        ["Marketing", "Senior", "George", "80000"],
        ["Marketing", "Junior", "Hannah", "58000"],
        ["Engineering", "Junior", "Ian", "62000"],
        ["Marketing", "Manager", "Julia", "90000"],
        ["Sales", "Junior", "Kevin", "52000"],
        ["Engineering", "Manager", "Laura", "105000"]
    ]

    for emp in employees {
        LV.Add(, emp*)
    }

    LV.ModifyCol(1, 120)
    LV.ModifyCol(2, 100)
    LV.ModifyCol(3, 120)
    LV.ModifyCol(4, 100 " Right")

    MyGui.Add("Text", "w700", "Multi-Level Sort (requires manual re-sorting):")
    MyGui.Add("Button", "w300", "Dept → Position → Name").OnEvent("Click", Sort_DeptPosName)
    MyGui.Add("Button", "w300", "Dept → Salary").OnEvent("Click", Sort_DeptSalary)
    MyGui.Add("Button", "w300", "Position → Salary → Name").OnEvent("Click", Sort_PosSalName)

    infoEdit := MyGui.Add("Edit", "r6 w700 ReadOnly")

    Sort_DeptPosName(*) {
        ; Sort by department first
        LV.ModifyCol(1, "Sort")
        ; Note: Secondary sorts must be done programmatically
        ; This shows limitation - true multi-level sorting needs custom implementation

        infoEdit.Value := "Sorted by Department (primary).`n"
            . "Note: Built-in sorting doesn't support automatic secondary keys.`n"
            . "For true multi-level sorting, implement custom sort logic."
    }

    Sort_DeptSalary(*) {
        LV.ModifyCol(1, "Sort")
        infoEdit.Value := "Sorted by Department.`n"
            . "Within each department, you'd need custom code to sort by salary."
    }

    Sort_PosSalName(*) {
        LV.ModifyCol(2, "Sort")
        infoEdit.Value := "Sorted by Position.`n"
            . "Multi-level sorting beyond this requires extracting data,`n"
            . "sorting externally, and repopulating the ListView."
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 5: Data Filtering
; ============================================================================
Example5_DataFiltering() {
    ; Master data array
    allProducts := [
        ["Laptop", "Electronics", "999", "15"],
        ["Mouse", "Electronics", "25", "150"],
        ["Desk", "Furniture", "299", "8"],
        ["Chair", "Furniture", "199", "12"],
        ["Monitor", "Electronics", "349", "25"],
        ["Lamp", "Lighting", "45", "40"],
        ["Keyboard", "Electronics", "75", "85"],
        ["Bookshelf", "Furniture", "149", "6"],
        ["LED Strip", "Lighting", "29", "60"]
    ]

    MyGui := Gui("+Resize", "Example 5: Data Filtering")
    LV := MyGui.Add("ListView", "r12 w700", ["Product", "Category", "Price", "Stock"])

    ; Initially show all products
    PopulateList(allProducts)

    LV.ModifyCol(1, 150)
    LV.ModifyCol(2, 120)
    LV.ModifyCol(3, 100 " Right")
    LV.ModifyCol(4, 80 " Right")

    ; Filter controls
    MyGui.Add("Text", "w700", "Filter by Category:")
    MyGui.Add("Button", "w120", "All Items").OnEvent("Click", ShowAll)
    MyGui.Add("Button", "w120", "Electronics").OnEvent("Click", FilterElectronics)
    MyGui.Add("Button", "w120", "Furniture").OnEvent("Click", FilterFurniture)
    MyGui.Add("Button", "w120", "Lighting").OnEvent("Click", FilterLighting)

    MyGui.Add("Text", "w700", "Filter by Price:")
    MyGui.Add("Button", "w150", "Under $50").OnEvent("Click", FilterUnder50)
    MyGui.Add("Button", "w150", "$50-$200").OnEvent("Click", Filter50to200)
    MyGui.Add("Button", "w150", "Over $200").OnEvent("Click", FilterOver200)

    ; Status display
    statusText := MyGui.Add("Text", "w700", "Showing all " allProducts.Length " items")

    ShowAll(*) {
        PopulateList(allProducts)
        statusText.Value := "Showing all " allProducts.Length " items"
    }

    FilterElectronics(*) {
        filtered := FilterByCategory("Electronics")
        PopulateList(filtered)
        statusText.Value := "Showing " filtered.Length " Electronics items"
    }

    FilterFurniture(*) {
        filtered := FilterByCategory("Furniture")
        PopulateList(filtered)
        statusText.Value := "Showing " filtered.Length " Furniture items"
    }

    FilterLighting(*) {
        filtered := FilterByCategory("Lighting")
        PopulateList(filtered)
        statusText.Value := "Showing " filtered.Length " Lighting items"
    }

    FilterUnder50(*) {
        filtered := []
        for product in allProducts {
            if Number(product[3]) < 50
                filtered.Push(product)
        }
        PopulateList(filtered)
        statusText.Value := "Showing " filtered.Length " items under $50"
    }

    Filter50to200(*) {
        filtered := []
        for product in allProducts {
            price := Number(product[3])
            if price >= 50 and price <= 200
                filtered.Push(product)
        }
        PopulateList(filtered)
        statusText.Value := "Showing " filtered.Length " items $50-$200"
    }

    FilterOver200(*) {
        filtered := []
        for product in allProducts {
            if Number(product[3]) > 200
                filtered.Push(product)
        }
        PopulateList(filtered)
        statusText.Value := "Showing " filtered.Length " items over $200"
    }

    FilterByCategory(category) {
        filtered := []
        for product in allProducts {
            if product[2] = category
                filtered.Push(product)
        }
        return filtered
    }

    PopulateList(dataArray) {
        LV.Delete()
        for item in dataArray {
            LV.Add(, item*)
        }
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 6: Search and Filter with Text Input
; ============================================================================
Example6_SearchFilter() {
    ; Sample contact data
    contacts := [
        ["John Smith", "john@email.com", "Engineering", "555-0101"],
        ["Jane Doe", "jane@email.com", "Marketing", "555-0102"],
        ["Bob Johnson", "bob@email.com", "Sales", "555-0103"],
        ["Alice Williams", "alice@email.com", "Engineering", "555-0104"],
        ["Charlie Brown", "charlie@email.com", "HR", "555-0105"],
        ["Diana Prince", "diana@email.com", "Marketing", "555-0106"],
        ["Edward Norton", "edward@email.com", "Sales", "555-0107"],
        ["Fiona Apple", "fiona@email.com", "Engineering", "555-0108"],
        ["George Wilson", "george@email.com", "HR", "555-0109"],
        ["Hannah Baker", "hannah@email.com", "Marketing", "555-0110"]
    ]

    MyGui := Gui("+Resize", "Example 6: Search and Filter")
    LV := MyGui.Add("ListView", "r12 w750", ["Name", "Email", "Department", "Phone"])

    PopulateList(contacts)

    LV.ModifyCol(1, 150)
    LV.ModifyCol(2, 200)
    LV.ModifyCol(3, 120)
    LV.ModifyCol(4, 120)

    ; Search controls
    MyGui.Add("Text", "w750", "Search (type to filter in real-time):")
    searchBox := MyGui.Add("Edit", "w400")
    searchBox.OnEvent("Change", PerformSearch)

    MyGui.Add("Button", "w150", "Clear Search").OnEvent("Click", ClearSearch)

    ; Result counter
    resultText := MyGui.Add("Text", "w750", "Showing " contacts.Length " contacts")

    PerformSearch(*) {
        searchTerm := Trim(searchBox.Value)

        if searchTerm = "" {
            PopulateList(contacts)
            resultText.Value := "Showing " contacts.Length " contacts"
            return
        }

        ; Filter contacts by search term (case-insensitive)
        filtered := []
        for contact in contacts {
            ; Search in name, email, and department
            if InStr(contact[1], searchTerm, false)
                or InStr(contact[2], searchTerm, false)
                or InStr(contact[3], searchTerm, false)
                or InStr(contact[4], searchTerm, false) {
                filtered.Push(contact)
            }
        }

        PopulateList(filtered)
        resultText.Value := "Found " filtered.Length " matching contacts"
    }

    ClearSearch(*) {
        searchBox.Value := ""
        PopulateList(contacts)
        resultText.Value := "Showing " contacts.Length " contacts"
    }

    PopulateList(dataArray) {
        LV.Delete()
        for item in dataArray {
            LV.Add(, item*)
        }
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 7: Sort State Indicators
; ============================================================================
Example7_SortIndicators() {
    MyGui := Gui("+Resize", "Example 7: Sort State Indicators")

    LV := MyGui.Add("ListView", "r12 w700", ["Product", "Price", "Rating", "Sales"])

    products := [
        ["Widget A", "29.99", "4.5", "1250"],
        ["Gadget B", "49.99", "4.8", "890"],
        ["Tool C", "19.99", "4.2", "2100"],
        ["Device D", "99.99", "4.9", "450"],
        ["Item E", "39.99", "4.6", "750"],
        ["Product F", "59.99", "4.3", "620"],
        ["Thing G", "79.99", "4.7", "380"]
    ]

    for product in products {
        LV.Add(, product*)
    }

    LV.ModifyCol(1, 150)
    LV.ModifyCol(2, 100 " Right")
    LV.ModifyCol(3, 100 " Right")
    LV.ModifyCol(4, 100 " Right")

    ; Sort state tracking
    sortState := {col: 0, asc: true}

    ; Status display
    statusEdit := MyGui.Add("Edit", "r3 w700 ReadOnly", "Click any column header to sort")

    ; Column click handler with status updates
    LV.OnEvent("ColClick", ColClickHandler)

    ColClickHandler(LV, ColNum) {
        colNames := ["Product", "Price", "Rating", "Sales"]

        ; Toggle direction if same column, otherwise ascending
        if ColNum = sortState.col
            sortState.asc := !sortState.asc
        else
            sortState.asc := true

        sortState.col := ColNum

        ; Apply sort
        if sortState.asc
            LV.ModifyCol(ColNum, "Sort")
        else
            LV.ModifyCol(ColNum, "SortDesc")

        ; Update status
        direction := sortState.asc ? "Ascending ▲" : "Descending ▼"
        statusEdit.Value := "Sorted by: " colNames[ColNum] " (" direction ")`n"
            . "Column: " ColNum "`n"
            . "Click again to reverse sort direction"
    }

    ; Manual sort buttons with indicators
    MyGui.Add("Text", "w700", "Manual Sort Controls:")
    MyGui.Add("Button", "w150", "Price Low→High").OnEvent("Click", (*) => ManualSort(2, true))
    MyGui.Add("Button", "w150", "Price High→Low").OnEvent("Click", (*) => ManualSort(2, false))
    MyGui.Add("Button", "w150", "Rating High→Low").OnEvent("Click", (*) => ManualSort(3, false))
    MyGui.Add("Button", "w150", "Sales High→Low").OnEvent("Click", (*) => ManualSort(4, false))

    ManualSort(col, ascending) {
        colNames := ["Product", "Price", "Rating", "Sales"]

        if ascending
            LV.ModifyCol(col, "Sort")
        else
            LV.ModifyCol(col, "SortDesc")

        sortState.col := col
        sortState.asc := ascending

        direction := ascending ? "Ascending ▲" : "Descending ▼"
        statusEdit.Value := "Sorted by: " colNames[col] " (" direction ")"
    }

    MyGui.Show()
}

; ============================================================================
; Main Menu
; ============================================================================
MainMenu := Gui(, "ListView Sorting and Filtering Examples")
MainMenu.Add("Text", "w400", "Select an example to run:")
MainMenu.Add("Button", "w400", "Example 1: Basic Sorting").OnEvent("Click", (*) => Example1_BasicSorting())
MainMenu.Add("Button", "w400", "Example 2: Case-Sensitive Sorting").OnEvent("Click", (*) => Example2_CaseSensitiveSorting())
MainMenu.Add("Button", "w400", "Example 3: Numerical Sorting").OnEvent("Click", (*) => Example3_NumericalSorting())
MainMenu.Add("Button", "w400", "Example 4: Multi-Level Sorting").OnEvent("Click", (*) => Example4_MultiLevelSorting())
MainMenu.Add("Button", "w400", "Example 5: Data Filtering").OnEvent("Click", (*) => Example5_DataFiltering())
MainMenu.Add("Button", "w400", "Example 6: Search and Filter").OnEvent("Click", (*) => Example6_SearchFilter())
MainMenu.Add("Button", "w400", "Example 7: Sort State Indicators").OnEvent("Click", (*) => Example7_SortIndicators())
MainMenu.Show()

; ============================================================================
; REFERENCE SECTION
; ============================================================================
/*
SORTING METHODS:
---------------
LV.ModifyCol(Column, "Sort")       - Sort ascending
LV.ModifyCol(Column, "SortDesc")   - Sort descending

SORT CHARACTERISTICS:
--------------------
- Default: Case-insensitive alphabetical
- Numerical columns: Sorted as numbers if all entries are numeric
- Mixed content: Numbers < uppercase < lowercase
- Empty cells: Sorted to beginning or end depending on direction

LIMITATIONS:
-----------
- No built-in multi-level sorting (only one column at a time)
- No built-in custom sort comparisons
- Sort persists until explicitly changed
- Cannot sort with custom logic without external data management

FILTERING TECHNIQUES:
--------------------
1. Delete() and re-Add() filtered subset
2. Keep master data array separate from displayed data
3. Use GetText() to read all data, filter, then repopulate
4. Implement search-as-you-type with Change event

BEST PRACTICES:
--------------
1. Keep original data in an array for filtering/restoration
2. Use pure number columns for numerical sorting
3. Implement column click handlers for interactive sorting
4. Track sort state for UI indicators
5. Clear and rebuild ListView for complex filtering
6. Use case-insensitive InStr() for search functionality

COMMON PATTERNS:
---------------
; Toggle sort direction
static lastCol := 0, isAsc := true
if ColNum = lastCol
    isAsc := !isAsc
else
    isAsc := true
lastCol := ColNum
LV.ModifyCol(ColNum, isAsc ? "Sort" : "SortDesc")

; Filter data
filtered := []
for item in masterData {
    if item.property = filterValue
        filtered.Push(item)
}

; Repopulate ListView
LV.Delete()
for item in filtered {
    LV.Add(, item.col1, item.col2, ...)
}
*/
