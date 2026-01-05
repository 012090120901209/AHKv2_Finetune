#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_OOP_Inherit_03_Override.ahk
 * 
 * DESCRIPTION:
 * Demonstrates method overriding in AutoHotkey v2 - replacing parent class methods
 * in child classes to provide specialized behavior while maintaining the same interface.
 * 
 * FEATURES:
 * - Method overriding basics
 * - Complete method replacement
 * - Partial overriding with super
 * - Overriding vs overloading
 * - Virtual method patterns
 * - Abstract method simulation
 * - Override best practices
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - Objects
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Method replacement in child classes
 * - Polymorphic behavior through overriding
 * - super keyword for partial overrides
 * - Same method signature requirement
 * - Dynamic dispatch of overridden methods
 * - Preserving interfaces while changing implementation
 * 
 * LEARNING POINTS:
 * 1. Child classes can replace parent methods
 * 2. Overridden methods have same name as parent
 * 3. Override provides specialized behavior
 * 4. Use super to extend rather than replace
 * 5. Overriding enables polymorphism
 * 6. Method signatures should match
 * 7. Override ToString() for custom string representation
 */

; ========================================
; EXAMPLE 1: Basic Method Overriding
; ========================================
; Replacing parent methods with child-specific implementations

class Animal {
    Name := ""
    Species := ""

    __New(name, species) {
        this.Name := name
        this.Species := species
    }

    MakeSound() {
        return this.Name " makes a generic animal sound"
    }

    Move() {
        return this.Name " is moving"
    }

    Sleep() {
        return this.Name " is sleeping"
    }

    ToString() {
        return this.Name " the " this.Species
    }
}

class Dog extends Animal {
    __New(name) {
        super.__New(name, "Dog")
    }

    ; Override MakeSound with dog-specific implementation
    MakeSound() {
        return this.Name " barks: Woof! Woof!"
    }

    ; Override Move with dog-specific behavior
    Move() {
        return this.Name " runs on four legs"
    }

    ; Sleep is NOT overridden - uses parent implementation
}

class Bird extends Animal {
    __New(name) {
        super.__New(name, "Bird")
    }

    ; Override MakeSound
    MakeSound() {
        return this.Name " chirps: Tweet! Tweet!"
    }

    ; Override Move
    Move() {
        return this.Name " flies through the air"
    }

    ; Override Sleep with bird-specific behavior
    Sleep() {
        return this.Name " sleeps perched on a branch"
    }
}

class Fish extends Animal {
    __New(name) {
        super.__New(name, "Fish")
    }

    ; Override MakeSound - fish are quiet
    MakeSound() {
        return this.Name " makes bubbles (silent)"
    }

    ; Override Move
    Move() {
        return this.Name " swims through water"
    }
}

; Create different animals
dog := Dog("Buddy")
bird := Bird("Tweety")
fish := Fish("Nemo")

; Same method call, different behavior (polymorphism)
MsgBox(dog.MakeSound())   ; "Buddy barks: Woof! Woof!"
MsgBox(bird.MakeSound())  ; "Tweety chirps: Tweet! Tweet!"
MsgBox(fish.MakeSound())  ; "Nemo makes bubbles (silent)"

MsgBox(dog.Move())   ; "Buddy runs on four legs"
MsgBox(bird.Move())  ; "Tweety flies through the air"
MsgBox(fish.Move())  ; "Nemo swims through water"

; Sleep - Dog uses parent, Bird overrides
MsgBox(dog.Sleep())   ; Uses parent implementation
MsgBox(bird.Sleep())  ; Uses overridden implementation

; ========================================
; EXAMPLE 2: Complete vs Partial Override
; ========================================
; Demonstrating when to completely replace vs extend

class Shape {
    X := 0
    Y := 0
    Color := "Black"

    __New(x, y, color := "Black") {
        this.X := x
        this.Y := y
        this.Color := color
    }

    Draw() {
        return "Drawing shape at (" this.X ", " this.Y ") in " this.Color
    }

    Area() {
        return 0  ; Base shape has no area
    }

    GetInfo() {
        return "Shape at (" this.X ", " this.Y ")`nColor: " this.Color "`nArea: " this.Area()
    }
}

