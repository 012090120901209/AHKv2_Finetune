#Requires AutoHotkey v2.0

/**
 * BuiltIn_OOP_Class_02_Properties.ahk
 * 
 * DESCRIPTION:
 * Demonstrates various ways to define and use properties in AutoHotkey v2 classes.
 * Covers instance properties, default values, property methods, and encapsulation patterns.
 * 
 * FEATURES:
 * - Instance property definition
 * - Default property values
 * - Property getter/setter methods
 * - Computed properties
 * - Property validation
 * - Private property patterns
 * - Dynamic property access
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - Objects
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Property syntax with := operator
 * - Property methods (get/set)
 * - Dynamic property access with bracket notation
 * - HasOwnProp() method
 * - GetOwnPropDesc() for property metadata
 * - DeleteProp() for property removal
 * 
 * LEARNING POINTS:
 * 1. Properties can have default values
 * 2. Properties can be validated on assignment
 * 3. Property methods provide encapsulation
 * 4. Computed properties don't store values
 * 5. Properties can be accessed dynamically
 * 6. Property existence can be checked at runtime
 * 7. Naming conventions can indicate privacy
 */

; ========================================
; EXAMPLE 1: Properties with Default Values
; ========================================
; Demonstrating various types of default property values

class Product {
    ; String properties with defaults
    Name := "Unnamed Product"
    Category := "General"
    Description := ""

    ; Numeric properties
    Price := 0.00
    Quantity := 0
    SKU := ""

    ; Boolean properties
    InStock := false
    OnSale := false

    ; Array/Object properties
    Tags := []
    Metadata := Map()

    __New(name, price) {
        this.Name := name
        this.Price := price
        this.InStock := true
    }

    GetDetails() {
        details := "Product: " this.Name "`n"
        details .= "Category: " this.Category "`n"
        details .= "Price: $" this.Price "`n"
        details .= "In Stock: " (this.InStock ? "Yes" : "No") "`n"
        details .= "On Sale: " (this.OnSale ? "Yes" : "No")
        return details
    }
}

; Create products with different property sets
product1 := Product("Laptop", 999.99)
product1.Category := "Electronics"
product1.Quantity := 5
product1.Tags := ["Computer", "Portable", "Business"]

product2 := Product("Coffee Mug", 12.99)
product2.Category := "Kitchen"
product2.OnSale := true

MsgBox(product1.GetDetails())
MsgBox(product2.GetDetails())

; ========================================
; EXAMPLE 2: Property Methods (Getters/Setters)
; ========================================
; Using property methods for validation and encapsulation

class User {
    _username := ""  ; Private by convention (underscore prefix)
    _email := ""
    _age := 0

    ; Property with getter and setter
    Username {
        get => this._username

        set {
            ; Validate username
            if (StrLen(value) < 3)
                throw ValueError("Username must be at least 3 characters")
            if (StrLen(value) > 20)
                throw ValueError("Username must be less than 20 characters")
            if (!RegExMatch(value, "^[a-zA-Z0-9_]+$"))
                throw ValueError("Username can only contain letters, numbers, and underscores")

            this._username := value
        }
    }

    ; Email property with validation
    Email {
        get => this._email

        set {
            ; Basic email validation
            if (!RegExMatch(value, "^[^@]+@[^@]+\.[^@]+$"))
                throw ValueError("Invalid email format")

            this._email := value
        }
    }

    ; Age property with validation
    Age {
        get => this._age

        set {
            if (value < 0 || value > 150)
                throw ValueError("Age must be between 0 and 150")

            this._age := value
        }
    }

    __New(username, email, age) {
        ; Using properties ensures validation on construction
        this.Username := username
        this.Email := email
        this.Age := age
    }

    ToString() {
        return "User: " this.Username " (" this.Email "), Age: " this.Age
    }
}

; Valid user creation
try {
    user1 := User("john_doe", "john@example.com", 30)
    MsgBox(user1.ToString())
}

; Invalid username (too short)
try {
    user2 := User("ab", "test@example.com", 25)
} catch Error as err {
    MsgBox("Error: " err.Message)  ; "Username must be at least 3 characters"
}

