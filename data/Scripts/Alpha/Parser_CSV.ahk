#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; CSV Parser - Parses and generates CSV data
; Demonstrates string parsing with proper quote handling

class CSV {
    static Parse(text, delimiter := ",") {
        rows := []
        lines := StrSplit(text, "`n")

        for line in lines {
            line := Trim(line, "`r")
            if line = ""
                continue

            cells := []
            inQuotes := false
            cell := ""

            Loop StrLen(line) {
                char := SubStr(line, A_Index, 1)

                if char = '"' {
                    inQuotes := !inQuotes
                } else if char = delimiter && !inQuotes {
                    cells.Push(cell)
                    cell := ""
                } else {
                    cell .= char
                }
            }
            cells.Push(cell)
            rows.Push(cells)
        }

        return rows
    }

    static Stringify(rows, delimiter := ",") {
        result := ""

        for row in rows {
            line := ""
            for i, cell in row {
                if i > 1
                    line .= delimiter
                if InStr(cell, delimiter) || InStr(cell, '"') || InStr(cell, "`n")
                    line .= '"' StrReplace(cell, '"', '""') '"'
                else
                    line .= cell
            }
            result .= line "`n"
        }

        return RTrim(result, "`n")
    }

    ; Parse into array of maps with headers
    static ParseWithHeaders(text, delimiter := ",") {
        rows := this.Parse(text, delimiter)
        if rows.Length < 2
            return []

        headers := rows[1]
        result := []

        Loop rows.Length - 1 {
            row := rows[A_Index + 1]
            record := Map()
            for i, header in headers
                record[header] := i <= row.Length ? row[i] : ""
            result.Push(record)
        }

        return result
    }
}

; Demo
csvData := "
(
name,age,city
"John Doe",30,New York
"Jane, Smith",25,"Los Angeles"
Bob,35,Chicago
)"

; Parse
rows := CSV.Parse(csvData)
result := "Parsed rows:`n"
for row in rows {
    line := ""
    for cell in row
        line .= "[" cell "] "
    result .= line "`n"
}

MsgBox(result)

; Parse with headers
records := CSV.ParseWithHeaders(csvData)
result := "Records:`n"
for record in records
    result .= record["name"] " (" record["age"] ") - " record["city"] "`n"

MsgBox(result)

; Generate CSV
data := [
    ["product", "price", "stock"],
    ["Widget", "9.99", "100"],
    ["Gadget, Pro", "19.99", "50"]
]

generated := CSV.Stringify(data)
MsgBox("Generated CSV:`n`n" generated)
