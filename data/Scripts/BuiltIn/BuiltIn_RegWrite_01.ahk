#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 Registry Write Examples - Part 1
* ============================================================================
*
* This file demonstrates comprehensive usage of the RegWrite function in
* AutoHotkey v2, including writing values, creating keys, and handling
* different data types (REG_SZ, REG_DWORD, REG_BINARY, etc.).
*
* @description Examples of writing to Windows Registry
* @author AHK v2 Examples Collection
* @version 1.0.0
* @date 2024-01-15
*/

; ============================================================================
; EXAMPLE 1: Basic Registry Writing (Different Data Types)
; ============================================================================

/**
* @function Example1_BasicRegWrite
* @description Demonstrates writing different registry data types
* @returns {void}
*/
Example1_BasicRegWrite() {
    MsgBox "=== Example 1: Basic Registry Writing ===`n`n" .
    "Creating test registry entries with different data types..."

    ; Define test key (safe location in HKCU)
    testKey := "HKCU\Software\AHKv2Examples\RegWriteTest"

    try {
        ; REG_SZ (String)
        RegWrite "String Value Test", "REG_SZ", testKey, "TestString"

        ; REG_DWORD (32-bit number)
        RegWrite 42, "REG_DWORD", testKey, "TestDWORD"

        ; REG_QWORD (64-bit number)
        RegWrite 9876543210, "REG_QWORD", testKey, "TestQWORD"

        ; REG_BINARY (Binary data - as hex string)
        RegWrite "01020304", "REG_BINARY", testKey, "TestBinary"

        ; REG_MULTI_SZ (Multi-string - separated by `n)
        RegWrite "Line1`nLine2`nLine3", "REG_MULTI_SZ", testKey, "TestMultiString"

        ; REG_EXPAND_SZ (Expandable string)
        RegWrite "%SystemRoot%\System32", "REG_EXPAND_SZ", testKey, "TestExpandString"

        ; Verify the values were written
        result := "Registry Values Written Successfully:`n"
        result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"

        result .= "REG_SZ: " . RegRead(testKey, "TestString") . "`n"
        result .= "REG_DWORD: " . RegRead(testKey, "TestDWORD") . "`n"
        result .= "REG_QWORD: " . RegRead(testKey, "TestQWORD") . "`n"
        result .= "REG_BINARY: " . RegRead(testKey, "TestBinary") . "`n"
        result .= "REG_MULTI_SZ: " . RegRead(testKey, "TestMultiString") . "`n"
        result .= "REG_EXPAND_SZ: " . RegRead(testKey, "TestExpandString") . "`n"

        MsgBox result, "Write Successful"

    } catch Error as err {
        MsgBox "Error writing to registry: " . err.Message, "Error"
    }
}

; ============================================================================
; EXAMPLE 2: Application Settings Manager
; ============================================================================

/**
* @class AppSettings
* @description Manages application settings in the registry
*/
class AppSettings {
    appKey := ""

    /**
    * @method __New
    * @description Constructor
    * @param {String} appName - Application name for registry key
    */
    __New(appName) {
        this.appKey := "HKCU\Software\" . appName
    }

    /**
    * @method SetString
    * @description Sets a string value
    * @param {String} name - Setting name
    * @param {String} value - Setting value
    * @returns {Boolean} Success status
    */
    SetString(name, value) {
        try {
            RegWrite value, "REG_SZ", this.appKey, name
            return true
        } catch {
            return false
        }
    }

    /**
    * @method SetNumber
    * @description Sets a numeric value
    * @param {String} name - Setting name
    * @param {Integer} value - Setting value
    * @returns {Boolean} Success status
    */
    SetNumber(name, value) {
        try {
            RegWrite value, "REG_DWORD", this.appKey, name
            return true
        } catch {
            return false
        }
    }

    /**
    * @method SetBoolean
    * @description Sets a boolean value (as DWORD 0 or 1)
    * @param {String} name - Setting name
    * @param {Boolean} value - Setting value
    * @returns {Boolean} Success status
    */
    SetBoolean(name, value) {
        try {
            RegWrite (value ? 1 : 0), "REG_DWORD", this.appKey, name
            return true
        } catch {
            return false
        }
    }

    /**
    * @method GetString
    * @description Gets a string value
    * @param {String} name - Setting name
    * @param {String} default - Default value
    * @returns {String} Setting value
    */
    GetString(name, default := "") {
        try {
            return RegRead(this.appKey, name)
        } catch {
            return default
        }
    }

    /**
    * @method GetNumber
    * @description Gets a numeric value
    * @param {String} name - Setting name
    * @param {Integer} default - Default value
    * @returns {Integer} Setting value
    */
    GetNumber(name, default := 0) {
        try {
            return RegRead(this.appKey, name)
        } catch {
            return default
        }
    }

    /**
    * @method GetBoolean
    * @description Gets a boolean value
    * @param {String} name - Setting name
    * @param {Boolean} default - Default value
    * @returns {Boolean} Setting value
    */
    GetBoolean(name, default := false) {
        try {
            value := RegRead(this.appKey, name)
            return (value != 0)
        } catch {
            return default
        }
    }

    /**
    * @method ExportSettings
    * @description Exports all settings
    * @returns {Map} All settings
    */
    ExportSettings() {
        settings := Map()
        try {
            Loop Reg, this.appKey, "V"
 {
                try {
                    settings[A_LoopRegName] := RegRead(this.appKey, A_LoopRegName)
                }
            }
        }
        return settings
    }
}

/**
* @function Example2_AppSettings
* @description Demonstrates application settings management
* @returns {void}
*/
Example2_AppSettings() {
    MsgBox "=== Example 2: Application Settings ===`n`n" .
    "Managing application settings in registry..."

    settings := AppSettings("AHKv2Examples\MyApp")

    ; Write various settings
    settings.SetString("AppVersion", "1.2.3")
    settings.SetString("UserName", "John Doe")
    settings.SetNumber("WindowWidth", 800)
    settings.SetNumber("WindowHeight", 600)
    settings.SetBoolean("StartWithWindows", true)
    settings.SetBoolean("ShowNotifications", false)
    settings.SetNumber("ThemeID", 2)

    ; Read settings back
    result := "Application Settings:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "App Version: " . settings.GetString("AppVersion") . "`n"
    result .= "User Name: " . settings.GetString("UserName") . "`n"
    result .= "Window Size: " . settings.GetNumber("WindowWidth") . "x" . settings.GetNumber("WindowHeight") . "`n"
    result .= "Start with Windows: " . (settings.GetBoolean("StartWithWindows") ? "Yes" : "No") . "`n"
    result .= "Show Notifications: " . (settings.GetBoolean("ShowNotifications") ? "Yes" : "No") . "`n"
    result .= "Theme ID: " . settings.GetNumber("ThemeID") . "`n"

    MsgBox result, "Settings Manager"
}

; ============================================================================
; EXAMPLE 3: Configuration Backup and Restore
; ============================================================================

/**
* @class ConfigBackup
* @description Backs up and restores registry configurations
*/
class ConfigBackup {
    backupData := Map()

    /**
    * @method Backup
    * @description Backs up a registry key and all its values
    * @param {String} keyPath - Registry key to backup
    * @returns {Integer} Number of values backed up
    */
    Backup(keyPath) {
        this.backupData := Map()
        this.backupData["keyPath"] := keyPath
        this.backupData["values"] := Map()
        count := 0

        try {
            Loop Reg, keyPath, "V"
 {
                try {
                    valueName := A_LoopRegName
                    value := RegRead(keyPath, valueName)

                    ; Try to determine the type by reading it back
                    this.backupData["values"][valueName] := Map(
                    "value", value,
                    "type", "REG_SZ"  ; Default to string type
                    )
                    count++
                } catch {
                    ; Skip inaccessible values
                }
            }
        } catch {
            return 0
        }

        this.backupData["timestamp"] := A_Now
        return count
    }

    /**
    * @method Restore
    * @description Restores backed up values
    * @returns {Integer} Number of values restored
    */
    Restore() {
        if (!this.backupData.Has("keyPath"))
        return 0

        keyPath := this.backupData["keyPath"]
        count := 0

        for valueName, valueData in this.backupData["values"] {
            try {
                RegWrite valueData["value"], valueData["type"], keyPath, valueName
                count++
            } catch {
                ; Skip failed writes
            }
        }

        return count
    }

    /**
    * @method GetBackupInfo
    * @description Gets information about the backup
    * @returns {String} Backup information
    */
    GetBackupInfo() {
        if (!this.backupData.Has("keyPath"))
        return "No backup data available"

        info := "Backup Information:`n"
        info .= "━━━━━━━━━━━━━━━━━━`n"
        info .= "Key: " . this.backupData["keyPath"] . "`n"
        info .= "Timestamp: " . this.backupData["timestamp"] . "`n"
        info .= "Values: " . this.backupData["values"].Count . "`n`n"

        for valueName, valueData in this.backupData["values"] {
            valueStr := String(valueData["value"])
            if (StrLen(valueStr) > 40)
            valueStr := SubStr(valueStr, 1, 37) . "..."
            info .= valueName . " = " . valueStr . "`n"
        }

        return info
    }
}

/**
* @function Example3_BackupRestore
* @description Demonstrates backup and restore functionality
* @returns {void}
*/
Example3_BackupRestore() {
    MsgBox "=== Example 3: Backup & Restore ===`n`n" .
    "Demonstrating registry backup and restore..."

    testKey := "HKCU\Software\AHKv2Examples\BackupTest"

    ; Create some test data
    try {
        RegWrite "Original Value 1", "REG_SZ", testKey, "Value1"
        RegWrite "Original Value 2", "REG_SZ", testKey, "Value2"
        RegWrite 100, "REG_DWORD", testKey, "Number1"
    }

    ; Create backup
    backup := ConfigBackup()
    count := backup.Backup(testKey)
    MsgBox "Backed up " . count . " values", "Backup Created"

    ; Show backup info
    info := backup.GetBackupInfo()
    MsgBox info, "Backup Information"

    ; Modify the values
    try {
        RegWrite "Modified Value 1", "REG_SZ", testKey, "Value1"
        RegWrite "Modified Value 2", "REG_SZ", testKey, "Value2"
        RegWrite 200, "REG_DWORD", testKey, "Number1"
    }

    MsgBox "Values have been modified.`nClick OK to restore from backup.", "Modified"

    ; Restore from backup
    restored := backup.Restore()
    MsgBox "Restored " . restored . " values from backup", "Restore Complete"

    ; Verify restoration
    try {
        val1 := RegRead(testKey, "Value1")
        val2 := RegRead(testKey, "Value2")
        num1 := RegRead(testKey, "Number1")

        result := "Restored Values:`n"
        result .= "Value1: " . val1 . "`n"
        result .= "Value2: " . val2 . "`n"
        result .= "Number1: " . num1 . "`n"

        MsgBox result, "Verification"
    }
}

; ============================================================================
; EXAMPLE 4: Batch Registry Operations
; ============================================================================

/**
* @class BatchRegWriter
* @description Performs batch registry write operations
*/
class BatchRegWriter {
    operations := []
    results := []

    /**
    * @method Add
    * @description Adds an operation to the batch
    * @param {String} keyPath - Registry key path
    * @param {String} valueName - Value name
    * @param {Any} value - Value to write
    * @param {String} type - Registry value type
    */
    Add(keyPath, valueName, value, type := "REG_SZ") {
        this.operations.Push(Map(
        "keyPath", keyPath,
        "valueName", valueName,
        "value", value,
        "type", type
        ))
    }

    /**
    * @method Execute
    * @description Executes all batch operations
    * @returns {Integer} Number of successful operations
    */
    Execute() {
        this.results := []
        successCount := 0

        for op in this.operations {
            result := Map(
            "keyPath", op["keyPath"],
            "valueName", op["valueName"],
            "status", "Unknown",
            "error", ""
            )

            try {
                RegWrite op["value"], op["type"], op["keyPath"], op["valueName"]
                result["status"] := "Success"
                successCount++
            } catch Error as err {
                result["status"] := "Failed"
                result["error"] := err.Message
            }

            this.results.Push(result)
        }

        return successCount
    }

    /**
    * @method GetReport
    * @description Gets execution report
    * @returns {String} Formatted report
    */
    GetReport() {
        report := "Batch Operation Report:`n"
        report .= "━━━━━━━━━━━━━━━━━━━━━━`n"
        report .= "Total Operations: " . this.operations.Length . "`n"

        successCount := 0
        failCount := 0

        for result in this.results {
            if (result["status"] = "Success")
            successCount++
            else
            failCount++
        }

        report .= "Successful: " . successCount . "`n"
        report .= "Failed: " . failCount . "`n`n"

        for result in this.results {
            status := result["status"] = "Success" ? "✓" : "✗"
            report .= status . " " . result["keyPath"] . "\" . result["valueName"] . "`n"
            if (result["status"] != "Success" && result["error"] != "")
            report .= "  Error: " . result["error"] . "`n"
        }

        return report
    }

    /**
    * @method Clear
    * @description Clears all operations
    */
    Clear() {
        this.operations := []
        this.results := []
    }
}

/**
* @function Example4_BatchOperations
* @description Demonstrates batch registry operations
* @returns {void}
*/
Example4_BatchOperations() {
    MsgBox "=== Example 4: Batch Operations ===`n`n" .
    "Performing batch registry writes..."

    batch := BatchRegWriter()
    baseKey := "HKCU\Software\AHKv2Examples\BatchTest"

    ; Add multiple operations
    batch.Add(baseKey, "Setting1", "Value 1")
    batch.Add(baseKey, "Setting2", "Value 2")
    batch.Add(baseKey, "Counter", 0, "REG_DWORD")
    batch.Add(baseKey, "Enabled", 1, "REG_DWORD")
    batch.Add(baseKey, "Path", "%USERPROFILE%\Documents", "REG_EXPAND_SZ")

    ; Execute batch
    successCount := batch.Execute()

    ; Show report
    report := batch.GetReport()
    MsgBox report, "Batch Results"
}

; ============================================================================
; EXAMPLE 5: User Preferences Manager
; ============================================================================

/**
* @class UserPreferences
* @description Manages user preferences with validation
*/
class UserPreferences {
    prefKey := "HKCU\Software\AHKv2Examples\UserPrefs"

    /**
    * @method SetTheme
    * @description Sets the theme preference
    * @param {String} themeName - Theme name (Light, Dark, Auto)
    * @returns {Boolean} Success status
    */
    SetTheme(themeName) {
        validThemes := ["Light", "Dark", "Auto"]
        if (!this.ArrayContains(validThemes, themeName))
        return false

        try {
            RegWrite themeName, "REG_SZ", this.prefKey, "Theme"
            return true
        } catch {
            return false
        }
    }

    /**
    * @method SetFontSize
    * @description Sets the font size preference
    * @param {Integer} size - Font size (8-72)
    * @returns {Boolean} Success status
    */
    SetFontSize(size) {
        if (size < 8 || size > 72)
        return false

        try {
            RegWrite size, "REG_DWORD", this.prefKey, "FontSize"
            return true
        } catch {
            return false
        }
    }

    /**
    * @method SetLanguage
    * @description Sets the language preference
    * @param {String} langCode - Language code (en, es, fr, de)
    * @returns {Boolean} Success status
    */
    SetLanguage(langCode) {
        validLangs := ["en", "es", "fr", "de", "ja", "zh"]
        if (!this.ArrayContains(validLangs, langCode))
        return false

        try {
            RegWrite langCode, "REG_SZ", this.prefKey, "Language"
            return true
        } catch {
            return false
        }
    }

    /**
    * @method SetNotifications
    * @description Sets notification preferences
    * @param {Boolean} enabled - Enable notifications
    * @param {Integer} volume - Notification volume (0-100)
    * @returns {Boolean} Success status
    */
    SetNotifications(enabled, volume := 50) {
        if (volume < 0 || volume > 100)
        return false

        try {
            RegWrite (enabled ? 1 : 0), "REG_DWORD", this.prefKey, "NotificationsEnabled"
            RegWrite volume, "REG_DWORD", this.prefKey, "NotificationVolume"
            return true
        } catch {
            return false
        }
    }

    /**
    * @method GetAllPreferences
    * @description Gets all current preferences
    * @returns {String} Formatted preferences
    */
    GetAllPreferences() {
        prefs := "User Preferences:`n"
        prefs .= "━━━━━━━━━━━━━━━━━━`n`n"

        try {
            theme := RegRead(this.prefKey, "Theme")
            prefs .= "Theme: " . theme . "`n"
        } catch {
            prefs .= "Theme: Not Set`n"
        }

        try {
            fontSize := RegRead(this.prefKey, "FontSize")
            prefs .= "Font Size: " . fontSize . "`n"
        } catch {
            prefs .= "Font Size: Not Set`n"
        }

        try {
            lang := RegRead(this.prefKey, "Language")
            prefs .= "Language: " . lang . "`n"
        } catch {
            prefs .= "Language: Not Set`n"
        }

        try {
            notifEnabled := RegRead(this.prefKey, "NotificationsEnabled")
            notifVolume := RegRead(this.prefKey, "NotificationVolume")
            prefs .= "Notifications: " . (notifEnabled ? "Enabled" : "Disabled") . "`n"
            prefs .= "Volume: " . notifVolume . "%`n"
        } catch {
            prefs .= "Notifications: Not Set`n"
        }

        return prefs
    }

    /**
    * @method ArrayContains
    * @description Helper to check if array contains value
    */
    ArrayContains(arr, value) {
        for item in arr {
            if (item = value)
            return true
        }
        return false
    }
}

/**
* @function Example5_UserPreferences
* @description Demonstrates user preferences management
* @returns {void}
*/
Example5_UserPreferences() {
    MsgBox "=== Example 5: User Preferences ===`n`n" .
    "Managing user preferences with validation..."

    prefs := UserPreferences()

    ; Set various preferences
    prefs.SetTheme("Dark")
    prefs.SetFontSize(12)
    prefs.SetLanguage("en")
    prefs.SetNotifications(true, 75)

    ; Display preferences
    allPrefs := prefs.GetAllPreferences()
    MsgBox allPrefs, "Current Preferences"
}

; ============================================================================
; EXAMPLE 6: Registry Migration Tool
; ============================================================================

/**
* @function Example6_RegistryMigration
* @description Demonstrates migrating settings from one key to another
* @returns {void}
*/
Example6_RegistryMigration() {
    MsgBox "=== Example 6: Registry Migration ===`n`n" .
    "Migrating settings from old to new location..."

    oldKey := "HKCU\Software\AHKv2Examples\OldSettings"
    newKey := "HKCU\Software\AHKv2Examples\NewSettings"

    ; Create some old settings
    try {
        RegWrite "Old Config Value 1", "REG_SZ", oldKey, "Config1"
        RegWrite "Old Config Value 2", "REG_SZ", oldKey, "Config2"
        RegWrite 999, "REG_DWORD", oldKey, "VersionCode"
    }

    ; Migrate
    migrated := 0
    try {
        Loop Reg, oldKey, "V"
 {
            try {
                value := RegRead(oldKey, A_LoopRegName)
                ; Default to REG_SZ for simplicity
                RegWrite value, "REG_SZ", newKey, A_LoopRegName
                migrated++
            }
        }
    }

    result := "Migration Complete:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━`n"
    result .= "Migrated " . migrated . " values`n"
    result .= "From: " . oldKey . "`n"
    result .= "To: " . newKey . "`n"

    MsgBox result, "Migration Results"
}

; ============================================================================
; EXAMPLE 7: Configuration Template System
; ============================================================================

/**
* @function Example7_ConfigTemplate
* @description Demonstrates applying configuration templates
* @returns {void}
*/
Example7_ConfigTemplate() {
    MsgBox "=== Example 7: Configuration Template ===`n`n" .
    "Applying configuration template..."

    ; Define configuration template
    template := Map(
    "AppName", "AHK Application",
    "Version", "2.0.0",
    "WindowX", 100,
    "WindowY", 100,
    "WindowWidth", 1024,
    "WindowHeight", 768,
    "MaximizeOnStart", 0,
    "AutoSave", 1,
    "AutoSaveInterval", 300,
    "Theme", "Light",
    "ShowToolbar", 1,
    "ShowStatusBar", 1
    )

    targetKey := "HKCU\Software\AHKv2Examples\TemplateConfig"
    applied := 0

    ; Apply template
    for valueName, value in template {
        try {
            ; Determine type based on value
            if (value is Integer)
            RegWrite value, "REG_DWORD", targetKey, valueName
            else
            RegWrite value, "REG_SZ", targetKey, valueName
            applied++
        }
    }

    result := "Configuration Template Applied:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
    result .= "Values Applied: " . applied . "/" . template.Count . "`n`n"
    result .= "Template Contents:`n"

    for valueName, value in template {
        result .= "  " . valueName . " = " . value . "`n"
    }

    MsgBox result, "Template Applied"
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMenu() {
    menu := "
    (
    AutoHotkey v2 - RegWrite Examples
    ═══════════════════════════════════

    1. Basic Registry Writing
    2. Application Settings
    3. Backup & Restore
    4. Batch Operations
    5. User Preferences
    6. Registry Migration
    7. Configuration Template

    0. Exit

    Select an example (1-7):
    )"

    choice := InputBox(menu, "RegWrite Examples").Value

    switch choice {
        case "1": Example1_BasicRegWrite()
        case "2": Example2_AppSettings()
        case "3": Example3_BackupRestore()
        case "4": Example4_BatchOperations()
        case "5": Example5_UserPreferences()
        case "6": Example6_RegistryMigration()
        case "7": Example7_ConfigTemplate()
        case "0": ExitApp()
        default:
        MsgBox "Invalid selection!", "Error"
        return
    }

    ; Show menu again
    SetTimer(() => ShowMenu(), -1000)
}

; Start the menu
ShowMenu()
