/**
 * ============================================================================
 * AutoHotkey v2 #Requires Directive - Operating System Requirements
 * ============================================================================
 *
 * @description Comprehensive examples demonstrating OS-specific requirements
 *              and platform detection in AutoHotkey v2
 *
 * @author AHK v2 Documentation Team
 * @version 2.0.0
 * @date 2025-01-15
 *
 * DIRECTIVE: #Requires
 * PURPOSE: Enforce OS version requirements and platform compatibility
 * SYNTAX: #Requires AutoHotkey v2.0
 *
 * OS DETECTION VARIABLES:
 *   A_OSVersion - Windows version identifier
 *   A_PtrSize - 4 for 32-bit, 8 for 64-bit
 *   A_Is64bitOS - True if running on 64-bit Windows
 *
 * @reference https://www.autohotkey.com/docs/v2/lib/_Requires.htm
 * @reference https://www.autohotkey.com/docs/v2/Variables.htm#OS
 */

#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Example 1: Basic OS Version Detection
 * ============================================================================
 *
 * @description Detect and display Windows version information
 * @concept OS detection, platform identification
 */

/**
 * Get detailed OS information
 * @returns {Object} OS information object
 */
GetOSInfo() {
    return {
        Version: A_OSVersion,
        Is64Bit: A_Is64bitOS,
        Architecture: A_PtrSize = 8 ? "64-bit" : "32-bit",
        ComputerName: A_ComputerName,
        UserName: A_UserName,
        IsAdmin: A_IsAdmin
    }
}

/**
 * Get friendly OS name
 * @returns {String} Human-readable OS name
 */
GetOSName() {
    switch A_OSVersion {
        case "10.0.22000", "10.0.22621", "10.0.22631":
            return "Windows 11"
        case "10.0.19044", "10.0.19043", "10.0.19042", "10.0.19041":
            return "Windows 10"
        default:
            if InStr(A_OSVersion, "10.0")
                return "Windows 10/11"
            else if InStr(A_OSVersion, "6.3")
                return "Windows 8.1"
            else if InStr(A_OSVersion, "6.2")
                return "Windows 8"
            else if InStr(A_OSVersion, "6.1")
                return "Windows 7"
            else
                return "Windows (Version " A_OSVersion ")"
    }
}

/**
 * Display OS information
 * @returns {void}
 */
ShowOSInfo() {
    info := GetOSInfo()

    msg := "Operating System Information`n"
    msg .= "============================`n`n"
    msg .= "OS Name: " GetOSName() "`n"
    msg .= "OS Version: " info.Version "`n"
    msg .= "64-bit OS: " (info.Is64Bit ? "Yes" : "No") "`n"
    msg .= "Process Architecture: " info.Architecture "`n"
    msg .= "Computer Name: " info.ComputerName "`n"
    msg .= "User Name: " info.UserName "`n"
    msg .= "Admin Rights: " (info.IsAdmin ? "Yes" : "No") "`n"

    MsgBox(msg, "OS Information", "Iconi")
}

^!o::ShowOSInfo()

/**
 * ============================================================================
 * Example 2: OS Version Requirements Enforcement
 * ============================================================================
 *
 * @description Enforce minimum Windows version requirements
 * @concept Version validation, compatibility enforcement
 */

/**
 * OS requirement checker
 * @class
 */
class OSRequirements {
    static MinimumVersion := "10.0"  ; Windows 10
    static RecommendedVersion := "10.0.19041"  ; Windows 10 2004

    /**
     * Parse Windows version string
     * @param {String} version - Version string (e.g., "10.0.19041")
     * @returns {Object} Parsed version components
     */
    static ParseVersion(version) {
        parts := StrSplit(version, ".")
        return {
            Major: Integer(parts[1] ?? 0),
            Minor: Integer(parts[2] ?? 0),
            Build: Integer(parts[3] ?? 0)
        }
    }

    /**
     * Compare two OS versions
     * @param {String} v1 - First version
     * @param {String} v2 - Second version
     * @returns {Integer} -1, 0, or 1
     */
    static CompareVersions(v1, v2) {
        ver1 := this.ParseVersion(v1)
        ver2 := this.ParseVersion(v2)

        if (ver1.Major != ver2.Major)
            return (ver1.Major > ver2.Major) ? 1 : -1
        if (ver1.Minor != ver2.Minor)
            return (ver1.Minor > ver2.Minor) ? 1 : -1
        if (ver1.Build != ver2.Build)
            return (ver1.Build > ver2.Build) ? 1 : -1

        return 0
    }

