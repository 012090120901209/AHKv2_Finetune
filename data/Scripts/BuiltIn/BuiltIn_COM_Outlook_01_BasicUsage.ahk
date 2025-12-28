#Requires AutoHotkey v2.0

/**
 * BuiltIn_COM_Outlook_01_BasicUsage.ahk
 * 
 * DESCRIPTION:
 * Demonstrates BasicUsage using COM automation in AutoHotkey v2.
 * 
 * FEATURES:
 * - Creating Outlook COM objects
 * - Sending emails programmatically
 * - Email formatting and attachments
 * - Managing email properties
 * - Accessing Outlook folders
 * - Error handling
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - ComObject
 * https://www.autohotkey.com/docs/v2/lib/ComObject.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - ComObject() function for creating COM instances
 * - COM method calls and property access
 * - Try/Catch error handling
 * - Proper cleanup with object := ""
 * 
 * LEARNING POINTS:
 * 1. Creating and using Outlook COM objects
 * 2. Working with Outlook automation
 * 3. Error handling in COM operations
 * 4. Best practices for Outlook automation
 * 5. Practical real-world examples
 * 6. Performance optimization
 * 7. Resource management and cleanup
 */


;===============================================================================
; Example 1: Sending a Basic Email
;===============================================================================
Example1_SendEmail() {
    MsgBox("Example 1: Sending a Basic Email")
    Try {
        outlook := ComObject("Outlook.Application")
        mail := outlook.CreateItem(0)  ; olMailItem

        mail.To := "recipient@example.com"
        mail.Subject := "Test Email from AutoHotkey"
        mail.Body := "This is a test email sent using COM automation."

        ; mail.Send()  ; Uncomment to actually send
        mail.Display()  ; Show the email

        MsgBox("Email prepared! Check Outlook.")
    }
    Catch as err {
        MsgBox("Error in Example 1:`n" err.Message)
        if IsSet(obj)
            Try obj.Quit()
    }
}


;===============================================================================
; Example 2: Email with Attachment
;===============================================================================
Example2_SendWithAttachment() {
    MsgBox("Example 2: Email with Attachment")
    Try {
        outlook := ComObject("Outlook.Application")
        mail := outlook.CreateItem(0)

        mail.To := "recipient@example.com"
        mail.Subject := "Email with Attachment"
        mail.Body := "Please find the attachment."

        ; Add attachment
        testFile := A_Temp "	est_attachment.txt"
        FileAppend("This is a test file", testFile)
        mail.Attachments.Add(testFile)

        mail.Display()
        MsgBox("Email with attachment created!")
    }
    Catch as err {
        MsgBox("Error in Example 2:`n" err.Message)
        if IsSet(obj)
            Try obj.Quit()
    }
}


;===============================================================================
; Example 3: HTML Formatted Email
;===============================================================================
Example3_HTMLEmail() {
    MsgBox("Example 3: HTML Formatted Email")
    Try {
        outlook := ComObject("Outlook.Application")
        mail := outlook.CreateItem(0)

        mail.To := "recipient@example.com"
        mail.Subject := "HTML Email"
        mail.HTMLBody := "<h1>Hello!</h1><p>This is <b>HTML</b> formatted email.</p>"

        mail.Display()
        MsgBox("HTML email created!")
    }
    Catch as err {
        MsgBox("Error in Example 3:`n" err.Message)
        if IsSet(obj)
            Try obj.Quit()
    }
}


;===============================================================================
; Example 4: Multiple Recipients
;===============================================================================
Example4_MultipleRecipients() {
    MsgBox("Example 4: Multiple Recipients")
    Try {
        outlook := ComObject("Outlook.Application")
        mail := outlook.CreateItem(0)

        mail.To := "person1@example.com; person2@example.com"
        mail.CC := "cc@example.com"
        mail.BCC := "bcc@example.com"
        mail.Subject := "Email to Multiple Recipients"
        mail.Body := "This email goes to multiple people."

        mail.Display()
        MsgBox("Multi-recipient email created!")
    }
    Catch as err {
        MsgBox("Error in Example 4:`n" err.Message)
        if IsSet(obj)
            Try obj.Quit()
    }
}


;===============================================================================
; Example 5: High Priority Email
;===============================================================================
Example5_HighPriority() {
    MsgBox("Example 5: High Priority Email")
    Try {
        outlook := ComObject("Outlook.Application")
        mail := outlook.CreateItem(0)

        mail.To := "urgent@example.com"
        mail.Subject := "URGENT: Action Required"
        mail.Body := "This is a high priority message."
        mail.Importance := 2  ; olImportanceHigh

        mail.Display()
        MsgBox("High priority email created!")
    }
    Catch as err {
        MsgBox("Error in Example 5:`n" err.Message)
        if IsSet(obj)
            Try obj.Quit()
    }
}


;===============================================================================
; Example 6: Request Read Receipt
;===============================================================================
Example6_ReadReceipt() {
    MsgBox("Example 6: Request Read Receipt")
    Try {
        outlook := ComObject("Outlook.Application")
        mail := outlook.CreateItem(0)

        mail.To := "recipient@example.com"
        mail.Subject := "Read Receipt Requested"
        mail.Body := "Please confirm reading this email."
        mail.ReadReceiptRequested := true

        mail.Display()
        MsgBox("Email with read receipt created!")
    }
    Catch as err {
        MsgBox("Error in Example 6:`n" err.Message)
        if IsSet(obj)
            Try obj.Quit()
    }
}


;===============================================================================
; Example 7: Send Batch Emails
;===============================================================================
Example7_BatchEmails() {
    MsgBox("Example 7: Send Batch Emails")
    Try {
        outlook := ComObject("Outlook.Application")

        recipients := ["user1@example.com", "user2@example.com", "user3@example.com"]
        Loop recipients.Length {
            mail := outlook.CreateItem(0)
            mail.To := recipients[A_Index]
            mail.Subject := "Batch Email " A_Index
            mail.Body := "This is batch email number " A_Index
            ; mail.Send()  ; Uncomment to send
        }

        MsgBox("Prepared " recipients.Length " emails!")
    }
    Catch as err {
        MsgBox("Error in Example 7:`n" err.Message)
        if IsSet(obj)
            Try obj.Quit()
    }
}


;===============================================================================
; Main Menu
;===============================================================================
ShowMenu() {
    menu := "
    (
    Outlook COM - BasicUsage

    Choose an example:

    1. Sending a Basic Email
    2. Email with Attachment
    3. HTML Formatted Email
    4. Multiple Recipients
    5. High Priority Email
    6. Request Read Receipt
    7. Send Batch Emails

    0. Exit
    )"

    choice := InputBox(menu, "Outlook Examples", "w350 h450").Value

    switch choice {
        case "1": Example1_SendEmail()
        case "2": Example2_SendWithAttachment()
        case "3": Example3_HTMLEmail()
        case "4": Example4_MultipleRecipients()
        case "5": Example5_HighPriority()
        case "6": Example6_ReadReceipt()
        case "7": Example7_BatchEmails()
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
