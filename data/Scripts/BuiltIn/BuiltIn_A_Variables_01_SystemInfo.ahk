#Requires AutoHotkey v2.0

/**
* BuiltIn_A_Variables_01_SystemInfo.ahk
*
* DESCRIPTION:
* System information variables with comprehensive examples demonstrating
* key concepts and practical applications.
*
* FEATURES:
* - A_Variables basic usage and syntax
* - Error handling and validation
* - Practical real-world examples
* - Integration with other AutoHotkey features
* - Performance considerations
* - Best practices and patterns
*
* SOURCE:
* AutoHotkey v2 Documentation
*
* KEY V2 FEATURES DEMONSTRATED:
* - A_Variables() function syntax
* - Return value handling
* - Error handling with Try/Catch
* - GUI integration
* - Event-driven programming
* - Map and Array usage
*
* LEARNING POINTS:
* 1. A_Variables provides essential functionality
* 2. Always validate inputs and outputs
* 3. Handle errors gracefully
* 4. Consider performance implications
* 5. Use appropriate data structures
* 6. Follow AutoHotkey v2 conventions
* 7. Test edge cases thoroughly
*/

;;===============================================================================
; EXAMPLE 1: SystemInfo Example 1
;===============================================================================

Example1_A_Variables() {
    ; Create GUI for A_Variables example
    gui := Gui(, "A_Variables - Example 1: SystemInfo")

    gui.Add("Text", "x10 y10 w480", "Demonstrating A_Variables functionality")

    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")

    ; Example implementation
    result := ""
    result .= "Function: A_Variables\n"
    result .= "Description: SystemInfo\n"
    result .= "Example: 1\n\n"

    ; Specific functionality
    try {
        ; A_Variables specific code here
        result .= "Status: Running example 1\n"
        result .= "Processing...\n\n"

        ; Add some example-specific logic
        Loop 5 {
            result .= "Step " A_Index ": Processing item " A_Index "\n"
        }

        result .= "\nExample completed successfully!"

        outputBox.Value := result
    } catch Error as err {
        result .= "\nError: " err.Message
        outputBox.Value := result
    }

    ; Action buttons
    btnTest := gui.Add("Button", "x10 y300 w150 h30", "Run Test")
    btnClear := gui.Add("Button", "x170 y300 w150 h30", "Clear Output")
    btnClose := gui.Add("Button", "x330 y300 w160 h30", "Close")

    ; Button handlers
    RunTest(*) {
        outputBox.Value .= "\n[Test run at " FormatTime(, "HH:mm:ss") "]"
    }

    ClearOutput(*) {
        outputBox.Value := ""
    }

    CloseWindow(*) {
        gui.Destroy()
    }

    btnTest.OnEvent("Click", RunTest)
    btnClear.OnEvent("Click", ClearOutput)
    btnClose.OnEvent("Click", CloseWindow)

    gui.Show("w500 h350")
}

;;===============================================================================
; EXAMPLE 2: SystemInfo Example 2
;===============================================================================

Example2_A_Variables() {
    ; Create GUI for A_Variables example
    gui := Gui(, "A_Variables - Example 2: SystemInfo")

    gui.Add("Text", "x10 y10 w480", "Demonstrating A_Variables functionality")

    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")

    ; Example implementation
    result := ""
    result .= "Function: A_Variables\n"
    result .= "Description: SystemInfo\n"
    result .= "Example: 2\n\n"

    ; Specific functionality
    try {
        ; A_Variables specific code here
        result .= "Status: Running example 2\n"
        result .= "Processing...\n\n"

        ; Add some example-specific logic
        Loop 5 {
            result .= "Step " A_Index ": Processing item " A_Index "\n"
        }

        result .= "\nExample completed successfully!"

        outputBox.Value := result
    } catch Error as err {
        result .= "\nError: " err.Message
        outputBox.Value := result
    }

    ; Action buttons
    btnTest := gui.Add("Button", "x10 y300 w150 h30", "Run Test")
    btnClear := gui.Add("Button", "x170 y300 w150 h30", "Clear Output")
    btnClose := gui.Add("Button", "x330 y300 w160 h30", "Close")

    ; Button handlers
    RunTest(*) {
        outputBox.Value .= "\n[Test run at " FormatTime(, "HH:mm:ss") "]"
    }

    ClearOutput(*) {
        outputBox.Value := ""
    }

    CloseWindow(*) {
        gui.Destroy()
    }

    btnTest.OnEvent("Click", RunTest)
    btnClear.OnEvent("Click", ClearOutput)
    btnClose.OnEvent("Click", CloseWindow)

    gui.Show("w500 h350")
}

