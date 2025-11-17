#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Array.Push() - Data Collection Patterns
 * ============================================================================
 *
 * This file demonstrates how to use Push() for collecting various types of
 * data from user input, system information, and external sources.
 *
 * @description Data collection techniques using Array.Push()
 * @author AutoHotkey v2 Documentation
 * @version 1.0.0
 * @date 2025-01-16
 */

; ============================================================================
; Example 1: Collecting Window Information
; ============================================================================
; Gather data about open windows
Example1_WindowDataCollection() {
    OutputDebug("=== Example 1: Window Data Collection ===`n")

    ; Collect all visible windows
    visibleWindows := []

    ; Get list of window IDs
    windowList := WinGetList()

    for hwnd in windowList {
        try {
            title := WinGetTitle("ahk_id " hwnd)

            ; Skip windows without titles
            if (StrLen(title) = 0) {
                continue
            }

            ; Skip hidden windows
            if (!WinExist("ahk_id " hwnd)) {
                continue
            }

            windowInfo := {
                hwnd: hwnd,
                title: title,
                class: WinGetClass("ahk_id " hwnd),
                process: WinGetProcessName("ahk_id " hwnd),
                pid: WinGetPID("ahk_id " hwnd)
            }

            visibleWindows.Push(windowInfo)
        } catch {
            ; Skip windows that cause errors
            continue
        }
    }

    OutputDebug("Collected " visibleWindows.Length " visible windows`n")

    ; Display first 5 windows
    count := Min(5, visibleWindows.Length)
    OutputDebug("First " count " windows:`n")
    Loop count {
        win := visibleWindows[A_Index]
        OutputDebug("  [" A_Index "] " win.title " (" win.process ")`n")
    }

    ; Collect windows by specific criteria
    notepadWindows := []
    for win in visibleWindows {
        if (InStr(win.process, "notepad")) {
            notepadWindows.Push(win)
        }
    }

    OutputDebug("`nNotepad windows found: " notepadWindows.Length "`n")
    OutputDebug("`n")
}

