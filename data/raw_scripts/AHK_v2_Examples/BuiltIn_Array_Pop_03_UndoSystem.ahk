#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Array.Pop() - Undo/Redo System Implementation
 * ============================================================================
 *
 * This file demonstrates how to implement comprehensive undo/redo systems
 * using Pop() and Push(). These patterns are essential for text editors,
 * graphics programs, and any application requiring action reversibility.
 *
 * @description Undo/Redo system implementations using Array.Pop()
 * @author AutoHotkey v2 Documentation
 * @version 1.0.0
 * @date 2025-01-16
 */

; ============================================================================
; Example 1: Basic Text Editor Undo/Redo
; ============================================================================
; Simple text editing with undo and redo
Example1_TextEditorUndoRedo() {
    OutputDebug("=== Example 1: Text Editor Undo/Redo ===`n")

    editor := TextEditor()

    ; Perform edits
    OutputDebug("Performing edits:`n")
    editor.Type("Hello")
    editor.Type(" World")
    editor.Type("!")
    editor.Delete(1)  ; Remove "!"
    editor.Type("?")

    OutputDebug("`nCurrent text: '" editor.GetText() "'`n")
    OutputDebug("Undo stack: " editor.undoStack.Length " | Redo stack: " editor.redoStack.Length "`n`n")

    ; Undo operations
    OutputDebug("Undoing operations:`n")
    editor.Undo()
    editor.Undo()

    OutputDebug("`nAfter 2 undos: '" editor.GetText() "'`n`n")

    ; Redo operations
    OutputDebug("Redoing operations:`n")
    editor.Redo()

    OutputDebug("`nAfter 1 redo: '" editor.GetText() "'`n")
    OutputDebug("Final undo stack: " editor.undoStack.Length
                " | Redo stack: " editor.redoStack.Length "`n`n")
}

; ============================================================================
; Example 2: Drawing Application Undo/Redo
; ============================================================================
; Track drawing operations
Example2_DrawingUndoRedo() {
    OutputDebug("=== Example 2: Drawing Application ===`n")

    canvas := DrawingCanvas()

    ; Draw shapes
    OutputDebug("Drawing shapes:`n")
    canvas.DrawCircle(100, 100, 50, "Red")
    canvas.DrawRectangle(200, 200, 80, 60, "Blue")
    canvas.DrawLine(50, 50, 150, 150, "Green")
    canvas.DrawCircle(300, 300, 30, "Yellow")

    OutputDebug("`nShapes on canvas: " canvas.shapes.Length "`n")
    canvas.ShowShapes()

    ; Undo last two shapes
    OutputDebug("`nUndoing last 2 shapes:`n")
    canvas.Undo()
    canvas.Undo()

    OutputDebug("`nShapes on canvas: " canvas.shapes.Length "`n")
    canvas.ShowShapes()

    ; Redo one shape
    OutputDebug("`nRedoing 1 shape:`n")
    canvas.Redo()

    OutputDebug("`nFinal shapes: " canvas.shapes.Length "`n")
    canvas.ShowShapes()

    OutputDebug("`n")
}

; ============================================================================
; Example 3: Form Data Undo/Redo
; ============================================================================
; Track form field changes
Example3_FormDataUndoRedo() {
    OutputDebug("=== Example 3: Form Data Undo/Redo ===`n")

    form := FormTracker()

    ; Make changes
    OutputDebug("Making form changes:`n")
    form.SetField("name", "John")
    form.SetField("email", "john@example.com")
    form.SetField("name", "John Doe")  ; Update name
    form.SetField("phone", "555-1234")
    form.SetField("email", "johndoe@example.com")  ; Update email

    OutputDebug("`nCurrent form data:`n")
    form.ShowData()

    OutputDebug("`nChanges in history: " form.undoStack.Length "`n`n")

    ; Undo changes
    OutputDebug("Undoing last 3 changes:`n")
    Loop 3 {
        form.Undo()
    }

    OutputDebug("`nForm data after undo:`n")
    form.ShowData()

    ; Redo changes
    OutputDebug("`nRedoing 2 changes:`n")
    Loop 2 {
        form.Redo()
    }

    OutputDebug("`nFinal form data:`n")
    form.ShowData()

    OutputDebug("`n")
}

