#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric Reflection - Runtime type inspection and dynamic manipulation
; Demonstrates deep introspection capabilities in AHK v2

; =============================================================================
; 1. Type Information
; =============================================================================

class TypeInfo {
    ; Get detailed type information
    static Of(value) {
        info := {
            type: Type(value),
            isObject: IsObject(value),
            isCallable: value is Func || HasMethod(value, "Call"),
            isPrimitive: !IsObject(value)
        }
        
        if IsObject(value) {
            info.hasBase := HasProp(value, "base")
            info.ownPropCount := ObjOwnPropCount(value)
            info.ptr := ObjPtr(value)
            
            if value is Array
                info.length := value.Length
            else if value is Map
                info.count := value.Count
        }
        
        return info
    }
    
    ; Get inheritance chain
    static Hierarchy(obj) {
        chain := []
        current := obj
        
        while IsObject(current) {
            chain.Push(Type(current))
            if !HasProp(current, "base") || !current.base
                break
            current := current.base
        }
        
        return chain
    }
    
    ; Check if value implements interface (duck typing)
    static Implements(obj, interface) {
        for methodName in interface {
            if !HasMethod(obj, methodName)
                return false
        }
        return true
    }
}

; =============================================================================
; 2. Property Descriptor Reflection
; =============================================================================

class PropReflection {
    ; Get property descriptor
    static GetDescriptor(obj, propName) {
        if !obj.HasOwnProp(propName)
            return ""
        
        desc := obj.GetOwnPropDesc(propName)
        return {
            name: propName,
            hasValue: desc.HasOwnProp("Value"),
            hasGetter: desc.HasOwnProp("Get"),
            hasSetter: desc.HasOwnProp("Set"),
            hasCall: desc.HasOwnProp("Call"),
            value: desc.HasOwnProp("Value") ? desc.Value : "",
            getter: desc.HasOwnProp("Get") ? desc.Get : "",
            setter: desc.HasOwnProp("Set") ? desc.Set : "",
            caller: desc.HasOwnProp("Call") ? desc.Call : ""
        }
    }
    
    ; Get all property descriptors
    static GetAllDescriptors(obj, includeInherited := false) {
        descriptors := Map()
        
        current := obj
        while IsObject(current) {
            for propName in ObjOwnProps(current)
                if !descriptors.Has(propName)
                    descriptors[propName] := PropReflection.GetDescriptor(current, propName)
            
            if !includeInherited || !HasProp(current, "base") || !current.base
                break
            current := current.base
        }
        
        return descriptors
    }
    
    ; Copy property with descriptor
    static CopyProperty(source, target, propName) {
        if !source.HasOwnProp(propName)
            return false
        
        desc := source.GetOwnPropDesc(propName)
        target.DefineProp(propName, desc)
        return true
    }
}

; =============================================================================
; 3. Method Reflection
; =============================================================================

class MethodReflection {
    ; Get all methods (own and inherited)
    static GetMethods(obj, includeInherited := true) {
        methods := Map()
        current := obj
        
        while IsObject(current) {
            for propName in ObjOwnProps(current) {
                if methods.Has(propName)
                    continue
                
                desc := current.GetOwnPropDesc(propName)
                if desc.HasOwnProp("Call")
                    methods[propName] := {
                        name: propName,
                        owner: Type(current),
                        fn: desc.Call
                    }
            }
            
            if !includeInherited || !HasProp(current, "base") || !current.base
                break
            current := current.base
        }
        
        return methods
    }
    
    ; Check if method is overridden
    static IsOverridden(derived, base, methodName) {
        if !HasMethod(derived, methodName) || !HasMethod(base, methodName)
            return false
        
        derivedFn := derived.GetOwnPropDesc(methodName)
        baseFn := base.GetOwnPropDesc(methodName)
        
        if !derivedFn.HasOwnProp("Call") || !baseFn.HasOwnProp("Call")
            return false
        
        return ObjPtr(derivedFn.Call) != ObjPtr(baseFn.Call)
    }
    
    ; Get method parameters (limited in AHK)
    static GetParameters(fn) {
        ; AHK doesn't expose parameter names, but we can get some info
        return {
            minParams: fn.MinParams,
            maxParams: fn.MaxParams,
            isVariadic: fn.IsVariadic,
            isBIM: fn is BoundFunc
        }
    }
}

; =============================================================================
; 4. Dynamic Invocation
; =============================================================================

class DynamicInvoke {
    ; Invoke method by name
    static Method(obj, methodName, args*) {
        if !HasMethod(obj, methodName)
            throw MethodError("Method not found: " methodName)
        return obj.%methodName%(args*)
    }
    
    ; Get property by name
    static GetProp(obj, propName, defaultValue := "") {
        try {
            return obj.%propName%
        } catch {
            return defaultValue
        }
    }
    
    ; Set property by name
    static SetProp(obj, propName, value) {
        obj.%propName% := value
        return value
    }
    
    ; Invoke with apply-like semantics
    static Apply(fn, args) {
        return fn(args*)
    }
    
