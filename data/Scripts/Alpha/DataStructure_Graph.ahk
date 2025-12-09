#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Graph - Adjacency list representation with BFS/DFS
; Demonstrates graph traversal algorithms

class Graph {
    __New(directed := false) {
        this.adjacency := Map()
        this.directed := directed
    }

    AddVertex(v) {
        if !this.adjacency.Has(v)
            this.adjacency[v] := []
    }

    AddEdge(v1, v2, weight := 1) {
        this.AddVertex(v1)
        this.AddVertex(v2)
        this.adjacency[v1].Push(Map("vertex", v2, "weight", weight))
        if !this.directed
            this.adjacency[v2].Push(Map("vertex", v1, "weight", weight))
    }

    GetNeighbors(v) => this.adjacency.Has(v) ? this.adjacency[v] : []

    ; Breadth-First Search
    BFS(start) {
        visited := Map()
        result := []
        queue := [start]
        visited[start] := true

        while queue.Length {
            vertex := queue.RemoveAt(1)
            result.Push(vertex)

            for edge in this.GetNeighbors(vertex) {
                if !visited.Has(edge["vertex"]) {
                    visited[edge["vertex"]] := true
                    queue.Push(edge["vertex"])
                }
            }
        }
        return result
    }

    ; Depth-First Search
    DFS(start) {
        visited := Map()
        result := []
        this.DFSRecurse(start, visited, result)
        return result
    }

    DFSRecurse(vertex, visited, result) {
        visited[vertex] := true
        result.Push(vertex)

        for edge in this.GetNeighbors(vertex) {
            if !visited.Has(edge["vertex"])
                this.DFSRecurse(edge["vertex"], visited, result)
        }
    }
    
    HasPath(start, end) {
        visited := Map()
        return this.HasPathDFS(start, end, visited)
    }
    
    HasPathDFS(current, end, visited) {
        if current = end
            return true
        
        visited[current] := true
        
        for edge in this.GetNeighbors(current)
            if !visited.Has(edge["vertex"])
                if this.HasPathDFS(edge["vertex"], end, visited)
                    return true
        
        return false
    }
}

; Demo - social network graph
myGraph := Graph()

; Add connections
myGraph.AddEdge("Alice", "Bob")
myGraph.AddEdge("Alice", "Charlie")
myGraph.AddEdge("Bob", "David")
myGraph.AddEdge("Charlie", "David")
myGraph.AddEdge("David", "Eve")

bfs := graph.BFS("Alice")
dfs := graph.DFS("Alice")

result := "BFS from Alice: "
for v in bfs
    result .= v " -> "

result .= "`n`nDFS from Alice: "
for v in dfs
    result .= v " -> "

result .= "`n`nPath Alice to Eve: " graph.HasPath("Alice", "Eve")
result .= "`nPath Alice to Frank: " graph.HasPath("Alice", "Frank")

MsgBox(result)
