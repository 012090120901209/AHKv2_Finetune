#Requires AutoHotkey v2.0

; Library: iseahound/ImagePut
; Function: ImagePutClipboard - Copy image to clipboard
; Category: Image Processing
; Use Case: Screenshot tools, image manipulation, clipboard operations

; Example: Capture screen region and copy to clipboard
; Note: Requires ImagePut.ahk library from iseahound/ImagePut

; #Include <ImagePut>

DemoImagePutClipboard() {
    MsgBox("ImagePut Clipboard Demonstration`n`n"
          "Copy images to clipboard from various sources:`n`n"
          "1. Screenshot: ImagePutClipboard([0,0,500,500])`n"
          "2. File: ImagePutClipboard('photo.jpg')`n"
          "3. URL: ImagePutClipboard('https://...')`n"
          "4. Convert: ImagePutClipboard('file.bmp')  ; Auto-converts`n`n"
          "The image is ready to paste in any application.`n`n"
          "Perfect for: Screenshot tools, image converters, automation",
          "ImagePut Clipboard Demo")
}

; Real implementation examples (commented out, requires library):
/*
; Example 1: Screenshot to clipboard (hotkey)
^+s:: {  ; Ctrl+Shift+S
    ; Capture full screen
    ImagePutClipboard("screen")
    ToolTip("Screenshot copied to clipboard")
    SetTimer(() => ToolTip(), -2000)
}

; Example 2: Region selector and copy
CaptureRegion() {
    ; This would typically involve mouse selection
    ; For demo: capture fixed region
    x := 100, y := 100, w := 500, h := 400

    ImagePutClipboard([x, y, w, h])
    MsgBox("Region captured to clipboard!")
}

; Example 3: Convert file format via clipboard
ConvertToClipboard(filepath) {
    ; Reads any format, converts to clipboard format
    ImagePutClipboard(filepath)
}
*/

; Run demonstration
DemoImagePutClipboard()
