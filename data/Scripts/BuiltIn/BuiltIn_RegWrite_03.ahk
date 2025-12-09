#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 Registry Write Examples - Part 3
* ============================================================================
*
* This file demonstrates comprehensive registry writing for system
* configuration, automated deployment, and settings validation.
*
* @description System configuration and automated deployment
* @author AHK v2 Examples Collection
* @version 1.0.0
* @date 2024-01-15
*/

; ============================================================================
; EXAMPLE 1: Application Deployment Configuration
; ============================================================================

/**
* @class DeploymentManager
* @description Manages application deployment configurations
*/
class DeploymentManager {
    deployKey := ""

    __New(appName) {
        this.deployKey := "HKCU\Software\" . appName . "\Deployment"
    }

    /**
    * @method DeployConfiguration
    * @description Deploys complete application configuration
    * @param {String} environment - Environment (Dev/Test/Prod)
    * @returns {Boolean} Success status
    */
    DeployConfiguration(environment) {
        try {
            ; Set environment
            RegWrite environment, "REG_SZ", this.deployKey, "Environment"
            RegWrite A_Now, "REG_SZ", this.deployKey, "DeployedAt"
            RegWrite A_ComputerName, "REG_SZ", this.deployKey, "DeployedOn"

            ; Environment-specific settings
            switch environment {
                case "Dev":
                this.DeployDevSettings()
                case "Test":
                this.DeployTestSettings()
                case "Prod":
                this.DeployProdSettings()
                default:
                return false
            }

            ; Common settings
            this.DeployCommonSettings()

            return true
        } catch {
            return false
        }
    }

    /**
    * @method DeployDevSettings
    * @description Deploys development environment settings
    */
    DeployDevSettings() {
        settingsKey := this.deployKey . "\Settings"

        RegWrite 1, "REG_DWORD", settingsKey, "DebugMode"
        RegWrite 1, "REG_DWORD", settingsKey, "VerboseLogging"
        RegWrite "localhost", "REG_SZ", settingsKey, "ApiServer"
        RegWrite 8080, "REG_DWORD", settingsKey, "ApiPort"
        RegWrite 0, "REG_DWORD", settingsKey, "RequireSSL"
        RegWrite 300, "REG_DWORD", settingsKey, "CacheTimeout"
    }

    /**
    * @method DeployTestSettings
    * @description Deploys test environment settings
    */
    DeployTestSettings() {
        settingsKey := this.deployKey . "\Settings"

        RegWrite 0, "REG_DWORD", settingsKey, "DebugMode"
        RegWrite 1, "REG_DWORD", settingsKey, "VerboseLogging"
        RegWrite "test.api.example.com", "REG_SZ", settingsKey, "ApiServer"
        RegWrite 443, "REG_DWORD", settingsKey, "ApiPort"
        RegWrite 1, "REG_DWORD", settingsKey, "RequireSSL"
        RegWrite 600, "REG_DWORD", settingsKey, "CacheTimeout"
    }

    /**
    * @method DeployProdSettings
    * @description Deploys production environment settings
    */
    DeployProdSettings() {
        settingsKey := this.deployKey . "\Settings"

        RegWrite 0, "REG_DWORD", settingsKey, "DebugMode"
        RegWrite 0, "REG_DWORD", settingsKey, "VerboseLogging"
        RegWrite "api.example.com", "REG_SZ", settingsKey, "ApiServer"
        RegWrite 443, "REG_DWORD", settingsKey, "ApiPort"
        RegWrite 1, "REG_DWORD", settingsKey, "RequireSSL"
        RegWrite 3600, "REG_DWORD", settingsKey, "CacheTimeout"
    }

    /**
    * @method DeployCommonSettings
    * @description Deploys settings common to all environments
    */
    DeployCommonSettings() {
        settingsKey := this.deployKey . "\Settings"

        RegWrite 30, "REG_DWORD", settingsKey, "RequestTimeout"
        RegWrite 3, "REG_DWORD", settingsKey, "MaxRetries"
        RegWrite "1.0.0", "REG_SZ", settingsKey, "ConfigVersion"
        RegWrite 100, "REG_DWORD", settingsKey, "MaxConnections"
    }

