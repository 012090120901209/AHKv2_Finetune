; Title: Array - Creation and Manipulation
; Category: Array
; Source: https://www.autohotkey.com/docs/v2/lib/Array.htm
; Description: Comprehensive examples of array creation, manipulation, iteration, and common operations in AutoHotkey v2.

#Requires AutoHotkey v2.0

; Create an array
myArray := ["apple", "banana", "cherry"]

; Access elements (1-based indexing)
MsgBox myArray[1]  ; Shows "apple"

; Add elements
myArray.Push("date")
myArray.InsertAt(2, "apricot")

; Remove elements
removed := myArray.Pop()  ; Removes and returns "date"
myArray.RemoveAt(1)  ; Removes "apple"

; Loop through array
for index, value in myArray
MsgBox "Item " index ": " value

; Array methods
MsgBox "Length: " myArray.Length
MsgBox "Has banana? " myArray.Has("banana")

; Filter and map
numbers := [1, 2, 3, 4, 5]
evens := []
for num in numbers
if Mod(num, 2) = 0
evens.Push(num)
