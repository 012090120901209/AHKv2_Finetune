#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_OOP_Inherit_01_BasicUsage.ahk
 * 
 * DESCRIPTION:
 * Demonstrates basic inheritance in AutoHotkey v2 using the 'extends' keyword.
 * Shows how child classes inherit properties and methods from parent classes,
 * and how to extend functionality while maintaining code reuse.
 * 
 * FEATURES:
 * - Basic extends syntax
 * - Inheriting properties and methods
 * - Adding new members to child classes
 * - Single inheritance hierarchy
 * - Multi-level inheritance
 * - Accessing inherited members
 * - instanceof-like checks
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - Objects
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - extends keyword for inheritance
 * - Automatic inheritance of parent members
 * - Class hierarchy and type relationships
 * - HasBase() method for type checking
 * - Prototype chain navigation
 * - Method and property inheritance
 * 
 * LEARNING POINTS:
 * 1. Inheritance enables code reuse
 * 2. Child classes automatically get parent members
 * 3. Child classes can add new functionality
 * 4. Use extends keyword to inherit
 * 5. Inheritance creates "is-a" relationships
 * 6. Multi-level inheritance is supported
 * 7. Type checking possible with HasBase()
 */

; ========================================
; EXAMPLE 1: Simple Parent-Child Inheritance
; ========================================
; Basic inheritance with extends keyword

class Animal {
    Name := ""
    Species := ""

    __New(name, species) {
        this.Name := name
        this.Species := species
    }

    Speak() {
        return this.Name " makes a sound"
    }

    Eat() {
        return this.Name " is eating"
    }

    Sleep() {
        return this.Name " is sleeping"
    }

    ToString() {
        return this.Name " (" this.Species ")"
    }
}

; Dog inherits from Animal
class Dog extends Animal {
    Breed := ""

    __New(name, breed) {
        ; Call parent constructor
        super.__New(name, "Dog")
        this.Breed := breed
    }

    ; Dogs have additional behavior
    Bark() {
        return this.Name " says: Woof! Woof!"
    }

    FetchBall() {
        return this.Name " is fetching the ball"
    }
}

; Cat inherits from Animal
class Cat extends Animal {
    IndoorOnly := false

    __New(name, indoorOnly := false) {
        super.__New(name, "Cat")
        this.IndoorOnly := indoorOnly
    }

    ; Cats have additional behavior
    Meow() {
        return this.Name " says: Meow!"
    }

    Scratch() {
        return this.Name " is scratching"
    }
}

; Create instances
dog := Dog("Buddy", "Golden Retriever")
cat := Cat("Whiskers", true)

; Use inherited methods
MsgBox(dog.Speak())     ; Inherited from Animal
MsgBox(dog.Eat())       ; Inherited from Animal
MsgBox(dog.ToString())  ; Inherited from Animal

; Use Dog-specific methods
MsgBox(dog.Bark())      ; Dog-specific
MsgBox(dog.FetchBall()) ; Dog-specific

; Cat using inherited and specific methods
MsgBox(cat.Sleep())     ; Inherited from Animal
MsgBox(cat.Meow())      ; Cat-specific
MsgBox(cat.Scratch())   ; Cat-specific

; ========================================
; EXAMPLE 2: Adding Properties in Child Classes
; ========================================
; Child classes can have additional properties

class Vehicle {
    Make := ""
    Model := ""
    Year := 0

    __New(make, model, year) {
        this.Make := make
        this.Model := model
        this.Year := year
    }

    Start() {
        return "Starting " this.Make " " this.Model
    }

    Stop() {
        return "Stopping " this.Make " " this.Model
    }

    GetInfo() {
        return this.Year " " this.Make " " this.Model
    }
}

class Car extends Vehicle {
    ; Additional properties specific to cars
    Doors := 4
    Transmission := "Automatic"

    __New(make, model, year, doors := 4, transmission := "Automatic") {
        super.__New(make, model, year)
        this.Doors := doors
        this.Transmission := transmission
    }

