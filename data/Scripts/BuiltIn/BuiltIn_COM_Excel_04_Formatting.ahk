#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_COM_Excel_04_Formatting.ahk
 * 
 * DESCRIPTION:
 * Demonstrates cell formatting operations in Microsoft Excel using COM automation.
 * Covers fonts, colors, borders, number formats, and conditional formatting.
 * 
 * FEATURES:
 * - Font formatting (bold, italic, size, color)
 * - Cell background colors and patterns
 * - Borders and gridlines
 * - Number formatting (currency, dates, percentages)
 * - Column and row sizing
 * - Alignment and text wrapping
 * - Conditional formatting
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - ComObject
 * https://www.autohotkey.com/docs/v2/lib/ComObject.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - ComObject() for Excel automation
 * - Accessing Font, Interior, and Borders objects
 * - Using Excel constants for formatting
 * - Property chaining for complex formatting
 * 
 * LEARNING POINTS:
 * 1. How to format fonts and text appearance
 * 2. Applying colors to cells and text
 * 3. Adding and customizing borders
 * 4. Using number format strings
 * 5. Auto-sizing columns and rows
 * 6. Text alignment and wrapping
 * 7. Creating professional-looking spreadsheets
 */

;===============================================================================
; Example 1: Font Formatting
;===============================================================================
Example1_FontFormatting() {
    MsgBox("Example 1: Font Formatting`n`nDemonstrating various font formatting options.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Title
        sheet.Range("A1").Value := "Font Formatting Examples"
        sheet.Range("A1").Font.Size := 16
        sheet.Range("A1").Font.Bold := true
        sheet.Range("A1").Font.Color := 0x0000FF  ; Red (BGR format)

        ; Bold
        sheet.Range("A3").Value := "Bold Text"
        sheet.Range("A3").Font.Bold := true

        ; Italic
        sheet.Range("A4").Value := "Italic Text"
        sheet.Range("A4").Font.Italic := true

        ; Bold and Italic
        sheet.Range("A5").Value := "Bold & Italic"
        sheet.Range("A5").Font.Bold := true
        sheet.Range("A5").Font.Italic := true

        ; Underline
        sheet.Range("A6").Value := "Underlined Text"
        sheet.Range("A6").Font.Underline := 2  ; xlUnderlineStyleSingle

        ; Strikethrough
        sheet.Range("A7").Value := "Strikethrough Text"
        sheet.Range("A7").Font.Strikethrough := true

        ; Font size variations
        sheet.Range("A9").Value := "Size 8"
        sheet.Range("A9").Font.Size := 8

        sheet.Range("A10").Value := "Size 12"
        sheet.Range("A10").Font.Size := 12

        sheet.Range("A11").Value := "Size 18"
        sheet.Range("A11").Font.Size := 18

        ; Font colors
        sheet.Range("B3").Value := "Red"
        sheet.Range("B3").Font.Color := 0x0000FF  ; BGR: Red

        sheet.Range("B4").Value := "Green"
        sheet.Range("B4").Font.Color := 0x00FF00  ; BGR: Green

        sheet.Range("B5").Value := "Blue"
        sheet.Range("B5").Font.Color := 0xFF0000  ; BGR: Blue

        ; Font names
        sheet.Range("C3").Value := "Arial"
        sheet.Range("C3").Font.Name := "Arial"

        sheet.Range("C4").Value := "Times New Roman"
        sheet.Range("C4").Font.Name := "Times New Roman"

        sheet.Range("C5").Value := "Courier New"
        sheet.Range("C5").Font.Name := "Courier New"

        ; Auto-fit columns
        sheet.Columns("A:C").AutoFit()

        MsgBox("Font formatting complete!`n`nVarious font styles, sizes, and colors demonstrated.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 1:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 2: Cell Colors and Backgrounds
;===============================================================================
Example2_CellColors() {
    MsgBox("Example 2: Cell Colors`n`nApplying background colors and patterns to cells.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Title
        sheet.Range("A1").Value := "Cell Color Examples"
        sheet.Range("A1").Font.Bold := true
        sheet.Range("A1").Font.Size := 14

        ; Basic colors (using RGB to BGR conversion)
        sheet.Range("A3").Value := "Light Red"
        sheet.Range("A3").Interior.Color := 0xCCCCFF  ; Light red

        sheet.Range("A4").Value := "Light Green"
        sheet.Range("A4").Interior.Color := 0xCCFFCC  ; Light green

        sheet.Range("A5").Value := "Light Blue"
        sheet.Range("A5").Interior.Color := 0xFFCCCC  ; Light blue

        sheet.Range("A6").Value := "Yellow"
        sheet.Range("A6").Interior.Color := 0x00FFFF  ; Yellow

        sheet.Range("A7").Value := "Orange"
        sheet.Range("A7").Interior.Color := 0x00A5FF  ; Orange

        sheet.Range("A8").Value := "Pink"
        sheet.Range("A8").Interior.Color := 0xCBC0FF  ; Pink

        ; Color palette demonstration
        sheet.Range("C3").Value := "Color Palette"
        sheet.Range("C3").Font.Bold := true

        ; Create a gradient effect
        colors := [
            0xFFFFFF,  ; White
            0xF0F0F0,  ; Very light gray
            0xD0D0D0,  ; Light gray
            0xB0B0B0,  ; Gray
            0x808080,  ; Dark gray
            0x404040,  ; Very dark gray
            0x000000   ; Black
        ]

        Loop colors.Length {
            row := A_Index + 3
            sheet.Cells(row, 3).Interior.Color := colors[A_Index]
            sheet.Cells(row, 4).Value := "Shade " A_Index

            ; White text for darker backgrounds
            if (A_Index > 4)
                sheet.Cells(row, 4).Font.Color := 0xFFFFFF
        }

        ; Pattern example
        sheet.Range("F3").Value := "With Pattern"
        sheet.Range("F3").Interior.Pattern := -4121  ; xlPatternChecker
        sheet.Range("F3").Interior.Color := 0x00FFFF  ; Yellow
        sheet.Range("F3").Interior.PatternColor := 0x0000FF  ; Red

        ; Auto-fit
        sheet.Columns("A:F").AutoFit()

        MsgBox("Cell colors applied!`n`nVarious background colors and patterns demonstrated.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 2:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 3: Borders and Gridlines
;===============================================================================
Example3_Borders() {
    MsgBox("Example 3: Borders`n`nAdding borders and outlines to cells and ranges.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Title
        sheet.Range("A1").Value := "Border Examples"
        sheet.Range("A1").Font.Bold := true
        sheet.Range("A1").Font.Size := 14

        ; Example 1: All borders
        sheet.Range("A3:C5").Value := "All Borders"
        sheet.Range("A3:C5").Borders.LineStyle := 1  ; xlContinuous

        ; Example 2: Thick outline
        sheet.Range("E3:G5").Value := "Thick Outline"
        sheet.Range("E3:G5").BorderAround(1, 4)  ; LineStyle=1, Weight=4 (xlThick)

        ; Example 3: Box with thin borders
        sheet.Range("A7:C9").Value := "Thin Box"
        sheet.Range("A7:C9").Borders.LineStyle := 1
        sheet.Range("A7:C9").Borders.Weight := 2  ; xlThin

        ; Example 4: Double line border
        sheet.Range("E7:G9").Value := "Double Line"
        sheet.Range("E7:G9").BorderAround(9, 4)  ; xlDouble, xlThick

        ; Example 5: Custom borders (top and bottom only)
        sheet.Range("A11:C13").Value := "Top & Bottom"
        sheet.Range("A11:C13").Borders(3).LineStyle := 1  ; xlEdgeTop
        sheet.Range("A11:C13").Borders(4).LineStyle := 1  ; xlEdgeBottom
        sheet.Range("A11:C13").Borders(3).Weight := 4  ; Thick top
        sheet.Range("A11:C13").Borders(4).Weight := 4  ; Thick bottom

        ; Example 6: Colored borders
        sheet.Range("E11:G13").Value := "Colored"
        sheet.Range("E11:G13").Borders.LineStyle := 1
        sheet.Range("E11:G13").Borders.Color := 0x0000FF  ; Red borders
        sheet.Range("E11:G13").Borders.Weight := 3  ; xlMedium

        ; Example 7: Table with header
        sheet.Range("A15").Value := "Name"
        sheet.Range("B15").Value := "Age"
        sheet.Range("C15").Value := "City"

        sheet.Range("A16").Value := "John"
        sheet.Range("B16").Value := 30
        sheet.Range("C16").Value := "NYC"

        ; Format as table
        sheet.Range("A15:C16").Borders.LineStyle := 1
        sheet.Range("A15:C15").Font.Bold := true
        sheet.Range("A15:C15").Interior.Color := 0xD0D0D0  ; Gray header

        ; Auto-fit
        sheet.Columns("A:G").AutoFit()

        MsgBox("Borders applied!`n`nVarious border styles and colors demonstrated.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 3:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 4: Number Formatting
;===============================================================================
Example4_NumberFormatting() {
    MsgBox("Example 4: Number Formatting`n`nApplying various number formats to cells.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Title
        sheet.Range("A1").Value := "Number Formatting Examples"
        sheet.Range("A1").Font.Bold := true
        sheet.Range("A1").Font.Size := 14

        ; Headers
        sheet.Range("A3").Value := "Format Type"
        sheet.Range("B3").Value := "Value"
        sheet.Range("C3").Value := "Format String"
        sheet.Range("A3:C3").Font.Bold := true

        ; General number
        sheet.Range("A4").Value := "General"
        sheet.Range("B4").Value := 1234.56
        sheet.Range("C4").Value := "General"

        ; Currency
        sheet.Range("A5").Value := "Currency"
        sheet.Range("B5").Value := 1234.56
        sheet.Range("B5").NumberFormat := "$#,##0.00"
        sheet.Range("C5").Value := "$#,##0.00"

        ; Percentage
        sheet.Range("A6").Value := "Percentage"
        sheet.Range("B6").Value := 0.1234
        sheet.Range("B6").NumberFormat := "0.00%"
        sheet.Range("C6").Value := "0.00%"

        ; Scientific
        sheet.Range("A7").Value := "Scientific"
        sheet.Range("B7").Value := 1234567890
        sheet.Range("B7").NumberFormat := "0.00E+00"
        sheet.Range("C7").Value := "0.00E+00"

        ; Date - Short
        sheet.Range("A8").Value := "Date (Short)"
        sheet.Range("B8").Value := A_Now
        sheet.Range("B8").NumberFormat := "m/d/yyyy"
        sheet.Range("C8").Value := "m/d/yyyy"

        ; Date - Long
        sheet.Range("A9").Value := "Date (Long)"
        sheet.Range("B9").Value := A_Now
        sheet.Range("B9").NumberFormat := "dddd, mmmm dd, yyyy"
        sheet.Range("C9").Value := "dddd, mmmm dd, yyyy"

        ; Time
        sheet.Range("A10").Value := "Time"
        sheet.Range("B10").Value := A_Now
        sheet.Range("B10").NumberFormat := "h:mm:ss AM/PM"
        sheet.Range("C10").Value := "h:mm:ss AM/PM"

        ; Custom - Phone
        sheet.Range("A11").Value := "Phone Number"
        sheet.Range("B11").Value := 5551234567
        sheet.Range("B11").NumberFormat := "(000) 000-0000"
        sheet.Range("C11").Value := "(000) 000-0000"

        ; Custom - Fractions
        sheet.Range("A12").Value := "Fraction"
        sheet.Range("B12").Value := 1.25
        sheet.Range("B12").NumberFormat := "# ?/?"
        sheet.Range("C12").Value := "# ?/?"

        ; Accounting
        sheet.Range("A13").Value := "Accounting"
        sheet.Range("B13").Value := 1234.56
        sheet.Range("B13").NumberFormat := "_($* #,##0.00_);_($* (#,##0.00);_($* `"-`"??_);_(@_)"
        sheet.Range("C13").Value := "Accounting"

        ; Text format
        sheet.Range("A14").Value := "Text"
        sheet.Range("B14").Value := "00123"
        sheet.Range("B14").NumberFormat := "@"
        sheet.Range("C14").Value := "@"

        ; Auto-fit
        sheet.Columns("A:C").AutoFit()

        MsgBox("Number formatting complete!`n`nVarious number formats demonstrated.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 4:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 5: Alignment and Text Wrapping
;===============================================================================
Example5_Alignment() {
    MsgBox("Example 5: Alignment`n`nDemonstrating text alignment and wrapping options.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Title
        sheet.Range("A1").Value := "Text Alignment Examples"
        sheet.Range("A1").Font.Bold := true
        sheet.Range("A1").Font.Size := 14

        ; Horizontal alignment
        sheet.Range("A3").Value := "Left Aligned"
        sheet.Range("A3").HorizontalAlignment := -4131  ; xlLeft

        sheet.Range("B3").Value := "Center Aligned"
        sheet.Range("B3").HorizontalAlignment := -4108  ; xlCenter

        sheet.Range("C3").Value := "Right Aligned"
        sheet.Range("C3").HorizontalAlignment := -4152  ; xlRight

        ; Vertical alignment
        sheet.Range("A5:A7").Merge()
        sheet.Range("A5").Value := "Top"
        sheet.Range("A5").VerticalAlignment := -4160  ; xlTop

        sheet.Range("B5:B7").Merge()
        sheet.Range("B5").Value := "Middle"
        sheet.Range("B5").VerticalAlignment := -4108  ; xlCenter

        sheet.Range("C5:C7").Merge()
        sheet.Range("C5").Value := "Bottom"
        sheet.Range("C5").VerticalAlignment := -4107  ; xlBottom

        ; Add borders to see alignment
        sheet.Range("A5:C7").Borders.LineStyle := 1

        ; Text wrapping
        sheet.Range("A9").Value := "This is a long text that will wrap automatically within the cell when WrapText is enabled"
        sheet.Range("A9").WrapText := true
        sheet.Range("A9").ColumnWidth := 20

        ; Text orientation
        sheet.Range("E3").Value := "Rotated 45°"
        sheet.Range("E3").Orientation := 45

        sheet.Range("E5").Value := "Rotated -45°"
        sheet.Range("E5").Orientation := -45

        sheet.Range("E7").Value := "Vertical"
        sheet.Range("E7").Orientation := 90

        ; Indent
        sheet.Range("A11").Value := "No Indent"
        sheet.Range("A12").Value := "Indent Level 1"
        sheet.Range("A12").IndentLevel := 1

        sheet.Range("A13").Value := "Indent Level 2"
        sheet.Range("A13").IndentLevel := 2

        sheet.Range("A14").Value := "Indent Level 3"
        sheet.Range("A14").IndentLevel := 3

        ; Shrink to fit
        sheet.Range("C11").Value := "This text will shrink to fit in the cell"
        sheet.Range("C11").ShrinkToFit := true
        sheet.Range("C11").ColumnWidth := 10

        ; Auto-fit
        sheet.Columns("B:B").AutoFit()
        sheet.Columns("E:E").AutoFit()

        MsgBox("Alignment formatting complete!`n`nVarious alignment options demonstrated.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 5:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 6: Column and Row Sizing
;===============================================================================
Example6_ColumnRowSizing() {
    MsgBox("Example 6: Column/Row Sizing`n`nControlling column widths and row heights.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Title
        sheet.Range("A1").Value := "Column and Row Sizing"
        sheet.Range("A1").Font.Bold := true
        sheet.Range("A1").Font.Size := 14

        ; Set specific column widths
        sheet.Range("A3").Value := "Width: 10"
        sheet.Columns("A:A").ColumnWidth := 10

        sheet.Range("B3").Value := "Width: 20"
        sheet.Columns("B:B").ColumnWidth := 20

        sheet.Range("C3").Value := "Width: 30"
        sheet.Columns("C:C").ColumnWidth := 30

        ; Set specific row heights
        sheet.Range("A5").Value := "Height: 15"
        sheet.Rows("5:5").RowHeight := 15

        sheet.Range("A6").Value := "Height: 30"
        sheet.Rows("6:6").RowHeight := 30

        sheet.Range("A7").Value := "Height: 45"
        sheet.Rows("7:7").RowHeight := 45

        ; Auto-fit based on content
        sheet.Range("E3").Value := "This will auto-fit"
        sheet.Columns("E:E").AutoFit()

        sheet.Range("E5").Value := "Row auto-fit"
        sheet.Rows("5:5").AutoFit()

        ; Hide column
        sheet.Range("F3").Value := "Column F (will be hidden)"
        sheet.Columns("F:F").Hidden := true

        ; Hide row
        sheet.Range("A9").Value := "Row 9 (will be hidden)"
        sheet.Rows("9:9").Hidden := true

        ; Group columns
        sheet.Range("H3").Value := "H"
        sheet.Range("I3").Value := "I"
        sheet.Range("J3").Value := "J"
        sheet.Range("H:J").Group()

        MsgBox("Column and row sizing complete!`n`nColumn F and Row 9 are hidden.`nColumns H:J are grouped.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 6:`n" err.Message)
        if (IsSet(xl))
            xl.Quit()
    }
}

;===============================================================================
; Example 7: Professional Report Formatting
;===============================================================================
Example7_ProfessionalReport() {
    MsgBox("Example 7: Professional Report`n`nCreating a fully formatted professional report.")

    Try {
        xl := ComObject("Excel.Application")
        xl.Visible := true
        xl.ScreenUpdating := false
        workbook := xl.Workbooks.Add()
        sheet := workbook.ActiveSheet

        ; Report title
        sheet.Range("A1").Value := "Q4 2024 Sales Report"
        sheet.Range("A1").Font.Size := 18
        sheet.Range("A1").Font.Bold := true
        sheet.Range("A1").Font.Color := 0x8B0000  ; Dark blue

        ; Subtitle
        sheet.Range("A2").Value := "Generated: " FormatTime(A_Now, "MMMM dd, yyyy")
        sheet.Range("A2").Font.Italic := true
        sheet.Range("A2").Font.Size := 10

        ; Headers
        headers := ["Region", "Q1", "Q2", "Q3", "Q4", "Total", "% Growth"]
        Loop headers.Length {
            sheet.Cells(4, A_Index).Value := headers[A_Index]
        }

        ; Format header row
        headerRange := sheet.Range("A4:G4")
        headerRange.Font.Bold := true
        headerRange.Font.Color := 0xFFFFFF  ; White
        headerRange.Interior.Color := 0x8B0000  ; Dark blue
        headerRange.HorizontalAlignment := -4108  ; Center

        ; Sample data
        regions := ["North", "South", "East", "West"]
        Loop regions.Length {
            row := A_Index + 4
            sheet.Cells(row, 1).Value := regions[A_Index]
            sheet.Cells(row, 2).Value := Random(50000, 100000)
            sheet.Cells(row, 3).Value := Random(50000, 100000)
            sheet.Cells(row, 4).Value := Random(50000, 100000)
            sheet.Cells(row, 5).Value := Random(50000, 100000)
            sheet.Cells(row, 6).Formula := "=SUM(B" row ":E" row ")"
            sheet.Cells(row, 7).Formula := "=((E" row "-B" row ")/B" row ")"
        }

        ; Totals row
        totalRow := 9
        sheet.Cells(totalRow, 1).Value := "TOTAL"
        sheet.Cells(totalRow, 1).Font.Bold := true
        Loop 5 {
            col := A_Index + 1
            sheet.Cells(totalRow, col).Formula := "=SUM(" Chr(64 + col) "5:" Chr(64 + col) "8)"
        }

        ; Number formatting
        sheet.Range("B5:F9").NumberFormat := "$#,##0"
        sheet.Range("G5:G9").NumberFormat := "0.0%"

        ; Borders
        sheet.Range("A4:G9").Borders.LineStyle := 1
        sheet.Range("A4:G9").BorderAround(1, 4)  ; Thick outer border

        ; Alternating row colors
        sheet.Range("A5:G5").Interior.Color := 0xF0F0F0
        sheet.Range("A7:G7").Interior.Color := 0xF0F0F0

        ; Total row highlight
        sheet.Range("A9:G9").Interior.Color := 0xE0E0E0
        sheet.Range("A9:G9").Font.Bold := true

        ; Auto-fit columns
        sheet.Columns("A:G").AutoFit()

        ; Add some padding
        sheet.Columns("A:G").ColumnWidth := sheet.Columns("A:A").ColumnWidth + 2

        xl.ScreenUpdating := true

        MsgBox("Professional report created!`n`nComplete with formatting, colors, and formulas.`n`nClose Excel manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 7:`n" err.Message)
        if (IsSet(xl)) {
            xl.ScreenUpdating := true
            xl.Quit()
        }
    }
}

;===============================================================================
; Main Menu
;===============================================================================
ShowMenu() {
    menu := "
    (
    Excel COM - Formatting Examples

    Choose an example:

    1. Font Formatting
    2. Cell Colors
    3. Borders
    4. Number Formatting
    5. Alignment
    6. Column/Row Sizing
    7. Professional Report

    0. Exit
    )"

    choice := InputBox(menu, "Excel Formatting Examples", "w300 h400").Value

    switch choice {
        case "1": Example1_FontFormatting()
        case "2": Example2_CellColors()
        case "3": Example3_Borders()
        case "4": Example4_NumberFormatting()
        case "5": Example5_Alignment()
        case "6": Example6_ColumnRowSizing()
        case "7": Example7_ProfessionalReport()
        case "0": return
        default:
            MsgBox("Invalid choice!")
            return
    }

    result := MsgBox("Run another example?", "Continue?", "YesNo")
    if (result = "Yes")
        ShowMenu()
}

ShowMenu()
