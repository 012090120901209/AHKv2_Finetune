#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * MsgBox Advanced Examples - Part 2
 * ============================================================================
 * 
 * Advanced MsgBox patterns and techniques in AutoHotkey v2.
 * 
 * @description This file covers advanced MsgBox functionality including:
 *              - Timeout functionality
 *              - Owner window specification
 *              - Multi-step wizards
 *              - Input validation feedback
 *              - Error handling patterns
 * 
 * @author AutoHotkey Foundation
 * @version 2.0
 * @see https://www.autohotkey.com/docs/v2/lib/MsgBox.htm
 * 
 * ============================================================================
 */

; ============================================================================
; EXAMPLE 1: Timeout Messages
; ============================================================================
/**
 * Demonstrates MsgBox with automatic timeout using SetTimer.
 * 
 * @description Shows how to create self-closing message boxes that
 *              automatically dismiss after a specified time.
 * 
 * @param {Integer} timeout Time in milliseconds before auto-close
 */
Example1_TimeoutMessages() {
    ; Auto-closing information message (3 seconds)
    ShowTimedMessage("File saved successfully!", 3000)

    ; Processing notification with timeout
    ShowTimedMessage("Processing... Please wait.", 2000)

    ; Temporary notification
    ShowTimedMessage("Configuration updated.", 1500)

    ; Auto-dismiss warning
    ShowTimedMessage("Low disk space detected.`nPlease free up some space.", 5000)

    ; Multiple sequential timed messages
    ShowTimedMessage("Step 1: Initializing...", 1500)
    Sleep 1600
    ShowTimedMessage("Step 2: Loading modules...", 1500)
    Sleep 1600
    ShowTimedMessage("Step 3: Complete!", 1500)
}

/**
 * Helper function to show a message with automatic timeout.
 * 
 * @param {String} message The message to display
 * @param {Integer} timeout Time in milliseconds before auto-close
 */
ShowTimedMessage(message, timeout := 3000) {
    ; Create the message box in a separate thread
    SetTimer(CloseMessageBox, timeout)
    MsgBox message, "Notification", "T" . (timeout / 1000)

    CloseMessageBox() {
        ; Close any visible message box
        if WinExist("Notification") {
            WinClose "Notification"
        }
        SetTimer(CloseMessageBox, 0)  ; Turn off the timer
    }
}

; ============================================================================
; EXAMPLE 2: Multi-Step Wizard Pattern
; ============================================================================
/**
 * Demonstrates using MsgBox for creating multi-step wizards.
 * 
 * @description Shows how to chain multiple MsgBox dialogs to create
 *              an interactive setup or configuration wizard.
 */
Example2_WizardPattern() {
    ; Step 1: Welcome
    welcome := MsgBox("Welcome to the Setup Wizard!`n`n"
        . "This wizard will guide you through the configuration process.`n`n"
        . "Click OK to continue or Cancel to exit.",
        "Setup Wizard - Step 1 of 4",
        "OKCancel Iconi")

    if (welcome = "Cancel") {
        MsgBox "Setup cancelled.", "Cancelled", "Iconi"
        return
    }

    ; Step 2: Choose installation type
    installType := MsgBox("Choose installation type:`n`n"
        . "Yes - Full Installation (recommended)`n"
        . "No - Custom Installation`n"
        . "Cancel - Exit Setup",
        "Setup Wizard - Step 2 of 4",
        "YesNoCancel Icon?")

    Switch installType {
        Case "Cancel":
            MsgBox "Setup cancelled.", "Cancelled", "Iconi"
            return
        Case "Yes":
            installMode := "Full"
            components := "All components will be installed."
        Case "No":
            installMode := "Custom"
            components := "You can select specific components."
    }

    ; Step 3: Confirm settings
    confirmMsg := Format("Installation Summary:`n`n"
        . "Type: {1}`n"
        . "Components: {2}`n"
        . "Destination: C:\Program Files\MyApp`n`n"
        . "Proceed with installation?",
        installMode,
        components)

    confirmation := MsgBox(confirmMsg,
        "Setup Wizard - Step 3 of 4",
        "YesNo Icon?")

    if (confirmation = "No") {
        MsgBox "Installation cancelled.", "Cancelled", "Iconi"
        return
    }

    ; Step 4: Installation progress (simulated)
    MsgBox "Installing... Please wait.`n`nThis may take several minutes.",
        "Setup Wizard - Step 4 of 4",
        "Iconi"

    ; Simulate installation time
    Sleep 2000

    ; Step 5: Completion
    MsgBox "Installation completed successfully!`n`n"
        . "Click OK to launch the application.",
        "Setup Complete",
        "Iconi"
}

