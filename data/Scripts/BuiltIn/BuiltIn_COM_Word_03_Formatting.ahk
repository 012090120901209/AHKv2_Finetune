#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_COM_Word_03_Formatting.ahk
 * 
 * DESCRIPTION:
 * Demonstrates text formatting operations in Microsoft Word using COM automation.
 * Covers fonts, colors, styles, paragraph formatting, and text effects.
 * 
 * FEATURES:
 * - Font formatting (bold, italic, size, color)
 * - Paragraph alignment and indentation
 * - Line spacing and paragraph spacing
 * - Applying styles
 * - Text effects (underline, strikethrough)
 * - Highlighting and shading
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - ComObject
 * https://www.autohotkey.com/docs/v2/lib/ComObject.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - ComObject() for Word automation
 * - Font and ParagraphFormat objects
 * - Style application
 * - Color and formatting properties
 * 
 * LEARNING POINTS:
 * 1. How to format text appearance
 * 2. Applying paragraph formatting
 * 3. Using built-in Word styles
 * 4. Creating professional-looking documents
 * 5. Combining multiple formatting options
 * 6. Text highlighting and colors
 * 7. Managing line and paragraph spacing
 */

;===============================================================================
; Example 1: Font Formatting
;===============================================================================
Example1_FontFormatting() {
    MsgBox("Example 1: Font Formatting`n`nApplying various font formats.")

    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()
        selection := word.Selection

        ; Title
        selection.Font.Size := 18
        selection.Font.Bold := true
        selection.Font.Name := "Arial"
        selection.TypeText("Font Formatting Examples`n`n")

        ; Bold text
        selection.Font.Size := 12
        selection.Font.Bold := true
        selection.TypeText("This text is BOLD`n")

        ; Italic text
        selection.Font.Bold := false
        selection.Font.Italic := true
        selection.TypeText("This text is ITALIC`n")

        ; Bold and Italic
        selection.Font.Bold := true
        selection.TypeText("This text is BOLD and ITALIC`n")

        ; Underline
        selection.Font.Bold := false
        selection.Font.Italic := false
        selection.Font.Underline := 1  ; wdUnderlineSingle
        selection.TypeText("This text is UNDERLINED`n")

        ; Strikethrough
        selection.Font.Underline := 0
        selection.Font.Strikethrough := true
        selection.TypeText("This text has STRIKETHROUGH`n")

        ; Font sizes
        selection.Font.Strikethrough := false
        selection.TypeParagraph()

        Loop 5 {
            fontSize := 8 + (A_Index * 2)
            selection.Font.Size := fontSize
            selection.TypeText("Font size: " fontSize "`n")
        }

        ; Font colors
        selection.TypeParagraph()
        selection.Font.Size := 12

        selection.Font.Color := 0x0000FF  ; Red (BGR)
        selection.TypeText("RED text ")

        selection.Font.Color := 0x00FF00  ; Green
        selection.TypeText("GREEN text ")

        selection.Font.Color := 0xFF0000  ; Blue
        selection.TypeText("BLUE text`n")

        MsgBox("Font formatting complete!`n`nClose Word manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 1:`n" err.Message)
        if (IsSet(word))
            word.Quit()
    }
}

;===============================================================================
; Example 2: Paragraph Alignment and Indentation
;===============================================================================
Example2_ParagraphFormatting() {
    MsgBox("Example 2: Paragraph Formatting`n`nAlignment and indentation examples.")

    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()
        selection := word.Selection

        ; Left aligned (default)
        selection.ParagraphFormat.Alignment := 0  ; wdAlignParagraphLeft
        selection.TypeText("This paragraph is LEFT aligned. ")
        selection.TypeText("It's the default alignment in most documents.")
        selection.TypeParagraph()
        selection.TypeParagraph()

        ; Center aligned
        selection.ParagraphFormat.Alignment := 1  ; wdAlignParagraphCenter
        selection.TypeText("This paragraph is CENTER aligned. ")
        selection.TypeText("Often used for titles and headings.")
        selection.TypeParagraph()
        selection.TypeParagraph()

        ; Right aligned
        selection.ParagraphFormat.Alignment := 2  ; wdAlignParagraphRight
        selection.TypeText("This paragraph is RIGHT aligned. ")
        selection.TypeText("Often used for dates and signatures.")
        selection.TypeParagraph()
        selection.TypeParagraph()

        ; Justified
        selection.ParagraphFormat.Alignment := 3  ; wdAlignParagraphJustify
        selection.TypeText("This paragraph is JUSTIFIED. ")
        selection.TypeText("The text is aligned to both left and right margins, creating a clean professional look. ")
        selection.TypeText("This is commonly used in newspapers and formal documents.")
        selection.TypeParagraph()
        selection.TypeParagraph()

        ; Indentation examples
        selection.ParagraphFormat.Alignment := 0
        selection.TypeText("No Indentation")
        selection.TypeParagraph()

        selection.ParagraphFormat.LeftIndent := 36  ; 0.5 inch (72 points = 1 inch)
        selection.TypeText("Left Indented by 0.5 inch")
        selection.TypeParagraph()

        selection.ParagraphFormat.LeftIndent := 72  ; 1 inch
        selection.TypeText("Left Indented by 1 inch")
        selection.TypeParagraph()

        selection.ParagraphFormat.LeftIndent := 0
        selection.ParagraphFormat.FirstLineIndent := 36  ; First line indent
        selection.TypeText("This paragraph has a first line indent of 0.5 inch. ")
        selection.TypeText("Only the first line is indented, while subsequent lines align to the left margin. ")
        selection.TypeText("This is commonly used in essays and formal writing.")
        selection.TypeParagraph()

        MsgBox("Paragraph formatting complete!`n`nClose Word manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 2:`n" err.Message)
        if (IsSet(word))
            word.Quit()
    }
}

