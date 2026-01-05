#Requires AutoHotkey v2.0
#SingleInstance Force

; Library: Descolada/AHK-v2-libraries/Array.ahk
; Function: Array.Map - Transform array elements
; Category: Functional Programming
; Use Case: Data transformation, array processing

; Example: Transform array with Map function
; Note: v2.1-alpha.3+ has built-in Array.Map()

; Native v2.1+ Array.Map example
DemoArrayMap() {
    ; Create sample array
    numbers := [1, 2, 3, 4, 5]

    ; Map: multiply each by 2
    doubled := []
    for num in numbers
        doubled.Push(num * 2)

    ; Display result
    result := "Original: " ArrayToString(numbers) "`n"
    result .= "Doubled: " ArrayToString(doubled) "`n`n"

    ; With Descolada's Array lib (enhanced):
    ; #Include <Array>
    ; doubled := numbers.Map((v) => v * 2)

    result .= "With Array library:`n"
    result .= "doubled := numbers.Map((v) => v * 2)`n`n"

    result .= "Other useful methods:`n"
    result .= "- Filter: arr.Filter((v) => v > 5)`n"
    result .= "- Reduce: arr.Reduce((a,b) => a + b, 0)`n"
    result .= "- Shuffle: arr.Shuffle()`n"
    result .= "- Flat: [[1,2],[3,4]].Flat()"

    MsgBox(result, "Array Map Demo")
}

; Helper: Convert array to string
ArrayToString(arr) {
    str := "["
    for i, val in arr {
        str .= val
        if (i < arr.Length)
            str .= ", "
    }
    return str "]"
}

; Run demonstration
DemoArrayMap()