class Circle extends Shape {
    Radius := 0

    __New(x, y, radius, color := "Black") {
        super.__New(x, y, color)
        this.Radius := radius
    }

    ; Complete override - doesn't use parent
    Area() {
        return 3.14159 * this.Radius ** 2
    }

    ; Partial override - extends parent
    Draw() {
        parentDraw := super.Draw()
        return parentDraw " (Circle, radius=" this.Radius ")"
    }

    ; GetInfo is NOT overridden - uses parent implementation
}

class Rectangle extends Shape {
    Width := 0
    Height := 0

    __New(x, y, width, height, color := "Black") {
        super.__New(x, y, color)
        this.Width := width
        this.Height := height
    }

    ; Complete override
    Area() {
        return this.Width * this.Height
    }

    ; Partial override
    Draw() {
        parentDraw := super.Draw()
        return parentDraw " (Rectangle, " this.Width "x" this.Height ")"
    }
}

; Create shapes
circle := Circle(10, 20, 5, "Red")
rectangle := Rectangle(30, 40, 10, 5, "Blue")

; Area is completely overridden
MsgBox("Circle area: " Round(circle.Area(), 2))
MsgBox("Rectangle area: " rectangle.Area())

; Draw is partially overridden
MsgBox(circle.Draw())
MsgBox(rectangle.Draw())

; GetInfo uses parent implementation with overridden Area
MsgBox(circle.GetInfo())
MsgBox(rectangle.GetInfo())

; ========================================
; EXAMPLE 3: Overriding ToString()
; ========================================
; Standard pattern for custom string representation

class Product {
    ID := ""
    Name := ""
    Price := 0

    __New(id, name, price) {
        this.ID := id
        this.Name := name
        this.Price := price
    }

    ToString() {
        return this.Name " ($" this.Price ")"
    }

    GetDetails() {
        return "Product: " this.ToString() "`nID: " this.ID
    }
}

class Book extends Product {
    Author := ""
    ISBN := ""

    __New(id, name, price, author, isbn) {
        super.__New(id, name, price)
        this.Author := author
        this.ISBN := isbn
    }

    ; Override ToString with book-specific format
    ToString() {
        return '"' this.Name '" by ' this.Author ' ($' this.Price ')'
    }

    GetDetails() {
        return "Book: " this.ToString()
            . "`nID: " this.ID
            . "`nISBN: " this.ISBN
    }
}

class Electronics extends Product {
    Brand := ""
    Warranty := 0

    __New(id, name, price, brand, warranty) {
        super.__New(id, name, price)
        this.Brand := brand
        this.Warranty := warranty
    }

    ; Override ToString
    ToString() {
        return this.Brand " " this.Name " ($" this.Price ") - " this.Warranty " year warranty"
    }

    GetDetails() {
        return "Electronics: " this.ToString() "`nID: " this.ID
    }
}

; Create products
book := Book("B001", "AutoHotkey Guide", 29.99, "John Doe", "978-1234567890")
laptop := Electronics("E001", "ThinkPad X1", 1299.99, "Lenovo", 3)

; ToString() is polymorphic
MsgBox(book.ToString())
MsgBox(laptop.ToString())

; GetDetails() uses overridden ToString()
MsgBox(book.GetDetails())
MsgBox(laptop.GetDetails())

; ========================================
; EXAMPLE 4: Polymorphic Collections
; ========================================
; Using overridden methods with collections

class Employee {
    Name := ""
    ID := ""
    BaseSalary := 0

    __New(name, id, baseSalary) {
        this.Name := name
        this.ID := id
        this.BaseSalary := baseSalary
    }

    CalculatePay() {
        return this.BaseSalary
    }

    GetType() {
        return "Employee"
    }

    ToString() {
        return this.Name " (" this.ID ") - " this.GetType()
    }
}

class HourlyEmployee extends Employee {
    HourlyRate := 0
    HoursWorked := 0

    __New(name, id, hourlyRate) {
        super.__New(name, id, 0)
        this.HourlyRate := hourlyRate
        this.HoursWorked := 0
    }

