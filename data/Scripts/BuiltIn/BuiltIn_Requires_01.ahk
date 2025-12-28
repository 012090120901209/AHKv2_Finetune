/**
 * ============================================================================
 * AutoHotkey v2 #Requires Directive - Version Requirements
 * ============================================================================
 * 
 * @description Comprehensive examples demonstrating #Requires directive for
 *              version requirements in AutoHotkey v2 scripts
 * 
 * @author AHK v2 Documentation Team
 * @version 2.0.0
 * @date 2025-01-15
 * 
 * DIRECTIVE: #Requires
 * PURPOSE: Specifies minimum AutoHotkey version required to run the script
 * SYNTAX: #Requires AutoHotkey v2.0
 *         #Requires AutoHotkey >=v2.0-beta.1
 *         #Requires AutoHotkey v2.0.2
 * 
 * @example
 * Basic Usage:
 *   #Requires AutoHotkey v2.0
 *   ; Script will only run on AHK v2.0 or later
 * 
 * @reference https://www.autohotkey.com/docs/v2/lib/_Requires.htm
 */

#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Example 1: Basic Version Requirement
 * ============================================================================
 * 
 * @description Simple version requirement ensuring script runs on v2.0+
 * @concept Version enforcement, compatibility checking
 */

; This ensures the script only runs on AutoHotkey v2.0 or later
#Requires AutoHotkey v2.0

/**
 * Displays version information
 * @returns {void}
 */
ShowVersionInfo() {
    versionInfo := "AutoHotkey Version Information`n"
    versionInfo .= "================================`n`n"
    versionInfo .= "AHK Version: " A_AhkVersion "`n"
    versionInfo .= "AHK Path: " A_AhkPath "`n"
    versionInfo .= "Is 64-bit: " (A_PtrSize = 8 ? "Yes" : "No") "`n"
    versionInfo .= "Script Name: " A_ScriptName "`n"

    MsgBox(versionInfo, "Version Check", "Iconi")
}

; Hotkey to display version info
^!v:: ShowVersionInfo()

/**
 * ============================================================================
 * Example 2: Specific Version Requirement
 * ============================================================================
 * 
 * @description Require exact version or higher with specific release
 * @concept Precise version targeting, feature compatibility
 */

; Require AutoHotkey 2.0.2 or later (for specific bug fixes or features)
; #Requires AutoHotkey v2.0.2

/**
 * Version comparison utility
 * @param {String} required - Required version string
 * @returns {Boolean} True if current version meets requirement
 */
CheckVersion(required) {
    current := A_AhkVersion

    ; Parse version components
    ParseVersion(ver) {
        parts := StrSplit(ver, ".")
        return {
            major: Integer(parts[1] ?? 0),
            minor: Integer(parts[2] ?? 0),
            patch: Integer(parts[3] ?? 0)
        }
    }

    req := ParseVersion(required)
    cur := ParseVersion(current)

    ; Compare versions
    if (cur.major != req.major)
        return cur.major > req.major
    if (cur.minor != req.minor)
        return cur.minor > req.minor
    return cur.patch >= req.patch
}

/**
 * Validate version requirements
 * @param {String} minVersion - Minimum required version
 * @returns {void}
 */
ValidateVersion(minVersion) {
    if (!CheckVersion(minVersion)) {
        MsgBox(
            "This script requires AutoHotkey v" minVersion " or later.`n"
            "Current version: " A_AhkVersion "`n`n"
            "Please update your AutoHotkey installation.",
            "Version Error",
            "Icon! 16"
        )
        ExitApp()
    }
}

; Test version validation
^!t:: ValidateVersion("2.0.0")

/**
 * ============================================================================
 * Example 3: Beta/Pre-release Version Requirements
 * ============================================================================
 * 
 * @description Handle beta and pre-release version requirements
 * @concept Pre-release testing, early feature adoption
 */

; For scripts using beta features
; #Requires AutoHotkey >=v2.0-beta.1

/**
 * Version type detector
 * @returns {String} Version type (release, beta, alpha, rc)
 */
GetVersionType() {
    version := A_AhkVersion

    if InStr(version, "alpha")
        return "Alpha"
    else if InStr(version, "beta")
        return "Beta"
    else if InStr(version, "rc")
        return "Release Candidate"
    else
        return "Release"
}

