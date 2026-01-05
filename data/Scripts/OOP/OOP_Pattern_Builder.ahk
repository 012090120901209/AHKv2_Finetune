#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Pattern: Builder Pattern with Fluent Interface
; Demonstrates: Method chaining, builder pattern, immutability options

class PersonBuilder {
    __New() => (this.personobj := { name: "", age: 0, email: "", phone: "", address: "" })

    WithName(name) => (this.personobj .name := name, this)
    WithAge(age) => (this.personobj .age := age, this)
    WithEmail(email) => (this.personobj .email := email, this)
    WithPhone(phone) => (this.personobj .phone := phone, this)
    WithAddress(address) => (this.personobj .address := address, this)

    Build() => Person(this.person*)
}

class Person {
    __New(data) {
        for key, value in data.OwnProps()
            this.%key% := value
    }

    ToString() => Format("Person[name={}, age={}, email={}]", this.name, this.age, this.email)
    Greet() => MsgBox("Hello, I'm " this.name " and I'm " this.age " years old!")
}

; Usage with beautiful chaining
personobj := PersonBuilder()
    .WithName("Alice Johnson")
    .WithAge(28)
    .WithEmail("alice@example.com")
    .WithPhone("555-0123")
    .WithAddress("123 Main St")
    .Build()

personobj .Greet()
MsgBox(personobj .ToString())
