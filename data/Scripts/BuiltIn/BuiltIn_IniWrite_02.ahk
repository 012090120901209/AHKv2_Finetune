#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 INI Write Examples - Part 2
* ============================================================================
*
* Advanced INI writing scenarios including migrations, versioning,
* and configuration synchronization.
*
* @description Advanced INI file writing techniques
* @author AHK v2 Examples Collection
* @version 1.0.0
* @date 2024-01-15
*/

; ============================================================================
; EXAMPLE 1: Configuration Migration Writer
; ============================================================================

class ConfigMigrator {
    static MigrateToV2(oldFile, newFile) {
        try {
            FileDelete newFile
        }

        ; Read old format
        oldHost := IniRead(oldFile, "Database", "Server", "localhost")
        oldPort := IniRead(oldFile, "Database", "ServerPort", "3306")

        ; Write new format
        IniWrite oldHost, newFile, "Database", "Host"
        IniWrite oldPort, newFile, "Database", "Port"
        IniWrite "2", newFile, "Meta", "ConfigVersion"
        IniWrite A_Now, newFile, "Meta", "MigratedAt"

        return true
    }
}

Example1_ConfigMigration() {
    MsgBox "=== Example 1: Configuration Migration ===`n`n" .
    "Migrating configuration format..."

    oldFile := A_ScriptDir . "\old_format.ini"
    newFile := A_ScriptDir . "\new_format.ini"

    try {
        FileDelete oldFile
    }

    ; Create old format
    IniWrite "oldserver.com", oldFile, "Database", "Server"
    IniWrite "3306", oldFile, "Database", "ServerPort"

    ; Migrate
    ConfigMigrator.MigrateToV2(oldFile, newFile)

    result := "Configuration Migrated:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Old Format → New Format`n"
    result .= "Server → Host`n"
    result .= "ServerPort → Port`n"
    result .= "`nNew version: 2`n"

    MsgBox result, "Migration Complete"
}

; ============================================================================
; EXAMPLE 2: Multi-Profile Configuration Writer
; ============================================================================

Example2_MultiProfile() {
    MsgBox "=== Example 2: Multi-Profile Config ===`n`n" .
    "Creating multiple configuration profiles..."

    iniFile := A_ScriptDir . "\profiles.ini"

    try {
        FileDelete iniFile
    }

    ; Profile 1: Home
    IniWrite "Home", iniFile, "Profile.Home", "Name"
    IniWrite "Light", iniFile, "Profile.Home", "Theme"
    IniWrite "12", iniFile, "Profile.Home", "FontSize"
    IniWrite "true", iniFile, "Profile.Home", "ShowNotifications"

    ; Profile 2: Work
    IniWrite "Work", iniFile, "Profile.Work", "Name"
    IniWrite "Dark", iniFile, "Profile.Work", "Theme"
    IniWrite "10", iniFile, "Profile.Work", "FontSize"
    IniWrite "false", iniFile, "Profile.Work", "ShowNotifications"

    ; Profile 3: Presentation
    IniWrite "Presentation", iniFile, "Profile.Presentation", "Name"
    IniWrite "Light", iniFile, "Profile.Presentation", "Theme"
    IniWrite "18", iniFile, "Profile.Presentation", "FontSize"
    IniWrite "false", iniFile, "Profile.Presentation", "ShowNotifications"

    ; Set active profile
    IniWrite "Work", iniFile, "Settings", "ActiveProfile"

    result := "Multi-Profile Configuration Created:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Profiles:`n"
    result .= "  • Home`n"
    result .= "  • Work (Active)`n"
    result .= "  • Presentation`n"

    MsgBox result, "Profiles Created"
}

; ============================================================================
; EXAMPLE 3: Configuration Synchronization
; ============================================================================

