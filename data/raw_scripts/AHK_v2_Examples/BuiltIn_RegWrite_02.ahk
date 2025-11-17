#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 Registry Write Examples - Part 2
 * ============================================================================
 *
 * This file demonstrates advanced registry writing scenarios including
 * version control, setting profiles, and configuration synchronization.
 *
 * @description Advanced registry writing techniques
 * @author AHK v2 Examples Collection
 * @version 1.0.0
 * @date 2024-01-15
 */

; ============================================================================
; EXAMPLE 1: Configuration Version Control
; ============================================================================

/**
 * @class ConfigVersionControl
 * @description Manages configuration versions in registry
 */
class ConfigVersionControl {
    baseKey := ""
    currentVersion := 1

    __New(baseKey) {
        this.baseKey := baseKey
        this.LoadCurrentVersion()
    }

    /**
     * @method LoadCurrentVersion
     * @description Loads the current version number
     */
    LoadCurrentVersion() {
        try {
            this.currentVersion := RegRead(this.baseKey, "ConfigVersion")
        } catch {
            this.currentVersion := 1
        }
    }

    /**
     * @method SaveConfig
     * @description Saves configuration with version tracking
     * @param {Map} config - Configuration data
     * @returns {Boolean} Success status
     */
    SaveConfig(config) {
        try {
            ; Increment version
            this.currentVersion++

            ; Save version number
            RegWrite this.currentVersion, "REG_DWORD", this.baseKey, "ConfigVersion"

            ; Save timestamp
            RegWrite A_Now, "REG_SZ", this.baseKey, "LastModified"

            ; Save configuration values
            for key, value in config {
                if (value is Integer)
                    RegWrite value, "REG_DWORD", this.baseKey, key
                else
                    RegWrite value, "REG_SZ", this.baseKey, key
            }

            ; Archive this version
            this.ArchiveVersion(config)

            return true
        } catch {
            return false
        }
    }

    /**
     * @method ArchiveVersion
     * @description Archives a configuration version
     * @param {Map} config - Configuration to archive
     */
    ArchiveVersion(config) {
        archiveKey := this.baseKey . "\Archive\v" . this.currentVersion

        try {
            for key, value in config {
                if (value is Integer)
                    RegWrite value, "REG_DWORD", archiveKey, key
                else
                    RegWrite value, "REG_SZ", archiveKey, key
            }

            RegWrite A_Now, "REG_SZ", archiveKey, "ArchivedAt"
        }
    }

    /**
     * @method GetVersionHistory
     * @description Gets version history report
     * @returns {String} Formatted history
     */
    GetVersionHistory() {
        history := "Configuration Version History:`n"
        history .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
        history .= "Current Version: " . this.currentVersion . "`n`n"

        try {
            Loop Reg, this.baseKey . "\Archive", "K"
            {
                versionKey := this.baseKey . "\Archive\" . A_LoopRegName
                try {
                    timestamp := RegRead(versionKey, "ArchivedAt")
                    history .= A_LoopRegName . " - " . timestamp . "`n"
                } catch {
                    history .= A_LoopRegName . "`n"
                }
            }
        }

        return history
    }
}

/**
 * @function Example1_VersionControl
 * @description Demonstrates configuration version control
 * @returns {void}
 */
Example1_VersionControl() {
    MsgBox "=== Example 1: Configuration Version Control ===`n`n" .
           "Managing configuration versions..."

    vcs := ConfigVersionControl("HKCU\Software\AHKv2Examples\VersionedConfig")

    ; Save version 1
    config1 := Map("Setting1", "Value A", "Setting2", 100, "Theme", "Light")
    vcs.SaveConfig(config1)
    MsgBox "Saved configuration version 1", "Version 1"

    ; Save version 2
    config2 := Map("Setting1", "Value B", "Setting2", 200, "Theme", "Dark")
    vcs.SaveConfig(config2)
    MsgBox "Saved configuration version 2", "Version 2"

    ; Save version 3
    config3 := Map("Setting1", "Value C", "Setting2", 300, "Theme", "Auto")
    vcs.SaveConfig(config3)
    MsgBox "Saved configuration version 3", "Version 3"

    ; Show history
    history := vcs.GetVersionHistory()
    MsgBox history, "Version History"
}