    ; Construct object by class name string
    static Construct(className, args*) {
        ; Need to resolve class from global scope
        try {
            classObj := %className%
            return classObj(args*)
        } catch {
            throw Error("Class not found: " className)
        }
    }
}

; =============================================================================
; 5. Object Comparison and Equality
; =============================================================================

class ObjectCompare {
    ; Deep equality check
    static Equals(a, b, maxDepth := 10) {
        return this._equalsRecursive(a, b, maxDepth, Map())
    }
    
    static _equalsRecursive(a, b, depth, seen) {
        ; Same reference
        if IsObject(a) && IsObject(b) && ObjPtr(a) = ObjPtr(b)
            return true
        
        ; Different types
        if Type(a) != Type(b)
            return false
        
        ; Primitives
        if !IsObject(a)
            return a = b
        
        ; Depth limit
        if depth <= 0
            return true
        
        ; Circular reference check
        ptrA := ObjPtr(a)
        if seen.Has(ptrA)
            return true
        seen[ptrA] := true
        
        ; Arrays
        if a is Array {
            if a.Length != b.Length
                return false
            for i, v in a {
                if !this._equalsRecursive(v, b[i], depth - 1, seen)
                    return false
            }
            return true
        }
        
        ; Maps
        if a is Map {
            if a.Count != b.Count
                return false
            for k, v in a {
                if !b.Has(k) || !this._equalsRecursive(v, b[k], depth - 1, seen)
                    return false
            }
            return true
        }
        
        ; Objects
        propsA := []
        propsB := []
        for p in ObjOwnProps(a)
            propsA.Push(p)
        for p in ObjOwnProps(b)
            propsB.Push(p)
        
        if propsA.Length != propsB.Length
            return false
        
        for prop in propsA {
            if !b.HasOwnProp(prop)
                return false
            if !this._equalsRecursive(a.%prop%, b.%prop%, depth - 1, seen)
                return false
        }
        
        return true
    }
    
    ; Generate hash code for object
    static Hash(obj) {
        if !IsObject(obj)
            return this._hashPrimitive(obj)
        
        hash := 17
        for prop in ObjOwnProps(obj) {
            propHash := this._hashString(prop)
            valHash := this.Hash(obj.%prop%)
            hash := hash * 31 + propHash
            hash := hash * 31 + valHash
        }
        
        return hash
    }
    
    static _hashString(s) {
        hash := 0
        loop StrLen(s) {
            hash := hash * 31 + Ord(SubStr(s, A_Index, 1))
            hash := Mod(hash, 0x7FFFFFFF)
        }
        return hash
    }
    
    static _hashPrimitive(v) {
        if v is Number
            return Integer(v * 1000) & 0x7FFFFFFF
        return this._hashString(String(v))
    }
}

; =============================================================================
; 6. Object Serialization
; =============================================================================

class Serializer {
    ; Serialize to string representation
    static Stringify(obj, indent := 0) {
        if !IsObject(obj)
            return this._stringifyPrimitive(obj)
        
        spaces := this._repeat("  ", indent)
        innerSpaces := this._repeat("  ", indent + 1)
        
        if obj is Array {
            if obj.Length = 0
                return "[]"
            
            parts := []
            for item in obj
                parts.Push(innerSpaces . this.Stringify(item, indent + 1))
            
            return "[`n" this._join(parts, ",`n") "`n" spaces "]"
        }
        
        if obj is Map {
            if obj.Count = 0
                return "Map()"
            
            parts := []
            for k, v in obj
                parts.Push(innerSpaces . this._stringifyPrimitive(k) . " => " . this.Stringify(v, indent + 1))
            
            return "Map(`n" this._join(parts, ",`n") "`n" spaces ")"
        }
        
        ; Generic object
        props := []
        for propName in ObjOwnProps(obj)
            props.Push(propName)
        
        if props.Length = 0
            return "{}"
        
        parts := []
        for propName in props
            parts.Push(innerSpaces . propName . ": " . this.Stringify(obj.%propName%, indent + 1))
        
        return "{`n" this._join(parts, ",`n") "`n" spaces "}"
    }
    
