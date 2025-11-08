#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Multiple Hotstring Options Combined
 * Combine various options for advanced behavior
 */

; *C = Immediate trigger + Case-sensitive
:*C:AHK::AutoHotkey

; ?*C = Inside word + Immediate + Case-sensitive
:?*C:JS::JavaScript

; *T = Immediate + Text/Raw mode
:*T:code::const myVar = {};

; C1 = Case-sensitive + Auto-capitalize
; (Automatically matches the case of what you type)
:C1:ahk::AutoHotkey
; Type "Ahk" → "AutoHotkey", "AHK" → "AUTOHOTKEY"

; ?*T = Inside word + Immediate + Raw text
:?*T:()::(){

}

; *C0 = Immediate + Non-case-conforming
; (Always outputs exact case regardless of input)
:*C0:js::JavaScript

; Multiple options for code snippets
:*T:func::
(
function myFunction() {
    // code here
    return;
}
)

; Email template with multiple options
:*T:email::
(
Dear [Name],

Thank you for your message.

Best regards,
[Your Name]
)
