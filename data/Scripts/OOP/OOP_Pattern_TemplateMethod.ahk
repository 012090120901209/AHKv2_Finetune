#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Pattern: Template Method
; Demonstrates: Algorithm skeleton, customizable steps, code reuse

class DataProcessor {
    Process() {
        this.LoadData()
        this.ValidateData()
        this.TransformData()
        this.SaveData()
    }

    LoadData() => throw Error("Must implement LoadData()")
    ValidateData() => throw Error("Must implement ValidateData()")
    TransformData() => throw Error("Must implement TransformData()")
    SaveData() => throw Error("Must implement SaveData()")
}

class CSVProcessor extends DataProcessor {
    __New(file) => this.file := file
    LoadData() => (this.data := "CSV data from " this.file, MsgBox("Loading CSV..."))
    ValidateData() => MsgBox("Validating CSV structure...")
    TransformData() => (this.data := StrUpper(this.data), MsgBox("Transforming CSV..."))
    SaveData() => MsgBox("Saving: " this.data)
}

class JSONProcessor extends DataProcessor {
    __New(file) => this.file := file
    LoadData() => (this.data := '{"data": "from ' this.file '"}', MsgBox("Loading JSON..."))
    ValidateData() => MsgBox("Validating JSON syntax...")
    TransformData() => (this.data := StrReplace(this.data, "data", "processed"), MsgBox("Transforming JSON..."))
    SaveData() => MsgBox("Saving: " this.data)
}

class XMLProcessor extends DataProcessor {
    __New(file) => this.file := file
    LoadData() => (this.data := "<data>" this.file "</data>", MsgBox("Loading XML..."))
    ValidateData() => MsgBox("Validating XML schema...")
    TransformData() => (this.data := StrReplace(this.data, "<data>", "<processed>"), MsgBox("Transforming XML..."))
    SaveData() => MsgBox("Saving: " this.data)
}

; Usage - same algorithm, different implementations
CSVProcessor("data.csv").Process()