; Invalid email
try {
    user3 := User("valid_user", "invalid-email", 25)
} catch Error as err {
    MsgBox("Error: " err.Message)  ; "Invalid email format"
}

; ========================================
; EXAMPLE 3: Computed Properties
; ========================================
; Properties that calculate their values instead of storing them

class Rectangle {
    Width := 0
    Height := 0

    __New(width, height) {
        this.Width := width
        this.Height := height
    }

    ; Computed properties using property methods
    Area {
        get => this.Width * this.Height
    }

    Perimeter {
        get => 2 * (this.Width + this.Height)
    }

    Diagonal {
        get => Sqrt(this.Width ** 2 + this.Height ** 2)
    }

    AspectRatio {
        get => this.Width / this.Height
    }

    IsSquare {
        get => this.Width = this.Height
    }

    IsPortrait {
        get => this.Height > this.Width
    }

    IsLandscape {
        get => this.Width > this.Height
    }

    ToString() {
        return Format("Rectangle: {}x{}, Area: {}, Perimeter: {}, Diagonal: {:.2f}",
            this.Width, this.Height, this.Area, this.Perimeter, this.Diagonal)
    }
}

rect1 := Rectangle(10, 5)
MsgBox(rect1.ToString())
MsgBox("Is Square: " rect1.IsSquare "`nIs Landscape: " rect1.IsLandscape)

rect2 := Rectangle(8, 8)
MsgBox(rect2.ToString())
MsgBox("Is Square: " rect2.IsSquare)

; ========================================
; EXAMPLE 4: Read-Only and Write-Only Properties
; ========================================
; Properties with restricted access

class Thermometer {
    _celsius := 0
    _readings := []

    ; Write-only property (no getter)
    RawReading {
        set {
            this._celsius := value
            this._readings.Push({ time: A_Now, value: value })
        }
    }

    ; Read-only property (no setter)
    Celsius {
        get => this._celsius
    }

    Fahrenheit {
        get => (this._celsius * 9 / 5) + 32
    }

    Kelvin {
        get => this._celsius + 273.15
    }

    ; Read-only computed property
    ReadingCount {
        get => this._readings.Length
    }

    AverageReading {
        get {
            if (this._readings.Length = 0)
                return 0

            total := 0
            for reading in this._readings
                total += reading.value

            return total / this._readings.Length
        }
    }

    GetHistory() {
        history := "Temperature History:`n"
        for index, reading in this._readings {
            history .= index ". " reading.value "°C at " reading.time "`n"
        }
        return history
    }
}

therm := Thermometer()
therm.RawReading := 20
therm.RawReading := 22
therm.RawReading := 21

MsgBox("Current: " therm.Celsius "°C / " therm.Fahrenheit "°F")
MsgBox("Average: " Round(therm.AverageReading, 2) "°C")
MsgBox(therm.GetHistory())

; This would cause an error (no setter):
; therm.Celsius := 25

; ========================================
; EXAMPLE 5: Dynamic Property Access
; ========================================
; Accessing properties dynamically using bracket notation

class Configuration {
    ; Configuration properties
    AppName := "MyApp"
    Version := "1.0.0"
    Debug := false
    MaxConnections := 100
    Timeout := 30
    LogLevel := "INFO"

    ; Get property by name
    Get(propName, defaultValue := "") {
        if (this.HasOwnProp(propName))
            return this.%propName%
        return defaultValue
    }

    ; Set property by name
    Set(propName, value) {
        this.%propName% := value
    }

    ; Check if property exists
    Has(propName) {
        return this.HasOwnProp(propName)
    }

    ; Get all property names
    GetPropertyNames() {
        names := []
        for propName in this.OwnProps()
            names.Push(propName)
        return names
    }

    ; Export configuration as string
    Export() {
        config := "=== Configuration ===`n"
        for propName in this.OwnProps() {
            value := this.%propName%
            config .= propName ": " value "`n"
        }
        return config
    }