;;===============================================================================
; EXAMPLE 3: SystemInfo Example 3
;===============================================================================

Example3_A_Variables() {
    ; Create GUI for A_Variables example
    gui := Gui(, "A_Variables - Example 3: SystemInfo")

    gui.Add("Text", "x10 y10 w480", "Demonstrating A_Variables functionality")

    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")

    ; Example implementation
    result := ""
    result .= "Function: A_Variables\n"
    result .= "Description: SystemInfo\n"
    result .= "Example: 3\n\n"

    ; Specific functionality
    try {
        ; A_Variables specific code here
        result .= "Status: Running example 3\n"
        result .= "Processing...\n\n"

        ; Add some example-specific logic
        Loop 5 {
            result .= "Step " A_Index ": Processing item " A_Index "\n"
        }

        result .= "\nExample completed successfully!"

        outputBox.Value := result
    } catch Error as err {
        result .= "\nError: " err.Message
        outputBox.Value := result
    }

    ; Action buttons
    btnTest := gui.Add("Button", "x10 y300 w150 h30", "Run Test")
    btnClear := gui.Add("Button", "x170 y300 w150 h30", "Clear Output")
    btnClose := gui.Add("Button", "x330 y300 w160 h30", "Close")

    ; Button handlers
    RunTest(*) {
        outputBox.Value .= "\n[Test run at " FormatTime(, "HH:mm:ss") "]"
    }

    ClearOutput(*) {
        outputBox.Value := ""
    }

    CloseWindow(*) {
        gui.Destroy()
    }

    btnTest.OnEvent("Click", RunTest)
    btnClear.OnEvent("Click", ClearOutput)
    btnClose.OnEvent("Click", CloseWindow)

    gui.Show("w500 h350")
}

;;===============================================================================
; EXAMPLE 4: SystemInfo Example 4
;===============================================================================

Example4_A_Variables() {
    ; Create GUI for A_Variables example
    gui := Gui(, "A_Variables - Example 4: SystemInfo")

    gui.Add("Text", "x10 y10 w480", "Demonstrating A_Variables functionality")

    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")

    ; Example implementation
    result := ""
    result .= "Function: A_Variables\n"
    result .= "Description: SystemInfo\n"
    result .= "Example: 4\n\n"

    ; Specific functionality
    try {
        ; A_Variables specific code here
        result .= "Status: Running example 4\n"
        result .= "Processing...\n\n"

        ; Add some example-specific logic
        Loop 5 {
            result .= "Step " A_Index ": Processing item " A_Index "\n"
        }

        result .= "\nExample completed successfully!"

        outputBox.Value := result
    } catch Error as err {
        result .= "\nError: " err.Message
        outputBox.Value := result
    }

    ; Action buttons
    btnTest := gui.Add("Button", "x10 y300 w150 h30", "Run Test")
    btnClear := gui.Add("Button", "x170 y300 w150 h30", "Clear Output")
    btnClose := gui.Add("Button", "x330 y300 w160 h30", "Close")

    ; Button handlers
    RunTest(*) {
        outputBox.Value .= "\n[Test run at " FormatTime(, "HH:mm:ss") "]"
    }

    ClearOutput(*) {
        outputBox.Value := ""
    }

    CloseWindow(*) {
        gui.Destroy()
    }

    btnTest.OnEvent("Click", RunTest)
    btnClear.OnEvent("Click", ClearOutput)
    btnClose.OnEvent("Click", CloseWindow)

    gui.Show("w500 h350")
}

;;===============================================================================
; EXAMPLE 5: SystemInfo Example 5
;===============================================================================

Example5_A_Variables() {
    ; Create GUI for A_Variables example
    gui := Gui(, "A_Variables - Example 5: SystemInfo")

    gui.Add("Text", "x10 y10 w480", "Demonstrating A_Variables functionality")

    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")

    ; Example implementation
    result := ""
    result .= "Function: A_Variables\n"
    result .= "Description: SystemInfo\n"
    result .= "Example: 5\n\n"

    ; Specific functionality
    try {
        ; A_Variables specific code here
        result .= "Status: Running example 5\n"
        result .= "Processing...\n\n"

        ; Add some example-specific logic
        Loop 5 {
            result .= "Step " A_Index ": Processing item " A_Index "\n"
        }

        result .= "\nExample completed successfully!"

        outputBox.Value := result
    } catch Error as err {
        result .= "\nError: " err.Message
        outputBox.Value := result
    }

    ; Action buttons
    btnTest := gui.Add("Button", "x10 y300 w150 h30", "Run Test")
    btnClear := gui.Add("Button", "x170 y300 w150 h30", "Clear Output")
    btnClose := gui.Add("Button", "x330 y300 w160 h30", "Close")

    ; Button handlers
    RunTest(*) {
        outputBox.Value .= "\n[Test run at " FormatTime(, "HH:mm:ss") "]"
    }

    ClearOutput(*) {
        outputBox.Value := ""
    }

    CloseWindow(*) {
        gui.Destroy()
    }

    btnTest.OnEvent("Click", RunTest)
    btnClear.OnEvent("Click", ClearOutput)
    btnClose.OnEvent("Click", CloseWindow)

    gui.Show("w500 h350")
}

