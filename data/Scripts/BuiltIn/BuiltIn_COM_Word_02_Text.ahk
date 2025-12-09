#Requires AutoHotkey v2.0

/**
* BuiltIn_COM_Word_02_Text.ahk
*
* DESCRIPTION:
* Demonstrates reading and writing text in Microsoft Word using COM automation.
* Shows various methods for inserting, modifying, and extracting text content.
*
* FEATURES:
* - Inserting text at different positions
* - Reading text from documents
* - Working with Selection and Range objects
* - Find and replace operations
* - Text manipulation and extraction
* - Paragraph and sentence handling
*
* SOURCE:
* AutoHotkey v2 Documentation - ComObject
* https://www.autohotkey.com/docs/v2/lib/ComObject.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - ComObject() for Word automation
* - Selection object for text insertion
* - Range object for text manipulation
* - Find and Replace functionality
*
* LEARNING POINTS:
* 1. Different ways to insert text (Selection vs Range)
* 2. Reading text from documents
* 3. Moving through document content
* 4. Finding and replacing text
* 5. Working with paragraphs
* 6. Extracting specific portions of text
* 7. Text formatting while inserting
*/

;===============================================================================
; Example 1: Basic Text Insertion
;===============================================================================
Example1_BasicTextInsertion() {
    MsgBox("Example 1: Basic Text Insertion`n`nDifferent methods for inserting text.")

    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()
        selection := word.Selection

        ; Method 1: TypeText (simulates typing)
        selection.TypeText("Method 1: TypeText`n")
        selection.TypeText("This simulates actual typing.`n`n")

        ; Method 2: InsertAfter
        selection.InsertAfter("Method 2: InsertAfter`n")
        selection.InsertAfter("This inserts text after current position.`n`n")

        ; Method 3: TypeParagraph
        selection.TypeText("Method 3: TypeParagraph")
        selection.TypeParagraph()
        selection.TypeText("This creates a new paragraph.`n`n")

        ; Method 4: Direct Range insertion
        rng := doc.Range(0, 0)  ; Beginning of document
        rng.InsertBefore("=== DOCUMENT START ===`n`n")

        ; Method 5: End of document
        rng := doc.Range()
        rng.Collapse(0)  ; wdCollapseEnd
        rng.InsertAfter("`n`n=== DOCUMENT END ===")

        MsgBox("Text insertion complete!`n`nMultiple insertion methods demonstrated.`n`nClose Word manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 1:`n" err.Message)
        if (IsSet(word))
        word.Quit()
    }
}

;===============================================================================
; Example 2: Reading Text from Document
;===============================================================================
Example2_ReadingText() {
    MsgBox("Example 2: Reading Text`n`nExtracting text from a Word document.")

    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()
        selection := word.Selection

        ; Create sample document
        selection.TypeText("Title: Sample Document`n`n")
        selection.TypeText("Paragraph 1: This is the first paragraph with some content.`n`n")
        selection.TypeText("Paragraph 2: This is the second paragraph with more content.`n`n")
        selection.TypeText("Paragraph 3: This is the third and final paragraph.")

        Sleep(500)

        ; Read entire document text
        entireText := doc.Range().Text

        ; Read first paragraph
        firstPara := doc.Paragraphs(1).Range.Text

        ; Read specific range (first 50 characters)
        rng := doc.Range(0, 50)
        first50 := rng.Text

        ; Count statistics
        charCount := doc.Characters.Count
        wordCount := doc.Words.Count
        paraCount := doc.Paragraphs.Count

        result := "Document Statistics:`n`n"
        result .= "Characters: " charCount "`n"
        result .= "Words: " wordCount "`n"
        result .= "Paragraphs: " paraCount "`n`n"
        result .= "First 50 chars: " SubStr(first50, 1, 50) "..."

        MsgBox(result "`n`nClose Word manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 2:`n" err.Message)
        if (IsSet(word))
        word.Quit()
    }
}

