#Requires AutoHotkey v2.0

/**
* BuiltIn_COM_Outlook_05_Folders.ahk
*
* DESCRIPTION:
* Folder operations in Outlook using COM automation.
*
* FEATURES:
* - Creating folders
* - Moving emails
* - Folder organization
* - Search folders
* - Inbox management
*
* SOURCE:
* AutoHotkey v2 Documentation - ComObject
* https://www.autohotkey.com/docs/v2/lib/ComObject.htm
*/

Example1_CreateFolder() {
    MsgBox("Example 1: Create Folder")
    Try {
        outlook := ComObject("Outlook.Application")
        namespace := outlook.GetNamespace("MAPI")
        inbox := namespace.GetDefaultFolder(6)  ; olFolderInbox

        newFolder := inbox.Folders.Add("AHK Test Folder")
        MsgBox("Folder created: " newFolder.Name)
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example2_ListFolders() {
    MsgBox("Example 2: List Folders")
    Try {
        outlook := ComObject("Outlook.Application")
        namespace := outlook.GetNamespace("MAPI")
        inbox := namespace.GetDefaultFolder(6)

        output := "Inbox Subfolders:`n`n"
        Loop inbox.Folders.Count {
            folder := inbox.Folders(A_Index)
            output .= folder.Name "`n"
        }

        MsgBox(output)
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example3_ReadInbox() {
    MsgBox("Example 3: Read Inbox")
    Try {
        outlook := ComObject("Outlook.Application")
        namespace := outlook.GetNamespace("MAPI")
        inbox := namespace.GetDefaultFolder(6)

        count := inbox.Items.Count
        unread := inbox.UnReadItemCount

        MsgBox("Total: " count "`nUnread: " unread)
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example4_MoveEmail() {
    MsgBox("Example 4: Move Email")
    Try {
        outlook := ComObject("Outlook.Application")
        namespace := outlook.GetNamespace("MAPI")
        inbox := namespace.GetDefaultFolder(6)

        if (inbox.Items.Count > 0) {
            MsgBox("Would move first email to another folder`n(Disabled for safety)")
        } else {
            MsgBox("Inbox is empty")
        }
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example5_SearchFolder() {
    MsgBox("Example 5: Search Emails")
    Try {
        outlook := ComObject("Outlook.Application")
        namespace := outlook.GetNamespace("MAPI")
        inbox := namespace.GetDefaultFolder(6)

        found := inbox.Items.Find("[Subject] = 'Test'")
        if (found)
        MsgBox("Found: " found.Subject)
        else
        MsgBox("No matching emails found")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example6_SentItems() {
    MsgBox("Example 6: Sent Items")
    Try {
        outlook := ComObject("Outlook.Application")
        namespace := outlook.GetNamespace("MAPI")
        sentItems := namespace.GetDefaultFolder(5)  ; olFolderSentMail

        count := sentItems.Items.Count
        MsgBox("Sent items: " count)
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example7_DeletedItems() {
    MsgBox("Example 7: Deleted Items")
    Try {
        outlook := ComObject("Outlook.Application")
        namespace := outlook.GetNamespace("MAPI")
        deletedItems := namespace.GetDefaultFolder(3)  ; olFolderDeletedItems

        count := deletedItems.Items.Count
        MsgBox("Deleted items: " count)
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

ShowMenu() {
    menu := "
    (
    Outlook COM - Folders

    1. Create Folder
    2. List Folders
    3. Read Inbox
    4. Move Email
    5. Search Folder
    6. Sent Items
    7. Deleted Items

    0. Exit
    )"

    choice := InputBox(menu, "Folder Examples", "w300 h400").Value

    switch choice {
        case "1": Example1_CreateFolder()
        case "2": Example2_ListFolders()
        case "3": Example3_ReadInbox()
        case "4": Example4_MoveEmail()
        case "5": Example5_SearchFolder()
        case "6": Example6_SentItems()
        case "7": Example7_DeletedItems()
        case "0": return
        default: MsgBox("Invalid choice!")
    }

    result := MsgBox("Run another example?", "Continue?", "YesNo")
    if (result = "Yes")
    ShowMenu()
}

ShowMenu()
