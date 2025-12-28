#Requires AutoHotkey v2.0

/**
 * BuiltIn_COM_IE_04_Tables.ahk
 * 
 * DESCRIPTION:
 * Table extraction and manipulation in IE using COM.
 * 
 * FEATURES:
 * - Reading table data
 * - Extracting rows and cells
 * - Table navigation
 * - Data extraction
 * - Table modification
 */

Example1_ReadTable() {
    MsgBox("Example 1: Read Table Data")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        html := "<table id='data'><tr><td>A1</td><td>B1</td></tr><tr><td>A2</td><td>B2</td></tr></table>"
        ie.Document.write(html)
        Sleep(500)
        table := ie.Document.getElementById("data")
        MsgBox("Table rows: " table.rows.length)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example2_ExtractCells() {
    MsgBox("Example 2: Extract Cell Data")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        html := "<table id='t'><tr><td id='cell'>Value</td></tr></table>"
        ie.Document.write(html)
        Sleep(500)
        cell := ie.Document.getElementById("cell")
        MsgBox("Cell: " cell.innerText)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example3_IterateRows() {
    MsgBox("Example 3: Iterate Table Rows")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        html := "<table id='t'><tr><td>R1</td></tr><tr><td>R2</td></tr></table>"
        ie.Document.write(html)
        Sleep(500)
        table := ie.Document.getElementById("t")
        output := "Rows:`n"
        Loop table.rows.length
            output .= "Row " A_Index "`n"
        MsgBox(output)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example4_GetCellValue() {
    MsgBox("Example 4: Get Specific Cell")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        html := "<table><tr><td>Cell1</td><td>Cell2</td></tr></table>"
        ie.Document.write(html)
        MsgBox("Table created")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example5_ModifyCell() {
    MsgBox("Example 5: Modify Cell")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        html := "<table><tr><td id='modify'>Old</td></tr></table>"
        ie.Document.write(html)
        Sleep(500)
        ie.Document.getElementById("modify").innerText := "New"
        MsgBox("Cell modified!")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example6_AddRow() {
    MsgBox("Example 6: Add Table Row")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        html := "<table id='t'><tr><td>R1</td></tr></table>"
        ie.Document.write(html)
        Sleep(500)
        table := ie.Document.getElementById("t")
        newRow := table.insertRow(-1)
        newCell := newRow.insertCell(-1)
        newCell.innerText := "New Row"
        MsgBox("Row added!")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example7_TableToArray() {
    MsgBox("Example 7: Table to Array")
    Try {
        ie := ComObject("InternetExplorer.Application")
        ie.Visible := true
        html := "<table id='data'><tr><td>1</td><td>2</td></tr></table>"
        ie.Document.write(html)
        MsgBox("Table extraction ready")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

ShowMenu() {
    menu := "
    (
    IE COM - Tables

    1. Read Table
    2. Extract Cells
    3. Iterate Rows
    4. Get Cell Value
    5. Modify Cell
    6. Add Row
    7. Table to Array

    0. Exit
    )"
    choice := InputBox(menu, "Table Examples", "w300 h400").Value
    switch choice {
        case "1": Example1_ReadTable()
        case "2": Example2_ExtractCells()
        case "3": Example3_IterateRows()
        case "4": Example4_GetCellValue()
        case "5": Example5_ModifyCell()
        case "6": Example6_AddRow()
        case "7": Example7_TableToArray()
        case "0": return
        default: MsgBox("Invalid!")
    }
    if MsgBox("Run another?", "Continue?", "YesNo") = "Yes"
        ShowMenu()
}
ShowMenu()
