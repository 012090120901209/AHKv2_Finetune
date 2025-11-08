#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Joystick/Gamepad Buttons
 * Detect game controller button presses
 */

; Xbox/PlayStation controller buttons
; Joy1 = A/X button, Joy2 = B/Circle, etc.
Joy1::MsgBox("Gamepad Button 1 (A/X) pressed")
Joy2::MsgBox("Gamepad Button 2 (B/Circle) pressed")
Joy3::MsgBox("Gamepad Button 3 (X/Square) pressed")
Joy4::MsgBox("Gamepad Button 4 (Y/Triangle) pressed")

; D-pad directions (detected as POV)
; Note: POV angles: 0=Up, 9000=Right, 18000=Down, 27000=Left

; Combine with keyboard modifiers
^Joy1::MsgBox("Ctrl + Gamepad Button 1")

; Note: Joystick must be connected for these to work
; Use GetKeyState("JoyName") to check button states