    /**
    * @method GetDeploymentReport
    * @description Gets deployment report
    * @returns {String} Formatted report
    */
    GetDeploymentReport() {
        report := "Deployment Report:`n"
        report .= "━━━━━━━━━━━━━━━━━━`n`n"

        try {
            env := RegRead(this.deployKey, "Environment")
            deployedAt := RegRead(this.deployKey, "DeployedAt")
            deployedOn := RegRead(this.deployKey, "DeployedOn")

            report .= "Environment: " . env . "`n"
            report .= "Deployed At: " . deployedAt . "`n"
            report .= "Deployed On: " . deployedOn . "`n`n"

            report .= "Settings:`n"
            settingsKey := this.deployKey . "\Settings"

            try {
                Loop Reg, settingsKey, "V"
 {
                    try {
                        value := RegRead(settingsKey, A_LoopRegName)
                        report .= "  " . A_LoopRegName . " = " . value . "`n"
                    }
                }
            }
        } catch {
            report .= "No deployment found"
        }

        return report
    }
}

/**
* @function Example1_Deployment
* @description Demonstrates application deployment
* @returns {void}
*/
Example1_Deployment() {
    MsgBox "=== Example 1: Application Deployment ===`n`n" .
    "Deploying application configuration..."

    dm := DeploymentManager("AHKv2Examples\MyApp")

    ; Deploy to Development
    if (dm.DeployConfiguration("Dev")) {
        report := dm.GetDeploymentReport()
        MsgBox report, "Development Deployment"
    }

    ; Deploy to Production
    if (dm.DeployConfiguration("Prod")) {
        report := dm.GetDeploymentReport()
        MsgBox report, "Production Deployment"
    }
}

; ============================================================================
; EXAMPLE 2: Configuration Validation and Sanitization
; ============================================================================

/**
* @class ConfigValidator
* @description Validates and sanitizes configuration before writing
*/
class ConfigValidator {
    configKey := ""
    validationRules := Map()

    __New(configKey) {
        this.configKey := configKey
        this.SetupValidationRules()
    }

    /**
    * @method SetupValidationRules
    * @description Sets up validation rules
    */
    SetupValidationRules() {
        ; Define validation rules
        this.validationRules["Port"] := Map(
        "type", "integer",
        "min", 1,
        "max", 65535
        )

        this.validationRules["Theme"] := Map(
        "type", "enum",
        "values", ["Light", "Dark", "Auto"]
        )

        this.validationRules["FontSize"] := Map(
        "type", "integer",
        "min", 8,
        "max", 72
        )

        this.validationRules["Username"] := Map(
        "type", "string",
        "minLength", 3,
        "maxLength", 32,
        "pattern", "^[a-zA-Z0-9_]+$"
        )
    }

    /**
    * @method Validate
    * @description Validates a configuration value
    * @param {String} key - Configuration key
    * @param {Any} value - Value to validate
    * @returns {Map} Validation result
    */
    Validate(key, value) {
        result := Map(
        "valid", false,
        "error", "",
        "sanitized", value
        )

        if (!this.validationRules.Has(key)) {
            result["valid"] := true
            return result
        }

        rule := this.validationRules[key]

        ; Validate based on type
        switch rule["type"] {
            case "integer":
            if (value is Integer) {
                if (value < rule["min"] || value > rule["max"]) {
                    result["error"] := "Value must be between " . rule["min"] . " and " . rule["max"]
                } else {
                    result["valid"] := true
                }
            } else {
                result["error"] := "Value must be an integer"
            }

            case "enum":
            found := false
            for allowed in rule["values"] {
                if (value = allowed) {
                    found := true
                    break
                }
            }
            if (found) {
                result["valid"] := true
            } else {
                result["error"] := "Value must be one of: " . this.JoinArray(rule["values"], ", ")
            }

            case "string":
            if (StrLen(value) < rule["minLength"]) {
                result["error"] := "String too short (min " . rule["minLength"] . ")"
            } else if (StrLen(value) > rule["maxLength"]) {
                result["error"] := "String too long (max " . rule["maxLength"] . ")"
            } else {
                result["valid"] := true
            }
        }

        return result
    }

