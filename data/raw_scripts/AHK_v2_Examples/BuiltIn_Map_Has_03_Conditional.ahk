#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Map_Has_03_Conditional.ahk
 *
 * @description Map.Has() for conditional logic and decision making
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2025-11-16
 *
 * @overview
 * Using Map.Has() for conditional operations, branching logic,
 * feature detection, and dynamic behavior based on key presence.
 */

;=============================================================================
; Example 1: Feature Toggle System
;=============================================================================

/**
 * @class FeatureToggles
 * @description Enable/disable features based on existence
 */
class FeatureToggles {
    features := Map()

    EnableFeature(name) {
        this.features.Set(name, true)
    }

    DisableFeature(name) {
        this.features.Delete(name)
    }

    IsEnabled(name) {
        return this.features.Has(name) && this.features[name]
    }

    ExecuteIfEnabled(featureName, callback) {
        if (this.IsEnabled(featureName)) {
            return callback.Call()
        }
        return "Feature not enabled"
    }
}

Example1_FeatureToggles() {
    features := FeatureToggles()

    ; Enable some features
    features.EnableFeature("darkMode")
    features.EnableFeature("notifications")

    output := "=== Feature Toggles Example ===`n`n"

    ; Check features
    output .= "Dark Mode: " (features.IsEnabled("darkMode") ? "Enabled" : "Disabled") "`n"
    output .= "Notifications: " (features.IsEnabled("notifications") ? "Enabled" : "Disabled") "`n"
    output .= "Advanced Search: " (features.IsEnabled("advancedSearch") ? "Enabled" : "Disabled") "`n`n"

    ; Execute conditionally
    result := features.ExecuteIfEnabled("darkMode", () => "Applied dark theme")
    output .= "Dark mode action: " result "`n"

    result := features.ExecuteIfEnabled("advancedSearch", () => "Running advanced search")
    output .= "Advanced search action: " result "`n"

    MsgBox(output, "Feature Toggles")
}

;=============================================================================
; Example 2: Permission-Based Logic
;=============================================================================

Example2_PermissionLogic() {
    permissions := Map(
        "read", true,
        "write", true,
        "delete", false
    )

    CanPerformAction(action) {
        return permissions.Has(action) && permissions[action]
    }

    output := "=== Permission Logic Example ===`n`n"

    actions := ["read", "write", "delete", "admin"]

    for action in actions {
        if (CanPerformAction(action))
            output .= action ": Allowed`n"
        else
            output .= action ": Denied`n"
    }

    ; Conditional execution
    output .= "`nAttempting operations:`n"

    if (CanPerformAction("read"))
        output .= "  Reading data... Success`n"

    if (CanPerformAction("write"))
        output .= "  Writing data... Success`n"

    if (!CanPerformAction("delete"))
        output .= "  Cannot delete: Permission denied`n"

    MsgBox(output, "Permission Logic")
}

;=============================================================================
; Example 3: Configuration-Based Behavior
;=============================================================================

Example3_ConfigBehavior() {
    config := Map(
        "debugMode", true,
        "cacheEnabled", true,
        "compressionLevel", 5
    )

    output := "=== Config-Based Behavior ===`n`n"

    ; Conditional logging
    LogMessage(msg) {
        if (config.Has("debugMode") && config["debugMode"])
            output .= "[DEBUG] " msg "`n"
    }

    ; Conditional caching
    GetData() {
        if (config.Has("cacheEnabled") && config["cacheEnabled"])
            return "Cached data"
        return "Fresh data"
    }

    LogMessage("Application started")
    LogMessage("Loading configuration")

    data := GetData()
    output .= "Data source: " data "`n`n"

    ; Feature availability
    output .= "Features:`n"
    output .= "  Debug logging: " (config.Has("debugMode") ? "On" : "Off") "`n"
    output .= "  Caching: " (config.Has("cacheEnabled") ? "On" : "Off") "`n"
    output .= "  Compression: " (config.Has("compressionLevel") ? "Level " config["compressionLevel"] : "Off") "`n"

    MsgBox(output, "Config Behavior")
}

;=============================================================================
; Example 4: Conditional Data Processing
;=============================================================================

Example4_ConditionalProcessing() {
    data := Map(
        "name", "John Doe",
        "email", "john@example.com",
        "premium", true
    )

    ProcessUser(userData) {
        result := "Processing user: " userData["name"] "`n"

        ; Apply premium features if available
        if (userData.Has("premium") && userData["premium"])
            result .= "  Applied premium features`n"
        else
            result .= "  Using standard features`n"

        ; Optional newsletter subscription
        if (userData.Has("newsletter") && userData["newsletter"])
            result .= "  Subscribed to newsletter`n"

        ; Optional profile picture
        if (userData.Has("profilePicture"))
            result .= "  Profile picture: " userData["profilePicture"] "`n"
        else
            result .= "  Using default avatar`n"

        return result
    }

    output := "=== Conditional Processing ===`n`n"
    output .= ProcessUser(data)

    MsgBox(output, "Conditional Processing")
}