    OpenTrunk() {
        return "Opening trunk of " this.Model
    }

    GetCarInfo() {
        return this.GetInfo() " - " this.Doors " doors, " this.Transmission
    }
}

class Motorcycle extends Vehicle {
    ; Additional properties specific to motorcycles
    EngineCC := 0
    HasSidecar := false

    __New(make, model, year, engineCC, hasSidecar := false) {
        super.__New(make, model, year)
        this.EngineCC := engineCC
        this.HasSidecar := hasSidecar
    }

    Wheelie() {
        return this.Model " is doing a wheelie!"
    }

    GetBikeInfo() {
        sidecar := this.HasSidecar ? " with sidecar" : ""
        return this.GetInfo() " - " this.EngineCC "cc" sidecar
    }
}

; Create vehicles
car := Car("Toyota", "Camry", 2024, 4, "Automatic")
bike := Motorcycle("Harley-Davidson", "Street 750", 2024, 750)

; Use inherited and specific methods
MsgBox(car.Start())          ; Inherited
MsgBox(car.GetCarInfo())     ; Uses inherited and own properties
MsgBox(car.OpenTrunk())      ; Car-specific

MsgBox(bike.Start())         ; Inherited
MsgBox(bike.GetBikeInfo())   ; Uses inherited and own properties
MsgBox(bike.Wheelie())       ; Motorcycle-specific

; ========================================
; EXAMPLE 3: Multi-Level Inheritance
; ========================================
; Inheritance chains can go multiple levels deep

class Shape {
    X := 0
    Y := 0

    __New(x := 0, y := 0) {
        this.X := x
        this.Y := y
    }

    Move(newX, newY) {
        this.X := newX
        this.Y := newY
        return "Moved to (" newX ", " newY ")"
    }

    GetPosition() {
        return "Position: (" this.X ", " this.Y ")"
    }
}

class Polygon extends Shape {
    Sides := 0

    __New(x, y, sides) {
        super.__New(x, y)
        this.Sides := sides
    }

    GetSides() {
        return "This polygon has " this.Sides " sides"
    }
}

class Rectangle extends Polygon {
    Width := 0
    Height := 0

    __New(x, y, width, height) {
        super.__New(x, y, 4)  ; Rectangle always has 4 sides
        this.Width := width
        this.Height := height
    }

    Area() {
        return this.Width * this.Height
    }

    Perimeter() {
        return 2 * (this.Width + this.Height)
    }

    GetInfo() {
        return "Rectangle at " this.GetPosition() ", "
            . this.Width "x" this.Height
            . ", Area: " this.Area()
    }
}

class Square extends Rectangle {
    __New(x, y, size) {
        super.__New(x, y, size, size)
    }

    GetSize() {
        return this.Width  ; Width = Height for square
    }

    IsSquare() {
        return true
    }
}

; Create shapes with multi-level inheritance
square := Square(10, 20, 5)

; Methods inherited from Shape (3 levels up)
MsgBox(square.GetPosition())

; Methods inherited from Polygon (2 levels up)
MsgBox(square.GetSides())

; Methods inherited from Rectangle (1 level up)
MsgBox("Area: " square.Area())
MsgBox("Perimeter: " square.Perimeter())

; Square-specific methods
MsgBox("Size: " square.GetSize())
MsgBox("Is Square: " square.IsSquare())

; Combined information
MsgBox(square.GetInfo())

; ========================================
; EXAMPLE 4: Inheriting Static Members
; ========================================
; Static members are also inherited

class Counter {
    static TotalInstances := 0
    InstanceID := 0

    __New() {
        Counter.TotalInstances++
        this.InstanceID := Counter.TotalInstances
    }

    static GetTotal() {
        return Counter.TotalInstances
    }

    GetID() {
        return this.InstanceID
    }
}

class NamedCounter extends Counter {
    Name := ""

