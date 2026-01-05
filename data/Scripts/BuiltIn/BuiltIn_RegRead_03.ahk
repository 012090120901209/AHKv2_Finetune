#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 Registry Read Examples - Part 3
 * ============================================================================
 * 
 * This file demonstrates comprehensive registry reading for system
 * diagnostics, software inventory, and configuration validation.
 * 
 * @description System diagnostics and software inventory
 * @author AHK v2 Examples Collection
 * @version 1.0.0
 * @date 2024-01-15
 */

; ============================================================================
; EXAMPLE 1: Installed Software Inventory
; ============================================================================

/**
 * @class SoftwareInventory
 * @description Enumerates installed software from registry
 */
class SoftwareInventory {
    software := []

    /**
     * @method Scan
     * @description Scans registry for installed software
     * @returns {Integer} Number of programs found
     */
    Scan() {
        this.software := []

        ; Scan both 64-bit and 32-bit locations
        locations := [
            "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
            "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
            "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall"
        ]

        for location in locations {
            try {
                Loop Reg, location, "K"
                {
                    subKey := location . "\" . A_LoopRegName

                    ; Try to get display name
                    try {
                        displayName := RegRead(subKey, "DisplayName")

                        ; Skip entries without display name
                        if (displayName = "")
                            continue

                        ; Get additional info
                        publisher := this.SafeRead(subKey, "Publisher")
                        version := this.SafeRead(subKey, "DisplayVersion")
                        installDate := this.SafeRead(subKey, "InstallDate")
                        installLocation := this.SafeRead(subKey, "InstallLocation")

                        this.software.Push(Map(
                            "name", displayName,
                            "publisher", publisher,
                            "version", version,
                            "installDate", installDate,
                            "location", installLocation,
                            "regKey", subKey
                        ))
                    } catch {
                        ; Skip entries without display name
                    }
                }
            } catch {
                ; Skip inaccessible locations
            }
        }

        return this.software.Length
    }

    /**
     * @method SafeRead
     * @description Safely reads a registry value
     * @param {String} keyPath - Registry key path
     * @param {String} valueName - Value name
     * @param {String} default - Default value
     * @returns {String} Registry value or default
     */
    SafeRead(keyPath, valueName, default := "") {
        try {
            return RegRead(keyPath, valueName)
        } catch {
            return default
        }
    }

    /**
     * @method FindByName
     * @description Finds software by name (partial match)
     * @param {String} searchTerm - Search term
     * @returns {Array} Matching software entries
     */
    FindByName(searchTerm) {
        results := []
        for app in this.software {
            if (InStr(app["name"], searchTerm, false)) {
                results.Push(app)
            }
        }
        return results
    }

    /**
     * @method GetReport
     * @description Gets formatted inventory report
     * @param {Integer} limit - Maximum entries to show
     * @returns {String} Formatted report
     */
    GetReport(limit := 25) {
        report := "Installed Software Inventory:`n"
        report .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
        report .= "Total Programs: " . this.software.Length . "`n`n"

        count := 0
        for app in this.software {
            if (count >= limit)
                break

            report .= (count + 1) . ". " . app["name"] . "`n"
            if (app["publisher"] != "")
                report .= "   Publisher: " . app["publisher"] . "`n"
            if (app["version"] != "")
                report .= "   Version: " . app["version"] . "`n"
            report .= "`n"

            count++
        }

        if (this.software.Length > limit)
            report .= "... (" . (this.software.Length - limit) . " more programs)"

        return report
    }
}

/**
 * @function Example1_SoftwareInventory
 * @description Demonstrates installed software enumeration
 * @returns {void}
 */
Example1_SoftwareInventory() {
    MsgBox "=== Example 1: Software Inventory ===`n`n" .
        "Scanning installed software...`nThis may take a moment.", "Scanning"

    inventory := SoftwareInventory()
    count := inventory.Scan()

    report := inventory.GetReport(30)
    MsgBox report, "Software Inventory (" . count . " programs)"
}

; ============================================================================
; EXAMPLE 2: System Diagnostics Report
; ============================================================================

/**
 * @class SystemDiagnostics
 * @description Collects system diagnostic information from registry
 */
class SystemDiagnostics {
    diagnostics := Map()

