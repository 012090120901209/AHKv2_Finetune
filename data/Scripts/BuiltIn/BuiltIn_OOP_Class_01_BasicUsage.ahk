#Requires AutoHotkey v2.0

/**
 * BuiltIn_OOP_Class_01_BasicUsage.ahk
 * 
 * DESCRIPTION:
 * Demonstrates the fundamental concepts of creating and using classes in AutoHotkey v2.
 * This file covers basic class definition, instantiation, and simple usage patterns.
 * 
 * FEATURES:
 * - Basic class definition syntax
 * - Object instantiation
 * - Instance methods and properties
 * - Simple member access
 * - Multiple instances
 * - Value types vs reference types
 * - Class-based organization
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - Objects
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Class keyword with modern syntax
 * - Constructor methods (__New)
 * - Instance property access (this.property)
 * - Method definition without function keyword
 * - Reference-based object handling
 * - Built-in Object type
 * 
 * LEARNING POINTS:
 * 1. Classes are blueprints for creating objects
 * 2. Objects are instances of classes
 * 3. Each instance has its own property values
 * 4. Methods are functions defined within a class
 * 5. The 'this' keyword refers to the current instance
 * 6. Classes help organize related data and behavior
 * 7. Objects are passed by reference, not by value
 */

; ========================================
; EXAMPLE 1: Simple Class Definition
; ========================================
; The most basic class with properties and a method

class Person {
    ; Properties are defined by assigning to them
    Name := ""
    Age := 0

    ; Constructor - runs when object is created
    __New(name, age) {
        this.Name := name
        this.Age := age
    }

    ; Method to display information
    Introduce() {
        return "Hi, I'm " this.Name " and I'm " this.Age " years old."
    }
}

; Create instances of the Person class
person1 := Person("Alice", 30)
person2 := Person("Bob", 25)

; Use the instances
MsgBox(person1.Introduce())  ; "Hi, I'm Alice and I'm 30 years old."
MsgBox(person2.Introduce())  ; "Hi, I'm Bob and I'm 25 years old."

; Access properties directly
MsgBox("Person 1 name: " person1.Name)  ; "Person 1 name: Alice"
MsgBox("Person 2 age: " person2.Age)    ; "Person 2 age: 25"

; ========================================
; EXAMPLE 2: Class Without Constructor
; ========================================
; Classes don't require a constructor - properties can be set after creation

class Rectangle {
    Width := 0
    Height := 0

    Area() {
        return this.Width * this.Height
    }

    Perimeter() {
        return 2 * (this.Width + this.Height)
    }

    IsSquare() {
        return this.Width = this.Height
    }
}

; Create instance and set properties
rect := Rectangle()
rect.Width := 10
rect.Height := 5

MsgBox("Rectangle Area: " rect.Area())           ; "Rectangle Area: 50"
MsgBox("Rectangle Perimeter: " rect.Perimeter()) ; "Rectangle Perimeter: 30"
MsgBox("Is Square? " rect.IsSquare())            ; "Is Square? 0" (false)

; Create a square
square := Rectangle()
square.Width := 7
square.Height := 7
MsgBox("Is Square? " square.IsSquare())          ; "Is Square? 1" (true)

; ========================================
; EXAMPLE 3: Class with Multiple Methods
; ========================================
; A BankAccount class demonstrating multiple related methods

class BankAccount {
    AccountNumber := ""
    HolderName := ""
    Balance := 0

    __New(accountNum, holderName, initialBalance := 0) {
        this.AccountNumber := accountNum
        this.HolderName := holderName
        this.Balance := initialBalance
    }

    Deposit(amount) {
        if (amount <= 0) {
            return "Invalid deposit amount"
        }
        this.Balance += amount
        return "Deposited: $" amount ". New balance: $" this.Balance
    }

