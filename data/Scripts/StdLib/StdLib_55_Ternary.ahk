#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Ternary operator
 * 
 * Conditional expression: condition ? true_value : false_value
 */

score := 85

grade := score >= 90 ? "A" : score >= 80 ? "B" : score >= 70 ? "C" : "F"
passed := score >= 60 ? "Passed" : "Failed"

MsgBox("Score: " score "`n"
    . "Grade: " grade "`n"
    . "Status: " passed)
