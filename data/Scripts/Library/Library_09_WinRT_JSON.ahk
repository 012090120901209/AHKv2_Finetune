#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
* WinRT - JSON Manipulation
*
* Demonstrates using Windows.Data.Json for parsing, creating, and
* manipulating JSON data with Windows Runtime APIs.
*
* Library: https://github.com/Lexikos/winrt.ahk
*/

MsgBox("WinRT - JSON Example`n`n"
. "Demonstrates Windows Runtime JSON APIs`n"
. "Requires: winrt.ahk and Windows 10+", , "T3")

/*
; Uncomment to run (requires winrt.ahk):

#Include <winrt.ahk>

; Get JSON classes
JsonObject := WinRT('Windows.Data.Json.JsonObject')
JsonArray := WinRT('Windows.Data.Json.JsonArray')
JsonValue := WinRT('Windows.Data.Json.JsonValue')

; Example 1: Parse JSON string
MsgBox("Example 1: Parsing JSON...", , "T2")

jsonText := '{"name":"Alice","age":30,"email":"alice@example.com","active":true}'

if (JsonObject.TryParse(jsonText, &obj)) {
    name := obj.GetNamedString("name")
    age := obj.GetNamedNumber("age")
    email := obj.GetNamedString("email")
    active := obj.GetNamedBoolean("active")

    MsgBox("Parsed JSON:`n`n"
    . "Name: " name "`n"
    . "Age: " age "`n"
    . "Email: " email "`n"
    . "Active: " active, , "T5")
}

; Example 2: Create JSON object
MsgBox("Example 2: Creating JSON object...", , "T2")

newObj := JsonObject.Construct()
newObj.SetNamedValue("id", JsonValue.CreateNumberValue(123))
newObj.SetNamedValue("title", JsonValue.CreateStringValue("Hello World"))
newObj.SetNamedValue("completed", JsonValue.CreateBooleanValue(false))
newObj.SetNamedValue("priority", JsonValue.CreateNumberValue(5))

jsonStr := newObj.Stringify()
MsgBox("Created JSON:`n`n" jsonStr, , "T5")

; Example 3: JSON arrays
MsgBox("Example 3: Working with arrays...", , "T2")

arr := JsonArray.Construct()
arr.Append(JsonValue.CreateStringValue("apple"))
arr.Append(JsonValue.CreateStringValue("banana"))
arr.Append(JsonValue.CreateStringValue("cherry"))

arrayObj := JsonObject.Construct()
arrayObj.SetNamedValue("fruits", arr)

arrayJson := arrayObj.Stringify()
MsgBox("JSON with array:`n`n" arrayJson, , "T5")

; Example 4: Nested objects
MsgBox("Example 4: Nested JSON objects...", , "T2")

address := JsonObject.Construct()
address.SetNamedValue("street", JsonValue.CreateStringValue("123 Main St"))
address.SetNamedValue("city", JsonValue.CreateStringValue("New York"))
address.SetNamedValue("zip", JsonValue.CreateStringValue("10001"))

person := JsonObject.Construct()
person.SetNamedValue("name", JsonValue.CreateStringValue("Bob"))
person.SetNamedValue("age", JsonValue.CreateNumberValue(25))
person.SetNamedValue("address", address)

nestedJson := person.Stringify()
MsgBox("Nested JSON:`n`n" nestedJson, , "T5")

; Example 5: Parse complex JSON
MsgBox("Example 5: Complex JSON parsing...", , "T2")

complexJson := '
(
{
    "users": [
    {
        "id": 1, "name": "Alice"},
        {
            "id": 2, "name": "Bob"},
            {
                "id": 3, "name": "Charlie"
            }
            ],
            "meta": {
                "count": 3,
                "page": 1
            }
        }
        )'

        if (JsonObject.TryParse(complexJson, &data)) {
            ; Get array
            users := data.GetNamedArray("users")
            count := users.Size

            ; Get first user
            firstUser := users.GetObjectAt(0)
            firstName := firstUser.GetNamedString("name")

            ; Get metadata
            meta := data.GetNamedObject("meta")
            totalCount := meta.GetNamedNumber("count")

            MsgBox("Complex JSON:`n`n"
            . "Users: " count "`n"
            . "First: " firstName "`n"
            . "Total: " totalCount, , "T5")
        }

        ; Example 6: Modify existing JSON
        MsgBox("Example 6: Modifying JSON...", , "T2")

        if (JsonObject.TryParse('{"x":10,"y":20}', &point)) {
            ; Modify values
            point.SetNamedValue("x", JsonValue.CreateNumberValue(30))
            point.SetNamedValue("y", JsonValue.CreateNumberValue(40))

            ; Add new value
            point.SetNamedValue("z", JsonValue.CreateNumberValue(50))

            modified := point.Stringify()
            MsgBox("Modified JSON:`n`n" modified, , "T3")
        }

        ; Example 7: Type checking
        MsgBox("Example 7: Checking value types...", , "T2")

        testJson := '{"str":"text","num":42,"bool":true,"null":null}'

        if (JsonObject.TryParse(testJson, &test)) {
            strType := test.GetNamedValue("str").ValueType  ; 2 = String
            numType := test.GetNamedValue("num").ValueType  ; 3 = Number
            boolType := test.GetNamedValue("bool").ValueType  ; 4 = Boolean
            nullType := test.GetNamedValue("null").ValueType  ; 0 = Null

            types := Map(
            0, "Null",
            1, "Boolean",
            2, "Number",
            3, "String",
            4, "Array",
            5, "Object"
            )

            MsgBox("Value Types:`n`n"
            . "str: " types[strType] "`n"
            . "num: " types[numType] "`n"
            . "bool: " types[boolType] "`n"
            . "null: " types[nullType], , "T5")
        }
        */

        /*
        * Key Concepts:
        *
        * 1. JSON Classes:
        *    JsonObject - Key-value pairs
        *    JsonArray - Ordered list
        *    JsonValue - Primitive values
        *
        * 2. Parsing:
        *    JsonObject.TryParse(text, &obj)
        *    Returns true if successful
        *    Output to reference parameter
        *
        * 3. Getting Values:
        *    GetNamedString(key) - String
        *    GetNamedNumber(key) - Number
        *    GetNamedBoolean(key) - Boolean
        *    GetNamedObject(key) - Object
        *    GetNamedArray(key) - Array
        *
        * 4. Setting Values:
        *    SetNamedValue(key, JsonValue.Create...)
        *    JsonValue.CreateStringValue(str)
        *    JsonValue.CreateNumberValue(num)
        *    JsonValue.CreateBooleanValue(bool)
        *    JsonValue.CreateNullValue()
        *
        * 5. Array Operations:
        *    arr.Append(value) - Add to end
        *    arr.GetObjectAt(index) - Get by index
        *    arr.Size - Array length
        *
        * 6. Stringify:
        *    obj.Stringify() - Convert to string
        *    Compact format (no whitespace)
        *
        * 7. Value Types:
        *    0 = Null
        *    1 = Boolean
        *    2 = Number
        *    3 = String
        *    4 = Array
        *    5 = Object
        *
        * 8. Use Cases:
        *    ✅ API responses
        *    ✅ Configuration files
        *    ✅ Data exchange
        *    ✅ Settings storage
        *    ✅ Log parsing
        *
        * 9. Advantages:
        *    ✅ Native Windows API
        *    ✅ Fast performance
        *    ✅ Type-safe access
        *    ✅ Built-in validation
        *
        * 10. Best Practices:
        *     ✅ Check TryParse result
        *     ✅ Handle missing keys
        *     ✅ Validate value types
        *     ✅ Use try/catch
        *
        * 11. Comparison to JavaScript:
        *     WinRT: Type-safe, verbose
        *     JS: Dynamic, concise
        *     WinRT: Better for large data
        *     JS: Better for small tasks
        *
        * 12. Error Handling:
        *     TryParse returns false on error
        *     GetNamed* throws if key missing
        *     Check HasKey() first
        */
