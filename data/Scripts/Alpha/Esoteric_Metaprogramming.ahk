#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric Metaprogramming - Runtime class/method generation and manipulation
; Demonstrates dynamic code construction and prototype manipulation

; =============================================================================
; 1. Dynamic Class Creation
; =============================================================================

class ClassFactory {
    ; Create a class at runtime with specified properties and methods
    static Create(name, properties := [], methods := Map()) {
        ; Create base class dynamically
        newClass := Class()
        
        ; Add properties
        for prop in properties {
            newClass.Prototype.DefineProp(prop, {
                Value: ""
            })
        }
        
        ; Add methods
        for methodName, methodFunc in methods {
            newClass.Prototype.DefineProp(methodName, {
                Call: methodFunc
            })
        }
        
        ; Store class name
        newClass.DefineProp("__ClassName", {Value: name})
        
        return newClass
    }
    
    ; Create a mixin that can be applied to any class
    static CreateMixin(methods) {
        return (targetClass) => (
            ClassFactory._applyMethods(targetClass, methods),
            targetClass
        )
    }
    
    static _applyMethods(targetClass, methods) {
        for name, fn in methods
            targetClass.Prototype.DefineProp(name, {Call: fn})
    }
}

; =============================================================================
; 2. Method Missing / No Such Method
; =============================================================================

class MethodMissing {
    __New() {
        this.data := Map()
    }
    
    ; Intercept all undefined method calls
    __Call(name, params) {
        ; Auto-generate getters/setters
        if SubStr(name, 1, 3) = "get" {
            prop := SubStr(name, 4)
            return this.data.Get(prop, "")
        }
        
        if SubStr(name, 1, 3) = "set" {
            prop := SubStr(name, 4)
            this.data[prop] := params[1]
            return this
        }
        
        ; Log unknown method calls
        return "Unknown method: " name "(" this._joinParams(params) ")"
    }
    
    _joinParams(params) {
        result := ""
        for i, p in params
            result .= (i > 1 ? ", " : "") String(p)
        return result
    }
}

; =============================================================================
; 3. Property Missing / Dynamic Properties
; =============================================================================

class DynamicProps {
    static storage := Map()
    
    __Get(name, params) {
        key := ObjPtr(this) "." name
        return DynamicProps.storage.Get(key, "")
    }
    
    __Set(name, params, value) {
        key := ObjPtr(this) "." name
        DynamicProps.storage[key] := value
    }
}

; =============================================================================
; 4. Prototype Chain Manipulation
; =============================================================================

class PrototypeHacks {
    ; Add method to all arrays
    static ExtendArray() {
        ; Sum all numeric elements
        Array.Prototype.DefineProp("Sum", {
            Call: (arr) => PrototypeHacks._arraySum(arr)
        })
        
        ; Average
        Array.Prototype.DefineProp("Average", {
            Call: (arr) => arr.Sum() / arr.Length
        })
        
        ; Chunk into groups
        Array.Prototype.DefineProp("Chunk", {
            Call: (arr, size) => PrototypeHacks._arrayChunk(arr, size)
        })
        
        ; Unique values
        Array.Prototype.DefineProp("Unique", {
            Call: (arr) => PrototypeHacks._arrayUnique(arr)
        })
    }
    
    static _arraySum(arr) {
        total := 0
        for v in arr
            if IsNumber(v)
                total += v
        return total
    }
    
    static _arrayChunk(arr, size) {
        chunks := []
        current := []
        
        for v in arr {
            current.Push(v)
            if current.Length >= size {
                chunks.Push(current)
                current := []
            }
        }
        
        if current.Length > 0
            chunks.Push(current)
        
        return chunks
    }
    
    static _arrayUnique(arr) {
        seen := Map()
        result := []
        
        for v in arr {
            key := Type(v) = "String" ? v : String(v)
            if !seen.Has(key) {
                seen[key] := true
                result.Push(v)
            }
        }
        
        return result
    }
    
    ; Add method to all strings
    static ExtendString() {
        ; This requires String wrapper class since primitives
        ; don't have prototypes we can modify directly
    }
}

; =============================================================================
; 5. Aspect-Oriented Programming (AOP)
; =============================================================================

class Aspect {
    static Before(target, methodName, advice) {
        original := target.Prototype.GetOwnPropDesc(methodName)
        
        if !original.HasProp("Call")
            throw Error("Method not found: " methodName)
        
        originalFn := original.Call
        
        target.Prototype.DefineProp(methodName, {
            Call: (this, params*) => (
                advice(this, methodName, params),
                originalFn(this, params*)
            )
        })
    }
    
