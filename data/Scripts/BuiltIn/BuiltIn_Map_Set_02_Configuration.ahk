#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Map_Set_02_Configuration.ahk
 * 
 * @description Map.Set() method for configuration management systems
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2025-11-16
 * 
 * @overview
 * Demonstrates using Map.Set() for managing application configurations,
 * settings, and preferences. Shows hierarchical config structures,
 * validation, defaults, and persistence patterns.
 */

;=============================================================================
; Example 1: Application Settings Management
;=============================================================================

/**
 * @class AppConfig
 * @description Manages application configuration using Maps
 */
class AppConfig {
    settings := Map()

    /**
     * @constructor
     * @description Initialize configuration with default values
     */
    __New() {
        ; Set default configuration values
        this.settings.Set("app.name", "MyApplication")
        this.settings.Set("app.version", "1.0.0")
        this.settings.Set("app.author", "Developer")

        this.settings.Set("window.width", 800)
        this.settings.Set("window.height", 600)
        this.settings.Set("window.x", 100)
        this.settings.Set("window.y", 100)
        this.settings.Set("window.maximized", false)

        this.settings.Set("editor.fontSize", 12)
        this.settings.Set("editor.fontFamily", "Consolas")
        this.settings.Set("editor.tabSize", 4)
        this.settings.Set("editor.wordWrap", true)
        this.settings.Set("editor.lineNumbers", true)

        this.settings.Set("theme.name", "Default")
        this.settings.Set("theme.darkMode", false)
        this.settings.Set("theme.accentColor", "0x0078D7")
    }

    /**
     * @method SetValue
     * @description Set a configuration value with dot notation
     * @param {String} key - Configuration key (e.g., "editor.fontSize")
     * @param {Any} value - Configuration value
     * @returns {Boolean} Success status
     */
    SetValue(key, value) {
        this.settings.Set(key, value)
        return true
    }

    /**
     * @method SetMultiple
     * @description Set multiple configuration values at once
     * @param {Map} configMap - Map of key-value pairs to set
     */
    SetMultiple(configMap) {
        for key, value in configMap {
            this.settings.Set(key, value)
        }
    }

    /**
     * @method GetValue
     * @description Retrieve a configuration value
     * @param {String} key - Configuration key
     * @param {Any} defaultValue - Default value if key doesn't exist
     * @returns {Any} Configuration value
     */
    GetValue(key, defaultValue := "") {
        return this.settings.Has(key) ? this.settings[key] : defaultValue
    }

    /**
     * @method Export
     * @description Export configuration as formatted string
     * @returns {String} Formatted configuration string
     */
    Export() {
        output := "=== Application Configuration ===`n`n"

        categories := Map()

        ; Group settings by category (prefix before first dot)
        for key, value in this.settings {
            parts := StrSplit(key, ".")
            category := parts[1]

            if (!categories.Has(category))
                categories.Set(category, Map())

            categories[category].Set(key, value)
        }

        ; Format output by category
        for category, items in categories {
            output .= "[" StrUpper(category) "]`n"
            for key, value in items {
                output .= "  " key " = " value "`n"
            }
            output .= "`n"
        }

        return output
    }
}

Example1_ConfigManagement() {
    config := AppConfig()

    ; Show default configuration
    MsgBox(config.Export(), "Default Configuration")

    ; Update some settings
    config.SetValue("window.width", 1024)
    config.SetValue("window.height", 768)
    config.SetValue("theme.darkMode", true)
    config.SetValue("editor.fontSize", 14)

    ; Show updated configuration
    MsgBox(config.Export(), "Updated Configuration")
}

;=============================================================================
; Example 2: Environment-Based Configuration
;=============================================================================

/**
 * @class EnvironmentConfig
 * @description Manages environment-specific configurations
 */
class EnvironmentConfig {
    configs := Map()
    currentEnv := "development"

