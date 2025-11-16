#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * FileAppend - CSV File Operations
 * ============================================================================
 *
 * Demonstrates CSV file creation and appending:
 * - Creating CSV files with headers
 * - Appending CSV rows
 * - Handling quoted values and special characters
 * - Generating reports in CSV format
 * - CSV data export
 * - Batch CSV operations
 *
 * @description CSV file operations using FileAppend
 * @author AutoHotkey Foundation
 * @version 1.0.0
 * @see https://www.autohotkey.com/docs/v2/lib/FileAppend.htm
 */

; ============================================================================
; Example 1: Creating Basic CSV Files
; ============================================================================

Example1_BasicCSV() {
    csvFile := A_Temp "\basic_data.csv"

    try {
        ; Delete existing file
        FileDelete(csvFile)

        ; Write CSV header
        FileAppend("ID,Name,Age,City`n", csvFile)

        ; Append data rows
        FileAppend("1,John Doe,30,New York`n", csvFile)
        FileAppend("2,Jane Smith,25,Los Angeles`n", csvFile)
        FileAppend("3,Bob Johnson,35,Chicago`n", csvFile)
        FileAppend("4,Alice Brown,28,Houston`n", csvFile)

        ; Read and display
        content := FileRead(csvFile)
        MsgBox("CSV File Created:`n`n" content, "Basic CSV")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(csvFile)
    }
}

; ============================================================================
; Example 2: CSV with Quoted Values
; ============================================================================

