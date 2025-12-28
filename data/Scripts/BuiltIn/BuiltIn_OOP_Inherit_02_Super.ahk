#Requires AutoHotkey v2.0

/**
 * BuiltIn_OOP_Inherit_02_Super.ahk
 * 
 * DESCRIPTION:
 * Demonstrates the 'super' keyword in AutoHotkey v2 for accessing parent class
 * members from child classes. Shows how to call parent constructors, override
 * methods while preserving parent functionality, and properly initialize inheritance chains.
 * 
 * FEATURES:
 * - super keyword syntax
 * - Calling parent constructors with super.__New()
 * - Calling parent methods with super.Method()
 * - Extending parent functionality
 * - Preserving parent behavior in overrides
 * - Super in multi-level inheritance
 * - Initialization order with super
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - Objects
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - super keyword for parent access
 * - super.__New() for parent constructor
 * - super.MethodName() for parent methods
 * - Proper initialization chains
 * - Method extension vs replacement
 * - Constructor chaining
 * 
 * LEARNING POINTS:
 * 1. super refers to the parent class
 * 2. super.__New() calls parent constructor
 * 3. Always call super.__New() if parent has constructor
 * 4. super allows extending parent functionality
 * 5. super preserves parent behavior in overrides
 * 6. Initialization flows from parent to child
 * 7. super works through multiple inheritance levels
 */

; ========================================
; EXAMPLE 1: Basic super.__New() Usage
; ========================================
; Properly calling parent constructors

class Person {
    FirstName := ""
    LastName := ""
    Age := 0

    __New(firstName, lastName, age) {
        this.FirstName := firstName
        this.LastName := lastName
        this.Age := age
        MsgBox("Person constructor called for: " firstName " " lastName)
    }

    GetFullName() {
        return this.FirstName " " this.LastName
    }

    Introduce() {
        return "Hi, I'm " this.GetFullName()
    }
}

class Student extends Person {
    StudentID := ""
    Major := ""
    GPA := 0.0

    __New(firstName, lastName, age, studentID, major) {
        ; Must call parent constructor first
        super.__New(firstName, lastName, age)

        ; Then initialize child properties
        this.StudentID := studentID
        this.Major := major
        this.GPA := 0.0

        MsgBox("Student constructor called for: " studentID)
    }

    Introduce() {
        ; Call parent method and extend it
        parentIntro := super.Introduce()
        return parentIntro ", and I'm studying " this.Major
    }

    GetInfo() {
        return this.GetFullName()
            . "`nStudent ID: " this.StudentID
            . "`nMajor: " this.Major
            . "`nGPA: " this.GPA
    }
}

; Creating student calls both constructors
student := Student("John", "Doe", 20, "S12345", "Computer Science")

MsgBox(student.Introduce())  ; Uses both parent and child logic
MsgBox(student.GetInfo())

; ========================================
; EXAMPLE 2: Extending Parent Methods
; ========================================
; Using super to extend rather than replace functionality

class Logger {
    Name := ""
    LogCount := 0

    __New(name) {
        this.Name := name
        this.LogCount := 0
    }

    Log(message) {
        this.LogCount++
        timestamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
        return "[" timestamp "] " message
    }

    GetStats() {
        return "Logger: " this.Name ", Logs: " this.LogCount
    }
}

class FileLogger extends Logger {
    FilePath := ""
    WriteCount := 0

    __New(name, filePath) {
        ; Initialize parent first
        super.__New(name)

        ; Then child-specific initialization
        this.FilePath := filePath
        this.WriteCount := 0
    }

    Log(message) {
        ; Call parent's Log method to get formatted message
        formattedMsg := super.Log(message)

        ; Add file-specific functionality
        this.WriteCount++
        fileMsg := formattedMsg " -> " this.FilePath

        return fileMsg
    }

    GetStats() {
        ; Get parent stats and extend them
        parentStats := super.GetStats()
        return parentStats
            . "`nFile: " this.FilePath
            . "`nWrites: " this.WriteCount
    }
}

