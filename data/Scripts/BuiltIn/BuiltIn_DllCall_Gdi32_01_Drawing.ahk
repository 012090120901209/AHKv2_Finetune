#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_DllCall_Gdi32_01_Drawing.ahk
 * 
 * DESCRIPTION:
 * Demonstrates drawing operations using GDI32 API through DllCall.
 * Shows how to draw lines, rectangles, ellipses, polygons, and other shapes
 * using device context handles.
 * 
 * FEATURES:
 * - Device context (DC) management
 * - Drawing lines with LineTo and MoveToEx
 * - Drawing rectangles and ellipses
 * - Polygon and polyline drawing
 * - Pen and brush creation
 * - Drawing arcs and chords
 * - Bezier curves
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - DllCall
 * https://www.autohotkey.com/docs/v2/lib/DllCall.htm
 * Microsoft GDI Drawing Functions
 * https://docs.microsoft.com/en-us/windows/win32/gdi/drawing-functions
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - DllCall() with GDI32 functions
 * - Device context handle management
 * - GDI object creation and selection
 * - Coordinate systems
 * - Resource cleanup
 * 
 * LEARNING POINTS:
 * 1. Getting and releasing device contexts
 * 2. Creating pens and brushes
 * 3. Drawing basic shapes
 * 4. Working with GDI handles
 * 5. Selecting objects into DC
 * 6. Cleaning up GDI resources
 * 7. Drawing complex paths
 */

global testGui := ""

;==============================================================================
; EXAMPLE 1: Basic Line Drawing
;==============================================================================
Example1_LineDrawing() {
    global testGui

    testGui := Gui(, "GDI Line Drawing")
    testGui.Add("Text", "w400 h300 Border")
    testGui.Show("w420 h320")

    hwnd := testGui.Hwnd
    hdc := DllCall("User32.dll\GetDC", "Ptr", hwnd, "Ptr")

    ; Create red pen
    RED_PEN := DllCall("Gdi32.dll\CreatePen"
        , "Int", 0          ; PS_SOLID
        , "Int", 2          ; width
        , "UInt", 0x000000FF  ; RGB(255,0,0)
        , "Ptr")

    oldPen := DllCall("Gdi32.dll\SelectObject", "Ptr", hdc, "Ptr", RED_PEN, "Ptr")

    ; Draw lines
    DllCall("Gdi32.dll\MoveToEx", "Ptr", hdc, "Int", 10, "Int", 10, "Ptr", 0, "Int")
    DllCall("Gdi32.dll\LineTo", "Ptr", hdc, "Int", 200, "Int", 10, "Int")
    DllCall("Gdi32.dll\LineTo", "Ptr", hdc, "Int", 200, "Int", 100, "Int")
    DllCall("Gdi32.dll\LineTo", "Ptr", hdc, "Int", 10, "Int", 100, "Int")
    DllCall("Gdi32.dll\LineTo", "Ptr", hdc, "Int", 10, "Int", 10, "Int")

    ; Cleanup
    DllCall("Gdi32.dll\SelectObject", "Ptr", hdc, "Ptr", oldPen, "Ptr")
    DllCall("Gdi32.dll\DeleteObject", "Ptr", RED_PEN, "Int")
    DllCall("User32.dll\ReleaseDC", "Ptr", hwnd, "Ptr", hdc, "Int")

    MsgBox("Line drawing complete!", "Success")
}