    /**
     * Check if OS meets minimum requirements
     * @returns {Boolean} True if requirements met
     */
    static MeetsMinimum() {
        return this.CompareVersions(A_OSVersion, this.MinimumVersion) >= 0
    }

    /**
     * Check if OS meets recommended version
     * @returns {Boolean} True if recommended or higher
     */
    static MeetsRecommended() {
        return this.CompareVersions(A_OSVersion, this.RecommendedVersion) >= 0
    }

    /**
     * Enforce OS requirements
     * @param {Boolean} strict - Exit if not met
     * @returns {Boolean} True if requirements met
     */
    static Enforce(strict := true) {
        if (!this.MeetsMinimum()) {
            this.ShowRequirementError()
            if strict
                ExitApp(1)
            return false
        }

        if (!this.MeetsRecommended()) {
            this.ShowRecommendationWarning()
        }

        return true
    }

    /**
     * Show requirement error dialog
     * @returns {void}
     */
    static ShowRequirementError() {
        msg := "Operating System Requirement Not Met`n"
        msg .= "====================================`n`n"
        msg .= "This script requires Windows 10 or later.`n`n"
        msg .= "Current OS: " GetOSName() "`n"
        msg .= "OS Version: " A_OSVersion "`n`n"
        msg .= "Please upgrade your operating system to continue."

        MsgBox(msg, "OS Requirement Error", "Icon! 48")
    }

    /**
     * Show recommendation warning
     * @returns {void}
     */
    static ShowRecommendationWarning() {
        msg := "OS Update Recommended`n"
        msg .= "=====================`n`n"
        msg .= "For optimal performance, Windows 10 version 2004 or later is recommended.`n`n"
        msg .= "Current OS: " GetOSName() "`n"
        msg .= "Current Version: " A_OSVersion "`n"
        msg .= "Recommended: 10.0.19041 or later`n`n"
        msg .= "Some features may not work correctly on older versions."

        MsgBox(msg, "Update Recommended", "Icon! 32")
    }
}

; Check requirements on startup (non-strict for demo)
OSRequirements.Enforce(false)

^!r::OSRequirements.Enforce(false)

/**
 * ============================================================================
 * Example 3: Architecture-Specific Requirements
 * ============================================================================
 *
 * @description Handle 32-bit vs 64-bit architecture requirements
 * @concept Architecture detection, bitness validation
 */

/**
 * Architecture requirement manager
 * @class
 */
class ArchitectureChecker {
    /**
     * Get current architecture info
     * @returns {Object} Architecture details
     */
    static GetArchitecture() {
        return {
            ProcessBits: A_PtrSize * 8,
            OSBits: A_Is64bitOS ? 64 : 32,
            IsProcess64: A_PtrSize = 8,
            IsOS64: A_Is64bitOS,
            CanRun64Bit: A_Is64bitOS
        }
    }

    /**
     * Require 64-bit OS
     * @param {Boolean} strict - Exit if requirement not met
     * @returns {Boolean} True if 64-bit OS
     */
    static Require64BitOS(strict := true) {
        if (!A_Is64bitOS) {
            msg := "64-bit Operating System Required`n"
            msg .= "=================================`n`n"
            msg .= "This script requires a 64-bit version of Windows.`n`n"
            msg .= "Current OS: " (A_Is64bitOS ? "64-bit" : "32-bit") "`n"
            msg .= "Process: " (A_PtrSize * 8) "-bit`n`n"
            msg .= "Please use a 64-bit operating system."

            MsgBox(msg, "Architecture Error", "Icon! 48")

            if strict
                ExitApp(1)
            return false
        }
        return true
    }