Example3_ConfigSync() {
    MsgBox "=== Example 3: Configuration Sync ===`n`n" .
    "Synchronizing configuration files..."

    localFile := A_ScriptDir . "\local_config.ini"
    remoteFile := A_ScriptDir . "\remote_config.ini"

    try {
        FileDelete localFile
        FileDelete remoteFile
    }

    ; Local settings
    IniWrite "LocalValue1", localFile, "Settings", "Key1"
    IniWrite "LocalValue2", localFile, "Settings", "Key2"

    ; Remote settings (simulated)
    IniWrite "RemoteValue1", remoteFile, "Settings", "Key1"
    IniWrite "RemoteValue3", remoteFile, "Settings", "Key3"

    ; Sync (local takes precedence for conflicts)
    localSections := IniRead(localFile)
    for section in StrSplit(localSections, "`n") {
        if (section = "")
        continue

        keys := IniRead(localFile, section)
        for key in StrSplit(keys, "`n") {
            if (key = "")
            continue

            value := IniRead(localFile, section, key)
            IniWrite value, remoteFile, section, key
        }
    }

    IniWrite A_Now, remoteFile, "Sync", "LastSyncTime"

    result := "Configuration Synchronized:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Local → Remote`n"
    result .= "Sync Time: " . A_Now . "`n"

    MsgBox result, "Sync Complete"
}

; ============================================================================
; EXAMPLE 4: Hierarchical Configuration Writer
; ============================================================================

Example4_HierarchicalConfig() {
    MsgBox "=== Example 4: Hierarchical Config ===`n`n" .
    "Writing hierarchical configuration..."

    iniFile := A_ScriptDir . "\hierarchical.ini"

    try {
        FileDelete iniFile
    }

    ; Write hierarchical structure using dot notation
    IniWrite "localhost", iniFile, "App", "Database.Host"
    IniWrite "5432", iniFile, "App", "Database.Port"
    IniWrite "mydb", iniFile, "App", "Database.Name"

    IniWrite "INFO", iniFile, "App", "Logging.Level"
    IniWrite "app.log", iniFile, "App", "Logging.File"
    IniWrite "10", iniFile, "App", "Logging.MaxFiles"

    IniWrite "8080", iniFile, "App", "Server.Port"
    IniWrite "0.0.0.0", iniFile, "App", "Server.Host"

    result := "Hierarchical Configuration:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Structure:`n"
    result .= "  Database.Host`n"
    result .= "  Database.Port`n"
    result .= "  Database.Name`n"
    result .= "  Logging.Level`n"
    result .= "  Logging.File`n"
    result .= "  Logging.MaxFiles`n"
    result .= "  Server.Port`n"
    result .= "  Server.Host`n"

    MsgBox result, "Hierarchical Config"
}

; ============================================================================
; EXAMPLE 5: Configuration with Validation
; ============================================================================

class ValidatingConfigWriter {
    iniFile := ""
    errors := []

    __New(iniFile) {
        this.iniFile := iniFile
    }

    WriteValidated(section, key, value, validator) {
        if (!validator.Call(value)) {
            this.errors.Push("Invalid value for " . section . "." . key)
            return false
        }

        IniWrite value, this.iniFile, section, key
        return true
    }

    GetErrors() {
        return this.errors
    }
}

Example5_ValidatedWrite() {
    MsgBox "=== Example 5: Validated Writing ===`n`n" .
    "Writing with validation..."

    iniFile := A_ScriptDir . "\validated.ini"

    try {
        FileDelete iniFile
    }

    writer := ValidatingConfigWriter(iniFile)

    ; Validators
    portValidator := (v) => IsInteger(v) && v >= 1 && v <= 65535
    boolValidator := (v) => v = "true" || v = "false"

    ; Write with validation
    writer.WriteValidated("Server", "Port", "8080", portValidator)
    writer.WriteValidated("Server", "Port", "99999", portValidator)  ; Invalid
    writer.WriteValidated("Features", "Enabled", "true", boolValidator)

    errors := writer.GetErrors()

    result := "Validated Write Results:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━`n`n"

    if (errors.Length > 0) {
        result .= "Errors Found:`n"
        for error in errors {
            result .= "  • " . error . "`n"
        }
    } else {
        result .= "All validations passed"
    }

    MsgBox result, "Validation Results"
}

