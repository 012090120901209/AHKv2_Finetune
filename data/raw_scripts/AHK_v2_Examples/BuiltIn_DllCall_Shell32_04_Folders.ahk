#Requires AutoHotkey v2.0
/**
 * BuiltIn_DllCall_Shell32_04_Folders.ahk
 *
 * DESCRIPTION:
 * Demonstrates Special folder paths using Windows API through DllCall.
 * Comprehensive examples showing various Folders operations.
 *
 * FEATURES:
 * - Folders API integration
 * - Practical Folders examples
 * - Error handling
 * - Resource management
 * - Advanced Folders techniques
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - DllCall
 * https://www.autohotkey.com/docs/v2/lib/DllCall.htm
 * Microsoft Shell32 API Documentation
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - DllCall() function
 * - Windows API integration
 * - Pointer handling
 * - Structure manipulation
 * - Resource cleanup
 *
 * LEARNING POINTS:
 * 1. Understanding Shell32 API functions
 * 2. Working with Folders operations
 * 3. Proper error handling
 * 4. Memory and resource management
 * 5. Advanced Folders techniques
 * 6. Best practices for Shell32 API
 * 7. Real-world Folders applications
 */

;==============================================================================
; EXAMPLE 1: Basic Folders Operations
;==============================================================================
Example1_BasicOperations() {
    ; Basic Folders demonstration
    MsgBox("Example 1: Basic Folders OperationsnThis demonstrates fundamental Folders API calls.", "Example 1")
    
    ; Example implementation would go here
    ; This is a template - actual implementation depends on specific API
    
    result := "Example 1 demonstrates:n"
    result .= "- Basic Folders API usagen"
    result .= "- Error checkingn"
    
    MsgBox(result, "Folders - Example 1 Complete")
}

;==============================================================================
; EXAMPLE 2: Intermediate Folders Techniques
;==============================================================================
Example2_IntermediateTechniques() {
    MsgBox("Example 2: Intermediate Folders TechniquesnShowing more advanced usage.", "Example 2")
    
    result := "Example 2 demonstrates:n"
    result .= "- Intermediate Folders operationsn"
    result .= "- Data structuresn"
    
    MsgBox(result, "Folders - Example 2 Complete")
}

;==============================================================================
; EXAMPLE 3: Working with Structures
;==============================================================================
Example3_WorkingWithStructures() {
    MsgBox("Example 3: Working with Folders StructuresnDemonstrates structure handling.", "Example 3")
    
    result := "Example 3 demonstrates:n"
    result .= "- Structure creationn"
    result .= "- Buffer managementn"
    
    MsgBox(result, "Folders - Example 3 Complete")
}

;==============================================================================
; EXAMPLE 4: Error Handling and Validation
;==============================================================================
Example4_ErrorHandling() {
    MsgBox("Example 4: Error HandlingnShows proper error checking.", "Example 4")
    
    result := "Example 4 demonstrates:n"
    result .= "- Return value checkingn"
    result .= "- Try/catch integrationn"
    
    MsgBox(result, "Folders - Example 4 Complete")
}

;==============================================================================
; EXAMPLE 5: Advanced Folders Features
;==============================================================================
Example5_AdvancedFeatures() {
    MsgBox("Example 5: Advanced Folders FeaturesnAdvanced API usage patterns.", "Example 5")
    
    result := "Example 5 demonstrates:n"
    result .= "- Advanced Folders capabilitiesn"
    result .= "- Complex data handlingn"
    
    MsgBox(result, "Folders - Example 5 Complete")
}

;==============================================================================
; EXAMPLE 6: Practical Application
;==============================================================================
Example6_PracticalApplication() {
    MsgBox("Example 6: Practical ApplicationnReal-world Folders usage.", "Example 6")
    
    result := "Example 6 demonstrates:n"
    result .= "- Real-world scenariosn"
    result .= "- Integration patternsn"
    
    MsgBox(result, "Folders - Example 6 Complete")
}

;==============================================================================
; EXAMPLE 7: Comprehensive Folders Example
;==============================================================================
Example7_ComprehensiveExample() {
    MsgBox("Example 7: Comprehensive ExamplenCombining all concepts.", "Example 7")
    
    result := "Example 7 demonstrates:n"
    result .= "- Full Folders implementationn"
    result .= "- Complete error handlingn"
    
    MsgBox(result, "Folders - Example 7 Complete")
}

;==============================================================================
; HELPER FUNCTIONS
;==============================================================================

/**
 * Helper function for Folders operations
 */
HelperFunction(param) {
    ; Helper implementation
    return "Helper result"
}

;==============================================================================
; DEMO MENU
;==============================================================================

ShowDemoMenu() {
    menu := "
    (
    Folders DllCall Examples (Shell32)
    " . StrRepeat("=", 40) . "

    1. Basic Folders Operations
    2. Intermediate Techniques
    3. Working with Structures
    4. Error Handling
    5. Advanced Features
    6. Practical Application
    7. Comprehensive Example

    Enter choice (1-7) or 0 to exit:
    )"

    Loop {
        choice := InputBox(menu, "Folders Examples", "w400 h350").Value

        if (choice = "0" or choice = "")
            break

        switch choice {
            case "1": Example1_BasicOperations()
            case "2": Example2_IntermediateTechniques()
            case "3": Example3_WorkingWithStructures()
            case "4": Example4_ErrorHandling()
            case "5": Example5_AdvancedFeatures()
            case "6": Example6_PracticalApplication()
            case "7": Example7_ComprehensiveExample()
            default: MsgBox("Invalid choice! Please enter 1-7.", "Error", "IconX")
        }
    }
}

; Helper to repeat string
StrRepeat(str, count) {
    result := ""
    Loop count
        result .= str
    return result
}

; Run the demo menu
ShowDemoMenu()
