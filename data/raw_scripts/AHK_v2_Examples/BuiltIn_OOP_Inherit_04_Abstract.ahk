#Requires AutoHotkey v2.0
/**
 * BuiltIn_OOP_Inherit_04_Abstract.ahk
 *
 * DESCRIPTION:
 * Demonstrates abstract class patterns in AutoHotkey v2. While AHK v2 doesn't have
 * formal abstract keywords, this shows how to simulate abstract classes and methods
 * to enforce implementation in derived classes.
 *
 * FEATURES:
 * - Abstract class simulation
 * - Abstract method patterns
 * - Enforcing method implementation
 * - Template method pattern
 * - Interface-like patterns
 * - Protected constructor pattern
 * - Contract enforcement
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - Objects
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - Error throwing for unimplemented methods
 * - Type checking with HasBase()
 * - Constructor validation
 * - Method contract enforcement
 * - Template method design pattern
 * - Polymorphism through abstract interfaces
 *
 * LEARNING POINTS:
 * 1. Abstract classes define contracts for children
 * 2. Abstract methods must be overridden
 * 3. Use Error() to enforce implementation
 * 4. Template methods provide structure
 * 5. Abstract classes shouldn't be instantiated directly
 * 6. Enables polymorphism with guaranteed interface
 * 7. Documents required child class behavior
 */

; ========================================
; EXAMPLE 1: Basic Abstract Class Pattern
; ========================================
; Creating a class that can't be instantiated directly

class AbstractAnimal {
    Name := ""
    Species := ""

    __New(name, species) {
        ; Prevent direct instantiation
        if (this.__Class = "AbstractAnimal")
            throw Error("Cannot instantiate abstract class AbstractAnimal")

        this.Name := name
        this.Species := species
    }

    ; Abstract method - must be overridden
    MakeSound() {
        throw Error("Abstract method MakeSound() must be implemented in " this.__Class)
    }

    ; Abstract method
    GetDiet() {
        throw Error("Abstract method GetDiet() must be implemented in " this.__Class)
    }

    ; Concrete method - can be used as-is
    Introduce() {
        return "I am " this.Name ", a " this.Species
    }

    ; Concrete method using abstract methods
    FullDescription() {
        return this.Introduce()
             . "`nSound: " this.MakeSound()
             . "`nDiet: " this.GetDiet()
    }
}

class Dog extends AbstractAnimal {
    __New(name) {
        super.__New(name, "Dog")
    }

    ; Implement required abstract methods
    MakeSound() {
        return "Woof!"
    }

    GetDiet() {
        return "Omnivore"
    }
}

class Cat extends AbstractAnimal {
    __New(name) {
        super.__New(name, "Cat")
    }

    ; Implement required abstract methods
    MakeSound() {
        return "Meow!"
    }

    GetDiet() {
        return "Carnivore"
    }
}

; Cannot create AbstractAnimal directly
try {
    animal := AbstractAnimal("Generic", "Unknown")
} catch Error as err {
    MsgBox("Error: " err.Message)
}

; Can create concrete implementations
dog := Dog("Buddy")
cat := Cat("Whiskers")

MsgBox(dog.FullDescription())
MsgBox(cat.FullDescription())

; Forgetting to implement abstract method causes error
class IncompleteBird extends AbstractAnimal {
    __New(name) {
        super.__New(name, "Bird")
    }

    ; Only implement one abstract method
    MakeSound() {
        return "Tweet!"
    }

    ; GetDiet() is NOT implemented
}

try {
    bird := IncompleteBird("Tweety")
    MsgBox(bird.FullDescription())  ; This will fail when GetDiet() is called
} catch Error as err {
    MsgBox("Error: " err.Message)
}

; ========================================
; EXAMPLE 2: Template Method Pattern
; ========================================
; Abstract class defines algorithm structure, children implement steps

class AbstractReportGenerator {
    ReportTitle := ""
    Data := []

    __New(title, data := "") {
        if (this.__Class = "AbstractReportGenerator")
            throw Error("Cannot instantiate abstract class AbstractReportGenerator")

        this.ReportTitle := title
        this.Data := data != "" ? data : []
    }

