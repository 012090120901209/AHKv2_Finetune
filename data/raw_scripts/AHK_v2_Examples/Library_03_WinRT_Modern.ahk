#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * WinRT Library - Windows Runtime Integration
 *
 * Demonstrates using Lexikos' winrt.ahk library to access modern Windows
 * APIs including toast notifications, file pickers, and sensors.
 *
 * Library: https://github.com/Lexikos/winrt.ahk
 * Note: This example assumes winrt.ahk is installed in Lib folder
 */

; NOTE: This is a demonstration. To run, you need to:
; 1. Download winrt.ahk from https://github.com/Lexikos/winrt.ahk
; 2. Place it in your Lib folder
; 3. Run on Windows 10 or later
; 4. Uncomment the code below

MsgBox("WinRT Library Example`n`n"
     . "This demonstrates Windows Runtime integration.`n`n"
     . "To use this library:`n"
     . "1. Download from github.com/Lexikos/winrt.ahk`n"
     . "2. Place in Lib folder`n"
     . "3. Requires Windows 10+`n"
     . "4. Uncomment the example code", , "T5")

/*
; Uncomment to test (requires library installation):

#Include <winrt.ahk>

; Example 1: JSON parsing with Windows.Data.Json
JsonObject := WinRT('Windows.Data.Json.JsonObject')
jsonText := '{"name":"Alice","age":30,"active":true}'

if (JsonObject.TryParse(jsonText, &jo)) {
    name := jo.GetNamedString("name")
    age := jo.GetNamedNumber("age")
    active := jo.GetNamedBoolean("active")

    MsgBox("JSON Parsing:`n`n"
         . "Name: " name "`n"
         . "Age: " age "`n"
         . "Active: " active, , "T3")
}

; Example 2: Creating JSON
JsonValue := WinRT('Windows.Data.Json.JsonValue')
newObj := WinRT('Windows.Data.Json.JsonObject').Construct()

newObj.SetNamedValue("id", JsonValue.CreateNumberValue(123))
newObj.SetNamedValue("title", JsonValue.CreateStringValue("Test Item"))
newObj.SetNamedValue("enabled", JsonValue.CreateBooleanValue(true))

jsonStr := newObj.Stringify()
MsgBox("Created JSON:`n`n" jsonStr, , "T3")

; Example 3: File picker (requires UI thread)
; Note: File pickers require proper app context, may not work in all scenarios

try {
    FileOpenPicker := WinRT('Windows.Storage.Pickers.FileOpenPicker')
    picker := FileOpenPicker.Construct()

    picker.FileTypeFilter.Append("*")
    picker.SuggestedStartLocation := WinRT('Windows.Storage.Pickers.PickerLocationId').E.DocumentsLibrary

    ; Note: PickSingleFileAsync requires proper async handling
    ; This is simplified - full implementation more complex
    MsgBox("File picker initialized`n(Actual file picking requires async handling)", , "T3")
} catch as e {
    MsgBox("File picker example (requires app context)", , "T3")
}

; Example 4: Toast Notifications (basic)
; Note: Toast notifications require proper app registration

try {
    ; Get toast template
    ToastNotificationManager := WinRT('Windows.UI.Notifications.ToastNotificationManager')
    ToastTemplateType := WinRT('Windows.UI.Notifications.ToastTemplateType')

    ; This is demonstration - actual toast requires more setup
    MsgBox("Toast notification classes loaded`n"
         . "(Actual notifications require app registration)", , "T3")
} catch as e {
    MsgBox("Toast notification example (requires registration)", , "T3")
}

; Example 5: Cryptography
CryptographicBuffer := WinRT('Windows.Security.Cryptography.CryptographicBuffer')
HashAlgorithmProvider := WinRT('Windows.Security.Cryptography.Core.HashAlgorithmProvider')

; Create hash provider
hashProvider := HashAlgorithmProvider.OpenAlgorithm("SHA256")

; Create buffer from string
text := "Hello, WinRT!"
buffer := CryptographicBuffer.ConvertStringToBinary(text, 0)  ; 0 = Utf8

; Compute hash
hashBuffer := hashProvider.HashData(buffer)
hashHex := CryptographicBuffer.EncodeToHexString(hashBuffer)

MsgBox("SHA256 Hash:`n`nText: " text "`nHash: " hashHex, , "T5")

; Example 6: Random number generation
buffer := CryptographicBuffer.GenerateRandom(4)  ; 4 bytes
randomNum := CryptographicBuffer.ConvertBinaryToString(1, buffer)  ; 1 = Hex

MsgBox("Cryptographically secure random:`n" randomNum, , "T3")

; Example 7: Base64 encoding
text := "AutoHotkey + WinRT"
inputBuffer := CryptographicBuffer.ConvertStringToBinary(text, 0)
base64 := CryptographicBuffer.EncodeToBase64String(inputBuffer)

decoded := CryptographicBuffer.ConvertBinaryToString(
    0,  ; Utf8
    CryptographicBuffer.DecodeFromBase64String(base64)
)

MsgBox("Base64 Encoding:`n`n"
     . "Original: " text "`n"
     . "Encoded: " base64 "`n"
     . "Decoded: " decoded, , "T5")
*/

