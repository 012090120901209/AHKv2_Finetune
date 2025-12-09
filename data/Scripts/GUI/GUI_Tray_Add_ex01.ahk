#Requires AutoHotkey v2.0
#SingleInstance Force

Tray := A_TrayMenu
Tray.Add() ; Creates a separator line.
Tray.Add("Item1", MenuHandler) ; Creates a new menu item.