    /**
    * @method WriteValidated
    * @description Writes a value after validation
    * @param {String} key - Configuration key
    * @param {Any} value - Value to write
    * @returns {Map} Write result
    */
    WriteValidated(key, value) {
        ; Validate first
        validation := this.Validate(key, value)

        writeResult := Map(
        "success", false,
        "error", ""
        )

        if (!validation["valid"]) {
            writeResult["error"] := validation["error"]
            return writeResult
        }

        ; Write to registry
        try {
            if (value is Integer)
            RegWrite value, "REG_DWORD", this.configKey, key
            else
            RegWrite value, "REG_SZ", this.configKey, key

            writeResult["success"] := true
        } catch Error as err {
            writeResult["error"] := err.Message
        }

        return writeResult
    }

    /**
    * @method JoinArray
    * @description Joins array elements
    */
    JoinArray(arr, separator) {
        result := ""
        for item in arr {
            if (result != "")
            result .= separator
            result .= item
        }
        return result
    }
}

/**
* @function Example2_Validation
* @description Demonstrates configuration validation
* @returns {void}
*/
Example2_Validation() {
    MsgBox "=== Example 2: Configuration Validation ===`n`n" .
    "Validating configuration before writing..."

    validator := ConfigValidator("HKCU\Software\AHKv2Examples\ValidatedConfig")

    ; Test valid values
    result1 := validator.WriteValidated("Port", 8080)
    result2 := validator.WriteValidated("Theme", "Dark")
    result3 := validator.WriteValidated("FontSize", 12)

    ; Test invalid values
    result4 := validator.WriteValidated("Port", 99999)  ; Out of range
    result5 := validator.WriteValidated("Theme", "Invalid")  ; Not in enum
    result6 := validator.WriteValidated("FontSize", 200)  ; Out of range

    ; Build report
    report := "Validation Results:`n"
    report .= "━━━━━━━━━━━━━━━━━━`n`n"

    report .= "Port=8080: " . (result1["success"] ? "✓ Valid" : "✗ " . result1["error"]) . "`n"
    report .= "Theme=Dark: " . (result2["success"] ? "✓ Valid" : "✗ " . result2["error"]) . "`n"
    report .= "FontSize=12: " . (result3["success"] ? "✓ Valid" : "✗ " . result3["error"]) . "`n`n"

    report .= "Port=99999: " . (result4["success"] ? "✓ Valid" : "✗ " . result4["error"]) . "`n"
    report .= "Theme=Invalid: " . (result5["success"] ? "✓ Valid" : "✗ " . result5["error"]) . "`n"
    report .= "FontSize=200: " . (result6["success"] ? "✓ Valid" : "✗ " . result6["error"]) . "`n"

    MsgBox report, "Validation Test"
}

; ============================================================================
; EXAMPLE 3: Atomic Configuration Updates
; ============================================================================

/**
* @class AtomicConfig
* @description Performs atomic configuration updates with rollback
*/
class AtomicConfig {
    configKey := ""
    backupKey := ""
    transaction := []

    __New(configKey) {
        this.configKey := configKey
        this.backupKey := configKey . "_Backup"
    }

    /**
    * @method BeginTransaction
    * @description Begins a configuration transaction
    * @returns {Boolean} Success status
    */
    BeginTransaction() {
        this.transaction := []

        ; Backup current configuration
        try {
            Loop Reg, this.configKey, "V"
 {
                try {
                    valueName := A_LoopRegName
                    value := RegRead(this.configKey, valueName)

                    RegWrite value, "REG_SZ", this.backupKey, valueName
                } catch {
                    ; Continue backing up other values
                }
            }
            return true
        } catch {
            return false
        }
    }

    /**
    * @method AddWrite
    * @description Adds a write operation to transaction
    * @param {String} valueName - Value name
    * @param {Any} value - Value to write
    * @param {String} type - Registry type
    */
    AddWrite(valueName, value, type := "REG_SZ") {
        this.transaction.Push(Map(
        "operation", "write",
        "valueName", valueName,
        "value", value,
        "type", type
        ))
    }

