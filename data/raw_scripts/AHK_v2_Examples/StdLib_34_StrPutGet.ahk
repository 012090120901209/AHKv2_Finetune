#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * StrPut/StrGet() - Encoding operations
 *
 * Write/read strings to/from buffers with specific encodings.
 */

text := "Hello 世界"

; StrPut - Write to buffer
buf := Buffer(StrPut(text, "UTF-8"))
StrPut(text, buf, "UTF-8")

; StrGet - Read from buffer
retrieved := StrGet(buf, "UTF-8")

MsgBox("Original: " text
    . "`nBuffer size: " buf.Size
    . "`nRetrieved: " retrieved)
