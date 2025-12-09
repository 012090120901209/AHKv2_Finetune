#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric Property Descriptors - Advanced property manipulation
; Demonstrates __Item, DefineProp, GetOwnPropDesc, and property interceptors

; =============================================================================
; 1. Custom Indexer with __Item
; =============================================================================

class Matrix2D {
    __New(rows, cols) {
        this.rows := rows
        this.cols := cols
        this.data := []
        
        ; Initialize with zeros
        Loop rows {
            row := []
            Loop cols
                row.Push(0)
            this.data.Push(row)
        }
    }
    
    ; Enable matrix[row, col] syntax
    __Item[row, col] {
        get => this.data[row][col]
        set => this.data[row][col] := value
    }
    
    ; String representation
    ToString() {
        result := ""
        for row in this.data {
            for i, val in row
                result .= (i > 1 ? ", " : "") val
            result .= "`n"
        }
        return result
    }
}

; =============================================================================
; 2. Default Dictionary with __Item
; =============================================================================

class DefaultDict {
    __New(defaultFactory) {
        this.data := Map()
        this.factory := defaultFactory
    }
    
    __Item[key] {
        get {
            if !this.data.Has(key)
                this.data[key] := this.factory()
            return this.data[key]
        }
        set => this.data[key] := value
    }
    
    Has(key) => this.data.Has(key)
    Delete(key) => this.data.Delete(key)
    Keys() => this.data.Keys()
}

; =============================================================================
; 3. Computed Properties
; =============================================================================

class Circle {
    __New(radius) => this._radius := radius
    
    ; Computed property - derived from radius
    radius {
        get => this._radius
        set => this._radius := value
    }
    
    ; Read-only computed properties
    diameter => this._radius * 2
    circumference => 2 * 3.14159 * this._radius
    area => 3.14159 * this._radius * this._radius
}

; =============================================================================
; 4. Validated Properties
; =============================================================================

class ValidatedPerson {
    _name := ""
    _age := 0
    _email := ""
    
    name {
        get => this._name
        set {
            if StrLen(value) < 2
                throw ValueError("Name must be at least 2 characters")
            this._name := value
        }
    }
    
    age {
        get => this._age
        set {
            if value < 0 || value > 150
                throw ValueError("Age must be between 0 and 150")
            this._age := Integer(value)
        }
    }
    
    email {
        get => this._email
        set {
            if !RegExMatch(value, "^\w+@\w+\.\w+$")
                throw ValueError("Invalid email format")
            this._email := value
        }
    }
}

; =============================================================================
; 5. Observable Properties (Property Change Events)
; =============================================================================

class Observable {
    __New() {
        this._data := Map()
        this._observers := Map()
    }
    
    ; Dynamically add observable property
    AddProperty(name, initialValue := "") {
        this._data[name] := initialValue
        this._observers[name] := []
        
        this.DefineProp(name, {
            Get: (this) => this._data[name],
            Set: (this, value) => this._setWithNotify(name, value)
        })
    }
    
    _setWithNotify(name, value) {
        oldValue := this._data[name]
        this._data[name] := value
        
        for callback in this._observers[name]
            callback(name, oldValue, value)
    }
    
    OnChange(propName, callback) {
        if this._observers.Has(propName)
            this._observers[propName].Push(callback)
    }
}

; =============================================================================
; 6. Lazy Properties (Computed Once)
; =============================================================================

class LazyProperties {
    __New() {
        this._cache := Map()
    }
    
    ; Define a lazy property that computes once
    static DefineLazy(instance, name, computeFn) {
        instance.DefineProp(name, {
            Get: (this) => (
                !this._cache.Has(name) 
                    ? this._cache[name] := computeFn(this)
                    : 0,
                this._cache[name]
            )
        })
    }
}

class ExpensiveData extends LazyProperties {
    __New(seed) {
        super.__New()
        this.seed := seed
        
        ; Define lazy property
        LazyProperties.DefineLazy(this, "processedData", (self) => (
            Sleep(100),  ; Simulate expensive operation
            self.seed * 1000 + Random(1, 100)
        ))
    }
}

; =============================================================================
; 7. Property Proxy (Intercept All Access)
; =============================================================================