;===============================================================================
; Example 3: Find and Replace
;===============================================================================
Example3_FindReplace() {
    MsgBox("Example 3: Find and Replace`n`nSearching and replacing text in documents.")

    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()
        selection := word.Selection

        ; Create sample text
        selection.TypeText("The quick brown fox jumps over the lazy dog.`n")
        selection.TypeText("The fox is very quick and agile.`n")
        selection.TypeText("Many foxes live in the forest.`n")
        selection.TypeText("The fox population is stable.")

        Sleep(500)

        MsgBox("Original text created.`n`nNow we'll replace 'fox' with 'wolf'")

        ; Find and Replace
        findObj := word.Selection.Find
        findObj.ClearFormatting()
        findObj.Text := "fox"
        findObj.Replacement.Text := "wolf"
        findObj.Forward := true
        findObj.Wrap := 1  ; wdFindContinue
        findObj.Format := false
        findObj.MatchCase := false
        findObj.MatchWholeWord := true

        ; Execute replace all
        findObj.Execute(,,,,,,,,,"wolf", 2)  ; 2 = wdReplaceAll

        ; Count how many replacements were made
        MsgBox("Replacement complete!`n`nAll instances of 'fox' replaced with 'wolf'.`n`nCheck the document.")

        MsgBox("Close Word manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 3:`n" err.Message)
        if (IsSet(word))
        word.Quit()
    }
}

;===============================================================================
; Example 4: Working with Paragraphs
;===============================================================================
Example4_Paragraphs() {
    MsgBox("Example 4: Paragraphs`n`nManipulating paragraphs in Word documents.")

    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()
        selection := word.Selection

        ; Add multiple paragraphs
        Loop 5 {
            selection.TypeText("Paragraph " A_Index ": ")
            selection.TypeText("This is the content of paragraph number " A_Index ". ")
            selection.TypeText("It contains some sample text for demonstration.")
            selection.TypeParagraph()
        }

        Sleep(500)

        ; Access and modify specific paragraphs
        ; Make first paragraph bold
        doc.Paragraphs(1).Range.Font.Bold := true
        doc.Paragraphs(1).Range.Font.Size := 14

        ; Change third paragraph color
        doc.Paragraphs(3).Range.Font.Color := 0x0000FF  ; Red

        ; Add text to specific paragraph
        doc.Paragraphs(2).Range.InsertAfter(" [ADDED TEXT]")

        ; Get paragraph count
        paraCount := doc.Paragraphs.Count

        ; Read specific paragraph
        para3Text := doc.Paragraphs(3).Range.Text

        MsgBox("Paragraph manipulation complete!`n`nTotal paragraphs: " paraCount "`n`nParagraph 3: " para3Text "`n`nClose Word manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 4:`n" err.Message)
        if (IsSet(word))
        word.Quit()
    }
}

;===============================================================================
; Example 5: Selection Movement and Navigation
;===============================================================================
Example5_SelectionMovement() {
    MsgBox("Example 5: Selection Movement`n`nMoving through document using Selection object.")

    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()
        selection := word.Selection

        ; Create document
        selection.TypeText("Word 1 Word 2 Word 3 Word 4 Word 5`n")
        selection.TypeText("Line 2: More words here`n")
        selection.TypeText("Line 3: Even more words")

        ; Move to start of document
        selection.HomeKey(6)  ; wdStory = move to beginning

        ; Move forward by word
        Sleep(300)
        selection.MoveRight(2, 1)  ; wdWord, count=1
        selection.MoveRight(2, 1)
        currentWord := selection.Text

        MsgBox("Moved forward 2 words.`n`nCurrent word: " currentWord)

        ; Select next 3 words
        selection.MoveRight(2, 3, 1)  ; wdWord, count=3, extend=1
        selectedText := selection.Text

        MsgBox("Selected 3 words: " selectedText)

        ; Move to end of document
        selection.EndKey(6)  ; wdStory

        ; Type at end
        selection.TypeParagraph()
        selection.TypeText("`n--- END OF DOCUMENT ---")

        MsgBox("Navigation complete!`n`nClose Word manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 5:`n" err.Message)
        if (IsSet(word))
        word.Quit()
    }
}

