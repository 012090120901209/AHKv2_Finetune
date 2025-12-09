#Requires AutoHotkey v2.0

/**
* ============================================================================
* MsgBox Basic Examples - Part 1
* ============================================================================
*
* Comprehensive examples demonstrating basic MsgBox usage in AutoHotkey v2.
*
* @description This file covers fundamental MsgBox functionality including:
*              - Simple message displays
*              - Basic button configurations
*              - Icon types and visual feedback
*              - Return value handling
*
* @author AutoHotkey Foundation
* @version 2.0
* @see https://www.autohotkey.com/docs/v2/lib/MsgBox.htm
*
* ============================================================================
*/

; ============================================================================
; EXAMPLE 1: Simple Message Display
; ============================================================================
/**
* Demonstrates the most basic MsgBox usage with plain text messages.
*
* @description Shows how to display simple informational messages to users
*              without buttons or icons configuration.
*
* @example
* MsgBox "Hello, World!"
*/
Example1_SimpleMessage() {
    ; Basic message - default OK button and no icon
    MsgBox "This is a simple message box."

    ; Message with line breaks for better readability
    MsgBox "This message contains`nmultiple lines`nfor better formatting."

    ; Using variables in messages
    userName := "John Doe"
    MsgBox "Welcome, " . userName . "!"

    ; String interpolation with format (recommended in v2)
    age := 25
    MsgBox Format("User {1} is {2} years old.", userName, age)

    ; Long message with word wrapping
    longMessage := "This is a very long message that demonstrates how MsgBox "
    . "automatically wraps text to fit within the dialog window. "
    . "The window will resize to accommodate the content up to "
    . "a maximum width, after which text wrapping occurs."
    MsgBox longMessage

    ; Message with special characters
    MsgBox "Special characters: © ® ™ ± × ÷ § ¶"

    ; Empty message (displays blank dialog)
    MsgBox ""  ; Not recommended, but possible
}

; ============================================================================
; EXAMPLE 2: Button Configurations
; ============================================================================
/**
* Explores different button combinations available in MsgBox.
*
* @description Demonstrates all standard button layouts and how to
*              configure them using the Options parameter.
*
* @param {String} options Numeric or string button configuration
* @returns {String} Button pressed by user
*
* Button Types:
* - 0/OK: OK button only (default)
* - 1/OKCancel: OK and Cancel buttons
* - 2/AbortRetryIgnore: Abort, Retry, and Ignore buttons
* - 3/YesNoCancel: Yes, No, and Cancel buttons
* - 4/YesNo: Yes and No buttons
* - 5/RetryCancel: Retry and Cancel buttons
* - 6/CancelTryAgainContinue: Cancel, Try Again, and Continue buttons
*/
Example2_ButtonConfigurations() {
    ; OK button only (default - option 0)
    MsgBox "This shows only an OK button.", "Information"

    ; OK and Cancel buttons (option 1)
    result := MsgBox("Do you want to continue?", "Confirmation", "OKCancel")
    MsgBox "You clicked: " . result

    ; Abort, Retry, Ignore buttons (option 2)
    result := MsgBox("An error occurred. What would you like to do?",
    "Error Handler",
    "AbortRetryIgnore")
    MsgBox "You selected: " . result

    ; Yes, No, Cancel buttons (option 3)
    result := MsgBox("Would you like to save your changes?",
    "Save Confirmation",
    "YesNoCancel")
    Switch result {
        Case "Yes":
        MsgBox "Changes will be saved."
        Case "No":
        MsgBox "Changes will be discarded."
        Case "Cancel":
        MsgBox "Operation cancelled."
    }

    ; Yes and No buttons (option 4)
    result := MsgBox("Is this your first time using this application?",
    "Welcome",
    "YesNo")
    if (result = "Yes")
    MsgBox "Welcome! Let's show you a quick tutorial."
    else
    MsgBox "Welcome back!"

    ; Retry and Cancel buttons (option 5)
    result := MsgBox("Connection failed. Would you like to retry?",
    "Connection Error",
    "RetryCancel")
    if (result = "Retry")
    MsgBox "Attempting to reconnect..."
    else
    MsgBox "Connection cancelled by user."

    ; Cancel, Try Again, Continue buttons (option 6)
    result := MsgBox("Installation incomplete. Choose an option:",
    "Installation",
    "CancelTryAgainContinue")
    Switch result {
        Case "Cancel":
        MsgBox "Installation cancelled."
        Case "TryAgain":
        MsgBox "Retrying installation..."
        Case "Continue":
        MsgBox "Continuing with partial installation..."
    }
}

