#Requires AutoHotkey v2.0
/**
 * BuiltIn_COM_Outlook_03_Calendar.ahk
 *
 * DESCRIPTION:
 * Calendar and appointment management in Outlook using COM automation.
 *
 * FEATURES:
 * - Creating appointments
 * - Setting reminders
 * - Recurring events
 * - Meeting requests
 * - Calendar searches
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - ComObject
 * https://www.autohotkey.com/docs/v2/lib/ComObject.htm
 */

Example1_CreateAppointment() {
    MsgBox("Example 1: Create Appointment")
    Try {
        outlook := ComObject("Outlook.Application")
        appt := outlook.CreateItem(1)  ; olAppointmentItem
        
        appt.Subject := "Team Meeting"
        appt.Location := "Conference Room A"
        appt.Start := A_Now
        appt.Duration := 60  ; minutes
        appt.ReminderMinutesBeforeStart := 15
        appt.Body := "Discuss project updates"
        
        appt.Display()
        MsgBox("Appointment created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example2_RecurringMeeting() {
    MsgBox("Example 2: Recurring Meeting")
    Try {
        outlook := ComObject("Outlook.Application")
        appt := outlook.CreateItem(1)
        
        appt.Subject := "Weekly Status Meeting"
        appt.Start := A_Now
        appt.Duration := 30
        
        recurrence := appt.GetRecurrencePattern()
        recurrence.RecurrenceType := 1  ; olRecursWeekly
        recurrence.DayOfWeekMask := 4  ; Wednesday
        recurrence.PatternEndDate := DateAdd(A_Now, 90, "Days")
        
        appt.Display()
        MsgBox("Recurring meeting created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example3_AllDayEvent() {
    MsgBox("Example 3: All-Day Event")
    Try {
        outlook := ComObject("Outlook.Application")
        appt := outlook.CreateItem(1)
        
        appt.Subject := "Company Holiday"
        appt.Start := A_Now
        appt.AllDayEvent := true
        appt.ReminderSet := false
        
        appt.Display()
        MsgBox("All-day event created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example4_MeetingRequest() {
    MsgBox("Example 4: Meeting Request")
    Try {
        outlook := ComObject("Outlook.Application")
        appt := outlook.CreateItem(1)
        
        appt.MeetingStatus := 1  ; olMeeting
        appt.Subject := "Project Review"
        appt.Location := "Meeting Room"
        appt.Start := A_Now
        appt.Duration := 60
        appt.Recipients.Add("colleague@example.com")
        
        appt.Display()
        MsgBox("Meeting request created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example5_ReadCalendar() {
    MsgBox("Example 5: Read Calendar")
    Try {
        outlook := ComObject("Outlook.Application")
        namespace := outlook.GetNamespace("MAPI")
        calendar := namespace.GetDefaultFolder(9)  ; olFolderCalendar
        
        count := calendar.Items.Count
        MsgBox("Total calendar items: " count)
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example6_ColorCodeEvent() {
    MsgBox("Example 6: Color-Coded Event")
    Try {
        outlook := ComObject("Outlook.Application")
        appt := outlook.CreateItem(1)
        
        appt.Subject := "Important Meeting"
        appt.Start := A_Now
        appt.Duration := 45
        appt.Categories := "Red Category"
        
        appt.Display()
        MsgBox("Color-coded event created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example7_PrivateAppointment() {
    MsgBox("Example 7: Private Appointment")
    Try {
        outlook := ComObject("Outlook.Application")
        appt := outlook.CreateItem(1)
        
        appt.Subject := "Personal Appointment"
        appt.Start := A_Now
        appt.Duration := 30
        appt.Sensitivity := 2  ; olPrivate
        
        appt.Display()
        MsgBox("Private appointment created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

ShowMenu() {
    menu := "(
    Outlook COM - Calendar
    
    1. Create Appointment
    2. Recurring Meeting
    3. All-Day Event
    4. Meeting Request
    5. Read Calendar
    6. Color-Coded Event
    7. Private Appointment
    
    0. Exit
    )"
    
    choice := InputBox(menu, "Calendar Examples", "w300 h400").Value
    
    switch choice {
        case "1": Example1_CreateAppointment()
        case "2": Example2_RecurringMeeting()
        case "3": Example3_AllDayEvent()
        case "4": Example4_MeetingRequest()
        case "5": Example5_ReadCalendar()
        case "6": Example6_ColorCodeEvent()
        case "7": Example7_PrivateAppointment()
        case "0": return
        default: MsgBox("Invalid choice!")
    }
    
    result := MsgBox("Run another example?", "Continue?", "YesNo")
    if (result = "Yes")
        ShowMenu()
}

ShowMenu()
