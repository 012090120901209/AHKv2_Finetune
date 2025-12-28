#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 INI Read Examples - Part 2
 * ============================================================================
 * 
 * Advanced INI reading scenarios including validation, templates,
 * and configuration merging.
 * 
 * @description Advanced INI file reading techniques
 * @author AHK v2 Examples Collection
 * @version 1.0.0
 * @date 2024-01-15
 */

; ============================================================================
; EXAMPLE 1: INI Configuration Validator
; ============================================================================

/**
 * @class IniValidator
 * @description Validates INI configuration against rules
 */
class IniValidator {
    iniFile := ""
    rules := Map()
    errors := []

    __New(iniFile) {
        this.iniFile := iniFile
    }

    AddRule(section, key, type, required := true, defaultValue := "") {
        if (!this.rules.Has(section))
            this.rules[section] := Map()

        this.rules[section][key] := Map(
            "type", type,
            "required", required,
            "default", defaultValue
        )
    }

    Validate() {
        this.errors := []
        valid := true

        for section, keys in this.rules {
            for key, rule in keys {
                value := IniRead(this.iniFile, section, key, "***MISSING***")

                if (value = "***MISSING***") {
                    if (rule["required"]) {
                        this.errors.Push("Missing required key: [" . section . "] " . key)
                        valid := false
                    }
                    continue
                }

                ; Validate type
                switch rule["type"] {
                    case "integer":
                        if (!IsInteger(value)) {
                            this.errors.Push("Invalid integer: [" . section . "] " . key)
                            valid := false
                        }
                    case "boolean":
                        if (value != "true" && value != "false" && value != "1" && value != "0") {
                            this.errors.Push("Invalid boolean: [" . section . "] " . key)
                            valid := false
                        }
                }
            }
        }

        return valid
    }

    GetErrors() {
        return this.errors
    }
}

Example1_ValidationDemo() {
    MsgBox "=== Example 1: Configuration Validation ===`n`n" .
        "Validating INI file structure..."

    iniFile := A_ScriptDir . "\validate_config.ini"

    try {
        FileDelete iniFile
    }

    IniWrite "App", iniFile, "Application", "Name"
    IniWrite "abc", iniFile, "Window", "Width"  ; Invalid - should be integer

    validator := IniValidator(iniFile)
    validator.AddRule("Application", "Name", "string", true)
    validator.AddRule("Application", "Version", "string", true)  ; Missing
    validator.AddRule("Window", "Width", "integer", true)

    if (validator.Validate()) {
        MsgBox "Configuration is valid!", "Validation Success"
    } else {
        errors := validator.GetErrors()
        errorMsg := "Validation Errors:`n━━━━━━━━━━━━━━━━━━`n`n"
        for error in errors {
            errorMsg .= "• " . error . "`n"
        }
        MsgBox errorMsg, "Validation Failed"
    }
}

; ============================================================================
; EXAMPLE 2: Configuration Inheritance
; ============================================================================

Example2_ConfigInheritance() {
    MsgBox "=== Example 2: Configuration Inheritance ===`n`n" .
        "Using base and override configurations..."

    baseIni := A_ScriptDir . "\base_config.ini"
    overrideIni := A_ScriptDir . "\override_config.ini"

    try {
        FileDelete baseIni
        FileDelete overrideIni
    }

    ; Base configuration
    IniWrite "Production", baseIni, "Application", "Environment"
    IniWrite "false", baseIni, "Debug", "Enabled"
    IniWrite "30", baseIni, "Cache", "TTL"

    ; Override configuration
    IniWrite "Development", overrideIni, "Application", "Environment"
    IniWrite "true", overrideIni, "Debug", "Enabled"

    ; Read with inheritance (override takes precedence)
    env := IniRead(overrideIni, "Application", "Environment", IniRead(baseIni, "Application", "Environment"))
    debug := IniRead(overrideIni, "Debug", "Enabled", IniRead(baseIni, "Debug", "Enabled"))
    ttl := IniRead(overrideIni, "Cache", "TTL", IniRead(baseIni, "Cache", "TTL"))

    result := "Configuration with Inheritance:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Environment: " . env . " (from override)`n"
    result .= "Debug: " . debug . " (from override)`n"
    result .= "Cache TTL: " . ttl . " (from base)`n"

    MsgBox result, "Inheritance Example"
}

; ============================================================================
; EXAMPLE 3: Environment-Specific Configuration
; ============================================================================

