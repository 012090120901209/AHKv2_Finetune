#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Segment Tree - Range query data structure
; Demonstrates efficient range operations

class SegmentTree {
    ; Build tree for range sum queries
    __New(arr, operation := "sum") {
        this.n := arr.Length
        this.tree := []
        this.lazy := []  ; For lazy propagation
        this.operation := operation

        ; Initialize tree (2 * next power of 2)
        treeSize := this.n * 4
        Loop treeSize {
            this.tree.Push(0)
            this.lazy.Push(0)
        }

        this._build(arr, 1, 1, this.n)
    }

    _build(arr, node, start, end) {
        if start = end {
            this.tree[node] := arr[start]
            return this.tree[node]
        }

        mid := (start + end) // 2
        left := this._build(arr, node * 2, start, mid)
        right := this._build(arr, node * 2 + 1, mid + 1, end)

        this.tree[node] := this._combine(left, right)
        return this.tree[node]
    }

    _combine(a, b) {
        switch this.operation {
            case "sum": return a + b
            case "min": return Min(a, b)
            case "max": return Max(a, b)
            default: return a + b
        }
    }

    _identity() {
        switch this.operation {
            case "sum": return 0
            case "min": return 999999999
            case "max": return -999999999
            default: return 0
        }
    }

    ; Query range [l, r]
    Query(l, r) {
        return this._query(1, 1, this.n, l, r)
    }

    _query(node, start, end, l, r) {
        ; Propagate lazy updates
        this._propagate(node, start, end)

        ; Out of range
        if r < start || end < l
            return this._identity()

        ; Completely in range
        if l <= start && end <= r
            return this.tree[node]

        ; Partial overlap
        mid := (start + end) // 2
        left := this._query(node * 2, start, mid, l, r)
        right := this._query(node * 2 + 1, mid + 1, end, l, r)

        return this._combine(left, right)
    }

    ; Point update
    Update(index, value) {
        this._update(1, 1, this.n, index, value)
    }

    _update(node, start, end, index, value) {
        this._propagate(node, start, end)

        if start = end {
            this.tree[node] := value
            return
        }

        mid := (start + end) // 2
        if index <= mid
            this._update(node * 2, start, mid, index, value)
        else
            this._update(node * 2 + 1, mid + 1, end, index, value)

        this.tree[node] := this._combine(this.tree[node * 2], this.tree[node * 2 + 1])
    }

    ; Range update (add delta to range [l, r])
    RangeUpdate(l, r, delta) {
        this._rangeUpdate(1, 1, this.n, l, r, delta)
    }

    _rangeUpdate(node, start, end, l, r, delta) {
        this._propagate(node, start, end)

        if r < start || end < l
            return

        if l <= start && end <= r {
            this.lazy[node] += delta
            this._propagate(node, start, end)
            return
        }

        mid := (start + end) // 2
        this._rangeUpdate(node * 2, start, mid, l, r, delta)
        this._rangeUpdate(node * 2 + 1, mid + 1, end, l, r, delta)

        this.tree[node] := this._combine(this.tree[node * 2], this.tree[node * 2 + 1])
    }

    _propagate(node, start, end) {
        if this.lazy[node] = 0
            return

        ; Apply lazy update
        if this.operation = "sum"
            this.tree[node] += this.lazy[node] * (end - start + 1)
        else
            this.tree[node] += this.lazy[node]

        ; Push to children
        if start != end {
            this.lazy[node * 2] += this.lazy[node]
            this.lazy[node * 2 + 1] += this.lazy[node]
        }

        this.lazy[node] := 0
    }
}

; Demo - Range sum queries
arr := [1, 3, 5, 7, 9, 11]
sumTree := SegmentTree(arr, "sum")

result := "Segment Tree Demo (Range Sum):`n`n"
result .= "Array: [1, 3, 5, 7, 9, 11]`n`n"

result .= "Queries:`n"
result .= Format("  Sum [1, 3]: {} (expected: {})`n", sumTree.Query(1, 3), 1 + 3 + 5)
result .= Format("  Sum [2, 5]: {} (expected: {})`n", sumTree.Query(2, 5), 3 + 5 + 7 + 9)
result .= Format("  Sum [1, 6]: {} (expected: {})`n", sumTree.Query(1, 6), 1 + 3 + 5 + 7 + 9 + 11)

result .= "`nAfter Update: arr[3] = 10`n"
sumTree.Update(3, 10)
result .= Format("  Sum [1, 3]: {} (expected: {})`n", sumTree.Query(1, 3), 1 + 3 + 10)

MsgBox(result)

; Demo - Range min queries
arr := [5, 2, 8, 1, 9, 3, 7, 4]
minTree := SegmentTree(arr, "min")

result := "Segment Tree Demo (Range Min):`n`n"
result .= "Array: [5, 2, 8, 1, 9, 3, 7, 4]`n`n"

result .= "Queries:`n"
result .= Format("  Min [1, 4]: {} (expected: 1)`n", minTree.Query(1, 4))
result .= Format("  Min [5, 8]: {} (expected: 3)`n", minTree.Query(5, 8))
result .= Format("  Min [3, 6]: {} (expected: 1)`n", minTree.Query(3, 6))

MsgBox(result)

; Demo - Range max queries
maxTree := SegmentTree(arr, "max")

result := "Segment Tree Demo (Range Max):`n`n"
result .= "Array: [5, 2, 8, 1, 9, 3, 7, 4]`n`n"

result .= "Queries:`n"
result .= Format("  Max [1, 4]: {} (expected: 8)`n", maxTree.Query(1, 4))
result .= Format("  Max [5, 8]: {} (expected: 9)`n", maxTree.Query(5, 8))
result .= Format("  Max [2, 7]: {} (expected: 9)`n", maxTree.Query(2, 7))

MsgBox(result)

; Demo - Range update with lazy propagation
arr := [0, 0, 0, 0, 0, 0, 0, 0]
lazyTree := SegmentTree(arr, "sum")

result := "Segment Tree Demo (Lazy Propagation):`n`n"
result .= "Initial: [0, 0, 0, 0, 0, 0, 0, 0]`n`n"

lazyTree.RangeUpdate(2, 5, 3)  ; Add 3 to indices 2-5
result .= "After adding 3 to [2, 5]:`n"
result .= Format("  Sum [1, 8]: {}`n", lazyTree.Query(1, 8))
result .= Format("  Sum [2, 5]: {}`n", lazyTree.Query(2, 5))

lazyTree.RangeUpdate(4, 7, 2)  ; Add 2 to indices 4-7
result .= "`nAfter adding 2 to [4, 7]:`n"
result .= Format("  Sum [1, 8]: {}`n", lazyTree.Query(1, 8))
result .= Format("  Sum [4, 5]: {}`n", lazyTree.Query(4, 5))

MsgBox(result)

; Demo - Complexity analysis
result := "Segment Tree Complexity:`n`n"
result .= "Operation      | Time      | Space`n"
result .= "---------------|-----------|-------`n"
result .= "Build          | O(n)      | O(n)`n"
result .= "Point Query    | O(log n)  | -`n"
result .= "Range Query    | O(log n)  | -`n"
result .= "Point Update   | O(log n)  | -`n"
result .= "Range Update   | O(log n)* | -`n"
result .= "`n* With lazy propagation`n`n"
result .= "Use Cases:`n"
result .= "- Range sum/min/max queries`n"
result .= "- Range updates (add/set)`n"
result .= "- Database aggregations`n"
result .= "- Computational geometry"

MsgBox(result)
