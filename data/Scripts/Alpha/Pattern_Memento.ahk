#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Memento Pattern - Captures and restores object's internal state
; Demonstrates undo functionality with state snapshots

class Editor {
    __New() => this.content := ""

    Type(text) {
        this.content .= text
        return this
    }
    
    Clear() {
        this.content := ""
        return this
    }

    Save() => Memento(this.content)
    
    Restore(memento) {
        this.content := memento.state
        return this
    }
    
    GetContent() => this.content
}

class Memento {
    __New(state) {
        this.state := state
        this.timestamp := A_Now
    }
}

class History {
    __New() => this.snapshots := []

    Push(memento) {
        this.snapshots.Push(memento)
        return this
    }

    Pop() {
        if this.snapshots.Length
            return this.snapshots.Pop()
        return ""
    }
    
    Count() => this.snapshots.Length
}

; Demo
myEditor := Editor()
editHistory := History()

; Make edits with snapshots
editHistory.Push(myEditor.Save())
myEditor.Type("Hello ")

editHistory.Push(myEditor.Save())
myEditor.Type("World! ")

editHistory.Push(myEditor.Save())
myEditor.Type("How are you?")

MsgBox("Current: " myEditor.GetContent())

; Undo steps
myEditor.Restore(editHistory.Pop())
MsgBox("After undo 1: " myEditor.GetContent())

myEditor.Restore(editHistory.Pop())
MsgBox("After undo 2: " myEditor.GetContent())