    __New() {
        ; Development environment
        this.configs.Set("development", Map(
            "database.host", "localhost",
            "database.port", 3306,
            "database.name", "dev_db",
            "api.endpoint", "http://localhost:8000/api",
            "api.timeout", 30,
            "debug.enabled", true,
            "debug.verbosity", 3,
            "cache.enabled", false
        ))

        ; Staging environment
        this.configs.Set("staging", Map(
            "database.host", "staging-db.example.com",
            "database.port", 3306,
            "database.name", "staging_db",
            "api.endpoint", "https://staging-api.example.com/api",
            "api.timeout", 60,
            "debug.enabled", true,
            "debug.verbosity", 2,
            "cache.enabled", true
        ))

        ; Production environment
        this.configs.Set("production", Map(
            "database.host", "prod-db.example.com",
            "database.port", 3306,
            "database.name", "production_db",
            "api.endpoint", "https://api.example.com/api",
            "api.timeout", 90,
            "debug.enabled", false,
            "debug.verbosity", 0,
            "cache.enabled", true
        ))
    }

    /**
     * @method SetEnvironment
     * @description Switch to a different environment
     * @param {String} env - Environment name
     */
    SetEnvironment(env) {
        if (this.configs.Has(env)) {
            this.currentEnv := env
            return true
        }
        return false
    }

    /**
     * @method Get
     * @description Get configuration value for current environment
     * @param {String} key - Configuration key
     * @returns {Any} Configuration value
     */
    Get(key) {
        envConfig := this.configs[this.currentEnv]
        return envConfig.Has(key) ? envConfig[key] : ""
    }

    /**
     * @method Display
     * @description Display current environment configuration
     * @returns {String} Formatted configuration
     */
    Display() {
        output := "=== " StrUpper(this.currentEnv) " Environment ===`n`n"

        envConfig := this.configs[this.currentEnv]
        for key, value in envConfig {
            output .= key ": " value "`n"
        }

        return output
    }
}

Example2_EnvironmentConfig() {
    envConfig := EnvironmentConfig()

    ; Show all environments
    for env in ["development", "staging", "production"] {
        envConfig.SetEnvironment(env)
        MsgBox(envConfig.Display(), "Environment Configuration")
    }
}

;=============================================================================
; Example 3: User Preferences with Validation
;=============================================================================

/**
 * @class UserPreferences
 * @description Manages user preferences with validation
 */
class UserPreferences {
    prefs := Map()
    validators := Map()

    __New() {
        this.InitializeDefaults()
        this.SetupValidators()
    }

    InitializeDefaults() {
        this.prefs.Set("volume", 50)
        this.prefs.Set("brightness", 75)
        this.prefs.Set("notifications", true)
        this.prefs.Set("language", "en")
        this.prefs.Set("autoUpdate", true)
        this.prefs.Set("startWithWindows", false)
    }

    SetupValidators() {
        ; Volume: 0-100
        this.validators.Set("volume", (val) => (val >= 0 && val <= 100))

        ; Brightness: 0-100
        this.validators.Set("brightness", (val) => (val >= 0 && val <= 100))

        ; Notifications: boolean
        this.validators.Set("notifications", (val) => (Type(val) = "Integer" && (val = 0 || val = 1)))

        ; Language: specific codes
        this.validators.Set("language", (val) => (val ~= "i)^(en|es|fr|de|it|pt|ja|zh)$"))

        ; Boolean preferences
        this.validators.Set("autoUpdate", (val) => (Type(val) = "Integer" && (val = 0 || val = 1)))
        this.validators.Set("startWithWindows", (val) => (Type(val) = "Integer" && (val = 0 || val = 1)))
    }

    /**
     * @method SetPreference
     * @description Set preference with validation
     * @param {String} key - Preference key
     * @param {Any} value - Preference value
     * @returns {Object} {success: Boolean, message: String}
     */
    SetPreference(key, value) {
        ; Check if validator exists for this key
        if (this.validators.Has(key)) {
            validator := this.validators[key]
            if (!validator.Call(value)) {
                return { success: false, message: "Invalid value for " key }
            }
        }

        ; Set the preference
        this.prefs.Set(key, value)
        return { success: true, message: "Preference set successfully" }
    }

