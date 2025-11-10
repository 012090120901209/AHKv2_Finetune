#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Context-Sensitive - Time-based
 * Hotkeys that change behavior based on time
 */

; Different behavior during work hours (9 AM - 5 PM)
#HotIf (A_Hour >= 9 and A_Hour < 17)
F7::MsgBox("F7 during WORK hours (9 AM - 5 PM)`n`nWork mode activated!")
#HotIf

; Different behavior outside work hours
#HotIf (A_Hour < 9 or A_Hour >= 17)
F7::MsgBox("F7 outside work hours`n`nPersonal time!")
#HotIf

; Only works on weekends (Sunday=1, Saturday=7)
#HotIf (A_WDay = 1 or A_WDay = 7)
F8::MsgBox("F8 on WEEKEND!`n`nToday is " FormatTime(, "dddd"))
#HotIf

; Only works on weekdays
#HotIf (A_WDay >= 2 and A_WDay <= 6)
F8::MsgBox("F8 on WEEKDAY`n`nToday is " FormatTime(, "dddd"))
#HotIf

#HotIf  ; Reset