    static _stringifyPrimitive(v) {
        if v is String
            return '"' . StrReplace(StrReplace(v, "\", "\\"), '"', '\"') . '"'
        if v = ""
            return '""'
        return String(v)
    }
    
    static _repeat(s, n) {
        result := ""
        loop n
            result .= s
        return result
    }
    
    static _join(arr, sep) {
        result := ""
        for i, v in arr
            result .= (i > 1 ? sep : "") . v
        return result
    }
}

; =============================================================================
; 7. Object Diffing
; =============================================================================

class ObjectDiff {
    ; Compare two objects and return differences
    static Diff(a, b) {
        changes := []
        this._diffRecursive(a, b, "", changes)
        return changes
    }
    
    static _diffRecursive(a, b, path, changes) {
        ; Type change
        if Type(a) != Type(b) {
            changes.Push({
                type: "type_change",
                path: path,
                from: Type(a),
                to: Type(b)
            })
            return
        }
        
        ; Primitives
        if !IsObject(a) {
            if a != b {
                changes.Push({
                    type: "value_change",
                    path: path,
                    from: a,
                    to: b
                })
            }
            return
        }
        
        ; Arrays
        if a is Array {
            maxLen := Max(a.Length, b.Length)
            loop maxLen {
                i := A_Index
                itemPath := path . "[" . i . "]"
                
                if i > a.Length {
                    changes.Push({type: "added", path: itemPath, value: b[i]})
                } else if i > b.Length {
                    changes.Push({type: "removed", path: itemPath, value: a[i]})
                } else {
                    this._diffRecursive(a[i], b[i], itemPath, changes)
                }
            }
            return
        }
        
        ; Objects
        allProps := Map()
        for p in ObjOwnProps(a)
            allProps[p] := true
        for p in ObjOwnProps(b)
            allProps[p] := true
        
        for prop, _ in allProps {
            propPath := path = "" ? prop : path . "." . prop
            
            if !a.HasOwnProp(prop) {
                changes.Push({type: "added", path: propPath, value: b.%prop%})
            } else if !b.HasOwnProp(prop) {
                changes.Push({type: "removed", path: propPath, value: a.%prop%})
            } else {
                this._diffRecursive(a.%prop%, b.%prop%, propPath, changes)
            }
        }
    }
}

; =============================================================================
; 8. Annotation/Decorator Storage
; =============================================================================

class Annotations {
    static _store := Map()
    
    ; Add annotation to object
    static Add(obj, key, value) {
        id := ObjPtr(obj)
        if !this._store.Has(id)
            this._store[id] := Map()
        this._store[id][key] := value
    }
    
    ; Get annotation
    static Get(obj, key, default := "") {
        id := ObjPtr(obj)
        if !this._store.Has(id)
            return default
        return this._store[id].Get(key, default)
    }
    
    ; Check if has annotation
    static Has(obj, key) {
        id := ObjPtr(obj)
        return this._store.Has(id) && this._store[id].Has(key)
    }
    
    ; Get all annotations for object
    static All(obj) {
        id := ObjPtr(obj)
        return this._store.Get(id, Map())
    }
    
    ; Clear annotations
    static Clear(obj) {
        id := ObjPtr(obj)
        if this._store.Has(id)
            this._store.Delete(id)
    }
}

; =============================================================================
; Demo
; =============================================================================

; Type information
class TestClass {
    Value := 42
    Method() => "test"
}

obj := TestClass()
info := TypeInfo.Of(obj)
MsgBox("TypeInfo:`n`n"
    . "Type: " info.type "`n"
    . "IsObject: " info.isObject "`n"
    . "IsCallable: " info.isCallable "`n"
    . "OwnPropCount: " info.ownPropCount)

; Hierarchy
class A {}
class B extends A {}
class C extends B {}

hierarchy := TypeInfo.Hierarchy(C())
MsgBox("Inheritance Hierarchy:`n`n" _ArrayJoin(hierarchy, " → "))

; Property descriptors
class PropDemo {
    _value := 0
    
    Computed {
        get => this._value * 2
        set => this._value := value / 2
    }
}

pd := PropDemo()
desc := PropReflection.GetDescriptor(pd, "_value")
MsgBox("Property Descriptor (_value):`n`n"
    . "hasValue: " desc.hasValue "`n"
    . "hasGetter: " desc.hasGetter "`n"
    . "hasSetter: " desc.hasSetter)

; Dynamic invocation
class Calculator {
    Add(a, b) => a + b
    Sub(a, b) => a - b
}

calc := Calculator()
result := DynamicInvoke.Method(calc, "Add", 10, 5)
MsgBox("Dynamic Invoke:`n`ncalc.Add(10, 5) = " result)

; Object comparison
obj1 := {a: 1, b: {c: 2}}
obj2 := {a: 1, b: {c: 2}}
obj3 := {a: 1, b: {c: 3}}

MsgBox("Object Equality:`n`n"
    . "obj1 == obj2: " ObjectCompare.Equals(obj1, obj2) "`n"
    . "obj1 == obj3: " ObjectCompare.Equals(obj1, obj3))

; Serialization
complex := {
    name: "Test",
    values: [1, 2, 3],
    nested: {x: 10, y: 20}
}
MsgBox("Serialized:`n`n" Serializer.Stringify(complex))

; Object diff
before := {x: 1, y: 2, z: 3}
after := {x: 1, y: 5, w: 4}

diffs := ObjectDiff.Diff(before, after)
diffStr := ""
for d in diffs
    diffStr .= d.type . " @ " . d.path . "`n"
MsgBox("Object Diff:`n`n" diffStr)

; Annotations
class Service {}
svc := Service()

Annotations.Add(svc, "route", "/api/users")
Annotations.Add(svc, "method", "GET")
Annotations.Add(svc, "auth", true)

MsgBox("Annotations:`n`n"
    . "route: " Annotations.Get(svc, "route") "`n"
    . "method: " Annotations.Get(svc, "method") "`n"
    . "auth: " Annotations.Get(svc, "auth"))

_ArrayJoin(arr, sep) {
    result := ""
    for i, v in arr
        result .= (i > 1 ? sep : "") . String(v)
    return result
}
