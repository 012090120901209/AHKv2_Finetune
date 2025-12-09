#Requires AutoHotkey v2.0

/**
* BuiltIn_COM_ComObjArray_01.ahk
*
* DESCRIPTION:
* Working with COM arrays (SafeArrays).
*
* FEATURES:
* - Creating COM arrays
* - Array indexing
* - Multi-dimensional arrays
* - Array conversion
* - VT types
*/

Example1_CreateArray() {
    MsgBox("Example 1: Create COM Array")
    Try {
        arr := ComObjArray(12, 10)  ; VT_VARIANT, 10 elements
        arr[0] := "First"
        arr[1] := "Second"
        arr[2] := "Third"
        MsgBox("Array created!`nElement 1: " arr[1])
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example2_IntegerArray() {
    MsgBox("Example 2: Integer Array")
    Try {
        arr := ComObjArray(3, 5)  ; VT_I4, 5 elements
        Loop 5
        arr[A_Index-1] := A_Index * 10
        MsgBox("Array filled!`nElement 2: " arr[2])
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example3_StringArray() {
    MsgBox("Example 3: String Array")
    Try {
        arr := ComObjArray(8, 3)  ; VT_BSTR, 3 elements
        arr[0] := "Hello"
        arr[1] := "World"
        arr[2] := "Test"

        output := "Array contents:`n"
        Loop 3
        output .= arr[A_Index-1] "`n"
        MsgBox(output)
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example4_2DArray() {
    MsgBox("Example 4: 2D Array")
    Try {
        arr := ComObjArray(12, 3, 3)  ; 3x3 array
        arr[0, 0] := "A1"
        arr[0, 1] := "A2"
        arr[1, 0] := "B1"
        arr[1, 1] := "B2"
        MsgBox("2D Array created!`n[1,1]: " arr[1,1])
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example5_ArrayToExcel() {
    MsgBox("Example 5: Array to Excel")
    Try {
        arr := ComObjArray(12, 5)
        Loop 5
        arr[A_Index-1] := "Item " A_Index

        xl := ComObject("Excel.Application")
        xl.Visible := true
        wb := xl.Workbooks.Add()
        sheet := wb.ActiveSheet

        ; Set range from array
        ; sheet.Range("A1:A5").Value := arr

        MsgBox("Array ready for Excel")
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

Example6_ArrayFromExcel() {
    MsgBox("Example 6: Array from Excel")
    Try {
        xl := ComObjActive("Excel.Application")
        if (xl.Workbooks.Count > 0) {
            sheet := xl.ActiveSheet
            ; data := sheet.Range("A1:A5").Value
            MsgBox("Ready to read array from Excel")
        } else {
            MsgBox("No active workbook")
        }
    } Catch {
        MsgBox("Excel not running")
    }
}

Example7_ArrayClone() {
    MsgBox("Example 7: Working with Arrays")
    Try {
        arr1 := ComObjArray(12, 5)
        Loop 5
        arr1[A_Index-1] := "Value " A_Index

        MsgBox("Original array created!`nElement 2: " arr1[2])
    } Catch as err {
        MsgBox("Error: " err.Message)
    }
}

ShowMenu() {
    menu := "
    (
    ComObjArray Examples

    1. Create Array
    2. Integer Array
    3. String Array
    4. 2D Array
    5. Array to Excel
    6. Array from Excel
    7. Working with Arrays

    0. Exit
    )"
    choice := InputBox(menu, "ComObjArray Examples", "w300 h400").Value
    switch choice {
        case "1": Example1_CreateArray()
        case "2": Example2_IntegerArray()
        case "3": Example3_StringArray()
        case "4": Example4_2DArray()
        case "5": Example5_ArrayToExcel()
        case "6": Example6_ArrayFromExcel()
        case "7": Example7_ArrayClone()
        case "0": return
        default: MsgBox("Invalid!")
    }
    if MsgBox("Run another?", "Continue?", "YesNo") = "Yes"
    ShowMenu()
}
ShowMenu()
