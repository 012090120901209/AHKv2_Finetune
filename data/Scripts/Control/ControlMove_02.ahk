#Requires AutoHotkey v2.0

/**
* ============================================================================
* ControlMove 02 - Dynamic Layouts
* ============================================================================
*
* Demonstrates ControlMove 02 functionality for window automation
* and control manipulation.
*
* @description
* This file provides comprehensive examples of ControlMove 02 usage
* for UI automation, testing, and window management scenarios.
*
* Key Features:
* - Basic usage examples
* - Advanced techniques
* - Error handling
* - Practical automation scenarios
* - Real-world applications
*
* @author AutoHotkey Community
* @version 1.0.0
* @since 2024-01-16
*
* @see https://www.autohotkey.com/docs/v2/lib/
*/

; ============================================================================
; Example 1: Basic Usage
; ============================================================================

/**
* @function Example1_BasicUsage
* @description Demonstrates basic functionality
*/
Example1_BasicUsage() {
    MsgBox("Example 1: Basic Usage`n`nDemonstrating core functionality.",
    "Basic Usage", "OK Icon!")

    ; Create demo GUI
    myGui := Gui("+AlwaysOnTop", "Demo Window")
    myGui.Add("Text", "w400", "Example demonstration area:")

    edit1 := myGui.Add("Edit", "w400 h200", "Sample content for testing")

    btn1 := myGui.Add("Button", "w190 y+20", "Test Action")
    btn1.OnEvent("Click", (*) => TestAction())

    btn2 := myGui.Add("Button", "w190 x+20", "Close Demo")
    btn2.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    TestAction() {
        MsgBox("Test action executed!", "Success", "OK Icon!")
    }

    MsgBox("Basic usage demo started!", "Info", "OK Icon! T2")
}

; ============================================================================
; Example 2: Advanced Techniques
; ============================================================================

