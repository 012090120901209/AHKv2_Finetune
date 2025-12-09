#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 INI Read Examples - Part 3
* ============================================================================
*
* Comprehensive INI reading for configuration management systems,
* migrations, and complex data structures.
*
* @description Configuration management and complex INI operations
* @author AHK v2 Examples Collection
* @version 1.0.0
* @date 2024-01-15
*/

; ============================================================================
; EXAMPLE 1: Configuration Migration Reader
; ============================================================================

class ConfigMigration {
    static ReadVersion(iniFile) {
        return IniRead(iniFile, "Meta", "ConfigVersion", "1")
    }

    static MigrateIfNeeded(iniFile, targetVersion) {
        currentVersion := this.ReadVersion(iniFile)

        if (currentVersion = targetVersion)
        return "Already at target version"

        steps := []
        v := Integer(currentVersion)

        while (v < Integer(targetVersion)) {
            v++
            steps.Push("Migrated to version " . v)
        }

        return steps
    }
}

Example1_ConfigMigration() {
    MsgBox "=== Example 1: Configuration Migration ===`n`n" .
    "Reading and migrating configuration versions..."

    iniFile := A_ScriptDir . "\migrate_config.ini"

    try {
        FileDelete iniFile
    }

    IniWrite "1", iniFile, "Meta", "ConfigVersion"
    IniWrite "OldValue", iniFile, "Settings", "SomeSetting"

    version := ConfigMigration.ReadVersion(iniFile)
    steps := ConfigMigration.MigrateIfNeeded(iniFile, "3")

    result := "Configuration Migration:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Current Version: " . version . "`n"
    result .= "Target Version: 3`n`n"
    result .= "Migration Steps:`n"

    if (steps is Array) {
        for step in steps {
            result .= "  • " . step . "`n"
        }
    } else {
        result .= "  " . steps . "`n"
    }

    MsgBox result, "Migration"
}

; ============================================================================
; EXAMPLE 2: Nested Configuration Reader
; ============================================================================

Example2_NestedConfig() {
    MsgBox "=== Example 2: Nested Configuration ===`n`n" .
    "Reading hierarchical configuration..."

    iniFile := A_ScriptDir . "\nested_config.ini"

    try {
        FileDelete iniFile
    }

    ; Simulate nested structure using dot notation
    IniWrite "Value1", iniFile, "App", "Database.Host"
    IniWrite "5432", iniFile, "App", "Database.Port"
    IniWrite "mydb", iniFile, "App", "Database.Name"
    IniWrite "INFO", iniFile, "App", "Logging.Level"
    IniWrite "app.log", iniFile, "App", "Logging.File"

    ; Read nested structure
    keys := IniRead(iniFile, "App")
    keyList := StrSplit(keys, "`n")

    nested := Map()

    for key in keyList {
        if (key = "")
        continue

        value := IniRead(iniFile, "App", key)
        parts := StrSplit(key, ".")

        if (parts.Length = 2) {
            category := parts[1]
            setting := parts[2]

            if (!nested.Has(category))
            nested[category] := Map()

            nested[category][setting] := value
        }
    }

    result := "Nested Configuration:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━`n`n"

    for category, settings in nested {
        result .= category . ":`n"
        for key, value in settings {
            result .= "  " . key . " = " . value . "`n"
        }
        result .= "`n"
    }

    MsgBox result, "Nested Config"
}

; ============================================================================
; EXAMPLE 3: Configuration Backup Reader
; ============================================================================

