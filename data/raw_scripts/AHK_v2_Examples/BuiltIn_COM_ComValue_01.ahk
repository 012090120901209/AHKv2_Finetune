#Requires AutoHotkey v2.0
/**
 * BuiltIn_COM_ComValue_01.ahk
 *
 * DESCRIPTION:
 * Using ComValue for COM type conversions.
 *
 * FEATURES:
 * - Type wrapping
 * - Variant types
 * - Type conversion
 * - ByRef parameters
 * - VT constants
 */

Example1_CreateComValue() {
    MsgBox("Example 1: Create ComValue")
    Try {
        val := ComValue(3, 42)  ; VT_I4 (32-bit integer)
        MsgBox("ComValue created: " val[])
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example2_StringValue() {
    MsgBox("Example 2: String Value")
    Try {
        val := ComValue(8, "Hello")  ; VT_BSTR (string)
        MsgBox("String value: " val[])
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example3_BooleanValue() {
    MsgBox("Example 3: Boolean Value")
    Try {
        val := ComValue(11, true)  ; VT_BOOL
        MsgBox("Boolean value: " val[])
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example4_FloatValue() {
    MsgBox("Example 4: Float Value")
    Try {
        val := ComValue(5, 3.14159)  ; VT_R8 (double)
        MsgBox("Float value: " val[])
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example5_ByRefValue() {
    MsgBox("Example 5: ByRef Value")
    Try {
        val := ComValue(0x4003, 10)  ; VT_I4 | VT_BYREF
        MsgBox("ByRef value created")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example6_VariantArray() {
    MsgBox("Example 6: Variant Types")
    Try {
        val1 := ComValue(2, 100)  ; VT_I2 (16-bit integer)
        val2 := ComValue(3, 1000)  ; VT_I4 (32-bit integer)
        val3 := ComValue(4, 3.14)  ; VT_R4 (float)
        MsgBox("Multiple variant types created")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example7_TypeConversion() {
    MsgBox("Example 7: Type Conversion")
    Try {
        ; ComValue ensures proper type passing to COM methods
        val := ComValue(8, "Test String")
        MsgBox("Type: VT_BSTR`nValue: " val[])
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

ShowMenu() {
    menu := "(
    ComValue Examples
    
    1. Create ComValue
    2. String Value
    3. Boolean Value
    4. Float Value
    5. ByRef Value
    6. Variant Types
    7. Type Conversion
    
    0. Exit
    )"
    choice := InputBox(menu, "ComValue Examples", "w300 h400").Value
    switch choice {
        case "1": Example1_CreateComValue()
        case "2": Example2_StringValue()
        case "3": Example3_BooleanValue()
        case "4": Example4_FloatValue()
        case "5": Example5_ByRefValue()
        case "6": Example6_VariantArray()
        case "7": Example7_TypeConversion()
        case "0": return
        default: MsgBox("Invalid!")
    }
    if MsgBox("Run another?", "Continue?", "YesNo") = "Yes"
        ShowMenu()
}
ShowMenu()
