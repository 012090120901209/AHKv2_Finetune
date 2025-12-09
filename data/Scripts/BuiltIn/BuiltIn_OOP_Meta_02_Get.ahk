#Requires AutoHotkey v2.0

/**
* BuiltIn_OOP_Meta_02_Get.ahk
*
* DESCRIPTION:
* Demonstrates the __Get meta-function in AutoHotkey v2. __Get is invoked when
* accessing an undefined property, enabling dynamic property handling, lazy
* loading, computed properties, and property aliasing.
*
* FEATURES:
* - __Get meta-function basics
* - Dynamic property creation
* - Lazy property initialization
* - Computed properties
* - Property aliasing
* - Default property values
* - Property access logging
*
* SOURCE:
* AutoHotkey v2 Documentation - Objects
*
* KEY V2 FEATURES DEMONSTRATED:
* - __Get(name, params) signature
* - Dynamic property access interception
* - Property name parameter
* - On-demand value calculation
* - Property existence checking
* - Meta-function return values
*
* LEARNING POINTS:
* 1. __Get intercepts undefined property access
* 2. First parameter is property name
* 3. Can generate properties on-the-fly
* 4. Useful for lazy initialization
* 5. Enables computed/virtual properties
* 6. Can implement default values
* 7. Works with bracket and dot notation
*/

; ========================================
; EXAMPLE 1: Basic __Get Usage
; ========================================
; Understanding how __Get intercepts property access

class PropertyLogger {
    AccessLog := []
    _actualData := Map()

    __Get(name, params) {
        ; Log the access
        this.AccessLog.Push({
            Property: name,
            Time: A_Now,
            Found: this._actualData.Has(name)
        })

        ; Return value if exists
        if (this._actualData.Has(name))
        return this._actualData[name]

        ; Return default value
        return "[Property '" name "' not found]"
    }

    SetProperty(name, value) {
        this._actualData[name] := value
    }

    GetLog() {
        log := "=== Property Access Log ===`n`n"

        for index, entry in this.AccessLog {
            log .= index ". " entry.Property
            log .= " (" (entry.Found ? "Found" : "Not Found") ")"
            log .= " at " FormatTime(entry.Time, "HH:mm:ss") "`n"
        }

        return log
    }
}

; Create logger
logger := PropertyLogger()
logger.SetProperty("Name", "John Doe")
logger.SetProperty("Age", 30)

; Access existing properties - logged
MsgBox("Name: " logger.Name)  ; Found
MsgBox("Age: " logger.Age)    ; Found

; Access non-existent properties - also logged
MsgBox("City: " logger.City)  ; Not found
MsgBox("Email: " logger.Email) ; Not found

; Show access log
MsgBox(logger.GetLog())

; ========================================
; EXAMPLE 2: Lazy Property Initialization
; ========================================
; Properties created only when first accessed

class LazyLoader {
    _cache := Map()

    __Get(name, params) {
        ; Check if already loaded
        if (this._cache.Has(name))
        return this._cache[name]

        ; Load based on property name
        value := ""

        if (name = "ExpensiveData") {
            MsgBox("Loading expensive data... (this happens only once)")
            Sleep(1000)  ; Simulate expensive operation
            value := "Expensive data loaded at " A_Now
        }
        else if (name = "Configuration") {
            MsgBox("Loading configuration... (this happens only once)")
            value := Map("Setting1", "Value1", "Setting2", "Value2")
        }
        else if (name = "CurrentTime") {
            ; Always recalculate - don't cache
            return A_Now
        }
        else {
            value := "Default value for " name
        }

        ; Cache the value
        this._cache[name] := value
        return value
    }

    ClearCache(propertyName := "") {
        if (propertyName != "") {
            if (this._cache.Has(propertyName))
            this._cache.Delete(propertyName)
        } else {
            this._cache := Map()
        }
    }
}

; Create lazy loader
loader := LazyLoader()

; First access loads data
MsgBox("First access: " loader.ExpensiveData)

; Second access uses cache
MsgBox("Second access: " loader.ExpensiveData)

; CurrentTime always recalculates
MsgBox("Time 1: " loader.CurrentTime)
Sleep(1000)
MsgBox("Time 2: " loader.CurrentTime)

; Clear cache and reload
loader.ClearCache("ExpensiveData")
MsgBox("After clear: " loader.ExpensiveData)

