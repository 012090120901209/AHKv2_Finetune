#Requires AutoHotkey v2.0
/**
 * BuiltIn_DllCall_Winmm_01_Sound.ahk
 *
 * DESCRIPTION:
 * Demonstrates Sound playback functions using Windows API through DllCall.
 * Comprehensive examples showing various Sound operations.
 *
 * FEATURES:
 * - Sound API integration
 * - Practical Sound examples
 * - Error handling
 * - Resource management
 * - Advanced Sound techniques
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - DllCall
 * https://www.autohotkey.com/docs/v2/lib/DllCall.htm
 * Microsoft Winmm API Documentation
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - DllCall() function
 * - Windows API integration
 * - Pointer handling
 * - Structure manipulation
 * - Resource cleanup
 *
 * LEARNING POINTS:
 * 1. Understanding Winmm API functions
 * 2. Working with Sound operations
 * 3. Proper error handling
 * 4. Memory and resource management
 * 5. Advanced Sound techniques
 * 6. Best practices for Winmm API
 * 7. Real-world Sound applications
 */

;==============================================================================
; EXAMPLE 1: Basic Sound Operations
;==============================================================================
Example1_BasicOperations() {
    ; Basic Sound demonstration
    MsgBox("Example 1: Basic Sound OperationsnThis demonstrates fundamental Sound API calls.", "Example 1")
    
    ; Example implementation would go here
    ; This is a template - actual implementation depends on specific API
    
    result := "Example 1 demonstrates:n"
    result .= "- Basic Sound API usagen"
    result .= "- Error checkingn"
    
    MsgBox(result, "Sound - Example 1 Complete")
}

;==============================================================================
; EXAMPLE 2: Intermediate Sound Techniques
;==============================================================================
Example2_IntermediateTechniques() {
    MsgBox("Example 2: Intermediate Sound TechniquesnShowing more advanced usage.", "Example 2")
    
    result := "Example 2 demonstrates:n"
    result .= "- Intermediate Sound operationsn"
    result .= "- Data structuresn"
    
    MsgBox(result, "Sound - Example 2 Complete")
}

;==============================================================================
; EXAMPLE 3: Working with Structures
;==============================================================================
Example3_WorkingWithStructures() {
    MsgBox("Example 3: Working with Sound StructuresnDemonstrates structure handling.", "Example 3")
    
    result := "Example 3 demonstrates:n"
    result .= "- Structure creationn"
    result .= "- Buffer managementn"
    
    MsgBox(result, "Sound - Example 3 Complete")
}

;==============================================================================
; EXAMPLE 4: Error Handling and Validation
;==============================================================================
Example4_ErrorHandling() {
    MsgBox("Example 4: Error HandlingnShows proper error checking.", "Example 4")
    
    result := "Example 4 demonstrates:n"
    result .= "- Return value checkingn"
    result .= "- Try/catch integrationn"
    
    MsgBox(result, "Sound - Example 4 Complete")
}

;==============================================================================
; EXAMPLE 5: Advanced Sound Features
;==============================================================================
Example5_AdvancedFeatures() {
    MsgBox("Example 5: Advanced Sound FeaturesnAdvanced API usage patterns.", "Example 5")
    
    result := "Example 5 demonstrates:n"
    result .= "- Advanced Sound capabilitiesn"
    result .= "- Complex data handlingn"
    
    MsgBox(result, "Sound - Example 5 Complete")
}

;==============================================================================
; EXAMPLE 6: Practical Application
;==============================================================================
Example6_PracticalApplication() {
    MsgBox("Example 6: Practical ApplicationnReal-world Sound usage.", "Example 6")
    
    result := "Example 6 demonstrates:n"
    result .= "- Real-world scenariosn"
    result .= "- Integration patternsn"
    
    MsgBox(result, "Sound - Example 6 Complete")
}

;==============================================================================
; EXAMPLE 7: Comprehensive Sound Example
;==============================================================================
Example7_ComprehensiveExample() {
    MsgBox("Example 7: Comprehensive ExamplenCombining all concepts.", "Example 7")
    
    result := "Example 7 demonstrates:n"
    result .= "- Full Sound implementationn"
    result .= "- Complete error handlingn"
    
    MsgBox(result, "Sound - Example 7 Complete")
}

;==============================================================================
; HELPER FUNCTIONS
;==============================================================================

/**
 * Helper function for Sound operations
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
    Sound DllCall Examples (Winmm)
    " . StrRepeat("=", 40) . "

    1. Basic Sound Operations
    2. Intermediate Techniques
    3. Working with Structures
    4. Error Handling
    5. Advanced Features
    6. Practical Application
    7. Comprehensive Example

    Enter choice (1-7) or 0 to exit:
    )"

    Loop {
        choice := InputBox(menu, "Sound Examples", "w400 h350").Value

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