/*
 * Key Concepts:
 *
 * 1. WinRT Function:
 *    Class := WinRT('Namespace.ClassName')
 *    obj := Class.Construct()
 *    Alternative to namespace includes
 *
 * 2. Namespace Include:
 *    #Include <windows.ahk>
 *    obj := Windows.Data.Json.JsonObject()
 *    More natural syntax
 *
 * 3. Constructors:
 *    obj := WinRT('ClassName').Construct()
 *    obj := WinRT('ClassName').Construct(args*)
 *
 * 4. Enums:
 *    E := WinRT('EnumType')
 *    value := E.E.MemberName  ; Numeric value
 *    name := E.E.MemberName.ToString()  ; String name
 *
 * 5. Properties:
 *    value := obj.PropertyName
 *    obj.PropertyName := value
 *
 * 6. Methods:
 *    result := obj.MethodName(args*)
 *    Static := Class.StaticMethod(args*)
 *
 * 7. Async Operations:
 *    ; WinRT async requires special handling
 *    ; Some operations may not work directly
 *    ; Consider alternatives or advanced patterns
 *
 * 8. Use Cases:
 *    ✅ JSON manipulation (fast, native)
 *    ✅ Cryptography (secure, modern)
 *    ✅ Toast notifications*
 *    ✅ File pickers*
 *    ✅ Sensors (GPS, accelerometer)*
 *    ✅ Bluetooth Low Energy*
 *    ✅ Speech synthesis/recognition*
 *    (* = Requires proper app context)
 *
 * 9. Limitations:
 *    ⚠ Windows 10+ only
 *    ⚠ Some APIs need app registration
 *    ⚠ Async operations complex
 *    ⚠ No array parameters
 *    ⚠ UI components need proper context
 *
 * 10. Best Practices:
 *     ✅ Use for modern Windows features
 *     ✅ Test async operations carefully
 *     ✅ Handle exceptions
 *     ✅ Check Windows version
 *     ✅ Understand UWP app model
 *
 * 11. Common Namespaces:
 *     Windows.Data.Json - JSON parsing
 *     Windows.Security.Cryptography - Crypto
 *     Windows.Storage - File system
 *     Windows.UI.Notifications - Toasts
 *     Windows.Devices - Sensors, Bluetooth
 *     Windows.Media.SpeechSynthesis - TTS
 *
 * 12. Real-World Applications:
 *     - Secure password generation
 *     - JSON API clients
 *     - Modern file operations
 *     - System notifications
 *     - Hardware sensor access
 *     - Bluetooth device control
 */