    LogHours(hours) {
        this.HoursWorked += hours
    }

    ; Override CalculatePay
    CalculatePay() {
        regularPay := this.HourlyRate * Min(this.HoursWorked, 40)
        overtimePay := this.HourlyRate * 1.5 * Max(0, this.HoursWorked - 40)
        return regularPay + overtimePay
    }

    ; Override GetType
    GetType() {
        return "Hourly Employee"
    }
}

class SalariedEmployee extends Employee {
    ; Override CalculatePay - just returns base salary
    CalculatePay() {
        return this.BaseSalary
    }

    ; Override GetType
    GetType() {
        return "Salaried Employee"
    }
}

class CommissionEmployee extends Employee {
    CommissionRate := 0
    Sales := 0

    __New(name, id, baseSalary, commissionRate) {
        super.__New(name, id, baseSalary)
        this.CommissionRate := commissionRate
        this.Sales := 0
    }

    AddSale(amount) {
        this.Sales += amount
    }

    ; Override CalculatePay
    CalculatePay() {
        return this.BaseSalary + (this.Sales * this.CommissionRate)
    }

    ; Override GetType
    GetType() {
        return "Commission Employee"
    }
}

; Create employee collection
employees := []

hourly := HourlyEmployee("Alice", "H001", 25)
hourly.LogHours(45)
employees.Push(hourly)

salaried := SalariedEmployee("Bob", "S001", "B002", 5000)
employees.Push(salaried)

commission := CommissionEmployee("Charlie", "C001", 3000, 0.1)
commission.AddSale(50000)
employees.Push(commission)

; Process payroll - polymorphic behavior
payroll := "=== PAYROLL REPORT ===`n`n"
totalPay := 0

for emp in employees {
    pay := emp.CalculatePay()
    totalPay += pay
    payroll .= emp.ToString() ": $" Round(pay, 2) "`n"
}

payroll .= "`n Total Payroll: $" Round(totalPay, 2)
MsgBox(payroll)

; ========================================
; EXAMPLE 5: Abstract Method Pattern
; ========================================
; Simulating abstract methods that must be overridden

class AbstractDocument {
    Title := ""
    Author := ""

    __New(title, author) {
        this.Title := title
        this.Author := author
    }

    ; "Abstract" method - throws error if not overridden
    Save() {
        throw Error("Save() must be overridden in derived class")
    }

    ; "Abstract" method
    Load() {
        throw Error("Load() must be overridden in derived class")
    }

    ; Concrete method - doesn't require override
    GetInfo() {
        return "Title: " this.Title "`nAuthor: " this.Author
    }
}

class TextDocument extends AbstractDocument {
    Content := ""
    FilePath := ""

    __New(title, author, filePath) {
        super.__New(title, author)
        this.FilePath := filePath
        this.Content := ""
    }

    ; Override required Save method
    Save() {
        ; Simulated file save
        result := "Saving text document to: " this.FilePath
        result .= "`nContent length: " StrLen(this.Content) " characters"
        return result
    }

    ; Override required Load method
    Load() {
        ; Simulated file load
        this.Content := "Loaded content from " this.FilePath
        return "Text document loaded successfully"
    }
}

class PDFDocument extends AbstractDocument {
    Pages := 0
    FilePath := ""

    __New(title, author, filePath) {
        super.__New(title, author)
        this.FilePath := filePath
        this.Pages := 0
    }

    ; Override required Save method
    Save() {
        result := "Saving PDF document to: " this.FilePath
        result .= "`nPages: " this.Pages
        return result
    }

    ; Override required Load method
    Load() {
        this.Pages := 10  ; Simulated
        return "PDF document loaded: " this.Pages " pages"
    }
}

; Create documents
textDoc := TextDocument("My Story", "John Doe", "story.txt")
textDoc.Content := "Once upon a time..."
MsgBox(textDoc.Save())

pdfDoc := PDFDocument("Report", "Jane Smith", "report.pdf")
pdfDoc.Pages := 25
MsgBox(pdfDoc.Save())

; Trying to use abstract class directly would fail
try {
    abstract := AbstractDocument("Test", "Test")
    abstract.Save()  ; This throws error
} catch Error as err {
    MsgBox("Error: " err.Message)
}