; ============================================================================
; EXAMPLE 2: Multi-Profile Settings Manager
; ============================================================================

/**
 * @class ProfileManager
 * @description Manages multiple configuration profiles
 */
class ProfileManager {
    baseKey := ""
    activeProfile := "Default"

    __New(baseKey) {
        this.baseKey := baseKey
        this.LoadActiveProfile()
    }

    /**
     * @method LoadActiveProfile
     * @description Loads the active profile name
     */
    LoadActiveProfile() {
        try {
            this.activeProfile := RegRead(this.baseKey, "ActiveProfile")
        } catch {
            this.activeProfile := "Default"
        }
    }

    /**
     * @method CreateProfile
     * @description Creates a new profile
     * @param {String} profileName - Profile name
     * @param {Map} settings - Profile settings
     * @returns {Boolean} Success status
     */
    CreateProfile(profileName, settings) {
        profileKey := this.baseKey . "\Profiles\" . profileName

        try {
            ; Save profile metadata
            RegWrite A_Now, "REG_SZ", profileKey, "CreatedAt"
            RegWrite A_Now, "REG_SZ", profileKey, "ModifiedAt"

            ; Save settings
            for key, value in settings {
                if (value is Integer)
                    RegWrite value, "REG_DWORD", profileKey, key
                else
                    RegWrite value, "REG_SZ", profileKey, key
            }

            return true
        } catch {
            return false
        }
    }

    /**
     * @method SwitchProfile
     * @description Switches to a different profile
     * @param {String} profileName - Profile name
     * @returns {Boolean} Success status
     */
    SwitchProfile(profileName) {
        profileKey := this.baseKey . "\Profiles\" . profileName

        ; Check if profile exists
        try {
            RegRead(profileKey, "CreatedAt")
        } catch {
            return false  ; Profile doesn't exist
        }

        try {
            RegWrite profileName, "REG_SZ", this.baseKey, "ActiveProfile"
            this.activeProfile := profileName
            return true
        } catch {
            return false
        }
    }

    /**
     * @method GetProfileSettings
     * @description Gets settings for a specific profile
     * @param {String} profileName - Profile name
     * @returns {Map} Profile settings
     */
    GetProfileSettings(profileName) {
        profileKey := this.baseKey . "\Profiles\" . profileName
        settings := Map()

        try {
            Loop Reg, profileKey, "V"
            {
                try {
                    valueName := A_LoopRegName
                    if (valueName != "CreatedAt" && valueName != "ModifiedAt") {
                        settings[valueName] := RegRead(profileKey, valueName)
                    }
                } catch {
                    ; Skip inaccessible values
                }
            }
        }

        return settings
    }

    /**
     * @method ListProfiles
     * @description Lists all available profiles
     * @returns {Array} Profile names
     */
    ListProfiles() {
        profiles := []

        try {
            Loop Reg, this.baseKey . "\Profiles", "K"
            {
                profiles.Push(A_LoopRegName)
            }
        }

        return profiles
    }

    /**
     * @method GetReport
     * @description Gets formatted profile report
     * @returns {String} Formatted report
     */
    GetReport() {
        report := "Profile Manager Report:`n"
        report .= "━━━━━━━━━━━━━━━━━━━━━━`n"
        report .= "Active Profile: " . this.activeProfile . "`n`n"

        profiles := this.ListProfiles()
        report .= "Available Profiles (" . profiles.Length . "):`n"

        for profile in profiles {
            isActive := (profile = this.activeProfile) ? " [ACTIVE]" : ""
            report .= "  • " . profile . isActive . "`n"

            ; Show settings count
            settings := this.GetProfileSettings(profile)
            report .= "    Settings: " . settings.Count . "`n"
        }

        return report
    }
}

/**
 * @function Example2_ProfileManager
 * @description Demonstrates multi-profile management
 * @returns {void}
 */
