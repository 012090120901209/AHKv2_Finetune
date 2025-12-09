#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Graphical User Interfaces/MenuGetHandle_ex1.ah2

item_count := DllCall("GetMenuItemCount", "ptr", MyMenu.Handle)