Example3_EnvironmentConfig() {
    MsgBox "=== Example 3: Environment-Specific Config ===`n`n" .
        "Reading environment-specific settings..."

    iniFile := A_ScriptDir . "\env_config.ini"

    try {
        FileDelete iniFile
    }

    ; Development environment
    IniWrite "localhost", iniFile, "Development.Database", "Host"
    IniWrite "5432", iniFile, "Development.Database", "Port"
    IniWrite "true", iniFile, "Development.Logging", "Verbose"

    ; Production environment
    IniWrite "prod-db.example.com", iniFile, "Production.Database", "Host"
    IniWrite "5432", iniFile, "Production.Database", "Port"
    IniWrite "false", iniFile, "Production.Logging", "Verbose"

    ; Select environment
    currentEnv := "Development"

    ; Read environment-specific config
    dbHost := IniRead(iniFile, currentEnv . ".Database", "Host")
    dbPort := IniRead(iniFile, currentEnv . ".Database", "Port")
    verbose := IniRead(iniFile, currentEnv . ".Logging", "Verbose")

    result := "Environment: " . currentEnv . "`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Database Host: " . dbHost . "`n"
    result .= "Database Port: " . dbPort . "`n"
    result .= "Verbose Logging: " . verbose . "`n"

    MsgBox result, "Environment Config"
}

; ============================================================================
; EXAMPLE 4: Configuration Templates
; ============================================================================

Example4_ConfigTemplates() {
    MsgBox "=== Example 4: Configuration Templates ===`n`n" .
        "Using configuration templates..."

    templateIni := A_ScriptDir . "\template_config.ini"

    try {
        FileDelete templateIni
    }

    ; Create template
    IniWrite "${APP_NAME}", templateIni, "Application", "Name"
    IniWrite "${APP_VERSION}", templateIni, "Application", "Version"
    IniWrite "${DB_HOST}", templateIni, "Database", "Host"
    IniWrite "${DB_PORT}", templateIni, "Database", "Port"

    ; Read and substitute
    substitutions := Map(
        "${APP_NAME}", "MyApplication",
        "${APP_VERSION}", "1.0.0",
        "${DB_HOST}", "localhost",
        "${DB_PORT}", "5432"
    )

    config := Map()
    sections := ["Application", "Database"]

    for section in sections {
        keys := IniRead(templateIni, section)
        keyList := StrSplit(keys, "`n")

        for key in keyList {
            if (key = "")
                continue

            value := IniRead(templateIni, section, key)

            ; Substitute variables
            for placeholder, replacement in substitutions {
                value := StrReplace(value, placeholder, replacement)
            }

            config[section . "." . key] := value
        }
    }

    result := "Template Configuration:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━`n`n"

    for key, value in config {
        result .= key . " = " . value . "`n"
    }

    MsgBox result, "Template Config"
}

; ============================================================================
; EXAMPLE 5: Configuration Comparison
; ============================================================================

Example5_ConfigComparison() {
    MsgBox "=== Example 5: Configuration Comparison ===`n`n" .
        "Comparing two configuration files..."

    config1 := A_ScriptDir . "\config1.ini"
    config2 := A_ScriptDir . "\config2.ini"

    try {
        FileDelete config1
        FileDelete config2
    }

    ; Create first config
    IniWrite "Value1", config1, "Settings", "Key1"
    IniWrite "Value2", config1, "Settings", "Key2"
    IniWrite "Value3", config1, "Settings", "Key3"

    ; Create second config (modified)
    IniWrite "Value1", config2, "Settings", "Key1"  ; Same
    IniWrite "ValueX", config2, "Settings", "Key2"  ; Different
    IniWrite "Value4", config2, "Settings", "Key4"  ; New

    ; Compare
    differences := []
    keys1 := IniRead(config1, "Settings")
    keyList1 := StrSplit(keys1, "`n")

    for key in keyList1 {
        if (key = "")
            continue

        val1 := IniRead(config1, "Settings", key)
        val2 := IniRead(config2, "Settings", key, "***MISSING***")

        if (val2 = "***MISSING***") {
            differences.Push("Removed: " . key)
        } else if (val1 != val2) {
            differences.Push("Changed: " . key . " (" . val1 . " → " . val2 . ")")
        }
    }

    ; Check for new keys
    keys2 := IniRead(config2, "Settings")
    keyList2 := StrSplit(keys2, "`n")

    for key in keyList2 {
        if (key = "")
            continue

        val1 := IniRead(config1, "Settings", key, "***MISSING***")
        if (val1 = "***MISSING***") {
            differences.Push("Added: " . key)
        }
    }

    result := "Configuration Comparison:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━`n`n"

    if (differences.Length = 0) {
        result .= "No differences found"
    } else {
        for diff in differences {
            result .= "• " . diff . "`n"
        }
    }

    MsgBox result, "Config Comparison"
}

