#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Template Method Pattern - Defines skeleton algorithm in base class
; Demonstrates hook methods for customizable processing steps

class DataProcessor {
    Process(data) {
        data := this.Validate(data)
        data := this.Transform(data)
        return this.Format(data)
    }

    ; Template methods - override in subclasses
    Validate(data) => data
    Transform(data) => data
    Format(data) => data
}

class CsvProcessor extends DataProcessor {
    Validate(data) => StrReplace(data, '"', '')
    Transform(data) => StrUpper(data)
    Format(data) => "CSV: " data
}

class JsonProcessor extends DataProcessor {
    Transform(data) => Trim(data)
    Format(data) => '{"value":"' data '"}'
}

class MarkdownProcessor extends DataProcessor {
    Validate(data) => RegExReplace(data, "<[^>]+>", "")
    Transform(data) => "# " data
    Format(data) => data "`n`n---"
}

; Demo
processors := [
    CsvProcessor(),
    JsonProcessor(),
    MarkdownProcessor()
]

input := '  "Hello World"  '
result := ""

for processor in processors
    result .= Type(processor) ": " processor.Process(input) "`n`n"

MsgBox(result)
