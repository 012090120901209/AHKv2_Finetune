#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 INI Write Examples - Part 3
* ============================================================================
*
* Comprehensive INI writing for enterprise configuration management,
* deployment automation, and advanced config patterns.
*
* @description Enterprise configuration management with INI files
* @author AHK v2 Examples Collection
* @version 1.0.0
* @date 2024-01-15
*/

; ============================================================================
; EXAMPLE 1: Configuration Deployment System
; ============================================================================

class ConfigDeployment {
    static DeployToEnvironment(env) {
        configFile := A_ScriptDir . "\deployed_" . env . ".ini"

        try {
            FileDelete configFile
        }

        ; Base configuration
        IniWrite "MyApp", configFile, "Application", "Name"
        IniWrite "2.0.0", configFile, "Application", "Version"
        IniWrite env, configFile, "Application", "Environment"

        ; Environment-specific deployment
        switch env {
            case "Development":
            this.DeployDev(configFile)
            case "Staging":
            this.DeployStaging(configFile)
            case "Production":
            this.DeployProduction(configFile)
        }

        IniWrite A_Now, configFile, "Deployment", "DeployedAt"
        IniWrite A_ComputerName, configFile, "Deployment", "DeployedOn"

        return configFile
    }

    static DeployDev(file) {
        IniWrite "localhost", file, "Database", "Host"
        IniWrite "true", file, "Debug", "Enabled"
        IniWrite "DEBUG", file, "Logging", "Level"
    }

    static DeployStaging(file) {
        IniWrite "staging-db.example.com", file, "Database", "Host"
        IniWrite "false", file, "Debug", "Enabled"
        IniWrite "INFO", file, "Logging", "Level"
    }

    static DeployProduction(file) {
        IniWrite "prod-db.example.com", file, "Database", "Host"
        IniWrite "false", file, "Debug", "Enabled"
        IniWrite "ERROR", file, "Logging", "Level"
    }
}

Example1_Deployment() {
    MsgBox "=== Example 1: Configuration Deployment ===`n`n" .
    "Deploying configurations to environments..."

    envs := ["Development", "Staging", "Production"]
    deployed := []

    for env in envs {
        file := ConfigDeployment.DeployToEnvironment(env)
        deployed.Push(env)
    }

    result := "Deployment Complete:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━`n`n"

    for env in deployed {
        result .= "✓ " . env . " deployed`n"
    }

    MsgBox result, "Deployment Results"
}

; ============================================================================
; EXAMPLE 2: Feature Flag Configuration
; ============================================================================

Example2_FeatureFlags() {
    MsgBox "=== Example 2: Feature Flag Config ===`n`n" .
    "Configuring feature flags..."

    iniFile := A_ScriptDir . "\feature_flags.ini"

    try {
        FileDelete iniFile
    }

    ; Feature flags with rollout percentages
    features := [
    Map("name", "DarkMode", "enabled", true, "rollout", 100),
    Map("name", "BetaSearch", "enabled", true, "rollout", 50),
    Map("name", "NewDashboard", "enabled", false, "rollout", 0),
    Map("name", "AIAssistant", "enabled", true, "rollout", 25)
    ]

    for feature in features {
        section := "Feature." . feature["name"]

        IniWrite (feature["enabled"] ? "true" : "false"), iniFile, section, "Enabled"
        IniWrite feature["rollout"], iniFile, section, "RolloutPercentage"
        IniWrite A_Now, iniFile, section, "LastModified"
    }

    result := "Feature Flags Configured:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━`n`n"

    for feature in features {
        status := feature["enabled"] ? "ON" : "OFF"
        result .= feature["name"] . ": " . status . " (" . feature["rollout"] . "%)`n"
    }

    MsgBox result, "Feature Flags"
}

; ============================================================================
; EXAMPLE 3: Configuration Template Engine
; ============================================================================

class TemplateEngine {
    static Process(templateFile, outputFile, variables) {
        try {
            FileDelete outputFile
        }

        sections := IniRead(templateFile)

        for section in StrSplit(sections, "`n") {
            if (section = "")
            continue

            keys := IniRead(templateFile, section)

            for key in StrSplit(keys, "`n") {
                if (key = "")
                continue

                value := IniRead(templateFile, section, key)

                ; Replace variables
                for placeholder, replacement in variables {
                    value := StrReplace(value, placeholder, replacement)
                }

                IniWrite value, outputFile, section, key
            }
        }
    }
}