    /**
     * Display architecture information
     * @returns {void}
     */
    static ShowArchInfo() {
        arch := this.GetArchitecture()

        msg := "Architecture Information`n"
        msg .= "========================`n`n"
        msg .= "Operating System: " arch.OSBits "-bit`n"
        msg .= "AHK Process: " arch.ProcessBits "-bit`n"
        msg .= "Pointer Size: " A_PtrSize " bytes`n`n"

        msg .= "Capabilities:`n"
        msg .= "  Can run 64-bit code: " (arch.CanRun64Bit ? "Yes" : "No") "`n"
        msg .= "  Running as 64-bit: " (arch.IsProcess64 ? "Yes" : "No") "`n`n"

        if (!arch.IsProcess64 && arch.IsOS64)
            msg .= "⚠ Note: Running 32-bit AHK on 64-bit OS"

        MsgBox(msg, "Architecture", "Iconi")
    }
}

^!b::ArchitectureChecker.ShowArchInfo()

/**
 * ============================================================================
 * Example 4: Feature Availability Based on OS Version
 * ============================================================================
 *
 * @description Check and handle OS-specific feature availability
 * @concept Feature detection, graceful degradation
 */

/**
 * OS feature detector
 * @class
 */
class OSFeatureDetector {
    /**
     * Feature requirements map
     */
    static FeatureRequirements := Map(
        "DarkMode", "10.0.17763",          ; Windows 10 1809
        "VirtualDesktops", "10.0.10240",   ; Windows 10 initial
        "TimelineAPI", "10.0.17134",       ; Windows 10 1803
        "FocusAssist", "10.0.17134",       ; Windows 10 1803
        "CloudClipboard", "10.0.17666",    ; Windows 10 1809
        "YourPhone", "10.0.17763"          ; Windows 10 1809
    )

    /**
     * Check if feature is available
     * @param {String} feature - Feature name
     * @returns {Boolean} True if available
     */
    static IsFeatureAvailable(feature) {
        if (!this.FeatureRequirements.Has(feature))
            return false

        required := this.FeatureRequirements[feature]
        return OSRequirements.CompareVersions(A_OSVersion, required) >= 0
    }

    /**
     * Get all available features
     * @returns {Array} List of available features
     */
    static GetAvailableFeatures() {
        available := []
        for feature, version in this.FeatureRequirements {
            if this.IsFeatureAvailable(feature)
                available.Push(feature)
        }
        return available
    }

    /**
     * Display feature availability report
     * @returns {void}
     */
    static ShowFeatureReport() {
        report := "OS Feature Availability Report`n"
        report .= "==============================`n"
        report .= "OS: " GetOSName() "`n"
        report .= "Version: " A_OSVersion "`n`n"

        report .= "Features:`n"
        for feature, required in this.FeatureRequirements {
            available := this.IsFeatureAvailable(feature)
            status := available ? "✓" : "✗"
            report .= status " " feature
            if !available
                report .= " (requires " required ")"
            report .= "`n"
        }

        MsgBox(report, "Feature Report", "Iconi")
    }
}

^!f::OSFeatureDetector.ShowFeatureReport()

/**
 * ============================================================================
 * Example 5: Administrator Rights Detection and Requirement
 * ============================================================================
 *
 * @description Handle administrator privilege requirements
 * @concept UAC, privilege elevation, admin detection
 */

/**
 * Administrator rights manager
 * @class
 */
class AdminManager {
    /**
     * Check if running as administrator
     * @returns {Boolean} True if admin
     */
    static IsAdmin() {
        return A_IsAdmin
    }

    /**
     * Request administrator elevation
     * @returns {void}
     */
    static RequestElevation() {
        if (this.IsAdmin())
            return

        msg := "Administrator Rights Required`n"
        msg .= "=============================`n`n"
        msg .= "This script requires administrator privileges.`n`n"
        msg .= "Would you like to restart with elevated rights?"

        result := MsgBox(msg, "Elevation Required", "Icon! YesNo")

        if (result = "Yes") {
            try {
                Run('*RunAs "' A_AhkPath '" "' A_ScriptFullPath '"')
                ExitApp()
            } catch Error as err {
                MsgBox("Failed to elevate: " err.Message, "Error", "Icon!")
            }
        }
    }

    /**
     * Require administrator rights
     * @param {Boolean} strict - Exit if not admin
     * @returns {Boolean} True if admin
     */
    static RequireAdmin(strict := false) {
        if (!this.IsAdmin()) {
            if strict {
                this.RequestElevation()
                return false
            } else {
                this.ShowAdminWarning()
                return false
            }
        }
        return true
    }