    /**
     * @method GetAll
     * @description Get all preferences
     * @returns {Map} All preferences
     */
    GetAll() {
        return this.prefs
    }
}

Example3_ValidatedPreferences() {
    userPrefs := UserPreferences()

    output := "=== User Preferences (Validated) ===`n`n"

    ; Try valid values
    result := userPrefs.SetPreference("volume", 75)
    output .= "Set volume to 75: " (result.success ? "SUCCESS" : "FAILED - " result.message) "`n"

    result := userPrefs.SetPreference("brightness", 50)
    output .= "Set brightness to 50: " (result.success ? "SUCCESS" : "FAILED - " result.message) "`n"

    result := userPrefs.SetPreference("language", "es")
    output .= "Set language to 'es': " (result.success ? "SUCCESS" : "FAILED - " result.message) "`n"

    ; Try invalid values
    result := userPrefs.SetPreference("volume", 150)
    output .= "Set volume to 150: " (result.success ? "SUCCESS" : "FAILED - " result.message) "`n"

    result := userPrefs.SetPreference("language", "invalid")
    output .= "Set language to 'invalid': " (result.success ? "SUCCESS" : "FAILED - " result.message) "`n"

    output .= "`n=== Current Preferences ===`n"
    for key, value in userPrefs.GetAll() {
        output .= key ": " value "`n"
    }

    MsgBox(output, "Validated Preferences")
}

;=============================================================================
; Example 4: Hierarchical Configuration with Inheritance
;=============================================================================

/**
 * @class HierarchicalConfig
 * @description Configuration with inheritance (defaults -> user -> runtime)
 */
class HierarchicalConfig {
    defaults := Map()
    user := Map()
    runtime := Map()

    __New() {
        ; Default configuration
        this.defaults.Set("connection.timeout", 30)
        this.defaults.Set("connection.retries", 3)
        this.defaults.Set("ui.theme", "light")
        this.defaults.Set("ui.animations", true)
        this.defaults.Set("performance.cacheSize", 100)
        this.defaults.Set("performance.threads", 4)
    }

    /**
     * @method SetUser
     * @description Set user-level configuration
     */
    SetUser(key, value) {
        this.user.Set(key, value)
    }

    /**
     * @method SetRuntime
     * @description Set runtime configuration (temporary)
     */
    SetRuntime(key, value) {
        this.runtime.Set(key, value)
    }

    /**
     * @method Get
     * @description Get value with inheritance: runtime -> user -> defaults
     */
    Get(key) {
        if (this.runtime.Has(key))
            return this.runtime[key]
        if (this.user.Has(key))
            return this.user[key]
        if (this.defaults.Has(key))
            return this.defaults[key]
        return ""
    }

    /**
     * @method ShowInheritance
     * @description Display configuration inheritance
     */
    ShowInheritance(key) {
        output := "Configuration for '" key "':`n`n"

        if (this.defaults.Has(key))
            output .= "Default: " this.defaults[key] "`n"
        else
            output .= "Default: (not set)`n"

        if (this.user.Has(key))
            output .= "User: " this.user[key] "`n"
        else
            output .= "User: (not set)`n"

        if (this.runtime.Has(key))
            output .= "Runtime: " this.runtime[key] "`n"
        else
            output .= "Runtime: (not set)`n"

        output .= "`nFinal value: " this.Get(key)

        return output
    }
}

Example4_HierarchicalConfig() {
    config := HierarchicalConfig()

    ; Show default
    output := config.ShowInheritance("ui.theme") "`n`n---`n`n"

    ; Set user preference
    config.SetUser("ui.theme", "dark")
    output .= config.ShowInheritance("ui.theme") "`n`n---`n`n"

    ; Set runtime override
    config.SetRuntime("ui.theme", "high-contrast")
    output .= config.ShowInheritance("ui.theme")

    MsgBox(output, "Configuration Inheritance")
}

