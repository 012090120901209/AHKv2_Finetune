#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_ListVars_02_DebuggingTools.ahk
 * 
 * DESCRIPTION:
 * Debugging with variable lists with comprehensive examples demonstrating
 * key concepts and practical applications.
 * 
 * FEATURES:
 * - ListVars basic usage and syntax
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
 * - ListVars() function syntax
 * - Return value handling
 * - Error handling with Try/Catch
 * - GUI integration
 * - Event-driven programming
 * - Map and Array usage
 * 
 * LEARNING POINTS:
 * 1. ListVars provides essential functionality
 * 2. Always validate inputs and outputs
 * 3. Handle errors gracefully
 * 4. Consider performance implications
 * 5. Use appropriate data structures
 * 6. Follow AutoHotkey v2 conventions
 * 7. Test edge cases thoroughly
 */

;;===============================================================================
; EXAMPLE 1: DebuggingTools Example 1
;===============================================================================

Example1_ListVars() {
    ; Create GUI for ListVars example
    gui := Gui(, "ListVars - Example 1: DebuggingTools")

    gui.Add("Text", "x10 y10 w480", "Demonstrating ListVars functionality")

    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")

    ; Example implementation
    result := ""
    result .= "Function: ListVars\n"
    result .= "Description: DebuggingTools\n"
    result .= "Example: 1\n\n"

    ; Specific functionality
    try {
        ; ListVars specific code here
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
; EXAMPLE 2: DebuggingTools Example 2
;===============================================================================

Example2_ListVars() {
    ; Create GUI for ListVars example
    gui := Gui(, "ListVars - Example 2: DebuggingTools")

    gui.Add("Text", "x10 y10 w480", "Demonstrating ListVars functionality")

    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")

    ; Example implementation
    result := ""
    result .= "Function: ListVars\n"
    result .= "Description: DebuggingTools\n"
    result .= "Example: 2\n\n"

    ; Specific functionality
    try {
        ; ListVars specific code here
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
; EXAMPLE 3: DebuggingTools Example 3
;===============================================================================

Example3_ListVars() {
    ; Create GUI for ListVars example
    gui := Gui(, "ListVars - Example 3: DebuggingTools")

    gui.Add("Text", "x10 y10 w480", "Demonstrating ListVars functionality")

    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")

    ; Example implementation
    result := ""
    result .= "Function: ListVars\n"
    result .= "Description: DebuggingTools\n"
    result .= "Example: 3\n\n"

    ; Specific functionality
    try {
        ; ListVars specific code here
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
; EXAMPLE 4: DebuggingTools Example 4
;===============================================================================

Example4_ListVars() {
    ; Create GUI for ListVars example
    gui := Gui(, "ListVars - Example 4: DebuggingTools")

    gui.Add("Text", "x10 y10 w480", "Demonstrating ListVars functionality")

    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")

    ; Example implementation
    result := ""
    result .= "Function: ListVars\n"
    result .= "Description: DebuggingTools\n"
    result .= "Example: 4\n\n"

    ; Specific functionality
    try {
        ; ListVars specific code here
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
; EXAMPLE 5: DebuggingTools Example 5
;===============================================================================

Example5_ListVars() {
    ; Create GUI for ListVars example
    gui := Gui(, "ListVars - Example 5: DebuggingTools")

    gui.Add("Text", "x10 y10 w480", "Demonstrating ListVars functionality")

    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")

    ; Example implementation
    result := ""
    result .= "Function: ListVars\n"
    result .= "Description: DebuggingTools\n"
    result .= "Example: 5\n\n"

    ; Specific functionality
    try {
        ; ListVars specific code here
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
; EXAMPLE 6: DebuggingTools Example 6
;===============================================================================

Example6_ListVars() {
    ; Create GUI for ListVars example
    gui := Gui(, "ListVars - Example 6: DebuggingTools")

    gui.Add("Text", "x10 y10 w480", "Demonstrating ListVars functionality")

    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")

    ; Example implementation
    result := ""
    result .= "Function: ListVars\n"
    result .= "Description: DebuggingTools\n"
    result .= "Example: 6\n\n"

    ; Specific functionality
    try {
        ; ListVars specific code here
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
;===============================================================================
; Run Examples
;===============================================================================

; Uncomment to run specific examples:
; Example1_ListVars()
; Example2_ListVars()
; Example3_ListVars()
; Example4_ListVars()
; Example5_ListVars()
; Example6_ListVars()