;=============================================================================
; Example 5: Dynamic Route Selection
;=============================================================================

Example5_DynamicRouting() {
    routes := Map(
        "home", () => "Rendering home page",
        "about", () => "Rendering about page",
        "contact", () => "Rendering contact page"
    )

    Navigate(route) {
        if (routes.Has(route))
            return routes[route].Call()
        return "404 - Page not found"
    }

    output := "=== Dynamic Routing ===`n`n"

    testRoutes := ["home", "about", "products", "contact"]

    for route in testRoutes {
        result := Navigate(route)
        output .= route ": " result "`n"
    }

    MsgBox(output, "Dynamic Routing")
}

;=============================================================================
; Example 6: Conditional Defaults
;=============================================================================

Example6_ConditionalDefaults() {
    userSettings := Map(
        "theme", "dark",
        "fontSize", 14
    )

    defaultSettings := Map(
        "theme", "light",
        "fontSize", 12,
        "language", "en",
        "autoSave", true
    )

    GetSetting(key) {
        if (userSettings.Has(key))
            return userSettings[key]
        if (defaultSettings.Has(key))
            return defaultSettings[key]
        return ""
    }

    output := "=== Conditional Defaults ===`n`n"

    settings := ["theme", "fontSize", "language", "autoSave", "notifications"]

    for setting in settings {
        value := GetSetting(setting)
        source := userSettings.Has(setting) ? "(user)" : 
                 defaultSettings.Has(setting) ? "(default)" : "(not set)"
        output .= setting ": " value " " source "`n"
    }

    MsgBox(output, "Conditional Defaults")
}

;=============================================================================
; Example 7: State Machine Pattern
;=============================================================================

Example7_StateMachine() {
    state := Map()
    state.Set("current", "idle")

    transitions := Map(
        "idle", ["running", "paused"],
        "running", ["paused", "stopped"],
        "paused", ["running", "stopped"],
        "stopped", []
    )

    CanTransition(from, to) {
        if (!transitions.Has(from))
            return false
        
        allowedTransitions := transitions[from]
        for allowed in allowedTransitions {
            if (allowed = to)
                return true
        }
        return false
    }

    Transition(newState) {
        current := state["current"]
        
        if (CanTransition(current, newState)) {
            state.Set("current", newState)
            return "Transitioned from " current " to " newState
        }
        return "Cannot transition from " current " to " newState
    }

    output := "=== State Machine ===`n`n"
    output .= "Initial state: " state["current"] "`n`n"

    output .= Transition("running") "`n"
    output .= Transition("paused") "`n"
    output .= Transition("idle") "`n"  ; Should fail
    output .= Transition("running") "`n"
    output .= Transition("stopped") "`n"
    output .= Transition("running") "`n"  ; Should fail

    MsgBox(output, "State Machine")
}

;=============================================================================
; GUI Interface
;=============================================================================

CreateDemoGUI() {
    demoGui := Gui()
    demoGui.Title := "Map.Has() - Conditional Logic Examples"

    demoGui.Add("Text", "x10 y10 w480 +Center", "Conditional Logic with Map.Has()")

    demoGui.Add("Button", "x10 y40 w230 h30", "Example 1: Feature Toggles")
        .OnEvent("Click", (*) => Example1_FeatureToggles())

    demoGui.Add("Button", "x250 y40 w230 h30", "Example 2: Permissions")
        .OnEvent("Click", (*) => Example2_PermissionLogic())

    demoGui.Add("Button", "x10 y80 w230 h30", "Example 3: Config Behavior")
        .OnEvent("Click", (*) => Example3_ConfigBehavior())

    demoGui.Add("Button", "x250 y80 w230 h30", "Example 4: Processing")
        .OnEvent("Click", (*) => Example4_ConditionalProcessing())

    demoGui.Add("Button", "x10 y120 w230 h30", "Example 5: Routing")
        .OnEvent("Click", (*) => Example5_DynamicRouting())

    demoGui.Add("Button", "x250 y120 w230 h30", "Example 6: Defaults")
        .OnEvent("Click", (*) => Example6_ConditionalDefaults())

    demoGui.Add("Button", "x10 y160 w470 h30", "Example 7: State Machine")
        .OnEvent("Click", (*) => Example7_StateMachine())

    demoGui.Add("Button", "x10 y200 w470 h30", "Run All Examples")
        .OnEvent("Click", RunAll)

    RunAll(*) {
        Example1_FeatureToggles()
        Example2_PermissionLogic()
        Example3_ConfigBehavior()
        Example4_ConditionalProcessing()
        Example5_DynamicRouting()
        Example6_ConditionalDefaults()
        Example7_StateMachine()
        MsgBox("All examples completed!", "Finished")
    }

    demoGui.Show("w490 h240")
}

CreateDemoGUI()
