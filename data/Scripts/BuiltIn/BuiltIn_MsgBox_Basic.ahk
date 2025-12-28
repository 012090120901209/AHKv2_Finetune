; Title: MsgBox - Basic Usage
; Category: GUI
; Source: https://www.autohotkey.com/docs/v2/lib/MsgBox.htm
; Description: Basic MsgBox function examples showing different parameter combinations including simple messages, titles, button types, and icons.

#Requires AutoHotkey v2.0

; Simple message box
MsgBox "This is a simple message box."

; Message box with title
MsgBox "This is the message.", "Title"

; Message box with options (Yes/No buttons)
result := MsgBox("Do you want to continue?", "Confirm", "YesNo")
if result = "Yes"
    MsgBox "You clicked Yes"
else
    MsgBox "You clicked No"

; Message box with icon and default button
MsgBox "An error occurred!", "Error", "Icon! Default2"
