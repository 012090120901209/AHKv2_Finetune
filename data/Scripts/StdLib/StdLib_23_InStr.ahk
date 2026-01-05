#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * InStr() - Find substring position
 * 
 * Searches for a given occurrence of a string within another string.
 */

email := "user@example.com"

posAt := InStr(email, "@")
posDot := InStr(email, ".")
posNotFound := InStr(email, "xyz")

MsgBox("Email: " email
    . "`nPosition of '@': " posAt
    . "`nPosition of '.': " posDot
    . "`nPosition of 'xyz': " posNotFound " (not found)")
