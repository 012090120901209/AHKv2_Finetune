#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * DateAdd() - Date arithmetic
 * 
 * Adds or subtracts time from a date-time value.
 */

today := A_Now

tomorrow := DateAdd(today, 1, "Days")
nextWeek := DateAdd(today, 7, "Days")
nextMonth := DateAdd(today, 1, "Months")

MsgBox("Today: " FormatTime(today, "yyyy-MM-dd")
    . "`nTomorrow: " FormatTime(tomorrow, "yyyy-MM-dd")
    . "`nNext week: " FormatTime(nextWeek, "yyyy-MM-dd")
    . "`nNext month: " FormatTime(nextMonth, "yyyy-MM-dd"))
