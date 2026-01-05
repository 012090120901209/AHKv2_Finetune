#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
 * ActiveScript Library - JScript Integration
 * 
 * Demonstrates using Lexikos' ActiveScript.ahk library to execute
 * JScript (JavaScript) code within AutoHotkey and exchange data.
 * 
 * Library: https://github.com/Lexikos/ActiveScript.ahk
 * Note: This example assumes ActiveScript.ahk is installed in Lib folder
 */

; NOTE: This is a demonstration. To run, you need to:
; 1. Download ActiveScript.ahk from https://github.com/Lexikos/ActiveScript.ahk
; 2. Place it in your Lib folder
; 3. Uncomment the code below

MsgBox("ActiveScript Library Example`n`n"
    . "This demonstrates JScript integration.`n`n"
    . "To use this library:`n"
    . "1. Download from github.com/Lexikos/ActiveScript.ahk`n"
    . "2. Place in Lib folder`n"
    . "3. Uncomment the example code", , "T5")

/*
; Uncomment to test (requires library installation):

#Include <ActiveScript>

; Example 1: Basic arithmetic
script := ActiveScript("JScript")
result := script.Eval("2 + 2 * 10")
MsgBox("JScript Eval: 2 + 2 * 10 = " result, , "T3")

; Example 2: String operations
script.Exec("var greeting = 'Hello from JScript!';")
msg := script.Eval("greeting.toUpperCase()")
MsgBox("String operation: " msg, , "T3")

; Example 3: Functions
script.Exec("
(
function factorial(n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}
)")
fact5 := script.Eval("factorial(5)")
MsgBox("JScript factorial(5) = " fact5, , "T3")

; Example 4: Inject AHK objects
ahkObj := {
    ShowMessage: (msg) => MsgBox(msg, "From JScript", "T3"),
    GetTime: () => FormatTime(, "HH:mm:ss")
}

script.AddObject("AHK", ahkObj)
script.Exec("AHK.ShowMessage('Hello from JScript calling AHK!')")

time := script.Eval("AHK.GetTime()")
MsgBox("Current time via JScript: " time, , "T3")

; Example 5: JSON parsing
jsonStr := '{"name":"Alice","age":30,"city":"NYC"}'
script.Exec("var data = " jsonStr)
name := script.Eval("data.name")
age := script.Eval("data.age")
MsgBox("Parsed JSON:`nName: " name "`nAge: " age, , "T3")

; Example 6: Array operations
script.Exec("var numbers = [1, 2, 3, 4, 5];")
sum := script.Eval("numbers.reduce(function(a, b) { return a + b; }, 0)")
MsgBox("JavaScript array sum: " sum, , "T3")
*/

/*
* Key Concepts:
*
* 1. Creating Script Engine:
*    script := ActiveScript("JScript")
*    script := ActiveScript("VBScript")
*    Supports any COM-registered engine
*
* 2. Eval vs Exec:
*    Eval(code) - Evaluates expression, returns result
*    Exec(code) - Executes statements, no return
*
* 3. Adding AHK Objects:
*    script.AddObject(name, dispObj)
*    Makes AHK objects available in script
*    Can call AHK functions from JScript
*
* 4. Data Exchange:
*    AHK -> JS: Via AddObject or Eval params
*    JS -> AHK: Via Eval return value
*
* 5. Use Cases:
*    ✅ Use JavaScript libraries
*    ✅ Complex string/array operations
*    ✅ JSON manipulation
*    ✅ Legacy VBScript code
*    ✅ Mathematical expressions
*
* 6. JsRT Alternative:
*    #Include <JsRT>
*    script := JsRT.IE()    ; IE11 engine
*    script := JsRT.Edge()  ; Edge engine + WinRT
*
* 7. Edge JavaScript Features:
*    script := JsRT.Edge()
*    script.ProjectWinRTNamespace("Windows.Storage")
*    Access Windows Runtime from JavaScript
*
* 8. Limitations:
*    ⚠ Don't load IE + Edge simultaneously
*    ⚠ WebBrowser incompatible with Edge
*    ⚠ JScript is legacy (ES3)
*    ⚠ Debugging across languages difficult
*
* 9. Best Practices:
*    ✅ Use for specific JS features
*    ✅ Keep JS code simple
*    ✅ Handle errors with try/catch
*    ✅ Document cross-language calls
*
* 10. Real-World Applications:
*     - Using JavaScript crypto libraries
*     - Complex regex from JS
*     - JSON manipulation
*     - Mathematical calculations
*     - Legacy code integration
*/

