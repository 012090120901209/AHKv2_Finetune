#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Advanced Loop Example: Generator Pattern (Iterator)
; Demonstrates: Custom iterators, range generation, lazy evaluation

; Range generator (like Python's range)
class Range {
    __New(start, end := "", step := 1) {
        if (end = "") {
            this.start := 1
            this.end := start
        } else {
            this.start := start
            this.end := end
        }
        this.step := step
        this.current := this.start
    }

    ; Iterator method for For loop
    __Enum(numberOfVars) {
        return (&value) => this.Next(&value)
    }

    Next(&value) {
        if (this.step > 0 && this.current > this.end)
            return false
        if (this.step < 0 && this.current < this.end)
            return false

        value := this.current
        this.current += this.step
        return true
    }

    Reset() {
        this.current := this.start
    }
}

; Fibonacci generator
class FibonacciGenerator {
    __New(maxCount := 0) {
        this.maxCount := maxCount
        this.count := 0
        this.a := 0
        this.b := 1
    }

    __Enum(numberOfVars) {
        return (&value) => this.Next(&value)
    }

    Next(&value) {
        if (this.maxCount > 0 && this.count >= this.maxCount)
            return false

        value := this.a
        temp := this.a + this.b
        this.a := this.b
        this.b := temp
        this.count++

        return true
    }

    Reset() {
        this.count := 0
        this.a := 0
        this.b := 1
    }
}

; Prime number generator
class PrimeGenerator {
    __New(maxPrimes := 100) {
        this.maxPrimes := maxPrimes
        this.count := 0
        this.current := 2
    }

    __Enum(numberOfVars) {
        return (&value) => this.Next(&value)
    }

    Next(&value) {
        if (this.count >= this.maxPrimes)
            return false

        while (!this.IsPrime(this.current)) {
            this.current++
        }

        value := this.current
        this.current++
        this.count++

        return true
    }

    IsPrime(n) {
        if (n < 2)
            return false
        if (n = 2)
            return true
        if (Mod(n, 2) = 0)
            return false

        limit := Sqrt(n)
        i := 3
        while (i <= limit) {
            if (Mod(n, i) = 0)
                return false
            i += 2
        }

        return true
    }

    Reset() {
        this.count := 0
        this.current := 2
    }
}

; File line generator
class FileLineGenerator {
    __New(filepath) {
        this.filepath := filepath
        this.lines := []

        if (FileExist(filepath)) {
            content := FileRead(filepath)
            this.lines := StrSplit(content, "`n", "`r")
        }

        this.index := 0
    }

    __Enum(numberOfVars) {
        return (&value) => this.Next(&value)
    }

    Next(&value) {
        this.index++

        if (this.index > this.lines.Length)
            return false

        value := this.lines[this.index]
        return true
    }

    Reset() {
        this.index := 0
    }
}

; Create GUI
genGui := Gui()
genGui.Title := "Generator Pattern / Iterator Demo"

genGui.Add("Text", "x10 y10", "Generator Examples (Lazy Evaluation):")

; Range generator
genGui.Add("GroupBox", "x10 y35 w460 h80", "Range Generator")
genGui.Add("Text", "x20 y60", "Start:")
rangeStart := genGui.Add("Edit", "x70 y57 w60 Number", "1")
genGui.Add("Text", "x140 y60", "End:")
rangeEnd := genGui.Add("Edit", "x180 y57 w60 Number", "10")
genGui.Add("Text", "x250 y60", "Step:")
rangeStep := genGui.Add("Edit", "x290 y57 w60 Number", "1")
genGui.Add("Button", "x20 y85 w150", "Generate Range").OnEvent("Click", GenerateRange)

; Fibonacci generator
genGui.Add("GroupBox", "x10 y125 w460 h80", "Fibonacci Generator")
genGui.Add("Text", "x20 y150", "Count:")
fibCount := genGui.Add("Edit", "x70 y147 w100 Number", "10")
genGui.Add("Button", "x20 y175 w150", "Generate Fibonacci").OnEvent("Click", GenerateFibonacci)
genGui.Add("Button", "x180 y175 w150", "First 100 Fibs").OnEvent("Click", Generate100Fibs)

; Prime generator
genGui.Add("GroupBox", "x10 y215 w460 h80", "Prime Number Generator")
genGui.Add("Text", "x20 y240", "Count:")
primeCount := genGui.Add("Edit", "x70 y237 w100 Number", "25")
genGui.Add("Button", "x20 y265 w150", "Generate Primes").OnEvent("Click", GeneratePrimes)

; Results
genGui.Add("Text", "x10 y305", "Results:")
resultDisplay := genGui.Add("Edit", "x10 y325 w460 h180 ReadOnly Multi")

genGui.Show("w480 h520")

GenerateRange(*) {
    start := Integer(rangeStart.Value)
    end := Integer(rangeEnd.Value)
    step := Integer(rangeStep.Value)

    if (step = 0) {
        MsgBox("Step cannot be zero!", "Error")
        return
    }

    result := "Range(" start ", " end ", " step "):`n`n"
    count := 0

    for value in Range(start, end, step) {
        result .= value " "
        count++

        ; Limit output
        if (count > 100) {
            result .= "..."
            break
        }
    }

    result .= "`n`nTotal items: " count

    resultDisplay.Value := result
}

GenerateFibonacci(*) {
    count := Integer(fibCount.Value)

    if (count > 100) {
        MsgBox("Count limited to 100 for display", "Warning")
        count := 100
    }

    result := "Fibonacci Sequence (First " count " numbers):`n`n"

    for value in FibonacciGenerator(count) {
        result .= value "`n"
    }

    resultDisplay.Value := result
}

Generate100Fibs(*) {
    result := "First 100 Fibonacci Numbers:`n`n"
    values := []

    for value in FibonacciGenerator(100) {
        values.Push(value)
    }

    ; Display in columns
    col := 0
    for value in values {
        result .= Format("{:15}", value)
        col++
        if (col = 3) {
            result .= "`n"
            col := 0
        }
    }

    resultDisplay.Value := result
}

GeneratePrimes(*) {
    count := Integer(primeCount.Value)

    if (count > 100) {
        MsgBox("Count limited to 100 for display", "Warning")
        count := 100
    }

    result := "First " count " Prime Numbers:`n`n"
    values := []

    for value in PrimeGenerator(count) {
        values.Push(value)
    }

    ; Display in columns
    col := 0
    for value in values {
        result .= Format("{:6}", value)
        col++
        if (col = 8) {
            result .= "`n"
            col := 0
        }
    }

    result .= "`n`nLargest: " values[values.Length]

    resultDisplay.Value := result
}

; Demonstrate lazy evaluation
^!l::
{
    MsgBox("
    (
    Lazy Evaluation Demo
    ====================

    Generators use lazy evaluation - they generate values on-demand
    rather than creating all values in memory at once.

    Example:
    For a Range(1, 1000000), only one value exists in memory at a time,
    not all one million values!

    This is memory-efficient and allows for infinite sequences.
    )", "Lazy Evaluation")
}
