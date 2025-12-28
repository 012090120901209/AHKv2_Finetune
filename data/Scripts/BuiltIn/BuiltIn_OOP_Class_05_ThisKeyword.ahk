#Requires AutoHotkey v2.0

/**
 * BuiltIn_OOP_Class_05_ThisKeyword.ahk
 * 
 * DESCRIPTION:
 * Demonstrates the 'this' keyword in AutoHotkey v2 classes. The 'this' keyword
 * refers to the current instance and is essential for accessing instance members,
 * method chaining, and distinguishing between parameters and properties.
 * 
 * FEATURES:
 * - Basic 'this' keyword usage
 * - Accessing instance properties with 'this'
 * - Calling instance methods with 'this'
 * - Method chaining with 'this' return
 * - Resolving name conflicts with 'this'
 * - 'this' in nested contexts
 * - Passing 'this' as parameter
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - Objects
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - this.PropertyName for property access
 * - this.MethodName() for method calls
 * - Returning 'this' for method chaining
 * - this in closures and callbacks
 * - Dynamic property access with this.%varName%
 * - this in property getters/setters
 * 
 * LEARNING POINTS:
 * 1. 'this' refers to the current instance
 * 2. 'this' is required to access instance members
 * 3. 'this' disambiguates between parameters and properties
 * 4. Returning 'this' enables method chaining
 * 5. 'this' context can change in nested functions
 * 6. 'this' is implicit in property methods
 * 7. 'this' can be passed to other functions/methods
 */

; ========================================
; EXAMPLE 1: Basic 'this' Usage
; ========================================
; Understanding how 'this' refers to the current instance

class Person {
    Name := ""
    Age := 0
    City := ""

    __New(name, age, city) {
        ; 'this' refers to the newly created instance
        this.Name := name
        this.Age := age
        this.City := city
    }

    ; Without 'this', would create local variables
    UpdateInfo(name, age, city) {
        ; 'this' is required to access instance properties
        this.Name := name
        this.Age := age
        this.City := city
    }

    Introduce() {
        ; 'this' accesses the instance's properties
        return "Hi, I'm " this.Name ", " this.Age " years old, from " this.City
    }

    HaveBirthday() {
        ; 'this' is needed to modify instance property
        this.Age++
        return "Happy Birthday! Now " this.Age " years old."
    }

    MoveTo(newCity) {
        oldCity := this.City  ; Reading property
        this.City := newCity   ; Writing property
        return "Moved from " oldCity " to " newCity
    }
}

; Create instance - 'this' inside constructor refers to person1
person1 := Person("Alice", 30, "New York")
MsgBox(person1.Introduce())

; Call method - 'this' inside HaveBirthday refers to person1
MsgBox(person1.HaveBirthday())
MsgBox(person1.Introduce())

; Different instance - 'this' refers to person2
person2 := Person("Bob", 25, "Los Angeles")
MsgBox(person2.Introduce())

; 'this' in MoveTo refers to the specific instance calling it
MsgBox(person1.MoveTo("Chicago"))
MsgBox(person2.MoveTo("Seattle"))

; ========================================
; EXAMPLE 2: Method Chaining with 'this'
; ========================================
; Returning 'this' enables fluent interface pattern

class StringBuilder {
    _buffer := ""

    __New(initialText := "") {
        this._buffer := initialText
    }

    ; Each method returns 'this' for chaining
    Append(text) {
        this._buffer .= text
        return this  ; Return current instance
    }

    AppendLine(text := "") {
        this._buffer .= text "`n"
        return this
    }

    Prepend(text) {
        this._buffer := text this._buffer
        return this
    }

    Insert(position, text) {
        before := SubStr(this._buffer, 1, position)
        after := SubStr(this._buffer, position + 1)
        this._buffer := before text after
        return this
    }

    Replace(oldText, newText) {
        this._buffer := StrReplace(this._buffer, oldText, newText)
        return this
    }

    Clear() {
        this._buffer := ""
        return this
    }

    ToUpper() {
        this._buffer := StrUpper(this._buffer)
        return this
    }

    ToLower() {
        this._buffer := StrLower(this._buffer)
        return this
    }

    ToString() {
        return this._buffer
    }
}

; Method chaining - each method returns 'this'
result := StringBuilder()
    .Append("Hello")
    .Append(" ")
    .Append("World")
    .AppendLine("!")
    .Append("This is ")
    .Append("method chaining")
    .ToString()

MsgBox(result)

; More complex chaining
formatted := StringBuilder("original text")
    .ToUpper()
    .Replace("ORIGINAL", "NEW")
    .Append(" - MODIFIED")
    .ToString()

MsgBox(formatted)

; ========================================
; EXAMPLE 3: Resolving Name Conflicts
; ========================================
; Using 'this' to distinguish between parameters and properties