; ========================================
; EXAMPLE 3: Computed Properties
; ========================================
; Properties calculated from other values

class Rectangle {
    Width := 0
    Height := 0

    __New(width, height) {
        this.Width := width
        this.Height := height
    }

    __Get(name, params) {
        ; Computed properties
        if (name = "Area")
        return this.Width * this.Height

        if (name = "Perimeter")
        return 2 * (this.Width + this.Height)

        if (name = "Diagonal")
        return Sqrt(this.Width**2 + this.Height**2)

        if (name = "AspectRatio")
        return this.Width / this.Height

        if (name = "IsSquare")
        return this.Width = this.Height

        if (name = "IsPortrait")
        return this.Height > this.Width

        if (name = "IsLandscape")
        return this.Width > this.Height

        throw Error("Property '" name "' not found")
    }
}

; Create rectangle
rect := Rectangle(10, 5)

; Access computed properties
MsgBox("Width: " rect.Width "`nHeight: " rect.Height
. "`nArea: " rect.Area
. "`nPerimeter: " rect.Perimeter
. "`nDiagonal: " Round(rect.Diagonal, 2)
. "`nAspect Ratio: " rect.AspectRatio
. "`nIs Square: " rect.IsSquare
. "`nIs Landscape: " rect.IsLandscape)

; Change dimensions - computed properties update automatically
rect.Width := 8
rect.Height := 8

MsgBox("After resize:`nArea: " rect.Area
. "`nIs Square: " rect.IsSquare)

; ========================================
; EXAMPLE 4: Property Aliasing
; ========================================
; Multiple names for the same property

class Person {
    FirstName := ""
    LastName := ""
    BirthYear := 0

    __New(firstName, lastName, birthYear) {
        this.FirstName := firstName
        this.LastName := lastName
        this.BirthYear := birthYear
    }

    __Get(name, params) {
        ; Aliases for FirstName
        if (name = "GivenName" || name = "Forename")
        return this.FirstName

        ; Aliases for LastName
        if (name = "Surname" || name = "FamilyName")
        return this.LastName

        ; Computed properties
        if (name = "FullName")
        return this.FirstName " " this.LastName

        if (name = "Age")
        return Integer(FormatTime(A_Now, "yyyy")) - this.BirthYear

        if (name = "Initials")
        return SubStr(this.FirstName, 1, 1) SubStr(this.LastName, 1, 1)

        throw Error("Property '" name "' not found")
    }
}

; Create person
person := Person("John", "Doe", 1990)

; Access via different aliases
MsgBox("FirstName: " person.FirstName)
MsgBox("GivenName: " person.GivenName)
MsgBox("Forename: " person.Forename)
MsgBox("LastName: " person.LastName)
MsgBox("Surname: " person.Surname)
MsgBox("FamilyName: " person.FamilyName)
MsgBox("FullName: " person.FullName)
MsgBox("Age: " person.Age)
MsgBox("Initials: " person.Initials)

; ========================================
; EXAMPLE 5: Default Values Pattern
; ========================================
; Providing defaults for missing properties

class ConfigManager {
    _config := Map()
    _defaults := Map()

    __New() {
        ; Set default values
        this._defaults := Map(
        "Theme", "Light",
        "FontSize", 12,
        "AutoSave", true,
        "Language", "en",
        "MaxConnections", 10,
        "Timeout", 30
        )
    }

    __Get(name, params) {
        ; Return actual value if set
        if (this._config.Has(name))
        return this._config[name]

        ; Return default if available
        if (this._defaults.Has(name))
        return this._defaults[name]

        ; No default available
        throw Error("Configuration '" name "' not found and has no default")
    }

    Set(name, value) {
        this._config[name] := value
    }

    Reset(name := "") {
        if (name != "") {
            if (this._config.Has(name))
            this._config.Delete(name)
        } else {
            this._config := Map()
        }
    }

    GetAll() {
        result := "=== Configuration ===`n`n"

        ; Show all defaults and overrides
        for key, value in this._defaults {
            actualValue := this._config.Has(key) ? this._config[key] : value
            isDefault := !this._config.Has(key)

            result .= key ": " actualValue
            result .= isDefault ? " (default)`n" : " (custom)`n"
        }

        return result
    }
}

; Create config manager
config := ConfigManager()