; ============================================================================
; EXAMPLE 6: Configuration Profiles
; ============================================================================

Example6_ConfigProfiles() {
    MsgBox "=== Example 6: Configuration Profiles ===`n`n" .
        "Managing multiple configuration profiles..."

    iniFile := A_ScriptDir . "\profiles_config.ini"

    try {
        FileDelete iniFile
    }

    ; Profile 1: Home
    IniWrite "Light", iniFile, "Profile.Home", "Theme"
    IniWrite "12", iniFile, "Profile.Home", "FontSize"
    IniWrite "true", iniFile, "Profile.Home", "Notifications"

    ; Profile 2: Work
    IniWrite "Dark", iniFile, "Profile.Work", "Theme"
    IniWrite "10", iniFile, "Profile.Work", "FontSize"
    IniWrite "false", iniFile, "Profile.Work", "Notifications"

    ; Profile 3: Mobile
    IniWrite "Auto", iniFile, "Profile.Mobile", "Theme"
    IniWrite "14", iniFile, "Profile.Mobile", "FontSize"
    IniWrite "true", iniFile, "Profile.Mobile", "Notifications"

    ; Select profile
    activeProfile := "Work"

    ; Load profile
    theme := IniRead(iniFile, "Profile." . activeProfile, "Theme")
    fontSize := IniRead(iniFile, "Profile." . activeProfile, "FontSize")
    notifications := IniRead(iniFile, "Profile." . activeProfile, "Notifications")

    result := "Active Profile: " . activeProfile . "`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Theme: " . theme . "`n"
    result .= "Font Size: " . fontSize . "`n"
    result .= "Notifications: " . notifications . "`n"

    MsgBox result, "Profile Config"
}

; ============================================================================
; EXAMPLE 7: Configuration Monitoring
; ============================================================================

Example7_ConfigMonitoring() {
    MsgBox "=== Example 7: Configuration Monitoring ===`n`n" .
        "Monitoring configuration changes..."

    iniFile := A_ScriptDir . "\monitor_config.ini"

    try {
        FileDelete iniFile
    }

    ; Create initial config
    IniWrite "Value1", iniFile, "Monitor", "Key1"
    IniWrite "Value2", iniFile, "Monitor", "Key2"

    ; Take snapshot
    snapshot := Map()
    keys := IniRead(iniFile, "Monitor")
    keyList := StrSplit(keys, "`n")

    for key in keyList {
        if (key != "")
            snapshot[key] := IniRead(iniFile, "Monitor", key)
    }

    ; Simulate modification
    IniWrite "ModifiedValue", iniFile, "Monitor", "Key1"
    IniWrite "Value3", iniFile, "Monitor", "Key3"

    ; Detect changes
    changes := []

    for key, originalValue in snapshot {
        currentValue := IniRead(iniFile, "Monitor", key, "***MISSING***")
        if (currentValue != originalValue) {
            changes.Push("Modified: " . key . " (" . originalValue . " → " . currentValue . ")")
        }
    }

    ; Check for new keys
    currentKeys := IniRead(iniFile, "Monitor")
    currentKeyList := StrSplit(currentKeys, "`n")

    for key in currentKeyList {
        if (key != "" && !snapshot.Has(key)) {
            changes.Push("Added: " . key)
        }
    }

    result := "Configuration Changes:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━`n`n"

    if (changes.Length = 0) {
        result .= "No changes detected"
    } else {
        for change in changes {
            result .= "• " . change . "`n"
        }
    }

    MsgBox result, "Config Monitoring"
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMenu() {
    menu := "
    (
    AutoHotkey v2 - IniRead Advanced
    ═════════════════════════════════

    1. Configuration Validation
    2. Config Inheritance
    3. Environment-Specific Config
    4. Config Templates
    5. Config Comparison
    6. Config Profiles
    7. Config Monitoring

    0. Exit

    Select an example (1-7):
    )"

    choice := InputBox(menu, "IniRead Advanced").Value

    switch choice {
        case "1": Example1_ValidationDemo()
        case "2": Example2_ConfigInheritance()
        case "3": Example3_EnvironmentConfig()
        case "4": Example4_ConfigTemplates()
        case "5": Example5_ConfigComparison()
        case "6": Example6_ConfigProfiles()
        case "7": Example7_ConfigMonitoring()
        case "0": ExitApp()
        default:
            MsgBox "Invalid selection!", "Error"
            return
    }

    SetTimer(() => ShowMenu(), -1000)
}

ShowMenu()
