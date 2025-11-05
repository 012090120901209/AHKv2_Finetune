#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Window_StatusbargetText_ex1.ah2 RetrievedText := StatusBarGetText(1, "Search Results")
if InStr(RetrievedText, "found") MsgBox("Search results have been found.")