; ========================================
; EXAMPLE 6: Override with Parameter Variations
; ========================================
; Handling different parameter patterns in overrides

class Formatter {
    Format(value) {
        return String(value)
    }

    FormatList(values*) {
        result := ""
        for value in values {
            result .= this.Format(value) "`n"
        }
        return result
    }
}

class NumberFormatter extends Formatter {
    DecimalPlaces := 2

    __New(decimalPlaces := 2) {
        this.DecimalPlaces := decimalPlaces
    }

    ; Override with same parameter pattern
    Format(value) {
        if (!IsNumber(value))
            return "NaN"

        return Round(value, this.DecimalPlaces)
    }
}

class CurrencyFormatter extends NumberFormatter {
    Symbol := "$"

    __New(symbol := "$", decimalPlaces := 2) {
        super.__New(decimalPlaces)
        this.Symbol := symbol
    }

    ; Override Format
    Format(value) {
        ; Use parent formatting
        formatted := super.Format(value)
        return this.Symbol formatted
    }
}

class PercentageFormatter extends NumberFormatter {
    __New(decimalPlaces := 1) {
        super.__New(decimalPlaces)
    }

    ; Override Format
    Format(value) {
        ; Convert to percentage
        percentValue := value * 100
        formatted := super.Format(percentValue)
        return formatted "%"
    }
}

; Use different formatters
numFormatter := NumberFormatter(3)
MsgBox(numFormatter.Format(3.14159))  ; "3.142"

currFormatter := CurrencyFormatter("$", 2)
MsgBox(currFormatter.Format(1234.567))  ; "$1234.57"

pctFormatter := PercentageFormatter(2)
MsgBox(pctFormatter.Format(0.12345))  ; "12.35%"

; FormatList uses overridden Format
values := [3.14159, 2.71828, 1.41421]
MsgBox(currFormatter.FormatList(values*))

; ========================================
; EXAMPLE 7: Complex Override Patterns
; ========================================
; Advanced override scenarios

class DataProcessor {
    Name := ""
    ProcessCount := 0

    __New(name) {
        this.Name := name
    }

    Process(data) {
        this.ProcessCount++
        return this.PreProcess(data)
            . this.MainProcess(data)
            . this.PostProcess(data)
    }

    ; Template methods for overriding
    PreProcess(data) {
        return "Pre: Starting process`n"
    }

    MainProcess(data) {
        return "Main: Processing " data "`n"
    }

    PostProcess(data) {
        return "Post: Finishing process`n"
    }

    GetStats() {
        return this.Name " - Processed: " this.ProcessCount
    }
}

class XMLProcessor extends DataProcessor {
    __New() {
        super.__New("XML Processor")
    }

    ; Override template methods
    PreProcess(data) {
        return "Pre: Validating XML structure`n"
    }

    MainProcess(data) {
        return "Main: Parsing XML data: " data "`n"
    }

    PostProcess(data) {
        return "Post: XML processing complete`n"
    }
}

class JSONProcessor extends DataProcessor {
    __New() {
        super.__New("JSON Processor")
    }

    ; Override template methods
    PreProcess(data) {
        return "Pre: Validating JSON syntax`n"
    }

    MainProcess(data) {
        return "Main: Parsing JSON data: " data "`n"
    }

    PostProcess(data) {
        return "Post: JSON processing complete`n"
    }
}

; Use processors - Process() calls overridden methods
xmlProc := XMLProcessor()
jsonProc := JSONProcessor()

MsgBox(xmlProc.Process("<root>data</root>"))
MsgBox(jsonProc.Process('{"key": "value"}'))

MsgBox(xmlProc.GetStats() "`n" jsonProc.GetStats())

MsgBox("=== OOP Method Override Examples Complete ===`n`n"
    . "This file demonstrated:`n"
    . "- Basic method overriding`n"
    . "- Complete vs partial overrides`n"
    . "- ToString() override pattern`n"
    . "- Polymorphic collections`n"
    . "- Abstract method simulation`n"
    . "- Override with parameters`n"
    . "- Template method pattern")
