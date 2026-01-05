#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Mediator Pattern - Reduces chaotic dependencies between objects
; Demonstrates centralized communication through chat room example

class ChatRoom {
    __New() => this.users := Map()

    Register(user) {
        this.users[user.name] := user
        user.room := this
        this.Broadcast(user.name, user.name " joined the chat")
        return this
    }

    Send(from, to, msg) {
        if this.users.Has(to)
            this.users[to].Receive(from, msg)
    }

    Broadcast(from, msg) {
        for name, user in this.users
            if name != from
                user.Receive(from, msg)
    }
}

class ChatUser {
    __New(name) {
        this.name := name
        this.room := ""
        this.messages := []
    }

    Send(to, msg) {
        this.room.Send(this.name, to, msg)
        return this
    }

    Broadcast(msg) {
        this.room.Broadcast(this.name, msg)
        return this
    }

    Receive(from, msg) {
        this.messages.Push("[" from "]: " msg)
        return this
    }

    GetMessages() {
        result := ""
        for msg in this.messages
            result .= msg "`n"
        return result
    }
}

; Demo
room := ChatRoom()
alice := ChatUser("Alice")
bob := ChatUser("Bob")
charlie := ChatUser("Charlie")

room.Register(alice).Register(bob).Register(charlie)

alice.Send("Bob", "Hey Bob!")
bob.Broadcast("Hello everyone!")
charlie.Send("Alice", "Hi Alice, welcome!")

MsgBox("Alice's messages:`n" alice.GetMessages())
MsgBox("Bob's messages:`n" bob.GetMessages())