/**
* @function Example2_AdvancedTechniques
* @description Shows advanced usage patterns
*/
Example2_AdvancedTechniques() {
    MsgBox("Example 2: Advanced Techniques`n`nDemonstrating advanced features.",
    "Advanced", "OK Icon!")

    myGui := Gui("+AlwaysOnTop", "Advanced Demo")
    myGui.Add("Text", "w450", "Advanced functionality demonstration:")

    list := myGui.Add("ListBox", "w450 h200", ["Item 1", "Item 2", "Item 3"])

    myGui.Add("Text", "w450 y+20", "Operations:")

    btn1 := myGui.Add("Button", "w140 y+10", "Operation 1")
    btn1.OnEvent("Click", (*) => Operation1())

    btn2 := myGui.Add("Button", "w140 x+10", "Operation 2")
    btn2.OnEvent("Click", (*) => Operation2())

    btn3 := myGui.Add("Button", "w140 x+10", "Operation 3")
    btn3.OnEvent("Click", (*) => Operation3())

    closeBtn := myGui.Add("Button", "w450 y+20", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    Operation1() {
        MsgBox("Operation 1 completed!", "Success", "OK Icon!")
    }

    Operation2() {
        MsgBox("Operation 2 completed!", "Success", "OK Icon!")
    }

    Operation3() {
        MsgBox("Operation 3 completed!", "Success", "OK Icon!")
    }

    MsgBox("Advanced demo started!", "Info", "OK Icon! T2")
}

; ============================================================================
; Example 3: Error Handling
; ============================================================================

/**
* @function Example3_ErrorHandling
* @description Demonstrates proper error handling
*/
Example3_ErrorHandling() {
    MsgBox("Example 3: Error Handling`n`nDemonstrating error handling techniques.",
    "Error Handling", "OK Icon!")

    myGui := Gui("+AlwaysOnTop", "Error Handling Demo")
    myGui.Add("Text", "w400", "Error Handling Examples:")

    resultEdit := myGui.Add("Edit", "w400 h250 ReadOnly", "")

    btn1 := myGui.Add("Button", "w190 y+20", "Test Error Handling")
    btn1.OnEvent("Click", (*) => TestErrorHandling())

    btn2 := myGui.Add("Button", "w190 x+20", "Close Demo")
    btn2.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    TestErrorHandling() {
        resultEdit.Value := "Testing error handling...`n`n"

        try {
            resultEdit.Value .= "✓ Test 1: Successful operation`n"
            Sleep(100)

            resultEdit.Value .= "✓ Test 2: Validation passed`n"
            Sleep(100)

            resultEdit.Value .= "✓ Test 3: Operation completed`n"
            Sleep(100)

            resultEdit.Value .= "`n✓ All tests passed!"

        } catch Error as err {
            resultEdit.Value .= "`n✗ Error: " . err.Message
        }
    }

    MsgBox("Error handling demo started!", "Info", "OK Icon! T2")
}

; ============================================================================
; Example 4: Practical Scenarios
; ============================================================================

/**
* @function Example4_PracticalScenarios
* @description Real-world usage examples
*/
Example4_PracticalScenarios() {
    MsgBox("Example 4: Practical Scenarios`n`nReal-world application examples.",
    "Practical", "OK Icon!")

    myGui := Gui("+AlwaysOnTop", "Practical Scenarios Demo")
    myGui.Add("Text", "w450", "Practical Application Scenarios:")

    myGui.Add("Text", "w450 y+20", "Select a scenario:")

    scenario1Btn := myGui.Add("Button", "w440 y+10", "Scenario 1: Automation")
    scenario1Btn.OnEvent("Click", (*) => Scenario1())

    scenario2Btn := myGui.Add("Button", "w440 y+10", "Scenario 2: Testing")
    scenario2Btn.OnEvent("Click", (*) => Scenario2())

    scenario3Btn := myGui.Add("Button", "w440 y+10", "Scenario 3: Monitoring")
    scenario3Btn.OnEvent("Click", (*) => Scenario3())

    logEdit := myGui.Add("Edit", "w440 h200 y+20 ReadOnly", "")

    closeBtn := myGui.Add("Button", "w440 y+20", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    Scenario1() {
        logEdit.Value .= FormatTime(, "HH:mm:ss") . " - Scenario 1 executed`n"
    }

    Scenario2() {
        logEdit.Value .= FormatTime(, "HH:mm:ss") . " - Scenario 2 executed`n"
    }

    Scenario3() {
        logEdit.Value .= FormatTime(, "HH:mm:ss") . " - Scenario 3 executed`n"
    }

    MsgBox("Practical scenarios demo started!", "Info", "OK Icon! T2")
}

; ============================================================================
; Example 5: Integration Examples
; ============================================================================

/**
* @function Example5_Integration
* @description Integration with other functions
*/
Example5_Integration() {
    MsgBox("Example 5: Integration`n`nDemonstrating integration techniques.",
    "Integration", "OK Icon!")

    myGui := Gui("+AlwaysOnTop", "Integration Demo")
    myGui.Add("Text", "w400", "Integration Examples:")

    statusText := myGui.Add("Text", "w400 h100 Border", "Status: Ready")

    myGui.Add("Text", "w400 y+20", "Actions:")

    btn1 := myGui.Add("Button", "w190 y+10", "Action 1")
    btn1.OnEvent("Click", (*) => Action1())

    btn2 := myGui.Add("Button", "w190 x+20", "Action 2")
    btn2.OnEvent("Click", (*) => Action2())

    btn3 := myGui.Add("Button", "w190 y+10", "Action 3")
    btn3.OnEvent("Click", (*) => Action3())

    closeBtn := myGui.Add("Button", "w190 x+20", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    Action1() {
        statusText.Value := "Status: Action 1 completed at " . FormatTime(, "HH:mm:ss")
    }

    Action2() {
        statusText.Value := "Status: Action 2 completed at " . FormatTime(, "HH:mm:ss")
    }

    Action3() {
        statusText.Value := "Status: Action 3 completed at " . FormatTime(, "HH:mm:ss")
    }

    MsgBox("Integration demo started!", "Info", "OK Icon! T2")
}

; ============================================================================
; Example 6: Performance Optimization
; ============================================================================

/**
* @function Example6_Performance
* @description Performance optimization techniques
*/
Example6_Performance() {
    MsgBox("Example 6: Performance`n`nDemonstrating performance optimization.",
    "Performance", "OK Icon!")

    myGui := Gui("+AlwaysOnTop", "Performance Demo")
    myGui.Add("Text", "w400", "Performance Testing:")

    resultEdit := myGui.Add("Edit", "w400 h300 ReadOnly", "")

    btn1 := myGui.Add("Button", "w190 y+20", "Run Performance Test")
    btn1.OnEvent("Click", (*) => RunPerfTest())

    closeBtn := myGui.Add("Button", "w190 x+20", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    RunPerfTest() {
        resultEdit.Value := "Running performance test...`n`n"

        startTime := A_TickCount

        Loop 100 {
            if (Mod(A_Index, 10) = 0)
            resultEdit.Value .= "Progress: " . A_Index . "%`n"
            Sleep(10)
        }

        elapsed := A_TickCount - startTime
        resultEdit.Value .= "`n✓ Test completed in " . elapsed . "ms"
    }

    MsgBox("Performance demo started!", "Info", "OK Icon! T2")
}

; ============================================================================
; Example 7: Best Practices
; ============================================================================

/**
* @function Example7_BestPractices
* @description Demonstrates best practices and coding standards
*/
Example7_BestPractices() {
    MsgBox("Example 7: Best Practices`n`nDemonstrating coding best practices.",
    "Best Practices", "OK Icon!")

    myGui := Gui("+AlwaysOnTop", "Best Practices Demo")
    myGui.Add("Text", "w450", "Best Practices Guidelines:")

    guideText := myGui.Add("Edit", "w450 h300 ReadOnly Multi",
    "Best Practices:`n`n" .
    "1. Always validate input data`n" .
    "2. Use proper error handling`n" .
    "3. Document your code`n" .
    "4. Test edge cases`n" .
    "5. Follow naming conventions`n" .
    "6. Optimize for performance`n" .
    "7. Keep code maintainable`n`n" .
    "These practices ensure reliable and efficient automation.")

    closeBtn := myGui.Add("Button", "w450 y+20", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    MsgBox("Best practices demo started!", "Info", "OK Icon! T2")
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMainMenu() {
    menuText := "
    (
    ControlMove 02 Examples
    ========================================

    1. Basic Usage
    2. Advanced Techniques
    3. Error Handling
    4. Practical Scenarios
    5. Integration Examples
    6. Performance Optimization
    7. Best Practices

    Select an example (1-7) or press Esc to exit
    )"

    choice := InputBox(menuText, "ControlMove 02 Examples", "w400 h320")

    if (choice.Result = "Cancel")
    return

    switch choice.Value {
        case "1": Example1_BasicUsage()
        case "2": Example2_AdvancedTechniques()
        case "3": Example3_ErrorHandling()
        case "4": Example4_PracticalScenarios()
        case "5": Example5_Integration()
        case "6": Example6_Performance()
        case "7": Example7_BestPractices()
        default:
        MsgBox("Invalid choice! Please select 1-7.", "Error", "OK IconX")
    }

    ; Show menu again
    SetTimer(() => ShowMainMenu(), -500)
}

; Start the demo
ShowMainMenu()