;===============================================================================
; Example 3: Line and Paragraph Spacing
;===============================================================================
Example3_Spacing() {
    MsgBox("Example 3: Spacing`n`nLine and paragraph spacing examples.")

    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()
        selection := word.Selection

        ; Single spacing
        selection.Font.Bold := true
        selection.TypeText("Single Spacing:`n")
        selection.Font.Bold := false
        selection.ParagraphFormat.LineSpacingRule := 0  ; wdLineSpaceSingle
        selection.TypeText("Line 1 of single-spaced text.`n")
        selection.TypeText("Line 2 of single-spaced text.`n")
        selection.TypeText("Line 3 of single-spaced text.`n")
        selection.TypeParagraph()

        ; 1.5 spacing
        selection.Font.Bold := true
        selection.TypeText("1.5 Line Spacing:`n")
        selection.Font.Bold := false
        selection.ParagraphFormat.LineSpacingRule := 1  ; wdLineSpace1pt5
        selection.TypeText("Line 1 of 1.5-spaced text.`n")
        selection.TypeText("Line 2 of 1.5-spaced text.`n")
        selection.TypeText("Line 3 of 1.5-spaced text.`n")
        selection.TypeParagraph()

        ; Double spacing
        selection.Font.Bold := true
        selection.TypeText("Double Spacing:`n")
        selection.Font.Bold := false
        selection.ParagraphFormat.LineSpacingRule := 2  ; wdLineSpaceDouble
        selection.TypeText("Line 1 of double-spaced text.`n")
        selection.TypeText("Line 2 of double-spaced text.`n")
        selection.TypeText("Line 3 of double-spaced text.`n")
        selection.TypeParagraph()

        ; Paragraph spacing
        selection.ParagraphFormat.LineSpacingRule := 0
        selection.Font.Bold := true
        selection.TypeText("Paragraph Spacing:`n`n")
        selection.Font.Bold := false

        selection.ParagraphFormat.SpaceBefore := 12  ; 12 points before
        selection.ParagraphFormat.SpaceAfter := 12   ; 12 points after
        selection.TypeText("Paragraph 1 with 12pt spacing before and after.")
        selection.TypeParagraph()

        selection.TypeText("Paragraph 2 with 12pt spacing before and after.")
        selection.TypeParagraph()

        selection.TypeText("Paragraph 3 with 12pt spacing before and after.")
        selection.TypeParagraph()

        MsgBox("Spacing examples complete!`n`nClose Word manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 3:`n" err.Message)
        if (IsSet(word))
            word.Quit()
    }
}

