#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; INI Parser - Parses and generates INI configuration files
; Demonstrates section-based configuration handling

class INI {
    static Parse(text) {
        result := Map()
        currentSection := ""

        for line in StrSplit(text, "`n") {
            line := Trim(line, " `t`r")

            ; Skip empty lines and comments
            if line = "" || SubStr(line, 1, 1) = ";" || SubStr(line, 1, 1) = "#"
                continue

            ; Section header
            if RegExMatch(line, "^\[(.+)\]$", &m) {
                currentSection := m[1]
                result[currentSection] := Map()
            }
            ; Key=Value pair
            else if RegExMatch(line, "^([^=]+)=(.*)$", &m) {
                key := Trim(m[1])
                value := Trim(m[2])

                ; Handle quoted values
                if RegExMatch(value, '^"(.*)"$', &q)
                    value := q[1]

                if currentSection
                    result[currentSection][key] := value
            }
        }

        return result
    }

    static Stringify(data) {
        result := ""

        for section, values in data {
            result .= "[" section "]`n"
            for key, value in values {
                ; Quote values with special characters
                if InStr(value, "=") || InStr(value, "`n") || InStr(value, ";")
                    value := '"' value '"'
                result .= key "=" value "`n"
            }
            result .= "`n"
        }

        return RTrim(result, "`n")
    }

    ; Get nested value with default
    static Get(data, section, key, defaultVal := "") {
        if !data.Has(section)
            return defaultVal
        if !data[section].Has(key)
            return defaultVal
        return data[section][key]
    }

    ; Set nested value (creates section if needed)
    static Set(data, section, key, value) {
        if !data.Has(section)
            data[section] := Map()
        data[section][key] := value
    }
}

; Demo
iniText := "
(
; Application Configuration
[General]
AppName=My Application
Version=1.0.0
Debug=true

[Database]
Host=localhost
Port=5432
Name=mydb
User="admin"

[UI]
Theme=dark
FontSize=12
ShowToolbar=true
)"

; Parse
config := INI.Parse(iniText)

result := "Parsed Configuration:`n`n"
for section, values in config {
    result .= "[" section "]`n"
    for key, value in values
        result .= "  " key " = " value "`n"
    result .= "`n"
}

MsgBox(result)

; Access values
dbHost := INI.Get(config, "Database", "Host", "127.0.0.1")
missing := INI.Get(config, "Missing", "Key", "default")

MsgBox("Database Host: " dbHost "`nMissing Key: " missing)

; Modify and stringify
INI.Set(config, "General", "Version", "2.0.0")
INI.Set(config, "NewSection", "NewKey", "NewValue")

MsgBox("Generated INI:`n`n" INI.Stringify(config))