Example3_BackupReader() {
    MsgBox "=== Example 3: Configuration Backup ===`n`n" .
    "Reading configuration backups..."

    mainIni := A_ScriptDir . "\main_config.ini"
    backupIni := A_ScriptDir . "\main_config.backup.ini"

    try {
        FileDelete mainIni
        FileDelete backupIni
    }

    ; Create main config
    IniWrite "Main Value 1", mainIni, "Settings", "Key1"
    IniWrite "Main Value 2", mainIni, "Settings", "Key2"

    ; Create backup (older version)
    IniWrite "Backup Value 1", backupIni, "Settings", "Key1"
    IniWrite "Backup Value 2", backupIni, "Settings", "Key2"

    ; Read both
    mainKey1 := IniRead(mainIni, "Settings", "Key1")
    backupKey1 := IniRead(backupIni, "Settings", "Key1")

    result := "Configuration Backup Comparison:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Main Config:`n"
    result .= "  Key1 = " . mainKey1 . "`n`n"
    result .= "Backup Config:`n"
    result .= "  Key1 = " . backupKey1 . "`n"

    MsgBox result, "Backup Reader"
}

; ============================================================================
; EXAMPLE 4: Configuration Cache Reader
; ============================================================================

class ConfigCache {
    static cache := Map()

    static Get(iniFile, section, key, default := "") {
        cacheKey := iniFile . "|" . section . "|" . key

        if (this.cache.Has(cacheKey))
        return this.cache[cacheKey]

        value := IniRead(iniFile, section, key, default)
        this.cache[cacheKey] := value

        return value
    }

    static Clear() {
        this.cache := Map()
    }
}

Example4_CachedReading() {
    MsgBox "=== Example 4: Cached Configuration Reading ===`n`n" .
    "Using cached configuration reads..."

    iniFile := A_ScriptDir . "\cached_config.ini"

    try {
        FileDelete iniFile
    }

    IniWrite "CachedValue", iniFile, "Settings", "Key1"

    ; First read (cached)
    start1 := A_TickCount
    val1 := ConfigCache.Get(iniFile, "Settings", "Key1")
    time1 := A_TickCount - start1

    ; Second read (from cache)
    start2 := A_TickCount
    val2 := ConfigCache.Get(iniFile, "Settings", "Key1")
    time2 := A_TickCount - start2

    result := "Cached Configuration Reading:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "First Read: " . time1 . "ms (disk)`n"
    result .= "Second Read: " . time2 . "ms (cache)`n"
    result .= "Value: " . val1 . "`n"

    MsgBox result, "Cached Reading"
}

; ============================================================================
; EXAMPLE 5: Large Configuration File Reader
; ============================================================================

Example5_LargeConfig() {
    MsgBox "=== Example 5: Large Configuration ===`n`n" .
    "Reading large configuration files..."

    iniFile := A_ScriptDir . "\large_config.ini"

    try {
        FileDelete iniFile
    }

    ; Create large config
    Loop 10 {
        section := "Section" . A_Index
        Loop 10 {
            IniWrite "Value" . A_Index, iniFile, section, "Key" . A_Index
        }
    }

    ; Read all sections
    sections := IniRead(iniFile)
    sectionList := StrSplit(sections, "`n")

    totalKeys := 0
    for section in sectionList {
        if (section = "")
        continue

        keys := IniRead(iniFile, section)
        keyList := StrSplit(keys, "`n")
        totalKeys += keyList.Length
    }

    result := "Large Configuration File:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Sections: " . sectionList.Length . "`n"
    result .= "Total Keys: " . totalKeys . "`n"

    MsgBox result, "Large Config"
}

; ============================================================================
; EXAMPLE 6: Configuration Audit Log Reader
; ============================================================================

Example6_AuditLog() {
    MsgBox "=== Example 6: Configuration Audit Log ===`n`n" .
    "Reading configuration change history..."

    iniFile := A_ScriptDir . "\audit_config.ini"

    try {
        FileDelete iniFile
    }

    ; Create audit entries
    IniWrite A_Now, iniFile, "Audit.Entry1", "Timestamp"
    IniWrite "User1", iniFile, "Audit.Entry1", "User"
    IniWrite "Changed Setting1", iniFile, "Audit.Entry1", "Action"

    IniWrite A_Now, iniFile, "Audit.Entry2", "Timestamp"
    IniWrite "User2", iniFile, "Audit.Entry2", "User"
    IniWrite "Changed Setting2", iniFile, "Audit.Entry2", "Action"

    ; Read audit log
    sections := IniRead(iniFile)
    sectionList := StrSplit(sections, "`n")

    auditEntries := []

    for section in sectionList {
        if (section = "" || !InStr(section, "Audit.Entry"))
        continue

        timestamp := IniRead(iniFile, section, "Timestamp")
        user := IniRead(iniFile, section, "User")
        action := IniRead(iniFile, section, "Action")

        auditEntries.Push(Map(
        "timestamp", timestamp,
        "user", user,
        "action", action
        ))
    }

    result := "Audit Log Entries:`n"
    result .= "━━━━━━━━━━━━━━━━━`n`n"

    for entry in auditEntries {
        result .= entry["timestamp"] . " - " . entry["user"] . "`n"
        result .= "  " . entry["action"] . "`n`n"
    }

    MsgBox result, "Audit Log"
}