; ============================================================================
; Example 4: Configuration Changes Undo/Redo
; ============================================================================
; Track application setting changes
Example4_ConfigUndoRedo() {
    OutputDebug("=== Example 4: Configuration Changes ===`n")

    config := ConfigManager()

    ; Initial settings
    config.Set("theme", "light")
    config.Set("fontSize", 12)
    config.Set("autoSave", true)

    OutputDebug("Initial configuration:`n")
    config.ShowSettings()

    ; Make changes
    OutputDebug("`nChanging settings:`n")
    config.Set("theme", "dark")
    config.Set("fontSize", 14)
    config.Set("fontSize", 16)  ; Change again
    config.Set("language", "en-US")

    OutputDebug("`nCurrent configuration:`n")
    config.ShowSettings()

    ; Undo to previous theme
    OutputDebug("`nUndoing to restore previous theme:`n")
    Loop 4 {
        config.Undo()
        if (config.Get("theme") = "light") {
            break
        }
    }

    OutputDebug("`nConfiguration after undo:`n")
    config.ShowSettings()

    OutputDebug("`n")
}

; ============================================================================
; Example 5: Multi-Level Undo with Groups
; ============================================================================
; Group multiple operations for undo
Example5_GroupedUndoRedo() {
    OutputDebug("=== Example 5: Grouped Undo/Redo ===`n")

    editor := GroupedEditor()

    ; Perform ungrouped operation
    editor.ExecuteAction("Insert", "Hello")

    ; Begin group
    editor.BeginGroup("Format paragraph")
    editor.ExecuteAction("Bold", "Hello")
    editor.ExecuteAction("Italics", "Hello")
    editor.ExecuteAction("Color", "red")
    editor.EndGroup()

    ; Another ungrouped operation
    editor.ExecuteAction("Insert", " World")

    ; Another group
    editor.BeginGroup("Add footer")
    editor.ExecuteAction("NewLine", "")
    editor.ExecuteAction("Insert", "Footer text")
    editor.ExecuteAction("Align", "center")
    editor.EndGroup()

    OutputDebug("Total action groups: " editor.undoStack.Length "`n`n")

    ; Undo one group (undoes all operations in the group)
    OutputDebug("Undoing last group (Add footer):`n")
    editor.Undo()

    OutputDebug("`nRemaining groups: " editor.undoStack.Length "`n`n")

    ; Undo another group
    OutputDebug("Undoing previous group:`n")
    editor.Undo()

    OutputDebug("`nRemaining groups: " editor.undoStack.Length "`n`n")
}

; ============================================================================
; Example 6: Limited Undo History
; ============================================================================
; Implement undo with history limit
Example6_LimitedUndoHistory() {
    OutputDebug("=== Example 6: Limited Undo History ===`n")

    maxHistory := 5
    editor := LimitedUndoEditor(maxHistory)

    OutputDebug("Undo history limit: " maxHistory "`n`n")

    ; Perform many operations
    OutputDebug("Performing operations:`n")
    Loop 10 {
        editor.AddText("Line " A_Index)
        OutputDebug("  Added: Line " A_Index
                    " | History size: " editor.undoStack.Length "`n")
    }

    OutputDebug("`nFinal history size: " editor.undoStack.Length "`n")
    OutputDebug("(Oldest operations removed when limit exceeded)`n`n")

    ; Try to undo all
    OutputDebug("Undoing all available:`n")
    undoCount := 0

    while (editor.CanUndo()) {
        editor.Undo()
        undoCount++
    }

    OutputDebug("Total undos performed: " undoCount "`n")
    OutputDebug("(Maximum of " maxHistory " as expected)`n`n")
}

; ============================================================================
; Example 7: State Snapshot Undo System
; ============================================================================
; Complete state snapshots for undo
Example7_StateSnapshotUndo() {
    OutputDebug("=== Example 7: State Snapshot Undo ===`n")

    app := SnapshotApp()

    ; Create initial state
    app.state.text := "Hello"
    app.state.fontSize := 12
    app.state.color := "black"
    app.SaveSnapshot()

    OutputDebug("Initial state saved`n")
    app.ShowState()

    ; Make changes and save
    app.state.text := "Hello World"
    app.state.fontSize := 14
    app.SaveSnapshot()

    OutputDebug("`nState after edit 1:`n")
    app.ShowState()

    ; More changes
    app.state.text := "Hello AutoHotkey"
    app.state.color := "blue"
    app.SaveSnapshot()

    OutputDebug("`nState after edit 2:`n")
    app.ShowState()

    OutputDebug("`nSnapshots saved: " app.undoStack.Length "`n`n")

    ; Undo to previous state
    OutputDebug("Undoing to previous state:`n")
    app.Undo()
    app.ShowState()

    ; Redo
    OutputDebug("`nRedoing:`n")
    app.Redo()
    app.ShowState()

    OutputDebug("`n")
}