    /**
     * Show admin warning
     * @returns {void}
     */
    static ShowAdminWarning() {
        msg := "Limited Functionality Warning`n"
        msg .= "=============================`n`n"
        msg .= "This script is not running with administrator rights.`n`n"
        msg .= "Some features may not work correctly.`n`n"
        msg .= "To enable all features, run as administrator."

        MsgBox(msg, "Not Administrator", "Icon! 48")
    }

    /**
     * Display privilege information
     * @returns {void}
     */
    static ShowPrivilegeInfo() {
        msg := "Privilege Information`n"
        msg .= "=====================`n`n"
        msg .= "Administrator: " (A_IsAdmin ? "Yes" : "No") "`n"
        msg .= "User Name: " A_UserName "`n"
        msg .= "Computer: " A_ComputerName "`n`n"

        if (!A_IsAdmin) {
            msg .= "⚠ Running with limited privileges`n"
            msg .= "Some operations may be restricted."
        } else {
            msg .= "✓ Full administrator privileges available"
        }

        MsgBox(msg, "Privileges", "Iconi")
    }
}

^!p::AdminManager.ShowPrivilegeInfo()
^!+a::AdminManager.RequestElevation()

/**
 * ============================================================================
 * Example 6: Regional and Language Settings
 * ============================================================================
 *
 * @description Detect and handle regional/language requirements
 * @concept Localization, regional settings, language detection
 */

/**
 * Regional settings detector
 * @class
 */
class RegionalSettings {
    /**
     * Get regional information
     * @returns {Object} Regional settings
     */
    static GetRegionalInfo() {
        return {
            Language: A_Language,
            Locale: A_Language,  ; System locale
            TimeFormat: A_TimeFormat,
            DateFormat: A_DateFormat,
            Timezone: this.GetTimezone()
        }
    }

    /**
     * Get timezone information
     * @returns {String} Timezone description
     */
    static GetTimezone() {
        ; Calculate UTC offset
        utc := A_NowUTC
        local := A_Now

        ; This is simplified - actual calculation would be more complex
        return "System Timezone"
    }

    /**
     * Get language name
     * @param {String} langCode - Language code
     * @returns {String} Language name
     */
    static GetLanguageName(langCode := "") {
        if (langCode = "")
            langCode := A_Language

        languages := Map(
            "0409", "English (United States)",
            "0809", "English (United Kingdom)",
            "0407", "German",
            "040C", "French",
            "0410", "Italian",
            "0C0A", "Spanish",
            "0416", "Portuguese (Brazil)",
            "0411", "Japanese",
            "0804", "Chinese (Simplified)",
            "0404", "Chinese (Traditional)"
        )

        return languages.Get(langCode, "Unknown (" langCode ")")
    }

    /**
     * Display regional information
     * @returns {void}
     */
    static ShowRegionalInfo() {
        info := this.GetRegionalInfo()

        msg := "Regional Settings`n"
        msg .= "=================`n`n"
        msg .= "Language: " this.GetLanguageName() "`n"
        msg .= "Language Code: " info.Language "`n"
        msg .= "Timezone: " info.Timezone "`n`n"

        msg .= "Current Time:`n"
        msg .= "  Local: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n"
        msg .= "  UTC: " FormatTime(A_NowUTC, "yyyy-MM-dd HH:mm:ss") "`n"

        MsgBox(msg, "Regional Settings", "Iconi")
    }
}

^!l::RegionalSettings.ShowRegionalInfo()

/**
 * ============================================================================
 * Example 7: Complete System Requirements Checker
 * ============================================================================
 *
 * @description Comprehensive system requirements validation
 * @concept Complete validation, system compatibility
 */

/**
 * Complete system requirements checker
 * @class
 */
class SystemRequirements {
    static Requirements := {
        MinAHKVersion: "2.0.0",
        MinOSVersion: "10.0",
        Require64Bit: false,
        RequireAdmin: false,
        RecommendedRAM: 4,  ; GB
        RecommendedCPU: 2   ; Cores
    }

    /**
     * Check all system requirements
     * @returns {Object} Requirement check results
     */
    static CheckAll() {
        results := {
            AHKVersion: this.CheckAHKVersion(),
            OSVersion: this.CheckOSVersion(),
            Architecture: this.CheckArchitecture(),
            AdminRights: this.CheckAdminRights(),
            PassedAll: false
        }

        results.PassedAll := results.AHKVersion
                          && results.OSVersion
                          && results.Architecture
                          && results.AdminRights

        return results
    }

