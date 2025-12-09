#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
* ActiveScript - JSON Manipulation with JavaScript
*
* Demonstrates using JavaScript's native JSON capabilities for parsing,
* manipulating, and stringifying JSON data.
*
* Library: https://github.com/Lexikos/ActiveScript.ahk
*/

MsgBox("ActiveScript - JSON Example`n`n"
. "Demonstrates JavaScript JSON manipulation`n"
. "Requires: ActiveScript.ahk in Lib folder", , "T3")

/*
; Uncomment to run (requires ActiveScript.ahk):

#Include <ActiveScript>

; Create JScript engine
script := ActiveScript("JScript")

; Example 1: Parse complex JSON
jsonData := '
(
{
    "users": [
    {
        "id": 1, "name": "Alice", "email": "alice@example.com", "active": true},
        {
            "id": 2, "name": "Bob", "email": "bob@example.com", "active": false},
            {
                "id": 3, "name": "Charlie", "email": "charlie@example.com", "active": true
            }
            ],
            "metadata": {
                "total": 3,
                "timestamp": "2024-01-15T10:30:00Z"
            }
        }
        )'

        ; Parse in JavaScript
        script.Exec("var data = JSON.parse('" StrReplace(jsonData, "'", "\'") "')")

        ; Query data
        total := script.Eval("data.metadata.total")
        firstUser := script.Eval("data.users[0].name")
        activeCount := script.Eval("data.users.filter(function(u) { return u.active; }).length")

        MsgBox("JSON Parsing:`n`n"
        . "Total users: " total "`n"
        . "First user: " firstUser "`n"
        . "Active users: " activeCount, , "T5")

        ; Example 2: Transform data with JavaScript
        script.Exec("
        (
        var activeUsers = data.users
        .filter(function(u) { return u.active; })
        .map(function(u) { return {name: u.name, email: u.email}; });
        )")

        activeJson := script.Eval("JSON.stringify(activeUsers, null, 2)")
        MsgBox("Filtered Active Users:`n`n" activeJson, , "T5")

        ; Example 3: Create JSON from AHK data
        script.Exec("var newUser = {}")
        script.Exec("newUser.id = 4")
        script.Exec("newUser.name = 'David'")
        script.Exec("newUser.email = 'david@example.com'")
        script.Exec("newUser.active = true")
        script.Exec("newUser.created = new Date().toISOString()")

        newUserJson := script.Eval("JSON.stringify(newUser, null, 2)")
        MsgBox("Created User:`n`n" newUserJson, , "T5")

        ; Example 4: Array operations with reduce
        script.Exec("
        (
        var stats = data.users.reduce(function(acc, user) {
            acc.total++;
            if (user.active) acc.active++;
            else acc.inactive++;
            return acc;
        }, {total: 0, active: 0, inactive: 0});
        )")

        stats := script.Eval("JSON.stringify(stats)")
        MsgBox("User Statistics:`n`n" stats, , "T3")
        */

        /*
        * Key Concepts:
        *
        * 1. JSON Parsing:
        *    script.Exec("var obj = JSON.parse(jsonString)")
        *    Native JavaScript JSON parser
        *    Faster than AHK parsing
        *
        * 2. JSON Stringification:
        *    json := script.Eval("JSON.stringify(obj, null, 2)")
        *    Second param: replacer (null = all)
        *    Third param: indentation (2 spaces)
        *
        * 3. JavaScript Array Methods:
        *    .filter(fn) - Filter elements
        *    .map(fn) - Transform elements
        *    .reduce(fn, init) - Aggregate
        *    .find(fn) - Find first match
        *
        * 4. Escaping Strings:
        *    StrReplace(json, "'", "\'")
        *    Escape quotes when passing to JS
        *    Or use different quote style
        *
        * 5. Use Cases:
        *    ✅ Complex JSON parsing
        *    ✅ API response processing
        *    ✅ Data transformation
        *    ✅ JSON validation
        *    ✅ Nested data queries
        *
        * 6. Advantages over AHK:
        *    ✅ Native JSON support
        *    ✅ Powerful array methods
        *    ✅ Functional programming
        *    ✅ Built-in validation
        *
        * 7. Performance:
        *    For large JSON: JavaScript faster
        *    For simple parsing: AHK sufficient
        *    Balance interop overhead
        *
        * 8. Best Practices:
        *    ✅ Validate JSON first
        *    ✅ Handle errors with try/catch
        *    ✅ Cache parsed objects
        *    ✅ Minimize JS/AHK transitions
        */
