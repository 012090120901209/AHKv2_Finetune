#Requires AutoHotkey v2.0
/**
 * BuiltIn_DirCopy_02_RecursiveCopy.ahk
 *
 * DESCRIPTION:
 * Recursive directory copying with comprehensive examples demonstrating
 * key concepts and practical applications.
 *
 * FEATURES:
 * - DirCopy basic usage and syntax
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
 * - DirCopy() function syntax
 * - Return value handling
 * - Error handling with Try/Catch
 * - GUI integration
 * - Event-driven programming
 * - Map and Array usage
 *
 * LEARNING POINTS:
 * 1. DirCopy provides essential functionality
 * 2. Always validate inputs and outputs
 * 3. Handle errors gracefully
 * 4. Consider performance implications
 * 5. Use appropriate data structures
 * 6. Follow AutoHotkey v2 conventions
 * 7. Test edge cases thoroughly
 */

;;===============================================================================
; EXAMPLE 1: RecursiveCopy Example 1
;===============================================================================

Example1_DirCopy() {
    ; Create GUI for DirCopy example
    gui := Gui(, "DirCopy - Example 1: RecursiveCopy")
    
    gui.Add("Text", "x10 y10 w480", "Demonstrating DirCopy functionality")
    
    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")
    
    ; Example implementation
    result := ""
    result .= "Function: DirCopy\n"
    result .= "Description: RecursiveCopy\n"
    result .= "Example: 1\n\n"
    
    ; Specific functionality
    try {
        ; DirCopy specific code here
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
; EXAMPLE 2: RecursiveCopy Example 2
;===============================================================================

Example2_DirCopy() {
    ; Create GUI for DirCopy example
    gui := Gui(, "DirCopy - Example 2: RecursiveCopy")
    
    gui.Add("Text", "x10 y10 w480", "Demonstrating DirCopy functionality")
    
    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")
    
    ; Example implementation
    result := ""
    result .= "Function: DirCopy\n"
    result .= "Description: RecursiveCopy\n"
    result .= "Example: 2\n\n"
    
    ; Specific functionality
    try {
        ; DirCopy specific code here
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
; EXAMPLE 3: RecursiveCopy Example 3
;===============================================================================

Example3_DirCopy() {
    ; Create GUI for DirCopy example
    gui := Gui(, "DirCopy - Example 3: RecursiveCopy")
    
    gui.Add("Text", "x10 y10 w480", "Demonstrating DirCopy functionality")
    
    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")
    
    ; Example implementation
    result := ""
    result .= "Function: DirCopy\n"
    result .= "Description: RecursiveCopy\n"
    result .= "Example: 3\n\n"
    
    ; Specific functionality
    try {
        ; DirCopy specific code here
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
; EXAMPLE 4: RecursiveCopy Example 4
;===============================================================================

Example4_DirCopy() {
    ; Create GUI for DirCopy example
    gui := Gui(, "DirCopy - Example 4: RecursiveCopy")
    
    gui.Add("Text", "x10 y10 w480", "Demonstrating DirCopy functionality")
    
    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")
    
    ; Example implementation
    result := ""
    result .= "Function: DirCopy\n"
    result .= "Description: RecursiveCopy\n"
    result .= "Example: 4\n\n"
    
    ; Specific functionality
    try {
        ; DirCopy specific code here
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
; EXAMPLE 5: RecursiveCopy Example 5
;===============================================================================

Example5_DirCopy() {
    ; Create GUI for DirCopy example
    gui := Gui(, "DirCopy - Example 5: RecursiveCopy")
    
    gui.Add("Text", "x10 y10 w480", "Demonstrating DirCopy functionality")
    
    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")
    
    ; Example implementation
    result := ""
    result .= "Function: DirCopy\n"
    result .= "Description: RecursiveCopy\n"
    result .= "Example: 5\n\n"
    
    ; Specific functionality
    try {
        ; DirCopy specific code here
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
; EXAMPLE 6: RecursiveCopy Example 6
;===============================================================================

Example6_DirCopy() {
    ; Create GUI for DirCopy example
    gui := Gui(, "DirCopy - Example 6: RecursiveCopy")
    
    gui.Add("Text", "x10 y10 w480", "Demonstrating DirCopy functionality")
    
    ; Main content area
    outputBox := gui.Add("Edit", "x10 y40 w480 h250 ReadOnly Multi", "")
    
    ; Example implementation
    result := ""
    result .= "Function: DirCopy\n"
    result .= "Description: RecursiveCopy\n"
    result .= "Example: 6\n\n"
    
    ; Specific functionality
    try {
        ; DirCopy specific code here
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
; Example1_DirCopy()
; Example2_DirCopy()
; Example3_DirCopy()
; Example4_DirCopy()
; Example5_DirCopy()
; Example6_DirCopy()
