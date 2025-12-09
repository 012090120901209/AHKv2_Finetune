#Requires AutoHotkey v2.0

/**
* BuiltIn_COM_Excel_01_BasicUsage.ahk
*
* DESCRIPTION:
* Demonstrates basic Microsoft Excel automation using COM objects in AutoHotkey v2.
* Covers fundamental operations like opening Excel, creating workbooks, saving, and closing.
*
* FEATURES:
* - Creating Excel COM objects
* - Opening and creating workbooks
* - Saving workbooks in various formats
* - Closing Excel properly
* - Error handling for COM operations
* - Visibility control and user interaction
*
* SOURCE:
* AutoHotkey v2 Documentation - ComObject
* https://www.autohotkey.com/docs/v2/lib/ComObject.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - ComObject() function for creating COM instances
* - COM method calls and property access
* - Try/Catch error handling for COM operations
* - Proper cleanup with object := ""
*
* LEARNING POINTS:
* 1. How to create and connect to Excel using ComObject()
* 2. Making Excel visible or hidden for background operations
* 3. Creating new workbooks and opening existing ones
* 4. Saving workbooks with different file formats
* 5. Proper cleanup to prevent Excel processes from staying in memory
* 6. Error handling for COM operations that might fail
* 7. Controlling Excel's display alerts and screen updating
*/

;===============================================================================
; Example 1: Creating Excel Instance and Making it Visible
;===============================================================================
Example1_CreateExcelInstance() {
    MsgBox("Example 1: Creating Excel Instance`n`nThis example creates an Excel instance and makes it visible.")

    Try {
        ; Create new Excel instance
        xl := ComObject("Excel.Application")

        ; Make Excel visible to the user
        xl.Visible := true

        MsgBox("Excel has been launched and is now visible.`n`nCheck your taskbar!")

        ; Wait a moment to see Excel
        Sleep(2000)

        ; Close Excel
        xl.Quit()

        ; Clean up the COM object
        xl := ""

        MsgBox("Example 1 Complete!`n`nExcel was created, made visible, and then closed.")
    }
    Catch as err {
        MsgBox("Error in Example 1:`n" err.Message)
    }
}

;===============================================================================
; Example 2: Creating a New Workbook
;===============================================================================
Example2_CreateWorkbook() {
    MsgBox("Example 2: Creating a New Workbook`n`nThis example creates Excel with a new workbook.")

    Try {
        ; Create Excel instance (invisible by default)
        xl := ComObject("Excel.Application")

        ; Create a new workbook
        workbook := xl.Workbooks.Add()

        ; Get the active sheet
        sheet := workbook.ActiveSheet

        ; Add some data to verify it worked
        sheet.Range("A1").Value := "New Workbook Created!"
        sheet.Range("A2").Value := "Created at: " FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")

        ; Make Excel visible to show the result
        xl.Visible := true

        MsgBox("A new workbook has been created with sample data.`n`nClose Excel manually when done.")

        ; Note: We're not closing Excel here to let user see the result
        ; In production code, you would close it
    }
    Catch as err {
        MsgBox("Error in Example 2:`n" err.Message)
        if (IsSet(xl))
        xl.Quit()
    }
}

;===============================================================================
; Example 3: Opening an Existing Workbook
;===============================================================================
Example3_OpenWorkbook() {
    MsgBox("Example 3: Opening an Existing Workbook`n`nThis example will create a test file and then reopen it.")

    Try {
        ; Create a test file first
        xl := ComObject("Excel.Application")
        workbook := xl.Workbooks.Add()

        ; Add some test data
        sheet := workbook.ActiveSheet
        sheet.Range("A1").Value := "Test Workbook"
        sheet.Range("A2").Value := "This file was created for testing"

        ; Save the file to a temp location
        testFile := A_Temp "\AHK_Test_Workbook.xlsx"
        workbook.SaveAs(testFile)

        ; Close the workbook
        workbook.Close()
        xl.Quit()
        xl := ""

        MsgBox("Test file created at:`n" testFile "`n`nNow opening it...")

        ; Now open the file we just created
        xl := ComObject("Excel.Application")
        xl.Visible := true

        ; Open the workbook
        workbook := xl.Workbooks.Open(testFile)

        ; Read a value to verify it opened correctly
        value := workbook.ActiveSheet.Range("A1").Value

        MsgBox("File opened successfully!`n`nValue in A1: " value "`n`nClose Excel manually when done.")

        ; Clean up happens when user closes Excel manually
    }
    Catch as err {
        MsgBox("Error in Example 3:`n" err.Message)
        if (IsSet(xl))
        xl.Quit()
    }
}

