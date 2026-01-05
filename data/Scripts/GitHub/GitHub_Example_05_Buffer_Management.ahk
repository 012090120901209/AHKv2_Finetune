#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Buffer Management Patterns
 * Source: Patterns from jNizM examples
 * 
 * Demonstrates:
 * - Buffer() for memory allocation (AHK v2 way)
 * - NumPut/NumGet for binary data
 * - StrPut/StrGet for string encoding
 * - Working with pointers and DllCall
 */

; Example 1: Basic Buffer allocation
CreateBuffer() {
    ; Allocate 16 bytes, initialized to zero
    buf := Buffer(16, 0)

    ; Write integers to buffer
    NumPut("UInt", 12345, buf, 0)      ; Offset 0
    NumPut("UInt", 67890, buf, 4)      ; Offset 4

    ; Read back
    val1 := NumGet(buf, 0, "UInt")
    val2 := NumGet(buf, 4, "UInt")

    MsgBox("Buffer Example:`n"
        . "Value 1: " val1 "`n"
        . "Value 2: " val2)
}

; Example 2: String in Buffer
StringBuffer() {
    text := "Hello, World!"

    ; Calculate required buffer size
    size := StrPut(text, "UTF-8")

    ; Create buffer and write string
    buf := Buffer(size)
    StrPut(text, buf, "UTF-8")

    ; Read back
    retrieved := StrGet(buf, "UTF-8")

    MsgBox("String Buffer:`n"
        . "Original: " text "`n"
        . "Retrieved: " retrieved)
}

; Example 3: Struct-like usage
PointStruct() {
    ; Create a POINT structure (x, y coordinates)
    point := Buffer(8)  ; 2 integers = 8 bytes

    NumPut("Int", 150, point, 0)  ; x coordinate
    NumPut("Int", 200, point, 4)  ; y coordinate

    x := NumGet(point, 0, "Int")
    y := NumGet(point, 4, "Int")

    MsgBox("POINT Structure:`n"
        . "X: " x "`n"
        . "Y: " y)
}

; Run all examples
CreateBuffer()
Sleep(1000)
StringBuffer()
Sleep(1000)
PointStruct()
