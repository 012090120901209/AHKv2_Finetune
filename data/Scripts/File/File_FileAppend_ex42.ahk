#Requires AutoHotkey v2.0
#SingleInstance Force

var := 7

if (var >= 5 && var <= 10) {
    FileAppend(var " between 5 and 10", "*")
} else if (var >= 1 && var <= 4) {
    FileAppend(var " between 1 and 4", "*")
}