    ; Template method - defines the algorithm structure
    GenerateReport() {
        report := this.GenerateHeader()
        report .= this.GenerateBody()
        report .= this.GenerateFooter()
        return report
    }

    ; Abstract methods - must be implemented by children
    GenerateHeader() {
        throw Error("GenerateHeader() must be implemented")
    }

    GenerateBody() {
        throw Error("GenerateBody() must be implemented")
    }

    GenerateFooter() {
        throw Error("GenerateFooter() must be implemented")
    }

    ; Concrete helper method
    GetTimestamp() {
        return FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
    }
}

class HTMLReport extends AbstractReportGenerator {
    __New(title, data) {
        super.__New(title, data)
    }

    ; Implement abstract methods
    GenerateHeader() {
        return "<html>`n<head><title>" this.ReportTitle "</title></head>`n<body>`n"
             . "<h1>" this.ReportTitle "</h1>`n"
    }

    GenerateBody() {
        body := "<div class='content'>`n"
        for item in this.Data {
            body .= "  <p>" item "</p>`n"
        }
        body .= "</div>`n"
        return body
    }

    GenerateFooter() {
        return "<footer>Generated: " this.GetTimestamp() "</footer>`n"
             . "</body>`n</html>"
    }
}

class TextReport extends AbstractReportGenerator {
    __New(title, data) {
        super.__New(title, data)
    }

    ; Implement abstract methods
    GenerateHeader() {
        header := "=" StrRepeat("=", StrLen(this.ReportTitle)) "=`n"
        header .= " " this.ReportTitle " `n"
        header .= "=" StrRepeat("=", StrLen(this.ReportTitle)) "=`n`n"
        return header
    }

    GenerateBody() {
        body := "CONTENT:`n"
        for index, item in this.Data {
            body .= index ". " item "`n"
        }
        body .= "`n"
        return body
    }

    GenerateFooter() {
        return "---`nGenerated: " this.GetTimestamp()
    }
}

StrRepeat(str, count) {
    result := ""
    Loop count
        result .= str
    return result
}

; Use template method pattern
data := ["First item", "Second item", "Third item"]

htmlReport := HTMLReport("Monthly Report", data)
MsgBox(htmlReport.GenerateReport())

textReport := TextReport("Monthly Report", data)
MsgBox(textReport.GenerateReport())

; ========================================
; EXAMPLE 3: Interface-Like Pattern
; ========================================
; Abstract class defining an interface contract

class IComparable {
    __New() {
        if (this.__Class = "IComparable")
            throw Error("Cannot instantiate interface IComparable")
    }

    ; Abstract method - compare to another object
    CompareTo(other) {
        throw Error("CompareTo() must be implemented")
    }

    ; Concrete methods built on abstract method
    IsEqualTo(other) {
        return this.CompareTo(other) = 0
    }

    IsGreaterThan(other) {
        return this.CompareTo(other) > 0
    }

    IsLessThan(other) {
        return this.CompareTo(other) < 0
    }
}

class Version extends IComparable {
    Major := 0
    Minor := 0
    Patch := 0

    __New(major, minor, patch) {
        super.__New()
        this.Major := major
        this.Minor := minor
        this.Patch := patch
    }

    ; Implement required abstract method
    CompareTo(other) {
        if (!other.HasBase(Version.Prototype))
            throw TypeError("Can only compare to Version objects")

        if (this.Major != other.Major)
            return this.Major - other.Major

        if (this.Minor != other.Minor)
            return this.Minor - other.Minor

        return this.Patch - other.Patch
    }

    ToString() {
        return this.Major "." this.Minor "." this.Patch
    }
}

class Priority extends IComparable {
    static LOW := 1
    static MEDIUM := 2
    static HIGH := 3
    static CRITICAL := 4

    Value := 0
    Label := ""

    __New(value, label) {
        super.__New()
        this.Value := value
        this.Label := label
    }

    ; Implement required abstract method
    CompareTo(other) {
        if (!other.HasBase(Priority.Prototype))
            throw TypeError("Can only compare to Priority objects")

        return this.Value - other.Value
    }

