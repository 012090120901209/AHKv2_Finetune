#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Data Structure: Graph (Adjacency List)
; Demonstrates: Vertices, edges, DFS, BFS, paths

class Graph {
    __New(directed := false) => (this.adjacencyList := Map(), this.directed := directed)

    AddVertex(vertex) {
        if (!this.adjacencyList.Has(vertex))
        this.adjacencyList[vertex] := []
        return this
    }

    AddEdge(v1, v2, weight := 1) {
        if (!this.adjacencyList.Has(v1))
        this.AddVertex(v1)
        if (!this.adjacencyList.Has(v2))
        this.AddVertex(v2)

        this.adjacencyList[v1].Push({vertex: v2, weight: weight})

        if (!this.directed)
        this.adjacencyList[v2].Push({vertex: v1, weight: weight})

        return this
    }

    GetNeighbors(vertex) => this.adjacencyList.Has(vertex) ? this.adjacencyList[vertex] : []

    DFS(start) {
        visited := Map()
        result := []
        this._DFSHelper(start, visited, result)
        return result
    }

    _DFSHelper(vertex, visited, result) {
        if (!this.adjacencyList.Has(vertex) || visited.Has(vertex))
        return

        visited[vertex] := true
        result.Push(vertex)

        for edge in this.adjacencyList[vertex]
        this._DFSHelper(edge.vertex, visited, result)
    }

    BFS(start) {
        if (!this.adjacencyList.Has(start))
        return []

        visited := Map()
        queue := [start]
        result := []

        visited[start] := true

        while (queue.Length > 0) {
            vertex := queue.RemoveAt(1)
            result.Push(vertex)

            for edge in this.adjacencyList[vertex] {
                if (!visited.Has(edge.vertex)) {
                    visited[edge.vertex] := true
                    queue.Push(edge.vertex)
                }
            }
        }

        return result
    }

    HasPath(start, end) {
        if (!this.adjacencyList.Has(start) || !this.adjacencyList.Has(end))
        return false

        visited := Map()
        return this._HasPathDFS(start, end, visited)
    }

    _HasPathDFS(current, end, visited) {
        if (current = end)
        return true

        if (visited.Has(current))
        return false

        visited[current] := true

        for edge in this.adjacencyList[current]
        if (this._HasPathDFS(edge.vertex, end, visited))
        return true

        return false
    }

    FindShortestPath(start, end) {
        if (!this.adjacencyList.Has(start) || !this.adjacencyList.Has(end))
        return []

        visited := Map()
        queue := [{vertex: start, path: [start]}]
        visited[start] := true

        while (queue.Length > 0) {
            current := queue.RemoveAt(1)

            if (current.vertex = end)
            return current.path

            for edge in this.adjacencyList[current.vertex] {
                if (!visited.Has(edge.vertex)) {
                    visited[edge.vertex] := true
                    newPath := current.path.Clone()
                    newPath.Push(edge.vertex)
                    queue.Push({vertex: edge.vertex, path: newPath})
                }
            }
        }

        return []
    }

    GetVertexCount() => this.adjacencyList.Count

    GetEdgeCount() {
        count := 0
        for vertex, edges in this.adjacencyList
        count += edges.Length
        return this.directed ? count : count // 2
    }

    ToString() {
        str := (this.directed ? "Directed" : "Undirected") . " Graph:`n"
        for vertex, edges in this.adjacencyList {
            str .= vertex . " -> "
            edgeStrs := []
            for edge in edges
            edgeStrs.Push(edge.vertex . "(" . edge.weight . ")")
            str .= edgeStrs.Join(", ") . "`n"
        }
        return str
    }
}

; Usage - Undirected graph
graph := Graph()

; Add edges (creates vertices automatically)
graph.AddEdge("A", "B").AddEdge("A", "C").AddEdge("B", "D")
.AddEdge("C", "D").AddEdge("D", "E").AddEdge("E", "F")

MsgBox(graph.ToString())

; Traversals
MsgBox("DFS from A: " . graph.DFS("A").Join(" -> "))
MsgBox("BFS from A: " . graph.BFS("A").Join(" -> "))

; Path finding
MsgBox("Has path A to F? " . (graph.HasPath("A", "F") ? "Yes" : "No"))
path := graph.FindShortestPath("A", "F")
MsgBox("Shortest path A to F: " . path.Join(" -> "))

; Directed graph example
dirGraph := Graph(true)
dirGraph.AddEdge("Start", "A").AddEdge("Start", "B")
.AddEdge("A", "C").AddEdge("B", "C")
.AddEdge("C", "End").AddEdge("B", "End")

MsgBox(dirGraph.ToString())
MsgBox("Shortest path Start to End: " . dirGraph.FindShortestPath("Start", "End").Join(" -> "))