; ============================================================================
; EXAMPLE 3: Input Validation Feedback
; ============================================================================
/**
 * Shows how to use MsgBox for providing validation feedback.
 * 
 * @description Demonstrates error messages and validation patterns
 *              when working with user input.
 */
Example3_ValidationFeedback() {
    Loop {
        ; Get user input
        userInput := InputBox("Enter your email address:", "Registration").Value

        ; Validate email format
        if (userInput = "") {
            retry := MsgBox("Email address cannot be empty.`n`nTry again?",
                "Validation Error",
                "RetryCancel Iconx")
            if (retry = "Cancel")
                break
            continue
        }

        if (!RegExMatch(userInput, "^[\w\.-]+@[\w\.-]+\.\w+$")) {
            retry := MsgBox("Invalid email format.`n`nPlease enter a valid email address (example@domain.com).`n`nTry again?",
                "Validation Error",
                "RetryCancel Iconx")
            if (retry = "Cancel")
                break
            continue
        }

        ; Email is valid
        MsgBox "Email address accepted: " . userInput,
            "Success",
            "Iconi"
        break
    }

    ; Password validation example
    Loop {
        password := InputBox("Create a password (min 8 characters):", "Password", "Password").Value

        if (password = "") {
            retry := MsgBox("Password cannot be empty.`n`nTry again?",
                "Validation Error",
                "RetryCancel Iconx")
            if (retry = "Cancel")
                return
            continue
        }

        if (StrLen(password) < 8) {
            retry := MsgBox(Format("Password too short ({1} characters).`n`nMinimum length: 8 characters`n`nTry again?",
                StrLen(password)),
                "Validation Error",
                "RetryCancel Iconx")
            if (retry = "Cancel")
                return
            continue
        }

        ; Password is valid
        MsgBox "Password meets requirements.",
            "Success",
            "Iconi"
        break
    }
}

; ============================================================================
; EXAMPLE 4: Error Handling Patterns
; ============================================================================
/**
 * Demonstrates comprehensive error handling with MsgBox.
 * 
 * @description Shows different error severity levels and appropriate
 *              user response options.
 */
Example4_ErrorHandlingPatterns() {
    ; Critical Error - Must abort
    HandleCriticalError()

    ; Recoverable Error - Can retry
    HandleRecoverableError()

    ; Warning - Can continue with caution
    HandleWarning()

    ; Non-critical Error - Can ignore
    HandleNonCriticalError()
}

/**
 * Handles critical errors that require immediate attention.
 */
HandleCriticalError() {
    errorDetails := "CRITICAL ERROR: System file corrupted`n`n"
        . "Error Code: 0xC000000E`n"
        . "File: system32.dll`n`n"
        . "The application must close."

    MsgBox errorDetails,
        "Critical Error",
        "Iconx 4096"  ; System modal

    ; In real scenario: ExitApp
}

/**
 * Handles errors that can be retried.
 */
HandleRecoverableError() {
    maxRetries := 3
    retryCount := 0

    Loop {
        ; Simulate operation that might fail
        operationSuccess := (Random(0, 1) = 1)

        if (operationSuccess) {
            MsgBox "Operation completed successfully!",
                "Success",
                "Iconi"
            break
        }

        retryCount++

        if (retryCount >= maxRetries) {
            MsgBox Format("Operation failed after {1} attempts.`n`nPlease contact support.",
                maxRetries),
                "Operation Failed",
                "Iconx"
            break
        }

        retry := MsgBox(Format("Operation failed (Attempt {1} of {2}).`n`nError: Connection timeout`n`nRetry?",
            retryCount,
            maxRetries),
            "Error",
            "RetryCancel Iconx")

        if (retry = "Cancel") {
            MsgBox "Operation cancelled by user.",
                "Cancelled",
                "Iconi"
            break
        }
    }
}

/**
 * Handles warnings that allow continuation.
 */
HandleWarning() {
    warningMsg := "WARNING: Disk space is running low.`n`n"
        . "Available: 500 MB`n"
        . "Recommended: 2 GB`n`n"
        . "Continue anyway?"

    response := MsgBox(warningMsg,
        "Warning",
        "YesNo Icon! 256")  ; Default to No

    if (response = "Yes")
        MsgBox "Continuing operation with limited disk space...",
            "Continuing",
            "Icon!"
    else
        MsgBox "Operation cancelled. Please free up disk space.",
            "Cancelled",
            "Iconi"
}

/**
 * Handles non-critical errors that can be ignored.
 */