Example2_ProfileManager() {
    MsgBox "=== Example 2: Profile Manager ===`n`n" .
           "Managing multiple configuration profiles..."

    pm := ProfileManager("HKCU\Software\AHKv2Examples\Profiles")

    ; Create profiles
    homeSettings := Map("Theme", "Light", "FontSize", 12, "ShowToolbar", 1)
    pm.CreateProfile("Home", homeSettings)

    workSettings := Map("Theme", "Dark", "FontSize", 10, "ShowToolbar", 0)
    pm.CreateProfile("Work", workSettings)

    gamingSettings := Map("Theme", "Dark", "FontSize", 14, "ShowToolbar", 0)
    pm.CreateProfile("Gaming", gamingSettings)

    ; Show report
    report := pm.GetReport()
    MsgBox report, "Profiles"

    ; Switch profiles
    pm.SwitchProfile("Work")
    MsgBox "Switched to Work profile", "Profile Changed"

    ; Show updated report
    report := pm.GetReport()
    MsgBox report, "Updated Profiles"
}

; ============================================================================
; EXAMPLE 3: Settings Synchronization
; ============================================================================

/**
 * @class SettingsSync
 * @description Synchronizes settings between different locations
 */
class SettingsSync {
    sourceKey := ""
    targetKey := ""
    syncLog := []

    __New(sourceKey, targetKey) {
        this.sourceKey := sourceKey
        this.targetKey := targetKey
    }

    /**
     * @method Sync
     * @description Synchronizes settings from source to target
     * @param {Boolean} bidirectional - Enable bidirectional sync
     * @returns {Integer} Number of synced items
     */
    Sync(bidirectional := false) {
        this.syncLog := []
        syncedCount := 0

        ; Sync from source to target
        try {
            Loop Reg, this.sourceKey, "V"
            {
                try {
                    valueName := A_LoopRegName
                    value := RegRead(this.sourceKey, valueName)

                    ; Write to target
                    RegWrite value, "REG_SZ", this.targetKey, valueName

                    this.syncLog.Push(Map(
                        "direction", "source → target",
                        "name", valueName,
                        "value", value,
                        "status", "Success"
                    ))

                    syncedCount++
                } catch Error as err {
                    this.syncLog.Push(Map(
                        "direction", "source → target",
                        "name", A_LoopRegName,
                        "status", "Failed",
                        "error", err.Message
                    ))
                }
            }
        }

        ; Bidirectional sync
        if (bidirectional) {
            try {
                Loop Reg, this.targetKey, "V"
                {
                    valueName := A_LoopRegName

                    ; Check if value exists in source
                    try {
                        RegRead(this.sourceKey, valueName)
                    } catch {
                        ; Value doesn't exist in source, sync from target
                        try {
                            value := RegRead(this.targetKey, valueName)
                            RegWrite value, "REG_SZ", this.sourceKey, valueName

                            this.syncLog.Push(Map(
                                "direction", "target → source",
                                "name", valueName,
                                "value", value,
                                "status", "Success"
                            ))

                            syncedCount++
                        }
                    }
                }
            }
        }

        return syncedCount
    }

    /**
     * @method GetSyncReport
     * @description Gets synchronization report
     * @returns {String} Formatted report
     */
    GetSyncReport() {
        report := "Settings Synchronization Report:`n"
        report .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
        report .= "Source: " . this.sourceKey . "`n"
        report .= "Target: " . this.targetKey . "`n"
        report .= "Operations: " . this.syncLog.Length . "`n`n"

        for entry in this.syncLog {
            status := entry["status"] = "Success" ? "✓" : "✗"
            report .= status . " " . entry["direction"] . " " . entry["name"] . "`n"

            if (entry["status"] = "Failed" && entry.Has("error"))
                report .= "  Error: " . entry["error"] . "`n"
        }

        return report
    }
}

/**
 * @function Example3_SettingsSync
 * @description Demonstrates settings synchronization
 * @returns {void}
 */
