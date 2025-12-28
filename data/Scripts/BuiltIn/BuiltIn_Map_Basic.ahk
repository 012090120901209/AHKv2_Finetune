; Title: Map - Key-Value Data Structure
; Category: Array
; Source: https://www.autohotkey.com/docs/v2/lib/Map.htm
; Description: Map (dictionary/hash table) creation and manipulation including iteration, checking keys, and nested structures.

#Requires AutoHotkey v2.0

; Create a map
person := Map()
person["name"] := "John Doe"
person["age"] := 30
person["city"] := "New York"

; Alternative creation syntax
settings := Map(
    "theme", "dark",
    "fontSize", 14,
    "autoSave", true
)

; Access values
MsgBox person["name"]  ; "John Doe"

; Check if key exists
if settings.Has("theme")
    MsgBox "Theme: " settings["theme"]

; Iterate through map
for key, value in person
    MsgBox key ": " value

; Remove items
person.Delete("city")

; Get keys and values
MsgBox "Count: " person.Count

; Nested maps
config := Map(
    "database", Map(
        "host", "localhost",
        "port", 3306
    ),
    "server", Map(
        "host", "0.0.0.0",
        "port", 8080
    )
)

MsgBox "DB Host: " config["database"]["host"]