HandleNonCriticalError() {
    errorMsg := "Minor issue detected:`n`n"
        . "Unable to load custom theme.`n"
        . "Using default theme instead.`n`n"
        . "Would you like to see more details?"

    response := MsgBox(errorMsg,
        "Non-Critical Error",
        "YesNo Iconi")

    if (response = "Yes") {
        detailsMsg := "Error Details:`n`n"
            . "Theme file: custom_theme.ini`n"
            . "Error: File not found`n"
            . "Path: C:\Users\Public\Themes\`n"
            . "Fallback: Default theme loaded successfully"

        MsgBox detailsMsg,
            "Error Details",
            "Iconi"
    }
}

; ============================================================================
; EXAMPLE 5: Confirmation Dialogs with Safety Checks
; ============================================================================
/**
 * Demonstrates safe confirmation patterns for destructive actions.
 * 
 * @description Shows multi-level confirmation for critical operations.
 */
Example5_SafeConfirmations() {
    ; Single confirmation for moderate risk
    DeleteFileWithConfirmation("document.txt")

    ; Double confirmation for high risk
    DeleteAllFilesWithConfirmation(42)

    ; Typed confirmation for critical actions
    FormatDriveWithTypedConfirmation("E:")
}

/**
 * Confirms single file deletion.
 */
DeleteFileWithConfirmation(filename) {
    confirm := MsgBox(Format("Delete file '{1}'?`n`nThis action cannot be undone.",
        filename),
        "Confirm Deletion",
        "YesNo Icon! 256")

    if (confirm = "Yes") {
        MsgBox "File deleted: " . filename,
            "Deleted",
            "Iconi"
        ; FileDelete filename
    } else {
        MsgBox "Deletion cancelled.",
            "Cancelled",
            "Iconi"
    }
}

/**
 * Confirms deletion of multiple files with double-check.
 */
DeleteAllFilesWithConfirmation(fileCount) {
    ; First confirmation
    firstConfirm := MsgBox(Format("Delete {1} files?`n`nThis action cannot be undone.",
        fileCount),
        "Confirm Batch Deletion",
        "YesNo Iconx 256")

    if (firstConfirm = "No") {
        MsgBox "Deletion cancelled.",
            "Cancelled",
            "Iconi"
        return
    }

    ; Second confirmation
    secondConfirm := MsgBox(Format("Are you absolutely sure you want to delete {1} files?`n`nThis is your last chance to cancel!",
        fileCount),
        "FINAL CONFIRMATION",
        "YesNo Iconx 256 4096")

    if (secondConfirm = "Yes") {
        MsgBox Format("Deleting {1} files...", fileCount),
            "Deleting",
            "Iconi"
        ; Perform deletion
    } else {
        MsgBox "Deletion cancelled at final confirmation.",
            "Cancelled",
            "Iconi"
    }
}

/**
 * Requires typed confirmation for critical operations.
 */
FormatDriveWithTypedConfirmation(driveLetter) {
    ; Show warning
    warning := MsgBox(Format("WARNING: You are about to format drive {1}:`n`n"
        . "ALL DATA WILL BE PERMANENTLY ERASED!`n`n"
        . "Continue?",
        driveLetter),
        "FORMAT WARNING",
        "YesNo Iconx 256 4096")

    if (warning = "No") {
        MsgBox "Format cancelled.",
            "Cancelled",
            "Iconi"
        return
    }

    ; Require typed confirmation
    MsgBox Format("To confirm, you must type: FORMAT {1}`n`nThis will be requested in the next dialog.",
        driveLetter),
        "Confirmation Required",
        "Icon!"

    Loop {
        confirmation := InputBox(Format("Type 'FORMAT {1}' to confirm:", driveLetter),
            "Type to Confirm").Value

        if (confirmation = Format("FORMAT {1}", driveLetter)) {
            MsgBox Format("Drive {1}: format initiated...`n`nNOTE: This is a demonstration only!",
                driveLetter),
                "Formatting",
                "Iconx"
            break
        } else if (confirmation = "") {
            MsgBox "Format cancelled.",
                "Cancelled",
                "Iconi"
            break
        } else {
            retry := MsgBox("Incorrect confirmation text.`n`nTry again?",
                "Error",
                "RetryCancel Iconx")
            if (retry = "Cancel") {
                MsgBox "Format cancelled.",
                    "Cancelled",
                    "Iconi"
                break
            }
        }
    }
}

; ============================================================================
; EXAMPLE 6: Context-Aware Messages
; ============================================================================
/**
 * Demonstrates context-aware messaging based on application state.
 * 
 * @description Shows how to customize messages based on user context
 *              and application state.
 */
