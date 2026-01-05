#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * GitHub_COM_01_Excel_CreateWorkbook.ahk
 * 
 * DESCRIPTION:
 * Creates and manipulates Excel workbooks using COM automation
 * 
 * FEATURES:
 * - Launch Excel application
 * - Create new workbook
 * - Write data to cells
 * - Format cells and ranges
 * - Save and close workbook
 * 
 * SOURCE:
 * Based on common Excel COM automation patterns
 * Reference: Microsoft Excel Object Model
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - ComObject() for creating COM instances
 * - COM property access (obj.Property)
 * - COM method calls (obj.Method())
 * - Nested COM objects (Excel.Workbooks.Add)
 * - Try/finally for cleanup
 * 
 * REQUIREMENTS:
 * - Microsoft Excel installed
 * 
 * USAGE:
 * CreateExcelReport()
 * 
 * LEARNING POINTS:
 * 1. ComObject("Excel.Application") creates Excel instance
 * 2. Visible property controls if Excel window shows
 * 3. Workbooks.Add creates new workbook
 * 4. Cells(row, col) accesses individual cells
 * 5. SaveAs requires full file path
 */

/**
 * Create a simple Excel workbook with sample data
 * 
 * @param {String} savePath - Full path to save workbook
 * @param {Boolean} visible - Show Excel window (default: true)
 * @returns {Boolean} - Success status
 * 
 * @example
 * CreateExcelWorkbook("C:\Reports\MyReport.xlsx")
 */
CreateExcelWorkbook(savePath := "", visible := true) {
    try {
        ; Create Excel application instance
        xl := ComObject("Excel.Application")
        xl.Visible := visible  ; Show/hide Excel window

        ; Add new workbook
        wb := xl.Workbooks.Add()
        ws := wb.Worksheets(1)  ; Get first worksheet

        ; Write headers
        ws.Cells(1, 1).Value := "Name"
        ws.Cells(1, 2).Value := "Age"
        ws.Cells(1, 3).Value := "City"

        ; Format headers (bold)
        ws.Range("A1:C1").Font.Bold := true

        ; Write sample data
        ws.Cells(2, 1).Value := "John Doe"
        ws.Cells(2, 2).Value := 30
        ws.Cells(2, 3).Value := "New York"

        ws.Cells(3, 1).Value := "Jane Smith"
        ws.Cells(3, 2).Value := 25
        ws.Cells(3, 3).Value := "Los Angeles"

        ws.Cells(4, 1).Value := "Bob Johnson"
        ws.Cells(4, 2).Value := 35
        ws.Cells(4, 3).Value := "Chicago"

        ; Auto-fit columns
        ws.Columns("A:C").AutoFit()

        ; Save workbook if path provided
        if (savePath != "") {
            wb.SaveAs(savePath)
            MsgBox("Workbook saved to:`n" savePath, "Success", "Icon!")
        } else {
            MsgBox("Workbook created but not saved.`nPlease save manually.", "Info", "Icon!")
        }

        ; Keep Excel open if visible
        if (!visible) {
            wb.Close(false)  ; Close without saving
            xl.Quit()
        }

        return true

    } catch as err {
        MsgBox("Error creating workbook:`n" err.Message, "Error", "Icon!")
        try xl.Quit()  ; Cleanup on error
        return false
    }
}

; ============================================================
; Example 1: Create Simple Workbook
; ============================================================

; Create and save workbook
; Uncomment to test:
; savePath := A_Desktop "\TestWorkbook.xlsx"
; CreateExcelWorkbook(savePath, true)

MsgBox("Example 1: Create workbook with sample data`n`n"
    . "Uncomment the code to test Excel creation",
    "Excel Example 1", "Icon!")

; ============================================================
; Example 2: Write Array Data to Excel
; ============================================================

/**
 * Write 2D array data to Excel
 * 
 * @param {Array} data - 2D array of data
 * @param {String} savePath - Path to save
 * @returns {Boolean} - Success
 */
WriteArrayToExcel(data, savePath := "") {
    try {
        xl := ComObject("Excel.Application")
        xl.Visible := true

        wb := xl.Workbooks.Add()
        ws := wb.Worksheets(1)

        ; Write array data
        for rowIndex, row in data {
            for colIndex, value in row {
                ws.Cells(rowIndex, colIndex).Value := value
            }
        }

        ; Format first row as headers
        ws.Range("A1:Z1").Font.Bold := true
        ws.Columns("A:Z").AutoFit()

        if (savePath != "")
            wb.SaveAs(savePath)

        return true

    } catch as err {
        MsgBox("Error: " err.Message, "Error", "Icon!")
        try xl.Quit()
        return false
    }
}

; Example data
sampleData := [
    ["Product", "Price", "Quantity", "Total"],
    ["Widget A", 10.50, 100, 1050.00],
    ["Widget B", 15.75, 75, 1181.25],
    ["Widget C", 8.25, 150, 1237.50]
]