class DatabaseLogger extends Logger {
    TableName := ""
    DBWrites := 0

    __New(name, tableName) {
        super.__New(name)
        this.TableName := tableName
        this.DBWrites := 0
    }

    Log(message) {
        ; Use parent's formatting
        formattedMsg := super.Log(message)

        ; Add database-specific logic
        this.DBWrites++
        dbMsg := "INSERT INTO " this.TableName ": " formattedMsg

        return dbMsg
    }

    GetStats() {
        parentStats := super.GetStats()
        return parentStats
            . "`nTable: " this.TableName
            . "`nDB Writes: " this.DBWrites
    }
}

; Create different logger types
fileLogger := FileLogger("AppLogger", "app.log")
dbLogger := DatabaseLogger("DBLogger", "logs")

; Both use parent Log but extend it
MsgBox(fileLogger.Log("Application started"))
MsgBox(dbLogger.Log("Database connected"))

; Extended stats
MsgBox(fileLogger.GetStats())
MsgBox(dbLogger.GetStats())

; ========================================
; EXAMPLE 3: Multi-Level super Calls
; ========================================
; Using super through multiple inheritance levels

class Vehicle {
    Make := ""
    Model := ""

    __New(make, model) {
        this.Make := make
        this.Model := model
        MsgBox("Vehicle constructor: " make " " model)
    }

    Start() {
        return "Starting " this.Make " " this.Model
    }

    GetDescription() {
        return this.Make " " this.Model
    }
}

class Car extends Vehicle {
    Doors := 4

    __New(make, model, doors) {
        super.__New(make, model)  ; Call Vehicle constructor
        this.Doors := doors
        MsgBox("Car constructor: " doors " doors")
    }

    Start() {
        ; Call parent Start and extend
        baseStart := super.Start()
        return baseStart " (Car with " this.Doors " doors)"
    }

    GetDescription() {
        return super.GetDescription() " - " this.Doors " door car"
    }
}

class ElectricCar extends Car {
    BatteryCapacity := 0
    Range := 0

    __New(make, model, doors, batteryCapacity, range) {
        super.__New(make, model, doors)  ; Call Car constructor (which calls Vehicle)
        this.BatteryCapacity := batteryCapacity
        this.Range := range
        MsgBox("ElectricCar constructor: " batteryCapacity "kWh battery")
    }

    Start() {
        ; Call Car's Start (which calls Vehicle's Start)
        carStart := super.Start()
        return carStart " [Electric: " this.BatteryCapacity "kWh, Range: " this.Range "mi]"
    }

    GetDescription() {
        return super.GetDescription()
            . "`nElectric: " this.BatteryCapacity "kWh battery"
            . "`nRange: " this.Range " miles"
    }
}

; Constructor chain: ElectricCar -> Car -> Vehicle
electricCar := ElectricCar("Tesla", "Model 3", 4, 75, 350)

; Method calls flow through inheritance chain
MsgBox(electricCar.Start())
MsgBox(electricCar.GetDescription())

; ========================================
; EXAMPLE 4: Preserving Parent Logic
; ========================================
; Important pattern: calling super to preserve parent behavior

class BankAccount {
    AccountNumber := ""
    Balance := 0
    TransactionHistory := []

    __New(accountNumber, initialBalance := 0) {
        this.AccountNumber := accountNumber
        this.Balance := initialBalance
        this.TransactionHistory := []
    }

    Deposit(amount) {
        if (amount <= 0)
            throw ValueError("Deposit amount must be positive")

        this.Balance += amount
        this.TransactionHistory.Push({
            type: "Deposit",
            amount: amount,
            time: A_Now,
            balance: this.Balance
        })

        return "Deposited $" amount ". New balance: $" this.Balance
    }

