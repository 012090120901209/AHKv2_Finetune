#Requires AutoHotkey v2.0
#SingleInstance Force

; Library: mmikeww/AHKv2-Gdip
; Function: Gdip_CreateBitmap - Create blank bitmap for drawing
; Category: Graphics (GDI+)
; Use Case: Custom graphics, image manipulation, overlays

; Example: Create bitmap and draw shapes
; Note: Requires Gdip_All.ahk from mmikeww/AHKv2-Gdip

; #Include <Gdip_All>

DemoGdipCreateBitmap() {
    MsgBox("GDI+ CreateBitmap Demonstration`n`n"
        "Create and manipulate bitmaps:`n`n"
        "Basic workflow:`n"
        "1. pToken := Gdip_Startup()`n"
        "2. pBitmap := Gdip_CreateBitmap(width, height)`n"
        "3. pGraphics := Gdip_GraphicsFromImage(pBitmap)`n"
        "4. Gdip_FillRectangle(...) ; Draw shapes`n"
        "5. Gdip_SaveBitmapToFile(pBitmap, 'output.png')`n"
        "6. Gdip_DisposeImage(pBitmap)`n"
        "7. Gdip_Shutdown(pToken)`n`n"
        "Use cases:`n"
        "- Custom GUI skins`n"
        "- Image editing`n"
        "- Data visualization`n"
        "- Game sprites",
        "GDI+ Demo")
}

; Real implementation example (commented out, requires library):
/*
CreateSimpleImage() {
    ; Initialize GDI+
    pToken := Gdip_Startup()

    ; Create 800x600 bitmap
    pBitmap := Gdip_CreateBitmap(800, 600)
    pGraphics := Gdip_GraphicsFromImage(pBitmap)

    ; Fill background
    pBrushBG := Gdip_BrushCreateSolid(0xFF1E1E1E)
    Gdip_FillRectangle(pGraphics, pBrushBG, 0, 0, 800, 600)

    ; Draw red rectangle
    pBrushRed := Gdip_BrushCreateSolid(0xFFFF0000)
    Gdip_FillRectangle(pGraphics, pBrushRed, 100, 100, 200, 150)

    ; Draw blue circle
    pBrushBlue := Gdip_BrushCreateSolid(0xFF0000FF)
    Gdip_FillEllipse(pGraphics, pBrushBlue, 400, 200, 150, 150)

    ; Save to file
    Gdip_SaveBitmapToFile(pBitmap, "output.png")

    ; Cleanup
    Gdip_DeleteBrush(pBrushBG)
    Gdip_DeleteBrush(pBrushRed)
    Gdip_DeleteBrush(pBrushBlue)
    Gdip_DeleteGraphics(pGraphics)
    Gdip_DisposeImage(pBitmap)
    Gdip_Shutdown(pToken)

    MsgBox("Image created: output.png")
}
*/

; Run demonstration
DemoGdipCreateBitmap()
