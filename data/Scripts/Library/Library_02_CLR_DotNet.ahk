#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
* CLR Library - .NET Framework Integration
*
* Demonstrates using Lexikos' CLR.ahk library to access .NET Framework
* classes, compile C# dynamically, and create Windows Forms applications.
*
* Library: https://github.com/Lexikos/CLR.ahk
* Note: This example assumes CLR.ahk is installed in Lib folder
*/

; NOTE: This is a demonstration. To run, you need to:
; 1. Download CLR.ahk from https://github.com/Lexikos/CLR.ahk
; 2. Place it in your Lib folder
; 3. Have .NET Framework 4.0+ installed
; 4. Uncomment the code below

MsgBox("CLR Library Example`n`n"
. "This demonstrates .NET Framework integration.`n`n"
. "To use this library:`n"
. "1. Download from github.com/Lexikos/CLR.ahk`n"
. "2. Place in Lib folder`n"
. "3. Ensure .NET Framework 4.0+ installed`n"
. "4. Uncomment the example code", , "T5")

/*
; Uncomment to test (requires library installation):

#Include <CLR>

; Example 1: Start CLR and use System.Math
CLR_Start("v4.0.30319")
asm := CLR_LoadLibrary("mscorlib")
Math := asm.GetType("System.Math")

sqrt := Math.Sqrt(16)
pow := Math.Pow(2, 10)
MsgBox(".NET Math Functions:`n`nSqrt(16) = " sqrt "`nPow(2, 10) = " pow, , "T3")

; Example 2: System.IO for file operations
IO := CLR_LoadLibrary("mscorlib")
Path := IO.GetType("System.IO.Path")

tempPath := Path.GetTempPath()
randomName := Path.GetRandomFileName()
MsgBox("System.IO.Path:`n`nTemp: " tempPath "`nRandom: " randomName, , "T3")

; Example 3: Compile C# dynamically
csharpCode := "
(
using System;

public class Calculator {
    public static double Add(double a, double b) {
        return a + b;
    }

    public static double Multiply(double a, double b) {
        return a * b;
    }

    public static string FormatCurrency(double amount) {
        return String.Format("${0:N2}", amount);
    }
}
)"

; Compile C# in memory
compiled := CLR_CompileCS(csharpCode, "System.dll")
Calculator := compiled.GetType("Calculator")

sum := Calculator.Add(10.5, 20.3)
product := Calculator.Multiply(5, 7)
formatted := Calculator.FormatCurrency(1234.56)

MsgBox("Dynamic C# Compilation:`n`n"
. "Add(10.5, 20.3) = " sum "`n"
. "Multiply(5, 7) = " product "`n"
. "FormatCurrency(1234.56) = " formatted, , "T5")

; Example 4: System.Collections.Generic.List
List := CLR_CreateObject(asm, "System.Collections.Generic.List``1[System.String]")
List.Add("Apple")
List.Add("Banana")
List.Add("Cherry")

result := "Generic List:`n`n"
result .= "Count: " List.Count "`n"
result .= "Items:`n"

Loop List.Count
result .= "  " (A_Index) ". " List.Item(A_Index-1) "`n"

MsgBox(result, , "T5")

; Example 5: DateTime and formatting
DateTime := asm.GetType("System.DateTime")
now := DateTime.Now

formatted := now.ToString("yyyy-MM-dd HH:mm:ss")
dayOfWeek := now.DayOfWeek.ToString()
daysInMonth := DateTime.DaysInMonth(now.Year, now.Month)

MsgBox("System.DateTime:`n`n"
. "Now: " formatted "`n"
. "Day: " dayOfWeek "`n"
. "Days in month: " daysInMonth, , "T5")

; Example 6: Regular Expressions
Regex := CLR_LoadLibrary("System")
.GetType("System.Text.RegularExpressions.Regex")

text := "Contact: alice@example.com or bob@test.org"
pattern := "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b"

matches := Regex.Matches(text, pattern)
result := ".NET Regex:`n`nFound " matches.Count " emails:`n"

Loop matches.Count
result .= "  " matches.Item(A_Index-1).Value "`n"

MsgBox(result, , "T5")
*/

/*
* Key Concepts:
*
* 1. Starting CLR:
*    CLR_Start([version])
*    CLR_Start("v4.0.30319")  ; .NET 4.0+
*    Initialize once per script
*
* 2. Loading Assemblies:
*    asm := CLR_LoadLibrary("mscorlib")
*    asm := CLR_LoadLibrary("System.dll")
*    asm := CLR_LoadLibrary("Full.Assembly.Name")
*
* 3. Getting Types:
*    Type := asm.GetType("Namespace.ClassName")
*    Math := asm.GetType("System.Math")
*
* 4. Creating Objects:
*    obj := CLR_CreateObject(asm, typeName, args*)
*    list := CLR_CreateObject(asm, "System.Collections.Generic.List``1[System.String]")
*
* 5. Calling Methods:
*    result := Type.StaticMethod(args*)
*    result := obj.InstanceMethod(args*)
*
* 6. Compiling C#:
*    asm := CLR_CompileCS(code, references)
*    references: "System.dll System.Xml.dll"
*    Returns assembly with compiled types
*
* 7. AppDomains:
*    CLR_StartDomain(&domain)
*    asm := CLR_LoadLibrary(name, domain)
*    CLR_StopDomain(&domain)
*    Isolate and unload assemblies
*
* 8. Use Cases:
*    ✅ Windows Forms GUIs
*    ✅ WPF applications
*    ✅ System.Drawing graphics
*    ✅ Cryptography (AES, RSA, etc)
*    ✅ Database access (ADO.NET)
*    ✅ XML/JSON parsing
*    ✅ Advanced regex
*    ✅ Network operations
*
* 9. Limitations:
*    ⚠ .NET Framework only (not Core/5+)
*    ⚠ Type marshalling overhead
*    ⚠ Complex error handling
*    ⚠ No LINQ query syntax
*    ⚠ Some types difficult to use
*
* 10. Best Practices:
*     ✅ Cache type references
*     ✅ Use try/catch
*     ✅ Compile C# for complex logic
*     ✅ Understand .NET type system
*     ✅ Check .NET Framework version
*
* 11. Common Assemblies:
*     mscorlib - Core types
*     System - Additional core
*     System.Windows.Forms - GUI
*     System.Drawing - Graphics
*     System.Xml - XML processing
*     System.Data - Databases
*
* 12. Real-World Applications:
*     - Database-driven apps
*     - Complex GUI applications
*     - Image processing
*     - Encryption/decryption
*     - Web service clients
*     - XML/JSON processing
*/
