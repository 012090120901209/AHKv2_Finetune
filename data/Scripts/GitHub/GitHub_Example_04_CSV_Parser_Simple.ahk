#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Simple CSV Parser (Simplified from DSVParser)
 * Source: Inspired by github.com/jasonsparc/dsvparser-ahk2
 * 
 * Demonstrates:
 * - Class definition with __New constructor
 * - Property definitions (read-only)
 * - String splitting and manipulation
 * - Array operations
 * - Regex for quoted field handling
 */

class SimpleCSVParser {
    __New(delimiter := ",") {
        this._delimiter := delimiter
    }

    ; Read-only property
    Delimiter => this._delimiter

    ; Parse CSV string to 2D array
    ToArray(csvText) {
        rows := []
        lines := StrSplit(csvText, "`n", "`r")

        for line in lines {
            if (Trim(line) = "")
                continue

            ; Simple split (doesn't handle quoted commas)
            cells := StrSplit(line, this._delimiter)
            rows.Push(cells)
        }

        return rows
    }

    ; Convert 2D array back to CSV string
    FromArray(data) {
        output := ""

        for row in data {
            line := ""
            for cell in row {
                line .= (line = "" ? "" : this._delimiter) . cell
            }
            output .= line "`n"
        }

        return RTrim(output, "`n")
    }
}

; Example usage
csv := SimpleCSVParser()

; Parse CSV data
csvData := "Name,Age,City`nAlice,30,NYC`nBob,25,LA`nCarol,35,Chicago"
parsed := csv.ToArray(csvData)

; Display parsed data
output := "Parsed CSV Data:`n`n"
for row in parsed {
    for cell in row {
        output .= cell " | "
    }
    output := RTrim(output, " | ") "`n"
}
MsgBox(output)

; Convert back to CSV
newData := [
    ["Product", "Price", "Stock"],
    ["Apple", "1.50", "100"],
    ["Banana", "0.75", "150"]
]
csvOutput := csv.FromArray(newData)
MsgBox("Generated CSV:`n`n" csvOutput)