; ============================================================================
; EXAMPLE 3: Icon Types
; ============================================================================
/**
* Demonstrates all available icon types in MsgBox.
*
* @description Shows how to add visual cues using different icon types
*              to convey message importance and context.
*
* Icon Options:
* - 16/Iconx: Stop/Error icon (red X)
* - 32/Icon?: Question icon (blue ?)
* - 48/Icon!: Exclamation/Warning icon (yellow !)
* - 64/Iconi: Information icon (blue i)
*/
Example3_IconTypes() {
    ; Error/Stop icon (16 or "Iconx")
    MsgBox "A critical error has occurred!`n`nPlease contact support.",
    "Critical Error",
    "Iconx"

    ; Question icon (32 or "Icon?")
    MsgBox "Are you sure you want to delete this file?`n`nThis action cannot be undone.",
    "Confirm Deletion",
    "YesNo Icon?"

    ; Warning/Exclamation icon (48 or "Icon!")
    MsgBox "Warning: This operation will modify system settings.`n`nProceed with caution.",
    "Warning",
    "OKCancel Icon!"

    ; Information icon (64 or "Iconi")
    MsgBox "Operation completed successfully!`n`nAll files have been processed.",
    "Success",
    "Iconi"

    ; Combining icons with different button sets
    MsgBox "Your trial period will expire in 5 days.`n`nWould you like to purchase now?",
    "Trial Expiration",
    "YesNo Icon!"

    ; Using numeric values instead of string names
    MsgBox "This uses numeric icon value (64 = Information)",
    "Numeric Icon",
    64
}

; ============================================================================
; EXAMPLE 4: Return Value Handling
; ============================================================================
/**
* Shows how to capture and process MsgBox return values.
*
* @description Demonstrates proper handling of user responses and
*              implementing conditional logic based on button clicks.
*
* @returns {String} Possible values: OK, Cancel, Yes, No, Abort, Retry,
*                   Ignore, TryAgain, Continue
*/
Example4_ReturnValueHandling() {
    ; Simple Yes/No decision
    answer := MsgBox("Do you want to enable auto-save?", "Settings", "YesNo")

    if (answer = "Yes") {
        autoSaveEnabled := true
        MsgBox "Auto-save has been enabled."
    } else {
        autoSaveEnabled := false
        MsgBox "Auto-save remains disabled."
    }

    ; Complex decision tree with multiple options
    fileAction := MsgBox("The file already exists. What would you like to do?",
    "File Exists",
    "YesNoCancel Icon?")

    Switch fileAction {
        Case "Yes":
        MsgBox "Overwriting existing file..."
        Case "No":
        newName := InputBox("Enter a new filename:", "Save As").Value
        MsgBox "Saving as: " . newName
        Case "Cancel":
        MsgBox "Save operation cancelled."
    }

    ; Error handling workflow
    errorResponse := MsgBox("An error occurred while processing.`n`nError Code: 0x80004005",
    "Error",
    "AbortRetryIgnore Iconx")

    Switch errorResponse {
        Case "Abort":
        MsgBox "Operation aborted. Rolling back changes..."
        Case "Retry":
        MsgBox "Retrying operation..."
        Case "Ignore":
        MsgBox "Error ignored. Continuing with next item..."
    }

    ; Nested MsgBox decisions
    firstChoice := MsgBox("Would you like to customize settings?",
    "Setup Wizard",
    "YesNo Iconi")

    if (firstChoice = "Yes") {
        secondChoice := MsgBox("Use advanced settings?",
        "Advanced Options",
        "YesNo Icon?")

        if (secondChoice = "Yes")
        MsgBox "Advanced settings mode activated."
        else
        MsgBox "Basic settings mode activated."
    } else {
        MsgBox "Using default settings."
    }
}

