#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Strategy Pattern - Defines interchangeable algorithms
; Demonstrates runtime behavior switching through composition

class Sorter {
    __New(strategy) => this.strategy := strategy

    Sort(data) => this.strategy.Execute(data.Clone())
}

class AscendingSort {
    Execute(arr) {
        arr.Sort("N")
        return arr
    }
}

class DescendingSort {
    Execute(arr) {
        arr.Sort("NR")
        return arr
    }
}

; Demo
numbers := [3, 1, 4, 1, 5, 9, 2, 6]
ascending := Sorter(AscendingSort())
descending := Sorter(DescendingSort())

asc := ascending.Sort(numbers)
desc := descending.Sort(numbers)

MsgBox("Ascending: " asc[1] "," asc[2] "," asc[3] "`nDescending: " desc[1] "," desc[2] "," desc[3])