Example2_QuotedCSV() {
    csvFile := A_Temp "\quoted_data.csv"

    try {
        FileDelete(csvFile)

        ; Create CSV helper
        CSVRow := (values*) {
            row := ""
            for value in values {
                ; Quote if contains comma, quote, or newline
                if InStr(value, ",") || InStr(value, "`"") || InStr(value, "`n") {
                    value := "`"" StrReplace(value, "`"", "`"`"") "`""
                }
                row .= value ","
            }
            return SubStr(row, 1, -1) "`n"  ; Remove trailing comma
        }

        ; Write header
        FileAppend(CSVRow("ID", "Name", "Company", "Notes"), csvFile)

        ; Write data with special characters
        FileAppend(CSVRow("1", "John Doe", "ABC, Inc.", "Works in sales"), csvFile)
        FileAppend(CSVRow("2", "Jane Smith", "XYZ Corp", "Department: R&D"), csvFile)
        FileAppend(CSVRow("3", "Bob Johnson", "Tech `"Solutions`"", "CEO"), csvFile)
        FileAppend(CSVRow("4", "Alice Brown", "Data Corp", "Multi-line`nnote here"), csvFile)

        ; Display
        content := FileRead(csvFile)
        MsgBox("CSV with Quoted Values:`n`n" content, "Quoted CSV")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(csvFile)
    }
}

; ============================================================================
; Example 3: Building CSV from Arrays
; ============================================================================

Example3_ArrayToCSV() {
    csvFile := A_Temp "\array_export.csv"

    try {
        FileDelete(csvFile)

        ; Sample data
        employees := [
            {id: 1, name: "John Doe", dept: "Engineering", salary: 75000},
            {id: 2, name: "Jane Smith", dept: "Marketing", salary: 65000},
            {id: 3, name: "Bob Johnson", dept: "Sales", salary: 70000},
            {id: 4, name: "Alice Brown", dept: "Engineering", salary: 80000}
        ]

        ; Write header
        FileAppend("ID,Name,Department,Salary`n", csvFile)

        ; Write data rows
        for emp in employees {
            row := emp.id "," emp.name "," emp.dept "," emp.salary "`n"
            FileAppend(row, csvFile)
        }

        ; Calculate totals
        totalSalary := 0
        for emp in employees
            totalSalary += emp.salary

        ; Add summary row
        FileAppend("`nSummary,,,`n", csvFile)
        FileAppend("Total Employees," employees.Length ",,`n", csvFile)
        FileAppend("Total Salary,,," totalSalary "`n", csvFile)
        FileAppend("Average Salary,,," Round(totalSalary / employees.Length) "`n", csvFile)

        ; Display
        content := FileRead(csvFile)
        MsgBox("Array to CSV Export:`n`n" content, "Array Export")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(csvFile)
    }
}

; ============================================================================
; Example 4: Incremental CSV Logging
; ============================================================================

Example4_IncrementalCSV() {
    csvFile := A_Temp "\event_log.csv"

    try {
        FileDelete(csvFile)

        ; Create CSV logger
        csvLogger := CreateCSVLogger(csvFile, ["Timestamp", "Event", "User", "Status"])

        ; Log events incrementally
        csvLogger.Log([FormatTime(, "yyyy-MM-dd HH:mm:ss"), "Login", "john_doe", "Success"])
        Sleep(100)

        csvLogger.Log([FormatTime(, "yyyy-MM-dd HH:mm:ss"), "File Upload", "john_doe", "Success"])
        Sleep(100)

        csvLogger.Log([FormatTime(, "yyyy-MM-dd HH:mm:ss"), "Database Query", "jane_smith", "Success"])
        Sleep(100)

        csvLogger.Log([FormatTime(, "yyyy-MM-dd HH:mm:ss"), "Login", "bob_user", "Failed"])
        Sleep(100)

        csvLogger.Log([FormatTime(, "yyyy-MM-dd HH:mm:ss"), "File Delete", "john_doe", "Success"])

        ; Display log
        content := FileRead(csvFile)
        MsgBox("CSV Event Log:`n`n" content, "Incremental CSV")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(csvFile)
    }

    ; Create CSV logger
    CreateCSVLogger(filePath, headers) {
        logger := {}
        logger.file := filePath
        logger.headers := headers

        ; Write header
        headerRow := ""
        for header in headers
            headerRow .= header ","
        FileAppend(SubStr(headerRow, 1, -1) "`n", filePath)

        logger.Log := (values) {
            row := ""
            for value in values {
                ; Escape if needed
                if InStr(value, ",")
                    value := "`"" value "`""
                row .= value ","
            }
            FileAppend(SubStr(row, 1, -1) "`n", this.file)
        }

        return logger
    }
}

; ============================================================================
; Example 5: Sales Report CSV Generation
; ============================================================================

Example5_SalesReport() {
    reportFile := A_Temp "\sales_report.csv"

    try {
        FileDelete(reportFile)

        ; Generate sales data
        salesData := GenerateSalesData(30)

        ; Write CSV report
        FileAppend("Date,Product,Quantity,Unit Price,Total,Salesperson`n", reportFile)

        totalRevenue := 0

        for sale in salesData {
            total := sale.quantity * sale.price
            totalRevenue += total

            row := sale.date "," sale.product "," sale.quantity ","
            row .= Format("{:.2f}", sale.price) ","
            row .= Format("{:.2f}", total) ","
            row .= sale.salesperson "`n"

            FileAppend(row, reportFile)
        }

        ; Add summary
        FileAppend("`n", reportFile)
        FileAppend("Total Sales," salesData.Length ",,,,`n", reportFile)
        FileAppend("Total Revenue,,,," Format("{:.2f}", totalRevenue) ",`n", reportFile)

        ; Display
        content := FileRead(reportFile)
        MsgBox("Sales Report (first 500 chars):`n`n" SubStr(content, 1, 500) "...", "Sales Report")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(reportFile)
    }

    ; Generate random sales data
    GenerateSalesData(count) {
        products := ["Laptop", "Mouse", "Keyboard", "Monitor", "Headset"]
        salespeople := ["John", "Jane", "Bob", "Alice"]
        sales := []

        Loop count {
            sale := {}
            sale.date := FormatTime(DateAdd(A_Now, -Random(1, 30), "Days"), "yyyy-MM-dd")
            sale.product := products[Random(1, products.Length)]
            sale.quantity := Random(1, 10)
            sale.price := Random(10, 1000) + (Random(0, 99) / 100)
            sale.salesperson := salespeople[Random(1, salespeople.Length)]
            sales.Push(sale)
        }

        return sales
    }
}

; ============================================================================
; Example 6: CSV Data Export Utility
; ============================================================================

Example6_DataExport() {
    exportFile := A_Temp "\data_export.csv"

    try {
        FileDelete(exportFile)

        ; Create export utility
        exporter := CreateCSVExporter(exportFile)

        ; Add fields
        exporter.AddField("ID")
        exporter.AddField("Username")
        exporter.AddField("Email")
        exporter.AddField("Status")
        exporter.AddField("Created")

        ; Write header
        exporter.WriteHeader()

        ; Add records
        exporter.AddRecord(["1", "johndoe", "john@example.com", "Active", "2023-01-15"])
        exporter.AddRecord(["2", "janesmith", "jane@example.com", "Active", "2023-02-20"])
        exporter.AddRecord(["3", "bobuser", "bob@example.com", "Inactive", "2023-03-10"])

        ; Finalize
        exporter.Finalize()

        ; Display
        content := FileRead(exportFile)
        MsgBox("Exported Data:`n`n" content, "Data Export")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(exportFile)
    }

    ; CSV Exporter utility
    CreateCSVExporter(filePath) {
        exporter := {}
        exporter.file := filePath
        exporter.fields := []
        exporter.recordCount := 0

        exporter.AddField := (fieldName) {
            this.fields.Push(fieldName)
        }

        exporter.WriteHeader := () {
            row := ""
            for field in this.fields
                row .= field ","
            FileAppend(SubStr(row, 1, -1) "`n", this.file)
        }

        exporter.AddRecord := (values) {
            row := ""
            for value in values {
                if InStr(value, ",")
                    value := "`"" value "`""
                row .= value ","
            }
            FileAppend(SubStr(row, 1, -1) "`n", this.file)
            this.recordCount++
        }

        exporter.Finalize := () {
            FileAppend("`n", this.file)
            FileAppend("Total Records," this.recordCount "`n", this.file)
        }

        return exporter
    }
}

; ============================================================================
; Example 7: Multi-Sheet CSV Export (Separate Files)
; ============================================================================

Example7_MultiSheet() {
    exportDir := A_Temp "\csv_export"

    try {
        ; Create export directory
        if !DirExist(exportDir)
            DirCreate(exportDir)

        ; Export different data sets
        ExportCustomers(exportDir "\customers.csv")
        ExportOrders(exportDir "\orders.csv")
        ExportProducts(exportDir "\products.csv")

        ; Show summary
        output := "CSV Export Complete:`n`n"

        Loop Files, exportDir "\*.csv" {
            output .= A_LoopFileName "`n"
            output .= "  Size: " A_LoopFileSize " bytes`n"

            ; Count lines
            content := FileRead(A_LoopFilePath)
            lines := StrSplit(content, "`n")
            output .= "  Records: " (lines.Length - 2) "`n`n"  ; Subtract header and empty line
        }

        MsgBox(output, "Multi-Sheet Export")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if DirExist(exportDir)
            DirDelete(exportDir, true)
    }

    ExportCustomers(file) {
        FileDelete(file)
        FileAppend("CustomerID,Name,Email,Phone`n", file)
        FileAppend("C001,John Doe,john@example.com,555-0001`n", file)
        FileAppend("C002,Jane Smith,jane@example.com,555-0002`n", file)
        FileAppend("C003,Bob Johnson,bob@example.com,555-0003`n", file)
    }

    ExportOrders(file) {
        FileDelete(file)
        FileAppend("OrderID,CustomerID,Date,Amount`n", file)
        FileAppend("O001,C001,2024-01-15,250.00`n", file)
        FileAppend("O002,C002,2024-01-16,175.50`n", file)
        FileAppend("O003,C001,2024-01-17,399.99`n", file)
    }

    ExportProducts(file) {
        FileDelete(file)
        FileAppend("ProductID,Name,Price,Stock`n", file)
        FileAppend("P001,Laptop,999.99,25`n", file)
        FileAppend("P002,Mouse,29.99,100`n", file)
        FileAppend("P003,Keyboard,79.99,50`n", file)
    }
}

; ============================================================================
; Run Examples
; ============================================================================

RunAllExamples() {
    examples := [
        {name: "Basic CSV", func: Example1_BasicCSV},
        {name: "Quoted CSV", func: Example2_QuotedCSV},
        {name: "Array to CSV", func: Example3_ArrayToCSV},
        {name: "Incremental CSV", func: Example4_IncrementalCSV},
        {name: "Sales Report", func: Example5_SalesReport},
        {name: "Data Export", func: Example6_DataExport},
        {name: "Multi-Sheet Export", func: Example7_MultiSheet}
    ]

    for example in examples {
        result := MsgBox("Run: " example.name "?", "CSV Examples", 4)
        if result = "Yes"
            example.func.Call()
    }
}