Example3_SettingsSync() {
    MsgBox "=== Example 3: Settings Synchronization ===`n`n" .
           "Synchronizing settings between locations..."

    sourceKey := "HKCU\Software\AHKv2Examples\SyncSource"
    targetKey := "HKCU\Software\AHKv2Examples\SyncTarget"

    ; Create source settings
    try {
        RegWrite "Source Value 1", "REG_SZ", sourceKey, "Setting1"
        RegWrite "Source Value 2", "REG_SZ", sourceKey, "Setting2"
        RegWrite 100, "REG_DWORD", sourceKey, "Counter"
    }

    ; Perform sync
    sync := SettingsSync(sourceKey, targetKey)
    syncedCount := sync.Sync(false)

    report := sync.GetSyncReport()
    MsgBox report, "Sync Complete (" . syncedCount . " items)"
}

; ============================================================================
; EXAMPLE 4: Feature Flags System
; ============================================================================

/**
 * @class FeatureFlags
 * @description Manages feature flags in registry
 */
class FeatureFlags {
    flagsKey := ""

    __New(flagsKey) {
        this.flagsKey := flagsKey
    }

    /**
     * @method EnableFeature
     * @description Enables a feature flag
     * @param {String} featureName - Feature name
     * @param {String} description - Feature description
     * @returns {Boolean} Success status
     */
    EnableFeature(featureName, description := "") {
        try {
            RegWrite 1, "REG_DWORD", this.flagsKey, featureName

            if (description != "")
                RegWrite description, "REG_SZ", this.flagsKey, featureName . "_Description"

            RegWrite A_Now, "REG_SZ", this.flagsKey, featureName . "_EnabledAt"

            return true
        } catch {
            return false
        }
    }

    /**
     * @method DisableFeature
     * @description Disables a feature flag
     * @param {String} featureName - Feature name
     * @returns {Boolean} Success status
     */
    DisableFeature(featureName) {
        try {
            RegWrite 0, "REG_DWORD", this.flagsKey, featureName
            RegWrite A_Now, "REG_SZ", this.flagsKey, featureName . "_DisabledAt"
            return true
        } catch {
            return false
        }
    }

    /**
     * @method IsEnabled
     * @description Checks if a feature is enabled
     * @param {String} featureName - Feature name
     * @returns {Boolean} Enabled status
     */
    IsEnabled(featureName) {
        try {
            value := RegRead(this.flagsKey, featureName)
            return (value = 1)
        } catch {
            return false
        }
    }

    /**
     * @method SetFeatureRollout
     * @description Sets feature rollout percentage
     * @param {String} featureName - Feature name
     * @param {Integer} percentage - Rollout percentage (0-100)
     * @returns {Boolean} Success status
     */
    SetFeatureRollout(featureName, percentage) {
        if (percentage < 0 || percentage > 100)
            return false

        try {
            RegWrite percentage, "REG_DWORD", this.flagsKey, featureName . "_Rollout"
            return true
        } catch {
            return false
        }
    }

    /**
     * @method GetAllFeatures
     * @description Gets all feature flags
     * @returns {String} Formatted feature list
     */
    GetAllFeatures() {
        features := Map()

        try {
            Loop Reg, this.flagsKey, "V"
            {
                valueName := A_LoopRegName

                ; Skip metadata fields
                if (InStr(valueName, "_Description") || InStr(valueName, "_EnabledAt") ||
                    InStr(valueName, "_DisabledAt") || InStr(valueName, "_Rollout"))
                    continue

                try {
                    enabled := RegRead(this.flagsKey, valueName)
                    features[valueName] := enabled
                } catch {
                    ; Skip
                }
            }
        }

        report := "Feature Flags:`n"
        report .= "━━━━━━━━━━━━━━`n`n"

        for featureName, enabled in features {
            status := enabled ? "✓ Enabled" : "✗ Disabled"
            report .= status . " " . featureName . "`n"

            ; Try to get description
            try {
                desc := RegRead(this.flagsKey, featureName . "_Description")
                if (desc != "")
                    report .= "  " . desc . "`n"
            }

            ; Try to get rollout
            try {
                rollout := RegRead(this.flagsKey, featureName . "_Rollout")
                report .= "  Rollout: " . rollout . "%`n"
            }

            report .= "`n"
        }

        return report
    }
}

