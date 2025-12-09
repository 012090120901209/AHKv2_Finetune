#Requires AutoHotkey v2.0
#Include JSON.ahk

/**
* ============================================================================
* FileRead - Structured Data Reading and Parsing
* ============================================================================
*
* Demonstrates reading and parsing structured data formats:
* - INI configuration files
* - CSV/TSV data files
* - XML data structures
* - JSON data formats
* - Custom delimited formats
* - Database export files
*
* @description Structured data reading examples for FileRead
* @author AutoHotkey Foundation
* @version 1.0.0
* @see https://www.autohotkey.com/docs/v2/lib/FileRead.htm
*/

; ============================================================================
; Example 1: Advanced INI File Reading and Parsing
; ============================================================================

Example1_AdvancedINI() {
    iniFile := A_Temp "\advanced_config.ini"

    ; Create complex INI file
    iniContent := "
    (
    ; Application Configuration File
    ; Last modified: 2024-01-15

    [Application]
    Name=DataManager Pro
    Version=2.5.1
    Author=Software Inc.
    License=Commercial

    [Database]
    Type=MySQL
    Host=localhost
    Port=3306
    Database=production_db
    Username=admin
    ; Password is encrypted
    Password=enc:A7B9C2D4E6F8
    ConnectionTimeout=30
    MaxConnections=100

    [Logging]
    Enabled=true
    Level=INFO  ; DEBUG, INFO, WARNING, ERROR
    LogFile=logs\application.log
    MaxFileSize=10485760  ; 10 MB in bytes
    RotateDaily=true

    [UI]
    Theme=modern-dark
    Language=en-US
    FontFamily=Segoe UI
    FontSize=10
    WindowWidth=1280
    WindowHeight=720
    RememberPosition=true

    [Features]
    AutoSave=true
    AutoSaveInterval=300  ; seconds
    SpellCheck=true
    AutoUpdate=true
    Analytics=false
    )"

    try {
        ; Write INI file
        FileAppend(iniContent, iniFile)

        ; Read and parse INI
        content := FileRead(iniFile)
        config := ParseINI(content)

        ; Display parsed structure
        output := "INI File Structure:`n`n"
        output .= "Total Sections: " config.Count "`n`n"

        for section, values in config {
            output .= "[" section "] (" values.Count " settings)`n"

            for key, value in values {
                displayValue := value
                if StrLen(value) > 30
                displayValue := SubStr(value, 1, 30) . "..."
                output .= "  " key " = " displayValue "`n"
            }
            output .= "`n"
        }

        MsgBox(output, "INI File Parser")

        ; Demonstrate accessing values
        dbHost := config["Database"]["Host"]
        uiTheme := config["UI"]["Theme"]
        logEnabled := config["Logging"]["Enabled"]

        MsgBox("Database Host: " dbHost "`n" .
        "UI Theme: " uiTheme "`n" .
        "Logging: " (logEnabled = "true" ? "Enabled" : "Disabled"),
        "Configuration Values")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(iniFile)
    }

    ; INI Parser with comment support
    ParseINI(content) {
        config := Map()
        currentSection := ""

        for line in StrSplit(content, "`n", "`r") {
            line := Trim(line)

            ; Skip empty lines and comments
            if !line || SubStr(line, 1, 1) = ";"
            continue

            ; Remove inline comments
            if pos := InStr(line, ";") {
                beforeComment := Trim(SubStr(line, 1, pos - 1))
                if beforeComment
                line := beforeComment
                else
                continue
            }

            ; Section header
            if RegExMatch(line, "^\[(.*)\]$", &match) {
                currentSection := match[1]
                config[currentSection] := Map()
            }
            ; Key=Value pair
            else if RegExMatch(line, "^([^=]+)=(.*)$", &match) && currentSection {
                key := Trim(match[1])
                value := Trim(match[2])
                config[currentSection][key] := value
            }
        }

        return config
    }
}

