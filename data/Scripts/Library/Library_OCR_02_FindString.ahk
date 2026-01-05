#Requires AutoHotkey v2.0
#SingleInstance Force

; Library: Descolada/OCR
; Function: FindString - Search for specific text in OCR results
; Category: Optical Character Recognition
; Use Case: Locate and interact with specific text on screen

; Example: Find and click specific text using OCR
; Note: Requires OCR.ahk library from Descolada/OCR

; #Include <OCR>

DemoOCRFindString() {
    MsgBox("OCR FindString Demonstration`n`n"
        "Find and interact with specific text on screen.`n`n"
        "Usage with OCR library:`n"
        "result := OCR.FromDesktop()`n"
        "found := result.FindString('Search Text')`n"
        "found.Click()  ; Click the found text`n`n"
        "Common use cases:`n"
        "- Click buttons by text in legacy apps`n"
        "- Find and copy specific text`n"
        "- Verify text presence for automation",
        "OCR FindString Demo")
}

; Real implementation example (commented out, requires library):
/*
ClickButtonByText(buttonText) {
    ; Scan entire desktop
    result := OCR.FromDesktop()

    ; Find specific text
    found := result.FindString(buttonText)

    ; Click if found
    if (found) {
        found.Click()
        MsgBox("Clicked: " buttonText)
    } else {
        MsgBox("Text not found: " buttonText)
    }
}

; Example: Click "Submit" button
; ClickButtonByText("Submit")
*/

; Run demonstration
DemoOCRFindString()
