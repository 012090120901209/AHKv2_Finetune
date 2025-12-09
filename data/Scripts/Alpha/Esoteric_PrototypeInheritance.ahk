#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric Prototype Inheritance - Deep dive into AHK v2's prototype chain
; Demonstrates prototype manipulation, inheritance patterns, and object model quirks

; =============================================================================
; 1. Understanding the Prototype Chain
; =============================================================================

; Every object has a base (prototype)
; obj.base returns the prototype
; obj.HasBase(proto) checks prototype chain

DescribeProtoChain(obj) {
    chain := []
    current := obj
    
    while HasProp(current, "base") && current.base != "" {
        chain.Push(Type(current))
        current := current.base
    }
    chain.Push(Type(current))
    
    return chain
}

; Custom prototype-based object creation
CreateObject(proto, props := Map()) {
    obj := {}
    obj.base := proto
    
    for key, value in props
        obj.%key% := value
    
    return obj
}

; =============================================================================
; 2. Prototype Manipulation
; =============================================================================

; Change prototype at runtime
class Animal {
    Speak() => "..."
}

class Dog extends Animal {
    Speak() => "Woof!"
}

class Cat extends Animal {
    Speak() => "Meow!"
}

; Function to swap prototype
MorphInto(obj, newProto) {
    oldProto := obj.base
    obj.base := newProto.Prototype
    return oldProto
}

; =============================================================================
; 3. Mixin via Prototype Extension
; =============================================================================

; Define mixins as plain objects with methods
Comparable := {
    __Lt: (self, other) => self.Compare(other) < 0,
    __Le: (self, other) => self.Compare(other) <= 0,
    __Gt: (self, other) => self.Compare(other) > 0,
    __Ge: (self, other) => self.Compare(other) >= 0,
    __Eq: (self, other) => self.Compare(other) = 0
}

Serializable := {
    ToJSON: (self) => "{" self._jsonProps() "}",
    _jsonProps: (self) => (
        parts := [],
        (for prop in ObjOwnProps(self)
            parts.Push('"' prop '":"' String(self.%prop%) '"')),
        _Join(parts, ",")
    )
}

_Join(arr, sep) {
    result := ""
    for i, v in arr
        result .= (i > 1 ? sep : "") . v
    return result
}

; Apply mixin to prototype
ApplyMixin(classObj, mixin) {
    proto := classObj.Prototype
    for prop in ObjOwnProps(mixin)
        proto.DefineProp(prop, {Call: mixin.%prop%})
}

; =============================================================================
; 4. Multiple Inheritance via Delegation
; =============================================================================

class MultiBase {
    __New(bases*) {
        this._bases := bases
    }
    
    ; Delegate unknown properties/methods to bases
    __Get(name, params) {
        for base in this._bases {
            if HasProp(base, name)
                return base.%name%
        }
        throw PropertyError("Property not found: " name)
    }
    
    __Call(name, params) {
        for base in this._bases {
            if HasMethod(base, name)
                return base.%name%(params*)
        }
        throw MethodError("Method not found: " name)
    }
}

; =============================================================================
; 5. Prototype Chain Interception
; =============================================================================

class InterceptingProxy {
    __New(target, interceptor) {
        this._target := target
        this._interceptor := interceptor
    }
    
    __Get(name, params) {
        if this._interceptor.HasOwnProp("onGet")
            return this._interceptor.onGet(this._target, name)
        return this._target.%name%
    }
    
    __Set(name, params, value) {
        if this._interceptor.HasOwnProp("onSet")
            return this._interceptor.onSet(this._target, name, value)
        return this._target.%name% := value
    }
    
    __Call(name, params) {
        if this._interceptor.HasOwnProp("onCall")
            return this._interceptor.onCall(this._target, name, params)
        return this._target.%name%(params*)
    }
}

; =============================================================================
; 6. Prototype-Based Traits System
; =============================================================================

class Trait {
    static Define(methods) {
        trait := {}
        for name, fn in methods
            trait.%name% := fn
        return trait
    }
    
    static Apply(target, trait) {
        for prop in ObjOwnProps(trait) {
            if !target.HasOwnProp(prop)
                target.DefineProp(prop, {Call: trait.%prop%})
        }
    }
    
    static Compose(traits*) {
        composed := {}
        for trait in traits {
            for prop in ObjOwnProps(trait)
                composed.%prop% := trait.%prop%
        }
        return composed
    }
}

; =============================================================================
; 7. Object Slots and Hidden Properties
; =============================================================================

class SlottedObject {
    static _slots := Map()
    
    ; Private slot storage (not visible via OwnProps)
    static SetSlot(obj, name, value) {
        id := ObjPtr(obj)
        if !this._slots.Has(id)
            this._slots[id] := Map()
        this._slots[id][name] := value
    }
    
    static GetSlot(obj, name, default := "") {
        id := ObjPtr(obj)
        if this._slots.Has(id) && this._slots[id].Has(name)
            return this._slots[id][name]
        return default
    }
    
    static HasSlot(obj, name) {
        id := ObjPtr(obj)
        return this._slots.Has(id) && this._slots[id].Has(name)
    }
    
