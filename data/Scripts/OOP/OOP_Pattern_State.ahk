#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Pattern: State Pattern
; Demonstrates: State machines, behavioral changes, clean state transitions

class TCPConnection {
    __New() => this.state := TCPClosedState(this)

    ChangeState(state) => this.state := state
    Open() => this.state.Open()
    Close() => this.state.Close()
    Send(data) => this.state.Send(data)
}

class TCPState {
    __New(connection) => this.connection := connection
    Open() => MsgBox("Invalid operation in current state", "Error")
    Close() => MsgBox("Invalid operation in current state", "Error")
    Send(data) => MsgBox("Cannot send - not connected", "Error")
}

class TCPClosedState extends TCPState {
    Open() {
        MsgBox("Opening connection...")
        this.connection.ChangeState(TCPOpenState(this.connection))
    }
}

class TCPOpenState extends TCPState {
    Close() {
        MsgBox("Closing connection...")
        this.connection.ChangeState(TCPClosedState(this.connection))
    }

    Send(data) {
        MsgBox("Sending data: " data)
        return true
    }
}

; Usage - clean state-based behavior
conn := TCPConnection()
conn.Send("Test")      ; Error - closed
conn.Open()           ; Opens
conn.Send("Hello!")   ; Success
conn.Close()          ; Closes
conn.Send("Test")     ; Error - closed again
