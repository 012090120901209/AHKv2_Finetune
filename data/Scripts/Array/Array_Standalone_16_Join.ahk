#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Join() - Join array elements (Standalone Implementation)
 * 
 * Converts all elements in array into a string separated by separator.
 */

Join(array, separator := ",") {
    result := ""

    for index, value in array {
        result .= value
        if (index < array.Length) {
            result .= separator
        }
    }

    return result
}

; Examples
result1 := Join(["a", "b", "c"], "~")
; => "a~b~c"

result2 := Join(["a", "b", "c"])
; => "a,b,c"

result3 := Join([1, 2, 3], " - ")
; => "1 - 2 - 3"

MsgBox("Join with '~': " result1 "`n"
    . "Join with default: " result2 "`n"
    . "Join with ' - ': " result3)