class BankAccount {
    AccountNumber := ""
    Balance := 0
    Owner := ""

    ; Parameters have same names as properties
    __New(AccountNumber, Balance, Owner) {
        ; 'this' distinguishes property from parameter
        this.AccountNumber := AccountNumber
        this.Balance := Balance
        this.Owner := Owner
    }

    ; Method where parameter name matches property
    SetOwner(Owner) {
        ; Without 'this', both would refer to parameter
        oldOwner := this.Owner  ; Property
        this.Owner := Owner     ; Property := Parameter
        return "Owner changed from " oldOwner " to " Owner
    }

    SetBalance(Balance) {
        this.Balance := Balance
        return "Balance set to $" Balance
    }

    Deposit(amount) {
        ; No conflict here, but 'this' still needed for property
        this.Balance += amount
        return "Deposited $" amount ". New balance: $" this.Balance
    }

    Transfer(amount, toAccount) {
        if (amount > this.Balance)
            return "Insufficient funds"

        ; 'this' refers to the source account
        this.Balance -= amount

        ; toAccount is a different instance
        toAccount.Balance += amount

        return "Transferred $" amount " to " toAccount.Owner
    }
}

account1 := BankAccount("ACC001", 1000, "Alice")
account2 := BankAccount("ACC002", 500, "Bob")

MsgBox(account1.SetOwner("Alice Smith"))
MsgBox(account1.Deposit(250))
MsgBox(account1.Transfer(300, account2))

; ========================================
; EXAMPLE 4: 'this' in Nested Contexts
; ========================================
; Understanding 'this' context in callbacks and nested functions

class EventHandler {
    Name := ""
    EventCount := 0
    Events := []

    __New(name) {
        this.Name := name
    }

    RegisterEvent(eventName) {
        this.EventCount++
        this.Events.Push({
            name: eventName,
            time: A_Now,
            handler: this  ; Capture 'this' reference
        })

        return "Event registered: " eventName
    }

    ProcessEvents() {
        ; 'this' refers to EventHandler instance
        result := "Processing events for: " this.Name "`n"

        for index, event in this.Events {
            ; Create a callback that needs to reference 'this'
            result .= this.FormatEvent(event, index) "`n"
        }

        return result
    }

    FormatEvent(event, index) {
        ; 'this' still refers to the EventHandler instance
        return Format("#{} - {} at {} (Handler: {})",
            index, event.name, event.time, this.Name)
    }

    CreateCallback() {
        ; Capture 'this' for use in closure
        instance := this

        ; Return a function that uses captured instance
        callback := (*) => instance.OnCallback()

        return callback
    }

    OnCallback() {
        this.EventCount++
        return "Callback executed for: " this.Name
    }
}

handler := EventHandler("MainHandler")
handler.RegisterEvent("Click")
handler.RegisterEvent("KeyPress")
handler.RegisterEvent("Timer")

MsgBox(handler.ProcessEvents())

; Using callback
callback := handler.CreateCallback()
MsgBox(callback.Call())

; ========================================
; EXAMPLE 5: Passing 'this' as Parameter
; ========================================
; Passing the current instance to other methods or functions

class Node {
    Value := ""
    Children := []
    Parent := ""

    __New(value) {
        this.Value := value
        this.Children := []
        this.Parent := ""
    }

    ; Pass 'this' to child nodes as parent
    AddChild(childValue) {
        child := Node(childValue)
        child.Parent := this  ; Pass current instance as parent
        this.Children.Push(child)
        return child
    }

    ; Check if this node is root
    IsRoot() {
        return this.Parent = ""
    }

    ; Get path from root to this node
    GetPath() {
        path := []

        ; Start from current node
        current := this

        ; Walk up to root
        while (current != "") {
            path.InsertAt(1, current.Value)
            current := current.Parent
        }

        result := ""
        for value in path {
            result .= value
            if (A_Index < path.Length)
                result .= " > "
        }

        return result
    }

    ; Compare this node with another
    IsSiblingOf(otherNode) {
        ; 'this' is current node, otherNode is parameter
        if (this.Parent = "" || otherNode.Parent = "")
            return false

        return this.Parent = otherNode.Parent
    }

    ToString() {
        return this.Value " (Children: " this.Children.Length ")"
    }
}

; Build tree
root := Node("Root")
child1 := root.AddChild("Child1")
child2 := root.AddChild("Child2")
grandchild1 := child1.AddChild("Grandchild1")
grandchild2 := child1.AddChild("Grandchild2")

; Show paths
MsgBox("Path to grandchild1: " grandchild1.GetPath())
MsgBox("Path to child2: " child2.GetPath())

; Check siblings
MsgBox("Are grandchild1 and grandchild2 siblings? "
    . (grandchild1.IsSiblingOf(grandchild2) ? "Yes" : "No"))

