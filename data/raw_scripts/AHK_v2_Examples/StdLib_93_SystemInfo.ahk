#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * A_ComputerName and A_UserName - System info
 *
 * Built-in variables with system information.
 */

MsgBox("Computer name: " A_ComputerName
    . "`nUser name: " A_UserName
    . "`nOS Version: " A_OSVersion
    . "`nIs Admin: " A_IsAdmin
    . "`n64-bit OS: " A_Is64bitOS)
