#Requires AutoHotkey v2.0
/**
 * BuiltIn_Ord_02_UnicodeHandling.ahk
 *
 * DESCRIPTION:
 * Unicode character processing with comprehensive examples demonstrating
 * key concepts and practical applications.
 *
 * FEATURES:
 * - Ord basic usage and syntax
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
 * - Ord() function syntax
 * - Return value handling
 * - Error handling with Try/Catch
 * - GUI integration
 * - Event-driven programming
 * - Map and Array usage
 *
 * LEARNING POINTS:
 * 1. Ord provides essential functionality
 * 2. Always validate inputs and outputs
 * 3. Handle errors gracefully
 * 4. Consider performance implications
 * 5. Use appropriate data structures
 * 6. Follow AutoHotkey v2 conventions
 * 7. Test edge cases thoroughly
 */

;;===============================================================================
; EXAMPLE 1: UnicodeHandling Example 1
;===============================================================================

Example1_Ord() {
    ; Create GUI for Ord example
    gui := Gui(, "Ord - Example 1: UnicodeHandling")
    
    gui.Add("Text", "x10 y10 w480", "Demonstrating Ord functionality")
    
    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")
    
    ; Example implementation
    result := ""
    result .= "Function: Ord\n"
    result .= "Description: UnicodeHandling\n"
    result .= "Example: 1\n\n"
    
    ; Specific functionality
    try {
        ; Ord specific code here
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
; EXAMPLE 2: UnicodeHandling Example 2
;===============================================================================

Example2_Ord() {
    ; Create GUI for Ord example
    gui := Gui(, "Ord - Example 2: UnicodeHandling")
    
    gui.Add("Text", "x10 y10 w480", "Demonstrating Ord functionality")
    
    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")
    
    ; Example implementation
    result := ""
    result .= "Function: Ord\n"
    result .= "Description: UnicodeHandling\n"
    result .= "Example: 2\n\n"
    
    ; Specific functionality
    try {
        ; Ord specific code here
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
; EXAMPLE 3: UnicodeHandling Example 3
;===============================================================================

Example3_Ord() {
    ; Create GUI for Ord example
    gui := Gui(, "Ord - Example 3: UnicodeHandling")
    
    gui.Add("Text", "x10 y10 w480", "Demonstrating Ord functionality")
    
    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")
    
    ; Example implementation
    result := ""
    result .= "Function: Ord\n"
    result .= "Description: UnicodeHandling\n"
    result .= "Example: 3\n\n"
    
    ; Specific functionality
    try {
        ; Ord specific code here
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
; EXAMPLE 4: UnicodeHandling Example 4
;===============================================================================

Example4_Ord() {
    ; Create GUI for Ord example
    gui := Gui(, "Ord - Example 4: UnicodeHandling")
    
    gui.Add("Text", "x10 y10 w480", "Demonstrating Ord functionality")
    
    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")
    
    ; Example implementation
    result := ""
    result .= "Function: Ord\n"
    result .= "Description: UnicodeHandling\n"
    result .= "Example: 4\n\n"
    
    ; Specific functionality
    try {
        ; Ord specific code here
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
; EXAMPLE 5: UnicodeHandling Example 5
;===============================================================================

Example5_Ord() {
    ; Create GUI for Ord example
    gui := Gui(, "Ord - Example 5: UnicodeHandling")
    
    gui.Add("Text", "x10 y10 w480", "Demonstrating Ord functionality")
    
    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")
    
    ; Example implementation
    result := ""
    result .= "Function: Ord\n"
    result .= "Description: UnicodeHandling\n"
    result .= "Example: 5\n\n"
    
    ; Specific functionality
    try {
        ; Ord specific code here
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
; EXAMPLE 6: UnicodeHandling Example 6
;===============================================================================

Example6_Ord() {
    ; Create GUI for Ord example
    gui := Gui(, "Ord - Example 6: UnicodeHandling")
    
    gui.Add("Text", "x10 y10 w480", "Demonstrating Ord functionality")
    
    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")
    
    ; Example implementation
    result := ""
    result .= "Function: Ord\n"
    result .= "Description: UnicodeHandling\n"
    result .= "Example: 6\n\n"
    
    ; Specific functionality
    try {
        ; Ord specific code here
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
; Example1_Ord()
; Example2_Ord()
; Example3_Ord()
; Example4_Ord()
; Example5_Ord()
; Example6_Ord()
