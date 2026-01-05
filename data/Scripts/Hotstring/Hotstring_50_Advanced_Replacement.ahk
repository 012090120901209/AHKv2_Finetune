#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Advanced Hotstring Techniques
 * Complex replacements, calculations, and interactive hotstrings
 */

; Math calculations
::calc:: {
    result := InputBox("Enter calculation (e.g., 5*8):", "Calculator").Value
    try {
        ; Evaluate the expression
        answer := Eval(result)
        Send(answer)
    } catch {
        Send("Error")
    }
}

; Eval function for basic math
Eval(expr) {
    ; Simple eval using AutoHotkey's expression evaluation
    return %expr%
}

; Interactive date picker
::pickdate:: {
    dateStr := InputBox("Enter date (YYYY-MM-DD) or leave blank for today:", "Date").Value
    if (dateStr = "")
        dateStr := FormatTime(, "yyyy-MM-dd")
    Send(dateStr)
}

; Multi-choice expansion
::greet:: {
    choice := MsgBox("Choose greeting:`n`nYes = Formal`nNo = Casual", , "YesNo")
    if (choice = "Yes")
        Send("Dear Sir/Madam,")
    else
        Send("Hey there!")
}

; Smart quotes based on context
::quote:: {
    clipSaved := A_Clipboard
    A_Clipboard := ""
    Send("^c")
    ClipWait(0.5)
    if (A_Clipboard != "") {
        Send('"' A_Clipboard '"')
    } else {
        Send('""')
    }
    A_Clipboard := clipSaved
}

; Table generator
::table3x3:: {
    table := ""
    Loop 3 {
        row := A_Index
        Loop 3 {
            col := A_Index
            table .= "R" row "C" col "`t"
        }
        table .= "`n"
    }
    Send(table)
}

; UUID generator
::uuid:: {
    uuid := CreateGUID()
    Send(uuid)
}

CreateGUID() {
    ; Simple GUID-like string
    Random1 := Format("{:08X}", Random(0, 0xFFFFFFFF))
    Random2 := Format("{:04X}", Random(0, 0xFFFF))
    Random3 := Format("{:04X}", Random(0, 0xFFFF))
    Random4 := Format("{:04X}", Random(0, 0xFFFF))
    Random5 := Format("{:012X}", Random(0, 0xFFFFFFFFFFFF))
    return Random1 "-" Random2 "-" Random3 "-" Random4 "-" Random5
}