    static After(target, methodName, advice) {
        original := target.Prototype.GetOwnPropDesc(methodName)
        
        if !original.HasProp("Call")
            throw Error("Method not found: " methodName)
        
        originalFn := original.Call
        
        target.Prototype.DefineProp(methodName, {
            Call: (this, params*) => (
                result := originalFn(this, params*),
                advice(this, methodName, result),
                result
            )
        })
    }
    
    static Around(target, methodName, wrapper) {
        original := target.Prototype.GetOwnPropDesc(methodName)
        
        if !original.HasProp("Call")
            throw Error("Method not found: " methodName)
        
        originalFn := original.Call
        
        target.Prototype.DefineProp(methodName, {
            Call: (this, params*) => wrapper(this, originalFn, params)
        })
    }
}

; =============================================================================
; 6. Self-Modifying Object
; =============================================================================

class SelfModifying {
    __New() {
        this.callCount := Map()
    }
    
    ; Method that optimizes itself after N calls
    SlowMethod() {
        name := "SlowMethod"
        
        if !this.callCount.Has(name)
            this.callCount[name] := 0
        
        this.callCount[name]++
        
        ; After 3 calls, replace with optimized version
        if this.callCount[name] >= 3 {
            this.DefineProp("SlowMethod", {
                Call: (*) => "Optimized!"
            })
        }
        
        ; Simulate slow operation
        Sleep(100)
        return "Slow result " this.callCount[name]
    }
}

; =============================================================================
; 7. Object Capability Model
; =============================================================================

class Capability {
    static CreateReadOnly(obj) {
        proxy := {}
        
        for prop in obj.OwnProps() {
            value := obj.%prop%
            proxy.DefineProp(prop, {
                Get: (*) => value,
                Set: (*) => (throw Error("Read-only object"))
            })
        }
        
        return proxy
    }
    
    static CreateWriteOnly(obj) {
        proxy := {_target: obj}
        
        for prop in obj.OwnProps() {
            proxy.DefineProp(prop, {
                Get: (*) => (throw Error("Write-only object")),
                Set: (this, value) => this._target.%prop% := value
            })
        }
        
        return proxy
    }
    
    static CreateLogged(obj, logger) {
        proxy := {_target: obj, _logger: logger}
        
        for prop in obj.OwnProps() {
            proxy.DefineProp(prop, {
                Get: (this) => (
                    this._logger("GET " prop),
                    this._target.%prop%
                ),
                Set: (this, value) => (
                    this._logger("SET " prop " = " value),
                    this._target.%prop% := value
                )
            })
        }
        
        return proxy
    }
}

; =============================================================================
; Demo
; =============================================================================

; Dynamic class creation
PersonClass := ClassFactory.Create("Person", ["name", "age"], Map(
    "greet", (this) => "Hello, I'm " this.name,
    "birthday", (this) => (this.age++, this)
))

person := PersonClass()
person.name := "Alice"
person.age := 30

MsgBox("Dynamic Class:`n`n"
    . "Class: " PersonClass.__ClassName "`n"
    . "Greeting: " person.greet() "`n"
    . "After birthday: " (person.birthday(), person.age))

; Method missing
mm := MethodMissing()
mm.setName("Bob")
mm.setAge(25)
MsgBox("Method Missing:`n`n"
    . "getName: " mm.getName() "`n"
    . "getAge: " mm.getAge() "`n"
    . "unknown: " mm.unknownMethod(1, 2, 3))

; Prototype extension
PrototypeHacks.ExtendArray()
arr := [1, 2, 3, 4, 5, 1, 2, 3]
MsgBox("Array Extensions:`n`n"
    . "Sum: " arr.Sum() "`n"
    . "Average: " arr.Average() "`n"
    . "Unique count: " arr.Unique().Length "`n"
    . "Chunks of 3: " arr.Chunk(3).Length " chunks")

; Self-modifying
sm := SelfModifying()
results := []
Loop 5
    results.Push(sm.SlowMethod())
MsgBox("Self-Modifying:`n`n" 
    . "Calls: " results[1] ", " results[2] ", " results[3] ", " results[4] ", " results[5])

; Capability model
original := {secret: "password", public: "hello"}
readOnly := Capability.CreateReadOnly(original)
MsgBox("Capability (Read-Only):`n`n"
    . "Can read: " readOnly.public "`n"
    . "Can read secret: " readOnly.secret)