    Withdraw(amount) {
        if (amount <= 0) {
            return "Invalid withdrawal amount"
        }
        if (amount > this.Balance) {
            return "Insufficient funds"
        }
        this.Balance -= amount
        return "Withdrew: $" amount ". New balance: $" this.Balance
    }

    GetBalance() {
        return "$" this.Balance
    }

    GetStatement() {
        statement := "=== Bank Statement ===`n"
        statement .= "Account: " this.AccountNumber "`n"
        statement .= "Holder: " this.HolderName "`n"
        statement .= "Balance: $" this.Balance "`n"
        statement .= "====================="
        return statement
    }
}

; Create and use a bank account
account := BankAccount("ACC001", "John Doe", 1000)
MsgBox(account.GetStatement())

MsgBox(account.Deposit(500))    ; "Deposited: $500. New balance: $1500"
MsgBox(account.Withdraw(200))   ; "Withdrew: $200. New balance: $1300"
MsgBox(account.Withdraw(2000))  ; "Insufficient funds"
MsgBox(account.GetBalance())    ; "$1300"

; ========================================
; EXAMPLE 4: Multiple Instances Independence
; ========================================
; Demonstrates that each instance has its own data

class Counter {
    Count := 0
    Label := ""

    __New(label := "Counter") {
        this.Label := label
    }

    Increment() {
        this.Count++
        return this.Label ": " this.Count
    }

    Decrement() {
        this.Count--
        return this.Label ": " this.Count
    }

    Reset() {
        this.Count := 0
        return this.Label " reset to 0"
    }

    GetValue() {
        return this.Count
    }
}

; Create multiple independent counters
counter1 := Counter("Counter A")
counter2 := Counter("Counter B")
counter3 := Counter("Counter C")

; Each counter maintains its own state
counter1.Increment()  ; Counter A: 1
counter1.Increment()  ; Counter A: 2
counter1.Increment()  ; Counter A: 3

counter2.Increment()  ; Counter B: 1
counter2.Increment()  ; Counter B: 2

counter3.Increment()  ; Counter C: 1

; Verify independence
result := "Counter 1: " counter1.GetValue() "`n"  ; 3
result .= "Counter 2: " counter2.GetValue() "`n"  ; 2
result .= "Counter 3: " counter3.GetValue()       ; 1
MsgBox(result)

; ========================================
; EXAMPLE 5: Class for Data Organization
; ========================================
; Using classes to organize related data (like a struct)

class Contact {
    FirstName := ""
    LastName := ""
    Email := ""
    Phone := ""
    Address := ""

    __New(firstName, lastName, email := "", phone := "", address := "") {
        this.FirstName := firstName
        this.LastName := lastName
        this.Email := email
        this.Phone := phone
        this.Address := address
    }

    GetFullName() {
        return this.FirstName " " this.LastName
    }

    HasEmail() {
        return this.Email != ""
    }

    HasPhone() {
        return this.Phone != ""
    }

    GetVCard() {
        vcard := "BEGIN:VCARD`n"
        vcard .= "VERSION:3.0`n"
        vcard .= "FN:" this.GetFullName() "`n"
        vcard .= "N:" this.LastName ";" this.FirstName "`n"

        if (this.HasEmail())
            vcard .= "EMAIL:" this.Email "`n"

        if (this.HasPhone())
            vcard .= "TEL:" this.Phone "`n"

        if (this.Address != "")
            vcard .= "ADR:" this.Address "`n"

        vcard .= "END:VCARD"
        return vcard
    }
}

; Create a contact directory
contacts := []
contacts.Push(Contact("Alice", "Smith", "alice@example.com", "555-0101"))
contacts.Push(Contact("Bob", "Johnson", "bob@example.com"))
contacts.Push(Contact("Charlie", "Brown", "", "555-0103", "123 Main St"))

; Display all contacts
contactList := "=== Contact Directory ===`n`n"
for index, contact in contacts {
    contactList .= index ". " contact.GetFullName()
    if (contact.HasEmail())
        contactList .= " (" contact.Email ")"
    contactList .= "`n"
}
MsgBox(contactList)

