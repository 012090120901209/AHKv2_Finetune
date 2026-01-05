#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * FormatTime() - Format timestamps
 * 
 * Formats a date-time stamp into a string.
 */

timestamp := A_Now

format1 := FormatTime(timestamp, "yyyy-MM-dd")
format2 := FormatTime(timestamp, "HH:mm:ss")
format3 := FormatTime(timestamp, "LongDate")
format4 := FormatTime(timestamp, "ShortDate")

MsgBox("Timestamp: " timestamp
    . "`n`nDate: " format1
    . "`nTime: " format2
    . "`nLong: " format3
    . "`nShort: " format4)
