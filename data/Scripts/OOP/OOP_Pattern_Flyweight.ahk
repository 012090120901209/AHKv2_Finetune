#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Pattern: Flyweight Pattern
; Demonstrates: Object sharing, memory optimization, intrinsic/extrinsic state

class TreeType {
    __New(name, color, texture) => (this.name := name, this.color := color, this.texture := texture)
    Draw(x, y) => MsgBox(Format("Drawing {} tree at ({}, {}) with color {} ", this.name, x, y, this.color))
}

class TreeFactory {
    static types := Map()

    static GetTreeType(name, color, texture) {
        key := name . color . texture
        if (!this.types.Has(key))
        this.types[key] := TreeType(name, color, texture)
        return this.types[key]
    }

    static GetTypeCount() => this.types.Count
}

class Tree {
    __New(x, y, type) => (this.x := x, this.y := y, this.type := type)
    Draw() => this.type.Draw(this.x, this.y)
}

class Forest {
    __New() => this.trees := []

    PlantTree(x, y, name, color, texture) {
        type := TreeFactory.GetTreeType(name, color, texture)
        tree := Tree(x, y, type)
        this.trees.Push(tree)
        return this
    }

    Draw() {
        for tree in this.trees
        tree.Draw()
        MsgBox(Format("Memory: {} unique tree types for {} trees", TreeFactory.GetTypeCount(), this.trees.Length))
    }
}

; Usage - memory efficient with thousands of trees
forest := Forest()
.PlantTree(10, 20, "Oak", "Green", "Rough")
.PlantTree(30, 40, "Pine", "DarkGreen", "Smooth")
.PlantTree(50, 60, "Oak", "Green", "Rough")  ; Reuses first type
.PlantTree(70, 80, "Pine", "DarkGreen", "Smooth")  ; Reuses second type

forest.Draw()