; ============================================================================
; Class Implementations
; ============================================================================

class TextEditor {
    text := ""
    undoStack := []
    redoStack := []

    Type(chars) {
        this.undoStack.Push({action: "type", text: this.text})
        this.text .= chars
        this.redoStack := []
        OutputDebug("  Typed: '" chars "' -> Current: '" this.text "'`n")
    }

    Delete(count) {
        this.undoStack.Push({action: "delete", text: this.text})
        this.text := SubStr(this.text, 1, -count)
        this.redoStack := []
        OutputDebug("  Deleted " count " chars -> Current: '" this.text "'`n")
    }

    Undo() {
        if (this.undoStack.Length = 0) {
            OutputDebug("  Cannot undo - no history`n")
            return
        }

        this.redoStack.Push({action: "redo", text: this.text})
        state := this.undoStack.Pop()
        this.text := state.text
        OutputDebug("  Undo -> Text: '" this.text "'`n")
    }

    Redo() {
        if (this.redoStack.Length = 0) {
            OutputDebug("  Cannot redo - no redo history`n")
            return
        }

        this.undoStack.Push({action: "undo", text: this.text})
        state := this.redoStack.Pop()
        this.text := state.text
        OutputDebug("  Redo -> Text: '" this.text "'`n")
    }

    GetText() => this.text
}

class DrawingCanvas {
    shapes := []
    undoStack := []
    redoStack := []

    DrawCircle(x, y, radius, color) {
        this.AddShape({type: "circle", x: x, y: y, radius: radius, color: color})
    }

    DrawRectangle(x, y, width, height, color) {
        this.AddShape({type: "rectangle", x: x, y: y, width: width, height: height, color: color})
    }

    DrawLine(x1, y1, x2, y2, color) {
        this.AddShape({type: "line", x1: x1, y1: y1, x2: x2, y2: y2, color: color})
    }

    AddShape(shape) {
        this.undoStack.Push(this.shapes.Clone())
        this.shapes.Push(shape)
        this.redoStack := []
        OutputDebug("  Drew " shape.type " (" shape.color ")`n")
    }

    Undo() {
        if (this.undoStack.Length = 0)
            return

        this.redoStack.Push(this.shapes.Clone())
        this.shapes := this.undoStack.Pop()
        OutputDebug("  Undid shape`n")
    }

    Redo() {
        if (this.redoStack.Length = 0)
            return

        this.undoStack.Push(this.shapes.Clone())
        this.shapes := this.redoStack.Pop()
        OutputDebug("  Redid shape`n")
    }

    ShowShapes() {
        for shape in this.shapes {
            OutputDebug("  - " shape.type " (" shape.color ")`n")
        }
    }
}

class FormTracker {
    fields := Map()
    undoStack := []
    redoStack := []

    SetField(name, value) {
        oldValue := this.fields.Has(name) ? this.fields[name] : ""
        this.undoStack.Push({field: name, value: oldValue})
        this.fields[name] := value
        this.redoStack := []
        OutputDebug("  Set " name " = '" value "'`n")
    }

    Undo() {
        if (this.undoStack.Length = 0)
            return

        change := this.undoStack.Pop()
        currentValue := this.fields.Has(change.field) ? this.fields[change.field] : ""
        this.redoStack.Push({field: change.field, value: currentValue})

        if (change.value = "")
            this.fields.Delete(change.field)
        else
            this.fields[change.field] := change.value

        OutputDebug("  Undid change to " change.field "`n")
    }

    Redo() {
        if (this.redoStack.Length = 0)
            return

        change := this.redoStack.Pop()
        oldValue := this.fields.Has(change.field) ? this.fields[change.field] : ""
        this.undoStack.Push({field: change.field, value: oldValue})
        this.fields[change.field] := change.value
        OutputDebug("  Redid change to " change.field "`n")
    }

    ShowData() {
        for name, value in this.fields {
            OutputDebug("  " name ": '" value "'`n")
        }
    }
}

class ConfigManager {
    settings := Map()
    undoStack := []

    Set(key, value) {
        oldValue := this.settings.Has(key) ? this.settings[key] : ""
        this.undoStack.Push({key: key, value: oldValue, exists: this.settings.Has(key)})
        this.settings[key] := value
        OutputDebug("  Set " key " = " value "`n")
    }

