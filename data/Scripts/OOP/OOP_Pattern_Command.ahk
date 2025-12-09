#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Pattern: Command Pattern with Undo/Redo
; Demonstrates: Command objects, undo stack, encapsulation

class Command {
    Execute() => throw Error("Must implement Execute()")
    Undo() => throw Error("Must implement Undo()")
}

class TextEditor {
    __New() => (this.text := "", this.history := [], this.redoStack := [])

    GetText() => this.text

    ExecuteCommand(cmd) {
        cmd.Execute()
        this.history.Push(cmd)
        this.redoStack := []
    }

    Undo() {
        if (this.history.Length > 0) {
            cmd := this.history.Pop()
            cmd.Undo()
            this.redoStack.Push(cmd)
        }
    }

    Redo() {
        if (this.redoStack.Length > 0) {
            cmd := this.redoStack.Pop()
            cmd.Execute()
            this.history.Push(cmd)
        }
    }
}

class InsertTextCommand extends Command {
    __New(editor, text) => (this.editor := editor, this.textToInsert := text, this.previousText := "")
    Execute() => (this.previousText := this.editor.text, this.editor.text .= this.textToInsert)
    Undo() => this.editor.text := this.previousText
}

class DeleteTextCommand extends Command {
    __New(editor, count) => (this.editor := editor, this.count := count, this.deletedText := "")
    Execute() => (this.deletedText := SubStr(this.editor.text, -(this.count-1)), this.editor.text := SubStr(this.editor.text, 1, StrLen(this.editor.text) - this.count))
    Undo() => this.editor.text .= this.deletedText
}

; Usage
editor := TextEditor()
editor.ExecuteCommand(InsertTextCommand(editor, "Hello "))
editor.ExecuteCommand(InsertTextCommand(editor, "World!"))
MsgBox("Text: " editor.GetText())

editor.Undo()
MsgBox("After undo: " editor.GetText())

editor.Redo()
MsgBox("After redo: " editor.GetText())
