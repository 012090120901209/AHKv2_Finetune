#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Hotkey() Function - Basic Hotkey Creation Examples
 * ============================================================================
 * 
 * This file demonstrates the fundamental usage of the Hotkey() function in
 * AutoHotkey v2 for creating and managing keyboard shortcuts dynamically.
 * 
 * The Hotkey() function allows you to:
 * - Create hotkeys programmatically
 * - Modify existing hotkey behavior
 * - Enable/disable hotkeys at runtime
 * - Check hotkey existence and properties
 * 
 * @author AutoHotkey v2 Documentation Team
 * @version 1.0.0
 * @see https://www.autohotkey.com/docs/v2/lib/Hotkey.htm
 */

; ============================================================================
; Example 1: Basic Hotkey Creation
; ============================================================================

/**
 * Demonstrates creating basic hotkeys using the Hotkey() function.
 * These hotkeys perform simple actions like showing message boxes.
 * 
 * @example
 * ; Press Ctrl+1 to show a greeting message
 * ; Press Ctrl+2 to show the current time
 * ; Press Ctrl+3 to show system information
 */
Example1_BasicHotkeys() {
    ; Create a hotkey that shows a greeting message
    Hotkey("^1", (*) => MsgBox("Hello! You pressed Ctrl+1", "Greeting"))

    ; Create a hotkey that shows the current time
    Hotkey("^2", ShowCurrentTime)

    ; Create a hotkey that shows system information
    Hotkey("^3", (*) => MsgBox(
        "Computer Name: " A_ComputerName "`n"
        "User Name: " A_UserName "`n"
        "OS Version: " A_OSVersion,
        "System Information"
    ))

    MsgBox(
        "Basic hotkeys created:`n`n"
        "Ctrl+1 - Show greeting`n"
        "Ctrl+2 - Show current time`n"
        "Ctrl+3 - Show system info`n`n"
        "Press any hotkey to test!",
        "Example 1: Basic Hotkeys"
    )
}

ShowCurrentTime(*) {
    currentTime := FormatTime(, "hh:mm:ss tt")
    currentDate := FormatTime(, "dddd, MMMM d, yyyy")
    MsgBox(
        "Current Time: " currentTime "`n"
        "Current Date: " currentDate,
        "Time and Date"
    )
}

; ============================================================================
; Example 2: Hotkey Creation with Different Modifiers
; ============================================================================

/**
 * Shows how to create hotkeys with various modifier key combinations.
 * Modifiers include Ctrl (^), Alt (!), Shift (+), and Win (#).
 * 
 * @example
 * ; Different modifier combinations for the same base key
 */
Example2_ModifierCombinations() {
    ; Ctrl+Alt+Q - Quick note
    Hotkey("^!q", (*) => MsgBox("Quick note hotkey activated!", "Ctrl+Alt+Q"))

    ; Shift+Alt+Q - Quick search
    Hotkey("+!q", (*) => MsgBox("Quick search hotkey activated!", "Shift+Alt+Q"))

    ; Ctrl+Shift+Q - Quick save
    Hotkey("^+q", (*) => MsgBox("Quick save hotkey activated!", "Ctrl+Shift+Q"))

    ; Win+Q - Quick launcher
    Hotkey("#q", (*) => MsgBox("Quick launcher activated!", "Win+Q"))

    ; Ctrl+Alt+Shift+Q - All modifiers
    Hotkey("^!+q", (*) => MsgBox("All modifiers activated!", "Ctrl+Alt+Shift+Q"))

    MsgBox(
        "Modifier combination hotkeys created:`n`n"
        "Ctrl+Alt+Q - Quick note`n"
        "Shift+Alt+Q - Quick search`n"
        "Ctrl+Shift+Q - Quick save`n"
        "Win+Q - Quick launcher`n"
        "Ctrl+Alt+Shift+Q - All modifiers",
        "Example 2: Modifier Combinations"
    )
}

; ============================================================================
; Example 3: Creating Hotkeys with Parameters
; ============================================================================

/**
 * Demonstrates creating hotkeys that execute functions with parameters.
 * Uses closures to capture parameter values.
 * 
 * @example
 * ; Create number pad hotkeys that insert formatted text
 */