;===============================================================================
; Example 4: Highlighting and Shading
;===============================================================================
Example4_HighlightingShading() {
    MsgBox("Example 4: Highlighting`n`nText highlighting and shading examples.")

    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()
        selection := word.Selection

        ; Title
        selection.Font.Size := 14
        selection.Font.Bold := true
        selection.TypeText("Highlighting and Shading Examples`n`n")
        selection.Font.Size := 12
        selection.Font.Bold := false

        ; Yellow highlight
        selection.Font.HighlightColorIndex := 7  ; wdYellow
        selection.TypeText("This text is highlighted in YELLOW ")

        ; Green highlight
        selection.Font.HighlightColorIndex := 4  ; wdBrightGreen
        selection.TypeText("GREEN ")

        ; Pink highlight
        selection.Font.HighlightColorIndex := 5  ; wdPink
        selection.TypeText("PINK ")

        ; Turquoise highlight
        selection.Font.HighlightColorIndex := 3  ; wdTurquoise
        selection.TypeText("TURQUOISE")
        selection.TypeParagraph()

        ; No highlight
        selection.Font.HighlightColorIndex := 0  ; wdNoHighlight
        selection.TypeParagraph()

        ; Shading
        selection.TypeText("This text has light gray shading")
        selection.ParagraphFormat.Shading.BackgroundPatternColor := 0xD3D3D3  ; Light gray
        selection.TypeParagraph()

        selection.TypeText("This text has yellow shading")
        selection.ParagraphFormat.Shading.BackgroundPatternColor := 0x00FFFF  ; Yellow
        selection.TypeParagraph()

        selection.TypeText("This text has light blue shading")
        selection.ParagraphFormat.Shading.BackgroundPatternColor := 0xFFCCCC  ; Light blue
        selection.TypeParagraph()

        MsgBox("Highlighting complete!`n`nClose Word manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 4:`n" err.Message)
        if (IsSet(word))
            word.Quit()
    }
}

;===============================================================================
; Example 5: Applying Built-in Styles
;===============================================================================
Example5_Styles() {
    MsgBox("Example 5: Styles`n`nApplying Word's built-in styles.")

    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()
        selection := word.Selection

        ; Heading 1
        selection.Style := doc.Styles("Heading 1")
        selection.TypeText("This is Heading 1")
        selection.TypeParagraph()

        ; Normal text
        selection.Style := doc.Styles("Normal")
        selection.TypeText("This is normal body text under Heading 1.")
        selection.TypeParagraph()
        selection.TypeParagraph()

        ; Heading 2
        selection.Style := doc.Styles("Heading 2")
        selection.TypeText("This is Heading 2")
        selection.TypeParagraph()

        ; Normal text
        selection.Style := doc.Styles("Normal")
        selection.TypeText("This is normal body text under Heading 2.")
        selection.TypeParagraph()
        selection.TypeParagraph()

        ; Heading 3
        selection.Style := doc.Styles("Heading 3")
        selection.TypeText("This is Heading 3")
        selection.TypeParagraph()

        ; Normal text
        selection.Style := doc.Styles("Normal")
        selection.TypeText("This is normal body text under Heading 3.")
        selection.TypeParagraph()
        selection.TypeParagraph()

        ; Title style
        selection.Style := doc.Styles("Title")
        selection.TypeText("Document Title Style")
        selection.TypeParagraph()

        ; Subtitle style
        selection.Style := doc.Styles("Subtitle")
        selection.TypeText("Document Subtitle Style")
        selection.TypeParagraph()
        selection.TypeParagraph()

        ; Quote style
        selection.Style := doc.Styles("Normal")
        selection.TypeText("Normal text followed by a quote:")
        selection.TypeParagraph()

        Try {
            selection.Style := doc.Styles("Quote")
            selection.TypeText("This is a quote style text block that stands out from regular content.")
        }
        Catch {
            ; Quote style might not exist in all versions
            selection.Style := doc.Styles("Normal")
            selection.Font.Italic := true
            selection.ParagraphFormat.LeftIndent := 36
            selection.TypeText("This is a quote style text block that stands out from regular content.")
        }

        MsgBox("Styles applied!`n`nClose Word manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 5:`n" err.Message)
        if (IsSet(word))
            word.Quit()
    }
}

;===============================================================================
; Example 6: Advanced Text Effects
;===============================================================================
Example6_TextEffects() {
    MsgBox("Example 6: Text Effects`n`nAdvanced text formatting effects.")

    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()
        selection := word.Selection

        ; Subscript
        selection.TypeText("H")
        selection.Font.Subscript := true
        selection.TypeText("2")
        selection.Font.Subscript := false
        selection.TypeText("O (Water formula with subscript)`n")

        ; Superscript
        selection.TypeText("E=mc")
        selection.Font.Superscript := true
        selection.TypeText("2")
        selection.Font.Superscript := false
        selection.TypeText(" (Einstein's equation with superscript)`n`n")

        ; Small caps
        selection.Font.SmallCaps := true
        selection.TypeText("This Text Uses Small Caps`n")
        selection.Font.SmallCaps := false

        ; All caps
        selection.Font.AllCaps := true
        selection.TypeText("This Text Is In All Caps`n")
        selection.Font.AllCaps := false

        ; Hidden text
        selection.TypeText("This is visible. ")
        selection.Font.Hidden := true
        selection.TypeText("[This text is hidden] ")
        selection.Font.Hidden := false
        selection.TypeText("This is visible again.`n`n")

        ; Character spacing
        selection.TypeText("Normal spacing`n")

        selection.Font.Spacing := 2  ; Expanded by 2 points
        selection.TypeText("Expanded spacing`n")

        selection.Font.Spacing := -1  ; Condensed by 1 point
        selection.TypeText("Condensed spacing`n")
        selection.Font.Spacing := 0

        ; Character scale
        selection.TypeParagraph()
        selection.Font.Scaling := 150  ; 150% width
        selection.TypeText("Text stretched to 150%`n")

        selection.Font.Scaling := 75  ; 75% width
        selection.TypeText("Text compressed to 75%`n")

        MsgBox("Text effects complete!`n`nClose Word manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 6:`n" err.Message)
        if (IsSet(word))
            word.Quit()
    }
}