    /**
     * @method Collect
     * @description Collects diagnostic information
     * @returns {Boolean} Success status
     */
    Collect() {
        this.diagnostics := Map()

        ; System Information
        this.CollectSystemInfo()

        ; Hardware Information
        this.CollectHardwareInfo()

        ; Network Information
        this.CollectNetworkInfo()

        ; Performance Information
        this.CollectPerformanceInfo()

        return true
    }

    /**
     * @method CollectSystemInfo
     * @description Collects system information
     */
    CollectSystemInfo() {
        sysInfo := Map()

        sysInfo["ProductName"] := this.SafeRead(
            "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion",
            "ProductName"
        )
        sysInfo["CurrentBuild"] := this.SafeRead(
            "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion",
            "CurrentBuild"
        )
        sysInfo["BuildBranch"] := this.SafeRead(
            "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion",
            "BuildBranch"
        )
        sysInfo["RegisteredOwner"] := this.SafeRead(
            "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion",
            "RegisteredOwner"
        )
        sysInfo["SystemRoot"] := this.SafeRead(
            "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion",
            "SystemRoot"
        )

        this.diagnostics["System"] := sysInfo
    }

    /**
     * @method CollectHardwareInfo
     * @description Collects hardware information
     */
    CollectHardwareInfo() {
        hwInfo := Map()

        hwInfo["ProcessorName"] := this.SafeRead(
            "HKLM\HARDWARE\DESCRIPTION\System\CentralProcessor\0",
            "ProcessorNameString"
        )
        hwInfo["ProcessorIdentifier"] := this.SafeRead(
            "HKLM\HARDWARE\DESCRIPTION\System\CentralProcessor\0",
            "Identifier"
        )

        this.diagnostics["Hardware"] := hwInfo
    }

    /**
     * @method CollectNetworkInfo
     * @description Collects network information
     */
    CollectNetworkInfo() {
        netInfo := Map()

        netInfo["ComputerName"] := this.SafeRead(
            "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName",
            "ComputerName"
        )
        netInfo["Domain"] := this.SafeRead(
            "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters",
            "Domain"
        )
        netInfo["HostName"] := this.SafeRead(
            "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters",
            "Hostname"
        )

        this.diagnostics["Network"] := netInfo
    }

    /**
     * @method CollectPerformanceInfo
     * @description Collects performance-related information
     */
    CollectPerformanceInfo() {
        perfInfo := Map()

        perfInfo["BootExecute"] := this.SafeRead(
            "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager",
            "BootExecute"
        )
        perfInfo["CrashControl"] := this.SafeRead(
            "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl",
            "CrashDumpEnabled"
        )

        this.diagnostics["Performance"] := perfInfo
    }

    /**
     * @method SafeRead
     * @description Safely reads a registry value
     */
    SafeRead(keyPath, valueName, default := "N/A") {
        try {
            return RegRead(keyPath, valueName)
        } catch {
            return default
        }
    }

    /**
     * @method GetReport
     * @description Gets formatted diagnostics report
     * @returns {String} Formatted report
     */
    GetReport() {
        report := "System Diagnostics Report:`n"
        report .= "━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"

        for category, info in this.diagnostics {
            report .= category . ":`n"
            for key, value in info {
                valueStr := String(value)
                if (StrLen(valueStr) > 50)
                    valueStr := SubStr(valueStr, 1, 47) . "..."
                report .= "  " . key . ": " . valueStr . "`n"
            }
            report .= "`n"
        }

        return report
    }
}

/**
 * @function Example2_SystemDiagnostics
 * @description Demonstrates system diagnostics collection
 * @returns {void}
 */
Example2_SystemDiagnostics() {
    MsgBox "=== Example 2: System Diagnostics ===`n`n" .
        "Collecting system diagnostic information..."

    diag := SystemDiagnostics()
    diag.Collect()

    report := diag.GetReport()
    MsgBox report, "System Diagnostics"
}

; ============================================================================
; EXAMPLE 3: File Association Reader
; ============================================================================

/**
 * @function Example3_FileAssociations
 * @description Reads file type associations from registry
 * @returns {void}
 */
