#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * WinActive() - Check if window is active
 *
 * Returns the ID of the active window.
 */

active := WinActive("A")  ; Get active window ID
title := WinGetTitle("A")

MsgBox("Active window ID: " active "`nTitle: " title)