; ============================================================================
; EXAMPLE 7: Configuration Schema Validator
; ============================================================================

Example7_SchemaValidation() {
    MsgBox "=== Example 7: Schema Validation ===`n`n" .
    "Validating configuration against schema..."

    iniFile := A_ScriptDir . "\schema_config.ini"
    schemaFile := A_ScriptDir . "\schema.ini"

    try {
        FileDelete iniFile
        FileDelete schemaFile
    }

    ; Create schema
    IniWrite "string", schemaFile, "Schema.Application", "Name"
    IniWrite "string", schemaFile, "Schema.Application", "Version"
    IniWrite "integer", schemaFile, "Schema.Window", "Width"
    IniWrite "integer", schemaFile, "Schema.Window", "Height"

    ; Create config
    IniWrite "MyApp", iniFile, "Application", "Name"
    IniWrite "1.0", iniFile, "Application", "Version"
    IniWrite "1024", iniFile, "Window", "Width"
    IniWrite "NotANumber", iniFile, "Window", "Height"  ; Invalid

    ; Validate
    violations := []

    schemaSections := IniRead(schemaFile)
    schemaSectionList := StrSplit(schemaSections, "`n")

    for schemaSection in schemaSectionList {
        if (schemaSection = "" || !InStr(schemaSection, "Schema."))
        continue

        actualSection := StrReplace(schemaSection, "Schema.", "")

        schemaKeys := IniRead(schemaFile, schemaSection)
        keyList := StrSplit(schemaKeys, "`n")

        for key in keyList {
            if (key = "")
            continue

            expectedType := IniRead(schemaFile, schemaSection, key)
            value := IniRead(iniFile, actualSection, key, "***MISSING***")

            if (value = "***MISSING***") {
                violations.Push("Missing: [" . actualSection . "] " . key)
                continue
            }

            if (expectedType = "integer" && !IsInteger(value)) {
                violations.Push("Type mismatch: [" . actualSection . "] " . key . " (expected integer)")
            }
        }
    }

    result := "Schema Validation Results:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━`n`n"

    if (violations.Length = 0) {
        result .= "✓ Configuration is valid"
    } else {
        result .= "✗ Validation failed:`n`n"
        for violation in violations {
            result .= "  • " . violation . "`n"
        }
    }

    MsgBox result, "Schema Validation"
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMenu() {
    menu := "
    (
    AutoHotkey v2 - IniRead Config Management
    ══════════════════════════════════════════

    1. Configuration Migration
    2. Nested Configuration
    3. Backup Reader
    4. Cached Reading
    5. Large Configuration
    6. Audit Log
    7. Schema Validation

    0. Exit

    Select an example (1-7):
    )"

    choice := InputBox(menu, "IniRead Config Management").Value

    switch choice {
        case "1": Example1_ConfigMigration()
        case "2": Example2_NestedConfig()
        case "3": Example3_BackupReader()
        case "4": Example4_CachedReading()
        case "5": Example5_LargeConfig()
        case "6": Example6_AuditLog()
        case "7": Example7_SchemaValidation()
        case "0": ExitApp()
        default:
        MsgBox "Invalid selection!", "Error"
        return
    }

    SetTimer(() => ShowMenu(), -1000)
}

ShowMenu()
