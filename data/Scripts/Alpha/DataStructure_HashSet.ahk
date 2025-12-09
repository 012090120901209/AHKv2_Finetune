#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; HashSet - Unique value collection with O(1) operations
; Demonstrates set theory operations

class HashSet {
    __New(values := "") {
        this.items := Map()
        if values {
            for value in values
                this.Add(value)
        }
    }

    Add(value) {
        this.items[value] := true
        return this
    }

    Has(value) => this.items.Has(value)

    Delete(value) {
        if this.items.Has(value) {
            this.items.Delete(value)
            return true
        }
        return false
    }

    Clear() => this.items := Map()
    Size() => this.items.Count

    ToArray() {
        arr := []
        for key, _ in this.items
            arr.Push(key)
        return arr
    }

    ; Set operations
    Union(other) {
        result := HashSet()
        for key, _ in this.items
            result.Add(key)
        for key, _ in other.items
            result.Add(key)
        return result
    }

    Intersection(other) {
        result := HashSet()
        for key, _ in this.items
            if other.Has(key)
                result.Add(key)
        return result
    }

    Difference(other) {
        result := HashSet()
        for key, _ in this.items
            if !other.Has(key)
                result.Add(key)
        return result
    }

    SymmetricDifference(other) {
        return this.Difference(other).Union(other.Difference(this))
    }

    IsSubset(other) {
        for key, _ in this.items
            if !other.Has(key)
                return false
        return true
    }

    IsSuperset(other) => other.IsSubset(this)
    
    IsDisjoint(other) => this.Intersection(other).Size() = 0

    __Enum(varCount) {
        enum := this.items.__Enum(2)
        return (&value) => enum(&value, &_)
    }
}

; Demo
setA := HashSet([1, 2, 3, 4, 5])
setB := HashSet([4, 5, 6, 7, 8])

result := "Set A: " ArrayJoin(setA.ToArray())
result .= "`nSet B: " ArrayJoin(setB.ToArray())

; Set operations
result .= "`n`nUnion (A ∪ B): " ArrayJoin(setA.Union(setB).ToArray())
result .= "`nIntersection (A ∩ B): " ArrayJoin(setA.Intersection(setB).ToArray())
result .= "`nDifference (A - B): " ArrayJoin(setA.Difference(setB).ToArray())
result .= "`nSymmetric Diff (A △ B): " ArrayJoin(setA.SymmetricDifference(setB).ToArray())

MsgBox(result)

; Subset/superset
small := HashSet([1, 2])
large := HashSet([1, 2, 3, 4, 5])

MsgBox("Is {1,2} subset of {1,2,3,4,5}? " small.IsSubset(large)
     . "`nIs {1,2,3,4,5} superset of {1,2}? " large.IsSuperset(small)
     . "`nAre {1,2,3} and {4,5,6} disjoint? " HashSet([1,2,3]).IsDisjoint(HashSet([4,5,6])))

; Helper
ArrayJoin(arr, sep := ", ") {
    result := ""
    for i, v in arr
        result .= (i > 1 ? sep : "") v
    return result
}
