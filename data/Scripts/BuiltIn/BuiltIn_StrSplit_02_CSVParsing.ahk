#Requires AutoHotkey v2.0

/**
* BuiltIn_StrSplit_02_CSVParsing.ahk
*
* DESCRIPTION:
* Advanced CSV and structured data parsing using StrSplit() function
*
* FEATURES:
* - Parse CSV (Comma-Separated Values) data
* - Parse TSV (Tab-Separated Values) data
* - Handle quoted fields with commas
* - Process multi-line CSV data
* - Build data tables from CSV
* - Export data back to CSV format
*
* SOURCE:
* AutoHotkey v2 Documentation - StrSplit()
* Common CSV parsing patterns
*
* KEY V2 FEATURES DEMONSTRATED:
* - StrSplit() for CSV parsing
* - Array of Arrays (2D data)
* - Map objects for structured data
* - Loop Parse for line-by-line processing
* - String manipulation with InStr() and SubStr()
*
* LEARNING POINTS:
* 1. CSV is a common data exchange format
* 2. Simple CSV can be parsed with StrSplit(line, ",")
* 3. Quoted fields require special handling
* 4. Multi-line data needs line-by-line parsing
* 5. Headers can be used as Map keys
* 6. Data validation is important when parsing
* 7. Whitespace often needs trimming
*/

; ============================================================
; Example 1: Simple CSV Line Parsing
; ============================================================

/**
* Parse a simple CSV line without quoted fields
*/
csvLine := "John,Doe,35,Engineer,New York"
fields := StrSplit(csvLine, ",")

output := "CSV Line:`n" csvLine "`n`n"
output .= "Parsed Fields:`n"

headers := ["First Name", "Last Name", "Age", "Occupation", "City"]
for index, field in fields {
    output .= headers[index] ": " field "`n"
}

MsgBox(output, "Simple CSV Parsing", "Icon!")

; ============================================================
; Example 2: Parse CSV with Headers
; ============================================================

/**
* Parse CSV data with headers into array of Maps
*
* @param {String} csvData - Multi-line CSV data
* @returns {Array} - Array of Map objects
*/
ParseCSVWithHeaders(csvData) {
    lines := StrSplit(csvData, "`n", "`r")  ; Split lines, omit CR
    if (lines.Length < 2)
    return []

    ; First line is headers
    headers := StrSplit(lines[1], ",")

    ; Clean headers
    for index, header in headers {
        headers[index] := Trim(header)
    }

    ; Parse data rows
    result := []
    Loop lines.Length - 1 {
        rowIndex := A_Index + 1
        if (Trim(lines[rowIndex]) = "")  ; Skip empty lines
        continue

        fields := StrSplit(lines[rowIndex], ",")
        row := Map()

        for index, header in headers {
            value := index <= fields.Length ? Trim(fields[index]) : ""
            row[header] := value
        }

        result.Push(row)
    }

    return result
}

; Sample CSV data
csvData := "
(
Name,Age,Department,Salary
Alice Johnson,28,Engineering,75000
Bob Smith,34,Marketing,65000
Carol White,29,Engineering,78000
David Brown,42,Sales,70000
)"

employees := ParseCSVWithHeaders(csvData)

output := "EMPLOYEE DATABASE:`n"
output .= "Total Records: " employees.Length "`n`n"

for index, employee in employees {
    output .= "Employee " index ":`n"
    output .= "  Name: " employee["Name"] "`n"
    output .= "  Age: " employee["Age"] "`n"
    output .= "  Department: " employee["Department"] "`n"
    output .= "  Salary: $" employee["Salary"] "`n`n"
}

MsgBox(output, "CSV with Headers", "Icon!")

; ============================================================
; Example 3: TSV (Tab-Separated Values) Parsing
; ============================================================

/**
* Parse Tab-Separated Values
* Common in spreadsheet exports
*/
tsvData := "
(
Product`tQuantity`tPrice`tTotal
Widget A`t10`t25.50`t255.00
Widget B`t5`t30.00`t150.00
Widget C`t15`t18.75`t281.25
)"

ParseTSV(tsvData) {
    lines := StrSplit(tsvData, "`n", "`r")
    result := []

    for line in lines {
        line := Trim(line)
        if (line = "")
        continue

        fields := StrSplit(line, "`t")
        result.Push(fields)
    }

    return result
}

table := ParseTSV(tsvData)

output := "TAB-SEPARATED DATA:`n`n"

; Display as table
for rowIndex, row in table {
    if (rowIndex = 1) {
        ; Header row
        for field in row {
            output .= field "`t"
        }
        output .= "`n" StrReplace(Format("{:80}", ""), " ", "-") "`n"
    } else {
        for field in row {
            output .= field "`t"
        }
        output .= "`n"
    }
}

