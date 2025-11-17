#Requires AutoHotkey v2.0
/**
 * BuiltIn_COM_Word_01_BasicUsage.ahk
 *
 * DESCRIPTION:
 * Demonstrates basic Microsoft Word automation using COM objects in AutoHotkey v2.
 * Covers fundamental operations like opening Word, creating documents, saving, and closing.
 *
 * FEATURES:
 * - Creating Word COM objects
 * - Opening and creating documents
 * - Saving documents in various formats
 * - Closing Word properly
 * - Error handling for COM operations
 * - Visibility control and user interaction
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - ComObject
 * https://www.autohotkey.com/docs/v2/lib/ComObject.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - ComObject() function for creating COM instances
 * - COM method calls and property access
 * - Try/Catch error handling for COM operations
 * - Proper cleanup with object := ""
 *
 * LEARNING POINTS:
 * 1. How to create and connect to Word using ComObject()
 * 2. Making Word visible or hidden for background operations
 * 3. Creating new documents and opening existing ones
 * 4. Saving documents with different file formats
 * 5. Proper cleanup to prevent Word processes from staying in memory
 * 6. Error handling for COM operations that might fail
 * 7. Controlling Word's display alerts and screen updating
 */

;===============================================================================
; Example 1: Creating Word Instance and Making it Visible
;===============================================================================
Example1_CreateWordInstance() {
    MsgBox("Example 1: Creating Word Instance`n`nThis example creates a Word instance and makes it visible.")
    
    Try {
        ; Create new Word instance
        word := ComObject("Word.Application")
        
        ; Make Word visible to the user
        word.Visible := true
        
        MsgBox("Word has been launched and is now visible.`n`nCheck your taskbar!")
        
        ; Wait a moment to see Word
        Sleep(2000)
        
        ; Close Word
        word.Quit()
        
        ; Clean up the COM object
        word := ""
        
        MsgBox("Example 1 Complete!`n`nWord was created, made visible, and then closed.")
    }
    Catch as err {
        MsgBox("Error in Example 1:`n" err.Message)
    }
}