    /**
    * @method Commit
    * @description Commits the transaction
    * @returns {Map} Commit result
    */
    Commit() {
        result := Map(
        "success", false,
        "operations", this.transaction.Length,
        "completed", 0,
        "error", ""
        )

        try {
            ; Execute all operations
            for op in this.transaction {
                if (op["operation"] = "write") {
                    RegWrite op["value"], op["type"], this.configKey, op["valueName"]
                    result["completed"]++
                }
            }

            result["success"] := true

            ; Clear backup on success
            try {
                RegDeleteKey this.backupKey
            }

        } catch Error as err {
            ; Rollback on error
            result["error"] := err.Message
            this.Rollback()
        }

        this.transaction := []
        return result
    }

    /**
    * @method Rollback
    * @description Rolls back the transaction
    * @returns {Boolean} Success status
    */
    Rollback() {
        try {
            ; Restore from backup
            Loop Reg, this.backupKey, "V"
 {
                try {
                    valueName := A_LoopRegName
                    value := RegRead(this.backupKey, valueName)
                    RegWrite value, "REG_SZ", this.configKey, valueName
                } catch {
                    ; Continue restoring other values
                }
            }

            ; Clear backup
            RegDeleteKey this.backupKey

            return true
        } catch {
            return false
        }
    }
}

/**
* @function Example3_AtomicUpdates
* @description Demonstrates atomic configuration updates
* @returns {void}
*/
Example3_AtomicUpdates() {
    MsgBox "=== Example 3: Atomic Updates ===`n`n" .
    "Performing atomic configuration updates..."

    atomic := AtomicConfig("HKCU\Software\AHKv2Examples\AtomicConfig")

    ; Begin transaction
    atomic.BeginTransaction()

    ; Add multiple operations
    atomic.AddWrite("Setting1", "New Value 1")
    atomic.AddWrite("Setting2", "New Value 2")
    atomic.AddWrite("Counter", 42, "REG_DWORD")
    atomic.AddWrite("Enabled", 1, "REG_DWORD")

    ; Commit transaction
    result := atomic.Commit()

    report := "Atomic Update Results:`n"
    report .= "━━━━━━━━━━━━━━━━━━━━━`n"
    report .= "Total Operations: " . result["operations"] . "`n"
    report .= "Completed: " . result["completed"] . "`n"
    report .= "Status: " . (result["success"] ? "✓ Success" : "✗ Failed") . "`n"

    if (!result["success"] && result["error"] != "")
    report .= "Error: " . result["error"] . "`n"

    MsgBox report, "Transaction Complete"
}

; ============================================================================
; EXAMPLE 4: Scheduled Configuration Updates
; ============================================================================

/**
* @function Example4_ScheduledUpdates
* @description Demonstrates scheduled configuration updates
* @returns {void}
*/
Example4_ScheduledUpdates() {
    MsgBox "=== Example 4: Scheduled Updates ===`n`n" .
    "Configuring scheduled updates..."

    scheduleKey := "HKCU\Software\AHKv2Examples\ScheduledUpdates"

    ; Configure update schedule
    try {
        ; Daily update at 3 AM
        RegWrite "03:00", "REG_SZ", scheduleKey, "DailyUpdateTime"
        RegWrite 1, "REG_DWORD", scheduleKey, "EnableDailyUpdate"

        ; Weekly update on Sunday
        RegWrite 0, "REG_DWORD", scheduleKey, "WeeklyUpdateDay"  ; 0 = Sunday
        RegWrite 1, "REG_DWORD", scheduleKey, "EnableWeeklyUpdate"

        ; Update settings
        RegWrite 1, "REG_DWORD", scheduleKey, "AutoDownload"
        RegWrite 0, "REG_DWORD", scheduleKey, "AutoInstall"
        RegWrite 1, "REG_DWORD", scheduleKey, "NotifyBeforeUpdate"
        RegWrite 60, "REG_DWORD", scheduleKey, "NotificationMinutes"

        ; Last update info
        RegWrite A_Now, "REG_SZ", scheduleKey, "LastChecked"
        RegWrite "", "REG_SZ", scheduleKey, "LastUpdateInstalled"
    }

    result := "Scheduled Update Configuration:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
    result .= "Daily Update: 03:00 (Enabled)`n"
    result .= "Weekly Update: Sunday (Enabled)`n`n"
    result .= "Auto Download: Yes`n"
    result .= "Auto Install: No`n"
    result .= "Notify Before: Yes (60 minutes)`n"

    MsgBox result, "Update Schedule"
}

