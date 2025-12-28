#Requires AutoHotkey v2.0

/**
 * BuiltIn_COM_Excel_02_Cells.ahk
 * 
 * DESCRIPTION:
 * Demonstrates reading and writing cell data in Microsoft Excel using COM automation.
 * Shows various methods for accessing cells, ranges, and manipulating cell values.
 * 
 * FEATURES:
 * - Reading and writing individual cells
 * - Working with ranges of cells
 * - Using Cells() and Range() methods
 * - Bulk data operations
 * - Array-based cell updates
 * - Dynamic cell references
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - ComObject
 * https://www.autohotkey.com/docs/v2/lib/ComObject.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - ComObject() for Excel automation
 * - COM property access for cells
 * - Loop structures for cell iteration
 * - Array manipulation with COM objects
 * 
 * LEARNING POINTS:
 * 1. Different ways to reference cells (Range vs Cells)
 * 2. Reading single cell values and ranges
 * 3. Writing data to cells efficiently
 * 4. Using R1C1 vs A1 notation
 * 5. Working with 2D arrays for bulk updates
 * 6. Iterating through cells and ranges
 * 7. Performance optimization for large datasets
 */

;===============================================================================
; Example 1: Basic Cell Reading and Writing
;===============================================================================
Example1_BasicCellOperations() {
    MsgBox("Example 1: Basic Cell Operations`n`nReading and writing individual cells using different methods.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Method 1: Using Range() with A1 notation
        sheet.Range("A1").Value := "Method 1: Range()"
        sheet.Range("B1").Value := 100

        ; Method 2: Using Cells() with row, column
        sheet.Cells(2, 1).Value := "Method 2: Cells()"
        sheet.Cells(2, 2).Value := 200

        ; Method 3: Using Range() with multiple cells
        sheet.Range("A3").Value := "Method 3: Range()"
        sheet.Range("B3").Value := 300

        ; Method 4: Using Cells() with calculated positions
        row := 4
        col := 1
        sheet.Cells(row, col).Value := "Method 4: Dynamic"
        sheet.Cells(row, col + 1).Value := 400

        ; Reading values back
        val1 := sheet.Range("B1").Value
        val2 := sheet.Cells(2, 2).Value
        val3 := sheet.Range("B3").Value
        val4 := sheet.Cells(4, 2).Value

        result := "Values read from cells:`n`n"
        result .= "B1: " val1 "`n"
        result .= "B2: " val2 "`n"
        result .= "B3: " val3 "`n"
        result .= "B4: " val4

        MsgBox(result "`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 1:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 2: Working with Ranges
;===============================================================================
Example2_RangeOperations() {
    MsgBox("Example 2: Range Operations`n`nWorking with multiple cells at once using ranges.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Set a range of cells to the same value
        sheet.Range("A1:C1").Value := "Header"

        ; Set a range with an array
        sheet.Range("A2:C2").Value := [10, 20, 30]

        ; Fill a vertical range
        sheet.Range("D1:D5").Value := "Column D"

        ; Fill a 2x3 range with individual values
        range := sheet.Range("A4:C5")
        range.Value := [[1, 2, 3], [4, 5, 6]]

        ; Read a range back
        rangeValues := sheet.Range("A4:C5").Value

        ; Format the range
        sheet.Range("A1:D1").Font.Bold := true
        sheet.Range("A1:D1").Interior.Color := 0xFFFF00  ; Yellow

        ; Get the count of cells in a range
        cellCount := sheet.Range("A1:D5").Count

        MsgBox("Range operations complete!`n`nTotal cells in A1:D5: " cellCount "`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 2:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 3: Bulk Data Import
;===============================================================================
Example3_BulkDataImport() {
    MsgBox("Example 3: Bulk Data Import`n`nImporting large amounts of data efficiently.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        xl.ScreenUpdating := false  ; Speed up by disabling screen updates

        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Create headers
        headers := ["ID", "Name", "Department", "Salary", "Start Date"]
        sheet.Range("A1:E1").Value := [headers]

        ; Generate sample data
        MsgBox("Generating 1000 rows of sample data...`n`nThis may take a moment.")

        departments := ["Sales", "Engineering", "Marketing", "HR", "Finance"]
        names := ["John", "Jane", "Bob", "Alice", "Charlie", "Diana", "Eve", "Frank"]

        ; Method 1: Row by row (slower but simple)
        Loop 1000 {
            row := A_Index + 1
            sheet.Cells(row, 1).Value := A_Index
            sheet.Cells(row, 2).Value := names[Mod(A_Index - 1, names.Length) + 1] " " A_Index
            sheet.Cells(row, 3).Value := departments[Mod(A_Index - 1, departments.Length) + 1]
            sheet.Cells(row, 4).Value := Random(30000, 100000)
            sheet.Cells(row, 5).Value := FormatTime(A_Now, "yyyy-MM-dd")
        }

        ; Format headers
        sheet.Range("A1:E1").Font.Bold := true
        sheet.Range("A1:E1").Interior.Color := 0xCCCCCC

        ; Auto-fit columns
        sheet.Columns("A:E").AutoFit()

        xl.ScreenUpdating := true

        MsgBox("Bulk import complete!`n`n1000 rows of data imported.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 3:`n" err.Message)
        if (IsSet(xl)) {
            xl.ScreenUpdating := true
            xl.Quit()
        }
    }
}

;===============================================================================
; Example 4: Reading Data from Spreadsheet
;===============================================================================
Example4_ReadingData() {
    MsgBox("Example 4: Reading Data`n`nCreating a spreadsheet and then reading data from it.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Create sample data
        sheet.Range("A1").Value := "Product"
        sheet.Range("B1").Value := "Price"
        sheet.Range("C1").Value := "Quantity"
        sheet.Range("D1").Value := "Total"

        ; Add some products
        products := [
            ["Laptop", 999.99, 5],
            ["Mouse", 24.99, 15],
            ["Keyboard", 79.99, 10],
            ["Monitor", 299.99, 8],
            ["Webcam", 89.99, 12]
        ]

        Loop products.Length {
            row := A_Index + 1
            sheet.Cells(row, 1).Value := products[A_Index][1]
            sheet.Cells(row, 2).Value := products[A_Index][2]
            sheet.Cells(row, 3).Value := products[A_Index][3]
            sheet.Cells(row, 4).Formula := "=B" row "*C" row
        }

        ; Now read the data back
        MsgBox("Data has been created. Now reading it back...")

        ; Find the last row with data
        lastRow := sheet.Cells(sheet.Rows.Count, 1).End(-4162).Row  ; -4162 = xlUp

        ; Read all data
        report := "Products in Spreadsheet:`n`n"
        Loop lastRow - 1 {
            row := A_Index + 1
            product := sheet.Cells(row, 1).Value
            price := sheet.Cells(row, 2).Value
            quantity := sheet.Cells(row, 3).Value
            total := sheet.Cells(row, 4).Value

            report .= product ": $" price " x " quantity " = $" Round(total, 2) "`n"
        }

        ; Calculate grand total
        grandTotal := sheet.Range("D2:D" lastRow).Sum
        report .= "`nGrand Total: $" Round(grandTotal, 2)

        MsgBox(report "`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 4:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 5: Dynamic Cell References
;===============================================================================
Example5_DynamicReferences() {
    MsgBox("Example 5: Dynamic Cell References`n`nUsing variables to build cell references dynamically.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Create a multiplication table using dynamic references
        sheet.Range("A1").Value := "Multiplication Table"

        ; Headers
        Loop 10 {
            sheet.Cells(2, A_Index + 1).Value := A_Index
            sheet.Cells(A_Index + 2, 1).Value := A_Index
        }

        ; Fill in the table
        Loop 10 {
            row := A_Index + 2
            Loop 10 {
                col := A_Index + 1
                sheet.Cells(row, col).Value := (row - 2) * (col - 1)
            }
        }

        ; Format the table
        sheet.Range("B2:K2").Font.Bold := true  ; Header row
        sheet.Range("A3:A12").Font.Bold := true  ; Header column

        ; Add borders
        tableRange := sheet.Range("A2:K12")
        tableRange.Borders.LineStyle := 1  ; xlContinuous

        ; Color code cells based on value
        Loop 10 {
            row := A_Index + 2
            Loop 10 {
                col := A_Index + 1
                value := sheet.Cells(row, col).Value

                ; Color cells based on value ranges
                if (value <= 20)
                    sheet.Cells(row, col).Interior.Color := 0xE0FFE0  ; Light green
                else if (value <= 50)
                    sheet.Cells(row, col).Interior.Color := 0xFFFFE0  ; Light yellow
                else
                    sheet.Cells(row, col).Interior.Color := 0xFFE0E0  ; Light red
            }
        }

        ; Auto-fit columns
        sheet.Columns("A:K").AutoFit()

        MsgBox("Dynamic multiplication table created!`n`nCells are color-coded by value.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 5:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 6: Find and Replace in Cells
;===============================================================================
Example6_FindReplace() {
    MsgBox("Example 6: Find and Replace`n`nSearching for and replacing cell values.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Create sample data
        sheet.Range("A1").Value := "Before Find & Replace"

        Loop 20 {
            sheet.Cells(A_Index + 1, 1).Value := "Item " Mod(A_Index - 1, 3) + 1
            sheet.Cells(A_Index + 1, 2).Value := Random(1, 100)
        }

        MsgBox("Sample data created.`n`nNow we'll find all 'Item 2' and replace with 'Item TWO'")

        ; Find and count occurrences
        searchRange := sheet.Range("A:A")
        found := searchRange.Find("Item 2")

        if (found) {
            count := 0
            firstAddress := found.Address

            ; Count occurrences
            Loop {
                count++
                found := searchRange.FindNext(found)
            } Until (found.Address = firstAddress)

            MsgBox("Found " count " occurrences of 'Item 2'`n`nReplacing now...")

            ; Replace all occurrences
            searchRange.Replace("Item 2", "Item TWO", 2)  ; 2 = xlPart

            MsgBox("Replacement complete!")
        }
        else {
            MsgBox("'Item 2' not found")
        }

        MsgBox("Close Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 6:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 7: Cell Data Types and Validation
;===============================================================================
Example7_DataTypes() {
    MsgBox("Example 7: Data Types`n`nWorking with different data types in cells.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Headers
        sheet.Range("A1").Value := "Data Type"
        sheet.Range("B1").Value := "Value"
        sheet.Range("C1").Value := "Detected Type"

        ; String
        sheet.Cells(2, 1).Value := "String"
        sheet.Cells(2, 2).Value := "Hello World"
        sheet.Cells(2, 3).Value := Type(sheet.Cells(2, 2).Value)

        ; Integer
        sheet.Cells(3, 1).Value := "Integer"
        sheet.Cells(3, 2).Value := 42
        sheet.Cells(3, 3).Value := Type(sheet.Cells(3, 2).Value)

        ; Float
        sheet.Cells(4, 1).Value := "Float"
        sheet.Cells(4, 2).Value := 3.14159
        sheet.Cells(4, 3).Value := Type(sheet.Cells(4, 2).Value)

        ; Date
        sheet.Cells(5, 1).Value := "Date"
        sheet.Cells(5, 2).Value := A_Now
        sheet.Cells(5, 2).NumberFormat := "yyyy-mm-dd"
        sheet.Cells(5, 3).Value := "Date"

        ; Formula
        sheet.Cells(6, 1).Value := "Formula"
        sheet.Cells(6, 2).Formula := "=10+20"
        sheet.Cells(6, 3).Value := sheet.Cells(6, 2).Formula

        ; Boolean (as number)
        sheet.Cells(7, 1).Value := "Boolean"
        sheet.Cells(7, 2).Value := true
        sheet.Cells(7, 3).Value := Type(sheet.Cells(7, 2).Value)

        ; Format the headers
        sheet.Range("A1:C1").Font.Bold := true
        sheet.Columns("A:C").AutoFit()

        MsgBox("Different data types demonstrated!`n`nNotice how Excel handles each type.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 7:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Main Menu
;===============================================================================
ShowMenu() {
    menu := "
    (
    Excel COM - Cell Operations

    Choose an example:

    1. Basic Cell Read/Write
    2. Range Operations
    3. Bulk Data Import
    4. Reading Data
    5. Dynamic References
    6. Find and Replace
    7. Data Types

    0. Exit
    )"

    choice := InputBox(menu, "Excel Cell Examples", "w300 h400").Value

    switch choice {
        case "1": Example1_BasicCellOperations()
        case "2": Example2_RangeOperations()
        case "3": Example3_BulkDataImport()
        case "4": Example4_ReadingData()
        case "5": Example5_DynamicReferences()
        case "6": Example6_FindReplace()
        case "7": Example7_DataTypes()
        case "0": return
        default:
            MsgBox("Invalid choice!")
            return
    }

    result := MsgBox("Run another example?", "Continue?", "YesNo")
    if (result = "Yes")
        ShowMenu()
}

ShowMenu()
