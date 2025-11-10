#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * VerCompare() - Version comparison
 *
 * Compares two version strings.
 */

ver1 := "2.0.1"
ver2 := "2.0.10"

result := VerCompare(ver1, ver2)

MsgBox("Version 1: " ver1
    . "`nVersion 2: " ver2
    . "`nComparison: " (result < 0 ? "v1 < v2" : result > 0 ? "v1 > v2" : "Equal"))