Example3_ParameterizedHotkeys() {
    ; Create a closure-based hotkey factory
    CreateTextInserter(key, text) {
        Hotkey(key, (*) => SendText(text))
    }

    ; Create multiple hotkeys with different text
    CreateTextInserter("^Numpad1", "First item")
    CreateTextInserter("^Numpad2", "Second item")
    CreateTextInserter("^Numpad3", "Third item")

    ; More complex example with formatting
    CreateFormattedInserter(key, template) {
        Hotkey(key, (*) {
            timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
            formatted := StrReplace(template, "{time}", timestamp)
            formatted := StrReplace(formatted, "{user}", A_UserName)
            SendText(formatted)
        })
    }

    CreateFormattedInserter("^Numpad4", "[{time}] Log entry by {user}: ")
    CreateFormattedInserter("^Numpad5", "Comment by {user} at {time}: ")

    MsgBox(
        "Parameterized hotkeys created:`n`n"
        "Ctrl+Numpad1 - Insert 'First item'`n"
        "Ctrl+Numpad2 - Insert 'Second item'`n"
        "Ctrl+Numpad3 - Insert 'Third item'`n"
        "Ctrl+Numpad4 - Insert timestamped log entry`n"
        "Ctrl+Numpad5 - Insert timestamped comment`n`n"
        "Click in a text editor and test!",
        "Example 3: Parameterized Hotkeys"
    )
}

; ============================================================================
; Example 4: Dynamic Hotkey Registration System
; ============================================================================

/**
 * Creates a system for registering and managing hotkeys dynamically.
 * Includes a registry to track all created hotkeys.
 * 
 * @example
 * ; Register multiple hotkeys and display them in a list
 */
Example4_HotkeyRegistry() {
    ; Global registry to track hotkeys
    global hotkeyRegistry := Map()

    /**
     * Registers a hotkey with description
     * @param {string} keys - The key combination
     * @param {function} callback - The function to call
     * @param {string} description - Description of the hotkey
     */
    RegisterHotkey(keys, callback, description := "") {
        global hotkeyRegistry
        Hotkey(keys, callback)
        hotkeyRegistry[keys] := {
            callback: callback,
            description: description,
            created: A_Now
        }
    }

    /**
     * Lists all registered hotkeys
     */
    ListRegisteredHotkeys() {
        global hotkeyRegistry
        list := "Registered Hotkeys:`n" . String(Repeat("-", 50)) . "`n"

        for keys, info in hotkeyRegistry {
            desc := info.description != "" ? info.description : "No description"
            list .= keys . " - " . desc . "`n"
        }

        MsgBox(list, "Hotkey Registry")
    }

    String(obj) {
        return obj
    }

    Repeat(char, count) {
        result := ""
        Loop count
            result .= char
        return result
    }

    ; Register several hotkeys
    RegisterHotkey("^!h", ListRegisteredHotkeys, "Show this hotkey list")
    RegisterHotkey("^!t", (*) => MsgBox(FormatTime()), "Show current time")
    RegisterHotkey("^!c", (*) => MsgBox(A_Clipboard), "Show clipboard content")
    RegisterHotkey("^!r", (*) => Reload(), "Reload the script")

    ; Show initial list
    ListRegisteredHotkeys()
}

; ============================================================================
; Example 5: Hotkey Creation with Error Handling
; ============================================================================

/**
 * Demonstrates proper error handling when creating hotkeys.
 * Handles invalid key names and duplicate registrations.
 * 
 * @example
 * ; Safely create hotkeys with validation
 */
Example5_ErrorHandling() {
    /**
     * Safely creates a hotkey with error handling
     * @param {string} keys - The key combination
     * @param {function} callback - The function to call
     * @returns {boolean} - Success status
     */
    SafeCreateHotkey(keys, callback) {
        try {
            Hotkey(keys, callback)
            return true
        } catch Error as err {
            MsgBox(
                "Failed to create hotkey: " keys "`n`n"
                "Error: " err.Message,
                "Hotkey Creation Error"
            )
            return false
        }
    }

    ; Create valid hotkeys
    result1 := SafeCreateHotkey("^!F1", (*) => MsgBox("F1 hotkey works!"))
    result2 := SafeCreateHotkey("^!F2", (*) => MsgBox("F2 hotkey works!"))

    ; Try to create an invalid hotkey (invalid key name)
    result3 := SafeCreateHotkey("^!InvalidKey", (*) => MsgBox("This won't work"))

    ; Create a duplicate hotkey (this will replace the previous one)
    SafeCreateHotkey("^!F1", (*) => MsgBox("F1 hotkey replaced!"))

    status := "Hotkey creation results:`n`n"
    status .= "^!F1: " . (result1 ? "Success" : "Failed") . "`n"
    status .= "^!F2: " . (result2 ? "Success" : "Failed") . "`n"
    status .= "^!InvalidKey: " . (result3 ? "Success" : "Failed") . "`n"
    status .= "`nNote: ^!F1 was replaced with a new action"

    MsgBox(status, "Example 5: Error Handling")
}

; ============================================================================
; Example 6: Conditional Hotkey Creation
; ============================================================================

/**
 * Shows how to conditionally create hotkeys based on system state
 * or configuration settings.
 * 
 * @example
 * ; Create different hotkeys based on user preferences
 */