    /**
     * Check AHK version requirement
     * @returns {Boolean} True if requirement met
     */
    static CheckAHKVersion() {
        return VersionChecker.CompareVersions(
            A_AhkVersion,
            this.Requirements.MinAHKVersion
        ) >= 0
    }

    /**
     * Check OS version requirement
     * @returns {Boolean} True if requirement met
     */
    static CheckOSVersion() {
        return OSRequirements.CompareVersions(
            A_OSVersion,
            this.Requirements.MinOSVersion
        ) >= 0
    }

    /**
     * Check architecture requirement
     * @returns {Boolean} True if requirement met
     */
    static CheckArchitecture() {
        if (this.Requirements.Require64Bit)
            return A_Is64bitOS
        return true
    }

    /**
     * Check admin rights requirement
     * @returns {Boolean} True if requirement met
     */
    static CheckAdminRights() {
        if (this.Requirements.RequireAdmin)
            return A_IsAdmin
        return true
    }

    /**
     * Display complete requirements report
     * @returns {void}
     */
    static ShowRequirementsReport() {
        results := this.CheckAll()

        report := "System Requirements Report`n"
        report .= "==========================`n`n"

        ; AHK Version
        status := results.AHKVersion ? "✓" : "✗"
        report .= status " AutoHotkey: " A_AhkVersion
        report .= " (requires " this.Requirements.MinAHKVersion ")`n"

        ; OS Version
        status := results.OSVersion ? "✓" : "✗"
        report .= status " Windows: " GetOSName()
        report .= " (" A_OSVersion ")`n"

        ; Architecture
        status := results.Architecture ? "✓" : "✗"
        report .= status " Architecture: " (A_Is64bitOS ? "64-bit" : "32-bit")
        if (this.Requirements.Require64Bit)
            report .= " (64-bit required)"
        report .= "`n"

        ; Admin Rights
        status := results.AdminRights ? "✓" : "✗"
        report .= status " Administrator: " (A_IsAdmin ? "Yes" : "No")
        if (this.Requirements.RequireAdmin)
            report .= " (required)"
        report .= "`n`n"

        ; Overall result
        if (results.PassedAll)
            report .= "✓ All requirements met!"
        else
            report .= "✗ Some requirements not met"

        icon := results.PassedAll ? "Iconi" : "Icon!"
        MsgBox(report, "Requirements Check", icon)
    }
}

^!s::SystemRequirements.ShowRequirementsReport()

/**
 * ============================================================================
 * STARTUP VALIDATION
 * ============================================================================
 */

; Perform startup checks
StartupValidation() {
    ; Check OS compatibility
    if (!OSRequirements.MeetsMinimum()) {
        MsgBox("Incompatible OS detected. Exiting...", "Error", "Icon!")
        ExitApp(1)
    }

    ; Log startup info
    OutputDebug("=== System Information ===")
    OutputDebug("OS: " GetOSName() " (" A_OSVersion ")")
    OutputDebug("Architecture: " (A_Is64bitOS ? "64-bit" : "32-bit"))
    OutputDebug("AHK: " A_AhkVersion " (" (A_PtrSize * 8) "-bit)")
    OutputDebug("Admin: " (A_IsAdmin ? "Yes" : "No"))
    OutputDebug("========================")
}

; Run validation
StartupValidation()

; Display ready message
TrayTip("OS: " GetOSName(), "Script Ready", "Iconi Mute")

/**
 * Help hotkey
 */
^!h::{
    help := "OS Requirements Script - Hotkeys`n"
    help .= "================================`n`n"
    help .= "^!o - Show OS Information`n"
    help .= "^!r - Check OS Requirements`n"
    help .= "^!b - Show Architecture Info`n"
    help .= "^!f - Show Feature Report`n"
    help .= "^!p - Show Privilege Info`n"
    help .= "^!+a - Request Admin Elevation`n"
    help .= "^!l - Show Regional Settings`n"
    help .= "^!s - System Requirements Report`n"
    help .= "^!h - Show this help`n"

    MsgBox(help, "Help", "Iconi")
}