;===============================================================================
; Example 6: Text Extraction and Processing
;===============================================================================
Example6_TextExtraction() {
    MsgBox("Example 6: Text Extraction`n`nExtracting and processing specific text portions.")

    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()
        selection := word.Selection

        ; Create structured document
        selection.Font.Size := 16
        selection.Font.Bold := true
        selection.TypeText("REPORT TITLE`n`n")

        selection.Font.Size := 12
        selection.Font.Bold := false
        selection.TypeText("Summary: This is the executive summary section.`n`n")
        selection.TypeText("Details: Here are the detailed findings.`n`n")
        selection.TypeText("Conclusion: Final thoughts and recommendations.")

        Sleep(500)

        ; Extract sections using Find
        summaryText := ""
        detailsText := ""

        ; Find Summary section
        findObj := selection.Find
        findObj.Text := "Summary:"
        if findObj.Execute() {
            selection.MoveRight(1, 1)  ; Move past "Summary:"
            selection.EndKey(5)  ; wdLine - to end of line
            summaryText := selection.Text
        }

        ; Reset selection to start
        selection.HomeKey(6)

        ; Find Details section
        findObj.Text := "Details:"
        if findObj.Execute() {
            selection.MoveRight(1, 1)
            selection.EndKey(5)
            detailsText := selection.Text
        }

        result := "Extracted Text:`n`n"
        result .= "Summary Section:" summaryText "`n`n"
        result .= "Details Section:" detailsText

        MsgBox(result "`n`nClose Word manually when done.")
    }
    Catch as err {
        MsgBox("Error in Example 6:`n" err.Message)
        if (IsSet(word))
        word.Quit()
    }
}

;===============================================================================
; Example 7: Automated Document Generation
;===============================================================================
Example7_DocumentGeneration() {
    MsgBox("Example 7: Document Generation`n`nAutomatically generating a formatted document.")

    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()
        selection := word.Selection

        ; Document title
        selection.Font.Size := 18
        selection.Font.Bold := true
        selection.ParagraphFormat.Alignment := 1  ; wdAlignParagraphCenter
        selection.TypeText("AUTOMATED REPORT`n")
        selection.TypeText("Generated: " FormatTime(A_Now, "MMMM dd, yyyy") "`n`n")

        ; Reset formatting
        selection.Font.Size := 12
        selection.Font.Bold := false
        selection.ParagraphFormat.Alignment := 0  ; wdAlignParagraphLeft

        ; Introduction
        selection.Font.Bold := true
        selection.TypeText("1. Introduction`n`n")
        selection.Font.Bold := false
        selection.TypeText("This document was automatically generated using AutoHotkey v2 COM automation. ")
        selection.TypeText("It demonstrates the capability to create well-structured documents programmatically.`n`n")

        ; Data Section
        selection.Font.Bold := true
        selection.TypeText("2. Data Summary`n`n")
        selection.Font.Bold := false

        ; Generate data table
        Loop 5 {
            selection.TypeText("Item " A_Index ": Value = " Random(100, 999) "`n")
        }
        selection.TypeParagraph()

        ; Conclusion
        selection.Font.Bold := true
        selection.TypeText("3. Conclusion`n`n")
        selection.Font.Bold := false
        selection.TypeText("This automated document generation demonstrates the power of COM automation ")
        selection.TypeText("for creating dynamic Word documents.`n`n")

        ; Footer
        selection.EndKey(6)  ; Go to end
        selection.TypeParagraph()
        selection.ParagraphFormat.Alignment := 1  ; Center
        selection.Font.Size := 10
        selection.Font.Italic := true
        selection.TypeText("--- End of Report ---")

        MsgBox("Document generation complete!`n`nFully formatted report created.`n`nClose Word manually when done.")
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
    Word COM - Text Operations

    Choose an example:

    1. Basic Text Insertion
    2. Reading Text
    3. Find and Replace
    4. Working with Paragraphs
    5. Selection Movement
    6. Text Extraction
    7. Document Generation

    0. Exit
    )"

    choice := InputBox(menu, "Word Text Examples", "w300 h400").Value

    switch choice {
        case "1": Example1_BasicTextInsertion()
        case "2": Example2_ReadingText()
        case "3": Example3_FindReplace()
        case "4": Example4_Paragraphs()
        case "5": Example5_SelectionMovement()
        case "6": Example6_TextExtraction()
        case "7": Example7_DocumentGeneration()
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
