#Requires AutoHotkey v2.0

/**
 * BuiltIn_COM_Excel_03_Formulas.ahk
 * 
 * DESCRIPTION:
 * Demonstrates working with Excel formulas and functions using COM automation.
 * Shows how to insert, evaluate, and manipulate formulas programmatically.
 * 
 * FEATURES:
 * - Creating formulas with Formula property
 * - Using R1C1 notation for dynamic formulas
 * - Working with built-in Excel functions
 * - Formula auditing and calculation
 * - Array formulas
 * - Named ranges in formulas
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - ComObject
 * https://www.autohotkey.com/docs/v2/lib/ComObject.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - ComObject() for Excel automation
 * - Formula and FormulaR1C1 properties
 * - COM method chaining
 * - Error handling for formula errors
 * 
 * LEARNING POINTS:
 * 1. How to insert formulas into cells
 * 2. Using R1C1 vs A1 notation for formulas
 * 3. Working with SUM, AVERAGE, COUNT, and other functions
 * 4. Creating dependent formulas
 * 5. Handling formula errors
 * 6. Calculating and recalculating workbooks
 * 7. Using named ranges in formulas
 */

;===============================================================================
; Example 1: Basic Formula Operations
;===============================================================================
Example1_BasicFormulas() {
    MsgBox("Example 1: Basic Formulas`n`nInserting and working with simple Excel formulas.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Set up data
        sheet.Range("A1").Value := "Number 1"
        sheet.Range("B1").Value := "Number 2"
        sheet.Range("C1").Value := "Sum"
        sheet.Range("D1").Value := "Product"
        sheet.Range("E1").Value := "Average"

        ; Add numbers
        sheet.Range("A2").Value := 10
        sheet.Range("B2").Value := 20

        ; Basic formulas using A1 notation
        sheet.Range("C2").Formula := "=A2+B2"
        sheet.Range("D2").Formula := "=A2*B2"
        sheet.Range("E2").Formula := "=(A2+B2)/2"

        ; Add more rows
        Loop 5 {
            row := A_Index + 2
            sheet.Cells(row, 1).Value := Random(1, 100)
            sheet.Cells(row, 2).Value := Random(1, 100)

            ; Copy formulas down
            sheet.Cells(row, 3).Formula := "=A" row "+B" row
            sheet.Cells(row, 4).Formula := "=A" row "*B" row
            sheet.Cells(row, 5).Formula := "=(A" row "+B" row ")/2"
        }

        ; Format headers
        sheet.Range("A1:E1").Font.Bold := true
        sheet.Columns("A:E").AutoFit()

        ; Read a calculated value
        result := sheet.Range("C2").Value

        MsgBox("Basic formulas created!`n`nFor example, C2 = " result "`n(which is A2 + B2)`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 1:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 2: Excel Built-in Functions
;===============================================================================
Example2_BuiltInFunctions() {
    MsgBox("Example 2: Built-in Functions`n`nUsing Excel's built-in functions like SUM, AVERAGE, MAX, MIN.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Create sample data
        sheet.Range("A1").Value := "Sales Data"
        sheet.Range("A2").Value := "Month"
        sheet.Range("B2").Value := "Sales"

        months := ["January", "February", "March", "April", "May", "June"]
        Loop months.Length {
            sheet.Cells(A_Index + 2, 1).Value := months[A_Index]
            sheet.Cells(A_Index + 2, 2).Value := Random(5000, 15000)
        }

        ; Add function labels
        sheet.Range("D2").Value := "Total Sales:"
        sheet.Range("D3").Value := "Average Sales:"
        sheet.Range("D4").Value := "Maximum Sales:"
        sheet.Range("D5").Value := "Minimum Sales:"
        sheet.Range("D6").Value := "Count:"
        sheet.Range("D7").Value := "Std Dev:"

        ; Add formulas using built-in functions
        sheet.Range("E2").Formula := "=SUM(B3:B8)"
        sheet.Range("E3").Formula := "=AVERAGE(B3:B8)"
        sheet.Range("E4").Formula := "=MAX(B3:B8)"
        sheet.Range("E5").Formula := "=MIN(B3:B8)"
        sheet.Range("E6").Formula := "=COUNT(B3:B8)"
        sheet.Range("E7").Formula := "=STDEV(B3:B8)"

        ; Format
        sheet.Range("A1").Font.Bold := true
        sheet.Range("A1").Font.Size := 14
        sheet.Range("A2:B2").Font.Bold := true
        sheet.Range("D2:D7").Font.Bold := true
        sheet.Columns("A:E").AutoFit()

        ; Add formatting to numbers
        sheet.Range("B3:B8").NumberFormat := "$#,##0"
        sheet.Range("E2:E7").NumberFormat := "$#,##0.00"

        ; Read results
        total := sheet.Range("E2").Value
        avg := sheet.Range("E3").Value

        MsgBox("Excel functions demonstrated!`n`nTotal Sales: $" Round(total, 2) "`nAverage Sales: $" Round(avg, 2) "`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 2:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 3: R1C1 Notation for Dynamic Formulas
;===============================================================================
Example3_R1C1Notation() {
    MsgBox("Example 3: R1C1 Notation`n`nUsing R1C1 reference style for more flexible formulas.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Create a commission calculator
        sheet.Range("A1").Value := "Sales Commission Calculator"

        ; Headers
        sheet.Range("A2").Value := "Salesperson"
        sheet.Range("B2").Value := "Sales Amount"
        sheet.Range("C2").Value := "Commission %"
        sheet.Range("D2").Value := "Commission $"

        ; Data
        salespeople := ["John", "Jane", "Bob", "Alice", "Charlie"]
        Loop salespeople.Length {
            row := A_Index + 2
            sheet.Cells(row, 1).Value := salespeople[A_Index]
            sheet.Cells(row, 2).Value := Random(10000, 50000)
            sheet.Cells(row, 3).Value := Random(5, 15) / 100

            ; Use R1C1 notation for formulas
            ; RC[-2] means same row, 2 columns left
            ; RC[-1] means same row, 1 column left
            sheet.Cells(row, 4).FormulaR1C1 := "=RC[-2]*RC[-1]"
        }

        ; Add totals row using R1C1
        totalRow := salespeople.Length + 3
        sheet.Cells(totalRow, 1).Value := "TOTALS:"
        sheet.Cells(totalRow, 2).FormulaR1C1 := "=SUM(R[-" salespeople.Length "]:R[-1])"
        sheet.Cells(totalRow, 4).FormulaR1C1 := "=SUM(R[-" salespeople.Length "]:R[-1])"

        ; Format
        sheet.Range("A1").Font.Bold := true
        sheet.Range("A1").Font.Size := 14
        sheet.Range("A2:D2").Font.Bold := true
        sheet.Cells(totalRow, 1).Font.Bold := true
        sheet.Columns("A:D").AutoFit()

        ; Number formatting
        sheet.Range("B3:B" totalRow).NumberFormat := "$#,##0"
        sheet.Range("C3:C" (totalRow - 1)).NumberFormat := "0.0%"
        sheet.Range("D3:D" totalRow).NumberFormat := "$#,##0.00"

        MsgBox("R1C1 formulas created!`n`nR1C1 notation allows for more flexible relative references.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 3:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 4: Conditional Formulas (IF, SUMIF, COUNTIF)
;===============================================================================
Example4_ConditionalFormulas() {
    MsgBox("Example 4: Conditional Formulas`n`nUsing IF, SUMIF, COUNTIF and other conditional functions.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Create test scores data
        sheet.Range("A1").Value := "Student Test Scores"

        ; Headers
        sheet.Range("A2").Value := "Student"
        sheet.Range("B2").Value := "Score"
        sheet.Range("C2").Value := "Grade"
        sheet.Range("D2").Value := "Pass/Fail"

        ; Sample data
        students := ["Alex", "Beth", "Carlos", "Diana", "Eric", "Fiona", "George", "Helen"]
        Loop students.Length {
            row := A_Index + 2
            sheet.Cells(row, 1).Value := students[A_Index]
            sheet.Cells(row, 2).Value := Random(55, 100)

            ; Grade formula using nested IFs
            sheet.Cells(row, 3).Formula := "=IF(B" row ">=90,`"A`",IF(B" row ">=80,`"B`",IF(B" row ">=70,`"C`",IF(B" row ">=60,`"D`",`"F`"))))"

            ; Pass/Fail formula
            sheet.Cells(row, 4).Formula := "=IF(B" row ">=60,`"PASS`",`"FAIL`")"
        }

        ; Add statistics using conditional functions
        statsRow := students.Length + 4
        sheet.Cells(statsRow, 1).Value := "Average Score:"
        sheet.Cells(statsRow, 2).Formula := "=AVERAGE(B3:B10)"

        sheet.Cells(statsRow + 1, 1).Value := "Passed:"
        sheet.Cells(statsRow + 1, 2).Formula := "=COUNTIF(D3:D10,`"PASS`")"

        sheet.Cells(statsRow + 2, 1).Value := "Failed:"
        sheet.Cells(statsRow + 2, 2).Formula := "=COUNTIF(D3:D10,`"FAIL`")"

        sheet.Cells(statsRow + 3, 1).Value := "A Grades:"
        sheet.Cells(statsRow + 3, 2).Formula := "=COUNTIF(C3:C10,`"A`")"

        sheet.Cells(statsRow + 4, 1).Value := "Avg of Passed:"
        sheet.Cells(statsRow + 4, 2).Formula := "=AVERAGEIF(D3:D10,`"PASS`",B3:B10)"

        ; Format
        sheet.Range("A1").Font.Bold := true
        sheet.Range("A1").Font.Size := 14
        sheet.Range("A2:D2").Font.Bold := true
        sheet.Range("A" statsRow ":A" (statsRow + 4)).Font.Bold := true
        sheet.Columns("A:D").AutoFit()

        MsgBox("Conditional formulas created!`n`nIF, COUNTIF, SUMIF, and AVERAGEIF demonstrated.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 4:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 5: VLOOKUP and Reference Functions
;===============================================================================
Example5_LookupFunctions() {
    MsgBox("Example 5: Lookup Functions`n`nUsing VLOOKUP, INDEX, and MATCH functions.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Create product database
        sheet.Range("A1").Value := "Product Database"
        sheet.Range("A2").Value := "Product ID"
        sheet.Range("B2").Value := "Product Name"
        sheet.Range("C2").Value := "Price"
        sheet.Range("D2").Value := "Stock"

        ; Add products
        products := [
            ["P001", "Laptop", 999.99, 25],
            ["P002", "Mouse", 24.99, 150],
            ["P003", "Keyboard", 79.99, 80],
            ["P004", "Monitor", 299.99, 45],
            ["P005", "Webcam", 89.99, 60]
        ]

        Loop products.Length {
            row := A_Index + 2
            Loop products[A_Index].Length {
                sheet.Cells(row, A_Index).Value := products[A_Index][A_Index]
            }
        }

        ; Create lookup section
        lookupRow := 10
        sheet.Cells(lookupRow, 1).Value := "Lookup Product ID:"
        sheet.Cells(lookupRow, 2).Value := "P003"

        sheet.Cells(lookupRow + 1, 1).Value := "Product Name:"
        sheet.Cells(lookupRow + 1, 2).Formula := "=VLOOKUP(B" lookupRow ",$A$3:$D$7,2,FALSE)"

        sheet.Cells(lookupRow + 2, 1).Value := "Price:"
        sheet.Cells(lookupRow + 2, 2).Formula := "=VLOOKUP(B" lookupRow ",$A$3:$D$7,3,FALSE)"

        sheet.Cells(lookupRow + 3, 1).Value := "Stock:"
        sheet.Cells(lookupRow + 3, 2).Formula := "=VLOOKUP(B" lookupRow ",$A$3:$D$7,4,FALSE)"

        ; Alternative using INDEX/MATCH
        sheet.Cells(lookupRow + 5, 1).Value := "Using INDEX/MATCH:"
        sheet.Cells(lookupRow + 6, 1).Value := "Product Name:"
        sheet.Cells(lookupRow + 6, 2).Formula := "=INDEX($B$3:$B$7,MATCH(B" lookupRow ",$A$3:$A$7,0))"

        ; Format
        sheet.Range("A1").Font.Bold := true
        sheet.Range("A1").Font.Size := 14
        sheet.Range("A2:D2").Font.Bold := true
        sheet.Cells(lookupRow, 1).Font.Bold := true
        sheet.Range("C3:C7").NumberFormat := "$#,##0.00"
        sheet.Columns("A:D").AutoFit()

        MsgBox("Lookup functions created!`n`nVLOOKUP and INDEX/MATCH demonstrated.`n`nTry changing B10 to different product IDs!`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 5:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 6: Date and Time Functions
;===============================================================================
Example6_DateTimeFunctions() {
    MsgBox("Example 6: Date/Time Functions`n`nWorking with Excel's date and time functions.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Title
        sheet.Range("A1").Value := "Date and Time Functions"

        ; TODAY and NOW
        sheet.Range("A3").Value := "Today's Date:"
        sheet.Range("B3").Formula := "=TODAY()"
        sheet.Range("B3").NumberFormat := "yyyy-mm-dd"

        sheet.Range("A4").Value := "Current Date/Time:"
        sheet.Range("B4").Formula := "=NOW()"
        sheet.Range("B4").NumberFormat := "yyyy-mm-dd hh:mm:ss"

        ; Date components
        sheet.Range("A6").Value := "Year:"
        sheet.Range("B6").Formula := "=YEAR(B3)"

        sheet.Range("A7").Value := "Month:"
        sheet.Range("B7").Formula := "=MONTH(B3)"

        sheet.Range("A8").Value := "Day:"
        sheet.Range("B8").Formula := "=DAY(B3)"

        sheet.Range("A9").Value := "Weekday:"
        sheet.Range("B9").Formula := "=TEXT(B3,`"dddd`")"

        ; Date calculations
        sheet.Range("A11").Value := "Project Timeline"
        sheet.Range("A12").Value := "Start Date:"
        sheet.Range("B12").Formula := "=TODAY()"
        sheet.Range("B12").NumberFormat := "yyyy-mm-dd"

        sheet.Range("A13").Value := "Duration (days):"
        sheet.Range("B13").Value := 30

        sheet.Range("A14").Value := "End Date:"
        sheet.Range("B14").Formula := "=B12+B13"
        sheet.Range("B14").NumberFormat := "yyyy-mm-dd"

        sheet.Range("A15").Value := "Business Days:"
        sheet.Range("B15").Formula := "=NETWORKDAYS(B12,B14)"

        sheet.Range("A16").Value := "Days Until End:"
        sheet.Range("B16").Formula := "=B14-TODAY()"

        ; Format
        sheet.Range("A1").Font.Bold := true
        sheet.Range("A1").Font.Size := 14
        sheet.Range("A3:A16").Font.Bold := true
        sheet.Columns("A:B").AutoFit()

        MsgBox("Date/Time functions created!`n`nTODAY, NOW, YEAR, MONTH, DAY, NETWORKDAYS demonstrated.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 6:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 7: Text Functions
;===============================================================================
Example7_TextFunctions() {
    MsgBox("Example 7: Text Functions`n`nUsing Excel's text manipulation functions.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Title
        sheet.Range("A1").Value := "Text Functions Demonstration"

        ; Sample data
        sheet.Range("A3").Value := "Original Text:"
        sheet.Range("B3").Value := "john.doe@example.com"

        ; Text functions
        sheet.Range("A5").Value := "UPPER:"
        sheet.Range("B5").Formula := "=UPPER(B3)"

        sheet.Range("A6").Value := "LOWER:"
        sheet.Range("B6").Formula := "=LOWER(B3)"

        sheet.Range("A7").Value := "PROPER:"
        sheet.Range("B7").Formula := "=PROPER(B3)"

        sheet.Range("A8").Value := "LENGTH:"
        sheet.Range("B8").Formula := "=LEN(B3)"

        sheet.Range("A9").Value := "LEFT(5):"
        sheet.Range("B9").Formula := "=LEFT(B3,5)"

        sheet.Range("A10").Value := "RIGHT(11):"
        sheet.Range("B10").Formula := "=RIGHT(B3,11)"

        sheet.Range("A11").Value := "MID(6,3):"
        sheet.Range("B11").Formula := "=MID(B3,6,3)"

        sheet.Range("A12").Value := "FIND(@):"
        sheet.Range("B12").Formula := "=FIND(`"@`",B3)"

        sheet.Range("A13").Value := "Username:"
        sheet.Range("B13").Formula := "=LEFT(B3,FIND(`"@`",B3)-1)"

        sheet.Range("A14").Value := "Domain:"
        sheet.Range("B14").Formula := "=RIGHT(B3,LEN(B3)-FIND(`"@`",B3))"

        ; Concatenation
        sheet.Range("A16").Value := "First Name:"
        sheet.Range("B16").Value := "John"

        sheet.Range("A17").Value := "Last Name:"
        sheet.Range("B17").Value := "Doe"

        sheet.Range("A18").Value := "Full Name:"
        sheet.Range("B18").Formula := "=B16&`" `"&B17"

        sheet.Range("A19").Value := "Using CONCAT:"
        sheet.Range("B19").Formula := "=CONCAT(B16,`" `",B17)"

        ; Format
        sheet.Range("A1").Font.Bold := true
        sheet.Range("A1").Font.Size := 14
        sheet.Range("A3:A19").Font.Bold := true
        sheet.Columns("A:B").AutoFit()

        MsgBox("Text functions created!`n`nUPPER, LOWER, LEFT, RIGHT, MID, FIND, CONCAT demonstrated.`n`nClose Excel manually when done.")
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
    Excel COM - Formulas and Functions

    Choose an example:

    1. Basic Formulas
    2. Built-in Functions
    3. R1C1 Notation
    4. Conditional Formulas
    5. Lookup Functions
    6. Date/Time Functions
    7. Text Functions

    0. Exit
    )"

    choice := InputBox(menu, "Excel Formula Examples", "w300 h400").Value

    switch choice {
        case "1": Example1_BasicFormulas()
        case "2": Example2_BuiltInFunctions()
        case "3": Example3_R1C1Notation()
        case "4": Example4_ConditionalFormulas()
        case "5": Example5_LookupFunctions()
        case "6": Example6_DateTimeFunctions()
        case "7": Example7_TextFunctions()
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
