#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; LINQ-style Query - Fluent data querying interface
; Demonstrates functional collection operations with chaining

class Query {
    __New(source) {
        this.source := source
        this.operations := []
    }

    Where(predicate) {
        this.operations.Push(Map("type", "where", "fn", predicate))
        return this
    }

    Select(selector) {
        this.operations.Push(Map("type", "select", "fn", selector))
        return this
    }

    OrderBy(keySelector, descending := false) {
        this.operations.Push(Map("type", "orderby", "fn", keySelector, "desc", descending))
        return this
    }

    Take(count) {
        this.operations.Push(Map("type", "take", "count", count))
        return this
    }

    Skip(count) {
        this.operations.Push(Map("type", "skip", "count", count))
        return this
    }

    Distinct() {
        this.operations.Push(Map("type", "distinct"))
        return this
    }

    ToArray() {
        result := this.source.Clone()

        for op in this.operations {
            switch op["type"] {
                case "where":
                    result := this.ApplyWhere(result, op["fn"])
                case "select":
                    result := this.ApplySelect(result, op["fn"])
                case "orderby":
                    result := this.ApplyOrderBy(result, op["fn"], op["desc"])
                case "take":
                    result := this.ApplyTake(result, op["count"])
                case "skip":
                    result := this.ApplySkip(result, op["count"])
                case "distinct":
                    result := this.ApplyDistinct(result)
            }
        }
        return result
    }

    First() {
        arr := this.ToArray()
        return arr.Length ? arr[1] : ""
    }

    Count() => this.ToArray().Length

    ApplyWhere(arr, fn) {
        result := []
        for item in arr
            if fn(item)
                result.Push(item)
        return result
    }

    ApplySelect(arr, fn) {
        result := []
        for item in arr
            result.Push(fn(item))
        return result
    }

    ApplyOrderBy(arr, fn, desc) {
        arr.Sort((a, b) {
            va := fn(a)
            vb := fn(b)
            cmp := va > vb ? 1 : (va < vb ? -1 : 0)
            return desc ? -cmp : cmp
        })
        return arr
    }

    ApplyTake(arr, count) {
        result := []
        Loop Min(count, arr.Length)
            result.Push(arr[A_Index])
        return result
    }

    ApplySkip(arr, count) {
        result := []
        i := count + 1
        while i <= arr.Length
            result.Push(arr[i++])
        return result
    }

    ApplyDistinct(arr) {
        seen := Map()
        result := []
        for item in arr {
            key := String(item)
            if !seen.Has(key) {
                seen[key] := true
                result.Push(item)
            }
        }
        return result
    }
}

; Demo - query users
users := [
    Map("name", "Alice", "age", 30, "dept", "Engineering"),
    Map("name", "Bob", "age", 25, "dept", "Sales"),
    Map("name", "Charlie", "age", 35, "dept", "Engineering"),
    Map("name", "Diana", "age", 28, "dept", "Marketing"),
    Map("name", "Eve", "age", 32, "dept", "Engineering")
]

; Query: Engineers over 28, sorted by age, take top 2
result := Query(users)
    .Where((u) => u["dept"] = "Engineering")
    .Where((u) => u["age"] > 28)
    .OrderBy((u) => u["age"])
    .Take(2)
    .Select((u) => u["name"] " (" u["age"] ")")
    .ToArray()

output := "Engineers over 28 (top 2 by age):`n"
for item in result
    output .= "- " item "`n"

MsgBox(output)
