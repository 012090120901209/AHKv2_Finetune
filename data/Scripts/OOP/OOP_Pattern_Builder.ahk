#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Pattern: Builder Pattern with Fluent Interface
; Demonstrates: Method chaining, builder pattern, immutability options

class PersonBuilder {
    __New() => (this.person := { name: "", age: 0, email: "", phone: "", address: "" })

    WithName(name) => (this.person.name := name, this)
    WithAge(age) => (this.person.age := age, this)
    WithEmail(email) => (this.person.email := email, this)
    WithPhone(phone) => (this.person.phone := phone, this)
    WithAddress(address) => (this.person.address := address, this)

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
person := PersonBuilder()
    .WithName("Alice Johnson")
    .WithAge(28)
    .WithEmail("alice@example.com")
    .WithPhone("555-0123")
    .WithAddress("123 Main St")
    .Build()

person.Greet()
MsgBox(person.ToString())
