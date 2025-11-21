; Title: String Operations - StrReplace, SubStr, RegEx
; Category: String
; Source: https://www.autohotkey.com/docs/v2/lib/StrReplace.htm
; Description: Comprehensive string manipulation examples including replacement, substring extraction, searching, and regular expressions.

#Requires AutoHotkey v2.0

; StrReplace
text := "Hello World, World!"
newText := StrReplace(text, "World", "Universe")
MsgBox newText  ; "Hello Universe, Universe!"

; Case-sensitive replacement
newText := StrReplace(text, "world", "Universe", true)
MsgBox newText  ; No change (case doesn't match)

; SubStr
text := "Hello World"
MsgBox SubStr(text, 7)      ; "World"
MsgBox SubStr(text, 1, 5)   ; "Hello"
MsgBox SubStr(text, -5)     ; "World"

; InStr
pos := InStr(text, "World")
MsgBox "Found at position: " pos  ; 7

; Regular expressions
text := "My email is john@example.com"
if RegExMatch(text, "(\w+)@(\w+\.\w+)", &match)
    MsgBox "Email: " match[0] "`nUser: " match[1] "`nDomain: " match[2]

; RegExReplace
phone := "Phone: (555) 123-4567"
cleaned := RegExReplace(phone, "[^\d]", "")
MsgBox cleaned  ; "5551234567"

; String formatting
name := "John"
age := 30
message := Format("My name is {1} and I am {2} years old.", name, age)
MsgBox message