Example6_ConditionalCreation() {
    ; Configuration object
    config := {
        enableDevMode: true,
        enableTextShortcuts: true,
        enableWindowControls: false
    }

    ; Create development hotkeys if dev mode is enabled
    if (config.enableDevMode) {
        Hotkey("^!d", (*) => MsgBox("Developer mode active", "Dev Mode"))
        Hotkey("^!r", (*) => Reload())
        Hotkey("^!e", (*) => Edit())
    }

    ; Create text shortcuts if enabled
    if (config.enableTextShortcuts) {
        Hotkey("^!;", (*) => SendText("Dear Sir/Madam,`n`n"))
        Hotkey("^!'", (*) => SendText("Best regards,`n" . A_UserName))
    }

    ; Create window control hotkeys if enabled
    if (config.enableWindowControls) {
        Hotkey("^!Up", (*) => WinMaximize("A"))
        Hotkey("^!Down", (*) => WinMinimize("A"))
    }

    ; Build status message
    status := "Hotkeys created based on configuration:`n`n"
    status .= "Dev Mode: " . (config.enableDevMode ? "Enabled" : "Disabled") . "`n"
    status .= "Text Shortcuts: " . (config.enableTextShortcuts ? "Enabled" : "Disabled") . "`n"
    status .= "Window Controls: " . (config.enableWindowControls ? "Enabled" : "Disabled") . "`n"

    if (config.enableDevMode) {
        status .= "`nDev hotkeys: Ctrl+Alt+D, Ctrl+Alt+R, Ctrl+Alt+E"
    }
    if (config.enableTextShortcuts) {
        status .= "`nText hotkeys: Ctrl+Alt+;, Ctrl+Alt+'"
    }

    MsgBox(status, "Example 6: Conditional Creation")
}

; ============================================================================
; Example 7: Hotkey Creation from Configuration File
; ============================================================================

/**
 * Demonstrates loading hotkey definitions from a data structure
 * and creating them dynamically. Simulates reading from a config file.
 * 
 * @example
 * ; Load and create hotkeys from configuration
 */
Example7_ConfigurationBased() {
    ; Simulate configuration loaded from file (in real use, load from JSON/INI)
    hotkeyConfig := [{
        key: "^!n", action: "NewDocument", desc: "Create new document" }, {
            key: "^!o", action: "OpenDocument", desc: "Open document" }, {
                key: "^!s", action: "SaveDocument", desc: "Save document" }, {
                    key: "^!p", action: "PrintDocument", desc: "Print document" }, {
                        key: "^!q", action: "Quit", desc: "Quit application"
                    }
    ]

    ; Action handlers
    actions := Map(
        "NewDocument", (*) => MsgBox("Creating new document...", "New"),
        "OpenDocument", (*) => MsgBox("Opening document...", "Open"),
        "SaveDocument", (*) => MsgBox("Saving document...", "Save"),
        "PrintDocument", (*) => MsgBox("Printing document...", "Print"),
        "Quit", (*) => MsgBox("Quitting application...", "Quit")
    )

    ; Create hotkeys from configuration
    createdCount := 0
    configList := "Created hotkeys from configuration:`n`n"

    for item in hotkeyConfig {
        if actions.Has(item.action) {
            Hotkey(item.key, actions[item.action])
            configList .= item.key . " - " . item.desc . "`n"
            createdCount++
        }
    }

    configList .= "`nTotal hotkeys created: " . createdCount

    MsgBox(configList, "Example 7: Configuration-Based Hotkeys")
}

; ============================================================================
; Main Execution
; ============================================================================

/**
 * Main menu to run examples
 */
ShowExampleMenu() {
    menu := "
                    (
                    AutoHotkey v2 - Hotkey() Basic Creation Examples
                    ================================================

                    Choose an example to run:

                    1. Basic Hotkey Creation
                    2. Modifier Combinations
                    3. Parameterized Hotkeys
                    4. Hotkey Registry System
                    5. Error Handling
                    6. Conditional Creation
                    7. Configuration-Based Creation

                    Press 1-7 to run an example, or ESC to exit.
                    )"

    choice := MsgBox(menu, "Hotkey Examples Menu", "T60")
}

; Run the menu
ShowExampleMenu()

; Create hotkeys to run examples
Hotkey("^!1", (*) => Example1_BasicHotkeys())
Hotkey("^!2", (*) => Example2_ModifierCombinations())
Hotkey("^!3", (*) => Example3_ParameterizedHotkeys())
Hotkey("^!4", (*) => Example4_HotkeyRegistry())
Hotkey("^!5", (*) => Example5_ErrorHandling())
Hotkey("^!6", (*) => Example6_ConditionalCreation())
Hotkey("^!7", (*) => Example7_ConfigurationBased())

; Show instructions
MsgBox(
    "Example hotkeys ready!`n`n"
    "Press Ctrl+Alt+[1-7] to run each example`n`n"
    "Each example will create its own set of hotkeys`n"
    "and explain what they do.",
    "Ready"
)
