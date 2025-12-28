#Requires AutoHotkey v2.0

/**
 * BuiltIn_OOP_Class_03_Constructor.ahk
 * 
 * DESCRIPTION:
 * Demonstrates the __New constructor method in AutoHotkey v2 classes, including
 * initialization patterns, parameter handling, validation, and advanced constructor techniques.
 * 
 * FEATURES:
 * - Basic constructor syntax
 * - Constructor parameters (required and optional)
 * - Default parameter values
 * - Parameter validation in constructors
 * - Constructor chaining
 * - Factory methods as constructor alternatives
 * - Constructor error handling
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - Objects
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - __New() special method
 * - Optional parameters with := default values
 * - Parameter validation with throw
 * - Variadic parameters (params*)
 * - Static methods for factory patterns
 * - Constructor return values
 * 
 * LEARNING POINTS:
 * 1. Constructors initialize objects when created
 * 2. __New is called automatically on instantiation
 * 3. Constructors can validate input parameters
 * 4. Optional parameters provide flexibility
 * 5. Factory methods offer alternative creation patterns
 * 6. Constructors can throw errors for invalid input
 * 7. Proper initialization prevents bugs
 */

; ========================================
; EXAMPLE 1: Basic Constructor Patterns
; ========================================
; Various ways to define and use constructors

class Book {
    Title := ""
    Author := ""
    ISBN := ""
    Pages := 0
    Published := 0

    ; Constructor with all required parameters
    __New(title, author, isbn, pages, published) {
        this.Title := title
        this.Author := author
        this.ISBN := isbn
        this.Pages := pages
        this.Published := published
    }

    ToString() {
        return Format('"{}" by {} ({}), {} pages, Published: {}',
            this.Title, this.Author, this.ISBN, this.Pages, this.Published)
    }
}

class Magazine {
    Title := ""
    Issue := 0
    Month := ""
    Year := 0

    ; Constructor with optional parameters
    __New(title, issue := 1, month := "", year := 0) {
        this.Title := title
        this.Issue := issue
        this.Month := month != "" ? month : FormatTime(A_Now, "MMMM")
        this.Year := year != 0 ? year : FormatTime(A_Now, "yyyy")
    }

    ToString() {
        return Format("{} - Issue {} ({} {})", this.Title, this.Issue, this.Month, this.Year)
    }
}

; Create objects using constructors
book := Book("The Great Gatsby", "F. Scott Fitzgerald", "978-0-7432-7356-5", 180, 1925)
MsgBox(book.ToString())

; Using optional parameters
mag1 := Magazine("Tech Monthly")
mag2 := Magazine("Science Weekly", 42, "November", 2024)
MsgBox(mag1.ToString() "`n" mag2.ToString())

; ========================================
; EXAMPLE 2: Constructor with Validation
; ========================================
; Validating parameters to ensure object integrity

class Person {
    Name := ""
    Age := 0
    Email := ""

    __New(name, age, email := "") {
        ; Validate name
        if (Trim(name) = "")
            throw ValueError("Name cannot be empty")

        if (StrLen(name) > 100)
            throw ValueError("Name is too long (max 100 characters)")

        ; Validate age
        if (!IsInteger(age))
            throw TypeError("Age must be an integer")

        if (age < 0 || age > 150)
            throw ValueError("Age must be between 0 and 150")

        ; Validate email if provided
        if (email != "" && !RegExMatch(email, "^[^@]+@[^@]+\.[^@]+$"))
            throw ValueError("Invalid email format")

        ; All validations passed - set properties
        this.Name := Trim(name)
        this.Age := age
        this.Email := email
    }

    ToString() {
        emailPart := this.Email != "" ? " (" this.Email ")" : ""
        return this.Name ", " this.Age " years old" emailPart
    }
}

; Valid person
try {
    person1 := Person("Alice Smith", 30, "alice@example.com")
    MsgBox("Created: " person1.ToString())
}