    ; Load configuration from map
    LoadFromMap(configMap) {
        for key, value in configMap
            this.Set(key, value)
    }
}

config := Configuration()

; Dynamic property access
propToGet := "Version"
MsgBox("Property '" propToGet "': " config.Get(propToGet))

; Set property dynamically
config.Set("Port", 8080)
MsgBox("Port: " config.Get("Port"))

; List all properties
allProps := ""
for prop in config.GetPropertyNames()
    allProps .= prop "`n"
MsgBox("All Properties:`n" allProps)

; Export configuration
MsgBox(config.Export())

; Load from map
newSettings := Map(
    "Debug", true,
    "LogLevel", "DEBUG",
    "MaxConnections", 200
)
config.LoadFromMap(newSettings)
MsgBox(config.Export())

; ========================================
; EXAMPLE 6: Property with Lazy Initialization
; ========================================
; Properties that initialize their values only when first accessed

class DataManager {
    _data := ""
    _cache := ""

    ; Lazy-loaded property
    Data {
        get {
            ; Initialize only on first access
            if (this._data = "") {
                MsgBox("Loading data for the first time...")
                this._data := this._LoadData()
            }
            return this._data
        }
    }

    Cache {
        get {
            if (this._cache = "") {
                MsgBox("Initializing cache...")
                this._cache := Map()
                this._cache["initialized"] := A_Now
            }
            return this._cache
        }
    }

    _LoadData() {
        ; Simulate expensive data loading
        Sleep(1000)
        return "Loaded data at " A_Now
    }

    ClearCache() {
        this._cache := ""
        MsgBox("Cache cleared")
    }
}

manager := DataManager()
MsgBox("Manager created (data not loaded yet)")

; First access triggers loading
MsgBox("Accessing data...")
data1 := manager.Data
MsgBox("Data: " data1)

; Second access uses cached value
MsgBox("Accessing data again...")
data2 := manager.Data
MsgBox("Data: " data2)

; Access cache
MsgBox("Cache initialized: " manager.Cache["initialized"])

; ========================================
; EXAMPLE 7: Property Dependency and Cascading Updates
; ========================================
; Properties that update other properties when changed

class Circle {
    _radius := 0

    Radius {
        get => this._radius

        set {
            if (value < 0)
                throw ValueError("Radius cannot be negative")
            this._radius := value
        }
    }

    ; Computed properties dependent on radius
    Diameter {
        get => this._radius * 2

        set {
            this.Radius := value / 2
        }
    }

    Circumference {
        get => 2 * 3.14159265359 * this._radius

        set {
            this.Radius := value / (2 * 3.14159265359)
        }
    }

    Area {
        get => 3.14159265359 * this._radius ** 2

        set {
            this.Radius := Sqrt(value / 3.14159265359)
        }
    }

    __New(radius := 1) {
        this.Radius := radius
    }

    ToString() {
        return Format("Circle: r={:.2f}, d={:.2f}, C={:.2f}, A={:.2f}",
            this.Radius, this.Diameter, this.Circumference, this.Area)
    }

    Scale(factor) {
        this.Radius *= factor
    }
}

; Create circle with radius
circle := Circle(5)
MsgBox(circle.ToString())

; Change via diameter - updates radius
circle.Diameter := 20
MsgBox("After setting diameter to 20:`n" circle.ToString())

; Change via area - updates radius
circle.Area := 100
MsgBox("After setting area to 100:`n" circle.ToString())

; Change via circumference
circle.Circumference := 31.4159
MsgBox("After setting circumference to 31.4159:`n" circle.ToString())

; Scale the circle
circle.Scale(2)
MsgBox("After scaling by 2:`n" circle.ToString())

MsgBox("=== OOP Properties Examples Complete ===`n`n"
    . "This file demonstrated:`n"
    . "- Default property values`n"
    . "- Property getters and setters`n"
    . "- Property validation`n"
    . "- Computed properties`n"
    . "- Read-only and write-only properties`n"
    . "- Dynamic property access`n"
    . "- Lazy initialization`n"
    . "- Property dependencies")