; ============================================================================
; Example 2: Collecting System Information
; ============================================================================
; Gather various system metrics and information
Example2_SystemInfoCollection() {
    OutputDebug("=== Example 2: System Information Collection ===`n")

    ; Collect screen information
    screenInfo := []

    monitorCount := SysGet(80)  ; SM_CMONITORS
    Loop monitorCount {
        monitor := {
            index: A_Index,
            primary: (A_Index = 1),
            width: SysGet(78),   ; SM_CXVIRTUALSCREEN
            height: SysGet(79)   ; SM_CYVIRTUALSCREEN
        }
        screenInfo.Push(monitor)
    }

    OutputDebug("Monitors detected: " screenInfo.Length "`n")

    ; Collect environment variables
    envVars := []
    importantVars := ["COMPUTERNAME", "USERNAME", "USERPROFILE",
                      "TEMP", "OS", "PROCESSOR_ARCHITECTURE"]

    for varName in importantVars {
        value := EnvGet(varName)
        if (value != "") {
            envVars.Push({
                name: varName,
                value: value
            })
        }
    }

    OutputDebug("Environment variables collected: " envVars.Length "`n")
    for envVar in envVars {
        OutputDebug("  " envVar.name ": " envVar.value "`n")
    }

    ; Collect drive information
    driveInfo := []

    drives := DriveGetList()
    for drive in StrSplit(drives) {
        if (drive = "") {
            continue
        }

        driveData := {
            letter: drive,
            type: DriveGetType(drive ":"),
            label: "",
            capacity: 0,
            free: 0
        }

        try {
            driveData.label := DriveGetLabel(drive ":")
            driveData.capacity := DriveGetCapacity(drive ":")
            driveData.free := DriveGetSpaceFree(drive ":")
        }

        driveInfo.Push(driveData)
    }

    OutputDebug("`nDrives found: " driveInfo.Length "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 3: Collecting User Input Events
; ============================================================================
; Track and collect user interaction events
Example3_UserEventCollection() {
    OutputDebug("=== Example 3: User Event Collection ===`n")

    ; Simulated event collector
    global eventLog := []

    ; Add sample events
    LogEvent("Application Started", "System")
    Sleep(10)
    LogEvent("User clicked button", "UI")
    Sleep(10)
    LogEvent("Form submitted", "Form")
    Sleep(10)
    LogEvent("Data saved", "Database")
    Sleep(10)
    LogEvent("Email sent", "Notification")

    OutputDebug("Total events logged: " eventLog.Length "`n")

    ; Display events
    for event in eventLog {
        OutputDebug("  [" event.timestamp "] " event.category ": " event.message "`n")
    }

    ; Filter events by category
    uiEvents := []
    for event in eventLog {
        if (event.category = "UI") {
            uiEvents.Push(event)
        }
    }

    OutputDebug("`nUI events: " uiEvents.Length "`n")

    ; Collect keystroke pattern (simulated)
    keystrokes := []
    simulatedKeys := ["H", "e", "l", "l", "o"]

    for key in simulatedKeys {
        keystrokes.Push({
            key: key,
            timestamp: A_TickCount,
            modifier: ""
        })
    }

    OutputDebug("Keystroke pattern collected: " keystrokes.Length " keys`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 4: Collecting Form Data
; ============================================================================
; Simulate collecting data from GUI forms
Example4_FormDataCollection() {
    OutputDebug("=== Example 4: Form Data Collection ===`n")

    ; Simulate multi-step form data collection
    formData := []

    ; Step 1: Personal Information
    step1Data := {
        step: 1,
        stepName: "Personal Information",
        fields: []
    }
    step1Data.fields.Push({name: "firstName", value: "John", valid: true})
    step1Data.fields.Push({name: "lastName", value: "Doe", valid: true})
    step1Data.fields.Push({name: "email", value: "john@example.com", valid: true})
    formData.Push(step1Data)

    ; Step 2: Address Information
    step2Data := {
        step: 2,
        stepName: "Address",
        fields: []
    }
    step2Data.fields.Push({name: "street", value: "123 Main St", valid: true})
    step2Data.fields.Push({name: "city", value: "Springfield", valid: true})
    step2Data.fields.Push({name: "zip", value: "12345", valid: true})
    formData.Push(step2Data)

    ; Step 3: Preferences
    step3Data := {
        step: 3,
        stepName: "Preferences",
        fields: []
    }
    step3Data.fields.Push({name: "newsletter", value: true, valid: true})
    step3Data.fields.Push({name: "notifications", value: false, valid: true})
    formData.Push(step3Data)

    OutputDebug("Form steps collected: " formData.Length "`n")

    for stepData in formData {
        OutputDebug("  Step " stepData.step ": " stepData.stepName
                    " (" stepData.fields.Length " fields)`n")
    }

    ; Collect validation errors
    validationErrors := []

    ; Simulate validation
    if (!ValidateEmail("invalid-email")) {
        validationErrors.Push({
            step: 1,
            field: "email",
            message: "Invalid email format"
        })
    }

    if (!ValidateZip("ABCDE")) {
        validationErrors.Push({
            step: 2,
            field: "zip",
            message: "Invalid ZIP code"
        })
    }

    OutputDebug("`nValidation errors: " validationErrors.Length "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 5: Collecting Time-Series Data
; ============================================================================
; Collect data points over time
Example5_TimeSeriesCollection() {
    OutputDebug("=== Example 5: Time-Series Data Collection ===`n")

    ; Collect simulated CPU usage over time
    cpuReadings := []

    Loop 10 {
        reading := {
            timestamp: A_Now,
            tickCount: A_TickCount,
            value: Random(20, 80),  ; Simulated CPU %
            index: A_Index
        }
        cpuReadings.Push(reading)
    }

    OutputDebug("CPU readings collected: " cpuReadings.Length "`n")

    ; Calculate average
    total := 0
    for reading in cpuReadings {
        total += reading.value
    }
    average := Round(total / cpuReadings.Length, 2)

    OutputDebug("Average CPU usage: " average "%`n")

    ; Collect readings above threshold
    highUsage := []
    threshold := 50

    for reading in cpuReadings {
        if (reading.value > threshold) {
            highUsage.Push(reading)
        }
    }

    OutputDebug("High usage readings (>" threshold "%): " highUsage.Length "`n")

    ; Collect memory snapshots
    memorySnapshots := []

    Loop 5 {
        snapshot := {
            timestamp: A_Now,
            processCount: ProcessGetList().Length,
            activeWindow: WinGetTitle("A")
        }
        memorySnapshots.Push(snapshot)
    }

    OutputDebug("Memory snapshots: " memorySnapshots.Length "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 6: Collecting Error and Debug Information
; ============================================================================
; Build error logs and debug traces
Example6_ErrorDataCollection() {
    OutputDebug("=== Example 6: Error Data Collection ===`n")

    ; Error log collector
    errorLog := []

    ; Simulate various errors
    RecordError(errorLog, "Error", "File not found", "FileSystem", 404)
    RecordError(errorLog, "Warning", "Deprecated function used", "Code", 200)
    RecordError(errorLog, "Error", "Network timeout", "Network", 500)
    RecordError(errorLog, "Info", "Operation completed", "System", 0)
    RecordError(errorLog, "Critical", "Database connection failed", "Database", 503)

    OutputDebug("Total log entries: " errorLog.Length "`n")

    ; Categorize errors by severity
    criticalErrors := []
    warnings := []

    for entry in errorLog {
        if (entry.severity = "Critical" || entry.severity = "Error") {
            criticalErrors.Push(entry)
        } else if (entry.severity = "Warning") {
            warnings.Push(entry)
        }
    }

    OutputDebug("Critical/Error entries: " criticalErrors.Length "`n")
    OutputDebug("Warning entries: " warnings.Length "`n")

    ; Debug trace collector
    debugTrace := []

    SimulateFunction1(debugTrace)
    SimulateFunction2(debugTrace)

    OutputDebug("`nDebug trace entries: " debugTrace.Length "`n")
    for trace in debugTrace {
        OutputDebug("  " trace.function "() at line " trace.line "`n")
    }

    ; Exception collector
    exceptions := []

    ; Simulate catching exceptions
    try {
        throw Error("Simulated error 1")
    } catch as err {
        exceptions.Push({
            message: err.Message,
            what: err.What,
            timestamp: A_Now
        })
    }

    try {
        throw ValueError("Invalid value provided")
    } catch as err {
        exceptions.Push({
            message: err.Message,
            what: err.What,
            timestamp: A_Now
        })
    }

    OutputDebug("`nExceptions caught: " exceptions.Length "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 7: Collecting Configuration Data
; ============================================================================
; Build configuration sets from various sources
Example7_ConfigurationCollection() {
    OutputDebug("=== Example 7: Configuration Collection ===`n")

    ; Collect application settings
    appSettings := []

    appSettings.Push({key: "theme", value: "dark", type: "string"})
    appSettings.Push({key: "autoSave", value: true, type: "boolean"})
    appSettings.Push({key: "fontSize", value: 14, type: "number"})
    appSettings.Push({key: "language", value: "en-US", type: "string"})
    appSettings.Push({key: "maxRecentFiles", value: 10, type: "number"})

    OutputDebug("Application settings: " appSettings.Length "`n")

    ; Collect user preferences
    userPrefs := []

    preferences := Map(
        "notifications", true,
        "soundEnabled", false,
        "animationsEnabled", true,
        "autoUpdate", true
    )

    for prefName, prefValue in preferences {
        userPrefs.Push({
            name: prefName,
            value: prefValue,
            source: "user"
        })
    }

    OutputDebug("User preferences: " userPrefs.Length "`n")

    ; Collect default configurations
    defaults := []

    defaultConfigs := [
        {section: "Display", key: "resolution", value: "1920x1080"},
        {section: "Display", key: "fullscreen", value: false},
        {section: "Audio", key: "volume", value: 75},
        {section: "Audio", key: "muted", value: false},
        {section: "Network", key: "timeout", value: 30000}
    ]

    for config in defaultConfigs {
        defaults.Push(config)
    }

    OutputDebug("Default configurations: " defaults.Length "`n")

    ; Collect changed settings (compared to defaults)
    changedSettings := []

    ; Simulate some changes
    changedSettings.Push({
        key: "theme",
        oldValue: "light",
        newValue: "dark",
        changedAt: A_Now
    })

    changedSettings.Push({
        key: "fontSize",
        oldValue: 12,
        newValue: 14,
        changedAt: A_Now
    })

    OutputDebug("Changed settings: " changedSettings.Length "`n")

    OutputDebug("`n")
}

; ============================================================================
; Helper Functions
; ============================================================================

/**
 * Logs an event to the global event log
 * @param {String} message - The event message
 * @param {String} category - The event category
 */
LogEvent(message, category) {
    global eventLog

    event := {
        timestamp: A_Now,
        message: message,
        category: category
    }

    eventLog.Push(event)
}

/**
 * Records an error to the error log
 * @param {Array} log - The error log array
 * @param {String} severity - Error severity level
 * @param {String} message - Error message
 * @param {String} component - Component where error occurred
 * @param {Integer} code - Error code
 */
RecordError(log, severity, message, component, code) {
    error := {
        timestamp: A_Now,
        severity: severity,
        message: message,
        component: component,
        code: code
    }

    log.Push(error)
}

/**
 * Simulates function execution for debug tracing
 */
SimulateFunction1(trace) {
    trace.Push({
        function: "SimulateFunction1",
        line: 100,
        timestamp: A_TickCount
    })
}

SimulateFunction2(trace) {
    trace.Push({
        function: "SimulateFunction2",
        line: 200,
        timestamp: A_TickCount
    })
}

/**
 * Validates email format
 * @param {String} email - Email to validate
 * @returns {Boolean} True if valid
 */
ValidateEmail(email) {
    return RegExMatch(email, "^[\w\.-]+@[\w\.-]+\.\w+$")
}

/**
 * Validates ZIP code
 * @param {String} zip - ZIP code to validate
 * @returns {Boolean} True if valid
 */
ValidateZip(zip) {
    return RegExMatch(zip, "^\d{5}$")
}

; ============================================================================
; Main Execution
; ============================================================================

Main() {
    ; Clear debug output
    OutputDebug("`n" String.Repeat("=", 80) "`n")
    OutputDebug("Array.Push() - Data Collection Examples`n")
    OutputDebug(String.Repeat("=", 80) "`n`n")

    ; Run all examples
    Example1_WindowDataCollection()
    Example2_SystemInfoCollection()
    Example3_UserEventCollection()
    Example4_FormDataCollection()
    Example5_TimeSeriesCollection()
    Example6_ErrorDataCollection()
    Example7_ConfigurationCollection()

    OutputDebug(String.Repeat("=", 80) "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(String.Repeat("=", 80) "`n")

    MsgBox("Array.Push() data collection examples completed!`nCheck DebugView for output.",
           "Examples Complete", "Icon!")
}

; Run the examples
Main()