/**
 * @function Example4_FeatureFlags
 * @description Demonstrates feature flags system
 * @returns {void}
 */
Example4_FeatureFlags() {
    MsgBox "=== Example 4: Feature Flags ===`n`n" .
           "Managing feature flags..."

    flags := FeatureFlags("HKCU\Software\AHKv2Examples\FeatureFlags")

    ; Enable features
    flags.EnableFeature("DarkMode", "Enable dark theme interface")
    flags.EnableFeature("BetaSearch", "New search algorithm")
    flags.DisableFeature("LegacyImport")

    ; Set rollout percentages
    flags.SetFeatureRollout("BetaSearch", 50)
    flags.SetFeatureRollout("DarkMode", 100)

    ; Get report
    report := flags.GetAllFeatures()
    MsgBox report, "Feature Flags"
}

; ============================================================================
; EXAMPLE 5: Application State Persistence
; ============================================================================

/**
 * @function Example5_StatePersistence
 * @description Demonstrates persisting application state
 * @returns {void}
 */
Example5_StatePersistence() {
    MsgBox "=== Example 5: Application State ===`n`n" .
           "Persisting application state..."

    stateKey := "HKCU\Software\AHKv2Examples\AppState"

    ; Save window position
    try {
        RegWrite 100, "REG_DWORD", stateKey, "WindowX"
        RegWrite 100, "REG_DWORD", stateKey, "WindowY"
        RegWrite 1024, "REG_DWORD", stateKey, "WindowWidth"
        RegWrite 768, "REG_DWORD", stateKey, "WindowHeight"
        RegWrite 0, "REG_DWORD", stateKey, "IsMaximized"
    }

    ; Save UI state
    try {
        RegWrite 1, "REG_DWORD", stateKey, "ShowToolbar"
        RegWrite 1, "REG_DWORD", stateKey, "ShowStatusBar"
        RegWrite 0, "REG_DWORD", stateKey, "ShowSidebar"
    }

    ; Save recent files
    try {
        RegWrite "C:\Documents\file1.txt", "REG_SZ", stateKey, "RecentFile1"
        RegWrite "C:\Documents\file2.txt", "REG_SZ", stateKey, "RecentFile2"
        RegWrite "C:\Documents\file3.txt", "REG_SZ", stateKey, "RecentFile3"
    }

    ; Save session info
    try {
        RegWrite A_Now, "REG_SZ", stateKey, "LastSession"
        RegWrite 5, "REG_DWORD", stateKey, "TabsOpen"
    }

    result := "Application state saved successfully!`n`n"
    result .= "Window: 100,100 (1024x768)`n"
    result .= "UI: Toolbar + StatusBar visible`n"
    result .= "Recent files: 3 items`n"
    result .= "Session: " . A_Now

    MsgBox result, "State Persisted"
}

; ============================================================================
; EXAMPLE 6: Registry-based Cache System
; ============================================================================

/**
 * @class RegistryCache
 * @description Implements a simple registry-based cache
 */
class RegistryCache {
    cacheKey := ""
    defaultTTL := 3600  ; 1 hour in seconds

    __New(cacheKey) {
        this.cacheKey := cacheKey
    }

    /**
     * @method Set
     * @description Sets a cache entry
     * @param {String} key - Cache key
     * @param {Any} value - Value to cache
     * @param {Integer} ttl - Time to live in seconds
     * @returns {Boolean} Success status
     */
    Set(key, value, ttl := 0) {
        if (ttl = 0)
            ttl := this.defaultTTL

        expiresAt := A_Now
        expiresAt := DateAdd(expiresAt, ttl, "Seconds")

        try {
            RegWrite value, "REG_SZ", this.cacheKey, key
            RegWrite expiresAt, "REG_SZ", this.cacheKey, key . "_Expires"
            return true
        } catch {
            return false
        }
    }