    ToString() {
        return this.Label " (" this.Value ")"
    }
}

; Use comparable objects
v1 := Version(1, 2, 3)
v2 := Version(1, 3, 0)
v3 := Version(1, 2, 3)

MsgBox("v1 (" v1.ToString() ") vs v2 (" v2.ToString() "):`n"
     . "Equal? " v1.IsEqualTo(v2) "`n"
     . "Greater? " v1.IsGreaterThan(v2) "`n"
     . "Less? " v1.IsLessThan(v2))

MsgBox("v1 (" v1.ToString() ") vs v3 (" v3.ToString() "):`n"
     . "Equal? " v1.IsEqualTo(v3))

p1 := Priority(Priority.HIGH, "High")
p2 := Priority(Priority.MEDIUM, "Medium")

MsgBox("Priority comparison:`n"
     . p1.ToString() " > " p2.ToString() ": " p1.IsGreaterThan(p2))

; ========================================
; EXAMPLE 4: Abstract Data Store Pattern
; ========================================
; Abstract class for data persistence with multiple implementations

class AbstractDataStore {
    StoreName := ""

    __New(storeName) {
        if (this.__Class = "AbstractDataStore")
            throw Error("Cannot instantiate abstract class AbstractDataStore")

        this.StoreName := storeName
    }

    ; Abstract CRUD operations
    Create(key, value) {
        throw Error("Create() must be implemented")
    }

    Read(key) {
        throw Error("Read() must be implemented")
    }

    Update(key, value) {
        throw Error("Update() must be implemented")
    }

    Delete(key) {
        throw Error("Delete() must be implemented")
    }

    Exists(key) {
        throw Error("Exists() must be implemented")
    }

    ; Concrete helper method
    ValidateKey(key) {
        if (Trim(key) = "")
            throw ValueError("Key cannot be empty")
        return true
    }
}

class MemoryStore extends AbstractDataStore {
    _data := Map()

    __New(storeName) {
        super.__New(storeName)
        this._data := Map()
    }

    Create(key, value) {
        this.ValidateKey(key)
        if (this._data.Has(key))
            throw Error("Key already exists: " key)

        this._data[key] := value
        return "Created: " key
    }

    Read(key) {
        this.ValidateKey(key)
        if (!this._data.Has(key))
            throw Error("Key not found: " key)

        return this._data[key]
    }

    Update(key, value) {
        this.ValidateKey(key)
        if (!this._data.Has(key))
            throw Error("Key not found: " key)

        this._data[key] := value
        return "Updated: " key
    }

    Delete(key) {
        this.ValidateKey(key)
        if (!this._data.Has(key))
            throw Error("Key not found: " key)

        this._data.Delete(key)
        return "Deleted: " key
    }

    Exists(key) {
        return this._data.Has(key)
    }
}

class FileStore extends AbstractDataStore {
    _basePath := ""

    __New(storeName, basePath) {
        super.__New(storeName)
        this._basePath := basePath
    }

    Create(key, value) {
        this.ValidateKey(key)
        filePath := this._GetFilePath(key)
        return "Would create file: " filePath " with value: " value
    }

    Read(key) {
        this.ValidateKey(key)
        filePath := this._GetFilePath(key)
        return "Would read from file: " filePath
    }

    Update(key, value) {
        this.ValidateKey(key)
        filePath := this._GetFilePath(key)
        return "Would update file: " filePath
    }

    Delete(key) {
        this.ValidateKey(key)
        filePath := this._GetFilePath(key)
        return "Would delete file: " filePath
    }

    Exists(key) {
        filePath := this._GetFilePath(key)
        return FileExist(filePath) != ""
    }

    _GetFilePath(key) {
        return this._basePath "\" key ".dat"
    }
}

; Use different store implementations
memStore := MemoryStore("UserCache")
fileStore := FileStore("ConfigStore", "C:\Data")

; Same interface, different implementation
MsgBox(memStore.Create("user1", "Alice"))
MsgBox(fileStore.Create("config1", "Settings"))

MsgBox("Memory store has user1: " memStore.Exists("user1"))
MsgBox("File store has config1: " fileStore.Exists("config1"))

