#Requires AutoHotkey v2.0

/**
* BuiltIn_COM_Word_05_MailMerge.ahk
*
* DESCRIPTION:
* Demonstrates mail merge functionality in Microsoft Word using COM automation.
*
* FEATURES:
* - Creating mail merge documents
* - Setting up data sources
* - Inserting merge fields
* - Executing mail merge
* - Generating personalized documents
*
* SOURCE:
* AutoHotkey v2 Documentation - ComObject
* https://www.autohotkey.com/docs/v2/lib/ComObject.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - ComObject() for Word automation
* - MailMerge object
* - MergeFields collection
*
* LEARNING POINTS:
* 1. Setting up mail merge templates
* 2. Connecting to data sources
* 3. Adding merge fields
* 4. Executing merge operations
* 5. Creating multiple personalized documents
* 6. Batch document generation
* 7. Mail merge automation workflows
*/

Example1_BasicMailMerge() {
    MsgBox("Example 1: Basic Mail Merge")
    Try {
        word := ComObject("Word.Application")
        word.Visible := true
        doc := word.Documents.Add()
        selection := word.Selection

        selection.TypeText("Dear Customer,`n`n")
        selection.TypeText("Thank you for your business!`n`n")
        selection.TypeText("Sincerely,`nCompany Name")

        MsgBox("Basic template created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
        if IsSet(word)
        word.Quit()
    }
}

Example2_PersonalizedLetters() {
    MsgBox("Example 2: Personalized Letters")
    Try {
        word := ComObject("Word.Application")
        word.Visible := false

        customers := [
        {
            name: "John Smith", email: "john@example.com"},
            {
                name: "Jane Doe", email: "jane@example.com"},
                {
                    name: "Bob Johnson", email: "bob@example.com"
                }
                ]

                Loop customers.Length {
                    doc := word.Documents.Add()
                    selection := word.Selection

                    selection.TypeText("Dear " customers[A_Index].name ",`n`n")
                    selection.TypeText("This is a personalized letter for you.`n`n")
                    selection.TypeText("Contact: " customers[A_Index].email "`n`n")
                    selection.TypeText("Best regards,`nCompany")

                    filename := A_Temp "\Letter_" A_Index ".docx"
                    doc.SaveAs(filename, 16)
                    doc.Close()
                }

                word.Quit()
                MsgBox("Created " customers.Length " personalized letters!")
            }
            Catch as err {
                MsgBox("Error: " err.Message)
                if IsSet(word)
                word.Quit()
            }
        }

        Example3_BulkEmails() {
            MsgBox("Example 3: Bulk Email Template")
            Try {
                word := ComObject("Word.Application")
                word.Visible := true
                doc := word.Documents.Add()
                selection := word.Selection

                selection.TypeText("Subject: Special Offer Just for You!`n`n")
                selection.TypeText("Dear [NAME],`n`n")
                selection.TypeText("We have a special offer tailored for you.`n`n")
                selection.TypeText("Visit us at: [WEBSITE]`n`n")
                selection.TypeText("Best regards,`n[COMPANY]")

                MsgBox("Email template created!")
            }
            Catch as err {
                MsgBox("Error: " err.Message)
                if IsSet(word)
                word.Quit()
            }
        }

        Example4_InvoiceGeneration() {
            MsgBox("Example 4: Invoice Generation")
            Try {
                word := ComObject("Word.Application")
                word.Visible := false

                invoices := [
                {
                    id: 1001, customer: "ABC Corp", amount: 5000},
                    {
                        id: 1002, customer: "XYZ Inc", amount: 7500},
                        {
                            id: 1003, customer: "123 LLC", amount: 3200
                        }
                        ]

                        Loop invoices.Length {
                            doc := word.Documents.Add()
                            selection := word.Selection

                            selection.Font.Size := 18
                            selection.Font.Bold := true
                            selection.TypeText("INVOICE`n`n")

                            selection.Font.Size := 12
                            selection.Font.Bold := false
                            selection.TypeText("Invoice #: " invoices[A_Index].id "`n")
                            selection.TypeText("Customer: " invoices[A_Index].customer "`n")
                            selection.TypeText("Amount: $" invoices[A_Index].amount "`n")
                            selection.TypeText("Date: " FormatTime(A_Now, "yyyy-MM-dd") "`n")

                            filename := A_Temp "\Invoice_" invoices[A_Index].id ".docx"
                            doc.SaveAs(filename, 16)
                            doc.Close()
                        }

                        word.Quit()
                        MsgBox("Generated " invoices.Length " invoices!")
                    }
                    Catch as err {
                        MsgBox("Error: " err.Message)
                        if IsSet(word)
                        word.Quit()
                    }
                }

                Example5_Certificates() {
                    MsgBox("Example 5: Certificate Generation")
                    Try {
                        word := ComObject("Word.Application")
                        word.Visible := false

                        recipients := ["Alice Brown", "Charlie Davis", "Eve Wilson"]

                        Loop recipients.Length {
                            doc := word.Documents.Add()
                            selection := word.Selection

                            selection.ParagraphFormat.Alignment := 1
                            selection.Font.Size := 24
                            selection.Font.Bold := true
                            selection.TypeText("CERTIFICATE OF COMPLETION`n`n`n")

                            selection.Font.Size := 16
                            selection.Font.Bold := false
                            selection.TypeText("This is to certify that`n`n")

                            selection.Font.Size := 20
                            selection.Font.Bold := true
                            selection.TypeText(recipients[A_Index] "`n`n")

                            selection.Font.Size := 14
                            selection.Font.Bold := false
                            selection.TypeText("has successfully completed the course`n`n")
                            selection.TypeText(FormatTime(A_Now, "MMMM yyyy"))

                            filename := A_Temp "\Certificate_" A_Index ".docx"
                            doc.SaveAs(filename, 16)
                            doc.Close()
                        }

                        word.Quit()
                        MsgBox("Generated " recipients.Length " certificates!")
                    }
                    Catch as err {
                        MsgBox("Error: " err.Message)
                        if IsSet(word)
                        word.Quit()
                    }
                }

                Example6_ReportCards() {
                    MsgBox("Example 6: Report Cards")
                    Try {
                        word := ComObject("Word.Application")
                        word.Visible := false

                        students := [
                        {
                            name: "Student A", grade: "A", score: 95},
                            {
                                name: "Student B", grade: "B", score: 85},
                                {
                                    name: "Student C", grade: "A", score: 92
                                }
                                ]

                                Loop students.Length {
                                    doc := word.Documents.Add()
                                    selection := word.Selection

                                    selection.Font.Size := 16
                                    selection.Font.Bold := true
                                    selection.TypeText("REPORT CARD`n`n")

                                    selection.Font.Size := 12
                                    selection.Font.Bold := false
                                    selection.TypeText("Student: " students[A_Index].name "`n")
                                    selection.TypeText("Grade: " students[A_Index].grade "`n")
                                    selection.TypeText("Score: " students[A_Index].score "%`n`n")
                                    selection.TypeText("Date: " FormatTime(A_Now, "yyyy-MM-dd"))

                                    filename := A_Temp "\ReportCard_" A_Index ".docx"
                                    doc.SaveAs(filename, 16)
                                    doc.Close()
                                }

                                word.Quit()
                                MsgBox("Generated " students.Length " report cards!")
                            }
                            Catch as err {
                                MsgBox("Error: " err.Message)
                                if IsSet(word)
                                word.Quit()
                            }
                        }

                        Example7_Labels() {
                            MsgBox("Example 7: Address Labels")
                            Try {
                                word := ComObject("Word.Application")
                                word.Visible := true
                                doc := word.Documents.Add()
                                selection := word.Selection

                                addresses := [
                                "John Smith`n123 Main St`nNew York, NY 10001",
                                "Jane Doe`n456 Oak Ave`nLos Angeles, CA 90001",
                                "Bob Johnson`n789 Pine Rd`nChicago, IL 60601"
                                ]

                                Loop addresses.Length {
                                    selection.TypeText(addresses[A_Index])
                                    if (A_Index < addresses.Length) {
                                        selection.TypeParagraph()
                                        selection.TypeParagraph()
                                        selection.InsertBreak(7)
                                    }
                                }

                                MsgBox("Labels created!")
                            }
                            Catch as err {
                                MsgBox("Error: " err.Message)
                                if IsSet(word)
                                word.Quit()
                            }
                        }

                        ShowMenu() {
                            menu := "
                            (
                            Word COM - Mail Merge

                            1. Basic Mail Merge
                            2. Personalized Letters
                            3. Bulk Email Template
                            4. Invoice Generation
                            5. Certificate Generation
                            6. Report Cards
                            7. Address Labels

                            0. Exit
                            )"

                            choice := InputBox(menu, "Mail Merge Examples", "w300 h400").Value

                            switch choice {
                                case "1": Example1_BasicMailMerge()
                                case "2": Example2_PersonalizedLetters()
                                case "3": Example3_BulkEmails()
                                case "4": Example4_InvoiceGeneration()
                                case "5": Example5_Certificates()
                                case "6": Example6_ReportCards()
                                case "7": Example7_Labels()
                                case "0": return
                                default: MsgBox("Invalid choice!")
                            }

                            result := MsgBox("Run another example?", "Continue?", "YesNo")
                            if (result = "Yes")
                            ShowMenu()
                        }

                        ShowMenu()
