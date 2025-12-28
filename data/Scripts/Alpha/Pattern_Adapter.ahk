#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Adapter Pattern - Converts interface of a class into another interface
; Demonstrates wrapping incompatible APIs for seamless integration

class OldApi {
    GetXml() => "<data><name>John</name><age>30</age></data>"
}

class JsonAdapter {
    __New(oldApi) => this.api := oldApi

    GetJson() {
        xml := this.api.GetXml()

        ; Parse XML to extract values
        result := Map()
        pos := 1
        while RegExMatch(xml, "<(\w+)>([^<]*)</\1>", &m, pos) {
            result[m[1]] := m[2]
            pos := m.Pos + m.Len
        }

        ; Build JSON string
        json := "{"
        first := true
        for key, value in result {
            if !first
                json .= ","
            json .= '"' key '":"' value '"'
            first := false
        }
        json .= "}"

        return json
    }
}

; Demo
legacyApi := OldApi()
adapter := JsonAdapter(legacyApi)

MsgBox("Original XML:`n" legacyApi.GetXml() "`n`nConverted JSON:`n" adapter.GetJson())
