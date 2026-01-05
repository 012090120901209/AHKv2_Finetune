#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinMove_param_combinations.ah2

WinMove(varX)
WinMove(, varY)
WinMove(varX)
WinMove(, varY)
WinMove(, , varWidth)
WinMove(, , , varHeight)
WinMove(, , , , , , "ExcludeTitle")
WinMove(, , , , , , , varExcl)
WinMove() WinMove(varX, varY, , , "title", "text")
WinMove(, varY, , , varTitle)
WinMove(varX, , , , , varText)
WinMove(, varY, , , , "text")