;=============================================================================
; Example 5: Feature Flags System
;=============================================================================

/**
 * @class FeatureFlags
 * @description Manage feature flags for gradual rollout
 */
class FeatureFlags {
    flags := Map()
    rolloutPercentages := Map()

    __New() {
        ; Initialize feature flags
        this.EnableFeature("new_ui", false, 0)
        this.EnableFeature("advanced_search", true, 100)
        this.EnableFeature("dark_mode", true, 100)
        this.EnableFeature("experimental_ai", false, 25)
        this.EnableFeature("beta_export", false, 50)
    }

    /**
     * @method EnableFeature
     * @description Enable/disable a feature with rollout percentage
     */
    EnableFeature(featureName, enabled, rolloutPercent := 100) {
        this.flags.Set(featureName, Map(
            "enabled", enabled,
            "rollout", rolloutPercent,
            "enabledAt", A_Now
        ))
    }

    /**
     * @method IsEnabled
     * @description Check if feature is enabled for user
     */
    IsEnabled(featureName, userId := 0) {
        if (!this.flags.Has(featureName))
            return false

        feature := this.flags[featureName]

        if (!feature["enabled"])
            return false

        ; Check rollout percentage
        if (feature["rollout"] = 100)
            return true

        ; Simulate user-based rollout (deterministic based on userId)
        userHash := Mod(userId * 31337, 100)
        return userHash < feature["rollout"]
    }

    /**
     * @method ListFeatures
     * @description List all features and their status
     */
    ListFeatures() {
        output := "=== Feature Flags ===`n`n"

        for featureName, feature in this.flags {
            status := feature["enabled"] ? "ENABLED" : "DISABLED"
            output .= featureName ": " status " (Rollout: " feature["rollout"] "%)`n"
        }

        return output
    }
}

Example5_FeatureFlags() {
    features := FeatureFlags()

    output := features.ListFeatures()
    output .= "`n=== User Feature Access ===`n`n"

    ; Test for different users
    for userId in [1, 50, 100, 500, 1000] {
        output .= "User " userId ":`n"
        output .= "  new_ui: " (features.IsEnabled("new_ui", userId) ? "Yes" : "No") "`n"
        output .= "  experimental_ai: " (features.IsEnabled("experimental_ai", userId) ? "Yes" : "No") "`n"
        output .= "  beta_export: " (features.IsEnabled("beta_export", userId) ? "Yes" : "No") "`n"
        output .= "`n"
    }

    MsgBox(output, "Feature Flags System")
}

;=============================================================================
; Example 6: Configuration Profiles
;=============================================================================

/**
 * @class ConfigProfiles
 * @description Manage different configuration profiles
 */
class ConfigProfiles {
    profiles := Map()
    currentProfile := "default"

    __New() {
        ; Create default profiles
        this.CreateProfile("default", Map(
            "performance", "balanced",
            "quality", "medium",
            "effects", true
        ))

        this.CreateProfile("performance", Map(
            "performance", "high",
            "quality", "low",
            "effects", false
        ))

        this.CreateProfile("quality", Map(
            "performance", "low",
            "quality", "ultra",
            "effects", true
        ))

        this.CreateProfile("power-saver", Map(
            "performance", "low",
            "quality", "low",
            "effects", false
        ))
    }

    CreateProfile(name, settings) {
        this.profiles.Set(name, settings)
    }

    SwitchProfile(name) {
        if (this.profiles.Has(name)) {
            this.currentProfile := name
            return true
        }
        return false
    }

    GetCurrentSettings() {
        return this.profiles[this.currentProfile]
    }