;===============================================================================
; Example 7: Professional Document Formatting
;===============================================================================
Example7_ProfessionalDocument() {
    MsgBox("Example 7: Professional Document`n`nCreating a fully formatted professional document.")

    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()
        selection := word.Selection

        ; Title page
        selection.ParagraphFormat.Alignment := 1  ; Center
        selection.Font.Size := 24
        selection.Font.Bold := true
        selection.Font.Name := "Arial"
        selection.TypeText("ANNUAL REPORT 2024")
        selection.TypeParagraph()
        selection.TypeParagraph()

        selection.Font.Size := 16
        selection.Font.Bold := false
        selection.Font.Italic := true
        selection.TypeText("Company Name, Inc.")
        selection.TypeParagraph()
        selection.TypeParagraph()
        selection.TypeParagraph()

        selection.Font.Size := 12
        selection.Font.Italic := false
        selection.TypeText(FormatTime(A_Now, "MMMM yyyy"))
        selection.TypeParagraph()
        selection.TypeParagraph()
        selection.TypeParagraph()

        ; Insert page break
        selection.InsertBreak(7)  ; wdPageBreak

        ; Reset to left align
        selection.ParagraphFormat.Alignment := 0

        ; Executive Summary
        selection.Style := doc.Styles("Heading 1")
        selection.TypeText("Executive Summary")
        selection.TypeParagraph()

        selection.Style := doc.Styles("Normal")
        selection.TypeText("This report provides a comprehensive overview of our company's performance during the fiscal year 2024. ")
        selection.TypeText("Key highlights include revenue growth, market expansion, and strategic initiatives.")
        selection.TypeParagraph()
        selection.TypeParagraph()

        ; Financial Overview
        selection.Style := doc.Styles("Heading 1")
        selection.TypeText("Financial Overview")
        selection.TypeParagraph()

        selection.Style := doc.Styles("Heading 2")
        selection.TypeText("Revenue")
        selection.TypeParagraph()

        selection.Style := doc.Styles("Normal")
        selection.TypeText("Total revenue for 2024 reached $10.5 million, representing a 15% increase over the previous year.")
        selection.TypeParagraph()
        selection.TypeParagraph()

        selection.Style := doc.Styles("Heading 2")
        selection.TypeText("Expenses")
        selection.TypeParagraph()

        selection.Style := doc.Styles("Normal")
        selection.TypeText("Operating expenses were maintained at $7.2 million, demonstrating effective cost control measures.")
        selection.TypeParagraph()
        selection.TypeParagraph()

        ; Conclusion
        selection.Style := doc.Styles("Heading 1")
        selection.TypeText("Conclusion")
        selection.TypeParagraph()

        selection.Style := doc.Styles("Normal")
        selection.TypeText("The company has demonstrated strong performance across all key metrics. ")
        selection.TypeText("We remain optimistic about future growth opportunities and are committed to delivering value to our stakeholders.")
        selection.TypeParagraph()

        MsgBox("Professional document created!`n`nComplete with title page, headings, and formatted content.`n`nClose Word manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 7:`n" err.Message)
        if (IsSet(word))
            word.Quit()
    }
}

;===============================================================================
; Main Menu
;===============================================================================
ShowMenu() {
    menu := "
    (
    Word COM - Text Formatting

    Choose an example:

    1. Font Formatting
    2. Paragraph Formatting
    3. Line and Paragraph Spacing
    4. Highlighting and Shading
    5. Applying Styles
    6. Advanced Text Effects
    7. Professional Document

    0. Exit
    )"

    choice := InputBox(menu, "Word Formatting Examples", "w300 h450").Value

    switch choice {
        case "1": Example1_FontFormatting()
        case "2": Example2_ParagraphFormatting()
        case "3": Example3_Spacing()
        case "4": Example4_HighlightingShading()
        case "5": Example5_Styles()
        case "6": Example6_TextEffects()
        case "7": Example7_ProfessionalDocument()
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
