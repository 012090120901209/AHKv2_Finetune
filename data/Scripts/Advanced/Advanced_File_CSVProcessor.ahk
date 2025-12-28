#Requires AutoHotkey v2.0
#SingleInstance Force
; Advanced File Example: CSV File Parser and Processor
; Demonstrates: CSV parsing, file reading, data grid display, export

global csvData := []
global headers := []

csvGui := Gui()
csvGui.Title := "CSV File Processor"

csvGui.Add("Text", "x10 y10", "CSV File:")
fileInput := csvGui.Add("Edit", "x80 y7 w300 ReadOnly")
csvGui.Add("Button", "x390 y6 w100", "Browse").OnEvent("Click", BrowseCSV)

LV := csvGui.Add("ListView", "x10 y40 w580 h300")

csvGui.Add("Button", "x10 y350 w100", "Add Row").OnEvent("Click", AddRow)
csvGui.Add("Button", "x120 y350 w100", "Delete Row").OnEvent("Click", DeleteRow)
csvGui.Add("Button", "x230 y350 w100", "Save CSV").OnEvent("Click", SaveCSV)
csvGui.Add("Button", "x340 y350 w100", "Export JSON").OnEvent("Click", ExportJSON)
csvGui.Add("Button", "x450 y350 w140", "Generate Report").OnEvent("Click", GenReport)

statusBar := csvGui.Add("StatusBar")

csvGui.Show("w600 h400")

BrowseCSV(*) {
    selected := FileSelect(3, , "Select CSV File", "CSV Files (*.csv)")
    if (!selected)
        return

    fileInput.Value := selected
    LoadCSV(selected)
}

LoadCSV(filepath) {
    global csvData, headers

    if (!FileExist(filepath)) {
        MsgBox("File not found!", "Error")
        return
    }

    csvData := []
    headers := []

    content := FileRead(filepath)
    lines := StrSplit(content, "`n", "`r")

    if (lines.Length = 0)
        return

    ; Parse headers
    headers := ParseCSVLine(lines[1])
    LV.Delete()
    Loop headers.Length
        LV.InsertCol(A_Index, , headers[A_Index])

    ; Parse data rows
    Loop lines.Length - 1 {
        if (A_Index = lines.Length)
            break
        if (lines[A_Index + 1] = "")
            continue

        row := ParseCSVLine(lines[A_Index + 1])
        csvData.Push(row)
        LV.Add(, row*)
    }

    LV.ModifyCol()
    statusBar.SetText("  Loaded " csvData.Length " rows")
}

ParseCSVLine(line) {
    fields := []
    current := ""
    inQuote := false

    Loop Parse, line {
        char := A_LoopField

        if (char = '"') {
            inQuote := !inQuote
        } else if (char = "," && !inQuote) {
            fields.Push(Trim(current))
            current := ""
        } else {
            current .= char
        }
    }

    fields.Push(Trim(current))
    return fields
}

AddRow(*) {
    ; Implementation for adding new row
    MsgBox("Add row dialog would appear here", "Add Row")
}

DeleteRow(*) {
    row := LV.GetNext()
    if (row) {
        LV.Delete(row)
        csvData.RemoveAt(row)
    }
}

SaveCSV(*) {
    if (!fileInput.Value) {
        MsgBox("No file loaded!", "Error")
        return
    }

    output := ArrayToCSVLine(headers) "`n"

    for row in csvData {
        output .= ArrayToCSVLine(row) "`n"
    }

    FileDelete(fileInput.Value)
    FileAppend(output, fileInput.Value)
    MsgBox("CSV saved!", "Success")
}

ExportJSON(*) {
    json := "[`n"

    for i, row in csvData {
        json .= "  {`n"
        for j, value in row {
            json .= '    "' headers[j] '": "' value '"'
            json .= (j < row.Length ? ",`n" : "`n")
        }
        json .= "  }" (i < csvData.Length ? ",`n" : "`n")
    }

    json .= "]"

    filename := "export_" FormatTime(, "yyyyMMdd_HHmmss") ".json"
    FileAppend(json, filename)
    MsgBox("Exported to " filename, "Success")
}

GenReport(*) {
    report := "CSV Data Report`n"
    report .= "Generated: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n`n"
    report .= "Total Rows: " csvData.Length "`n"
    report .= "Columns: " headers.Length "`n`n"

    for header in headers {
        report .= header ", "
    }

    MsgBox(report, "Report")
}

ArrayToCSVLine(arr) {
    line := ""
    for item in arr {
        if (InStr(item, ",") || InStr(item, '"'))
            item := '"' StrReplace(item, '"', '""') '"'
        line .= (line ? "," : "") item
    }
    return line
}
