#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Flow of Control/SetTimer_ex1.ah2 Persistent
SetTimer(CloseMailWarnings, 250)
CloseMailWarnings()
CloseMailWarnings() { WinClose("Microsoft Outlook", "A timeout occured while communicating") WinClose("Microsoft Outlook", "A connection to the server could not be established")
}
