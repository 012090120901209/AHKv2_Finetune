#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Array.InsertAt() - Advanced Data Structures
 * ============================================================================
 * 
 * Demonstrates using InsertAt() to implement complex data structures
 * like linked lists, trees, and specialized collections.
 * 
 * @description Advanced data structure implementations
 * @author AutoHotkey v2 Documentation
 * @version 1.0.0
 * @date 2025-01-16
 */

; Example 1: Ordered Set Implementation
Example1_OrderedSet() {
    OutputDebug("=== Example 1: Ordered Set ===`n")

    set := OrderedSet()

    set.Add(5)
    set.Add(2)
    set.Add(8)
    set.Add(2)  ; Duplicate - ignored
    set.Add(1)
    set.Add(5)  ; Duplicate - ignored

    OutputDebug("Set size: " set.Size() "`n")
    OutputDebug("Contains 5: " (set.Contains(5) ? "Yes" : "No") "`n")
    OutputDebug("Contains 3: " (set.Contains(3) ? "Yes" : "No") "`n")
    OutputDebug("Items: " set.ToString() "`n`n")
}

; Example 2: Sorted Map by Value
Example2_SortedMap() {
    OutputDebug("=== Example 2: Sorted Map by Value ===`n")

    sortedMap := SortedMapByValue()

    sortedMap.Add("apple", 3)
    sortedMap.Add("banana", 1)
    sortedMap.Add("cherry", 5)
    sortedMap.Add("date", 2)

    OutputDebug("Sorted map (by value):`n")
    sortedMap.Display()
    OutputDebug("`n")
}

; Example 3: Interval Tree
Example3_IntervalTree() {
    OutputDebug("=== Example 3: Interval Tree ===`n")

    intervals := []

    AddInterval(intervals, 1, 3, "Meeting A")
    AddInterval(intervals, 5, 7, "Meeting B")
    AddInterval(intervals, 2, 4, "Meeting C")
    AddInterval(intervals, 8, 10, "Meeting D")

    OutputDebug("Scheduled intervals:`n")
    ShowIntervals(intervals)

    OutputDebug("`nChecking conflicts:`n")
    if (HasConflict(intervals, 2.5, 3.5))
        OutputDebug("  Conflict found at time 2.5-3.5`n")
    if (!HasConflict(intervals, 7.5, 8.5))
        OutputDebug("  No conflict at time 7.5-8.5`n")

    OutputDebug("`n")
}

; Example 4: Range List
Example4_RangeList() {
    OutputDebug("=== Example 4: Range List ===`n")

    ranges := []

    AddRange(ranges, 10, 20)
    AddRange(ranges, 30, 40)
    AddRange(ranges, 15, 25)
    AddRange(ranges, 35, 45)

    OutputDebug("Ranges:`n")
    ShowRanges(ranges)
    OutputDebug("`n")
}

; Example 5: Skip List Simulation
Example5_SkipList() {
    OutputDebug("=== Example 5: Skip List ===`n")

    skipList := []

    values := [3, 6, 7, 9, 12, 17, 19, 21, 25, 26]

    for value in values
        InsertInSkipList(skipList, value)

    OutputDebug("Skip list values: " FormatArray(skipList) "`n")
    OutputDebug("Search for 12: " (SearchSkipList(skipList, 12) != 0 ? "Found" : "Not found") "`n")
    OutputDebug("Search for 15: " (SearchSkipList(skipList, 15) != 0 ? "Found" : "Not found") "`n")
    OutputDebug("`n")
}

; Example 6: Sparse Array
Example6_SparseArray() {
    OutputDebug("=== Example 6: Sparse Array ===`n")

    sparse := SparseArray()

    sparse.Set(1000, "Value A")
    sparse.Set(5000, "Value B")
    sparse.Set(100, "Value C")
    sparse.Set(10000, "Value D")

    OutputDebug("Sparse array (4 values stored):`n")
    sparse.Display()
    OutputDebug("`nGet value at 5000: " sparse.Get(5000) "`n")
    OutputDebug("Get value at 3000: " sparse.Get(3000) "`n")
    OutputDebug("`n")
}

; Example 7: Multi-Level Cache
Example7_MultiLevelCache() {
    OutputDebug("=== Example 7: Multi-Level Cache ===`n")

    cache := MultiLevelCache(3)

    cache.Put("A", "Value A", 1)
    cache.Put("B", "Value B", 2)
    cache.Put("C", "Value C", 1)
    cache.Put("D", "Value D", 3)

    OutputDebug("Cache structure:`n")
    cache.Display()

    OutputDebug("`nGet 'B': " cache.Get("B") "`n")
    OutputDebug("Get 'X': " cache.Get("X") "`n")
    OutputDebug("`n")
}

