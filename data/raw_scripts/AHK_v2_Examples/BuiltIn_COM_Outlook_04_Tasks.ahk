#Requires AutoHotkey v2.0
/**
 * BuiltIn_COM_Outlook_04_Tasks.ahk
 *
 * DESCRIPTION:
 * Task management in Outlook using COM automation.
 *
 * FEATURES:
 * - Creating tasks
 * - Setting priorities
 * - Due dates and reminders
 * - Task status tracking
 * - Task categories
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - ComObject
 * https://www.autohotkey.com/docs/v2/lib/ComObject.htm
 */

Example1_CreateTask() {
    MsgBox("Example 1: Create Task")
    Try {
        outlook := ComObject("Outlook.Application")
        task := outlook.CreateItem(3)  ; olTaskItem
        
        task.Subject := "Complete Project Report"
        task.Body := "Finish the quarterly report by end of week"
        task.DueDate := DateAdd(A_Now, 7, "Days")
        task.ReminderSet := true
        
        task.Display()
        MsgBox("Task created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example2_HighPriorityTask() {
    MsgBox("Example 2: High Priority Task")
    Try {
        outlook := ComObject("Outlook.Application")
        task := outlook.CreateItem(3)
        
        task.Subject := "URGENT: Fix Critical Bug"
        task.Importance := 2  ; olImportanceHigh
        task.DueDate := A_Now
        task.Status := 1  ; olTaskInProgress
        
        task.Display()
        MsgBox("High priority task created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example3_RecurringTask() {
    MsgBox("Example 3: Recurring Task")
    Try {
        outlook := ComObject("Outlook.Application")
        task := outlook.CreateItem(3)
        
        task.Subject := "Weekly Status Report"
        task.DueDate := A_Now
        
        recurrence := task.GetRecurrencePattern()
        recurrence.RecurrenceType := 1  ; Weekly
        recurrence.DayOfWeekMask := 2  ; Monday
        
        task.Display()
        MsgBox("Recurring task created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example4_TaskWithCategories() {
    MsgBox("Example 4: Categorized Task")
    Try {
        outlook := ComObject("Outlook.Application")
        task := outlook.CreateItem(3)
        
        task.Subject := "Review Documentation"
        task.Categories := "Work, Documentation"
        task.PercentComplete := 25
        
        task.Display()
        MsgBox("Categorized task created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example5_CompleteTask() {
    MsgBox("Example 5: Complete Task")
    Try {
        outlook := ComObject("Outlook.Application")
        namespace := outlook.GetNamespace("MAPI")
        tasks := namespace.GetDefaultFolder(13)  ; olFolderTasks
        
        if (tasks.Items.Count > 0) {
            task := tasks.Items(1)
            task.Status := 2  ; olTaskComplete
            task.PercentComplete := 100
            ; task.Save()
            MsgBox("Task marked as complete!")
        } else {
            MsgBox("No tasks found")
        }
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example6_TaskList() {
    MsgBox("Example 6: Read Task List")
    Try {
        outlook := ComObject("Outlook.Application")
        namespace := outlook.GetNamespace("MAPI")
        tasks := namespace.GetDefaultFolder(13)
        
        output := "Task List:`n`n"
        Loop Min(5, tasks.Items.Count) {
            task := tasks.Items(A_Index)
            output .= task.Subject "`n"
        }
        
        MsgBox(output)
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example7_AssignTask() {
    MsgBox("Example 7: Assign Task")
    Try {
        outlook := ComObject("Outlook.Application")
        task := outlook.CreateItem(3)
        
        task.Subject := "Assigned Task"
        task.Body := "Please complete this task"
        task.Assign()
        task.Recipients.Add("colleague@example.com")
        
        task.Display()
        MsgBox("Task assignment created!")
    }
    Catch as err {
        MsgBox("Error: " err.Message)
    }
}

ShowMenu() {
    menu := "(
    Outlook COM - Tasks
    
    1. Create Task
    2. High Priority Task
    3. Recurring Task
    4. Categorized Task
    5. Complete Task
    6. Read Task List
    7. Assign Task
    
    0. Exit
    )"
    
    choice := InputBox(menu, "Task Examples", "w300 h400").Value
    
    switch choice {
        case "1": Example1_CreateTask()
        case "2": Example2_HighPriorityTask()
        case "3": Example3_RecurringTask()
        case "4": Example4_TaskWithCategories()
        case "5": Example5_CompleteTask()
        case "6": Example6_TaskList()
        case "7": Example7_AssignTask()
        case "0": return
        default: MsgBox("Invalid choice!")
    }
    
    result := MsgBox("Run another example?", "Continue?", "YesNo")
    if (result = "Yes")
        ShowMenu()
}

ShowMenu()
