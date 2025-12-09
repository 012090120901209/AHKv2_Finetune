#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Pattern: Memento Pattern
; Demonstrates: State saving/restoration, undo functionality, snapshots

class TextEditorMemento {
    __New(content, cursor) => (this.content := content, this.cursor := cursor)
    GetContent() => this.content
    GetCursor() => this.cursor
}

class TextEditor {
    __New() => (this.content := "", this.cursor := 0)

    Type(text) => (this.content .= text, this.cursor += StrLen(text))
    DeleteChar() => (this.content := SubStr(this.content, 1, -1), this.cursor := Max(0, this.cursor - 1))

    Save() => TextEditorMemento(this.content, this.cursor)
    Restore(memento) => (this.content := memento.GetContent(), this.cursor := memento.GetCursor())

    Display() => MsgBox("Content: " this.content "`nCursor: " this.cursor)
}

class History {
    __New() => this.states := []
    Save(memento) => this.states.Push(memento)
    Undo() => this.states.Length > 0 ? this.states.Pop() : ""
}

; Usage
editor := TextEditor()
history := History()

editor.Type("Hello ")
history.Save(editor.Save())

editor.Type("World!")
history.Save(editor.Save())

editor.Display()

; Undo
saved := history.Undo()
if (saved) {
    editor.Restore(saved)
    editor.Display()
}
