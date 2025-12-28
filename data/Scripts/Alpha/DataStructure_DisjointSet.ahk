#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Disjoint Set (Union-Find) - Connected components
; Demonstrates path compression and union by rank

class DisjointSet {
    __New(n := 0) {
        this.parent := Map()
        this.rank := Map()
        this.count := 0

        if n > 0 {
            Loop n
                this.MakeSet(A_Index)
        }
    }

    MakeSet(x) {
        if !this.parent.Has(x) {
            this.parent[x] := x
            this.rank[x] := 0
            this.count++
        }
        return this
    }

    Find(x) {
        if !this.parent.Has(x)
            return ""

        ; Path compression
        if this.parent[x] != x
            this.parent[x] := this.Find(this.parent[x])

        return this.parent[x]
    }

    Union(x, y) {
        rootX := this.Find(x)
        rootY := this.Find(y)

        if rootX = "" || rootY = "" || rootX = rootY
            return false

        ; Union by rank
        if this.rank[rootX] < this.rank[rootY]
            this.parent[rootX] := rootY
        else if this.rank[rootX] > this.rank[rootY]
            this.parent[rootY] := rootX
        else {
            this.parent[rootY] := rootX
            this.rank[rootX]++
        }

        this.count--
        return true
    }

    Connected(x, y) {
        rootX := this.Find(x)
        rootY := this.Find(y)
        return rootX != "" && rootY != "" && rootX = rootY
    }

    GetComponentCount() => this.count

    GetComponents() {
        components := Map()
        for element, _ in this.parent {
            root := this.Find(element)
            if !components.Has(root)
                components[root] := []
            components[root].Push(element)
        }
        return components
    }
}

; Demo - Graph connectivity
ds := DisjointSet()

; Add nodes
Loop 10
    ds.MakeSet(A_Index)

; Connect some nodes (edges)
edges := [[1, 2], [2, 3], [4, 5], [6, 7], [7, 8], [8, 9], [1, 4]]

result := "Adding edges:`n"
for edge in edges {
    ds.Union(edge[1], edge[2])
    result .= edge[1] " -- " edge[2] "`n"
}

result .= "`nComponent count: " ds.GetComponentCount()

result .= "`n`nConnectivity:`n"
result .= "1-3 connected? " ds.Connected(1, 3) "`n"
result .= "1-5 connected? " ds.Connected(1, 5) "`n"
result .= "1-6 connected? " ds.Connected(1, 6) "`n"

MsgBox(result)

; Show all components
components := ds.GetComponents()
result := "Components:`n"
for root, members in components {
    result .= "Root " root ": {"
    for i, member in members
        result .= (i > 1 ? ", " : "") member
    result .= "}`n"
}

MsgBox(result)

; Use case: Friend groups
friends := DisjointSet()
people := ["Alice", "Bob", "Charlie", "Diana", "Eve", "Frank"]

for person in people
    friends.MakeSet(person)

; Friendships
friends.Union("Alice", "Bob")
friends.Union("Bob", "Charlie")
friends.Union("Diana", "Eve")

result := "Friend groups:`n"
for root, group in friends.GetComponents() {
    result .= "Group: "
    for i, person in group
        result .= (i > 1 ? ", " : "") person
    result .= "`n"
}

MsgBox(result)
