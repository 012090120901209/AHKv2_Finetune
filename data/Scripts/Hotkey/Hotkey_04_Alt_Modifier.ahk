#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Alt Modifier (!)
 * ! represents the Alt key
 */

; Alt+N to create a new document
!n:: {
    MsgBox("Creating new document...`n`nAlt+N pressed")
    ; In a real script, this might create a file or open an application
}