    __New(name) {
        super.__New()  ; Call parent constructor
        this.Name := name
    }

    GetInfo() {
        return "Counter: " this.Name " (ID: " this.InstanceID ")"
    }

    ; Can access parent's static method
    static ShowTotal() {
        return "Total counters created: " Counter.GetTotal()
    }
}

; Create instances
counter1 := Counter()
counter2 := NamedCounter("First")
counter3 := NamedCounter("Second")
counter4 := Counter()

MsgBox("Counter 1 ID: " counter1.GetID())
MsgBox("Named Counter 2: " counter2.GetInfo())
MsgBox("Named Counter 3: " counter3.GetInfo())

; Access static method through parent or child
MsgBox(Counter.GetTotal())
MsgBox(NamedCounter.ShowTotal())

; ========================================
; EXAMPLE 5: Type Checking with HasBase()
; ========================================
; Checking inheritance relationships at runtime

class Employee {
    Name := ""
    ID := ""

    __New(name, id) {
        this.Name := name
        this.ID := id
    }

    GetInfo() {
        return "Employee: " this.Name " (ID: " this.ID ")"
    }
}

class Manager extends Employee {
    Department := ""
    TeamSize := 0

    __New(name, id, department, teamSize) {
        super.__New(name, id)
        this.Department := department
        this.TeamSize := teamSize
    }

    GetInfo() {
        return "Manager: " this.Name " (ID: " this.ID ")"
            . "`nDepartment: " this.Department
            . "`nTeam Size: " this.TeamSize
    }
}

class Developer extends Employee {
    ProgrammingLanguages := []

    __New(name, id, languages*) {
        super.__New(name, id)
        this.ProgrammingLanguages := languages
    }

    GetInfo() {
        langs := ""
        for lang in this.ProgrammingLanguages {
            langs .= lang
            if (A_Index < this.ProgrammingLanguages.Length)
                langs .= ", "
        }
        return "Developer: " this.Name " (ID: " this.ID ")"
            . "`nLanguages: " langs
    }
}

; Helper function to check type
CheckEmployeeType(emp) {
    result := emp.Name " is:`n"

    ; Check if instance has Employee as base
    if (emp.HasBase(Employee.Prototype))
        result .= "- An Employee`n"

    ; Check if instance has Manager as base
    if (emp.HasBase(Manager.Prototype))
        result .= "- A Manager`n"

    ; Check if instance has Developer as base
    if (emp.HasBase(Developer.Prototype))
        result .= "- A Developer`n"

    return result
}

; Create different employee types
emp := Employee("John Doe", "E001")
mgr := Manager("Jane Smith", "M001", "Engineering", 10)
dev := Developer("Bob Johnson", "D001", "Python", "JavaScript", "C++")

MsgBox(CheckEmployeeType(emp))
MsgBox(CheckEmployeeType(mgr))
MsgBox(CheckEmployeeType(dev))

; ========================================
; EXAMPLE 6: Inheritance for Code Reuse
; ========================================
; Using inheritance to avoid code duplication

class DatabaseConnection {
    Host := ""
    Port := 0
    Connected := false

    __New(host, port) {
        this.Host := host
        this.Port := port
    }

    Connect() {
        ; Simulate connection
        this.Connected := true
        return "Connected to " this.Host ":" this.Port
    }

    Disconnect() {
        this.Connected := false
        return "Disconnected from " this.Host ":" this.Port
    }

    IsConnected() {
        return this.Connected
    }
}

class MySQLConnection extends DatabaseConnection {
    Database := ""
    Username := ""

    __New(host, port, database, username) {
        super.__New(host, port)
        this.Database := database
        this.Username := username
    }

    Query(sql) {
        if (!this.Connected)
            return "Not connected"
        return "Executing MySQL query: " sql
    }

    GetConnectionString() {
        return "mysql://" this.Username "@" this.Host ":" this.Port "/" this.Database
    }
}

