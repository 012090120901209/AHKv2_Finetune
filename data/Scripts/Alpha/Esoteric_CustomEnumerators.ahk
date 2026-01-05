#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric Custom Enumerators - Advanced iteration patterns
; Demonstrates __Enum and custom iterator implementations

; =============================================================================
; 1. Basic Custom Enumerator
; =============================================================================

class Range {
    __New(start, end, step := 1) {
        this.start := start
        this.end := end
        this.step := step
    }

    __Enum(count) {
        current := this.start
        end := this.end
        step := this.step

        if count = 1 {
            ; for value in Range
            return (&value) => (
                current <= end
                    ? (value := current, current += step, true)
                : false
            )
        } else {
            ; for index, value in Range
            index := 0
            return (&i, &value) => (
                current <= end
                    ? (i := ++index, value := current, current += step, true)
                : false
            )
        }
    }

    ToArray() {
        result := []
        for v in this
            result.Push(v)
        return result
    }
}

; =============================================================================
; 2. Infinite Generator
; =============================================================================

class InfiniteCounter {
    __New(start := 1, step := 1) {
        this.current := start - step
        this.step := step
    }

    __Enum(count) {
        ; Warning: Will iterate forever! Use with break/Take
        return (&value) => (
            this.current += this.step,
            value := this.current,
            true  ; Always continue
        )
    }

    ; Take first N values
    Take(n) {
        result := []
        count := 0
        for v in this {
            result.Push(v)
            if ++count >= n
                break
        }
        return result
    }

    Reset(start := 1) => this.current := start - this.step
}

; =============================================================================
; 3. Filtered Enumerator (Lazy evaluation)
; =============================================================================

class FilteredIterator {
    __New(source, predicate) {
        this.source := source
        this.predicate := predicate
    }

    __Enum(count) {
        iter := this.source.__Enum(1)
        pred := this.predicate

        return (&value) => _FilteredIteratorStep(iter, pred, value)
    }
}

_FilteredIteratorStep(iter, pred, &value) {
    loop {
        if !iter(&v)
            return false
        if pred(v) {
            value := v
            return true
        }
    }
}

; =============================================================================
; 4. Mapped Enumerator (Lazy transformation)
; =============================================================================

class MappedIterator {
    __New(source, transform) {
        this.source := source
        this.transform := transform
    }

    __Enum(count) {
        iter := this.source.__Enum(1)
        transform := this.transform

        return (&value) => (
            iter(&v) ? (value := transform(v), true) : false
        )
    }
}

; =============================================================================
; 5. Zip Enumerator (Combine two iterables)
; =============================================================================

class Zip {
    __New(iter1, iter2) {
        this.iter1 := iter1
        this.iter2 := iter2
    }

    __Enum(count) {
        enum1 := this.iter1.__Enum(1)
        enum2 := this.iter2.__Enum(1)

        if count = 1 {
            ; Returns array pairs
            return (&pair) => (
                enum1(&v1) && enum2(&v2)
                    ? (pair := [v1, v2], true)
                : false
            )
        } else {
            ; Returns two values
            return (&v1, &v2) => (
                enum1(&v1) && enum2(&v2)
            )
        }
    }
}

; =============================================================================
; 6. Chain Enumerator (Concatenate iterables)
; =============================================================================

class Chain {
    __New(iterables*) {
        this.iterables := iterables
    }

    __Enum(count) {
        iterables := this.iterables
        currentIdx := 1
        currentEnum := iterables.Length > 0 ? iterables[1].__Enum(1) : ""

        return (&value) => _ChainStep(iterables, currentIdx, currentEnum, value)
    }
}

_ChainStep(iterables, &currentIdx, &currentEnum, &value) {
    loop {
        if currentIdx > iterables.Length
            return false
        if currentEnum(&v) {
            value := v
            return true
        }
        ; Move to next iterable
        currentIdx++
        if currentIdx <= iterables.Length
            currentEnum := iterables[currentIdx].__Enum(1)
    }
}

; =============================================================================
; 7. Tree Traversal Enumerator
; =============================================================================

class TreeNode {
    __New(value, children := []) {
        this.value := value
        this.children := children
    }

    ; Depth-first traversal
    __Enum(count) {
        stack := [this]

        return (&node) => _TreeDFSStep(stack, node)
    }

    ; Breadth-first traversal
    BreadthFirst() => TreeBFSIterator(this)
}

_TreeDFSStep(stack, &node) {
    if stack.Length > 0 {
        node := stack.Pop()
        ; Add children in reverse for correct order
        i := node.children.Length
        while i >= 1 {
            stack.Push(node.children[i])
            i--
        }
        return true
    }
    return false
}

class TreeBFSIterator {
    __New(root) => this.root := root

    __Enum(count) {
        queue := [this.root]

        return (&node) => _TreeBFSStep(queue, node)
    }
}

_TreeBFSStep(queue, &node) {
    if queue.Length > 0 {
        node := queue.RemoveAt(1)
        for child in node.children
            queue.Push(child)
        return true
    }
    return false
}

