#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Snapshot/Restore - Object state capture
; Demonstrates memento pattern with serialization

class Snapshot {
    ; Create snapshot of object state
    static Create(obj, options := "") {
        depth := options.Has("depth") ? options["depth"] : 10

        return Map(
            "data", this._serialize(obj, depth),
            "timestamp", A_TickCount,
            "date", FormatTime(, "yyyy-MM-dd HH:mm:ss")
        )
    }

    static _serialize(value, depth, seen := "") {
        if depth <= 0
            return "[max depth]"

        if !seen
            seen := Map()

        ; Primitive types
        if !IsObject(value)
            return value

        ; Circular reference check
        if seen.Has(ObjPtr(value))
            return "[circular]"
        seen[ObjPtr(value)] := true

        ; Array
        if value is Array {
            result := []
            for item in value
                result.Push(this._serialize(item, depth - 1, seen))
            return result
        }

        ; Map
        if value is Map {
            result := Map("__type__", "Map")
            for k, v in value
                result[k] := this._serialize(v, depth - 1, seen)
            return result
        }

        ; Object with properties
        result := Map("__type__", "Object")
        for prop in value.OwnProps()
            result[prop] := this._serialize(value.%prop%, depth - 1, seen)

        return result
    }

    ; Restore object from snapshot
    static Restore(snapshot) {
        return this._deserialize(snapshot["data"])
    }

    static _deserialize(value) {
        if !IsObject(value)
            return value

        if value is Array {
            result := []
            for item in value
                result.Push(this._deserialize(item))
            return result
        }

        ; Check type marker
        if value is Map && value.Has("__type__") {
            typ := value["__type__"]

            if typ = "Map" {
                result := Map()
                for k, v in value
                    if k != "__type__"
                        result[k] := this._deserialize(v)
                return result
            }

            if typ = "Object" {
                result := {}
                for k, v in value
                    if k != "__type__"
                        result.%k% := this._deserialize(v)
                return result
            }
        }

        return value
    }

    ; Compare two snapshots
    static Diff(snap1, snap2) {
        return this._diffValues(snap1["data"], snap2["data"], "root")
    }

    static _diffValues(v1, v2, path) {
        diffs := []

        ; Type mismatch
        if Type(v1) != Type(v2) {
            diffs.Push(Map("path", path, "type", "type_change", "old", v1, "new", v2))
            return diffs
        }

        ; Primitive comparison
        if !IsObject(v1) {
            if v1 != v2
                diffs.Push(Map("path", path, "type", "value_change", "old", v1, "new", v2))
            return diffs
        }

        ; Array comparison
        if v1 is Array && v2 is Array {
            maxLen := Max(v1.Length, v2.Length)
            Loop maxLen {
                idx := A_Index
                if idx > v1.Length
                    diffs.Push(Map("path", path "[" idx "]", "type", "added", "value", v2[idx]))
                else if idx > v2.Length
                    diffs.Push(Map("path", path "[" idx "]", "type", "removed", "value", v1[idx]))
                else
                    diffs.Push(this._diffValues(v1[idx], v2[idx], path "[" idx "]")*)
            }
            return diffs
        }

        ; Map/Object comparison
        if v1 is Map && v2 is Map {
            keys := Map()
            for k, _ in v1
                keys[k] := true
            for k, _ in v2
                keys[k] := true

            for k, _ in keys {
                if k = "__type__"
                    continue

                has1 := v1.Has(k)
                has2 := v2.Has(k)

                if has1 && !has2
                    diffs.Push(Map("path", path "." k, "type", "removed", "value", v1[k]))
                else if !has1 && has2
                    diffs.Push(Map("path", path "." k, "type", "added", "value", v2[k]))
                else
                    diffs.Push(this._diffValues(v1[k], v2[k], path "." k)*)
            }
        }

        return diffs
    }
}

; Snapshot manager for undo/redo
class SnapshotManager {
    __New(maxSnapshots := 50) {
        this.history := []
        this.redoStack := []
        this.maxSnapshots := maxSnapshots
    }

    Save(obj, description := "") {
        snap := Snapshot.Create(obj)
        snap["description"] := description

        this.history.Push(snap)
        this.redoStack := []  ; Clear redo on new save

        ; Limit history size
        while this.history.Length > this.maxSnapshots
            this.history.RemoveAt(1)

        return snap
    }

    Undo() {
        if this.history.Length < 2
            return ""

        current := this.history.Pop()
        this.redoStack.Push(current)

        return Snapshot.Restore(this.history[this.history.Length])
    }

    Redo() {
        if !this.redoStack.Length
            return ""

        snap := this.redoStack.Pop()
        this.history.Push(snap)

        return Snapshot.Restore(snap)
    }

    CanUndo() => this.history.Length > 1
    CanRedo() => this.redoStack.Length > 0

    GetHistory() {
        result := []
        for snap in this.history
            result.Push(Map(
                "description", snap["description"],
                "date", snap["date"]
            ))
        return result
    }
}

; Demo object
class Document {
    __New() {
        this.title := ""
        this.content := ""
        this.metadata := Map()
    }
}

; Demo
doc := Document()
doc.title := "My Document"
doc.content := "Hello, World!"
doc.metadata := Map("author", "Alice", "version", 1)

; Create snapshot
snap1 := Snapshot.Create(doc)

result := "Snapshot 1:`n"
result .= "  Date: " snap1["date"] "`n"
result .= "  Title: " snap1["data"]["title"] "`n`n"

; Modify document
doc.title := "Updated Document"
doc.content := "Modified content"
doc.metadata["version"] := 2

snap2 := Snapshot.Create(doc)

result .= "Snapshot 2:`n"
result .= "  Title: " snap2["data"]["title"] "`n`n"

; Compare snapshots
diffs := Snapshot.Diff(snap1, snap2)
result .= "Differences:`n"
for diff in diffs
    result .= "  " diff["path"] " [" diff["type"] "]: "
        . (diff.Has("old") ? diff["old"] : "") " -> "
        . (diff.Has("new") ? diff["new"] : (diff.Has("value") ? diff["value"] : "")) "`n"

MsgBox(result)

; Demo - Undo/Redo
manager := SnapshotManager()

doc2 := Document()
doc2.title := "Version 1"
manager.Save(doc2, "Initial")

doc2.title := "Version 2"
manager.Save(doc2, "Second edit")

doc2.title := "Version 3"
manager.Save(doc2, "Third edit")

result := "Undo/Redo Demo:`n"
result .= "Current: " doc2.title "`n`n"

restored := manager.Undo()
result .= "After Undo: " restored.title "`n"

restored := manager.Undo()
result .= "After Undo: " restored.title "`n"

restored := manager.Redo()
result .= "After Redo: " restored.title "`n"

MsgBox(result)