    ListProfiles() {
        output := "=== Available Profiles ===`n`n"

        for profileName, settings in this.profiles {
            current := (profileName = this.currentProfile) ? " [ACTIVE]" : ""
            output .= profileName current ":`n"

            for key, value in settings {
                output .= "  " key ": " value "`n"
            }
            output .= "`n"
        }

        return output
    }
}

Example6_ConfigProfiles() {
    profiles := ConfigProfiles()

    MsgBox(profiles.ListProfiles(), "Configuration Profiles")

    profiles.SwitchProfile("performance")
    MsgBox(profiles.ListProfiles(), "Switched to Performance Profile")
}

;=============================================================================
; Example 7: Config Change Tracking
;=============================================================================

/**
 * @class TrackedConfig
 * @description Configuration with change history
 */
class TrackedConfig {
    config := Map()
    history := []

    SetConfig(key, value, reason := "") {
        oldValue := this.config.Has(key) ? this.config[key] : "(not set)"

        this.config.Set(key, value)

        this.history.Push(Map(
            "key", key,
            "oldValue", oldValue,
            "newValue", value,
            "reason", reason,
            "timestamp", A_Now
        ))
    }

    GetHistory() {
        output := "=== Configuration Change History ===`n`n"

        for change in this.history {
            output .= FormatTime(change["timestamp"], "yyyy-MM-dd HH:mm:ss") ": "
            output .= change["key"] " changed from '" change["oldValue"] "' to '" change["newValue"] "'"
            if (change["reason"] != "")
                output .= " (" change["reason"] ")"
            output .= "`n"
        }

        return output
    }
}

Example7_ConfigTracking() {
    config := TrackedConfig()

    config.SetConfig("theme", "light", "Initial setup")
    config.SetConfig("fontSize", 12, "Initial setup")
    config.SetConfig("theme", "dark", "User preference")
    config.SetConfig("fontSize", 14, "Accessibility")
    config.SetConfig("theme", "light", "User changed back")

    MsgBox(config.GetHistory(), "Configuration History")
}

;=============================================================================
; GUI Interface
;=============================================================================

CreateDemoGUI() {
    demoGui := Gui()
    demoGui.Title := "Map.Set() - Configuration Management Examples"

    demoGui.Add("Text", "x10 y10 w480 +Center", "Configuration Management with Map.Set()")

    demoGui.Add("Button", "x10 y40 w230 h30", "Example 1: App Config")
        .OnEvent("Click", (*) => Example1_ConfigManagement())

    demoGui.Add("Button", "x250 y40 w230 h30", "Example 2: Environments")
        .OnEvent("Click", (*) => Example2_EnvironmentConfig())

    demoGui.Add("Button", "x10 y80 w230 h30", "Example 3: Validated Prefs")
        .OnEvent("Click", (*) => Example3_ValidatedPreferences())

    demoGui.Add("Button", "x250 y80 w230 h30", "Example 4: Hierarchical")
        .OnEvent("Click", (*) => Example4_HierarchicalConfig())

    demoGui.Add("Button", "x10 y120 w230 h30", "Example 5: Feature Flags")
        .OnEvent("Click", (*) => Example5_FeatureFlags())

    demoGui.Add("Button", "x250 y120 w230 h30", "Example 6: Profiles")
        .OnEvent("Click", (*) => Example6_ConfigProfiles())

    demoGui.Add("Button", "x10 y160 w470 h30", "Example 7: Change Tracking")
        .OnEvent("Click", (*) => Example7_ConfigTracking())

    demoGui.Add("Button", "x10 y200 w470 h30", "Run All Examples")
        .OnEvent("Click", RunAll)

    RunAll(*) {
        Example1_ConfigManagement()
        Example2_EnvironmentConfig()
        Example3_ValidatedPreferences()
        Example4_HierarchicalConfig()
        Example5_FeatureFlags()
        Example6_ConfigProfiles()
        Example7_ConfigTracking()
        MsgBox("All configuration examples completed!", "Finished")
    }

    demoGui.Show("w490 h240")
}

CreateDemoGUI()