; ============================================================================
; EXAMPLE 5: Multi-Instance Configuration
; ============================================================================

/**
* @function Example5_MultiInstance
* @description Demonstrates managing multiple application instances
* @returns {void}
*/
Example5_MultiInstance() {
    MsgBox "=== Example 5: Multi-Instance Config ===`n`n" .
    "Configuring multiple application instances..."

    baseKey := "HKCU\Software\AHKv2Examples\MultiInstance"

    ; Configure Instance 1
    instance1Key := baseKey . "\Instance1"
    try {
        RegWrite "Primary Instance", "REG_SZ", instance1Key, "InstanceName"
        RegWrite 8080, "REG_DWORD", instance1Key, "Port"
        RegWrite "C:\Data\Instance1", "REG_SZ", instance1Key, "DataPath"
        RegWrite 1, "REG_DWORD", instance1Key, "AutoStart"
    }

    ; Configure Instance 2
    instance2Key := baseKey . "\Instance2"
    try {
        RegWrite "Secondary Instance", "REG_SZ", instance2Key, "InstanceName"
        RegWrite 8081, "REG_DWORD", instance2Key, "Port"
        RegWrite "C:\Data\Instance2", "REG_SZ", instance2Key, "DataPath"
        RegWrite 0, "REG_DWORD", instance2Key, "AutoStart"
    }

    ; Configure Instance 3
    instance3Key := baseKey . "\Instance3"
    try {
        RegWrite "Test Instance", "REG_SZ", instance3Key, "InstanceName"
        RegWrite 8082, "REG_DWORD", instance3Key, "Port"
        RegWrite "C:\Data\Instance3", "REG_SZ", instance3Key, "DataPath"
        RegWrite 0, "REG_DWORD", instance3Key, "AutoStart"
    }

    result := "Multi-Instance Configuration:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Instance 1: Port 8080 (AutoStart)`n"
    result .= "Instance 2: Port 8081`n"
    result .= "Instance 3: Port 8082 (Test)`n"

    MsgBox result, "Instances Configured"
}

; ============================================================================
; EXAMPLE 6: Configuration Migration System
; ============================================================================

/**
* @class ConfigMigration
* @description Migrates configuration between versions
*/
class ConfigMigration {
    /**
    * @method Migrate
    * @description Migrates configuration from old to new version
    * @param {Integer} fromVersion - Source version
    * @param {Integer} toVersion - Target version
    * @returns {Map} Migration result
    */
    static Migrate(fromVersion, toVersion) {
        result := Map(
        "success", false,
        "fromVersion", fromVersion,
        "toVersion", toVersion,
        "changes", []
        )

        try {
            ; Apply migrations sequentially
            currentVersion := fromVersion

            while (currentVersion < toVersion) {
                nextVersion := currentVersion + 1

                switch currentVersion {
                    case 1:
                    this.MigrateFrom1To2(result)
                    case 2:
                    this.MigrateFrom2To3(result)
                }

                currentVersion := nextVersion
            }

            result["success"] := true
        } catch Error as err {
            result["error"] := err.Message
        }

        return result
    }

    /**
    * @method MigrateFrom1To2
    * @description Migrates from version 1 to 2
    */
    static MigrateFrom1To2(result) {
        migKey := "HKCU\Software\AHKv2Examples\Migration"

        ; Add new settings in v2
        RegWrite 1, "REG_DWORD", migKey, "NewFeatureEnabled"
        RegWrite "Default", "REG_SZ", migKey, "ProfileName"

        result["changes"].Push("Added NewFeatureEnabled setting")
        result["changes"].Push("Added ProfileName setting")
    }