MsgBox("Are child1 and grandchild1 siblings? "
    . (child1.IsSiblingOf(grandchild1) ? "Yes" : "No"))

; ========================================
; EXAMPLE 6: 'this' in Property Getters/Setters
; ========================================
; Using 'this' in property methods

class Temperature {
    _celsius := 0

    Celsius {
        get {
            ; 'this' refers to the instance
            return this._celsius
        }
        set {
            ; 'this' accesses instance property
            this._celsius := value
        }
    }

    Fahrenheit {
        get {
            ; 'this' to access other property
            return (this._celsius * 9 / 5) + 32
        }
        set {
            ; 'this' to set related property
            this._celsius := (value - 32) * 5 / 9
        }
    }

    Kelvin {
        get {
            return this._celsius + 273.15
        }
        set {
            this._celsius := value - 273.15
        }
    }

    ; Method using 'this' to access properties
    ToString() {
        return Format("{:.1f}°C = {:.1f}°F = {:.1f}K",
            this.Celsius, this.Fahrenheit, this.Kelvin)
    }

    ; Method chaining with 'this'
    Add(celsius) {
        this.Celsius += celsius
        return this
    }

    Subtract(celsius) {
        this.Celsius -= celsius
        return this
    }
}

temp := Temperature()
temp.Celsius := 25
MsgBox(temp.ToString())

temp.Fahrenheit := 98.6  ; Body temperature
MsgBox(temp.ToString())

; Method chaining using 'this'
temp.Add(10).Subtract(5)
MsgBox("After adding 10 and subtracting 5: " temp.ToString())

; ========================================
; EXAMPLE 7: Complex 'this' Usage Pattern
; ========================================
; Advanced patterns combining multiple 'this' techniques

class FluentValidator {
    _value := ""
    _errors := []
    _fieldName := ""

    __New(fieldName, value) {
        this._fieldName := fieldName
        this._value := value
        this._errors := []
    }

    ; Each validation returns 'this' for chaining
    Required() {
        if (Trim(this._value) = "")
            this._AddError("is required")
        return this
    }

    MinLength(length) {
        if (StrLen(this._value) < length)
            this._AddError("must be at least " length " characters")
        return this
    }

    MaxLength(length) {
        if (StrLen(this._value) > length)
            this._AddError("must be no more than " length " characters")
        return this
    }

    Pattern(regex, message := "has invalid format") {
        if (!RegExMatch(this._value, regex))
            this._AddError(message)
        return this
    }

    Email() {
        return this.Pattern("^[^@]+@[^@]+\.[^@]+$", "must be a valid email")
    }

    Numeric() {
        if (!IsNumber(this._value))
            this._AddError("must be numeric")
        return this
    }

    Range(min, max) {
        val := Number(this._value)
        if (val < min || val > max)
            this._AddError("must be between " min " and " max)
        return this
    }

    ; Private method using 'this'
    _AddError(message) {
        this._errors.Push(this._fieldName " " message)
    }

    ; Check if valid
    IsValid() {
        return this._errors.Length = 0
    }

    ; Get errors
    GetErrors() {
        return this._errors
    }

    ; Get first error
    GetFirstError() {
        return this._errors.Length > 0 ? this._errors[1] : ""
    }

    ; Static factory method
    static For(fieldName, value) {
        return FluentValidator(fieldName, value)
    }
}

; Validate email with chaining
emailValidator := FluentValidator.For("Email", "test@example.com")
    .Required()
    .Email()
    .MaxLength(100)

if (emailValidator.IsValid()) {
    MsgBox("Email is valid!")
} else {
    errors := emailValidator.GetErrors()
    msg := "Validation errors:`n"
    for error in errors
        msg .= "- " error "`n"
    MsgBox(msg)
}

; Validate age
ageValidator := FluentValidator.For("Age", "25")
    .Required()
    .Numeric()
    .Range(18, 100)

MsgBox("Age is " (ageValidator.IsValid() ? "valid" : "invalid"))

; Invalid username
usernameValidator := FluentValidator.For("Username", "ab")
    .Required()
    .MinLength(3)
    .MaxLength(20)
    .Pattern("^[a-zA-Z0-9_]+$", "can only contain letters, numbers, and underscores")

if (!usernameValidator.IsValid()) {
    MsgBox("Error: " usernameValidator.GetFirstError())
}

MsgBox("=== OOP 'this' Keyword Examples Complete ===`n`n"
    . "This file demonstrated:`n"
    . "- Basic 'this' usage for instance access`n"
    . "- Method chaining with 'this' return`n"
    . "- Resolving name conflicts with 'this'`n"
    . "- 'this' in nested contexts and closures`n"
    . "- Passing 'this' as parameter`n"
    . "- 'this' in property getters/setters`n"
    . "- Complex fluent interface patterns")