; Calculate total
total := 0
Loop table.Length - 1 {
    row := table[A_Index + 1]
    if (row.Length >= 4)
    total += Float(row[4])
}

output .= "`nGrand Total: $" Format("{:.2f}", total)

MsgBox(output, "TSV Parsing", "Icon!")

; ============================================================
; Example 4: Handle Quoted CSV Fields
; ============================================================

/**
* Parse CSV with quoted fields that may contain commas
* This is a simplified parser for demonstration
*
* @param {String} csvLine - CSV line to parse
* @returns {Array} - Array of fields
*/
ParseQuotedCSV(csvLine) {
    fields := []
    currentField := ""
    inQuotes := false

    Loop Parse, csvLine {
        char := A_LoopField

        if (char = '"') {
            inQuotes := !inQuotes
        } else if (char = "," && !inQuotes) {
            fields.Push(currentField)
            currentField := ""
        } else {
            currentField .= char
        }
    }

    ; Add last field
    fields.Push(currentField)

    return fields
}

; Test with quoted fields
testLines := [
'John,Doe,Engineer',
'"Smith, Jane",Developer',
'"Brown, Bob","Senior Manager","Acme Corp"',
'Alice,"Quality Assurance","Company, Inc."'
]

output := "QUOTED CSV PARSING:`n`n"

for line in testLines {
    fields := ParseQuotedCSV(line)
    output .= "Line: " line "`n"
    output .= "Fields (" fields.Length "):`n"

    for index, field in fields {
        output .= "  " index ". '" field "'`n"
    }
    output .= "`n"
}

MsgBox(output, "Quoted CSV Fields", "Icon!")

; ============================================================
; Example 5: CSV to Table Converter
; ============================================================

/**
* Convert CSV data to a 2D array (table)
* Useful for data manipulation and analysis
*/
class CSVTable {
    /**
    * Parse CSV into 2D table
    *
    * @param {String} csvData - CSV data
    * @param {Boolean} hasHeaders - True if first row is headers
    * @returns {Object} - Table object with data and headers
    */
    static FromCSV(csvData, hasHeaders := true) {
        lines := StrSplit(csvData, "`n", "`r")
        table := {
            headers: [],
            rows: [],
            rowCount: 0,
            colCount: 0
        }

        startRow := 1

        if (hasHeaders && lines.Length > 0) {
            table.headers := StrSplit(lines[1], ",")
            for index, header in table.headers {
                table.headers[index] := Trim(header)
            }
            table.colCount := table.headers.Length
            startRow := 2
        }

        Loop lines.Length - startRow + 1 {
            rowIndex := A_Index + startRow - 1
            line := Trim(lines[rowIndex])

            if (line = "")
            continue

            fields := StrSplit(line, ",")
            cleanFields := []

            for field in fields {
                cleanFields.Push(Trim(field))
            }

            table.rows.Push(cleanFields)
            table.rowCount++

            if (table.colCount = 0)
            table.colCount := cleanFields.Length
        }

        return table
    }

    /**
    * Get specific column data
    *
    * @param {Object} table - Table object
    * @param {Integer} colIndex - Column index (1-based)
    * @returns {Array} - Column values
    */
    static GetColumn(table, colIndex) {
        column := []
        for row in table.rows {
            if (colIndex <= row.Length)
            column.Push(row[colIndex])
        }
        return column
    }

    /**
    * Calculate sum of numeric column
    */
    static SumColumn(table, colIndex) {
        sum := 0
        for row in table.rows {
            if (colIndex <= row.Length) {
                value := Float(row[colIndex])
                if (value != "")
                sum += value
            }
        }
        return sum
    }
}

; Sales data example
salesData := "
(
Month,Revenue,Expenses,Profit
January,45000,32000,13000
February,52000,35000,17000
March,48000,33000,15000
April,55000,36000,19000
)"

salesTable := CSVTable.FromCSV(salesData, true)

output := "SALES ANALYSIS:`n`n"
output .= "Columns: " salesTable.colCount "`n"
output .= "Data Rows: " salesTable.rowCount "`n`n"

; Display headers
output .= "Headers: "
for header in salesTable.headers {
    output .= header " | "
}
output .= "`n`n"

; Display data
for row in salesTable.rows {
    for field in row {
        output .= field "`t"
    }
    output .= "`n"
}

; Calculate totals
totalRevenue := CSVTable.SumColumn(salesTable, 2)
totalExpenses := CSVTable.SumColumn(salesTable, 3)
totalProfit := CSVTable.SumColumn(salesTable, 4)

