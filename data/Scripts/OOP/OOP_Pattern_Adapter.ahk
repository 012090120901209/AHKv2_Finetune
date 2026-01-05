#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Pattern: Adapter Pattern
; Demonstrates: Interface adaptation, legacy code integration

class ModernAPI {
    ProcessData(data) => MsgBox("Modern API processing: " data.ToString())
}

class LegacySystem {
    Process(csvString) => MsgBox("Legacy system received: " csvString)
}

class LegacyAdapter extends ModernAPI {
    __New(legacySystem) => this.legacy := legacySystem

    ProcessData(data) {
        csv := this.ConvertToCSV(data)
        this.legacy.Process(csv)
    }

    ConvertToCSV(data) {
        result := ""
        for key, value in data.OwnProps()
            result .= (result ? "," : "") . value
        return result
    }
}

; Usage - seamless integration
modern := ModernAPI()
legacy := LegacySystem()
adapter := LegacyAdapter(legacy)

data := { name: "John", age: 30, city: "NYC" }

modern.ProcessData(data)    ; Modern way
adapter.ProcessData(data)   ; Adapted to legacy

