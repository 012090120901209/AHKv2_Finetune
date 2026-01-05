#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Iterator Pattern - Sequential access without exposing underlying structure
; Demonstrates custom __Enum implementations for for-loops

class Range {
    __New(start, end, step := 1) {
        this.start := start
        this.end := end
        this.step := step
    }

    __Enum(n) {
        i := this.start
        return (&val) {
            if (this.step > 0 && i > this.end) || (this.step < 0 && i < this.end)
                return false
            val := i
            i += this.step
            return true
        }
    }
}

class Fibonacci {
    __New(count) => this.count := count

    __Enum(n) {
        a := 0, b := 1, i := 0
        return (&val) {
            if i >= this.count
                return false
            val := a
            temp := a + b
            a := b
            b := temp
            i++
            return true
        }
    }
}

class Reversed {
    __New(arr) => this.arr := arr

    __Enum(n) {
        i := this.arr.Length
        return (&val) {
            if i < 1
                return false
            val := this.arr[i]
            i--
            return true
        }
    }
}

; Demo - Range iterator
result := "Range(1, 10, 2): "
for n in Range(1, 10, 2)
    result .= n " "

result .= "`n`nFibonacci(10): "
for n in Fibonacci(10)
    result .= n " "

result .= "`n`nReversed [a,b,c,d]: "
for item in Reversed(["a", "b", "c", "d"])
    result .= item " "

MsgBox(result)
