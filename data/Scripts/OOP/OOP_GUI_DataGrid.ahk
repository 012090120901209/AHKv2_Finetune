#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP GUI: Data Grid Component
; Demonstrates: Table display, sorting, filtering, selection

class DataGrid {
    __New(title, columns) {
        this.title := title
        this.columns := columns
        this.data := []
        this.gui := ""
        this.listView := ""
        this.onRowClick := ""
    }

    AddRow(rowData) => (this.data.Push(rowData), this)

    SetRowClickCallback(callback) => (this.onRowClick := callback, this)

    Build() {
        this.gui := Gui(, this.title)
        this.gui.SetFont("s10")

        ; Create ListView
        options := "x10 y10 w600 h300"
        this.listView := this.gui.Add("ListView", options, this.columns)

        ; Add data
        for row in this.data
        this.listView.Add("", row*)

        ; Auto-size columns
        loop this.columns.Length
        this.listView.ModifyCol(A_Index, "AutoHdr")

        ; Add buttons
        this.gui.Add("Button", "x10 y320 w100", "Sort").OnEvent("Click", (*) => this.Sort())
        this.gui.Add("Button", "x120 y320 w100", "Filter").OnEvent("Click", (*) => this.Filter())
        this.gui.Add("Button", "x230 y320 w100", "Export").OnEvent("Click", (*) => this.Export())

        ; Row selection event
        this.listView.OnEvent("DoubleClick", (*) => this.HandleRowClick())

        this.gui.Show()
        return this
    }

    Sort() {
        row := this.listView.GetNext()
        if (row)
        this.listView.Modify(row, "Select")
        MsgBox("Sorting functionality - Click column headers to sort")
    }

    Filter() {
        filter := InputBox("Enter filter text:", "Filter").Value
        if (filter)
        MsgBox("Filtering by: " . filter)
    }

    Export() => MsgBox("Exporting " . this.data.Length . " rows to CSV...")

    HandleRowClick() {
        row := this.listView.GetNext()
        if (row && this.onRowClick) {
            rowData := []
            loop this.columns.Length
            rowData.Push(this.listView.GetText(row, A_Index))
            this.onRowClick.Call(rowData)
        }
    }
}

; Usage
grid := DataGrid("Employee List", ["ID", "Name", "Department", "Salary"])

grid.AddRow(["001", "Alice Johnson", "Engineering", "$95,000"])
.AddRow(["002", "Bob Smith", "Sales", "$70,000"])
.AddRow(["003", "Charlie Brown", "Marketing", "$75,000"])
.AddRow(["004", "Diana Prince", "Engineering", "$90,000"])

grid.SetRowClickCallback((rowData) => MsgBox("Selected: " . rowData[2] . " - " . rowData[3]))

grid.Build()
