#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Skip List - Probabilistic balanced data structure
; Demonstrates O(log n) average operations

class SkipListNode {
    __New(value, level) {
        this.value := value
        this.forward := []
        Loop level
            this.forward.Push("")
    }
}

class SkipList {
    __New(maxLevel := 16, probability := 0.5) {
        this.maxLevel := maxLevel
        this.probability := probability
        this.level := 1
        this.header := SkipListNode("", maxLevel)
        this.size := 0
    }

    _randomLevel() {
        level := 1
        while Random() < this.probability && level < this.maxLevel
            level++
        return level
    }

    Insert(value) {
        update := []
        Loop this.maxLevel
            update.Push("")

        x := this.header

        ; Find insert position at each level
        i := this.level
        while i >= 1 {
            while x.forward[i] && x.forward[i].value < value
                x := x.forward[i]
            update[i] := x
            i--
        }

        ; Generate random level for new node
        level := this._randomLevel()

        if level > this.level {
            i := this.level + 1
            while i <= level {
                update[i] := this.header
                i++
            }
            this.level := level
        }

        ; Create new node
        newNode := SkipListNode(value, level)

        ; Update forward pointers
        i := 1
        while i <= level {
            newNode.forward[i] := update[i].forward[i]
            update[i].forward[i] := newNode
            i++
        }

        this.size++
        return true
    }

    Search(value) {
        x := this.header

        i := this.level
        while i >= 1 {
            while x.forward[i] && x.forward[i].value < value
                x := x.forward[i]
            i--
        }

        x := x.forward[1]
        return x && x.value = value
    }

    Delete(value) {
        update := []
        Loop this.maxLevel
            update.Push("")

        x := this.header

        i := this.level
        while i >= 1 {
            while x.forward[i] && x.forward[i].value < value
                x := x.forward[i]
            update[i] := x
            i--
        }

        x := x.forward[1]

        if x && x.value = value {
            i := 1
            while i <= this.level {
                if update[i].forward[i] != x
                    break
                update[i].forward[i] := x.forward[i]
                i++
            }

            ; Reduce level if needed
            while this.level > 1 && !this.header.forward[this.level]
                this.level--

            this.size--
            return true
        }

        return false
    }

    ToArray() {
        arr := []
        x := this.header.forward[1]
        while x {
            arr.Push(x.value)
            x := x.forward[1]
        }
        return arr
    }

    Count() => this.size

    ; Visualize the structure
    Visualize() {
        if !this.size
            return "(empty)"

        result := ""

        ; From top level down
        i := this.level
        while i >= 1 {
            result .= "L" i ": "
            x := this.header.forward[i]
            prev := this.header

            ; Walk bottom level to show gaps
            bottom := this.header.forward[1]
            while bottom {
                if x && bottom.value = x.value {
                    result .= "[" x.value "]"
                    x := x.forward[i]
                } else {
                    result .= "----"
                }
                result .= "->"
                bottom := bottom.forward[1]
            }
            result .= "NIL`n"
            i--
        }

        return result
    }
}

; Demo - Basic operations
list := SkipList(4, 0.5)

; Insert values
values := [3, 6, 7, 9, 12, 19, 17, 26, 21, 25]
for v in values
    list.Insert(v)

result := "Skip List Demo:`n`n"
result .= "Inserted: "
for i, v in values
    result .= (i > 1 ? ", " : "") v

result .= "`nSorted: "
sorted := list.ToArray()
for i, v in sorted
    result .= (i > 1 ? ", " : "") v

result .= "`n`nStructure:`n"
result .= list.Visualize()

MsgBox(result)

; Demo - Search
searches := [9, 15, 21]
result := "Skip List Search Demo:`n`n"

for search in searches {
    found := list.Search(search)
    result .= Format("Search {}: {}`n", search, found ? "Found" : "Not found")
}

MsgBox(result)

; Demo - Delete
result := "Skip List Delete Demo:`n`n"
result .= "Before: " _join(list.ToArray()) "`n"
result .= "Count: " list.Count() "`n`n"

list.Delete(9)
result .= "After delete 9: " _join(list.ToArray()) "`n"

list.Delete(26)
result .= "After delete 26: " _join(list.ToArray()) "`n"

result .= "`nFinal count: " list.Count()

_join(arr, sep := ", ") {
    result := ""
    for i, v in arr
        result .= (i > 1 ? sep : "") v
    return result
}

MsgBox(result)

; Demo - Performance comparison (conceptual)
result := "Skip List Complexity:`n`n"
result .= "Operation     | Average  | Worst`n"
result .= "--------------|---------|---------`n"
result .= "Search        | O(log n)| O(n)`n"
result .= "Insert        | O(log n)| O(n)`n"
result .= "Delete        | O(log n)| O(n)`n"
result .= "Space         | O(n)    | O(n log n)`n"
result .= "`nAdvantages:`n"
result .= "- Simpler than balanced trees`n"
result .= "- No rotations needed`n"
result .= "- Easy concurrent access`n"
result .= "- Cache-friendly traversal"

MsgBox(result)
