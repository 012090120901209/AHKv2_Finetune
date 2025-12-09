#Requires AutoHotkey v2.0

/**
* BuiltIn_COM_Word_04_Tables.ahk
*
* DESCRIPTION:
* Demonstrates creating and manipulating tables in Microsoft Word using COM automation.
*
* FEATURES:
* - Creating tables
* - Adding and formatting table content
* - Table cell merging and splitting
* - Table borders and shading
* - Adding rows and columns dynamically
*
* SOURCE:
* AutoHotkey v2 Documentation - ComObject
* https://www.autohotkey.com/docs/v2/lib/ComObject.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - ComObject() for Word automation
* - Tables collection
* - Cell and Row objects
*
* LEARNING POINTS:
* 1. Creating tables programmatically
* 2. Populating table cells with data
* 3. Formatting tables professionally
* 4. Adding and removing rows/columns
* 5. Merging cells for complex layouts
* 6. Applying borders and shading
* 7. Converting text to tables
*/

; Example 1-7 implementations
Example1_CreateBasicTable() {
    MsgBox("Example 1: Basic Table Creation")
    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()

        table := doc.Tables.Add(word.Selection.Range, 5, 3)
        table.Borders.Enable := true

        Loop 5 {
            row := A_Index
            Loop 3 {
                col := A_Index
                table.Cell(row, col).Range.Text := "R" row "C" col
            }
        }
        MsgBox("Table created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
        if IsSet(word)
        word.Quit()
    }
}

Example2_FormattedTable() {
    MsgBox("Example 2: Formatted Table")
    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()

        table := doc.Tables.Add(word.Selection.Range, 4, 3)

        table.Cell(1, 1).Range.Text := "Product"
        table.Cell(1, 2).Range.Text := "Price"
        table.Cell(1, 3).Range.Text := "Quantity"

        table.Rows(1).Range.Font.Bold := true
        table.Rows(1).Shading.BackgroundPatternColor := 0xCCCCCC

        products := [["Laptop", "$999", "10"], ["Mouse", "$25", "50"], ["Keyboard", "$75", "30"]]
        Loop products.Length {
            table.Cell(A_Index + 1, 1).Range.Text := products[A_Index][1]
            table.Cell(A_Index + 1, 2).Range.Text := products[A_Index][2]
            table.Cell(A_Index + 1, 3).Range.Text := products[A_Index][3]
        }

        table.AutoFitBehavior(2)
        MsgBox("Formatted table created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
        if IsSet(word)
        word.Quit()
    }
}

Example3_DynamicTable() {
    MsgBox("Example 3: Dynamic Rows")
    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()

        table := doc.Tables.Add(word.Selection.Range, 2, 2)
        table.Cell(1, 1).Range.Text := "Name"
        table.Cell(1, 2).Range.Text := "Value"

        Loop 10 {
            newRow := table.Rows.Add()
            newRow.Cells(1).Range.Text := "Item " A_Index
            newRow.Cells(2).Range.Text := Random(100, 999)
        }
        MsgBox("Dynamic table with " table.Rows.Count " rows created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
        if IsSet(word)
        word.Quit()
    }
}

Example4_MergedCells() {
    MsgBox("Example 4: Cell Merging")
    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()

        table := doc.Tables.Add(word.Selection.Range, 4, 4)

        table.Cell(1, 1).Range.Text := "Merged Title"
        table.Cell(1, 1).Merge(table.Cell(1, 4))
        table.Rows(1).Range.ParagraphFormat.Alignment := 1
        table.Rows(1).Range.Font.Bold := true

        Loop 3 {
            row := A_Index + 1
            Loop 4 {
                table.Cell(row, A_Index).Range.Text := "R" row "C" A_Index
            }
        }
        MsgBox("Table with merged cells created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
        if IsSet(word)
        word.Quit()
    }
}

Example5_ColoredTable() {
    MsgBox("Example 5: Colored Table")
    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()

        table := doc.Tables.Add(word.Selection.Range, 6, 3)

        table.Rows(1).Shading.BackgroundPatternColor := 0x0000FF
        table.Rows(1).Range.Font.Color := 0xFFFFFF

        Loop table.Rows.Count - 1 {
            if Mod(A_Index, 2) = 0
            table.Rows(A_Index + 1).Shading.BackgroundPatternColor := 0xF0F0F0
        }
        MsgBox("Colored table created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
        if IsSet(word)
        word.Quit()
    }
}

Example6_BorderStyles() {
    MsgBox("Example 6: Border Styles")
    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()

        table := doc.Tables.Add(word.Selection.Range, 4, 4)

        table.Borders.OutsideLineStyle := 1
        table.Borders.OutsideLineWidth := 24
        table.Borders.InsideLineStyle := 1
        table.Borders.InsideLineWidth := 4

        Loop table.Rows.Count {
            row := A_Index
            Loop 4 {
                table.Cell(row, A_Index).Range.Text := "Cell " row "," A_Index
            }
        }
        MsgBox("Table with custom borders created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
        if IsSet(word)
        word.Quit()
    }
}

Example7_DataTable() {
    MsgBox("Example 7: Data Report Table")
    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()
        selection := word.Selection

        selection.Font.Size := 16
        selection.Font.Bold := true
        selection.TypeText("Sales Report - Q4 2024`n`n")

        table := doc.Tables.Add(selection.Range, 6, 4)

        table.Cell(1, 1).Range.Text := "Region"
        table.Cell(1, 2).Range.Text := "Sales"
        table.Cell(1, 3).Range.Text := "Growth"
        table.Cell(1, 4).Range.Text := "Target"

        table.Rows(1).Range.Font.Bold := true
        table.Rows(1).Shading.BackgroundPatternColor := 0x404040
        table.Rows(1).Range.Font.Color := 0xFFFFFF

        regions := ["North", "South", "East", "West", "Central"]
        Loop regions.Length {
            table.Cell(A_Index + 1, 1).Range.Text := regions[A_Index]
            table.Cell(A_Index + 1, 2).Range.Text := "$" Random(50, 150) "K"
            table.Cell(A_Index + 1, 3).Range.Text := Random(5, 25) "%"
            table.Cell(A_Index + 1, 4).Range.Text := "$" Random(100, 200) "K"
        }

        table.AutoFitBehavior(1)
        MsgBox("Sales report table created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
        if IsSet(word)
        word.Quit()
    }
}

ShowMenu() {
    menu := "Word COM - Tables`n`n"
    . "1. Basic Table`n"
    . "2. Formatted Table`n"
    . "3. Dynamic Rows`n"
    . "4. Merged Cells`n"
    . "5. Colored Table`n"
    . "6. Border Styles`n"
    . "7. Data Report Table`n`n"
    . "0. Exit"

    choice := InputBox(menu, "Word Table Examples", "w300 h400").Value

    switch choice {
        case "1": Example1_CreateBasicTable()
        case "2": Example2_FormattedTable()
        case "3": Example3_DynamicTable()
        case "4": Example4_MergedCells()
        case "5": Example5_ColoredTable()
        case "6": Example6_BorderStyles()
        case "7": Example7_DataTable()
        case "0": return
        default: MsgBox("Invalid choice!")
    }

    result := MsgBox("Run another example?", "Continue?", "YesNo")
    if (result = "Yes")
    ShowMenu()
}

ShowMenu()
