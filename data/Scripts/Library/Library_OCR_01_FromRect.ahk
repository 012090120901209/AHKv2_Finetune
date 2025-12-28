#Requires AutoHotkey v2.0

; Library: Descolada/OCR
; Function: FromRect - Extract text from screen region
; Category: Optical Character Recognition
; Use Case: Read text from screenshots, images, or screen areas

; Example: OCR text from a screen region
; Note: Requires OCR.ahk library from Descolada/OCR

; #Include <OCR>

DemoOCRFromRect() {
    MsgBox("OCR FromRect Demonstration`n`n"
        "This function extracts text from a screen region.`n`n"
        "Usage with OCR library:`n"
        "result := OCR.FromRect(x, y, width, height)`n"
        "text := result.Text`n"
        "result.Highlight()  ; Highlight detected text`n`n"
        "Requirements:`n"
        "- Windows 10+ with language pack installed`n"
        "- Descolada/OCR library",
        "OCR FromRect Demo")
}

; Real implementation example (commented out, requires library):
/*
ExtractTextFromRegion() {
    ; Define screen region (x, y, width, height)
    x := 0
    y := 0
    width := 500
    height := 300

    ; Perform OCR on region
    result := OCR.FromRect(x, y, width, height)

    ; Display extracted text
    MsgBox("Extracted Text:`n`n" result.Text, "OCR Result")

    ; Highlight detected text areas
    result.Highlight()

    ; Optional: Click on specific text
    ; result.Click("Search")  ; Click text containing "Search"
}
*/

; Run demonstration
DemoOCRFromRect()
