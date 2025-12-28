#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 INI Write Examples - Part 1
 * ============================================================================
 * 
 * This file demonstrates comprehensive usage of the IniWrite function in
 * AutoHotkey v2, including writing INI files, creating sections, and
 * configuration management.
 * 
 * @description Examples of writing INI configuration files
 * @author AHK v2 Examples Collection
 * @version 1.0.0
 * @date 2024-01-15
 */

; ============================================================================
; EXAMPLE 1: Basic INI Writing
; ============================================================================

Example1_BasicIniWrite() {
    MsgBox "=== Example 1: Basic INI Writing ===`n`n" .
        "Creating an INI configuration file..."

    iniFile := A_ScriptDir . "\basic_config.ini"

    try {
        FileDelete iniFile
    }

    ; Write application settings
    IniWrite "SuperApp", iniFile, "Application", "Name"
    IniWrite "1.0.0", iniFile, "Application", "Version"
    IniWrite "Acme Corporation", iniFile, "Application", "Publisher"
    IniWrite A_Now, iniFile, "Application", "CreatedDate"

    ; Write window settings
    IniWrite "1024", iniFile, "Window", "Width"
    IniWrite "768", iniFile, "Window", "Height"
    IniWrite "100", iniFile, "Window", "X"
    IniWrite "100", iniFile, "Window", "Y"
    IniWrite "false", iniFile, "Window", "Maximized"

    ; Write user preferences
    IniWrite "Light", iniFile, "Preferences", "Theme"
    IniWrite "12", iniFile, "Preferences", "FontSize"
    IniWrite "English", iniFile, "Preferences", "Language"

    result := "INI File Created Successfully!`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Location: " . iniFile . "`n`n"
    result .= "Sections Created:`n"
    result .= "  • Application (4 settings)`n"
    result .= "  • Window (5 settings)`n"
    result .= "  • Preferences (3 settings)`n"

    MsgBox result, "INI Created"
}

; ============================================================================
; EXAMPLE 2: Configuration Writer Class
; ============================================================================

class ConfigWriter {
    iniFile := ""

    __New(iniFile) {
        this.iniFile := iniFile
    }

    SetString(section, key, value) {
        IniWrite value, this.iniFile, section, key
    }

    SetInteger(section, key, value) {
        IniWrite String(value), this.iniFile, section, key
    }

    SetBoolean(section, key, value) {
        IniWrite (value ? "true" : "false"), this.iniFile, section, key
    }

    SetArray(section, key, arr) {
        joined := ""
        for item in arr {
            if (joined != "")
                joined .= ","
            joined .= item
        }
        IniWrite joined, this.iniFile, section, key
    }

    WriteSection(section, data) {
        for key, value in data {
            if (value is Integer)
                this.SetInteger(section, key, value)
            else if (value is Array)
                this.SetArray(section, key, value)
            else
                this.SetString(section, key, value)
        }
    }
}

Example2_ConfigWriterClass() {
    MsgBox "=== Example 2: Config Writer Class ===`n`n" .
        "Using ConfigWriter class..."

    iniFile := A_ScriptDir . "\class_config.ini"

    try {
        FileDelete iniFile
    }

    writer := ConfigWriter(iniFile)

    ; Write various data types
    writer.SetString("App", "Name", "MyApplication")
    writer.SetInteger("App", "Port", 8080)
    writer.SetBoolean("App", "DebugMode", true)
    writer.SetArray("App", "AllowedHosts", ["localhost", "127.0.0.1", "192.168.1.1"])

    ; Write entire section
    dbConfig := Map(
        "Host", "localhost",
        "Port", 5432,
        "Database", "mydb",
        "SSL", true
    )

    writer.WriteSection("Database", dbConfig)

    result := "Configuration Written Successfully!`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "App Section:`n"
    result .= "  Name: MyApplication`n"
    result .= "  Port: 8080`n"
    result .= "  Debug: Enabled`n`n"
    result .= "Database Section:`n"
    result .= "  Host: localhost`n"
    result .= "  Port: 5432`n"

    MsgBox result, "Config Written"
}

; ============================================================================
; EXAMPLE 3: Template-Based Configuration
; ============================================================================