;===============================================================================
; Example 2: Creating a New Document
;===============================================================================
Example2_CreateDocument() {
    MsgBox("Example 2: Creating a New Document`n`nThis example creates Word with a new document.")
    
    Try {
        ; Create Word instance (invisible by default)
        word := ComObject("Word.Application")
        
        ; Create a new document
        doc := word.Documents.Add()
        
        ; Add some text to verify it worked
        selection := word.Selection
        selection.TypeText("New Document Created!`n")
        selection.TypeText("Created at: " FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss"))
        
        ; Make Word visible to show the result
        word.Visible := true
        
        MsgBox("A new document has been created with sample text.`n`nClose Word manually when done.")
        
        ; Note: We're not closing Word here to let user see the result
    }
    Catch as err {
        MsgBox("Error in Example 2:`n" err.Message)
        if (IsSet(word))
            word.Quit()
    }
}

;===============================================================================
; Example 3: Opening an Existing Document
;===============================================================================
Example3_OpenDocument() {
    MsgBox("Example 3: Opening an Existing Document`n`nThis example will create a test file and then reopen it.")
    
    Try {
        ; Create a test file first
        word := ComObject("Word.Application")
        doc := word.Documents.Add()
        
        ; Add some test data
        selection := word.Selection
        selection.TypeText("Test Document`n`n")
        selection.TypeText("This file was created for testing purposes.")
        
        ; Save the file to a temp location
        testFile := A_Temp "\AHK_Test_Document.docx"
        doc.SaveAs(testFile, 16)  ; 16 = wdFormatXMLDocument (.docx)
        
        ; Close the document
        doc.Close()
        word.Quit()
        word := ""
        
        MsgBox("Test file created at:`n" testFile "`n`nNow opening it...")
        
        ; Now open the file we just created
        word := ComObject("Word.Application")
        word.Visible := true
        
        ; Open the document
        doc := word.Documents.Open(testFile)
        
        ; Read some text to verify it opened correctly
        text := doc.Range().Text
        
        MsgBox("File opened successfully!`n`nDocument contains " StrLen(text) " characters.`n`nClose Word manually when done.")
        
        ; Clean up happens when user closes Word manually
    }
    Catch as err {
        MsgBox("Error in Example 3:`n" err.Message)
        if (IsSet(word))
            word.Quit()
    }
}

;===============================================================================
; Example 4: Saving Documents in Different Formats
;===============================================================================
Example4_SaveFormats() {
    MsgBox("Example 4: Saving in Different Formats`n`nThis example saves documents in DOCX, PDF, and TXT formats.")
    
    Try {
        word := ComObject("Word.Application")
        doc := word.Documents.Add()
        selection := word.Selection
        
        ; Add sample content
        selection.Font.Size := 16
        selection.Font.Bold := true
        selection.TypeText("Document Format Test`n`n")
        
        selection.Font.Size := 12
        selection.Font.Bold := false
        selection.TypeText("This document demonstrates saving in different formats:`n`n")
        selection.TypeText("- Microsoft Word (.docx)`n")
        selection.TypeText("- PDF (.pdf)`n")
        selection.TypeText("- Plain Text (.txt)`n`n")
        selection.TypeText("Created: " FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss"))
        
        ; Create output directory
        outputDir := A_Temp "\AHK_Word_Formats"
        if !DirExist(outputDir)
            DirCreate(outputDir)
        
        ; Save as DOCX (wdFormatXMLDocument = 16)
        docxFile := outputDir "\test_document.docx"
        doc.SaveAs(docxFile, 16)
        
        ; Save as PDF (wdFormatPDF = 17)
        pdfFile := outputDir "\test_document.pdf"
        doc.SaveAs(pdfFile, 17)
        
        ; Save as TXT (wdFormatText = 2)
        txtFile := outputDir "\test_document.txt"
        doc.SaveAs(txtFile, 2)
        
        ; Close without saving again
        doc.Close(false)
        word.Quit()
        word := ""
        
        result := "Files saved successfully:`n`n"
        result .= "DOCX: " docxFile "`n"
        result .= "PDF:  " pdfFile "`n"
        result .= "TXT:  " txtFile
        
        MsgBox(result)
    }
    Catch as err {
        MsgBox("Error in Example 4:`n" err.Message)
        if (IsSet(word)) {
            Try word.Quit()
        }
        word := ""
    }
}

;===============================================================================
; Example 5: Background Processing (Invisible Word)
;===============================================================================
Example5_BackgroundProcessing() {
    MsgBox("Example 5: Background Processing`n`nThis example processes a document in Word without showing the window.")
    
    Try {
        ; Create Word instance (invisible)
        word := ComObject("Word.Application")
        word.Visible := false  ; Keep Word hidden
        word.DisplayAlerts := 0  ; wdAlertsNone
        word.ScreenUpdating := false  ; Speed up processing
        
        ; Create document
        doc := word.Documents.Add()
        selection := word.Selection
        
        ; Simulate document generation
        MsgBox("Generating document in background...`n`nThis will take a few seconds.")
        
        ; Add title
        selection.Font.Size := 18
        selection.Font.Bold := true
        selection.TypeText("Background Processing Report`n`n")
        
        ; Add content
        selection.Font.Size := 12
        selection.Font.Bold := false
        
        Loop 50 {
            selection.TypeText("Section " A_Index "`n")
            selection.TypeText("This is auto-generated content for section " A_Index ".")
            selection.TypeText(" " Random(100, 999) " items processed.`n`n")
        }
        
        ; Add footer
        selection.TypeText("`nGenerated: " FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss"))
        
        ; Save the file
        outputFile := A_Temp "\AHK_Background_Document.docx"
        doc.SaveAs(outputFile, 16)
        
        ; Close Word
        doc.Close()
        word.Quit()
        word := ""
        
        MsgBox("Background processing complete!`n`nFile saved to:`n" outputFile "`n`n50 sections of content generated.")
    }
    Catch as err {
        MsgBox("Error in Example 5:`n" err.Message)
        if (IsSet(word)) {
            Try word.Quit()
        }
        word := ""
    }
}

;===============================================================================
; Example 6: Proper Error Handling and Cleanup
;===============================================================================
Example6_ErrorHandling() {
    MsgBox("Example 6: Error Handling`n`nThis example demonstrates proper error handling for COM operations.")
    
    word := ""
    doc := ""
    
    Try {
        ; Create Word
        word := ComObject("Word.Application")
        
        ; Try to open a non-existent file (will cause error)
        Try {
            doc := word.Documents.Open("C:\NonExistent\File.docx")
        }
        Catch as err {
            MsgBox("Expected Error: Could not open file`n`nError: " err.Message "`n`nContinuing with new document...")
        }
        
        ; If that failed, create a new document instead
        if (!IsSet(doc) || doc = "") {
            doc := word.Documents.Add()
        }
        
        ; Add some content
        selection := word.Selection
        selection.TypeText("Error Handling Example`n`n")
        selection.TypeText("This document was created after handling an error.")
        
        ; Save the file
        outputFile := A_Temp "\AHK_Error_Handling.docx"
        doc.SaveAs(outputFile, 16)
        
        MsgBox("Error handling successful!`n`nDespite the error, we created a new document:`n" outputFile)
    }
    Catch as err {
        MsgBox("Unexpected Error in Example 6:`n" err.Message)
    }
    Finally {
        ; Always clean up, even if there was an error
        if (IsSet(doc) && doc != "") {
            Try doc.Close(false)
        }
        if (IsSet(word) && word != "") {
            Try word.Quit()
        }
        word := ""
        doc := ""
        MsgBox("Cleanup complete. Word has been closed.")
    }
}

;===============================================================================
; Example 7: Working with Multiple Documents
;===============================================================================
Example7_MultipleDocuments() {
    MsgBox("Example 7: Multiple Documents`n`nThis example works with multiple documents simultaneously.")
    
    Try {
        ; Create Word instance
        word := ComObject("Word.Application")
        word.Visible := true
        
        ; Create first document
        doc1 := word.Documents.Add()
        word.ActiveDocument.Range().Text := "Document 1`n`nThis is the first document."
        
        ; Create second document
        doc2 := word.Documents.Add()
        word.ActiveDocument.Range().Text := "Document 2`n`nThis is the second document."
        
        ; Create third document
        doc3 := word.Documents.Add()
        word.ActiveDocument.Range().Text := "Document 3`n`nThis is the third document."
        
        ; Show count of documents
        count := word.Documents.Count
        
        MsgBox("Created " count " documents!`n`n1. Document 1`n2. Document 2`n3. Document 3`n`nClose Word manually when done.")
        
        ; Note: Not closing Word so user can see the documents
    }
    Catch as err {
        MsgBox("Error in Example 7:`n" err.Message)
        if (IsSet(word))
            word.Quit()
    }
}

;===============================================================================
; Main Menu to Run Examples
;===============================================================================
ShowMenu() {
    menu := "
    (
    Word COM - Basic Usage Examples
    
    Choose an example to run:
    
    1. Create Word Instance (Basic)
    2. Create New Document
    3. Open Existing Document
    4. Save in Different Formats
    5. Background Processing
    6. Error Handling
    7. Multiple Documents
    
    0. Exit
    )"
    
    choice := InputBox(menu, "Word COM Examples", "w300 h400").Value
    
    switch choice {
        case "1": Example1_CreateWordInstance()
        case "2": Example2_CreateDocument()
        case "3": Example3_OpenDocument()
        case "4": Example4_SaveFormats()
        case "5": Example5_BackgroundProcessing()
        case "6": Example6_ErrorHandling()
        case "7": Example7_MultipleDocuments()
        case "0": return
        default:
            MsgBox("Invalid choice!")
            return
    }
    
    ; Ask if user wants to see another example
    result := MsgBox("Run another example?", "Continue?", "YesNo")
    if (result = "Yes")
        ShowMenu()
}

; Run the menu
ShowMenu()