    Get(key) => this.settings.Has(key) ? this.settings[key] : ""

    Undo() {
        if (this.undoStack.Length = 0)
            return

        change := this.undoStack.Pop()
        if (change.exists)
            this.settings[change.key] := change.value
        else
            this.settings.Delete(change.key)

        OutputDebug("  Undid " change.key "`n")
    }

    ShowSettings() {
        for key, value in this.settings {
            OutputDebug("  " key ": " value "`n")
        }
    }
}

class GroupedEditor {
    undoStack := []
    redoStack := []
    currentGroup := ""

    BeginGroup(name) {
        this.currentGroup := {name: name, actions: []}
        OutputDebug("Begin group: " name "`n")
    }

    ExecuteAction(action, data) {
        actionObj := {action: action, data: data}

        if (this.currentGroup != "") {
            this.currentGroup.actions.Push(actionObj)
            OutputDebug("  + " action ": " data "`n")
        } else {
            this.undoStack.Push({name: action, actions: [actionObj]})
            OutputDebug("Action: " action ": " data "`n")
        }
    }

    EndGroup() {
        if (this.currentGroup != "") {
            this.undoStack.Push(this.currentGroup)
            this.redoStack := []
            OutputDebug("End group: " this.currentGroup.name
                        " (" this.currentGroup.actions.Length " actions)`n`n")
            this.currentGroup := ""
        }
    }

    Undo() {
        if (this.undoStack.Length = 0)
            return

        group := this.undoStack.Pop()
        this.redoStack.Push(group)
        OutputDebug("  Undid group: " group.name
                    " (" group.actions.Length " actions)`n")
    }
}

class LimitedUndoEditor {
    text := []
    undoStack := []
    maxHistory := 10

    __New(maxHistory := 10) {
        this.maxHistory := maxHistory
    }

    AddText(line) {
        this.undoStack.Push(this.text.Clone())

        ; Limit history size
        if (this.undoStack.Length > this.maxHistory) {
            this.undoStack.RemoveAt(1)
        }

        this.text.Push(line)
    }

    Undo() {
        if (this.undoStack.Length > 0) {
            this.text := this.undoStack.Pop()
            OutputDebug("  Undone`n")
        }
    }

    CanUndo() => this.undoStack.Length > 0
}

class SnapshotApp {
    state := {text: "", fontSize: 12, color: "black"}
    undoStack := []
    redoStack := []

    SaveSnapshot() {
        snapshot := {
            text: this.state.text,
            fontSize: this.state.fontSize,
            color: this.state.color
        }
        this.undoStack.Push(snapshot)
        this.redoStack := []
    }

    Undo() {
        if (this.undoStack.Length = 0)
            return

        this.redoStack.Push({
            text: this.state.text,
            fontSize: this.state.fontSize,
            color: this.state.color
        })

        snapshot := this.undoStack.Pop()
        this.state.text := snapshot.text
        this.state.fontSize := snapshot.fontSize
        this.state.color := snapshot.color
    }

    Redo() {
        if (this.redoStack.Length = 0)
            return

        this.undoStack.Push({
            text: this.state.text,
            fontSize: this.state.fontSize,
            color: this.state.color
        })

        snapshot := this.redoStack.Pop()
        this.state.text := snapshot.text
        this.state.fontSize := snapshot.fontSize
        this.state.color := snapshot.color
    }

    ShowState() {
        OutputDebug("  Text: '" this.state.text "'`n")
        OutputDebug("  Font: " this.state.fontSize "pt`n")
        OutputDebug("  Color: " this.state.color "`n")
    }
}

; ============================================================================
; Main Execution
; ============================================================================

Main() {
    OutputDebug("`n" String.Repeat("=", 80) "`n")
    OutputDebug("Array.Pop() - Undo/Redo System Examples`n")
    OutputDebug(String.Repeat("=", 80) "`n`n")

    Example1_TextEditorUndoRedo()
    Example2_DrawingUndoRedo()
    Example3_FormDataUndoRedo()
    Example4_ConfigUndoRedo()
    Example5_GroupedUndoRedo()
    Example6_LimitedUndoHistory()
    Example7_StateSnapshotUndo()

    OutputDebug(String.Repeat("=", 80) "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(String.Repeat("=", 80) "`n")

    MsgBox("Array.Pop() undo/redo examples completed!`nCheck DebugView for output.",
           "Examples Complete", "Icon!")
}

Main()
