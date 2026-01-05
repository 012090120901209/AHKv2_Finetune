#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; OrderedMap and DefaultMap - Enhanced map collections
; Demonstrates insertion order preservation and default values

; OrderedMap - Preserves insertion order
class OrderedMap {
    __New() {
        this.keys := []
        this.values := Map()
    }

    Set(key, value) {
        if !this.values.Has(key)
            this.keys.Push(key)
        this.values[key] := value
        return this
    }

    Get(key, default := "") {
        return this.values.Has(key) ? this.values[key] : default
    }

    Has(key) => this.values.Has(key)

    Delete(key) {
        if this.values.Has(key) {
            this.values.Delete(key)
            for i, k in this.keys {
                if k = key {
                    this.keys.RemoveAt(i)
                    break
                }
            }
            return true
        }
        return false
    }

    Clear() {
        this.keys := []
        this.values := Map()
    }

    First() => this.keys.Length ? this.values[this.keys[1]] : ""
    Last() => this.keys.Length ? this.values[this.keys[this.keys.Length]] : ""
    Count() => this.keys.Length

    GetKeys() => this.keys.Clone()

    GetValues() {
        result := []
        for key in this.keys
            result.Push(this.values[key])
        return result
    }

    __Enum(varCount) {
        idx := 0
        keys := this.keys
        values := this.values

        if varCount = 1
            return (&key) => ++idx <= keys.Length ? (key := keys[idx], true) : false
        else
            return (&key, &value) => ++idx <= keys.Length ? (key := keys[idx], value := values[key], true) : false
    }
}

; DefaultMap - Returns default value for missing keys
class DefaultMap {
    __New(defaultFactory := "") {
        this.data := Map()
        this.defaultFactory := defaultFactory
    }

    Get(key) {
        if !this.data.Has(key) {
            if this.defaultFactory
                this.data[key] := this.defaultFactory()
            else
                return ""
        }
        return this.data[key]
    }

    Set(key, value) {
        this.data[key] := value
        return this
    }

    Has(key) => this.data.Has(key)
    Delete(key) => this.data.Delete(key)
    Count() => this.data.Count

    __Enum(varCount) => this.data.__Enum(varCount)
}

; Counter - Specialized DefaultMap for counting
class Counter {
    __New(items := "") {
        this.counts := Map()
        if items {
            for item in items
                this.Add(item)
        }
    }

    Add(item, count := 1) {
        if !this.counts.Has(item)
            this.counts[item] := 0
        this.counts[item] += count
        return this
    }

    Get(item) => this.counts.Has(item) ? this.counts[item] : 0

    MostCommon(n := 0) {
        items := []
        for item, count in this.counts
            items.Push(Map("item", item, "count", count))

        ; Sort descending
        Loop items.Length - 1 {
            i := A_Index
            Loop items.Length - i {
                j := i + A_Index
                if items[j]["count"] > items[i]["count"] {
                    temp := items[i]
                    items[i] := items[j]
                    items[j] := temp
                }
            }
        }

        return n > 0 && n < items.Length ? items.RemoveAt(n + 1, items.Length - n) : items
    }

    Total() {
        sum := 0
        for _, count in this.counts
            sum += count
        return sum
    }

    __Enum(varCount) => this.counts.__Enum(varCount)
}

; Demo - OrderedMap
om := OrderedMap()
om.Set("first", 1).Set("second", 2).Set("third", 3)

result := "OrderedMap (preserves insertion order):`n"
for key, value in om
    result .= key ": " value "`n"

result .= "First: " om.First() ", Last: " om.Last()

MsgBox(result)

; Demo - DefaultMap
dm := DefaultMap(() => [])  ; Default to empty array

dm.Get("users").Push("Alice")
dm.Get("users").Push("Bob")
dm.Get("admins").Push("Charlie")

result := "DefaultMap (auto-creates arrays):`n"
for key, arr in dm {
    result .= key ": "
    for item in arr
        result .= item " "
    result .= "`n"
}

MsgBox(result)

; Demo - Counter
words := StrSplit("the quick brown fox jumps over the lazy dog the fox", " ")
wordCounter := Counter(words)

result := "Word counts:`n"
for item in wordCounter.MostCommon(5)
    result .= item["item"] ": " item["count"] "`n"

result .= "Total words: " wordCounter.Total()

MsgBox(result)