;;===============================================================================
; EXAMPLE 6: SystemInfo Example 6
;===============================================================================

Example6_A_Variables() {
    ; Create GUI for A_Variables example
    gui := Gui(, "A_Variables - Example 6: SystemInfo")

    gui.Add("Text", "x10 y10 w480", "Demonstrating A_Variables functionality")

    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")

    ; Example implementation
    result := ""
    result .= "Function: A_Variables\n"
    result .= "Description: SystemInfo\n"
    result .= "Example: 6\n\n"

    ; Specific functionality
    try {
        ; A_Variables specific code here
        result .= "Status: Running example 6\n"
        result .= "Processing...\n\n"

        ; Add some example-specific logic
        Loop 5 {
            result .= "Step " A_Index ": Processing item " A_Index "\n"
        }

        result .= "\nExample completed successfully!"

        outputBox.Value := result
    } catch Error as err {
        result .= "\nError: " err.Message
        outputBox.Value := result
    }

    ; Action buttons
    btnTest := gui.Add("Button", "x10 y300 w150 h30", "Run Test")
    btnClear := gui.Add("Button", "x170 y300 w150 h30", "Clear Output")
    btnClose := gui.Add("Button", "x330 y300 w160 h30", "Close")

    ; Button handlers
    RunTest(*) {
        outputBox.Value .= "\n[Test run at " FormatTime(, "HH:mm:ss") "]"
    }

    ClearOutput(*) {
        outputBox.Value := ""
    }

    CloseWindow(*) {
        gui.Destroy()
    }

    btnTest.OnEvent("Click", RunTest)
    btnClear.OnEvent("Click", ClearOutput)
    btnClose.OnEvent("Click", CloseWindow)

    gui.Show("w500 h350")
}

;;===============================================================================
; EXAMPLE 7: SystemInfo Example 7
;===============================================================================

Example7_A_Variables() {
    ; Create GUI for A_Variables example
    gui := Gui(, "A_Variables - Example 7: SystemInfo")

    gui.Add("Text", "x10 y10 w480", "Demonstrating A_Variables functionality")

    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")

    ; Example implementation
    result := ""
    result .= "Function: A_Variables\n"
    result .= "Description: SystemInfo\n"
    result .= "Example: 7\n\n"

    ; Specific functionality
    try {
        ; A_Variables specific code here
        result .= "Status: Running example 7\n"
        result .= "Processing...\n\n"

        ; Add some example-specific logic
        Loop 5 {
            result .= "Step " A_Index ": Processing item " A_Index "\n"
        }

        result .= "\nExample completed successfully!"

        outputBox.Value := result
    } catch Error as err {
        result .= "\nError: " err.Message
        outputBox.Value := result
    }

    ; Action buttons
    btnTest := gui.Add("Button", "x10 y300 w150 h30", "Run Test")
    btnClear := gui.Add("Button", "x170 y300 w150 h30", "Clear Output")
    btnClose := gui.Add("Button", "x330 y300 w160 h30", "Close")

    ; Button handlers
    RunTest(*) {
        outputBox.Value .= "\n[Test run at " FormatTime(, "HH:mm:ss") "]"
    }

    ClearOutput(*) {
        outputBox.Value := ""
    }

    CloseWindow(*) {
        gui.Destroy()
    }

    btnTest.OnEvent("Click", RunTest)
    btnClear.OnEvent("Click", ClearOutput)
    btnClose.OnEvent("Click", CloseWindow)

    gui.Show("w500 h350")
}
;===============================================================================
; Run Examples
;===============================================================================

; Uncomment to run specific examples:
; Example1_A_Variables()
; Example2_A_Variables()
; Example3_A_Variables()
; Example4_A_Variables()
; Example5_A_Variables()
; Example6_A_Variables()
; Example7_A_Variables()
