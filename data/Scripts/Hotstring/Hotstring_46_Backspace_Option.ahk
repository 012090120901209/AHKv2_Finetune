#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Hotstring Option: B0 (No Backspacing)
* Don't erase the trigger text before replacement
*/

; Default behavior: erases "btw" and types "by the way"
::btw::by the way

; B0: Keeps "btw" and adds " (by the way)"
:B0:info:: (additional information)

; Useful for annotations
:B0:fn:: [footnote]
:B0:ref:: [reference needed]

; Expand without removing original
:B0:expand::
(
- Full expansion:
Detailed explanation here
)

; Add clarification
:B0:aka:: (also known as)
:B0:ie:: (that is)
:B0:eg:: (for example)