output .= "`nTOTALS:`n"
output .= "Revenue: $" totalRevenue "`n"
output .= "Expenses: $" totalExpenses "`n"
output .= "Profit: $" totalProfit

MsgBox(output, "CSV Table Analysis", "Icon!")

; ============================================================
; Example 6: Export Data to CSV
; ============================================================

/**
* Convert array of Maps back to CSV format
*
* @param {Array} data - Array of Map objects
* @param {Array} headers - Column headers
* @returns {String} - CSV formatted string
*/
ExportToCSV(data, headers) {
    csv := ""

    ; Add headers
    for index, header in headers {
        csv .= header
        if (index < headers.Length)
        csv .= ","
    }
    csv .= "`n"

    ; Add data rows
    for record in data {
        for index, header in headers {
            value := record.Has(header) ? record[header] : ""

            ; Quote if contains comma
            if (InStr(value, ","))
            value := '"' value '"'

            csv .= value
            if (index < headers.Length)
            csv .= ","
        }
        csv .= "`n"
    }

    return csv
}

; Create sample data
products := []

products.Push(Map(
"ID", "001",
"Name", "Widget, Premium",
"Price", "29.99",
"Stock", "150"
))

products.Push(Map(
"ID", "002",
"Name", "Gadget Pro",
"Price", "49.99",
"Stock", "75"
))

products.Push(Map(
"ID", "003",
"Name", "Tool, Deluxe",
"Price", "39.99",
"Stock", "200"
))

headers := ["ID", "Name", "Price", "Stock"]
csvOutput := ExportToCSV(products, headers)

output := "EXPORTED CSV DATA:`n`n"
output .= csvOutput
output .= "`nNote: Fields with commas are quoted"

MsgBox(output, "Export to CSV", "Icon!")

; ============================================================
; Example 7: Parse Configuration File (INI-style CSV)
; ============================================================

/**
* Parse configuration data in CSV format
* Format: key,value
*/
ParseConfigCSV(configData) {
    config := Map()
    lines := StrSplit(configData, "`n", "`r")

    for line in lines {
        line := Trim(line)

        ; Skip empty lines and comments
        if (line = "" || SubStr(line, 1, 1) = "#")
        continue

        parts := StrSplit(line, ",")
        if (parts.Length >= 2) {
            key := Trim(parts[1])
            value := Trim(parts[2])
            config[key] := value
        }
    }

    return config
}

configData := "
(
# Application Configuration

AppName,MyApplication
Version,2.1.0
Author,John Developer
MaxConnections,100
Timeout,30
EnableLogging,true
LogPath,C:\Logs\app.log
)"

config := ParseConfigCSV(configData)

output := "CONFIGURATION SETTINGS:`n`n"
for key, value in config {
    output .= key " = " value "`n"
}

output .= "`n"
output .= "Application: " config["AppName"] " v" config["Version"] "`n"
output .= "Max Connections: " config["MaxConnections"] "`n"
output .= "Logging: " (config["EnableLogging"] = "true" ? "Enabled" : "Disabled")

MsgBox(output, "Config Parser", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
CSV PARSING WITH STRSPLIT():

Basic CSV Parsing:
lines := StrSplit(csvData, '`n')
for line in lines {
    fields := StrSplit(line, ',')
}

Common Patterns:

1. Simple CSV (no quotes):
fields := StrSplit(line, ',')
for field in fields
field := Trim(field)

2. With Headers:
lines := StrSplit(data, '`n')
headers := StrSplit(lines[1], ',')
for index, line in lines {
    if (index > 1)
    fields := StrSplit(line, ',')
}

3. TSV (Tab-Separated):
fields := StrSplit(line, '`t')

4. Clean Whitespace:
fields := StrSplit(line, ',', ' `t')

5. Multi-line Processing:
Loop Parse, csvData, '`n', '`r' {
    fields := StrSplit(A_LoopField, ',')
}

CSV Challenges:
• Quoted fields with commas
• Embedded newlines in fields
• Different quote styles
• Missing fields
• Extra whitespace
• Different line endings

Best Practices:
✓ Trim whitespace from fields
✓ Handle empty lines
✓ Validate field count
✓ Check for headers
✓ Handle missing values
✓ Quote fields with delimiters
✓ Use consistent line endings

Common CSV Uses:
• Data import/export
• Configuration files
• Database dumps
• Spreadsheet exchange
• Log file parsing
• Report generation

Tools & Functions:
• StrSplit() - Split lines and fields
• Trim() - Clean whitespace
• Loop Parse - Process line by line
• Map - Store key-value data
• Array - Store rows/columns
)"

MsgBox(info, "CSV Parsing Reference", "Icon!")
