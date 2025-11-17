#Requires AutoHotkey v2.0
/**
 * BuiltIn_Binary_03_Serialization.ahk
 *
 * DESCRIPTION:
 * Data serialization and deserialization using binary formats.
 * Converting objects/data structures to binary and back.
 *
 * FEATURES:
 * - Object serialization to binary
 * - Binary deserialization to objects
 * - Complex data structure handling
 * - Version-aware serialization
 * - Compact binary formats
 * - Data persistence
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - Binary Operations
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - Custom serialization protocols
 * - Binary data packing
 * - Object reconstruction
 * - Type encoding/decoding
 * - Efficient data storage
 *
 * LEARNING POINTS:
 * 1. Serialization converts objects to byte streams
 * 2. Binary format is more compact than text
 * 3. Type information must be preserved
 * 4. Versioning enables format evolution
 * 5. Deserialization must match serialization format
 */

; ================================================================================================
; EXAMPLE 1: Simple Object Serialization
; ================================================================================================

Example1_SimpleObject() {
    class Serializer {
        static SerializeUser(user) {
            nameBytes := StrPut(user.name, "UTF-8")
            emailBytes := StrPut(user.email, "UTF-8")

            bufSize := 4 + 4 + 4 + nameBytes + emailBytes
            buf := Buffer(bufSize)

            offset := 0

            ; Write ID
            NumPut("Int", user.id, buf, offset)
            offset += 4

            ; Write name
            NumPut("Int", nameBytes, buf, offset)
            offset += 4
            StrPut(user.name, buf.Ptr + offset, nameBytes, "UTF-8")
            offset += nameBytes

            ; Write email
            NumPut("Int", emailBytes, buf, offset)
            offset += 4
            StrPut(user.email, buf.Ptr + offset, emailBytes, "UTF-8")

            return buf
        }

        static DeserializeUser(buf) {
            offset := 0

            ; Read ID
            id := NumGet(buf, offset, "Int")
            offset += 4

            ; Read name
            nameLen := NumGet(buf, offset, "Int")
            offset += 4
            name := StrGet(buf.Ptr + offset, nameLen, "UTF-8")
            offset += nameLen

            ; Read email
            emailLen := NumGet(buf, offset, "Int")
            offset += 4
            email := StrGet(buf.Ptr + offset, emailLen, "UTF-8")

            return {id: id, name: name, email: email}
        }
    }

    ; Create and serialize
    user := {id: 1001, name: "John Doe", email: "john@example.com"}
    serialized := Serializer.SerializeUser(user)

    ; Deserialize
    deserialized := Serializer.DeserializeUser(serialized)

    result := "Object Serialization:`n`n"
    result .= "Original:`n"
    result .= "  ID: " . user.id . "`n"
    result .= "  Name: " . user.name . "`n"
    result .= "  Email: " . user.email . "`n`n"

    result .= "Serialized Size: " . serialized.Size . " bytes`n`n"

    result .= "Deserialized:`n"
    result .= "  ID: " . deserialized.id . "`n"
    result .= "  Name: " . deserialized.name . "`n"
    result .= "  Email: " . deserialized.email

    MsgBox(result, "Example 1: Simple Serialization", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: Array Serialization
; ================================================================================================

Example2_ArraySerialization() {
    class ArraySerializer {
        static Serialize(arr) {
            ; Calculate size
            totalSize := 4  ; Count

            for item in arr {
                totalSize += 4  ; Item size prefix
                totalSize += 4  ; Integer value
            }

            buf := Buffer(totalSize)
            offset := 0

            ; Write count
            NumPut("Int", arr.Length, buf, offset)
            offset += 4

            ; Write items
            for item in arr {
                NumPut("Int", 4, buf, offset)  ; Size
                offset += 4
                NumPut("Int", item, buf, offset)  ; Value
                offset += 4
            }

            return buf
        }

        static Deserialize(buf) {
            offset := 0
            arr := []

            ; Read count
            count := NumGet(buf, offset, "Int")
            offset += 4

            ; Read items
            loop count {
                itemSize := NumGet(buf, offset, "Int")
                offset += 4
                value := NumGet(buf, offset, "Int")
                offset += 4
                arr.Push(value)
            }

            return arr
        }
    }

    ; Serialize array
    original := [100, 200, 300, 400, 500]
    serialized := ArraySerializer.Serialize(original)
    deserialized := ArraySerializer.Deserialize(serialized)

    result := "Array Serialization:`n`n"
    result .= "Original: ["
    for val in original {
        result .= val . (A_Index < original.Length ? ", " : "")
    }
    result .= "]`n`n"

    result .= "Serialized Size: " . serialized.Size . " bytes`n`n"

    result .= "Deserialized: ["
    for val in deserialized {
        result .= val . (A_Index < deserialized.Length ? ", " : "")
    }
    result .= "]"

    MsgBox(result, "Example 2: Array Serialization", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Complex Structure Serialization
; ================================================================================================

Example3_ComplexStructure() {
    class ComplexSerializer {
        static Serialize(obj) {
            ; Estimate size
            buf := Buffer(1024)
            offset := 0

            ; Version
            NumPut("UShort", 1, buf, offset)
            offset += 2

            ; Type
            NumPut("UShort", obj.type, buf, offset)
            offset += 2

            ; ID
            NumPut("Int", obj.id, buf, offset)
            offset += 4

            ; Timestamp
            NumPut("UInt64", obj.timestamp, buf, offset)
            offset += 8

            ; Data count
            NumPut("Int", obj.data.Length, buf, offset)
            offset += 4

            ; Data items
            for item in obj.data {
                NumPut("Float", item, buf, offset)
                offset += 4
            }

            ; Return actual size buffer
            final := Buffer(offset)
            DllCall("RtlMoveMemory", "Ptr", final.Ptr, "Ptr", buf.Ptr, "UPtr", offset)
            return final
        }

        static Deserialize(buf) {
            offset := 0

            ; Version
            version := NumGet(buf, offset, "UShort")
            offset += 2

            ; Type
            type := NumGet(buf, offset, "UShort")
            offset += 2

            ; ID
            id := NumGet(buf, offset, "Int")
            offset += 4

            ; Timestamp
            timestamp := NumGet(buf, offset, "UInt64")
            offset += 8

            ; Data count
            count := NumGet(buf, offset, "Int")
            offset += 4

            ; Data items
            data := []
            loop count {
                data.Push(NumGet(buf, offset, "Float"))
                offset += 4
            }

            return {
                version: version,
                type: type,
                id: id,
                timestamp: timestamp,
                data: data
            }
        }
    }

    ; Create complex object
    obj := {
        type: 42,
        id: 1001,
        timestamp: 1700000000,
        data: [1.5, 2.7, 3.9, 4.2, 5.1]
    }

    ; Serialize
    serialized := ComplexSerializer.Serialize(obj)
    deserialized := ComplexSerializer.Deserialize(serialized)

    result := "Complex Structure Serialization:`n`n"
    result .= "Original:`n"
    result .= "  Type: " . obj.type . "`n"
    result .= "  ID: " . obj.id . "`n"
    result .= "  Timestamp: " . obj.timestamp . "`n"
    result .= "  Data Items: " . obj.data.Length . "`n`n"

    result .= "Serialized Size: " . serialized.Size . " bytes`n`n"

    result .= "Deserialized:`n"
    result .= "  Version: " . deserialized.version . "`n"
    result .= "  Type: " . deserialized.type . "`n"
    result .= "  ID: " . deserialized.id . "`n"
    result .= "  Data: ["
    for val in deserialized.data {
        result .= Format("{:.1f}", val) . (A_Index < deserialized.data.Length ? ", " : "")
    }
    result .= "]"

    MsgBox(result, "Example 3: Complex Structure", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
    (
    Binary Serialization Examples

    1. Simple Object Serialization
    2. Array Serialization
    3. Complex Structure Serialization

    Select an example (1-3) or press Cancel to exit:
    )"

    choice := InputBox(menu, "Binary Serialization", "w450 h250")

    if choice.Result = "Cancel"
        return

    switch choice.Value {
        case "1": Example1_SimpleObject()
        case "2": Example2_ArraySerialization()
        case "3": Example3_ComplexStructure()
        default: MsgBox("Invalid selection. Please choose 1-3.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()