; ============================================================================
; EXAMPLE 5: Title and Options Combinations
; ============================================================================
/**
* Demonstrates proper title usage and option combinations.
*
* @description Shows how to create professional-looking message boxes
*              with meaningful titles and appropriate options.
*/
Example5_TitleAndOptions() {
    ; Descriptive title with simple message
    MsgBox "Your password has been updated successfully.",
    "Password Changed",
    "Iconi"

    ; Application-branded messages
    appName := "MyApplication v2.0"
    MsgBox "Thank you for using " . appName . "!",
    appName . " - Registration Complete"

    ; Context-specific titles
    MsgBox "Please check your internet connection and try again.",
    "Network Error - " . appName,
    "RetryCancel Iconx"

    ; Multiple options combined (Yes/No + Warning Icon)
    result := MsgBox("This will permanently delete all cached data.`n`nContinue?",
    "Clear Cache",
    "YesNo Icon! 256")  ; 256 = Default button 2 (No)

    ; Professional error messages
    errorCode := "ERR_CONNECTION_REFUSED"
    MsgBox Format("Connection to server failed.`n`nError: {1}`nTime: {2}",
    errorCode,
    FormatTime(, "yyyy-MM-dd HH:mm:ss")),
    "Connection Failed",
    "RetryCancel Iconx"

    ; Success confirmation with details
    filesProcessed := 150
    timeElapsed := 45
    MsgBox Format("Operation completed successfully!`n`nFiles processed: {1}`nTime elapsed: {2} seconds",
    filesProcessed,
    timeElapsed),
    "Batch Processing Complete",
    "Iconi"
}

; ============================================================================
; EXAMPLE 6: Practical Real-World Scenarios
; ============================================================================
/**
* Real-world application scenarios using MsgBox.
*
* @description Practical examples showing common use cases in
*              desktop applications and automation scripts.
*/
Example6_PracticalScenarios() {
    ; Scenario 1: Unsaved Changes Warning
    hasUnsavedChanges := true

    if (hasUnsavedChanges) {
        response := MsgBox("You have unsaved changes.`n`nSave before closing?",
        "Unsaved Changes",
        "YesNoCancel Icon!")

        Switch response {
            Case "Yes":
            MsgBox "Saving changes..."
            ; SaveData()
            Case "No":
            MsgBox "Closing without saving..."
            Case "Cancel":
            MsgBox "Close operation cancelled."
            return
        }
    }

    ; Scenario 2: License Agreement
    eula := "END USER LICENSE AGREEMENT`n`n"
    . "1. You must accept these terms to continue.`n"
    . "2. Software is provided 'as-is' without warranty.`n"
    . "3. You may not redistribute this software."

    acceptance := MsgBox(eula . "`n`nDo you accept these terms?",
    "License Agreement",
    "YesNo Icon?")

    if (acceptance = "No") {
        MsgBox "Installation cancelled. You must accept the license to continue.",
        "Installation Cancelled",
        "Iconi"
        return
    }

    ; Scenario 3: Disk Space Warning
    availableSpace := 150  ; MB
    requiredSpace := 500   ; MB

    if (availableSpace < requiredSpace) {
        shortfall := requiredSpace - availableSpace
        warning := Format("Insufficient disk space!`n`nRequired: {1} MB`nAvailable: {2} MB`nShortfall: {3} MB`n`nContinue anyway?",
        requiredSpace,
        availableSpace,
        shortfall)

        MsgBox warning, "Disk Space Warning", "YesNo Iconx"
    }

    ; Scenario 4: Update Notification
    currentVersion := "2.1.0"
    latestVersion := "2.2.0"

    updateMsg := Format("A new version is available!`n`nCurrent: v{1}`nLatest: v{2}`n`nWould you like to download it now?",
    currentVersion,
    latestVersion)

    response := MsgBox(updateMsg, "Update Available", "YesNo Iconi")

    if (response = "Yes")
    MsgBox "Opening download page..."

    ; Scenario 5: Timeout Notification (simulated)
    sessionTimeRemaining := 2  ; minutes

    if (sessionTimeRemaining <= 5) {
        timeoutWarning := Format("Your session will expire in {1} minutes.`n`nExtend session?",
        sessionTimeRemaining)

        response := MsgBox(timeoutWarning,
        "Session Timeout Warning",
        "YesNo Icon! 256")  ; Default to No

        if (response = "Yes")
        MsgBox "Session extended for 30 minutes."
        else
        MsgBox "Session will expire as scheduled."
    }
}