;==============================================================================
; EXAMPLE 2: Drawing Rectangles and Ellipses
;==============================================================================
Example2_ShapesDrawing() {
    global testGui

    testGui := Gui(, "GDI Shapes")
    testGui.Add("Text", "w400 h300 Border")
    testGui.Show("w420 h320")

    hwnd := testGui.Hwnd
    hdc := DllCall("User32.dll\GetDC", "Ptr", hwnd, "Ptr")

    ; Blue pen
    bluePen := DllCall("Gdi32.dll\CreatePen", "Int", 0, "Int", 2, "UInt", 0x00FF0000, "Ptr")
    oldPen := DllCall("Gdi32.dll\SelectObject", "Ptr", hdc, "Ptr", bluePen, "Ptr")

    ; Draw rectangle
    DllCall("Gdi32.dll\Rectangle"
        , "Ptr", hdc
        , "Int", 20, "Int", 20
        , "Int", 120, "Int", 80
        , "Int")

    ; Draw ellipse
    DllCall("Gdi32.dll\Ellipse"
        , "Ptr", hdc
        , "Int", 140, "Int", 20
        , "Int", 240, "Int", 80
        , "Int")

    ; Draw rounded rectangle
    DllCall("Gdi32.dll\RoundRect"
        , "Ptr", hdc
        , "Int", 20, "Int", 100
        , "Int", 120, "Int", 160
        , "Int", 20, "Int", 20
        , "Int")

    DllCall("Gdi32.dll\SelectObject", "Ptr", hdc, "Ptr", oldPen, "Ptr")
    DllCall("Gdi32.dll\DeleteObject", "Ptr", bluePen, "Int")
    DllCall("User32.dll\ReleaseDC", "Ptr", hwnd, "Ptr", hdc, "Int")

    MsgBox("Shapes drawn!", "Success")
}

;==============================================================================
; EXAMPLE 3: Filled Shapes with Brushes
;==============================================================================
Example3_FilledShapes() {
    global testGui

    testGui := Gui(, "Filled Shapes")
    testGui.Add("Text", "w400 h300 Border")
    testGui.Show("w420 h320")

    hwnd := testGui.Hwnd
    hdc := DllCall("User32.dll\GetDC", "Ptr", hwnd, "Ptr")

    ; Create green brush
    greenBrush := DllCall("Gdi32.dll\CreateSolidBrush", "UInt", 0x0000FF00, "Ptr")
    oldBrush := DllCall("Gdi32.dll\SelectObject", "Ptr", hdc, "Ptr", greenBrush, "Ptr")

    ; Filled rectangle
    DllCall("Gdi32.dll\Rectangle", "Ptr", hdc, "Int", 20, "Int", 20, "Int", 100, "Int", 80, "Int")

    ; Create yellow brush
    yellowBrush := DllCall("Gdi32.dll\CreateSolidBrush", "UInt", 0x0000FFFF, "Ptr")
    DllCall("Gdi32.dll\SelectObject", "Ptr", hdc, "Ptr", yellowBrush, "Ptr")

    ; Filled ellipse
    DllCall("Gdi32.dll\Ellipse", "Ptr", hdc, "Int", 120, "Int", 20, "Int", 200, "Int", 80, "Int")

    ; Cleanup
    DllCall("Gdi32.dll\SelectObject", "Ptr", hdc, "Ptr", oldBrush, "Ptr")
    DllCall("Gdi32.dll\DeleteObject", "Ptr", greenBrush, "Int")
    DllCall("Gdi32.dll\DeleteObject", "Ptr", yellowBrush, "Int")
    DllCall("User32.dll\ReleaseDC", "Ptr", hwnd, "Ptr", hdc, "Int")

    MsgBox("Filled shapes complete!", "Success")
}

