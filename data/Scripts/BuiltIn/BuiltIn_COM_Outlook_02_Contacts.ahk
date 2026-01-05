#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_COM_Outlook_02_Contacts.ahk
 * 
 * DESCRIPTION:
 * Demonstrates Contacts using COM automation in AutoHotkey v2.
 * 
 * FEATURES:
 * - Creating contacts
 * - Reading contact information
 * - Modifying contacts
 * - Searching contacts
 * - Contact categories
 * - Distribution lists
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
; Example 1: Create New Contact
;===============================================================================
Example1_CreateContact() {
    MsgBox("Example 1: Create New Contact")
    Try {
        outlook := ComObject("Outlook.Application")
        contact := outlook.CreateItem(2)  ; olContactItem

        contact.FirstName := "John"
        contact.LastName := "Smith"
        contact.Email1Address := "john.smith@example.com"
        contact.BusinessTelephoneNumber := "(555) 123-4567"
        contact.CompanyName := "Acme Corp"

        contact.Display()
        MsgBox("Contact created!")
    }
    Catch as err {
        MsgBox("Error in Example 1:`n" err.Message)
        if IsSet(obj)
            Try obj.Quit()
    }
}


;===============================================================================
; Example 2: Read Contact List
;===============================================================================
Example2_ReadContacts() {
    MsgBox("Example 2: Read Contact List")
    Try {
        outlook := ComObject("Outlook.Application")
        namespace := outlook.GetNamespace("MAPI")
        contacts := namespace.GetDefaultFolder(10)  ; olFolderContacts

        count := contacts.Items.Count
        MsgBox("Total contacts: " count)
    }
    Catch as err {
        MsgBox("Error in Example 2:`n" err.Message)
        if IsSet(obj)
            Try obj.Quit()
    }
}


;===============================================================================
; Example 3: Search for Contact
;===============================================================================
Example3_SearchContact() {
    MsgBox("Example 3: Search for Contact")
    Try {
        outlook := ComObject("Outlook.Application")
        namespace := outlook.GetNamespace("MAPI")
        contacts := namespace.GetDefaultFolder(10)

        found := contacts.Items.Find("[FirstName] = 'John'")
        if (found)
            MsgBox("Found: " found.FullName)
        else
            MsgBox("Contact not found")
    }
    Catch as err {
        MsgBox("Error in Example 3:`n" err.Message)
        if IsSet(obj)
            Try obj.Quit()
    }
}


;===============================================================================
; Example 4: Modify Existing Contact
;===============================================================================
Example4_ModifyContact() {
    MsgBox("Example 4: Modify Existing Contact")
    Try {
        outlook := ComObject("Outlook.Application")
        namespace := outlook.GetNamespace("MAPI")
        contacts := namespace.GetDefaultFolder(10)

        if (contacts.Items.Count > 0) {
            contact := contacts.Items(1)
            contact.JobTitle := "Senior Manager"
            ; contact.Save()
            MsgBox("Contact modified!")
        }
    }
    Catch as err {
        MsgBox("Error in Example 4:`n" err.Message)
        if IsSet(obj)
            Try obj.Quit()
    }
}


;===============================================================================
; Example 5: Categorize Contact
;===============================================================================
Example5_ContactCategory() {
    MsgBox("Example 5: Categorize Contact")
    Try {
        outlook := ComObject("Outlook.Application")
        contact := outlook.CreateItem(2)

        contact.FirstName := "Jane"
        contact.LastName := "Doe"
        contact.Email1Address := "jane@example.com"
        contact.Categories := "Business, VIP"

        contact.Display()
        MsgBox("Categorized contact created!")
    }
    Catch as err {
        MsgBox("Error in Example 5:`n" err.Message)
        if IsSet(obj)
            Try obj.Quit()
    }
}


;===============================================================================
; Example 6: Export Contact Info
;===============================================================================
Example6_ExportContacts() {
    MsgBox("Example 6: Export Contact Info")
    Try {
        outlook := ComObject("Outlook.Application")
        namespace := outlook.GetNamespace("MAPI")
        contacts := namespace.GetDefaultFolder(10)

        output := "Contact List:`n`n"
        Loop Min(5, contacts.Items.Count) {
            contact := contacts.Items(A_Index)
            output .= contact.FullName " - " contact.Email1Address "`n"
        }

        MsgBox(output)
    }
    Catch as err {
        MsgBox("Error in Example 6:`n" err.Message)
        if IsSet(obj)
            Try obj.Quit()
    }
}


;===============================================================================
; Example 7: Birthday Reminder Contact
;===============================================================================
Example7_BirthdayReminder() {
    MsgBox("Example 7: Birthday Reminder Contact")
    Try {
        outlook := ComObject("Outlook.Application")
        contact := outlook.CreateItem(2)

        contact.FirstName := "Birthday"
        contact.LastName := "Person"
        contact.Birthday := "1990-01-15"
        contact.ReminderSet := true

        contact.Display()
        MsgBox("Contact with birthday created!")
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
    Outlook COM - Contacts

    Choose an example:

    1. Create New Contact
    2. Read Contact List
    3. Search for Contact
    4. Modify Existing Contact
    5. Categorize Contact
    6. Export Contact Info
    7. Birthday Reminder Contact

    0. Exit
    )"

    choice := InputBox(menu, "Outlook Examples", "w350 h450").Value

    switch choice {
        case "1": Example1_CreateContact()
        case "2": Example2_ReadContacts()
        case "3": Example3_SearchContact()
        case "4": Example4_ModifyContact()
        case "5": Example5_ContactCategory()
        case "6": Example6_ExportContacts()
        case "7": Example7_BirthdayReminder()
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