; ============================================================================
; Example 2: Advanced CSV Parsing with Headers and Types
; ============================================================================

Example2_AdvancedCSV() {
    csvFile := A_Temp "\employees.csv"

    ; Create CSV with different data types
    csvContent := "
    (
    ID,Name,Department,Salary,HireDate,Active,Email
    1001,"John Doe",Engineering,75000.50,2020-03-15,true,john.doe@company.com
    1002,"Jane Smith",Marketing,65000.00,2019-07-22,true,jane.smith@company.com
    1003,"Bob Johnson",Sales,70000.25,2021-01-10,true,bob.johnson@company.com
    1004,"Alice Brown",Engineering,82000.00,2018-11-30,true,alice.brown@company.com
    1005,"Charlie Wilson",HR,60000.00,2022-05-18,false,charlie.wilson@company.com
    1006,"Diana Martinez","Customer Support",55000.75,2021-08-09,true,diana.martinez@company.com
    )"

    try {
        ; Write CSV file
        FileAppend(csvContent, csvFile)

        ; Read and parse CSV
        content := FileRead(csvFile)
        data := ParseCSV(content, true)  ; true = has headers

        ; Display data structure
        output := "CSV Data Structure:`n`n"
        output .= "Records: " data.records.Length "`n"
        output .= "Columns: " data.headers.Length "`n`n"

        output .= "Headers: " ArrayToString(data.headers) "`n`n"

        ; Display formatted table
        output .= Format("{:^6} {:^15} {:^18} {:^10} {:^12} {:^7}`n",
        "ID", "Name", "Department", "Salary", "Hire Date", "Active")
        output .= StrReplace(Format("{:-80}", ""), " ", "-") "`n"

        for record in data.records {
            output .= Format("{:^6} {:^15} {:^18} ${:>9} {:^12} {:^7}`n",
            record["ID"],
            record["Name"],
            record["Department"],
            record["Salary"],
            record["HireDate"],
            record["Active"])
        }

        MsgBox(output, "CSV Parser")

        ; Perform data analysis
        stats := AnalyzeCSVData(data)

        output := "Data Analysis:`n`n"
        output .= "Total Employees: " stats.total "`n"
        output .= "Active: " stats.active "`n"
        output .= "Inactive: " stats.inactive "`n`n"
        output .= "Average Salary: $" Round(stats.avgSalary, 2) "`n"
        output .= "Highest Salary: $" stats.maxSalary "`n"
        output .= "Lowest Salary: $" stats.minSalary "`n`n"
        output .= "By Department:`n"

        for dept, count in stats.byDepartment
        output .= "  " dept ": " count "`n"

        MsgBox(output, "CSV Data Analysis")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(csvFile)
    }

    ; Advanced CSV parser with header support
    ParseCSV(content, hasHeaders := false) {
        rows := []
        headers := []

        for line in StrSplit(content, "`n", "`r") {
            line := Trim(line)
            if !line
            continue

            ; Parse CSV line (handles quoted values)
            fields := ParseCSVLine(line)

            if hasHeaders && headers.Length = 0 {
                headers := fields
            } else {
                rows.Push(fields)
            }
        }

        ; Convert to record format if headers exist
        records := []
        if hasHeaders {
            for row in rows {
                record := Map()
                for index, value in row {
                    if index <= headers.Length
                    record[headers[index]] := value
                }
                records.Push(record)
            }
            return {headers: headers, records: records}
        }

        return {headers: [], records: rows}
    }

    ; Parse CSV line with quoted value support
    ParseCSVLine(line) {
        fields := []
        field := ""
        inQuotes := false

        Loop Parse, line {
            char := A_LoopField

            if char = '"' {
                inQuotes := !inQuotes
            } else if char = "," && !inQuotes {
                fields.Push(Trim(field))
                field := ""
            } else {
                field .= char
            }
        }

        ; Add last field
        if field != "" || SubStr(line, -1) = ","
        fields.Push(Trim(field))

        return fields
    }

    ; Analyze CSV data
    AnalyzeCSVData(data) {
        stats := Map()
        stats["total"] := data.records.Length
        stats["active"] := 0
        stats["inactive"] := 0
        stats["byDepartment"] := Map()

        totalSalary := 0
        maxSalary := 0
        minSalary := 999999

        for record in data.records {
            ; Count active/inactive
            if record["Active"] = "true"
            stats["active"]++
            else
            stats["inactive"]++

            ; Department count
            dept := record["Department"]
            stats["byDepartment"][dept] := stats["byDepartment"].Get(dept, 0) + 1

            ; Salary statistics
            salary := Float(record["Salary"])
            totalSalary += salary
            maxSalary := Max(maxSalary, salary)
            minSalary := Min(minSalary, salary)
        }

        stats["avgSalary"] := totalSalary / stats["total"]
        stats["maxSalary"] := maxSalary
        stats["minSalary"] := minSalary

        return stats
    }

    ArrayToString(arr, delimiter := ", ") {
        result := ""
        for item in arr {
            result .= item
            if A_Index < arr.Length
            result .= delimiter
        }
        return result
    }
}