; Invalid age
try {
    person2 := Person("Bob", -5)
} catch ValueError as err {
    MsgBox("Error creating person: " err.Message)
}

; Invalid email
try {
    person3 := Person("Charlie", 25, "not-an-email")
} catch ValueError as err {
    MsgBox("Error creating person: " err.Message)
}

; Empty name
try {
    person4 := Person("", 40)
} catch ValueError as err {
    MsgBox("Error creating person: " err.Message)
}

; ========================================
; EXAMPLE 3: Constructor Overloading Simulation
; ========================================
; Using parameter inspection to simulate overloading

class Color {
    R := 0
    G := 0
    B := 0
    A := 255  ; Alpha channel

    ; Constructor that handles different parameter patterns
    __New(params*) {
        paramCount := params.Length

        ; No parameters - default black
        if (paramCount = 0) {
            this.R := 0
            this.G := 0
            this.B := 0
            this.A := 255
        }
        ; One parameter - grayscale or hex string
        else if (paramCount = 1) {
            if (IsInteger(params[1])) {
                ; Grayscale value
                val := Max(0, Min(255, params[1]))
                this.R := val
                this.G := val
                this.B := val
                this.A := 255
            } else {
                ; Hex string like "#FF5733" or "FF5733"
                this.ParseHex(params[1])
            }
        }
        ; Three parameters - RGB
        else if (paramCount = 3) {
            this.R := Max(0, Min(255, params[1]))
            this.G := Max(0, Min(255, params[2]))
            this.B := Max(0, Min(255, params[3]))
            this.A := 255
        }
        ; Four parameters - RGBA
        else if (paramCount = 4) {
            this.R := Max(0, Min(255, params[1]))
            this.G := Max(0, Min(255, params[2]))
            this.B := Max(0, Min(255, params[3]))
            this.A := Max(0, Min(255, params[4]))
        }
        else {
            throw ValueError("Invalid number of parameters for Color")
        }
    }

    ParseHex(hexStr) {
        hexStr := StrReplace(hexStr, "#", "")
        if (StrLen(hexStr) = 6) {
            this.R := Integer("0x" SubStr(hexStr, 1, 2))
            this.G := Integer("0x" SubStr(hexStr, 3, 2))
            this.B := Integer("0x" SubStr(hexStr, 5, 2))
            this.A := 255
        } else {
            throw ValueError("Invalid hex color format")
        }
    }

    ToHex() {
        return Format("#{:02X}{:02X}{:02X}", this.R, this.G, this.B)
    }

    ToString() {
        return Format("RGB({}, {}, {}) Alpha: {} - {}", this.R, this.G, this.B, this.A, this.ToHex())
    }
}

; Different construction methods
color1 := Color()                    ; Default black
color2 := Color(128)                 ; Grayscale
color3 := Color(255, 100, 50)        ; RGB
color4 := Color(200, 150, 100, 128)  ; RGBA
color5 := Color("#FF5733")           ; Hex string

MsgBox("Color 1: " color1.ToString() "`n"
    . "Color 2: " color2.ToString() "`n"
    . "Color 3: " color3.ToString() "`n"
    . "Color 4: " color4.ToString() "`n"
    . "Color 5: " color5.ToString())

; ========================================
; EXAMPLE 4: Factory Methods as Constructor Alternatives
; ========================================
; Static methods that create instances with specific configurations

class Database {
    Host := ""
    Port := 0
    Username := ""
    Password := ""
    DatabaseName := ""
    ConnectionString := ""

    __New(host, port, username, password, database) {
        this.Host := host
        this.Port := port
        this.Username := username
        this.Password := password
        this.DatabaseName := database
        this.ConnectionString := this._BuildConnectionString()
    }

    _BuildConnectionString() {
        return Format("Server={};Port={};Database={};Uid={};Pwd={};",
            this.Host, this.Port, this.DatabaseName, this.Username, this.Password)
    }

    ; Factory method for local development database
    static Local(database := "dev_db") {
        return Database("localhost", 3306, "root", "password", database)
    }

