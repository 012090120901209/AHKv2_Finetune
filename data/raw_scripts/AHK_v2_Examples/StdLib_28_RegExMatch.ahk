#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * RegExMatch() - Pattern matching
 *
 * Checks if a pattern (regular expression) is found in a string.
 */

email := "contact@example.com"

if RegExMatch(email, "(.+)@(.+\..+)", &match) {
    MsgBox("Email: " email
        . "`nUsername: " match[1]
        . "`nDomain: " match[2])
}