; ========================================
; EXAMPLE 5: Abstract Validator Pattern
; ========================================
; Framework for validation with abstract rules

class AbstractValidator {
    Rules := []
    ErrorMessages := []

    __New() {
        if (this.__Class = "AbstractValidator")
            throw Error("Cannot instantiate abstract class AbstractValidator")

        this.Rules := []
        this.ErrorMessages := []
    }

    ; Abstract method - define validation rules
    DefineRules() {
        throw Error("DefineRules() must be implemented")
    }

    ; Template method - validation process
    Validate(value) {
        this.ErrorMessages := []

        ; Ensure rules are defined
        if (this.Rules.Length = 0)
            this.DefineRules()

        ; Run all validation rules
        for rule in this.Rules {
            if (!rule.Check(value))
                this.ErrorMessages.Push(rule.Message)
        }

        return this.IsValid()
    }

    IsValid() {
        return this.ErrorMessages.Length = 0
    }

    GetErrors() {
        return this.ErrorMessages
    }

    AddRule(checkFunc, message) {
        this.Rules.Push({Check: checkFunc, Message: message})
    }
}

class EmailValidator extends AbstractValidator {
    DefineRules() {
        ; Define email-specific validation rules
        this.AddRule(
            (v) => v != "" && Trim(v) != "",
            "Email is required"
        )

        this.AddRule(
            (v) => StrLen(v) <= 255,
            "Email must be 255 characters or less"
        )

        this.AddRule(
            (v) => RegExMatch(v, "^[^@]+@[^@]+\.[^@]+$"),
            "Email format is invalid"
        )

        this.AddRule(
            (v) => !RegExMatch(v, "\s"),
            "Email cannot contain spaces"
        )
    }
}

class PasswordValidator extends AbstractValidator {
    MinLength := 8

    __New(minLength := 8) {
        super.__New()
        this.MinLength := minLength
    }

    DefineRules() {
        ; Define password-specific validation rules
        this.AddRule(
            (v) => StrLen(v) >= this.MinLength,
            "Password must be at least " this.MinLength " characters"
        )

        this.AddRule(
            (v) => RegExMatch(v, "[A-Z]"),
            "Password must contain at least one uppercase letter"
        )

        this.AddRule(
            (v) => RegExMatch(v, "[a-z]"),
            "Password must contain at least one lowercase letter"
        )

        this.AddRule(
            (v) => RegExMatch(v, "[0-9]"),
            "Password must contain at least one number"
        )

        this.AddRule(
            (v) => RegExMatch(v, "[^A-Za-z0-9]"),
            "Password must contain at least one special character"
        )
    }
}

; Use validators
emailValidator := EmailValidator()
passwordValidator := PasswordValidator(10)

; Validate email
if (emailValidator.Validate("invalid.email")) {
    MsgBox("Email is valid")
} else {
    msg := "Email validation failed:`n"
    for error in emailValidator.GetErrors()
        msg .= "- " error "`n"
    MsgBox(msg)
}

if (emailValidator.Validate("valid@example.com")) {
    MsgBox("Email is valid")
}

; Validate password
if (passwordValidator.Validate("weak")) {
    MsgBox("Password is valid")
} else {
    msg := "Password validation failed:`n"
    for error in passwordValidator.GetErrors()
        msg .= "- " error "`n"
    MsgBox(msg)
}

if (passwordValidator.Validate("StrongPass123!")) {
    MsgBox("Password is valid")
}

; ========================================
; EXAMPLE 6: Abstract Command Pattern
; ========================================
; Command pattern with abstract base

class AbstractCommand {
    Name := ""
    Description := ""

    __New(name, description) {
        if (this.__Class = "AbstractCommand")
            throw Error("Cannot instantiate abstract class AbstractCommand")

        this.Name := name
        this.Description := description
    }

    ; Abstract methods
    Execute() {
        throw Error("Execute() must be implemented")
    }

    Undo() {
        throw Error("Undo() must be implemented")
    }

    CanUndo() {
        return true  ; Default: commands can be undone
    }
}