    ; Factory method for production database
    static Production(database) {
        return Database("prod-server.example.com", 3306, "prod_user", "secure_password", database)
    }

    ; Factory method for testing database
    static Testing() {
        return Database("test-server", 3306, "test_user", "test_pass", "test_db")
    }

    ; Factory method from configuration object
    static FromConfig(config) {
        return Database(
            config.Host,
            config.Port,
            config.Username,
            config.Password,
            config.DatabaseName
        )
    }

    ToString() {
        return Format("Database: {}@{}:{}/{}", this.Username, this.Host, this.Port, this.DatabaseName)
    }
}

; Using factory methods instead of constructors
devDb := Database.Local("my_app")
prodDb := Database.Production("my_app")
testDb := Database.Testing()

MsgBox("Development: " devDb.ToString() "`n"
    . "Production: " prodDb.ToString() "`n"
    . "Testing: " testDb.ToString())

; Using FromConfig factory
config := {
    Host: "custom-server.com",
    Port: 5432,
    Username: "custom_user",
    Password: "custom_pass",
    DatabaseName: "custom_db"
}
customDb := Database.FromConfig(config)
MsgBox("Custom: " customDb.ToString())

; ========================================
; EXAMPLE 5: Constructor with Complex Initialization
; ========================================
; Constructors that perform complex setup logic

class Logger {
    Name := ""
    Level := "INFO"
    Outputs := []
    Format := ""
    StartTime := ""
    LogCount := 0

    __New(name, level := "INFO") {
        ; Basic property initialization
        this.Name := name
        this.Level := this._ValidateLevel(level)
        this.StartTime := A_Now
        this.LogCount := 0

        ; Complex initialization
        this.Format := "[{timestamp}] [{level}] [{name}]: {message}"
        this.Outputs := []

        ; Add default console output
        this._AddDefaultOutputs()

        ; Log initialization
        this._LogInit()
    }

    _ValidateLevel(level) {
        validLevels := ["DEBUG", "INFO", "WARN", "ERROR"]
        level := StrUpper(level)

        for validLevel in validLevels {
            if (level = validLevel)
                return level
        }

        throw ValueError("Invalid log level: " level)
    }

    _AddDefaultOutputs() {
        ; Add default output handlers
        this.Outputs.Push({ type: "console", enabled: true })
    }

    _LogInit() {
        ; Log that logger was initialized
        this.LogCount++
        initMsg := Format("Logger '{}' initialized at level {}", this.Name, this.Level)
        ; In real implementation, would actually log this
    }

    Log(level, message) {
        this.LogCount++
        timestamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
        formattedMsg := StrReplace(this.Format, "{timestamp}", timestamp)
        formattedMsg := StrReplace(formattedMsg, "{level}", level)
        formattedMsg := StrReplace(formattedMsg, "{name}", this.Name)
        formattedMsg := StrReplace(formattedMsg, "{message}", message)
        return formattedMsg
    }

    Info(message) => this.Log("INFO", message)
    Debug(message) => this.Log("DEBUG", message)
    Warn(message) => this.Log("WARN", message)
    Error(message) => this.Log("ERROR", message)

    GetStats() {
        uptime := DateDiff(A_Now, this.StartTime, "Seconds")
        return Format("Logger: {}, Level: {}, Logs: {}, Uptime: {}s",
            this.Name, this.Level, this.LogCount, uptime)
    }
}

; Create logger with complex initialization
logger := Logger("MyApp", "DEBUG")
MsgBox(logger.Info("Application started"))
MsgBox(logger.Debug("Debug information"))
MsgBox(logger.GetStats())

; ========================================
; EXAMPLE 6: Constructor Chaining Pattern
; ========================================
; Using helper methods during construction

class Form {
    Title := ""
    Width := 0
    Height := 0
    Controls := []
    Styles := Map()
    Events := Map()