/**
 * Display detailed version analysis
 * @returns {void}
 */
AnalyzeVersion() {
    info := "Detailed Version Analysis`n"
    info .= "=========================`n`n"
    info .= "Version String: " A_AhkVersion "`n"
    info .= "Version Type: " GetVersionType() "`n"
    info .= "Architecture: " (A_PtrSize * 8) "-bit`n"
    info .= "Unicode Support: Yes (v2 is Unicode only)`n"
    info .= "Is Compiled: " (A_IsCompiled ? "Yes" : "No") "`n"

    ; Extract version numbers
    if RegExMatch(A_AhkVersion, "(\d+)\.(\d+)\.(\d+)", &match) {
        info .= "`nVersion Components:`n"
        info .= "  Major: " match[1] "`n"
        info .= "  Minor: " match[2] "`n"
        info .= "  Patch: " match[3] "`n"
    }

    MsgBox(info, "Version Analysis", "Iconi")
}

^!a:: AnalyzeVersion()

/**
 * ============================================================================
 * Example 4: Multiple Requirement Handling
 * ============================================================================
 * 
 * @description Handle multiple version requirements and compatibility
 * @concept Version ranges, compatibility matrices
 */

/**
 * Version compatibility checker
 * @class
 */
class VersionChecker {
    /**
     * Minimum supported versions for different features
     */
    static Requirements := Map(
        "CoreFeatures", "2.0.0",
        "AdvancedGUI", "2.0.2",
        "ImprovedHotkeys", "2.0.3",
        "OptimizedMemory", "2.0.4"
    )

    /**
     * Check if feature is supported
     * @param {String} feature - Feature name
     * @returns {Boolean} True if supported
     */
    static IsFeatureSupported(feature) {
        if (!this.Requirements.Has(feature))
            return false

        required := this.Requirements[feature]
        return this.CompareVersions(A_AhkVersion, required) >= 0
    }

    /**
     * Compare two version strings
     * @param {String} v1 - First version
     * @param {String} v2 - Second version
     * @returns {Integer} -1 if v1 < v2, 0 if equal, 1 if v1 > v2
     */
    static CompareVersions(v1, v2) {
        ; Parse version components
        parts1 := StrSplit(RegExReplace(v1, "[^\d.]", ""), ".")
        parts2 := StrSplit(RegExReplace(v2, "[^\d.]", ""), ".")

        ; Compare each component
        Loop 3 {
            num1 := Integer(parts1[A_Index] ?? 0)
            num2 := Integer(parts2[A_Index] ?? 0)

            if (num1 != num2)
                return (num1 > num2) ? 1 : -1
        }

        return 0
    }

    /**
     * Get all supported features
     * @returns {Array} List of supported feature names
     */
    static GetSupportedFeatures() {
        supported := []
        for feature, version in this.Requirements {
            if this.IsFeatureSupported(feature)
                supported.Push(feature)
        }
        return supported
    }

    /**
     * Display compatibility report
     * @returns {void}
     */
    static ShowCompatibilityReport() {
        report := "Feature Compatibility Report`n"
        report .= "============================`n"
        report .= "Current Version: " A_AhkVersion "`n`n"

        for feature, required in this.Requirements {
            supported := this.IsFeatureSupported(feature)
            status := supported ? "✓ Supported" : "✗ Not Supported"
            report .= feature ": " status " (requires v" required ")`n"
        }

        MsgBox(report, "Compatibility", "Iconi")
    }
}

; Show compatibility report
^!c:: VersionChecker.ShowCompatibilityReport()

/**
 * ============================================================================
 * Example 5: Version-Dependent Feature Loading
 * ============================================================================
 * 
 * @description Conditionally load features based on version
 * @concept Feature flags, graceful degradation
 */

/**
 * Feature loader with version checking
 * @class
 */
class FeatureLoader {
    static LoadedFeatures := Map()

    /**
     * Load feature if version supports it
     * @param {String} featureName - Feature identifier
     * @param {String} minVersion - Minimum required version
     * @param {Func} loader - Function to load feature
     * @returns {Boolean} True if loaded successfully
     */
    static LoadFeature(featureName, minVersion, loader) {
        if (VersionChecker.CompareVersions(A_AhkVersion, minVersion) >= 0) {
            try {
                loader.Call()
                this.LoadedFeatures[featureName] := true
                return true
            } catch Error as err {
                MsgBox("Failed to load " featureName ": " err.Message, "Error", "Icon!")
                return false
            }
        } else {
            this.LoadedFeatures[featureName] := false
            return false
        }
    }