    Withdraw(amount) {
        if (amount <= 0)
            throw ValueError("Withdrawal amount must be positive")

        if (amount > this.Balance)
            throw ValueError("Insufficient funds")

        this.Balance -= amount
        this.TransactionHistory.Push({
            type: "Withdrawal",
            amount: amount,
            time: A_Now,
            balance: this.Balance
        })

        return "Withdrew $" amount ". New balance: $" this.Balance
    }
}

class SavingsAccount extends BankAccount {
    InterestRate := 0.02
    MinimumBalance := 100

    __New(accountNumber, initialBalance, interestRate := 0.02) {
        ; Parent handles basic initialization
        super.__New(accountNumber, initialBalance)

        this.InterestRate := interestRate
    }

    Withdraw(amount) {
        ; Additional validation
        if ((this.Balance - amount) < this.MinimumBalance)
            throw ValueError("Withdrawal would go below minimum balance of $" this.MinimumBalance)

        ; Call parent Withdraw to preserve its logic
        return super.Withdraw(amount)
    }

    AddInterest() {
        interest := this.Balance * this.InterestRate

        ; Use parent's Deposit method for consistency
        super.Deposit(interest)

        return "Interest added: $" Round(interest, 2)
    }
}

; Create savings account
savings := SavingsAccount("SAV001", 500, 0.03)

; Deposit uses parent logic entirely
MsgBox(savings.Deposit(200))

; AddInterest uses super.Deposit
MsgBox(savings.AddInterest())

; Withdraw uses parent logic but adds validation
try {
    MsgBox(savings.Withdraw(50))
} catch ValueError as err {
    MsgBox("Error: " err.Message)
}

; This would fail minimum balance check
try {
    MsgBox(savings.Withdraw(700))
} catch ValueError as err {
    MsgBox("Error: " err.Message)
}

; ========================================
; EXAMPLE 5: Constructor Initialization Order
; ========================================
; Demonstrating proper initialization order with super

class Component {
    ID := ""
    Created := ""
    InitOrder := []

    __New(id) {
        this.ID := id
        this.Created := A_Now
        this.InitOrder := ["Component"]
    }

    Initialize() {
        this.InitOrder.Push("Component.Initialize")
        return "Component initialized"
    }
}

class UIComponent extends Component {
    Visible := true
    Enabled := true

    __New(id, visible := true) {
        ; Parent initialization must come first
        super.__New(id)

        ; Then child initialization
        this.Visible := visible
        this.Enabled := true
        this.InitOrder.Push("UIComponent")
    }

    Initialize() {
        ; Call parent initialization
        super.Initialize()

        ; Then child-specific initialization
        this.InitOrder.Push("UIComponent.Initialize")
        return "UIComponent initialized"
    }

    Show() {
        this.Visible := true
        return "Component shown"
    }
}

class Button extends UIComponent {
    Text := ""
    ClickCount := 0

    __New(id, text, visible := true) {
        ; Parent initialization
        super.__New(id, visible)

        ; Child initialization
        this.Text := text
        this.ClickCount := 0
        this.InitOrder.Push("Button")
    }

    Initialize() {
        ; Parent initialization chain
        super.Initialize()

        ; Child initialization
        this.InitOrder.Push("Button.Initialize")
        return "Button initialized"
    }

    Click() {
        this.ClickCount++
        return "Button '" this.Text "' clicked (" this.ClickCount " times)"
    }

    GetInitializationOrder() {
        order := "Initialization order:`n"
        for step in this.InitOrder {
            order .= A_Index ". " step "`n"
        }
        return order
    }
}

; Create button - watch initialization order
button := Button("btn1", "Click Me")

; Show initialization order
MsgBox(button.GetInitializationOrder())

; Call Initialize - flows through chain
button.Initialize()
MsgBox(button.GetInitializationOrder())

; ========================================
; EXAMPLE 6: Super with Property Methods
; ========================================
; Using super in property getters and setters

class Temperature {
    _value := 0
    _unit := "C"

    __New(value := 0, unit := "C") {
        this._value := value
        this._unit := unit
    }

    Value {
        get => this._value
        set => this._value := value
    }

    ToString() {
        return this._value "°" this._unit
    }
}

