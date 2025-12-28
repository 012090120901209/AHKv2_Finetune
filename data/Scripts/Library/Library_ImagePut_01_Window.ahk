#Requires AutoHotkey v2.0

; Library: iseahound/ImagePut
; Function: ImagePutWindow - Display image in a window
; Category: Image Processing
; Use Case: Show images, screenshots, or graphics in GUI windows

; Example: Display an image file in a window
; Note: Requires ImagePut.ahk library from iseahound/ImagePut

; #Include <ImagePut>

DemoImagePutWindow() {
    MsgBox("ImagePut Window Demonstration`n`n"
        "Display images from various sources:`n"
        "- Files: ImagePutWindow('photo.jpg')`n"
        "- URLs: ImagePutWindow('https://example.com/image.png')`n"
        "- Screenshots: ImagePutWindow([0,0,500,500])`n"
        "- Clipboard: ImagePutWindow('clipboard')`n`n"
        "Supported formats:`n"
        "BMP, JPG, PNG, GIF, TIFF, WebP, AVIF, HEIC, and more`n`n"
        "Install: Download from iseahound/ImagePut releases",
        "ImagePut Demo")
}

; Real implementation examples (commented out, requires library):
/*
; Example 1: Display image file
ShowImageFile() {
    ImagePutWindow("C:\Pictures\photo.jpg")
}

; Example 2: Display screenshot region
ShowScreenshot() {
    ; Capture region: [x, y, width, height]
    ImagePutWindow([0, 0, 800, 600])
}

; Example 3: Display from clipboard
ShowClipboardImage() {
    ImagePutWindow("clipboard")
}

; Example 4: Display from URL
ShowWebImage() {
    ImagePutWindow("https://via.placeholder.com/300")
}
*/

; Run demonstration
DemoImagePutWindow()