Example3_FileAssociations() {
    MsgBox "=== Example 3: File Associations ===`n`n" .
        "Reading file type associations..."

    SafeRead(keyPath, valueName, default := "") {
        try {
            return RegRead(keyPath, valueName)
        } catch {
            return default
        }
    }

    ; Common file extensions to check
    extensions := [".txt", ".pdf", ".jpg", ".png", ".doc", ".docx",
        ".xls", ".xlsx", ".mp3", ".mp4", ".html", ".zip"]

    associations := Map()

    for ext in extensions {
        ; Get the file type
        fileType := SafeRead("HKEY_CLASSES_ROOT\" . ext, "")

        if (fileType != "") {
            ; Get the description
            description := SafeRead("HKEY_CLASSES_ROOT\" . fileType, "")

            ; Get the default open command
            command := SafeRead("HKEY_CLASSES_ROOT\" . fileType . "\shell\open\command", "")

            associations[ext] := Map(
                "type", fileType,
                "description", description,
                "command", command
            )
        }
    }

    ; Build report
    result := "File Type Associations:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━`n`n"

    for ext, info in associations {
        result .= ext . " → " . info["type"] . "`n"
        if (info["description"] != "")
            result .= "  Description: " . info["description"] . "`n"
        if (info["command"] != "") {
            cmdStr := info["command"]
            if (StrLen(cmdStr) > 60)
                cmdStr := SubStr(cmdStr, 1, 57) . "..."
            result .= "  Command: " . cmdStr . "`n"
        }
        result .= "`n"
    }

    MsgBox result, "File Associations"
}

; ============================================================================
; EXAMPLE 4: Startup Programs Analyzer
; ============================================================================

/**
 * @class StartupAnalyzer
 * @description Analyzes programs that run at startup
 */
class StartupAnalyzer {
    startupItems := []

    /**
     * @method Scan
     * @description Scans all startup locations
     * @returns {Integer} Number of startup items found
     */
    Scan() {
        this.startupItems := []

        ; Define startup locations
        locations := [
            Map("key", "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
                "scope", "System", "type", "Run"),
            Map("key", "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
                "scope", "User", "type", "Run"),
            Map("key", "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",
                "scope", "System", "type", "RunOnce"),
            Map("key", "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce",
                "scope", "User", "type", "RunOnce")
        ]

        for location in locations {
            try {
                Loop Reg, location["key"], "V"
                {
                    try {
                        command := RegRead(location["key"], A_LoopRegName)

                        this.startupItems.Push(Map(
                            "name", A_LoopRegName,
                            "command", command,
                            "scope", location["scope"],
                            "type", location["type"],
                            "location", location["key"]
                        ))
                    } catch {
                        ; Skip inaccessible values
                    }
                }
            } catch {
                ; Skip inaccessible keys
            }
        }

        return this.startupItems.Length
    }

    /**
     * @method GetReport
     * @description Gets formatted startup report
     * @returns {String} Formatted report
     */
    GetReport() {
        report := "Startup Programs Analysis:`n"
        report .= "━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
        report .= "Total Startup Items: " . this.startupItems.Length . "`n`n"

        ; Group by scope
        systemItems := []
        userItems := []

        for item in this.startupItems {
            if (item["scope"] = "System")
                systemItems.Push(item)
            else
                userItems.Push(item)
        }

        if (systemItems.Length > 0) {
            report .= "System Startup Programs (" . systemItems.Length . "):`n"
            for item in systemItems {
                report .= "  • " . item["name"] . " [" . item["type"] . "]`n"
                cmdStr := item["command"]
                if (StrLen(cmdStr) > 70)
                    cmdStr := SubStr(cmdStr, 1, 67) . "..."
                report .= "    " . cmdStr . "`n`n"
            }
        }

        if (userItems.Length > 0) {
            report .= "User Startup Programs (" . userItems.Length . "):`n"
            for item in userItems {
                report .= "  • " . item["name"] . " [" . item["type"] . "]`n"
                cmdStr := item["command"]
                if (StrLen(cmdStr) > 70)
                    cmdStr := SubStr(cmdStr, 1, 67) . "..."
                report .= "    " . cmdStr . "`n`n"
            }
        }

        return report
    }
}

/**
 * @function Example4_StartupAnalyzer
 * @description Demonstrates startup program analysis
 * @returns {void}
 */
Example4_StartupAnalyzer() {
    MsgBox "=== Example 4: Startup Programs ===`n`n" .
        "Analyzing startup programs..."

    analyzer := StartupAnalyzer()
    count := analyzer.Scan()

    if (count > 0) {
        report := analyzer.GetReport()
        MsgBox report, "Startup Analysis"
    } else {
        MsgBox "No startup programs found.", "Startup Analysis"
    }
}

; ============================================================================
; EXAMPLE 5: Environment Variables Reader
; ============================================================================

/**
 * @function Example5_EnvironmentVariables
 * @description Reads environment variables from registry
 * @returns {void}
 */
Example5_EnvironmentVariables() {
    MsgBox "=== Example 5: Environment Variables ===`n`n" .
        "Reading environment variables..."

    SafeRead(keyPath, valueName, default := "") {
        try {
            return RegRead(keyPath, valueName)
        } catch {
            return default
        }
    }

    systemVars := Map()
    userVars := Map()

    ; Read system environment variables
    try {
        Loop Reg, "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment", "V"
        {
            try {
                value := RegRead("HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment", A_LoopRegName)
                systemVars[A_LoopRegName] := value
            }
        }
    }

    ; Read user environment variables
    try {
        Loop Reg, "HKCU\Environment", "V"
        {
            try {
                value := RegRead("HKCU\Environment", A_LoopRegName)
                userVars[A_LoopRegName] := value
            }
        }
    }

    ; Build report
    result := "Environment Variables:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━`n`n"

    if (systemVars.Count > 0) {
        result .= "System Variables (" . systemVars.Count . "):`n"
        count := 0
        for varName, varValue in systemVars {
            if (count >= 10)
                break
            valueStr := String(varValue)
            if (StrLen(valueStr) > 50)
                valueStr := SubStr(valueStr, 1, 47) . "..."
            result .= "  " . varName . " = " . valueStr . "`n"
            count++
        }
        if (systemVars.Count > 10)
            result .= "  ... (" . (systemVars.Count - 10) . " more)`n"
        result .= "`n"
    }

    if (userVars.Count > 0) {
        result .= "User Variables (" . userVars.Count . "):`n"
        count := 0
        for varName, varValue in userVars {
            if (count >= 10)
                break
            valueStr := String(varValue)
            if (StrLen(valueStr) > 50)
                valueStr := SubStr(valueStr, 1, 47) . "..."
            result .= "  " . varName . " = " . valueStr . "`n"
            count++
        }
        if (userVars.Count > 10)
            result .= "  ... (" . (userVars.Count - 10) . " more)`n"
    }

    MsgBox result, "Environment Variables"
}

; ============================================================================
; EXAMPLE 6: Windows Services Configuration Reader
; ============================================================================

/**
 * @function Example6_ServicesConfig
 * @description Reads Windows services configuration
 * @returns {void}
 */
Example6_ServicesConfig() {
    MsgBox "=== Example 6: Services Configuration ===`n`n" .
        "Reading Windows services configuration..."

    SafeRead(keyPath, valueName, default := "") {
        try {
            return RegRead(keyPath, valueName)
        } catch {
            return default
        }
    }

    services := []
    servicesKey := "HKLM\SYSTEM\CurrentControlSet\Services"

    ; Read some well-known services
    knownServices := ["EventLog", "Spooler", "Winmgmt", "Schedule", "wuauserv"]

    for serviceName in knownServices {
        serviceKey := servicesKey . "\" . serviceName

        try {
            displayName := SafeRead(serviceKey, "DisplayName", serviceName)
            description := SafeRead(serviceKey, "Description")
            startType := SafeRead(serviceKey, "Start")
            imagePath := SafeRead(serviceKey, "ImagePath")

            ; Convert start type number to text
            startTypeText := "Unknown"
            switch startType {
                case "0": startTypeText := "Boot"
                case "1": startTypeText := "System"
                case "2": startTypeText := "Automatic"
                case "3": startTypeText := "Manual"
                case "4": startTypeText := "Disabled"
            }

            services.Push(Map(
                "name", serviceName,
                "displayName", displayName,
                "description", description,
                "startType", startTypeText,
                "imagePath", imagePath
            ))
        } catch {
            ; Skip if service not found
        }
    }

    ; Build report
    result := "Windows Services Configuration:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"

    for service in services {
        result .= service["displayName"] . "`n"
        if (service["description"] != "")
            result .= "  Description: " . service["description"] . "`n"
        result .= "  Start Type: " . service["startType"] . "`n"
        if (service["imagePath"] != "") {
            pathStr := service["imagePath"]
            if (StrLen(pathStr) > 60)
                pathStr := SubStr(pathStr, 1, 57) . "..."
            result .= "  Path: " . pathStr . "`n"
        }
        result .= "`n"
    }

    MsgBox result, "Services Configuration"
}

; ============================================================================
; EXAMPLE 7: Registry Configuration Validator
; ============================================================================

/**
 * @class ConfigValidator
 * @description Validates registry configuration against expected values
 */
class ConfigValidator {
    validationResults := []

    /**
     * @method ValidateValue
     * @description Validates a single registry value
     * @param {String} keyPath - Registry key path
     * @param {String} valueName - Value name
     * @param {Any} expectedValue - Expected value
     * @param {String} description - Description of the setting
     * @returns {Boolean} Validation result
     */
    ValidateValue(keyPath, valueName, expectedValue, description := "") {
        result := Map(
            "keyPath", keyPath,
            "valueName", valueName,
            "expectedValue", expectedValue,
            "description", description,
            "status", "Unknown",
            "actualValue", ""
        )

        try {
            actualValue := RegRead(keyPath, valueName)
            result["actualValue"] := actualValue

            if (actualValue = expectedValue) {
                result["status"] := "✓ Pass"
            } else {
                result["status"] := "✗ Fail"
            }
        } catch {
            result["status"] := "✗ Not Found"
        }

        this.validationResults.Push(result)
        return result["status"] = "✓ Pass"
    }

    /**
     * @method GetReport
     * @description Gets validation report
     * @returns {String} Formatted report
     */
    GetReport() {
        report := "Configuration Validation Report:`n"
        report .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"

        passed := 0
        failed := 0
        notFound := 0

        for result in this.validationResults {
            if (result["status"] = "✓ Pass")
                passed++
            else if (result["status"] = "✗ Fail")
                failed++
            else
                notFound++

            report .= result["status"] . " "
            if (result["description"] != "")
                report .= result["description"]
            else
                report .= result["valueName"]
            report .= "`n"

            if (result["status"] != "✓ Pass") {
                report .= "  Key: " . result["keyPath"] . "`n"
                report .= "  Value: " . result["valueName"] . "`n"
                report .= "  Expected: " . result["expectedValue"] . "`n"
                if (result["actualValue"] != "")
                    report .= "  Actual: " . result["actualValue"] . "`n"
            }
            report .= "`n"
        }

        report .= "Summary:`n"
        report .= "  Passed: " . passed . "`n"
        report .= "  Failed: " . failed . "`n"
        report .= "  Not Found: " . notFound . "`n"

        return report
    }
}

/**
 * @function Example7_ConfigValidator
 * @description Demonstrates configuration validation
 * @returns {void}
 */
Example7_ConfigValidator() {
    MsgBox "=== Example 7: Configuration Validator ===`n`n" .
        "Validating registry configuration..."

    validator := ConfigValidator()

    ; Example validations (these are just examples, actual values may differ)
    validator.ValidateValue(
        "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion",
        "ProductName",
        "Windows 11 Pro",
        "Windows Edition Check"
    )

    ; This validation will likely fail as it's an example
    validator.ValidateValue(
        "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes",
        "CurrentTheme",
        "C:\Windows\Resources\Themes\aero.theme",
        "Default Theme Check"
    )

    report := validator.GetReport()
    MsgBox report, "Validation Results"
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMenu() {
    menu := "
    (
    AutoHotkey v2 - RegRead System Analysis
    ═══════════════════════════════════════════

    1. Software Inventory
    2. System Diagnostics
    3. File Associations
    4. Startup Programs
    5. Environment Variables
    6. Services Configuration
    7. Configuration Validator

    0. Exit

    Select an example (1-7):
    )"

    choice := InputBox(menu, "RegRead System Analysis").Value

    switch choice {
        case "1": Example1_SoftwareInventory()
        case "2": Example2_SystemDiagnostics()
        case "3": Example3_FileAssociations()
        case "4": Example4_StartupAnalyzer()
        case "5": Example5_EnvironmentVariables()
        case "6": Example6_ServicesConfig()
        case "7": Example7_ConfigValidator()
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