; ============================================================================
; Example 3: XML Data Reading and Parsing
; ============================================================================

Example3_XMLParsing() {
    xmlFile := A_Temp "\data.xml"

    ; Create XML file
    xmlContent := '
    (
    <?xml version="1.0" encoding="UTF-8"?>
    <catalog>
    <book id="1">
    <title>AutoHotkey Guide</title>
    <author>John Developer</author>
    <year>2023</year>
    <price>29.99</price>
    <category>Programming</category>
    </book>
    <book id="2">
    <title>Scripting Mastery</title>
    <author>Jane Coder</author>
    <year>2024</year>
    <price>39.99</price>
    <category>Programming</category>
    </book>
    <book id="3">
    <title>Automation Techniques</title>
    <author>Bob Automator</author>
    <year>2023</year>
    <price>34.99</price>
    <category>Productivity</category>
    </book>
    </catalog>
    )'

    try {
        ; Write XML file
        FileAppend(xmlContent, xmlFile)

        ; Read XML file
        content := FileRead(xmlFile)

        ; Simple XML parsing
        books := ParseXMLBooks(content)

        ; Display parsed data
        output := "XML Parsing Results:`n`n"
        output .= "Books Found: " books.Length "`n`n"

        for book in books {
            output .= "Book #" book["id"] ":`n"
            output .= "  Title: " book["title"] "`n"
            output .= "  Author: " book["author"] "`n"
            output .= "  Year: " book["year"] "`n"
            output .= "  Price: $" book["price"] "`n"
            output .= "  Category: " book["category"] "`n`n"
        }

        MsgBox(output, "XML Parser")

        ; Filter by category
        programmingBooks := FilterBooksByCategory(books, "Programming")

        output := "Programming Books:`n`n"
        for book in programmingBooks
        output .= book["title"] " by " book["author"] " - $" book["price"] "`n"

        MsgBox(output, "Filtered Results")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(xmlFile)
    }

    ; Simple XML book parser
    ParseXMLBooks(xml) {
        books := []

        ; Find all book entries
        pos := 1
        while pos := RegExMatch(xml, "s)<book id=`"(\d+)`">(.*?)</book>", &match, pos) {
            bookId := match[1]
            bookContent := match[2]

            book := Map("id", bookId)

            ; Extract fields
            fields := ["title", "author", "year", "price", "category"]
            for field in fields {
                if RegExMatch(bookContent, "<" field ">(.*?)</" field ">", &fieldMatch)
                book[field] := fieldMatch[1]
            }

            books.Push(book)
            pos += StrLen(match[0])
        }

        return books
    }

    ; Filter books by category
    FilterBooksByCategory(books, category) {
        filtered := []
        for book in books {
            if book["category"] = category
            filtered.Push(book)
        }
        return filtered
    }
}

; ============================================================================
; Example 4: Tab-Separated Values (TSV) Parsing
; ============================================================================

Example4_TSVParsing() {
    tsvFile := A_Temp "\data.tsv"

    ; Create TSV file (tab-delimited)
    tsvContent := "Name`tAge`tCity`tCountry`tOccupation`n"
    tsvContent .= "John Doe`t35`tNew York`tUSA`tEngineer`n"
    tsvContent .= "Jane Smith`t28`tLondon`tUK`tDesigner`n"
    tsvContent .= "Bob Johnson`t42`tToronto`tCanada`tManager`n"
    tsvContent .= "Alice Brown`t31`tSydney`tAustralia`tAnalyst`n"

    try {
        ; Write TSV file
        FileAppend(tsvContent, tsvFile)

        ; Read TSV file
        content := FileRead(tsvFile)

        ; Parse TSV
        data := ParseTSV(content)

        ; Display data
        output := "TSV Parsing Results:`n`n"
        output .= "Records: " data.records.Length "`n`n"

        output .= Format("{:-15} {:-5} {:-15} {:-15} {:-15}`n",
        "Name", "Age", "City", "Country", "Occupation")
        output .= StrReplace(Format("{:-70}", ""), " ", "-") "`n"

        for record in data.records {
            output .= Format("{:-15} {:-5} {:-15} {:-15} {:-15}`n",
            record[0], record[1], record[2], record[3], record[4])
        }

        MsgBox(output, "TSV Parser")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(tsvFile)
    }

    ; TSV parser
    ParseTSV(content) {
        rows := []
        headers := []

        for line in StrSplit(content, "`n", "`r") {
            line := Trim(line)
            if !line
            continue

            fields := StrSplit(line, "`t")

            if headers.Length = 0
            headers := fields
            else
            rows.Push(fields)
        }

        return {headers: headers, records: rows}
    }
}

; ============================================================================
; Example 5: Custom Delimited Format Parsing
; ============================================================================

Example5_CustomDelimited() {
    dataFile := A_Temp "\custom_format.dat"

    ; Create custom delimited file (using |)
    customContent := "
    (
    ProductID|ProductName|Category|Price|InStock|Supplier
    P001|Laptop Computer|Electronics|999.99|25|TechSupply Co.
    P002|Office Chair|Furniture|249.50|50|OfficeWorld Inc.
    P003|Desk Lamp|Lighting|45.99|100|LightMaster Ltd.
    P004|Wireless Mouse|Electronics|29.99|200|TechSupply Co.
    P005|Standing Desk|Furniture|499.00|15|OfficeWorld Inc.
    )"

    try {
        ; Write custom format file
        FileAppend(customContent, dataFile)

        ; Read and parse
        content := FileRead(dataFile)
        data := ParseDelimited(content, "|")

        ; Display results
        output := "Custom Delimited Format:`n`n"
        output .= "Records: " data.records.Length "`n`n"

        for record in data.records {
            output .= record["ProductID"] " - " record["ProductName"] "`n"
            output .= "  Category: " record["Category"] "`n"
            output .= "  Price: $" record["Price"] "`n"
            output .= "  In Stock: " record["InStock"] " units`n"
            output .= "  Supplier: " record["Supplier"] "`n`n"
        }

        MsgBox(output, "Custom Format Parser")

        ; Group by category
        byCategory := GroupByField(data.records, "Category")

        output := "Products by Category:`n`n"
        for category, products in byCategory {
            output .= category " (" products.Length "):`n"
            for product in products
            output .= "  - " product["ProductName"] "`n"
            output .= "`n"
        }

        MsgBox(output, "Grouped Data")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        FileDelete(dataFile)
    }

    ; Generic delimited parser
    ParseDelimited(content, delimiter := ",") {
        rows := []
        headers := []

        for line in StrSplit(content, "`n", "`r") {
            line := Trim(line)
            if !line
            continue

            fields := StrSplit(line, delimiter)

            ; Trim each field
            for index, field in fields
            fields[index] := Trim(field)

            if headers.Length = 0 {
                headers := fields
            } else {
                rows.Push(fields)
            }
        }

        ; Convert to record format
        records := []
        for row in rows {
            record := Map()
            for index, value in row {
                if index <= headers.Length
                record[headers[index]] := value
            }
            records.Push(record)
        }

        return {headers: headers, records: records}
    }

    ; Group records by field
    GroupByField(records, fieldName) {
        grouped := Map()

        for record in records {
            value := record[fieldName]

            if !grouped.Has(value)
            grouped[value] := []

            grouped[value].Push(record)
        }

        return grouped
    }
}

; ============================================================================
; Example 6: Fixed-Width Column Data Parsing
; ============================================================================

Example6_FixedWidth() {
    fixedFile := A_Temp "\fixed_width.txt"

    ; Create fixed-width format file
    fixedContent := "
    (
    ID    Name             Department       Salary    Status
    001   John Doe         Engineering      75000     Active
    002   Jane Smith       Marketing        65000     Active
    003   Bob Johnson      Sales            70000     Inactive
    004   Alice Brown      Engineering      82000     Active
    005   Charlie Wilson   HR               60000     Active
    )"

    try {
        ; Write file
        FileAppend(fixedContent, fixedFile)

        ; Read file
        content := FileRead(fixedFile)

        ; Define column positions (start, length)
        columns := [
        {
            name: "ID", start: 1, length: 6},
            {
                name: "Name", start: 7, length: 17},
                {
                    name: "Department", start: 24, length: 17},
                    {
                        name: "Salary", start: 41, length: 10},
                        {
                            name: "Status", start: 51, length: 10
                        }
                        ]

                        ; Parse fixed-width data
                        data := ParseFixedWidth(content, columns)

                        ; Display results
                        output := "Fixed-Width Format Parsing:`n`n"
                        output .= "Records: " data.Length "`n`n"

                        for record in data {
                            output .= "ID: " record["ID"] "`n"
                            output .= "Name: " record["Name"] "`n"
                            output .= "Department: " record["Department"] "`n"
                            output .= "Salary: $" record["Salary"] "`n"
                            output .= "Status: " record["Status"] "`n`n"
                        }

                        MsgBox(output, "Fixed-Width Parser")

                    } catch as err {
                        MsgBox("Error: " err.Message, "Error", 16)
                    } finally {
                        FileDelete(fixedFile)
                    }

                    ; Fixed-width parser
                    ParseFixedWidth(content, columns) {
                        records := []
                        lines := StrSplit(content, "`n", "`r")

                        ; Skip header line
                        for index, line in lines {
                            if index = 1 || !Trim(line)
                            continue

                            record := Map()

                            for col in columns {
                                value := SubStr(line, col.start, col.length)
                                record[col.name] := Trim(value)
                            }

                            records.Push(record)
                        }

                        return records
                    }
                }

                ; ============================================================================
                ; Example 7: Database Export File Reading
                ; ============================================================================

                Example7_DatabaseExport() {
                    sqlFile := A_Temp "\database_export.sql"

                    ; Create SQL export file
                    sqlContent := "
                    (
                    -- Database Export
                    -- Generated: 2024-01-15 10:30:00

                    INSERT INTO users (id, username, email, created_at) VALUES
                    (1, 'johndoe', 'john@example.com', '2023-01-15 08:00:00'),
                    (2, 'janesmith', 'jane@example.com', '2023-02-20 09:15:00'),
                    (3, 'bobjohnson', 'bob@example.com', '2023-03-10 10:30:00');

                    INSERT INTO orders (id, user_id, amount, order_date) VALUES
                    (101, 1, 250.50, '2023-06-01'),
                    (102, 2, 175.25, '2023-06-05'),
                    (103, 1, 399.99, '2023-06-10'),
                    (104, 3, 89.00, '2023-06-15');
                    )"

                    try {
                        ; Write SQL file
                        FileAppend(sqlContent, sqlFile)

                        ; Read SQL file
                        content := FileRead(sqlFile)

                        ; Extract INSERT statements
                        inserts := ParseSQLInserts(content)

                        ; Display results
                        output := "SQL Export File Analysis:`n`n"
                        output .= "Total INSERT Statements: " inserts.Length "`n`n"

                        for stmt in inserts {
                            output .= "Table: " stmt.table "`n"
                            output .= "Records: " stmt.records.Length "`n"
                            output .= "Columns: " ArrayToString(stmt.columns) "`n`n"
                        }

                        MsgBox(output, "SQL Parser")

                        ; Show user data
                        if inserts.Length > 0 {
                            userInsert := inserts[1]
                            output := "Users Table Data:`n`n"

                            for record in userInsert.records {
                                output .= "ID: " record[1] "`n"
                                output .= "Username: " record[2] "`n"
                                output .= "Email: " record[3] "`n"
                                output .= "Created: " record[4] "`n`n"
                            }

                            MsgBox(output, "Extracted User Data")
                        }

                    } catch as err {
                        MsgBox("Error: " err.Message, "Error", 16)
                    } finally {
                        FileDelete(sqlFile)
                    }

                    ; SQL INSERT parser
                    ParseSQLInserts(sql) {
                        inserts := []

                        ; Find all INSERT statements
                        pos := 1
                        while pos := RegExMatch(sql, "si)INSERT INTO (\w+)\s*\((.*?)\)\s*VALUES\s*(.*?);", &match, pos) {
                            tableName := match[1]
                            columns := []

                            ; Parse columns
                            for col in StrSplit(match[2], ",")
                            columns.Push(Trim(col))

                            ; Parse values
                            values := match[3]
                            records := []

                            ; Extract each record
                            vpos := 1
                            while vpos := RegExMatch(values, "\((.*?)\)", &vmatch, vpos) {
                                record := []
                                for value in StrSplit(vmatch[1], ",") {
                                    ; Remove quotes and trim
                                    value := Trim(value)
                                    value := Trim(value, "'`"")
                                    record.Push(value)
                                }
                                records.Push(record)
                                vpos += StrLen(vmatch[0])
                            }

                            inserts.Push({
                                table: tableName,
                                columns: columns,
                                records: records
                            })

                            pos += StrLen(match[0])
                        }

                        return inserts
                    }

                    ArrayToString(arr, delimiter := ", ") {
                        result := ""
                        for item in arr {
                            result .= item
                            if A_Index < arr.Length
                            result .= delimiter
                        }
                        return result
                    }
                }

                ; ============================================================================
                ; Run Examples
                ; ============================================================================

                ; Uncomment to run individual examples:
                ; Example1_AdvancedINI()
                ; Example2_AdvancedCSV()
                ; Example3_XMLParsing()
                ; Example4_TSVParsing()
                ; Example5_CustomDelimited()
                ; Example6_FixedWidth()
                ; Example7_DatabaseExport()

                ; Run all examples
                RunAllExamples() {
                    examples := [
                    {
                        name: "Advanced INI Parsing", func: Example1_AdvancedINI},
                        {
                            name: "Advanced CSV Parsing", func: Example2_AdvancedCSV},
                            {
                                name: "XML Parsing", func: Example3_XMLParsing},
                                {
                                    name: "TSV Parsing", func: Example4_TSVParsing},
                                    {
                                        name: "Custom Delimited Format", func: Example5_CustomDelimited},
                                        {
                                            name: "Fixed-Width Columns", func: Example6_FixedWidth},
                                            {
                                                name: "Database Export File", func: Example7_DatabaseExport
                                            }
                                            ]

                                            for example in examples {
                                                result := MsgBox("Run: " example.name "?", "Structured Data Examples", 4)
                                                if result = "Yes"
                                                example.func.Call()
                                            }
                                        }

                                        ; Uncomment to run all examples interactively:
                                        ; RunAllExamples()