Example3_TemplateConfig() {
    MsgBox "=== Example 3: Template Configuration ===`n`n" .
        "Creating configuration from template..."

    iniFile := A_ScriptDir . "\template_output.ini"

    try {
        FileDelete iniFile
    }

    ; Template variables
    template := Map(
        "{{APP_NAME}}", "ProductionApp",
        "{{VERSION}}", "2.0.1",
        "{{DB_HOST}}", "prod-db.example.com",
        "{{DB_PORT}}", "5432",
        "{{CACHE_SIZE}}", "1024",
        "{{LOG_LEVEL}}", "INFO"
    )

    ; Write configuration using template
    IniWrite template["{{APP_NAME}}"], iniFile, "Application", "Name"
    IniWrite template["{{VERSION}}"], iniFile, "Application", "Version"

    IniWrite template["{{DB_HOST}}"], iniFile, "Database", "Host"
    IniWrite template["{{DB_PORT}}"], iniFile, "Database", "Port"

    IniWrite template["{{CACHE_SIZE}}"], iniFile, "Cache", "MaxSize"
    IniWrite template["{{LOG_LEVEL}}"], iniFile, "Logging", "Level"

    result := "Template Configuration Created:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"

    for placeholder, value in template {
        result .= placeholder . " → " . value . "`n"
    }

    MsgBox result, "Template Config"
}

; ============================================================================
; EXAMPLE 4: Batch Configuration Writing
; ============================================================================

Example4_BatchWrite() {
    MsgBox "=== Example 4: Batch Configuration Writing ===`n`n" .
        "Writing multiple configurations..."

    iniFile := A_ScriptDir . "\batch_config.ini"

    try {
        FileDelete iniFile
    }

    ; Define multiple configurations
    configs := [
        Map("section", "Server1", "key", "Host", "value", "server1.example.com"),
        Map("section", "Server1", "key", "Port", "value", "8080"),
        Map("section", "Server2", "key", "Host", "value", "server2.example.com"),
        Map("section", "Server2", "key", "Port", "value", "8081"),
        Map("section", "Server3", "key", "Host", "value", "server3.example.com"),
        Map("section", "Server3", "key", "Port", "value", "8082")
    ]

    ; Write all configurations
    for config in configs {
        IniWrite config["value"], iniFile, config["section"], config["key"]
    }

    result := "Batch Configuration Written:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Total Entries: " . configs.Length . "`n"
    result .= "Servers Configured: 3`n"

    MsgBox result, "Batch Write Complete"
}

; ============================================================================
; EXAMPLE 5: User Settings Manager
; ============================================================================

class UserSettings {
    iniFile := ""

    __New(username) {
        this.iniFile := A_ScriptDir . "\user_" . username . ".ini"
    }

    SaveProfile(profile) {
        IniWrite profile.name, this.iniFile, "Profile", "Name"
        IniWrite profile.email, this.iniFile, "Profile", "Email"
        IniWrite profile.role, this.iniFile, "Profile", "Role"
    }

    SavePreferences(prefs) {
        for key, value in prefs {
            IniWrite value, this.iniFile, "Preferences", key
        }
    }

    SaveRecentFiles(files) {
        for index, file in files {
            IniWrite file, this.iniFile, "Recent", "File" . index
        }
    }

    SaveWindowState(state) {
        IniWrite state.x, this.iniFile, "Window", "X"
        IniWrite state.y, this.iniFile, "Window", "Y"
        IniWrite state.width, this.iniFile, "Window", "Width"
        IniWrite state.height, this.iniFile, "Window", "Height"
        IniWrite state.maximized ? "true" : "false", this.iniFile, "Window", "Maximized"
    }
}

Example5_UserSettingsManager() {
    MsgBox "=== Example 5: User Settings Manager ===`n`n" .
        "Saving user-specific settings..."

    settings := UserSettings("john_doe")

    ; Save profile
    profile := Map(
        "name", "John Doe",
        "email", "john@example.com",
        "role", "Administrator"
    )
    settings.SaveProfile(profile)

    ; Save preferences
    prefs := Map(
        "Theme", "Dark",
        "FontSize", "12",
        "Language", "English",
        "AutoSave", "true"
    )
    settings.SavePreferences(prefs)

    ; Save recent files
    recentFiles := [
        "C:\Documents\project1.txt",
        "C:\Documents\project2.txt",
        "C:\Documents\notes.txt"
    ]
    settings.SaveRecentFiles(recentFiles)

    ; Save window state
    windowState := Map(
        "x", 100,
        "y", 100,
        "width", 1280,
        "height", 720,
        "maximized", false
    )
    settings.SaveWindowState(windowState)

    result := "User Settings Saved:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "User: John Doe`n"
    result .= "Profile: Saved`n"
    result .= "Preferences: 4 settings`n"
    result .= "Recent Files: 3 files`n"
    result .= "Window State: Saved`n"

    MsgBox result, "Settings Saved"
}