; =============================================================================
; 8. Sliding Window Enumerator
; =============================================================================

class SlidingWindow {
    __New(source, windowSize) {
        this.source := source is Array ? source : source.ToArray()
        this.windowSize := windowSize
    }

    __Enum(count) {
        arr := this.source
        size := this.windowSize
        idx := 0

        return (&window) => _SlidingWindowStep(arr, size, idx, window)
    }
}

_SlidingWindowStep(arr, size, &idx, &window) {
    if idx + size <= arr.Length {
        window := []
        loop size
            window.Push(arr[idx + A_Index])
        idx++
        return true
    }
    return false
}

; =============================================================================
; 9. Permutation Enumerator
; =============================================================================

class Permutations {
    __New(items) {
        this.items := items
    }

    __Enum(count) {
        items := this.items.Clone()
        n := items.Length
        c := []
        loop n
            c.Push(0)
        i := 1
        first := true

        return (&perm) => _PermutationStep(items, n, c, i, first, perm)
    }

    _swap(arr, i, j) {
        temp := arr[i]
        arr[i] := arr[j]
        arr[j] := temp
    }
}

_PermutationStep(items, n, &c, &i, &first, &perm) {
    if first {
        first := false
        perm := items.Clone()
        return true
    }
    while i <= n {
        if c[i] < i {
            if Mod(i, 2) = 0
                _PermutationSwap(items, 1, i)
            else
                _PermutationSwap(items, c[i] + 1, i)
            c[i]++
            i := 1
            perm := items.Clone()
            return true
        }
        c[i] := 0
        i++
    }
    return false
}

_PermutationSwap(arr, i, j) {
    temp := arr[i]
    arr[i] := arr[j]
    arr[j] := temp
}

; =============================================================================
; 10. Fibonacci Generator
; =============================================================================

class Fibonacci {
    __Enum(count) {
        a := 0, b := 1

        return (&value) => (
            value := a,
            temp := a + b,
            a := b,
            b := temp,
            true  ; Infinite
        )
    }

    Take(n) {
        result := []
        count := 0
        for v in this {
            result.Push(v)
            if ++count >= n
                break
        }
        return result
    }
}

; =============================================================================
; Demo
; =============================================================================

; Range iterator
MsgBox("Range(1, 10, 2):`n" Range(1, 10, 2).ToArray().Join(", "))

; Infinite counter with Take
counter := InfiniteCounter(0, 5)
MsgBox("InfiniteCounter(0, 5).Take(10):`n" counter.Take(10).Join(", "))

; Filtered iterator
evens := FilteredIterator(Range(1, 20), (x) => Mod(x, 2) = 0)
result := []
for v in evens
    result.Push(v)
MsgBox("Filtered (evens 1-20):`n" result.Join(", "))

; Mapped iterator
doubled := MappedIterator(Range(1, 5), (x) => x * 2)
result := []
for v in doubled
    result.Push(v)
MsgBox("Mapped (doubled 1-5):`n" result.Join(", "))

; Zip iterator
names := ["Alice", "Bob", "Charlie"]
ages := [30, 25, 35]
result := []
for name, age in Zip(names, ages)
    result.Push(name ": " age)
MsgBox("Zip:`n" result.Join("`n"))

; Chain iterator
chainIter := Chain([1, 2], [3, 4], [5, 6])
result := []
for v in chainIter
    result.Push(v)
MsgBox("Chain([1,2], [3,4], [5,6]):`n" result.Join(", "))

; Tree traversal
tree := TreeNode("root", [
    TreeNode("A", [TreeNode("A1"), TreeNode("A2")]),
    TreeNode("B", [TreeNode("B1")])
])

dfsResult := []
for node in tree
    dfsResult.Push(node.value)
MsgBox("Tree DFS:`n" dfsResult.Join(" -> "))

bfsResult := []
for node in tree.BreadthFirst()
    bfsResult.Push(node.value)
MsgBox("Tree BFS:`n" bfsResult.Join(" -> "))

; Sliding window
windows := []
for window in SlidingWindow([1, 2, 3, 4, 5], 3)
    windows.Push("[" window.Join(",") "]")
MsgBox("Sliding Window (size 3):`n" windows.Join("`n"))

; Fibonacci
MsgBox("Fibonacci first 15:`n" Fibonacci().Take(15).Join(", "))

; Permutations
perms := []
count := 0
for perm in Permutations(["A", "B", "C"]) {
    perms.Push(perm.Join(""))
    if ++count >= 10  ; Limit display
        break
}
MsgBox("Permutations of [A,B,C]:`n" perms.Join(", "))

; Helper
Array.Prototype.Join := (this, sep := ",") => _ArrayJoinHelper(this, sep)

_ArrayJoinHelper(arr, sep) {
    r := ""
    for i, v in arr
        r .= (i > 1 ? sep : "") v
    return r
}
