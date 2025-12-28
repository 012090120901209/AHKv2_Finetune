#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Command Pattern - Encapsulates requests as objects
; Demonstrates undo/redo functionality with command history

class CommandInvoker {
    __New() => this.history := []

    Execute(cmd) {
        cmd.Execute()
        this.history.Push(cmd)
    }

    Undo() {
        if this.history.Length
            this.history.Pop().Undo()
    }

    UndoAll() {
        while this.history.Length
            this.Undo()
    }
}

class AddCommand {
    __New(receiver, value) {
        this.receiver := receiver
        this.value := value
    }
    Execute() => this.receiver.total += this.value
    Undo() => this.receiver.total -= this.value
}

class MultiplyCommand {
    __New(receiver, value) {
        this.receiver := receiver
        this.value := value
        this.previous := 0
    }
    Execute() {
        this.previous := this.receiver.total
        this.receiver.total *= this.value
    }
    Undo() => this.receiver.total := this.previous
}

; Demo
calc := { total: 10 }
invoker := CommandInvoker()

invoker.Execute(AddCommand(calc, 5))      ; 15
invoker.Execute(MultiplyCommand(calc, 2)) ; 30
MsgBox("After operations: " calc.total)

invoker.Undo()  ; 15
invoker.Undo()  ; 10
MsgBox("After undo all: " calc.total)