; Uncomment to test:
; WriteArrayToExcel(sampleData, A_Desktop "\ProductReport.xlsx")

; ============================================================
; Example 3: Read Data from Existing Excel
; ============================================================

/**
 * Read data from Excel file
 * 
 * @param {String} filePath - Path to Excel file
 * @param {String} sheetName - Worksheet name (default: first sheet)
 * @param {Number} maxRows - Maximum rows to read (default: 100)
 * @returns {Array} - 2D array of cell values
 */
ReadExcelData(filePath, sheetName := "", maxRows := 100) {
    data := []

    try {
        xl := ComObject("Excel.Application")
        xl.Visible := false

        wb := xl.Workbooks.Open(filePath)

        ; Get worksheet
        if (sheetName = "")
            ws := wb.Worksheets(1)
        else
            ws := wb.Worksheets(sheetName)

        ; Find last used row
        lastRow := ws.UsedRange.Rows.Count
        lastCol := ws.UsedRange.Columns.Count

        ; Limit rows
        lastRow := Min(lastRow, maxRows)

        ; Read data
        Loop lastRow {
            row := []
            rowNum := A_Index

            Loop lastCol {
                colNum := A_Index
                value := ws.Cells(rowNum, colNum).Value
                row.Push(value ?? "")  ; Use empty string for null
            }

            data.Push(row)
        }

        wb.Close(false)
        xl.Quit()

        return data

    } catch as err {
        MsgBox("Error reading Excel:`n" err.Message, "Error", "Icon!")
        try {
            wb.Close(false)
            xl.Quit()
        }
        return []
    }
}

; ============================================================
; Example 4: Excel Formatting
; ============================================================

/**
 * Create formatted Excel report
 * 
 * @param {String} savePath - Save location
 */
CreateFormattedReport(savePath) {
    try {
        xl := ComObject("Excel.Application")
        xl.Visible := true

        wb := xl.Workbooks.Add()
        ws := wb.Worksheets(1)

        ; Set worksheet name
        ws.Name := "Sales Report"

        ; Title
        ws.Cells(1, 1).Value := "Monthly Sales Report"
        ws.Range("A1:D1").Merge()
        ws.Range("A1").Font.Size := 16
        ws.Range("A1").Font.Bold := true
        ws.Range("A1").HorizontalAlignment := -4108  ; xlCenter

        ; Headers
        ws.Cells(3, 1).Value := "Month"
        ws.Cells(3, 2).Value := "Sales"
        ws.Cells(3, 3).Value := "Expenses"
        ws.Cells(3, 4).Value := "Profit"

        ; Header formatting
        ws.Range("A3:D3").Font.Bold := true
        ws.Range("A3:D3").Interior.Color := 0xD3D3D3  ; Light gray

        ; Data
        months := ["January", "February", "March"]
        sales := [50000, 55000, 60000]
        expenses := [30000, 32000, 35000]

        Loop 3 {
            row := A_Index + 3
            ws.Cells(row, 1).Value := months[A_Index]
            ws.Cells(row, 2).Value := sales[A_Index]
            ws.Cells(row, 3).Value := expenses[A_Index]
            ; Formula for profit
            ws.Cells(row, 4).Formula := "=B" row "-C" row
        }

        ; Number formatting (currency)
        ws.Range("B4:D6").NumberFormat := "$#,##0.00"

        ; Auto-fit
        ws.Columns("A:D").AutoFit()

        ; Add borders
        ws.Range("A3:D6").Borders.LineStyle := 1  ; Continuous

        if (savePath != "")
            wb.SaveAs(savePath)

        return true

    } catch as err {
        MsgBox("Error: " err.Message, "Error", "Icon!")
        try xl.Quit()
        return false
    }
}

; Uncomment to test:
; CreateFormattedReport(A_Desktop "\SalesReport.xlsx")

; ============================================================
; Example 5: Excel Constants Reference
; ============================================================

info := "
(
COMMON EXCEL COM CONSTANTS:

Alignment:
xlLeft = -4131
xlCenter = -4108
xlRight = -4152

Border Styles:
xlContinuous = 1
xlDash = -4115
xlDot = -4118

Colors (RGB):
0xFFFFFF = White
0x000000 = Black
0xFF0000 = Red
0x00FF00 = Green
0x0000FF = Blue

File Formats:
xlWorkbookDefault = 51
xlOpenXMLWorkbook = 51 (.xlsx)
xlExcel8 = 56 (.xls)

Number Formats:
General: "General"
Currency: "$#,##0.00"
Percentage: "0.00%"
Date: "mm/dd/yyyy"

Excel Object Hierarchy:
Application
└─ Workbooks
└─ Workbook
└─ Worksheets
└─ Worksheet
└─ Range/Cells
)"

MsgBox(info, "Excel COM Reference", "Icon!")
