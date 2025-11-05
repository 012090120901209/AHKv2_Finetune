#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Advanced Flow Control Example: Data Processing Pipeline
; Demonstrates: Method chaining, functional programming, data transformation

; Pipeline class for data transformation
class Pipeline {
    __New(data) {
        this.data := data
    }

    ; Filter: Keep items that match condition
    Filter(predicate) {
        filtered := []
        for item in this.data {
            if (predicate(item))
                filtered.Push(item)
        }
        this.data := filtered
        return this  ; Enable chaining
    }

    ; Map: Transform each item
    Map(transformer) {
        mapped := []
        for item in this.data {
            mapped.Push(transformer(item))
        }
        this.data := mapped
        return this
    }

    ; Reduce: Combine all items into single value
    Reduce(reducer, initial := 0) {
        accumulator := initial
        for item in this.data {
            accumulator := reducer(accumulator, item)
        }
        return accumulator
    }

    ; Take: Get first N items
    Take(count) {
        result := []
        Loop Min(count, this.data.Length) {
            result.Push(this.data[A_Index])
        }
        this.data := result
        return this
    }

    ; Skip: Skip first N items
    Skip(count) {
        result := []
        Loop this.data.Length {
            if (A_Index > count)
                result.Push(this.data[A_Index])
        }
        this.data := result
        return this
    }

    ; Sort: Sort items
    Sort(ascending := true) {
        ; Simple bubble sort for demonstration
        arr := this.data.Clone()
        n := arr.Length

        Loop n - 1 {
            swapped := false
            Loop n - A_Index {
                j := A_Index
                compare := ascending ? (arr[j] > arr[j + 1]) : (arr[j] < arr[j + 1])
                if (compare) {
                    temp := arr[j]
                    arr[j] := arr[j + 1]
                    arr[j + 1] := temp
                    swapped := true
                }
            }
            if (!swapped)
                break
        }

        this.data := arr
        return this
    }

    ; Distinct: Remove duplicates
    Distinct() {
        seen := Map()
        result := []

        for item in this.data {
            if (!seen.Has(item)) {
                seen[item] := true
                result.Push(item)
            }
        }

        this.data := result
        return this
    }

    ; Reverse: Reverse order
    Reverse() {
        result := []
        Loop this.data.Length {
            result.Push(this.data[this.data.Length - A_Index + 1])
        }
        this.data := result
        return this
    }

    ; Get result
    ToArray() {
        return this.data
    }

    ; Get count
    Count() {
        return this.data.Length
    }

    ; Get sum (for numeric data)
    Sum() {
        return this.Reduce((acc, val) => acc + val, 0)
    }

    ; Get average (for numeric data)
    Average() {
        if (this.data.Length = 0)
            return 0
        return this.Sum() / this.data.Length
    }

    ; Get maximum value
    Max() {
        if (this.data.Length = 0)
            return 0
        return this.Reduce((acc, val) => val > acc ? val : acc, this.data[1])
    }

    ; Get minimum value
    Min() {
        if (this.data.Length = 0)
            return 0
        return this.Reduce((acc, val) => val < acc ? val : acc, this.data[1])
    }
}

; Create GUI
pipeGui := Gui()
pipeGui.Title := "Data Processing Pipeline Demo"

pipeGui.Add("Text", "x10 y10", "Build data transformation pipelines with method chaining")

; Input data
pipeGui.Add("Text", "x10 y35", "Input Data (comma-separated numbers):")
inputData := pipeGui.Add("Edit", "x10 y55 w460", "5,12,3,18,7,22,9,15,4,20,11,6,25,8,19")

; Pipeline operations
pipeGui.Add("GroupBox", "x10 y85 w460 h140", "Pipeline Operations")

cbFilter := pipeGui.Add("Checkbox", "x20 y105", "Filter (keep only > 10)")
cbDouble := pipeGui.Add("Checkbox", "x20 y130", "Map (double each value)")
cbSort := pipeGui.Add("Checkbox", "x20 y155", "Sort ascending")
cbTake := pipeGui.Add("Checkbox", "x20 y180", "Take first")
takeCount := pipeGui.Add("Edit", "x120 y177 w50 Number Disabled", "5")

cbFilter.OnEvent("Click", UpdateTakeState)
cbDouble.OnEvent("Click", UpdateTakeState)
cbSort.OnEvent("Click", UpdateTakeState)
cbTake.OnEvent("Click", UpdateTakeState)

