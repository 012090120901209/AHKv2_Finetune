#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Mouse and Keyboard/KeyWait_ex6.ah2 *NumpadAdd::
{ ; Added opening brace for [*NumpadAdd]
global ; Made function global
MouseClick("left", , , 1, 0, "D") ; Hold down the left mouse button.
KeyWait("NumpadAdd") ; Wait for the key to be released.
MouseClick("left", , , 1, 0, "U") ; Release the mouse button.
} ; Added closing brace for [*NumpadAdd]