    static ClearSlots(obj) {
        id := ObjPtr(obj)
        if this._slots.Has(id)
            this._slots.Delete(id)
    }
}

; =============================================================================
; 8. Cloning and Shallow/Deep Copy
; =============================================================================

; Shallow clone
ShallowClone(obj) {
    clone := {}
    clone.base := obj.base
    
    for prop in ObjOwnProps(obj)
        clone.%prop% := obj.%prop%
    
    return clone
}

; Deep clone with circular reference handling
DeepClone(obj, seen := Map()) {
    ; Primitive types
    if !IsObject(obj)
        return obj
    
    ; Check for circular reference
    id := ObjPtr(obj)
    if seen.Has(id)
        return seen[id]
    
    ; Create clone based on type
    if obj is Array {
        clone := []
        seen[id] := clone
        for item in obj
            clone.Push(DeepClone(item, seen))
    } else if obj is Map {
        clone := Map()
        seen[id] := clone
        for key, value in obj
            clone[DeepClone(key, seen)] := DeepClone(value, seen)
    } else {
        clone := {}
        clone.base := obj.base
        seen[id] := clone
        for prop in ObjOwnProps(obj)
            clone.%prop% := DeepClone(obj.%prop%, seen)
    }
    
    return clone
}

; =============================================================================
; 9. Prototype Freezing
; =============================================================================

class FrozenObject {
    __New(source) {
        ; Copy all properties
        for prop in ObjOwnProps(source)
            this.DefineProp(prop, {Value: source.%prop%})
        
        ; Override __Set to prevent modification
        this.DefineProp("__Set", {
            Call: (self, name, params, value) => (
                throw Error("Cannot modify frozen object")
            )
        })
    }
}

Freeze(obj) => FrozenObject(obj)

; =============================================================================
; 10. Prototype Introspection
; =============================================================================

class Introspection {
    ; Get all properties including inherited
    static AllProps(obj) {
        props := Map()
        current := obj
        
        while current {
            for prop in ObjOwnProps(current)
                if !props.Has(prop)
                    props[prop] := {owner: Type(current), value: current.%prop%}
            
            current := HasProp(current, "base") ? current.base : ""
        }
        
        return props
    }
    
    ; Check if method is overridden
    static IsOverridden(obj, methodName) {
        if !obj.HasOwnProp(methodName)
            return false
        
        if !HasProp(obj, "base") || !obj.base
            return false
        
        return HasMethod(obj.base, methodName)
    }
    
    ; Get method resolution order (MRO)
    static MRO(classObj) {
        mro := [classObj]
        current := classObj
        
        while HasProp(current, "base") && current.base && current.base != Object {
            current := current.base
            mro.Push(current)
        }
        
        return mro
    }
}

; =============================================================================
; Demo
; =============================================================================

; Prototype chain
class A {
    MethodA() => "A"
}

class B extends A {
    MethodB() => "B"
}

class C extends B {
    MethodC() => "C"
}

c := C()
chain := DescribeProtoChain(c)
chainStr := ""
for t in chain
    chainStr .= (chainStr ? " → " : "") . t
MsgBox("Prototype Chain of C():`n`n" chainStr)

; Prototype swapping
pet := Dog()
MsgBox("Before morph: " pet.Speak())
MorphInto(pet, Cat)
MsgBox("After morph to Cat: " pet.Speak())

; Traits
Loggable := Trait.Define(Map(
    "Log", (self, msg) => MsgBox("[LOG] " self.name ": " msg),
    "Warn", (self, msg) => MsgBox("[WARN] " self.name ": " msg)
))

class Service {
    __New(name) => this.name := name
}

Trait.Apply(Service.Prototype, Loggable)
svc := Service("MyService")
svc.Log("Started")

; Deep clone with circular refs
circular := {name: "root"}
circular.self := circular  ; Circular reference!
cloned := DeepClone(circular)
MsgBox("Deep Clone with Circular Ref:`n`n"
    . "Original ptr: " ObjPtr(circular) "`n"
    . "Clone ptr: " ObjPtr(cloned) "`n"
    . "Clone.self ptr: " ObjPtr(cloned.self) "`n"
    . "Same as clone: " (ObjPtr(cloned) = ObjPtr(cloned.self)))

; Frozen object
original := {x: 1, y: 2}
frozen := Freeze(original)
MsgBox("Frozen Object:`n`n"
    . "frozen.x = " frozen.x "`n"
    . "Attempting to modify will throw error")

try {
    frozen.x := 999
} catch Error as e {
    MsgBox("Caught: " e.Message)
}

; Introspection
allProps := Introspection.AllProps(c)
propsStr := ""
for name, info in allProps
    propsStr .= name " (from " info.owner ")`n"
MsgBox("All Properties of C instance:`n`n" propsStr)

; MRO
mro := Introspection.MRO(C)
mroStr := ""
for classItem in mro
    mroStr .= (mroStr ? " → " : "") . (classItem.HasOwnProp("__Class") ? classItem.__Class : Type(classItem))
MsgBox("Method Resolution Order:`n`n" mroStr)