    __New(title, width := 800, height := 600) {
        this.Title := title
        this.Width := width
        this.Height := height
        this.Controls := []
        this.Styles := Map()
        this.Events := Map()

        ; Call initialization chain
        this._InitializeStyles()
        this._InitializeEvents()
        this._ApplyDefaults()
    }

    _InitializeStyles() {
        ; Set default styles
        this.Styles["BackgroundColor"] := "White"
        this.Styles["FontFamily"] := "Segoe UI"
        this.Styles["FontSize"] := 9
        this.Styles["Border"] := "Single"
    }

    _InitializeEvents() {
        ; Initialize event handlers
        this.Events["OnLoad"] := []
        this.Events["OnClose"] := []
        this.Events["OnResize"] := []
    }

    _ApplyDefaults() {
        ; Apply platform-specific defaults
        if (A_OSVersion >= "10.0") {
            this.Styles["FontFamily"] := "Segoe UI"
        } else {
            this.Styles["FontFamily"] := "Tahoma"
        }
    }

    AddControl(control) {
        this.Controls.Push(control)
        return this  ; Method chaining
    }

    SetStyle(key, value) {
        this.Styles[key] := value
        return this  ; Method chaining
    }

    ToString() {
        return Format("Form: '{}' ({}x{}), Controls: {}, Styles: {}",
            this.Title, this.Width, this.Height,
            this.Controls.Length, this.Styles.Count)
    }
}

; Create form with automatic initialization
form := Form("My Application", 1024, 768)
form.SetStyle("BackgroundColor", "LightGray")
    .SetStyle("FontSize", 10)
    .AddControl("Button1")
    .AddControl("TextBox1")

MsgBox(form.ToString())
MsgBox("Font Family: " form.Styles["FontFamily"])

; ========================================
; EXAMPLE 7: Constructor with Resource Management
; ========================================
; Constructors that acquire resources (with cleanup)

class FileHandler {
    FilePath := ""
    Mode := ""
    Handle := 0
    IsOpen := false
    BytesProcessed := 0
    Created := ""

    __New(filePath, mode := "r") {
        ; Validate parameters
        if (Trim(filePath) = "")
            throw ValueError("File path cannot be empty")

        validModes := ["r", "w", "a", "rw"]
        if (!this._IsValidMode(mode, validModes))
            throw ValueError("Invalid file mode: " mode)

        ; Store basic properties
        this.FilePath := filePath
        this.Mode := mode
        this.Created := A_Now

        ; Attempt to open/create the file
        try {
            this._OpenFile()
        } catch Error as err {
            throw Error("Failed to open file: " err.Message)
        }
    }

    _IsValidMode(mode, validModes) {
        for validMode in validModes {
            if (mode = validMode)
                return true
        }
        return false
    }

    _OpenFile() {
        ; Simulated file opening
        ; In real implementation, would use FileOpen()
        this.Handle := 1  ; Simulated handle
        this.IsOpen := true
    }

    Close() {
        if (this.IsOpen) {
            ; Simulated file closing
            ; In real implementation, would use FileClose()
            this.Handle := 0
            this.IsOpen := false
        }
    }

    GetInfo() {
        status := this.IsOpen ? "Open" : "Closed"
        return Format("File: {}, Mode: {}, Status: {}, Bytes: {}",
            this.FilePath, this.Mode, status, this.BytesProcessed)
    }

    __Delete() {
        ; Destructor ensures file is closed
        this.Close()
    }
}

; Create file handler - automatically opens file
fileHandler := FileHandler("test.txt", "w")
MsgBox(fileHandler.GetInfo())
fileHandler.Close()
MsgBox(fileHandler.GetInfo())

MsgBox("=== OOP Constructor Examples Complete ===`n`n"
    . "This file demonstrated:`n"
    . "- Basic constructor syntax`n"
    . "- Required and optional parameters`n"
    . "- Parameter validation`n"
    . "- Constructor overloading simulation`n"
    . "- Factory methods`n"
    . "- Complex initialization`n"
    . "- Constructor chaining`n"
    . "- Resource management in constructors")
