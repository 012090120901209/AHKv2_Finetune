#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Functional Pipeline - Composable data transformations
; Demonstrates functional programming patterns

class Pipeline {
    __New(value := "") {
        this.value := value
        this.operations := []
    }

    static Of(value) => Pipeline(value)

    Map(fn) {
        pipe := Pipeline(this.value)
        pipe.operations := this.operations.Clone()
        pipe.operations.Push(Map("type", "map", "fn", fn))
        return pipe
    }

    Filter(fn) {
        pipe := Pipeline(this.value)
        pipe.operations := this.operations.Clone()
        pipe.operations.Push(Map("type", "filter", "fn", fn))
        return pipe
    }

    FlatMap(fn) {
        pipe := Pipeline(this.value)
        pipe.operations := this.operations.Clone()
        pipe.operations.Push(Map("type", "flatMap", "fn", fn))
        return pipe
    }

    Take(n) {
        pipe := Pipeline(this.value)
        pipe.operations := this.operations.Clone()
        pipe.operations.Push(Map("type", "take", "n", n))
        return pipe
    }

    Skip(n) {
        pipe := Pipeline(this.value)
        pipe.operations := this.operations.Clone()
        pipe.operations.Push(Map("type", "skip", "n", n))
        return pipe
    }

    Reduce(fn, initial) {
        result := this.Execute()
        accumulator := initial

        for item in result
            accumulator := fn(accumulator, item)

        return accumulator
    }

    Execute() {
        result := this.value is Array ? this.value.Clone() : [this.value]

        for op in this.operations {
            switch op["type"] {
                case "map":
                    newResult := []
                    for item in result
                        newResult.Push(op["fn"](item))
                    result := newResult

                case "filter":
                    newResult := []
                    for item in result
                        if op["fn"](item)
                            newResult.Push(item)
                    result := newResult

                case "flatMap":
                    newResult := []
                    for item in result {
                        mapped := op["fn"](item)
                        if mapped is Array {
                            for sub in mapped
                                newResult.Push(sub)
                        } else {
                            newResult.Push(mapped)
                        }
                    }
                    result := newResult

                case "take":
                    if result.Length > op["n"]
                        result.RemoveAt(op["n"] + 1, result.Length - op["n"])

                case "skip":
                    if result.Length > op["n"]
                        result.RemoveAt(1, Min(op["n"], result.Length))
                    else
                        result := []
            }
        }

        return result
    }

    ToArray() => this.Execute()

    First(default := "") {
        result := this.Execute()
        return result.Length ? result[1] : default
    }

    Last(default := "") {
        result := this.Execute()
        return result.Length ? result[result.Length] : default
    }

    Count() => this.Execute().Length

    Any(fn := "") {
        result := this.Execute()
        for item in result
            if !fn || fn(item)
                return true
        return false
    }

    All(fn) {
        result := this.Execute()
        for item in result
            if !fn(item)
                return false
        return true
    }
}

; Compose functions (right to left)
Compose(fns*) {
    return (x) {
        result := x
        i := fns.Length
        while i >= 1 {
            result := fns[i](result)
            i--
        }
        return result
    }
}

; Pipe functions (left to right)
Pipe(fns*) {
    return (x) {
        result := x
        for fn in fns
            result := fn(result)
        return result
    }
}

; Curry - Convert multi-arg function to curried form
Curry(fn, arity := 2) {
    return _curry(fn, arity, [])
}

_curry(fn, arity, args) {
    if args.Length >= arity
        return fn(args*)

    ; Return a closure that captures fn, arity, and args
    return CurriedStep.Bind(fn, arity, args)
}

CurriedStep(fn, arity, args, arg) {
    newArgs := args.Clone()
    newArgs.Push(arg)
    return _curry(fn, arity, newArgs)
}

; Partial application
Partial(fn, boundArgs*) {
    return PartialCall.Bind(fn, boundArgs)
}

PartialCall(fn, boundArgs, moreArgs*) {
    allArgs := boundArgs.Clone()
    for arg in moreArgs
        allArgs.Push(arg)
    return fn(allArgs*)
}

; Demo - Pipeline
numbers := [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

result := Pipeline.Of(numbers)
    .Filter((x) => Mod(x, 2) = 0)      ; Keep even
    .Map((x) => x * x)                  ; Square
    .Take(3)                            ; First 3
    .ToArray()

output := "Pipeline Demo:`n`n"
output .= "Input: " JoinArray(numbers) "`n"
output .= "Filter even → Square → Take 3`n"
output .= "Result: " JoinArray(result) "`n"

JoinArray(arr, sep := ", ") {
    result := ""
    for i, v in arr
        result .= (i > 1 ? sep : "") v
    return result
}

MsgBox(output)

; Demo - Compose and Pipe
double := (x) => x * 2
addOne := (x) => x + 1
square := (x) => x * x

; Compose: square(addOne(double(5))) = square(11) = 121
composed := Compose(square, addOne, double)

; Pipe: square(addOne(double(5))) but read left to right
piped := Pipe(double, addOne, square)

result := "Compose vs Pipe Demo:`n`n"
result .= "Functions: double, addOne, square`n"
result .= "Input: 5`n`n"
result .= "Compose(square, addOne, double)(5) = " composed(5) "`n"
result .= "  → double(5)=10, addOne(10)=11, square(11)=121`n`n"
result .= "Pipe(double, addOne, square)(5) = " piped(5) "`n"
result .= "  → double(5)=10, addOne(10)=11, square(11)=121"

MsgBox(result)

; Demo - Curry and Partial
add := (a, b, c) => a + b + c

curriedAdd := Curry(add, 3)
partialAdd := Partial(add, 10)

result := "Curry and Partial Demo:`n`n"
result .= "add(a, b, c) = a + b + c`n`n"

result .= "Curried: curriedAdd(1)(2)(3) = " curriedAdd(1)(2)(3) "`n"
result .= "Partial: partialAdd(5, 7) = " partialAdd(5, 7) "`n"

MsgBox(result)

; Demo - Complex pipeline with reduce
people := [
    Map("name", "Alice", "age", 25, "dept", "Engineering"),
    Map("name", "Bob", "age", 30, "dept", "Engineering"),
    Map("name", "Charlie", "age", 35, "dept", "Sales"),
    Map("name", "Diana", "age", 28, "dept", "Engineering"),
    Map("name", "Eve", "age", 32, "dept", "Sales")
]

; Get average age of Engineering dept
engineeringAges := Pipeline.Of(people)
    .Filter((p) => p["dept"] = "Engineering")
    .Map((p) => p["age"])

totalAge := engineeringAges.Reduce((sum, age) => sum + age, 0)
count := engineeringAges.Count()
avgAge := totalAge / count

; Get all names
names := Pipeline.Of(people)
    .Map((p) => p["name"])
    .Reduce((acc, name) => acc (acc ? ", " : "") name, "")

result := "Complex Pipeline Demo:`n`n"
result .= "People: " names "`n`n"
result .= "Engineering dept average age: " Round(avgAge, 1) "`n"
result .= "  (Total: " totalAge ", Count: " count ")"

MsgBox(result)