    /**
     * Check if feature is loaded
     * @param {String} featureName - Feature identifier
     * @returns {Boolean} True if loaded
     */
    static IsLoaded(featureName) {
        return this.LoadedFeatures.Get(featureName, false)
    }

    /**
     * Initialize all features
     * @returns {void}
     */
    static Initialize() {
        ; Load core features
        this.LoadFeature("BasicHotkeys", "2.0.0", () => this.LoadBasicHotkeys())
        this.LoadFeature("AdvancedGUI", "2.0.2", () => this.LoadAdvancedGUI())
        this.LoadFeature("Performance", "2.0.3", () => this.LoadPerformanceFeatures())

        ; Show initialization report
        this.ShowLoadReport()
    }

    /**
     * Load basic hotkey features
     * @returns {void}
     */
    static LoadBasicHotkeys() {
        ; Basic hotkey setup
        OutputDebug("Loading basic hotkeys...")
    }

    /**
     * Load advanced GUI features
     * @returns {void}
     */
    static LoadAdvancedGUI() {
        ; Advanced GUI initialization
        OutputDebug("Loading advanced GUI features...")
    }

    /**
     * Load performance optimization features
     * @returns {void}
     */
    static LoadPerformanceFeatures() {
        ; Performance optimizations
        OutputDebug("Loading performance features...")
    }

    /**
     * Display feature load report
     * @returns {void}
     */
    static ShowLoadReport() {
        report := "Feature Load Report`n"
        report .= "===================`n`n"

        for feature, loaded in this.LoadedFeatures {
            status := loaded ? "✓ Loaded" : "✗ Skipped"
            report .= feature ": " status "`n"
        }

        MsgBox(report, "Initialization", "Iconi")
    }
}

; Initialize features on startup
FeatureLoader.Initialize()

/**
 * ============================================================================
 * Example 6: Version Upgrade Migration Helper
 * ============================================================================
 * 
 * @description Help users migrate from v1 to v2 with version detection
 * @concept Migration assistance, compatibility warnings
 */

/**
 * Migration helper for v1 to v2 transition
 * @class
 */
class MigrationHelper {
    /**
     * Check for v1 syntax patterns
     * @param {String} scriptPath - Path to script file
     * @returns {Array} List of potential issues
     */
    static DetectV1Patterns(scriptPath := A_ScriptFullPath) {
        issues := []

        try {
            content := FileRead(scriptPath)

            ; Common v1 patterns
            patterns := Map(
                "Command syntax", "i)^\s*(MsgBox|FileAppend|FileRead)\s+[^,(]",
                "Expression assignment", ":=\s*%\w+%",
                "Legacy if statement", "i)^\s*if\s+\w+\s*=",
                "Old string concat", "\.=",
                "Function comma syntax", "i)^\s*\w+\(.*,\s*,.*\)"
            )

            for issue, pattern in patterns {
                if RegExMatch(content, pattern)
                    issues.Push(issue)
            }
        }

        return issues
    }

    /**
     * Show migration report
     * @returns {void}
     */
    static ShowMigrationReport() {
        issues := this.DetectV1Patterns()

        report := "AutoHotkey v2 Migration Report`n"
        report .= "==============================`n`n"
        report .= "Current Version: " A_AhkVersion "`n"
        report .= "Script: " A_ScriptName "`n`n"

        if (issues.Length = 0) {
            report .= "✓ No v1 compatibility issues detected!`n"
            report .= "This script appears to be v2 compatible."
        } else {
            report .= "⚠ Potential v1 patterns detected:`n`n"
            for issue in issues {
                report .= "  • " issue "`n"
            }
            report .= "`nPlease review these patterns for v2 compatibility."
        }

        MsgBox(report, "Migration Check", "Iconi")
    }
}

; Run migration check
^!m:: MigrationHelper.ShowMigrationReport()

/**
 * ============================================================================
 * Example 7: Runtime Version Enforcement
 * ============================================================================
 * 
 * @description Enforce version requirements at runtime with detailed errors
 * @concept Runtime validation, user-friendly error messages
 */