Example6_ContextAwareMessages() {
    ; Initialize app state
    global AppState := {
        isLoggedIn: false,
        userName: "",
        itemsInCart: 0,
        hasUnsavedWork: false
    }

    ; Simulate different contexts
    ShowContextualMessage("login")
    Sleep 1000

    AppState.isLoggedIn := true
    AppState.userName := "John Doe"
    ShowContextualMessage("welcome")
    Sleep 1000

    AppState.itemsInCart := 5
    ShowContextualMessage("checkout")
    Sleep 1000

    AppState.hasUnsavedWork := true
    ShowContextualMessage("exit")
}

/**
 * Shows appropriate message based on context.
 */
ShowContextualMessage(context) {
    global AppState

    Switch context {
        Case "login":
            if (!AppState.isLoggedIn) {
                MsgBox "Please log in to continue.",
                    "Authentication Required",
                    "Iconi"
            }

        Case "welcome":
            if (AppState.isLoggedIn) {
                MsgBox Format("Welcome back, {1}!`n`nYou have {2} items in your cart.",
                    AppState.userName,
                    AppState.itemsInCart),
                    "Welcome",
                    "Iconi"
            }

        Case "checkout":
            if (AppState.itemsInCart > 0) {
                response := MsgBox(Format("You have {1} items in your cart.`n`nProceed to checkout?",
                    AppState.itemsInCart),
                    "Checkout",
                    "YesNo Icon?")

                if (response = "Yes")
                    MsgBox "Proceeding to checkout...",
                        "Checkout",
                        "Iconi"
            } else {
                MsgBox "Your cart is empty.`n`nAdd items before checking out.",
                    "Empty Cart",
                    "Icon!"
            }

        Case "exit":
            if (AppState.hasUnsavedWork) {
                response := MsgBox(Format("You have unsaved work, {1}.`n`nSave before exiting?",
                    AppState.userName),
                    "Unsaved Work",
                    "YesNoCancel Icon!")

                Switch response {
                    Case "Yes":
                        MsgBox "Saving work...",
                        "Saving",
                        "Iconi"
                    Case "No":
                        MsgBox "Exiting without saving...",
                        "Exiting",
                        "Iconi"
                    Case "Cancel":
                        MsgBox "Exit cancelled.",
                        "Cancelled",
                        "Iconi"
                }
            }
    }
}

; ============================================================================
; EXAMPLE 7: Progress Feedback Without GUI
; ============================================================================
/**
 * Uses MsgBox for simple progress notifications.
 * 
 * @description Shows how to provide progress feedback using sequential
 *              MsgBox calls for simple operations.
 */
Example7_ProgressFeedback() {
    totalSteps := 5
    currentStep := 0

    ; Step 1
    currentStep++
    ShowProgress(currentStep, totalSteps, "Initializing...")
    Sleep 1000

    ; Step 2
    currentStep++
    ShowProgress(currentStep, totalSteps, "Loading configuration...")
    Sleep 1000

    ; Step 3
    currentStep++
    ShowProgress(currentStep, totalSteps, "Connecting to server...")
    Sleep 1000

    ; Step 4
    currentStep++
    ShowProgress(currentStep, totalSteps, "Downloading updates...")
    Sleep 1000

    ; Step 5
    currentStep++
    ShowProgress(currentStep, totalSteps, "Finalizing...")
    Sleep 1000

    ; Complete
    MsgBox "Process completed successfully!",
        "Complete",
        "Iconi"
}

/**
 * Shows progress message.
 */
ShowProgress(current, total, message) {
    percentage := Round((current / total) * 100)
    progressBar := ""

    Loop percentage / 5
        progressBar .= "█"

    Loop (100 - percentage) / 5
        progressBar .= "░"

    MsgBox Format("Progress: {1}%`n`n{2}`n`n{3}`n`nStep {4} of {5}",
        percentage,
        progressBar,
        message,
        current,
        total),
        "Processing",
        "Iconi T1"
}

; ============================================================================
; Hotkey Triggers
; ============================================================================

^1:: Example1_TimeoutMessages()
^2:: Example2_WizardPattern()
^3:: Example3_ValidationFeedback()
^4:: Example4_ErrorHandlingPatterns()
^5:: Example5_SafeConfirmations()
^6:: Example6_ContextAwareMessages()
^7:: Example7_ProgressFeedback()
^0:: ExitApp

/**
 * ============================================================================
 * SUMMARY
 * ============================================================================
 * 
 * Advanced MsgBox patterns covered:
 * 1. Timeout messages for auto-dismissing notifications
 * 2. Multi-step wizard patterns for guided workflows
 * 3. Input validation feedback with retry logic
 * 4. Comprehensive error handling (critical, recoverable, warnings)
 * 5. Safe confirmation patterns for destructive actions
 * 6. Context-aware messaging based on application state
 * 7. Simple progress feedback using sequential MsgBox calls
 * 
 * ============================================================================
 */