; Access defaults
MsgBox("Theme: " config.Theme)  ; "Light" (default)
MsgBox("FontSize: " config.FontSize)  ; 12 (default)

; Override some values
config.Set("Theme", "Dark")
config.Set("FontSize", 14)

; Access overridden values
MsgBox("Theme: " config.Theme)  ; "Dark" (custom)
MsgBox("FontSize: " config.FontSize)  ; 14 (custom)

; Show all configuration
MsgBox(config.GetAll())

; Reset to defaults
config.Reset("Theme")
MsgBox("After reset:`nTheme: " config.Theme)  ; Back to "Light"

; ========================================
; EXAMPLE 6: Dynamic Property Generation
; ========================================
; Generating properties based on patterns

class DynamicObject {
    _data := Map()

    __Get(name, params) {
        ; Generate "count" properties
        if (SubStr(name, -4) = "Count") {
            ; Return count of items
            itemName := SubStr(name, 1, -5)
            return this._GetItemCount(itemName)
        }

        ; Generate "has" properties
        if (SubStr(name, 1, 3) = "has") {
            itemName := SubStr(name, 4)
            return this._data.Has(itemName)
        }

        ; Generate "isEmpty" property
        if (name = "isEmpty")
        return this._data.Count = 0

        ; Generate "size" property
        if (name = "size")
        return this._data.Count

        ; Regular property access
        if (this._data.Has(name))
        return this._data[name]

        return ""
    }

    Set(name, value) {
        this._data[name] := value
    }

    _GetItemCount(itemName) {
        if (!this._data.Has(itemName))
        return 0

        value := this._data[itemName]

        if (Type(value) = "Array")
        return value.Length

        if (Type(value) = "Map")
        return value.Count

        if (Type(value) = "String")
        return StrLen(value)

        return 1
    }
}

; Create dynamic object
obj := DynamicObject()

; Set some data
obj.Set("Name", "John Doe")
obj.Set("Items", [1, 2, 3, 4, 5])
obj.Set("Settings", Map("a", 1, "b", 2))

; Access dynamic properties
MsgBox("Name: " obj.Name)
MsgBox("Name Count: " obj.NameCount)  ; String length
MsgBox("Items Count: " obj.ItemsCount)  ; Array length
MsgBox("Settings Count: " obj.SettingsCount)  ; Map count

MsgBox("Has Name: " obj.hasName)
MsgBox("Has Email: " obj.hasEmail)

MsgBox("Is Empty: " obj.isEmpty)
MsgBox("Size: " obj.size)

; ========================================
; EXAMPLE 7: Chained Property Access
; ========================================
; Enabling nested property access

class NestedObject {
    _data := Map()

    __New(data := "") {
        this._data := data != "" ? data : Map()
    }

    __Get(name, params) {
        if (this._data.Has(name)) {
            value := this._data[name]

            ; If value is a Map, wrap it in NestedObject for chaining
            if (Type(value) = "Map")
            return NestedObject(value)

            return value
        }

        ; Return empty NestedObject for non-existent paths
        return NestedObject()
    }

    Set(name, value) {
        this._data[name] := value
    }

    Exists() {
        return this._data.Count > 0
    }

    GetValue(default := "") {
        ; For leaf values
        for key, value in this._data {
            if (Type(value) != "Map")
            return value
        }
        return default
    }
}

; Create nested structure
root := NestedObject()
root.Set("User", Map(
"Name", "John Doe",
"Contact", Map(
"Email", "john@example.com",
"Phone", "555-0123"
),
"Settings", Map(
"Theme", "Dark",
"Notifications", true
)
))

; Access nested properties (each property returns a new NestedObject)
MsgBox("User Name: " root.User.Name)
MsgBox("User Email: " root.User.Contact.Email)
MsgBox("User Theme: " root.User.Settings.Theme)

; Access non-existent path - doesn't error
nonExistent := root.User.Address.Street
MsgBox("Non-existent exists: " nonExistent.Exists())

MsgBox("=== OOP __Get Meta-Function Examples Complete ===`n`n"
. "This file demonstrated:`n"
. "- Basic __Get interception`n"
. "- Lazy property initialization`n"
. "- Computed properties`n"
. "- Property aliasing`n"
. "- Default values pattern`n"
. "- Dynamic property generation`n"
. "- Chained property access")
