#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Min() and Max() - Find minimum/maximum
*
* Returns the smallest or largest value from a list.
*/

numbers := [5, 12, 3, 18, 7]

minimum := Min(numbers*)
maximum := Max(numbers*)

MsgBox("Numbers: [5, 12, 3, 18, 7]`n`n"
. "Minimum: " minimum "`n"
. "Maximum: " maximum)
