#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; MultiMap and BiMap - Specialized map collections
; Demonstrates one-to-many and bidirectional mappings

; MultiMap - One key to many values
class MultiMap {
    __New() => this.data := Map()

    Add(key, value) {
        if !this.data.Has(key)
            this.data[key] := []
        this.data[key].Push(value)
        return this
    }

    Get(key) => this.data.Has(key) ? this.data[key] : []

    Has(key) => this.data.Has(key)

    HasValue(key, value) {
        if !this.data.Has(key)
            return false
        for v in this.data[key]
            if v = value
                return true
        return false
    }

    Remove(key, value := "") {
        if !this.data.Has(key)
            return false

        if value = "" {
            this.data.Delete(key)
            return true
        }

        values := this.data[key]
        for i, v in values {
            if v = value {
                values.RemoveAt(i)
                if values.Length = 0
                    this.data.Delete(key)
                return true
            }
        }
        return false
    }

    Keys() {
        keys := []
        for key, _ in this.data
            keys.Push(key)
        return keys
    }

    Count(key := "") {
        if key = ""
            return this.data.Count
        return this.data.Has(key) ? this.data[key].Length : 0
    }

    __Enum(varCount) {
        enum := this.data.__Enum(2)
        if varCount = 1
            return (&key) => enum(&key, &_)
        else
            return (&key, &values) => enum(&key, &values)
    }
}

; BiMap - Bidirectional map
class BiMap {
    __New() {
        this.forward := Map()
        this.reverse := Map()
    }

    Set(key, value) {
        ; Remove existing mappings
        if this.forward.Has(key) {
            oldValue := this.forward[key]
            this.reverse.Delete(oldValue)
        }
        if this.reverse.Has(value) {
            oldKey := this.reverse[value]
            this.forward.Delete(oldKey)
        }

        this.forward[key] := value
        this.reverse[value] := key
        return this
    }

    Get(key) => this.forward.Has(key) ? this.forward[key] : ""
    GetKey(value) => this.reverse.Has(value) ? this.reverse[value] : ""

    Has(key) => this.forward.Has(key)
    HasValue(value) => this.reverse.Has(value)

    Delete(key) {
        if this.forward.Has(key) {
            value := this.forward[key]
            this.forward.Delete(key)
            this.reverse.Delete(value)
            return true
        }
        return false
    }

    DeleteByValue(value) {
        if this.reverse.Has(value) {
            key := this.reverse[value]
            this.forward.Delete(key)
            this.reverse.Delete(value)
            return true
        }
        return false
    }

    Keys() {
        keys := []
        for key, _ in this.forward
            keys.Push(key)
        return keys
    }

    Values() {
        values := []
        for _, value in this.forward
            values.Push(value)
        return values
    }
    
    Count() => this.forward.Count
}

; Demo - MultiMap
mm := MultiMap()
mm.Add("fruits", "apple")
mm.Add("fruits", "banana")
mm.Add("fruits", "cherry")
mm.Add("vegetables", "carrot")
mm.Add("vegetables", "broccoli")

result := "MultiMap:`n"
for category, items in mm {
    result .= category ": "
    for item in items
        result .= item " "
    result .= "`n"
}

result .= "`nHas banana in fruits? " mm.HasValue("fruits", "banana")
result .= "`nFruits count: " mm.Count("fruits")

MsgBox(result)

; Demo - BiMap
bm := BiMap()
bm.Set("one", 1).Set("two", 2).Set("three", 3)

MsgBox("BiMap:`n"
     . "'one' -> " bm.Get("one") "`n"
     . "2 <- " bm.GetKey(2) "`n"
     . "Has 'two'? " bm.Has("two") "`n"
     . "Has value 3? " bm.HasValue(3))

; Overwrite test
bm.Set("ONE", 1)  ; 1 now maps to ONE instead of one
MsgBox("After bm.Set('ONE', 1):`n"
     . "1 <- " bm.GetKey(1) "`n"
     . "Has 'one'? " bm.Has("one"))