; Class Implementations
class OrderedSet {
    items := []

    Add(value) {
        if (this.Contains(value))
            return false

        pos := 1
        for item in this.items {
            if (value < item)
                break
            pos++
        }

        this.items.InsertAt(pos, value)
        return true
    }

    Contains(value) {
        for item in this.items
            if (item = value)
                return true
        return false
    }

    Size() => this.items.Length

    ToString() {
        result := "{"
        for index, value in this.items {
            if (index > 1)
                result .= ", "
            result .= value
        }
        return result "}"
    }
}

class SortedMapByValue {
    entries := []

    Add(key, value) {
        newEntry := { key: key, value: value }
        pos := 1

        for entry in this.entries {
            if (value < entry.value)
                break
            pos++
        }

        this.entries.InsertAt(pos, newEntry)
    }

    Display() {
        for entry in this.entries
            OutputDebug("  " entry.key ": " entry.value "`n")
    }
}

class SparseArray {
    elements := []

    Set(index, value) {
        newElem := { index: index, value: value }
        pos := 1

        for elem in this.elements {
            if (index = elem.index) {
                elem.value := value
                return
            }
            if (index < elem.index)
                break
            pos++
        }

        this.elements.InsertAt(pos, newElem)
    }

    Get(index) {
        for elem in this.elements
            if (elem.index = index)
                return elem.value
        return ""
    }

    Display() {
        for elem in this.elements
            OutputDebug("  [" elem.index "] = " elem.value "`n")
    }
}

class MultiLevelCache {
    levels := []
    maxLevel := 3

    __New(maxLevel := 3) {
        this.maxLevel := maxLevel
        Loop maxLevel
            this.levels.Push([])
    }

    Put(key, value, level) {
        if (level < 1 || level > this.maxLevel)
            return false

        newEntry := { key: key, value: value }
        this.levels[level].InsertAt(1, newEntry)
        return true
    }

    Get(key) {
        for level in this.levels
            for entry in level
                if (entry.key = key)
                    return entry.value
        return ""
    }

    Display() {
        for levelNum, level in this.levels {
            OutputDebug("  Level " levelNum ": " level.Length " items`n")
            for entry in level
                OutputDebug("    " entry.key ": " entry.value "`n")
        }
    }
}

; Helper Functions
AddInterval(intervals, start, end, name) {
    newInterval := { start: start, end: end, name: name }
    pos := 1

    for interval in intervals {
        if (start < interval.start)
            break
        pos++
    }

    intervals.InsertAt(pos, newInterval)
}

ShowIntervals(intervals) {
    for interval in intervals
        OutputDebug("  [" interval.start "-" interval.end "] " interval.name "`n")
}

HasConflict(intervals, start, end) {
    for interval in intervals
        if (!(end <= interval.start || start >= interval.end))
            return true
    return false
}

AddRange(ranges, start, end) {
    newRange := { start: start, end: end }
    pos := 1

    for range in ranges {
        if (start < range.start)
            break
        pos++
    }

    ranges.InsertAt(pos, newRange)
}

ShowRanges(ranges) {
    for range in ranges
        OutputDebug("  [" range.start ", " range.end "]`n")
}

InsertInSkipList(list, value) {
    pos := 1
    for item in list {
        if (value < item)
            break
        pos++
    }
    list.InsertAt(pos, value)
}

SearchSkipList(list, value) {
    for index, item in list
        if (item = value)
            return index
    return 0
}

FormatArray(arr) {
    if (arr.Length = 0)
        return "[]"
    result := "["
    for index, value in arr {
        if (index > 1)
            result .= ", "
        result .= value
    }
    return result "]"
}

Main() {
    OutputDebug("`n" String.Repeat("=", 80) "`n")
    OutputDebug("Array.InsertAt() - Advanced Data Structures`n")
    OutputDebug(String.Repeat("=", 80) "`n`n")

    Example1_OrderedSet()
    Example2_SortedMap()
    Example3_IntervalTree()
    Example4_RangeList()
    Example5_SkipList()
    Example6_SparseArray()
    Example7_MultiLevelCache()

    OutputDebug(String.Repeat("=", 80) "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(String.Repeat("=", 80) "`n")

    MsgBox("Array.InsertAt() data structures examples completed!`nCheck DebugView for output.",
        "Examples Complete", "Icon!")
}

Main()