;==============================================================================
; EXAMPLE 4: Polygon Drawing
;==============================================================================
Example4_Polygons() {
    global testGui

    testGui := Gui(, "Polygons")
    testGui.Add("Text", "w400 h300 Border")
    testGui.Show("w420 h320")

    hwnd := testGui.Hwnd
    hdc := DllCall("User32.dll\GetDC", "Ptr", hwnd, "Ptr")

    ; Create POINT array for triangle
    points := Buffer(12, 0)  ; 3 points * 4 bytes (2 ints) each
    NumPut("Int", 100, points, 0)   ; x1
    NumPut("Int", 20, points, 4)    ; y1
    NumPut("Int", 50, points, 8)    ; x2
    NumPut("Int", 80, points, 12)   ; y2
    NumPut("Int", 150, points, 16)  ; x3
    NumPut("Int", 80, points, 20)   ; y3

    redBrush := DllCall("Gdi32.dll\CreateSolidBrush", "UInt", 0x000000FF, "Ptr")
    oldBrush := DllCall("Gdi32.dll\SelectObject", "Ptr", hdc, "Ptr", redBrush, "Ptr")

    ; Draw polygon
    DllCall("Gdi32.dll\Polygon"
        , "Ptr", hdc
        , "Ptr", points.Ptr
        , "Int", 3
        , "Int")

    ; Draw pentagon
    points2 := Buffer(20, 0)  ; 5 points
    NumPut("Int", 250, points2, 0)
    NumPut("Int", 40, points2, 4)
    NumPut("Int", 280, points2, 8)
    NumPut("Int", 70, points2, 12)
    NumPut("Int", 265, points2, 16)
    NumPut("Int", 100, points2, 20)
    NumPut("Int", 235, points2, 24)
    NumPut("Int", 100, points2, 28)
    NumPut("Int", 220, points2, 32)
    NumPut("Int", 70, points2, 36)

    blueBrush := DllCall("Gdi32.dll\CreateSolidBrush", "UInt", 0x00FF0000, "Ptr")
    DllCall("Gdi32.dll\SelectObject", "Ptr", hdc, "Ptr", blueBrush, "Ptr")

    DllCall("Gdi32.dll\Polygon", "Ptr", hdc, "Ptr", points2.Ptr, "Int", 5, "Int")

    DllCall("Gdi32.dll\SelectObject", "Ptr", hdc, "Ptr", oldBrush, "Ptr")
    DllCall("Gdi32.dll\DeleteObject", "Ptr", redBrush, "Int")
    DllCall("Gdi32.dll\DeleteObject", "Ptr", blueBrush, "Int")
    DllCall("User32.dll\ReleaseDC", "Ptr", hwnd, "Ptr", hdc, "Int")

    MsgBox("Polygons drawn!", "Success")
}

;==============================================================================
; EXAMPLE 5: Arcs and Chords
;==============================================================================
Example5_ArcsChords() {
    global testGui

    testGui := Gui(, "Arcs and Chords")
    testGui.Add("Text", "w400 h300 Border")
    testGui.Show("w420 h320")

    hwnd := testGui.Hwnd
    hdc := DllCall("User32.dll\GetDC", "Ptr", hwnd, "Ptr")

    ; Draw arc
    DllCall("Gdi32.dll\Arc"
        , "Ptr", hdc
        , "Int", 20, "Int", 20    ; left, top
        , "Int", 120, "Int", 120  ; right, bottom
        , "Int", 70, "Int", 20    ; xStartArc, yStartArc
        , "Int", 20, "Int", 70    ; xEndArc, yEndArc
        , "Int")

    ; Draw chord
    DllCall("Gdi32.dll\Chord"
        , "Ptr", hdc
        , "Int", 140, "Int", 20
        , "Int", 240, "Int", 120
        , "Int", 190, "Int", 20
        , "Int", 140, "Int", 70
        , "Int")

    ; Draw pie
    greenBrush := DllCall("Gdi32.dll\CreateSolidBrush", "UInt", 0x0000FF00, "Ptr")
    oldBrush := DllCall("Gdi32.dll\SelectObject", "Ptr", hdc, "Ptr", greenBrush, "Ptr")

    DllCall("Gdi32.dll\Pie"
        , "Ptr", hdc
        , "Int", 260, "Int", 20
        , "Int", 360, "Int", 120
        , "Int", 310, "Int", 20
        , "Int", 360, "Int", 70
        , "Int")

    DllCall("Gdi32.dll\SelectObject", "Ptr", hdc, "Ptr", oldBrush, "Ptr")
    DllCall("Gdi32.dll\DeleteObject", "Ptr", greenBrush, "Int")
    DllCall("User32.dll\ReleaseDC", "Ptr", hwnd, "Ptr", hdc, "Int")

    MsgBox("Arcs and chords drawn!", "Success")
}