    /**
    * @method MigrateFrom2To3
    * @description Migrates from version 2 to 3
    */
    static MigrateFrom2To3(result) {
        migKey := "HKCU\Software\AHKv2Examples\Migration"

        ; Rename setting in v3
        try {
            oldValue := RegRead(migKey, "OldSetting")
            RegWrite oldValue, "REG_SZ", migKey, "NewSetting"
            RegDelete migKey, "OldSetting"

            result["changes"].Push("Renamed OldSetting to NewSetting")
        } catch {
            ; Old setting may not exist
        }

        ; Add v3 settings
        RegWrite 2, "REG_DWORD", migKey, "CacheVersion"

        result["changes"].Push("Added CacheVersion setting")
    }
}

/**
* @function Example6_Migration
* @description Demonstrates configuration migration
* @returns {void}
*/
Example6_Migration() {
    MsgBox "=== Example 6: Configuration Migration ===`n`n" .
    "Migrating configuration between versions..."

    ; Migrate from version 1 to 3
    result := ConfigMigration.Migrate(1, 3)

    report := "Migration Results:`n"
    report .= "━━━━━━━━━━━━━━━━`n"
    report .= "From Version: " . result["fromVersion"] . "`n"
    report .= "To Version: " . result["toVersion"] . "`n"
    report .= "Status: " . (result["success"] ? "✓ Success" : "✗ Failed") . "`n`n"

    report .= "Changes Applied:`n"
    for change in result["changes"] {
        report .= "  • " . change . "`n"
    }

    MsgBox report, "Migration Complete"
}

; ============================================================================
; EXAMPLE 7: Configuration Audit Trail
; ============================================================================

/**
* @function Example7_AuditTrail
* @description Demonstrates configuration audit trail
* @returns {void}
*/
Example7_AuditTrail() {
    MsgBox "=== Example 7: Configuration Audit Trail ===`n`n" .
    "Creating configuration audit trail..."

    auditKey := "HKCU\Software\AHKv2Examples\Audit"

    ; Create audit entries
    timestamp := A_Now

    ; Entry 1
    entry1Key := auditKey . "\Entry1"
    try {
        RegWrite timestamp, "REG_SZ", entry1Key, "Timestamp"
        RegWrite "Setting1", "REG_SZ", entry1Key, "SettingName"
        RegWrite "Old Value", "REG_SZ", entry1Key, "OldValue"
        RegWrite "New Value", "REG_SZ", entry1Key, "NewValue"
        RegWrite A_UserName, "REG_SZ", entry1Key, "ChangedBy"
        RegWrite "User requested change", "REG_SZ", entry1Key, "Reason"
    }

    ; Entry 2
    entry2Key := auditKey . "\Entry2"
    try {
        RegWrite timestamp, "REG_SZ", entry2Key, "Timestamp"
        RegWrite "Theme", "REG_SZ", entry2Key, "SettingName"
        RegWrite "Light", "REG_SZ", entry2Key, "OldValue"
        RegWrite "Dark", "REG_SZ", entry2Key, "NewValue"
        RegWrite A_UserName, "REG_SZ", entry2Key, "ChangedBy"
        RegWrite "Preference change", "REG_SZ", entry2Key, "Reason"
    }

    result := "Configuration Audit Trail:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Entry 1:`n"
    result .= "  Setting: Setting1`n"
    result .= "  Old → New: Old Value → New Value`n"
    result .= "  Changed By: " . A_UserName . "`n`n"
    result .= "Entry 2:`n"
    result .= "  Setting: Theme`n"
    result .= "  Old → New: Light → Dark`n"
    result .= "  Changed By: " . A_UserName . "`n"

    MsgBox result, "Audit Trail Created"
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMenu() {
    menu := "
    (
    AutoHotkey v2 - RegWrite System Config
    ═══════════════════════════════════════

    1. Application Deployment
    2. Configuration Validation
    3. Atomic Updates
    4. Scheduled Updates
    5. Multi-Instance Config
    6. Configuration Migration
    7. Audit Trail

    0. Exit

    Select an example (1-7):
    )"

    choice := InputBox(menu, "RegWrite System Config").Value

    switch choice {
        case "1": Example1_Deployment()
        case "2": Example2_Validation()
        case "3": Example3_AtomicUpdates()
        case "4": Example4_ScheduledUpdates()
        case "5": Example5_MultiInstance()
        case "6": Example6_Migration()
        case "7": Example7_AuditTrail()
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
