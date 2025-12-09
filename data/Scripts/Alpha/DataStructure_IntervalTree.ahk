#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Interval Tree - Range query data structure
; Demonstrates interval-based operations

class Interval {
    __New(low, high, data := "") {
        this.low := low
        this.high := high
        this.data := data
    }

    Overlaps(other) {
        return this.low <= other.high && other.low <= this.high
    }

    Contains(point) {
        return this.low <= point && point <= this.high
    }

    ContainsInterval(other) {
        return this.low <= other.low && other.high <= this.high
    }

    ToString() => "[" this.low ", " this.high "]"
}

class IntervalTree {
    __New() {
        this.intervals := []
    }

    Insert(low, high, data := "") {
        interval := Interval(low, high, data)
        this.intervals.Push(interval)
        return interval
    }

    ; Find all intervals containing a point
    Query(point) {
        results := []
        for interval in this.intervals {
            if interval.Contains(point)
                results.Push(interval)
        }
        return results
    }

    ; Find all intervals overlapping with a range
    QueryRange(low, high) {
        query := Interval(low, high)
        results := []
        
        for interval in this.intervals {
            if interval.Overlaps(query)
                results.Push(interval)
        }
        
        return results
    }

    ; Find all intervals completely contained in range
    QueryContained(low, high) {
        container := Interval(low, high)
        results := []
        
        for interval in this.intervals {
            if container.ContainsInterval(interval)
                results.Push(interval)
        }
        
        return results
    }

    Remove(interval) {
        for i, int in this.intervals {
            if int = interval {
                this.intervals.RemoveAt(i)
                return true
            }
        }
        return false
    }

    Count() => this.intervals.Length

    All() => this.intervals.Clone()
}

; Demo - Basic interval queries
tree := IntervalTree()

; Insert meeting schedule
tree.Insert(9, 10, "Morning standup")
tree.Insert(10, 12, "Development work")
tree.Insert(12, 13, "Lunch")
tree.Insert(14, 15, "Code review")
tree.Insert(14, 16, "Planning meeting")
tree.Insert(16, 17, "Wrap up")

result := "Interval Tree Demo - Meeting Schedule:`n`n"
result .= "All intervals:`n"
for int in tree.All()
    result .= Format("  {} - {}`n", int.ToString(), int.data)

result .= "`n"

; Query point
queryPoint := 14
matches := tree.Query(queryPoint)
result .= "What's happening at " queryPoint ":00?`n"
for int in matches
    result .= "  " int.data "`n"

result .= "`n"

; Query range
queryLow := 9
queryHigh := 13
overlapping := tree.QueryRange(queryLow, queryHigh)
result .= Format("Overlapping [{}, {}]:`n", queryLow, queryHigh)
for int in overlapping
    result .= "  " int.data "`n"

MsgBox(result)

; Demo - IP Range lookup (simplified)
ipRanges := IntervalTree()

; Simplified IP ranges as integers
ipRanges.Insert(167772160, 167772415, "Office Network (10.0.0.0/24)")
ipRanges.Insert(192168000, 192168255, "Home Network (192.168.0.0/24)")
ipRanges.Insert(172160000, 172319999, "Private Range (172.16-31.x.x)")

; Query an "IP"
queryIP := 192168100
matches := ipRanges.Query(queryIP)

result := "IP Range Lookup Demo:`n`n"
result .= "Query: " queryIP " (192.168.1.100 equivalent)`n`n"
result .= "Matches:`n"
for match in matches
    result .= "  " match.data "`n"

MsgBox(result)

; Demo - Timeline events with conflicts
timeline := IntervalTree()

events := [
    Map("start", 0, "end", 3, "name", "Event A"),
    Map("start", 2, "end", 5, "name", "Event B"),
    Map("start", 6, "end", 8, "name", "Event C"),
    Map("start", 4, "end", 7, "name", "Event D"),
    Map("start", 9, "end", 10, "name", "Event E")
]

for evt in events
    timeline.Insert(evt["start"], evt["end"], evt["name"])

; Find conflicts
result := "Timeline Conflict Detection:`n`n"
result .= "Events:`n"
for evt in events
    result .= Format("  {} [{}-{}]`n", evt["name"], evt["start"], evt["end"])

result .= "`nConflicts:`n"

for i, evt in events {
    ; Find overlapping events
    conflicts := timeline.QueryRange(evt["start"], evt["end"])
    
    ; Filter out self
    conflicting := []
    for c in conflicts {
        if c.data != evt["name"]
            conflicting.Push(c.data)
    }
    
    if conflicting.Length {
        result .= "  " evt["name"] " conflicts with: "
        for j, name in conflicting
            result .= (j > 1 ? ", " : "") name
        result .= "`n"
    }
}

MsgBox(result)