    /**
     * @method Get
     * @description Gets a cache entry
     * @param {String} key - Cache key
     * @param {Any} default - Default value if not found/expired
     * @returns {Any} Cached value or default
     */
    Get(key, default := "") {
        try {
            ; Check expiration
            expiresAt := RegRead(this.cacheKey, key . "_Expires")
            if (A_Now > expiresAt) {
                ; Expired, delete it
                this.Delete(key)
                return default
            }

            ; Return value
            return RegRead(this.cacheKey, key)
        } catch {
            return default
        }
    }

    /**
     * @method Delete
     * @description Deletes a cache entry
     * @param {String} key - Cache key
     */
    Delete(key) {
        try {
            RegDelete this.cacheKey, key
            RegDelete this.cacheKey, key . "_Expires"
        }
    }

    /**
     * @method Clear
     * @description Clears all cache entries
     */
    Clear() {
        try {
            RegDeleteKey this.cacheKey
        }
    }
}

/**
 * @function Example6_CacheSystem
 * @description Demonstrates registry-based caching
 * @returns {void}
 */
Example6_CacheSystem() {
    MsgBox "=== Example 6: Registry Cache ===`n`n" .
           "Demonstrating registry-based caching..."

    cache := RegistryCache("HKCU\Software\AHKv2Examples\Cache")

    ; Set cache entries
    cache.Set("UserName", "John Doe", 300)
    cache.Set("ApiToken", "abc123xyz", 600)
    cache.Set("LastUpdate", A_Now, 3600)

    ; Get cache entries
    userName := cache.Get("UserName")
    apiToken := cache.Get("ApiToken")
    lastUpdate := cache.Get("LastUpdate")

    result := "Cache Contents:`n"
    result .= "━━━━━━━━━━━━━━`n"
    result .= "UserName: " . userName . "`n"
    result .= "ApiToken: " . apiToken . "`n"
    result .= "LastUpdate: " . lastUpdate . "`n"

    MsgBox result, "Cache System"
}

; ============================================================================
; EXAMPLE 7: Settings Import/Export
; ============================================================================

/**
 * @function Example7_ImportExport
 * @description Demonstrates exporting and importing settings
 * @returns {void}
 */
Example7_ImportExport() {
    MsgBox "=== Example 7: Import/Export ===`n`n" .
           "Exporting and importing settings..."

    sourceKey := "HKCU\Software\AHKv2Examples\ExportSource"
    targetKey := "HKCU\Software\AHKv2Examples\ImportTarget"

    ; Create source settings
    try {
        RegWrite "Value 1", "REG_SZ", sourceKey, "Setting1"
        RegWrite "Value 2", "REG_SZ", sourceKey, "Setting2"
        RegWrite 42, "REG_DWORD", sourceKey, "Number"
    }

    ; Export (copy all values)
    exportData := Map()
    try {
        Loop Reg, sourceKey, "V"
        {
            try {
                exportData[A_LoopRegName] := RegRead(sourceKey, A_LoopRegName)
            }
        }
    }

    MsgBox "Exported " . exportData.Count . " settings", "Export Complete"

    ; Import to target
    imported := 0
    for key, value in exportData {
        try {
            RegWrite value, "REG_SZ", targetKey, key
            imported++
        }
    }

    MsgBox "Imported " . imported . " settings to target location", "Import Complete"
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMenu() {
    menu := "
    (
    AutoHotkey v2 - RegWrite Advanced
    ══════════════════════════════════

    1. Version Control
    2. Profile Manager
    3. Settings Sync
    4. Feature Flags
    5. State Persistence
    6. Cache System
    7. Import/Export

    0. Exit

    Select an example (1-7):
    )"

    choice := InputBox(menu, "RegWrite Advanced").Value

    switch choice {
        case "1": Example1_VersionControl()
        case "2": Example2_ProfileManager()
        case "3": Example3_SettingsSync()
        case "4": Example4_FeatureFlags()
        case "5": Example5_StatePersistence()
        case "6": Example6_CacheSystem()
        case "7": Example7_ImportExport()
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