class CelsiusTemperature extends Temperature {
    __New(value := 0) {
        super.__New(value, "C")
    }

    Value {
        get {
            ; Use parent getter
            return super.Value
        }
        set {
            ; Add validation before calling parent setter
            if (value < -273.15)
                throw ValueError("Temperature below absolute zero")

            ; Call parent setter
            super.Value := value
        }
    }

    ToFahrenheit() {
        return (this.Value * 9 / 5) + 32
    }

    ToString() {
        ; Extend parent ToString
        parentStr := super.ToString()
        return parentStr " (" this.ToFahrenheit() "°F)"
    }
}

temp := CelsiusTemperature(25)
MsgBox(temp.ToString())

temp.Value := 100
MsgBox(temp.ToString())

; This will fail validation
try {
    temp.Value := -300
} catch ValueError as err {
    MsgBox("Error: " err.Message)
}

; ========================================
; EXAMPLE 7: Advanced super Patterns
; ========================================
; Complex scenarios requiring super

class DataValidator {
    Rules := []

    __New() {
        this.Rules := []
    }

    AddRule(rule) {
        this.Rules.Push(rule)
    }

    Validate(value) {
        errors := []

        for rule in this.Rules {
            if (!rule.Check(value))
                errors.Push(rule.Message)
        }

        return errors
    }

    IsValid(value) {
        errors := this.Validate(value)
        return errors.Length = 0
    }
}

class StringValidator extends DataValidator {
    MinLength := 0
    MaxLength := 0

    __New(minLength := 0, maxLength := 0) {
        ; Initialize parent
        super.__New()

        this.MinLength := minLength
        this.MaxLength := maxLength

        ; Add default rules after parent initialization
        if (minLength > 0) {
            this.AddRule({
                Check: (v) => StrLen(v) >= minLength,
                Message: "Must be at least " minLength " characters"
            })
        }

        if (maxLength > 0) {
            this.AddRule({
                Check: (v) => StrLen(v) <= maxLength,
                Message: "Must be no more than " maxLength " characters"
            })
        }
    }

    Validate(value) {
        ; Call parent validation
        errors := super.Validate(value)

        ; Add string-specific validation
        if (!IsString(value))
            errors.InsertAt(1, "Value must be a string")

        return errors
    }

    RequirePattern(pattern, message) {
        this.AddRule({
            Check: (v) => RegExMatch(v, pattern),
            Message: message
        })
        return this  ; Allow chaining
    }
}

class EmailValidator extends StringValidator {
    __New() {
        ; Initialize with string constraints
        super.__New(5, 255)

        ; Add email-specific pattern
        this.RequirePattern("^[^@]+@[^@]+\.[^@]+$", "Must be valid email format")
    }

    Validate(value) {
        ; Get parent validation results
        errors := super.Validate(value)

        ; Additional email-specific checks
        if (errors.Length = 0) {
            parts := StrSplit(value, "@")
            if (parts.Length = 2 && StrLen(parts[1]) > 64)
                errors.Push("Local part too long (max 64 characters)")
        }

        return errors
    }
}

; Create email validator - initialization flows through chain
emailValidator := EmailValidator()

; Test validation
testEmails := [
    "valid@example.com",
    "invalid",
    "ab@c.d",
    "toolonglocalpaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaart@example.com"
]

for email in testEmails {
    errors := emailValidator.Validate(email)

    if (errors.Length = 0) {
        MsgBox(email " is valid")
    } else {
        msg := email " is invalid:`n"
        for error in errors
            msg .= "- " error "`n"
        MsgBox(msg)
    }
}

MsgBox("=== OOP Super Keyword Examples Complete ===`n`n"
    . "This file demonstrated:`n"
    . "- Basic super.__New() usage`n"
    . "- Extending parent methods with super`n"
    . "- Multi-level super calls`n"
    . "- Preserving parent logic`n"
    . "- Proper initialization order`n"
    . "- Super in property methods`n"
    . "- Advanced super patterns")