class PostgreSQLConnection extends DatabaseConnection {
    Database := ""
    Schema := "public"

    __New(host, port, database, schema := "public") {
        super.__New(host, port)
        this.Database := database
        this.Schema := schema
    }

    Query(sql) {
        if (!this.Connected)
            return "Not connected"
        return "Executing PostgreSQL query: " sql
    }

    GetConnectionString() {
        return "postgresql://" this.Host ":" this.Port "/" this.Database "?schema=" this.Schema
    }
}

; Both inherit connection logic from parent
mysql := MySQLConnection("localhost", 3306, "mydb", "root")
postgres := PostgreSQLConnection("localhost", 5432, "mydb", "public")

; Use inherited connection methods
MsgBox(mysql.Connect())
MsgBox(postgres.Connect())

; Use specific query methods
MsgBox(mysql.Query("SELECT * FROM users"))
MsgBox(postgres.Query("SELECT * FROM users"))

; Connection strings
MsgBox("MySQL: " mysql.GetConnectionString())
MsgBox("PostgreSQL: " postgres.GetConnectionString())

; ========================================
; EXAMPLE 7: Building Class Hierarchies
; ========================================
; Creating a logical hierarchy of related classes

class Account {
    AccountNumber := ""
    Balance := 0
    Owner := ""

    __New(accountNumber, owner, initialBalance := 0) {
        this.AccountNumber := accountNumber
        this.Owner := owner
        this.Balance := initialBalance
    }

    Deposit(amount) {
        this.Balance += amount
        return "Deposited: $" amount
    }

    GetBalance() {
        return "$" this.Balance
    }

    GetInfo() {
        return "Account: " this.AccountNumber
            . "`nOwner: " this.Owner
            . "`nBalance: $" this.Balance
    }
}

class SavingsAccount extends Account {
    InterestRate := 0.02  ; 2%
    MinimumBalance := 100

    __New(accountNumber, owner, initialBalance, interestRate := 0.02) {
        super.__New(accountNumber, owner, initialBalance)
        this.InterestRate := interestRate
    }

    AddInterest() {
        interest := this.Balance * this.InterestRate
        this.Balance += interest
        return "Interest added: $" Round(interest, 2)
    }

    CanWithdraw(amount) {
        return (this.Balance - amount) >= this.MinimumBalance
    }
}

class CheckingAccount extends Account {
    OverdraftLimit := 500
    ChecksWritten := 0

    __New(accountNumber, owner, initialBalance, overdraftLimit := 500) {
        super.__New(accountNumber, owner, initialBalance)
        this.OverdraftLimit := overdraftLimit
    }

    WriteCheck(amount) {
        if (amount > (this.Balance + this.OverdraftLimit))
            return "Insufficient funds (including overdraft)"

        this.Balance -= amount
        this.ChecksWritten++
        return "Check written for $" amount ". New balance: $" this.Balance
    }

    GetCheckCount() {
        return this.ChecksWritten
    }
}

; Create different account types
savings := SavingsAccount("SAV001", "Alice", 1000, 0.03)
checking := CheckingAccount("CHK001", "Bob", 500, 1000)

; Use inherited methods
MsgBox(savings.Deposit(200))
MsgBox(checking.Deposit(100))

; Use specific methods
MsgBox(savings.AddInterest())
MsgBox(checking.WriteCheck(400))

; Show info
MsgBox(savings.GetInfo())
MsgBox(checking.GetInfo() "`nChecks Written: " checking.GetCheckCount())

MsgBox("=== OOP Inheritance Basic Usage Examples Complete ===`n`n"
    . "This file demonstrated:`n"
    . "- Basic extends syntax`n"
    . "- Inheriting properties and methods`n"
    . "- Adding new members in child classes`n"
    . "- Multi-level inheritance`n"
    . "- Inheriting static members`n"
    . "- Type checking with HasBase()`n"
    . "- Code reuse through inheritance`n"
    . "- Building class hierarchies")