class FileCreateCommand extends AbstractCommand {
    FilePath := ""
    WasCreated := false

    __New(filePath) {
        super.__New("CreateFile", "Create a new file")
        this.FilePath := filePath
    }

    Execute() {
        ; Simulated file creation
        this.WasCreated := true
        return "Created file: " this.FilePath
    }

    Undo() {
        if (!this.WasCreated)
            return "Nothing to undo"

        ; Simulated file deletion
        this.WasCreated := false
        return "Deleted file: " this.FilePath
    }
}

class TextAppendCommand extends AbstractCommand {
    FilePath := ""
    Text := ""

    __New(filePath, text) {
        super.__New("AppendText", "Append text to file")
        this.FilePath := filePath
        this.Text := text
    }

    Execute() {
        return "Appended '" this.Text "' to " this.FilePath
    }

    Undo() {
        return "Removed '" this.Text "' from " this.FilePath
    }
}

class IrreversibleCommand extends AbstractCommand {
    __New() {
        super.__New("Irreversible", "Cannot be undone")
    }

    Execute() {
        return "Executed irreversible command"
    }

    Undo() {
        throw Error("This command cannot be undone")
    }

    CanUndo() {
        return false
    }
}

; Use command pattern
createCmd := FileCreateCommand("test.txt")
appendCmd := TextAppendCommand("test.txt", "Hello World")
irreversible := IrreversibleCommand()

MsgBox(createCmd.Execute())
MsgBox(appendCmd.Execute())

if (createCmd.CanUndo()) {
    MsgBox(createCmd.Undo())
}

if (!irreversible.CanUndo()) {
    MsgBox("Warning: " irreversible.Name " cannot be undone")
}

; ========================================
; EXAMPLE 7: Abstract Factory Pattern
; ========================================
; Abstract factory with abstract products

class AbstractUIFactory {
    __New() {
        if (this.__Class = "AbstractUIFactory")
            throw Error("Cannot instantiate abstract class AbstractUIFactory")
    }

    CreateButton(text) {
        throw Error("CreateButton() must be implemented")
    }

    CreateTextBox(defaultText) {
        throw Error("CreateTextBox() must be implemented")
    }

    CreateLabel(text) {
        throw Error("CreateLabel() must be implemented")
    }
}

class WindowsUIFactory extends AbstractUIFactory {
    CreateButton(text) {
        return {Type: "WindowsButton", Text: text, Style: "Win32"}
    }

    CreateTextBox(defaultText) {
        return {Type: "WindowsTextBox", Text: defaultText, Style: "Win32"}
    }

    CreateLabel(text) {
        return {Type: "WindowsLabel", Text: text, Style: "Win32"}
    }
}

class MacUIFactory extends AbstractUIFactory {
    CreateButton(text) {
        return {Type: "MacButton", Text: text, Style: "Aqua"}
    }

    CreateTextBox(defaultText) {
        return {Type: "MacTextBox", Text: defaultText, Style: "Aqua"}
    }

    CreateLabel(text) {
        return {Type: "MacLabel", Text: text, Style: "Aqua"}
    }
}

; Use abstract factory
CreateUI(factory) {
    button := factory.CreateButton("Click Me")
    textBox := factory.CreateTextBox("Enter text...")
    label := factory.CreateLabel("Name:")

    result := "UI Components Created:`n`n"
    result .= "Button: " button.Type " (" button.Style ")`n"
    result .= "TextBox: " textBox.Type " (" textBox.Style ")`n"
    result .= "Label: " label.Type " (" label.Style ")"

    return result
}

winFactory := WindowsUIFactory()
macFactory := MacUIFactory()

MsgBox(CreateUI(winFactory))
MsgBox(CreateUI(macFactory))

MsgBox("=== OOP Abstract Patterns Examples Complete ===`n`n"
     . "This file demonstrated:`n"
     . "- Abstract class simulation`n"
     . "- Template method pattern`n"
     . "- Interface-like patterns`n"
     . "- Abstract data store pattern`n"
     . "- Abstract validator pattern`n"
     . "- Abstract command pattern`n"
     . "- Abstract factory pattern")