; ============================================================================
; EXAMPLE 6: Environment-Specific Configuration
; ============================================================================

Example6_EnvironmentConfig() {
    MsgBox "=== Example 6: Environment-Specific Config ===`n`n" .
        "Creating environment-specific configurations..."

    environments := ["Development", "Testing", "Production"]

    for env in environments {
        iniFile := A_ScriptDir . "\config_" . env . ".ini"

        try {
            FileDelete iniFile
        }

        ; Common settings
        IniWrite "MyApp", iniFile, "Application", "Name"
        IniWrite "1.0.0", iniFile, "Application", "Version"
        IniWrite env, iniFile, "Application", "Environment"

        ; Environment-specific settings
        switch env {
            case "Development":
                IniWrite "localhost", iniFile, "Database", "Host"
                IniWrite "true", iniFile, "Debug", "Enabled"
                IniWrite "DEBUG", iniFile, "Logging", "Level"

            case "Testing":
                IniWrite "test-db.example.com", iniFile, "Database", "Host"
                IniWrite "false", iniFile, "Debug", "Enabled"
                IniWrite "INFO", iniFile, "Logging", "Level"

            case "Production":
                IniWrite "prod-db.example.com", iniFile, "Database", "Host"
                IniWrite "false", iniFile, "Debug", "Enabled"
                IniWrite "ERROR", iniFile, "Logging", "Level"
        }
    }

    result := "Environment Configurations Created:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "✓ Development`n"
    result .= "✓ Testing`n"
    result .= "✓ Production`n"

    MsgBox result, "Environments Created"
}

; ============================================================================
; EXAMPLE 7: Configuration Backup System
; ============================================================================

Example7_ConfigBackup() {
    MsgBox "=== Example 7: Configuration Backup ===`n`n" .
        "Creating configuration backup..."

    iniFile := A_ScriptDir . "\current_config.ini"
    backupFile := A_ScriptDir . "\config_backup_" . A_Now . ".ini"

    ; Create current config
    try {
        FileDelete iniFile
    }

    IniWrite "Value1", iniFile, "Settings", "Key1"
    IniWrite "Value2", iniFile, "Settings", "Key2"
    IniWrite "Value3", iniFile, "Settings", "Key3"

    ; Backup by copying all values
    sections := IniRead(iniFile)
    sectionList := StrSplit(sections, "`n")

    for section in sectionList {
        if (section = "")
            continue

        keys := IniRead(iniFile, section)
        keyList := StrSplit(keys, "`n")

        for key in keyList {
            if (key = "")
                continue

            value := IniRead(iniFile, section, key)
            IniWrite value, backupFile, section, key
        }
    }

    ; Add backup metadata
    IniWrite A_Now, backupFile, "Backup", "Timestamp"
    IniWrite iniFile, backupFile, "Backup", "SourceFile"

    result := "Configuration Backup Created:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Source: " . iniFile . "`n"
    result .= "Backup: " . backupFile . "`n"
    result .= "Timestamp: " . A_Now . "`n"

    MsgBox result, "Backup Created"
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMenu() {
    menu := "
    (
    AutoHotkey v2 - IniWrite Examples
    ══════════════════════════════════

    1. Basic INI Writing
    2. Config Writer Class
    3. Template Configuration
    4. Batch Writing
    5. User Settings Manager
    6. Environment-Specific Config
    7. Configuration Backup

    0. Exit

    Select an example (1-7):
    )"

    choice := InputBox(menu, "IniWrite Examples").Value

    switch choice {
        case "1": Example1_BasicIniWrite()
        case "2": Example2_ConfigWriterClass()
        case "3": Example3_TemplateConfig()
        case "4": Example4_BatchWrite()
        case "5": Example5_UserSettingsManager()
        case "6": Example6_EnvironmentConfig()
        case "7": Example7_ConfigBackup()
        case "0": ExitApp()
        default:
            MsgBox "Invalid selection!", "Error"
            return
    }

    SetTimer(() => ShowMenu(), -1000)
}

ShowMenu()