Example3_TemplateEngine() {
    MsgBox "=== Example 3: Template Engine ===`n`n" .
    "Processing configuration template..."

    templateFile := A_ScriptDir . "\template.ini"
    outputFile := A_ScriptDir . "\processed.ini"

    try {
        FileDelete templateFile
    }

    ; Create template
    IniWrite "{{APP_NAME}}", templateFile, "App", "Name"
    IniWrite "{{VERSION}}", templateFile, "App", "Version"
    IniWrite "{{DB_HOST}}", templateFile, "Database", "Host"
    IniWrite "{{DB_PORT}}", templateFile, "Database", "Port"

    ; Process template
    vars := Map(
    "{{APP_NAME}}", "ProductionApp",
    "{{VERSION}}", "3.0.1",
    "{{DB_HOST}}", "prod-server.example.com",
    "{{DB_PORT}}", "5432"
    )

    TemplateEngine.Process(templateFile, outputFile, vars)

    result := "Template Processing Complete:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Variables Substituted: " . vars.Count . "`n"
    result .= "Output: " . outputFile . "`n"

    MsgBox result, "Template Processed"
}

; ============================================================================
; EXAMPLE 4: Configuration Versioning System
; ============================================================================

Example4_ConfigVersioning() {
    MsgBox "=== Example 4: Configuration Versioning ===`n`n" .
    "Creating versioned configurations..."

    baseFile := A_ScriptDir . "\app_config.ini"
    versionFile := A_ScriptDir . "\app_config_v2.ini"

    try {
        FileDelete baseFile
        FileDelete versionFile
    }

    ; V1 configuration
    IniWrite "AppName", baseFile, "Application", "Name"
    IniWrite "1.0.0", baseFile, "Meta", "ConfigVersion"

    ; V2 configuration (with new fields)
    IniWrite "AppName", versionFile, "Application", "Name"
    IniWrite "Enhanced AppName", versionFile, "Application", "DisplayName"  ; New
    IniWrite "2.0.0", versionFile, "Meta", "ConfigVersion"

    IniWrite "localhost", versionFile, "Database", "Host"
    IniWrite "5432", versionFile, "Database", "Port"
    IniWrite "true", versionFile, "Features", "AdvancedMode"  ; New section

    result := "Configuration Versioning:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "V1 Created: " . baseFile . "`n"
    result .= "V2 Created: " . versionFile . "`n`n"
    result .= "V2 Enhancements:`n"
    result .= "  • DisplayName field`n"
    result .= "  • Database section`n"
    result .= "  • Features section`n"

    MsgBox result, "Versioning Complete"
}

; ============================================================================
; EXAMPLE 5: Multi-Tenant Configuration
; ============================================================================

Example5_MultiTenant() {
    MsgBox "=== Example 5: Multi-Tenant Config ===`n`n" .
    "Creating multi-tenant configurations..."

    iniFile := A_ScriptDir . "\multitenant.ini"

    try {
        FileDelete iniFile
    }

    tenants := [
    Map("id", "tenant1", "name", "Acme Corp", "db", "db1.example.com"),
    Map("id", "tenant2", "name", "TechStart", "db", "db2.example.com"),
    Map("id", "tenant3", "name", "GlobalInc", "db", "db3.example.com")
    ]

    for tenant in tenants {
        section := "Tenant." . tenant["id"]

        IniWrite tenant["name"], iniFile, section, "Name"
        IniWrite tenant["db"], iniFile, section, "DatabaseHost"
        IniWrite "5432", iniFile, section, "DatabasePort"
        IniWrite "true", iniFile, section, "Active"
        IniWrite A_Now, iniFile, section, "CreatedAt"
    }

    result := "Multi-Tenant Configuration:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Tenants Configured: " . tenants.Length . "`n`n"

    for tenant in tenants {
        result .= "• " . tenant["name"] . " (" . tenant["id"] . ")`n"
    }

    MsgBox result, "Multi-Tenant Config"
}

; ============================================================================
; EXAMPLE 6: Configuration Encryption Metadata
; ============================================================================

