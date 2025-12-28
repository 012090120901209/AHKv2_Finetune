#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Random() - Generate random numbers
 * 
 * Generates random integers or floating-point numbers.
 */

; Random integer between 1 and 100
rand1 := Random(1, 100)

; Random float between 0 and 1
rand2 := Random()

; Random from array
choices := ["red", "green", "blue", "yellow"]
randChoice := choices[Random(1, choices.Length)]

MsgBox("Random integer (1-100): " rand1 "`n"
    . "Random float (0-1): " rand2 "`n"
    . "Random choice: " randChoice)