;===============================================================================
; Example 4: Saving Workbooks in Different Formats
;===============================================================================
Example4_SaveFormats() {
    MsgBox("Example 4: Saving in Different Formats`n`nThis example saves workbooks in XLSX, CSV, and XLS formats.")

    Try {
        xl := ComObject("Excel.Application")
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Add sample data
        sheet.Range("A1").Value := "Product"
        sheet.Range("B1").Value := "Price"
        sheet.Range("A2").Value := "Widget"
        sheet.Range("B2").Value := 19.99
        sheet.Range("A3").Value := "Gadget"
        sheet.Range("B3").Value := 29.99

        ; Create output directory
        outputDir := A_Temp "\AHK_Excel_Formats"
        if !DirExist(outputDir)
        DirCreate(outputDir)

        ; Save as XLSX (Excel 2007-2019 format, FileFormat = 51)
        xlsxFile := outputDir "\test_data.xlsx"
        workbook.SaveAs(xlsxFile, 51)

        ; Save as CSV (FileFormat = 6)
        csvFile := outputDir "\test_data.csv"
        workbook.SaveAs(csvFile, 6)

        ; Save as XLS (Excel 97-2003 format, FileFormat = 56)
        xlsFile := outputDir "\test_data.xls"
        workbook.SaveAs(xlsFile, 56)

        ; Close without saving again
        workbook.Close(false)
        xl.Quit()
        xl := ""

        result := "Files saved successfully:`n`n"
        result .= "XLSX: " xlsxFile "`n"
        result .= "CSV:  " csvFile "`n"
        result .= "XLS:  " xlsFile

        MsgBox(result)
    }
    Catch as err {
        MsgBox("Error in Example 4:`n" err.Message)
        if (IsSet(xl)) {
            Try xl.Quit()
        }
        xl := ""
    }
}

;===============================================================================
; Example 5: Background Processing (Invisible Excel)
;===============================================================================
Example5_BackgroundProcessing() {
    MsgBox("Example 5: Background Processing`n`nThis example processes data in Excel without showing the window.")

    Try {
        ; Create Excel instance (invisible)
        xl := ComObject("Excel.Application")
        xl.Visible := false  ; Keep Excel hidden
        xl.DisplayAlerts := false  ; Suppress alerts
        xl.ScreenUpdating := false  ; Speed up processing

        ; Create workbook
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Simulate data processing
        MsgBox("Processing data in background...`n`nThis will take a few seconds.")

        ; Add 100 rows of data
        Loop 100 {
            sheet.Cells(A_Index, 1).Value := "Item " A_Index
            sheet.Cells(A_Index, 2).Value := Random(1, 1000)
            sheet.Cells(A_Index, 3).Value := Random(1, 100)
        }

        ; Add totals
        sheet.Cells(101, 1).Value := "Total:"
        sheet.Cells(101, 2).Formula := "=SUM(B1:B100)"
        sheet.Cells(101, 3).Formula := "=SUM(C1:C100)"

        ; Save the file
        outputFile := A_Temp "\AHK_Background_Processing.xlsx"
        workbook.SaveAs(outputFile)

        ; Close Excel
        workbook.Close()
        xl.Quit()
        xl := ""

        MsgBox("Background processing complete!`n`nFile saved to:`n" outputFile "`n`n100 rows of data processed.")
    }
    Catch as err {
        MsgBox("Error in Example 5:`n" err.Message)
        if (IsSet(xl)) {
            Try xl.Quit()
        }
        xl := ""
    }
}