cbDistinct := pipeGui.Add("Checkbox", "x250 y105", "Remove duplicates")
cbReverse := pipeGui.Add("Checkbox", "x250 y130", "Reverse order")
cbSquare := pipeGui.Add("Checkbox", "x250 y155", "Map (square values)")

pipeGui.Add("Button", "x20 y235 w200", "Execute Pipeline").OnEvent("Click", ExecutePipeline)
pipeGui.Add("Button", "x230 y235 w200", "Show Examples").OnEvent("Click", ShowExamples)

; Results
pipeGui.Add("Text", "x10 y270", "Results:")
resultText := pipeGui.Add("Edit", "x10 y290 w460 h180 ReadOnly Multi")

pipeGui.Show("w480 h485")

UpdateTakeState(*) {
    takeCount.Enabled := cbTake.Value
}

ExecutePipeline(*) {
    ; Parse input data
    input := inputData.Value
    numbers := []

    Loop Parse, input, ","
    {
        trimmed := Trim(A_LoopField)
        if (IsNumber(trimmed))
            numbers.Push(Integer(trimmed))
    }

    if (numbers.Length = 0) {
        MsgBox("Please enter valid numbers!", "Error")
        return
    }

    ; Start pipeline
    pipeline := Pipeline(numbers)
    operations := "Input: " ArrayToString(numbers) "`n`n"
    operations .= "Pipeline Steps:`n"

    ; Apply operations in order
    if (cbFilter.Value) {
        pipeline := pipeline.Filter((x) => x > 10)
        operations .= "1. Filter (> 10): " ArrayToString(pipeline.data) "`n"
    }

    if (cbDouble.Value) {
        pipeline := pipeline.Map((x) => x * 2)
        operations .= "2. Map (double): " ArrayToString(pipeline.data) "`n"
    }

    if (cbSquare.Value) {
        pipeline := pipeline.Map((x) => x * x)
        operations .= "3. Map (square): " ArrayToString(pipeline.data) "`n"
    }

    if (cbDistinct.Value) {
        pipeline := pipeline.Distinct()
        operations .= "4. Distinct: " ArrayToString(pipeline.data) "`n"
    }

    if (cbSort.Value) {
        pipeline := pipeline.Sort(true)
        operations .= "5. Sort: " ArrayToString(pipeline.data) "`n"
    }

    if (cbReverse.Value) {
        pipeline := pipeline.Reverse()
        operations .= "6. Reverse: " ArrayToString(pipeline.data) "`n"
    }

    if (cbTake.Value) {
        count := Integer(takeCount.Value)
        pipeline := pipeline.Take(count)
        operations .= "7. Take(" count "): " ArrayToString(pipeline.data) "`n"
    }

    ; Final results
    result := pipeline.ToArray()
    operations .= "`nFinal Result: " ArrayToString(result) "`n"
    operations .= "Count: " pipeline.Count() "`n"
    operations .= "Sum: " pipeline.Sum() "`n"
    operations .= "Average: " Round(pipeline.Average(), 2) "`n"
    operations .= "Min: " pipeline.Min() "`n"
    operations .= "Max: " pipeline.Max()

    resultText.Value := operations
}

ShowExamples(*) {
    examples := "
    (
    Pipeline Examples
    =================

    Example 1: Filter and Transform
    -------------------------------
    [1,2,3,4,5,6,7,8,9,10]
      .Filter(x => x > 5)     → [6,7,8,9,10]
      .Map(x => x * 2)        → [12,14,16,18,20]
      .Sum()                  → 80

    Example 2: Sort and Take Top 5
    ------------------------------
    [15,3,9,22,7,18,5,12]
      .Sort(descending)       → [22,18,15,12,9,7,5,3]
      .Take(5)                → [22,18,15,12,9]

    Example 3: Remove Duplicates
    ----------------------------
    [1,2,2,3,3,3,4,4,4,4]
      .Distinct()             → [1,2,3,4]

    Example 4: Complex Chain
    -----------------------
    [5,12,3,18,7,22,9,15]
      .Filter(x => x > 8)     → [12,18,22,15]
      .Map(x => x * x)        → [144,324,484,225]
      .Sort()                 → [144,225,324,484]
      .Take(3)                → [144,225,324]
      .Average()              → 231

    All operations are chainable!
    )"

    MsgBox(examples, "Pipeline Examples")
}

ArrayToString(arr) {
    if (!IsObject(arr) || arr.Length = 0)
        return "[]"

    result := "["
    for item in arr {
        result .= (A_Index > 1 ? ", " : "") . item
    }
    result .= "]"
    return result
}