; ============================================================================
; EXAMPLE 7: Advanced Options and Modality
; ============================================================================
/**
* Demonstrates advanced MsgBox options including system modality and
* default button selection.
*
* @description Shows advanced features like making MsgBox system-modal
*              and pre-selecting default buttons.
*
* Advanced Options:
* - 256: Make second button the default
* - 512: Make third button the default
* - 4096: System modal (always on top)
* - 262144: Make MsgBox always-on-top
*/
Example7_AdvancedOptions() {
    ; Default button selection - Button 2 (256)
    result := MsgBox("Delete this file?`n`nThis action cannot be undone!",
    "Confirm Deletion",
    "YesNo Icon! 256")  ; No is default

    MsgBox "You selected: " . result

    ; Default button 3 (512)
    result := MsgBox("Choose an action:",
    "File Options",
    "YesNoCancel 512")  ; Cancel is default

    ; System modal - blocks all other windows (4096)
    MsgBox "This is a system-modal message.`nNo other windows can be accessed until you close this.",
    "System Modal",
    "4096 Iconx"

    ; Always on top (262144)
    MsgBox "This message box stays on top of other windows.",
    "Always On Top",
    "262144 Iconi"

    ; Combining multiple options
    ; YesNo (4) + Warning Icon (48) + Default Button 2 (256) + Always On Top (262144)
    options := 4 + 48 + 256 + 262144
    result := MsgBox("Proceed with system changes?",
    "Administrator Action Required",
    options)

    ; Using option combinations for critical dialogs
    criticalOptions := "YesNo Iconx 256 4096"  ; String format
    result := MsgBox("WARNING: This will erase all data!`n`nAre you absolutely sure?",
    "CRITICAL WARNING",
    criticalOptions)

    if (result = "Yes") {
        ; Double confirmation for critical actions
        doubleCheck := MsgBox("This is your last chance to cancel.`n`nReally delete everything?",
        "FINAL CONFIRMATION",
        "YesNo Iconx 256 4096")

        if (doubleCheck = "Yes")
        MsgBox "Data deletion initiated...", "Processing", "Iconi"
        else
        MsgBox "Operation cancelled at final confirmation.", "Cancelled", "Iconi"
    } else {
        MsgBox "Operation cancelled.", "Cancelled", "Iconi"
    }
}

; ============================================================================
; Hotkey Triggers (for testing)
; ============================================================================

; Press Ctrl+1 to run Example 1
^1::Example1_SimpleMessage()

; Press Ctrl+2 to run Example 2
^2::Example2_ButtonConfigurations()

; Press Ctrl+3 to run Example 3
^3::Example3_IconTypes()

; Press Ctrl+4 to run Example 4
^4::Example4_ReturnValueHandling()

; Press Ctrl+5 to run Example 5
^5::Example5_TitleAndOptions()

; Press Ctrl+6 to run Example 6
^6::Example6_PracticalScenarios()

; Press Ctrl+7 to run Example 7
^7::Example7_AdvancedOptions()

; Press Ctrl+0 to exit script
^0::ExitApp

/**
* ============================================================================
* SUMMARY
* ============================================================================
*
* This file demonstrates comprehensive MsgBox usage including:
*
* 1. Simple message displays with text formatting
* 2. All button configuration options (7 types)
* 3. Icon types for visual feedback (4 types)
* 4. Return value handling and conditional logic
* 5. Professional title and option combinations
* 6. Real-world practical scenarios
* 7. Advanced options (modality, default buttons)
*
* Key Takeaways:
* - MsgBox is the primary method for user communication
* - Always use appropriate icons to convey message importance
* - Choose button configurations that match user decision requirements
* - Handle return values to create interactive workflows
* - Use descriptive titles for professional appearance
* - Consider default button selection for safety-critical actions
*
* ============================================================================
*/
