#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * DateDiff() - Calculate date difference
 * 
 * Compares two date-time values and returns the difference.
 */

date1 := "20240101"
date2 := "20241231"

diffDays := DateDiff(date2, date1, "Days")
diffWeeks := DateDiff(date2, date1, "Weeks")
diffMonths := DateDiff(date2, date1, "Months")

MsgBox("From: " date1
    . "`nTo: " date2
    . "`n`nDifference:`n"
    . diffDays " days`n"
    . diffWeeks " weeks`n"
    . diffMonths " months")