class PropertyProxy {
    __New(target, handler) {
        this._target := target
        this._handler := handler
    }
    
    __Get(name, params) {
        if this._handler.Has("get")
            return this._handler["get"](this._target, name)
        return this._target.%name%
    }
    
    __Set(name, params, value) {
        if this._handler.Has("set")
            return this._handler["set"](this._target, name, value)
        return this._target.%name% := value
    }
    
    __Call(name, params) {
        if this._handler.Has("call")
            return this._handler["call"](this._target, name, params)
        return this._target.%name%(params*)
    }
}

; =============================================================================
; 8. Reactive Computed Properties
; =============================================================================

class Reactive {
    static Create(data) {
        reactive := ReactiveObject()
        
        for key, value in data.OwnProps()
            reactive._addProp(key, value)
        
        return reactive
    }
}

class ReactiveObject {
    __New() {
        this._values := Map()
        this._computed := Map()
        this._deps := Map()
    }
    
    _addProp(name, value) {
        if value is Func {
            ; Computed property
            this._computed[name] := value
            this.DefineProp(name, {
                Get: (this) => this._computed[name](this)
            })
        } else {
            ; Regular reactive property
            this._values[name] := value
            this.DefineProp(name, {
                Get: (this) => this._values[name],
                Set: (this, val) => this._values[name] := val
            })
        }
    }
}

; =============================================================================
; 9. Property Metadata
; =============================================================================

class PropMeta {
    static metadata := Map()
    
    ; Add metadata to a property
    static Define(cls, propName, meta) {
        key := Type(cls) "." propName
        PropMeta.metadata[key] := meta
    }
    
    ; Get metadata
    static Get(cls, propName) {
        key := Type(cls) "." propName
        return PropMeta.metadata.Get(key, Map())
    }
    
    ; Decorate a class with metadata
    static Decorate(cls, propMeta) {
        for prop, meta in propMeta
            PropMeta.Define(cls, prop, meta)
        return cls
    }
}

; =============================================================================
; Demo
; =============================================================================

; Matrix with custom indexer
matrix := Matrix2D(3, 3)
matrix[1, 1] := 1
matrix[2, 2] := 2
matrix[3, 3] := 3
MsgBox("Matrix with __Item:`n`n" matrix.ToString())

; Default dictionary
wordCount := DefaultDict(() => 0)
words := StrSplit("the quick brown fox jumps over the lazy dog", " ")
for word in words
    wordCount[word]++

output := "DefaultDict word counts:`n"
for key in wordCount.Keys()
    output .= key ": " wordCount[key] "`n"
MsgBox(output)

; Computed properties
circle := Circle(5)
MsgBox("Circle (radius=5):`n"
    . "Diameter: " circle.diameter "`n"
    . "Circumference: " Round(circle.circumference, 2) "`n"
    . "Area: " Round(circle.area, 2))

; Validated properties
person := ValidatedPerson()
try {
    person.name := "Alice"
    person.age := 30
    person.email := "alice@example.com"
    MsgBox("Valid person:`n"
        . "Name: " person.name "`n"
        . "Age: " person.age "`n"
        . "Email: " person.email)
} catch ValueError as e {
    MsgBox("Validation error: " e.Message)
}

; Observable properties
observable := Observable()
observable.AddProperty("count", 0)
observable.OnChange("count", (name, old, new) => 
    ToolTip("count changed: " old " -> " new))

observable.count := 1
Sleep(500)
observable.count := 5
Sleep(500)
observable.count := 10
Sleep(500)
ToolTip()

MsgBox("Observable property final value: " observable.count)

; Lazy properties
expensive := ExpensiveData(42)
MsgBox("Lazy property:`n"
    . "First access (slow): " expensive.processedData "`n"
    . "Second access (cached): " expensive.processedData)

; Property proxy
target := {x: 10, y: 20}
logged := PropertyProxy(target, Map(
    "get", (t, name) => (OutputDebug("GET " name "`n"), t.%name%),
    "set", (t, name, val) => (OutputDebug("SET " name "=" val "`n"), t.%name% := val)
))

MsgBox("Property Proxy:`n"
    . "x = " logged.x "`n"
    . "(check debug output for logging)")