;===============================================================================
; Example 6: Proper Error Handling and Cleanup
;===============================================================================
Example6_ErrorHandling() {
    MsgBox("Example 6: Error Handling`n`nThis example demonstrates proper error handling for COM operations.")

    xl := ""
    workbook := ""

    Try {
        ; Create Excel
        xl := ComObject("Excel.Application")

        ; Try to open a non-existent file (will cause error)
        Try {
            workbook := xl.Workbooks.Open("C:\NonExistent\File.xlsx")
        }
        Catch as err {
            MsgBox("Expected Error: Could not open file`n`nError: " err.Message "`n`nContinuing with new workbook...")
        }

        ; If that failed, create a new workbook instead
        if (!IsSet(workbook) || workbook = "") {
            workbook := xl.Workbooks.Add()
        }

        ; Add some data
        sheet := workbook.ActiveSheet
        sheet.Range("A1").Value := "Error Handling Example"
        sheet.Range("A2").Value := "This workbook was created after handling an error"

        ; Save the file
        outputFile := A_Temp "\AHK_Error_Handling.xlsx"
        workbook.SaveAs(outputFile)

        MsgBox("Error handling successful!`n`nDespite the error, we created a new workbook:`n" outputFile)
    }
    Catch as err {
        MsgBox("Unexpected Error in Example 6:`n" err.Message)
    }
    Finally {
        ; Always clean up, even if there was an error
        if (IsSet(workbook) && workbook != "") {
            Try workbook.Close(false)
        }
        if (IsSet(xl) && xl != "") {
            Try xl.Quit()
        }
        xl := ""
        workbook := ""
        MsgBox("Cleanup complete. Excel has been closed.")
    }
}

;===============================================================================
; Example 7: Working with Multiple Workbooks
;===============================================================================
Example7_MultipleWorkbooks() {
    MsgBox("Example 7: Multiple Workbooks`n`nThis example works with multiple workbooks simultaneously.")

    Try {
        ; Create Excel instance
        xl := ComObject("Excel.Application")
        xl.Visible := true

        ; Create first workbook
        wb1 := xl.Workbooks.Add()
        wb1.ActiveSheet.Name := "Sales_Data"
        wb1.ActiveSheet.Range("A1").Value := "Sales Report"
        wb1.ActiveSheet.Range("A2").Value := 1000
        wb1.ActiveSheet.Range("A3").Value := 1500

        ; Create second workbook
        wb2 := xl.Workbooks.Add()
        wb2.ActiveSheet.Name := "Expenses_Data"
        wb2.ActiveSheet.Range("A1").Value := "Expenses Report"
        wb2.ActiveSheet.Range("A2").Value := 500
        wb2.ActiveSheet.Range("A3").Value := 750

        ; Create third workbook for summary
        wb3 := xl.Workbooks.Add()
        wb3.ActiveSheet.Name := "Summary"
        wb3.ActiveSheet.Range("A1").Value := "Combined Summary"
        wb3.ActiveSheet.Range("A2").Value := "This workbook could combine data from the other two"

        ; Show count of workbooks
        count := xl.Workbooks.Count

        MsgBox("Created " count " workbooks!`n`n1. Sales_Data`n2. Expenses_Data`n3. Summary`n`nClose Excel manually when done.")

        ; Note: Not closing Excel so user can see the workbooks
    }
    Catch as err {
        MsgBox("Error in Example 7:`n" err.Message)
        if (IsSet(xl))
        xl.Quit()
    }
}

;===============================================================================
; Main Menu to Run Examples
;===============================================================================
ShowMenu() {
    menu := "
    (
    Excel COM - Basic Usage Examples

    Choose an example to run:

    1. Create Excel Instance (Basic)
    2. Create New Workbook
    3. Open Existing Workbook
    4. Save in Different Formats
    5. Background Processing
    6. Error Handling
    7. Multiple Workbooks

    0. Exit
    )"

    choice := InputBox(menu, "Excel COM Examples", "w300 h400").Value

    switch choice {
        case "1": Example1_CreateExcelInstance()
        case "2": Example2_CreateWorkbook()
        case "3": Example3_OpenWorkbook()
        case "4": Example4_SaveFormats()
        case "5": Example5_BackgroundProcessing()
        case "6": Example6_ErrorHandling()
        case "7": Example7_MultipleWorkbooks()
        case "0": return
        default:
        MsgBox("Invalid choice!")
        return
    }

    ; Ask if user wants to see another example
    result := MsgBox("Run another example?", "Continue?", "YesNo")
    if (result = "Yes")
    ShowMenu()
}

; Run the menu
ShowMenu()