Example6_EncryptionMeta() {
    MsgBox "=== Example 6: Encryption Metadata ===`n`n" .
    "Storing encryption metadata..."

    iniFile := A_ScriptDir . "\encrypted.ini"

    try {
        FileDelete iniFile
    }

    ; Write encrypted value metadata (not actual encryption)
    IniWrite "AES256", iniFile, "Security", "Algorithm"
    IniWrite "true", iniFile, "Security", "Enabled"
    IniWrite A_Now, iniFile, "Security", "KeyRotatedAt"

    ; Encrypted values (simulated - in real use, these would be encrypted)
    IniWrite "***ENCRYPTED***", iniFile, "Secrets", "ApiKey"
    IniWrite "***ENCRYPTED***", iniFile, "Secrets", "DatabasePassword"
    IniWrite "***ENCRYPTED***", iniFile, "Secrets", "PrivateKey"

    ; Metadata about encrypted fields
    IniWrite "Secrets.ApiKey,Secrets.DatabasePassword,Secrets.PrivateKey", iniFile, "Security", "EncryptedFields"

    result := "Encryption Metadata Stored:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Algorithm: AES256`n"
    result .= "Encrypted Fields: 3`n"
    result .= "Last Key Rotation: " . A_Now . "`n"

    MsgBox result, "Encryption Metadata"
}

; ============================================================================
; EXAMPLE 7: Comprehensive Application Installer
; ============================================================================

Example7_AppInstaller() {
    MsgBox "=== Example 7: Application Installer ===`n`n" .
    "Creating complete installation configuration..."

    iniFile := A_ScriptDir . "\install_config.ini"

    try {
        FileDelete iniFile
    }

    ; Installation metadata
    IniWrite A_Now, iniFile, "Installation", "InstalledAt"
    IniWrite A_ComputerName, iniFile, "Installation", "ComputerName"
    IniWrite A_UserName, iniFile, "Installation", "InstalledBy"
    IniWrite "3.0.0", iniFile, "Installation", "Version"

    ; Application settings
    IniWrite "SuperApp Pro", iniFile, "Application", "Name"
    IniWrite "C:\Program Files\SuperApp", iniFile, "Application", "InstallPath"
    IniWrite "true", iniFile, "Application", "CreateDesktopShortcut"
    IniWrite "true", iniFile, "Application", "CreateStartMenuShortcut"

    ; Default user preferences
    IniWrite "Light", iniFile, "Preferences", "Theme"
    IniWrite "English", iniFile, "Preferences", "Language"
    IniWrite "true", iniFile, "Preferences", "CheckForUpdates"
    IniWrite "Weekly", iniFile, "Preferences", "UpdateFrequency"

    ; License information
    IniWrite "PRO-" . A_Now, iniFile, "License", "Key"
    IniWrite "Professional", iniFile, "License", "Edition"
    IniWrite "Perpetual", iniFile, "License", "Type"

    ; System requirements check results
    IniWrite "Windows 10", iniFile, "SystemCheck", "OS"
    IniWrite "8192", iniFile, "SystemCheck", "RAMInstalled"
    IniWrite "500", iniFile, "SystemCheck", "DiskSpaceGB"
    IniWrite "Pass", iniFile, "SystemCheck", "Result"

    result := "Installation Configuration Created:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Application: SuperApp Pro`n"
    result .= "Version: 3.0.0`n"
    result .= "Install Path: C:\Program Files\SuperApp`n"
    result .= "Licensed To: " . A_UserName . "`n"
    result .= "Edition: Professional`n`n"
    result .= "Installation: ✓ Complete`n"

    MsgBox result, "Installer Complete"
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMenu() {
    menu := "
    (
    AutoHotkey v2 - IniWrite Enterprise
    ═════════════════════════════════════

    1. Configuration Deployment
    2. Feature Flags
    3. Template Engine
    4. Config Versioning
    5. Multi-Tenant Config
    6. Encryption Metadata
    7. Application Installer

    0. Exit

    Select an example (1-7):
    )"

    choice := InputBox(menu, "IniWrite Enterprise").Value

    switch choice {
        case "1": Example1_Deployment()
        case "2": Example2_FeatureFlags()
        case "3": Example3_TemplateEngine()
        case "4": Example4_ConfigVersioning()
        case "5": Example5_MultiTenant()
        case "6": Example6_EncryptionMeta()
        case "7": Example7_AppInstaller()
        case "0": ExitApp()
        default:
        MsgBox "Invalid selection!", "Error"
        return
    }

    SetTimer(() => ShowMenu(), -1000)
}

ShowMenu()
