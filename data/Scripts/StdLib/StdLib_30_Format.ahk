#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Format() - String formatting
*
* Formats a string according to a format specification.
*/

name := "Alice"
age := 30
salary := 75000.50

formatted := Format("Name: {1}`nAge: {2}`nSalary: ${3:.2f}", name, age, salary)

MsgBox(formatted)
