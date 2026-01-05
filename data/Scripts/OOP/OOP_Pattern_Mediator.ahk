#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Pattern: Mediator Pattern
; Demonstrates: Decoupled communication, central control point

class Mediator {
    Notify(sender, event) => throw Error("Must implement Notify()")
}

class ChatMediator extends Mediator {
    __New() => this.users := []
    AddUser(user) => (this.users.Push(user), user.SetMediator(this))

    Notify(sender, event) {
        if (event = "message") {
            for user in this.users {
                if (user !== sender)
                    user.Receive(sender.name ": " sender.GetLastMessage())
            }
        }
    }
}

class User {
    __New(name) => (this.name := name, this.messages := [])

    SetMediator(mediator) => this.mediatorobj := mediator

    Send(message) {
        this.messages.Push(message)
        this.mediatorobj .Notify(this, "message")
    }

    Receive(message) => MsgBox(this.name " received: " message)
    GetLastMessage() => this.messages[this.messages.Length]
}

; Usage - users communicate through mediator
mediatorobj := ChatMediator()

alice := User("Alice")
bob := User("Bob")
charlie := User("Charlie")

mediatorobj .AddUser(alice)
mediatorobj .AddUser(bob)
mediatorobj .AddUser(charlie)

alice.Send("Hello everyone!")
bob.Send("Hi Alice!")