;==============================================================================
; EXAMPLE 6: Polylines and Connected Lines
;==============================================================================
Example6_Polylines() {
    global testGui

    testGui := Gui(, "Polylines")
    testGui.Add("Text", "w400 h300 Border")
    testGui.Show("w420 h320")

    hwnd := testGui.Hwnd
    hdc := DllCall("User32.dll\GetDC", "Ptr", hwnd, "Ptr")

    ; Create thick green pen
    greenPen := DllCall("Gdi32.dll\CreatePen", "Int", 0, "Int", 3, "UInt", 0x0000FF00, "Ptr")
    oldPen := DllCall("Gdi32.dll\SelectObject", "Ptr", hdc, "Ptr", greenPen, "Ptr")

    ; Polyline (zigzag pattern)
    points := Buffer(40, 0)  ; 10 points
    Loop 10 {
        x := 20 + (A_Index - 1) * 35
        y := (Mod(A_Index, 2) = 1) ? 50 : 100
        NumPut("Int", x, points, (A_Index - 1) * 8)
        NumPut("Int", y, points, (A_Index - 1) * 8 + 4)
    }

    DllCall("Gdi32.dll\Polyline", "Ptr", hdc, "Ptr", points.Ptr, "Int", 10, "Int")

    DllCall("Gdi32.dll\SelectObject", "Ptr", hdc, "Ptr", oldPen, "Ptr")
    DllCall("Gdi32.dll\DeleteObject", "Ptr", greenPen, "Int")
    DllCall("User32.dll\ReleaseDC", "Ptr", hwnd, "Ptr", hdc, "Int")

    MsgBox("Polylines drawn!", "Success")
}

;==============================================================================
; EXAMPLE 7: Bezier Curves
;==============================================================================
Example7_BezierCurves() {
    global testGui

    testGui := Gui(, "Bezier Curves")
    testGui.Add("Text", "w400 h300 Border")
    testGui.Show("w420 h320")

    hwnd := testGui.Hwnd
    hdc := DllCall("User32.dll\GetDC", "Ptr", hwnd, "Ptr")

    ; Create purple pen
    purplePen := DllCall("Gdi32.dll\CreatePen", "Int", 0, "Int", 2, "UInt", 0x00FF00FF, "Ptr")
    oldPen := DllCall("Gdi32.dll\SelectObject", "Ptr", hdc, "Ptr", purplePen, "Ptr")

    ; Bezier curve (4 control points)
    points := Buffer(16, 0)
    NumPut("Int", 50, points, 0)    ; start x
    NumPut("Int", 150, points, 4)   ; start y
    NumPut("Int", 100, points, 8)   ; control1 x
    NumPut("Int", 50, points, 12)   ; control1 y
    NumPut("Int", 200, points, 16)  ; control2 x
    NumPut("Int", 50, points, 20)   ; control2 y
    NumPut("Int", 250, points, 24)  ; end x
    NumPut("Int", 150, points, 28)  ; end y

    DllCall("Gdi32.dll\PolyBezier", "Ptr", hdc, "Ptr", points.Ptr, "Int", 4, "Int")

    DllCall("Gdi32.dll\SelectObject", "Ptr", hdc, "Ptr", oldPen, "Ptr")
    DllCall("Gdi32.dll\DeleteObject", "Ptr", purplePen, "Int")
    DllCall("User32.dll\ReleaseDC", "Ptr", hwnd, "Ptr", hdc, "Int")

    MsgBox("Bezier curve drawn!", "Success")
}

;==============================================================================
; DEMO MENU
;==============================================================================

ShowDemoMenu() {
    menu := "
    (
    GDI Drawing DllCall Examples
    =============================

    1. Line Drawing
    2. Rectangles and Ellipses
    3. Filled Shapes
    4. Polygons
    5. Arcs and Chords
    6. Polylines
    7. Bezier Curves

    Enter choice (1-7) or 0 to exit:
    )"

    Loop {
        choice := InputBox(menu, "GDI Drawing Examples", "w400 h350").Value

        if (choice = "0" or choice = "")
            break

        switch choice {
            case "1": Example1_LineDrawing()
            case "2": Example2_ShapesDrawing()
            case "3": Example3_FilledShapes()
            case "4": Example4_Polygons()
            case "5": Example5_ArcsChords()
            case "6": Example6_Polylines()
            case "7": Example7_BezierCurves()
            default: MsgBox("Invalid choice! Please enter 1-7.", "Error", "IconX")
        }
    }
}

; Run the demo menu
ShowDemoMenu()