; ============================================================================
; EXAMPLE 6: Atomic Configuration Updates
; ============================================================================

Example6_AtomicWrite() {
    MsgBox "=== Example 6: Atomic Writing ===`n`n" .
    "Performing atomic configuration updates..."

    iniFile := A_ScriptDir . "\atomic.ini"
    tempFile := iniFile . ".tmp"

    try {
        FileDelete iniFile
        FileDelete tempFile
    }

    ; Create initial config
    IniWrite "Value1", iniFile, "Settings", "Key1"
    IniWrite "Value2", iniFile, "Settings", "Key2"

    ; Atomic update: write to temp file first
    try {
        IniWrite "NewValue1", tempFile, "Settings", "Key1"
        IniWrite "NewValue2", tempFile, "Settings", "Key2"
        IniWrite "NewValue3", tempFile, "Settings", "Key3"

        ; All writes succeeded, replace original
        FileDelete iniFile
        FileMove tempFile, iniFile

        result := "Atomic Write: ✓ Success`n"
        result .= "━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
        result .= "All changes applied successfully"

    } catch Error as err {
        ; Rollback on error
        try {
            FileDelete tempFile
        }

        result := "Atomic Write: ✗ Failed`n"
        result .= "━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
        result .= "Error: " . err.Message . "`n"
        result .= "Changes rolled back"
    }

    MsgBox result, "Atomic Write"
}

; ============================================================================
; EXAMPLE 7: Configuration Change Tracking
; ============================================================================

Example7_ChangeTracking() {
    MsgBox "=== Example 7: Change Tracking ===`n`n" .
    "Tracking configuration changes..."

    iniFile := A_ScriptDir . "\tracked.ini"
    auditFile := A_ScriptDir . "\audit.ini"

    try {
        FileDelete iniFile
        FileDelete auditFile
    }

    ; Function to write with audit trail
    WriteWithAudit(file, section, key, value, auditFile) {
        ; Read old value
        oldValue := IniRead(file, section, key, "***NEW***")

        ; Write new value
        IniWrite value, file, section, key

        ; Log change
        timestamp := A_Now
        auditKey := "Change_" . timestamp

        IniWrite timestamp, auditFile, auditKey, "Timestamp"
        IniWrite section . "." . key, auditFile, auditKey, "Setting"
        IniWrite oldValue, auditFile, auditKey, "OldValue"
        IniWrite value, auditFile, auditKey, "NewValue"
    }

    ; Make tracked changes
    WriteWithAudit(iniFile, "Settings", "Theme", "Light", auditFile)
    WriteWithAudit(iniFile, "Settings", "Theme", "Dark", auditFile)
    WriteWithAudit(iniFile, "Settings", "FontSize", "12", auditFile)

    ; Count changes
    auditSections := IniRead(auditFile)
    changeCount := 0
    for section in StrSplit(auditSections, "`n") {
        if (InStr(section, "Change_"))
        changeCount++
    }

    result := "Configuration Changes Tracked:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Total Changes: " . changeCount . "`n"
    result .= "Audit File: " . auditFile . "`n"

    MsgBox result, "Change Tracking"
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMenu() {
    menu := "
    (
    AutoHotkey v2 - IniWrite Advanced
    ══════════════════════════════════

    1. Configuration Migration
    2. Multi-Profile Config
    3. Configuration Sync
    4. Hierarchical Config
    5. Validated Writing
    6. Atomic Writing
    7. Change Tracking

    0. Exit

    Select an example (1-7):
    )"

    choice := InputBox(menu, "IniWrite Advanced").Value

    switch choice {
        case "1": Example1_ConfigMigration()
        case "2": Example2_MultiProfile()
        case "3": Example3_ConfigSync()
        case "4": Example4_HierarchicalConfig()
        case "5": Example5_ValidatedWrite()
        case "6": Example6_AtomicWrite()
        case "7": Example7_ChangeTracking()
        case "0": ExitApp()
        default:
        MsgBox "Invalid selection!", "Error"
        return
    }

    SetTimer(() => ShowMenu(), -1000)
}

ShowMenu()