/**
 * Runtime version enforcement system
 * @class
 */
class VersionEnforcer {
    static MinimumVersion := "2.0.0"
    static RecommendedVersion := "2.0.2"

    /**
     * Enforce version requirements
     * @param {Boolean} strict - Exit if requirement not met
     * @returns {Boolean} True if requirements met
     */
    static Enforce(strict := true) {
        current := A_AhkVersion

        ; Check minimum version
        if (VersionChecker.CompareVersions(current, this.MinimumVersion) < 0) {
            this.ShowVersionError(current, this.MinimumVersion)
            if strict
                ExitApp(1)
            return false
        }

        ; Warn if below recommended version
        if (VersionChecker.CompareVersions(current, this.RecommendedVersion) < 0) {
            this.ShowVersionWarning(current, this.RecommendedVersion)
        }

        return true
    }

    /**
     * Display version error
     * @param {String} current - Current version
     * @param {String} required - Required version
     * @returns {void}
     */
    static ShowVersionError(current, required) {
        msg := "Version Requirement Not Met`n"
        msg .= "===========================`n`n"
        msg .= "This script requires AutoHotkey v" required " or later.`n`n"
        msg .= "Current Version: " current "`n"
        msg .= "Required Version: " required "`n`n"
        msg .= "Please download the latest version from:`n"
        msg .= "https://www.autohotkey.com/download/`n`n"
        msg .= "The script will now exit."

        MsgBox(msg, "Version Error", "Icon! 48")
    }

    /**
     * Display version warning
     * @param {String} current - Current version
     * @param {String} recommended - Recommended version
     * @returns {void}
     */
    static ShowVersionWarning(current, recommended) {
        msg := "Version Update Recommended`n"
        msg .= "==========================`n`n"
        msg .= "You are using an older version of AutoHotkey.`n`n"
        msg .= "Current Version: " current "`n"
        msg .= "Recommended Version: " recommended "`n`n"
        msg .= "Consider updating for better performance and bug fixes.`n`n"
        msg .= "Download from: https://www.autohotkey.com/download/"

        result := MsgBox(msg, "Update Available", "Icon! YesNo")

        if (result = "Yes")
            Run("https://www.autohotkey.com/download/")
    }
}

; Enforce version on startup (non-strict mode for demonstration)
VersionEnforcer.Enforce(false)

; Manual version check hotkey
^!e:: VersionEnforcer.Enforce(false)

/**
 * ============================================================================
 * UTILITY FUNCTIONS
 * ============================================================================
 */

/**
 * Show comprehensive version information
 * @returns {void}
 */
ShowCompleteVersionInfo() {
    info := "Complete AutoHotkey Information`n"
    info .= "================================`n`n"
    info .= "Version: " A_AhkVersion "`n"
    info .= "Path: " A_AhkPath "`n"
    info .= "Type: " GetVersionType() "`n"
    info .= "Bits: " (A_PtrSize * 8) "`n"
    info .= "Compiled: " (A_IsCompiled ? "Yes" : "No") "`n`n"

    info .= "Script Information:`n"
    info .= "Name: " A_ScriptName "`n"
    info .= "Directory: " A_ScriptDir "`n"
    info .= "Full Path: " A_ScriptFullPath "`n`n"

    info .= "Supported Features:`n"
    features := VersionChecker.GetSupportedFeatures()
    for feature in features {
        info .= "  ✓ " feature "`n"
    }

    MsgBox(info, "Complete Version Info", "Iconi")
}

; Hotkey for complete info
^!i:: ShowCompleteVersionInfo()

/**
 * ============================================================================
 * MAIN SCRIPT EXECUTION
 * ============================================================================
 */

; Display startup message
TrayTip("AHK Version: " A_AhkVersion, "Script Started", "Iconi Mute")

; Auto-check version on startup
if (VersionChecker.CompareVersions(A_AhkVersion, "2.0.0") >= 0) {
    OutputDebug("✓ AutoHotkey v2 detected - All features available")
}

/**
 * Exit handler
 */
OnExit(ExitHandler)
ExitHandler(ExitReason, ExitCode) {
    OutputDebug("Script exiting: " ExitReason " (Code: " ExitCode ")")
}