; Show vCard for first contact
MsgBox(contacts[1].GetVCard())

; ========================================
; EXAMPLE 6: Reference vs Value Behavior
; ========================================
; Objects are reference types - demonstrates this important concept

class Settings {
    Theme := "Light"
    FontSize := 12
    AutoSave := true

    __New(theme := "Light", fontSize := 12, autoSave := true) {
        this.Theme := theme
        this.FontSize := fontSize
        this.AutoSave := autoSave
    }

    ToString() {
        return "Theme: " this.Theme ", Font: " this.FontSize ", AutoSave: " this.AutoSave
    }
}

; Create an instance
settings1 := Settings("Dark", 14, true)
MsgBox("Settings 1: " settings1.ToString())

; Assignment creates a reference, not a copy
settings2 := settings1  ; settings2 points to the same object

; Modifying through settings2 affects settings1
settings2.Theme := "Light"
settings2.FontSize := 16

MsgBox("Settings 1: " settings1.ToString())  ; Changed!
MsgBox("Settings 2: " settings2.ToString())  ; Same object

; To create a copy, you need to create a new instance
settings3 := Settings(settings1.Theme, settings1.FontSize, settings1.AutoSave)
settings3.Theme := "Blue"

MsgBox("Settings 1: " settings1.ToString())  ; Unchanged
MsgBox("Settings 3: " settings3.ToString())  ; Different object

; ========================================
; EXAMPLE 7: Class with Computed Properties
; ========================================
; Methods can act as computed properties

class Temperature {
    Celsius := 0

    __New(celsius := 0) {
        this.Celsius := celsius
    }

    ; Computed property-like methods
    ToFahrenheit() {
        return (this.Celsius * 9 / 5) + 32
    }

    ToKelvin() {
        return this.Celsius + 273.15
    }

    FromFahrenheit(fahrenheit) {
        this.Celsius := (fahrenheit - 32) * 5 / 9
        return this
    }

    FromKelvin(kelvin) {
        this.Celsius := kelvin - 273.15
        return this
    }

    IsFreezing() {
        return this.Celsius <= 0
    }

    IsBoiling() {
        return this.Celsius >= 100
    }

    GetDescription() {
        if (this.Celsius < 0)
            return "Freezing"
        else if (this.Celsius < 10)
            return "Cold"
        else if (this.Celsius < 20)
            return "Cool"
        else if (this.Celsius < 30)
            return "Warm"
        else
            return "Hot"
    }

    ToString() {
        return this.Celsius "°C = "
            . Round(this.ToFahrenheit(), 1) "°F = "
            . Round(this.ToKelvin(), 1) "K ("
            . this.GetDescription() ")"
    }
}

; Create temperature instances
temp1 := Temperature(25)
MsgBox(temp1.ToString())  ; "25°C = 77°F = 298.15K (Warm)"

temp2 := Temperature(0)
MsgBox("Is freezing? " temp2.IsFreezing())  ; "Is freezing? 1"

temp3 := Temperature()
temp3.FromFahrenheit(98.6)  ; Body temperature
MsgBox(temp3.ToString())  ; "37°C = 98.6°F = 310.15K (Hot)"

; Compare temperatures
temperatures := [Temperature(-10), Temperature(0), Temperature(20), Temperature(100)]
tempDisplay := "Temperature Comparison:`n`n"
for temp in temperatures {
    tempDisplay .= temp.ToString() "`n"
}
MsgBox(tempDisplay)

MsgBox("=== OOP Class Basics Examples Complete ===`n`n"
    . "This file demonstrated:`n"
    . "- Basic class definition and instantiation`n"
    . "- Properties and methods`n"
    . "- Constructors`n"
    . "- Multiple instances`n"
    . "- Reference behavior`n"
    . "- Computed properties`n"
    . "- Data organization with classes")
