; Title: FileRead and FileAppend - File Operations
; Category: File
; Source: https://www.autohotkey.com/docs/v2/lib/FileRead.htm
; Description: File reading and writing operations including error handling, encodings, and line-by-line processing.

#Requires AutoHotkey v2.0

; Read entire file
try {
    contents := FileRead("C:\MyFile.txt")
    MsgBox contents
} catch as err {
    MsgBox "Error reading file: " err.Message
}

; Read with specific encoding
contents := FileRead("C:\MyFile.txt", "UTF-8")

; Write to file (overwrites existing)
FileAppend "This is new content`n", "C:\Output.txt"

; Append to file
FileAppend "Additional line`n", "C:\Output.txt"

; Read and process line by line
Loop Read, "C:\MyFile.txt"
 {
    if InStr(A_LoopReadLine, "search term")
    MsgBox "Found on line " A_Index ": " A_LoopReadLine
}

; Write processed content to new file
Loop Read, "C:\Input.txt", "C:\Output.txt"
 {
    ; Convert to uppercase
    FileAppend StrUpper(A_LoopReadLine) "`n"
}
