#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 Registry Read Examples - Part 2
 * ============================================================================
 * 
 * This file demonstrates advanced registry reading scenarios including
 * recursive enumeration, value comparison, and registry monitoring.
 * 
 * @description Advanced registry reading techniques
 * @author AHK v2 Examples Collection
 * @version 1.0.0
 * @date 2024-01-15
 */

; ============================================================================
; EXAMPLE 1: Recursive Registry Enumeration
; ============================================================================

/**
 * @class RegistryExplorer
 * @description A class for recursively exploring registry structures
 */
class RegistryExplorer {
    results := []
    maxDepth := 3
    currentDepth := 0

    /**
     * @method Explore
     * @description Recursively explores a registry key
     * @param {String} keyPath - Registry key path to explore
     * @param {Integer} depth - Current depth level
     * @returns {Array} Array of found items
     */
    Explore(keyPath, depth := 0) {
        if (depth >= this.maxDepth)
            return this.results

        indent := ""
        Loop depth
            indent .= "  "

        ; Add current key
        this.results.Push(Map(
            "path", keyPath,
            "type", "key",
            "depth", depth,
            "indent", indent
        ))

        try {
            ; Enumerate values
            Loop Reg, keyPath, "V"
            {
                try {
                    value := RegRead(keyPath, A_LoopRegName)
                    this.results.Push(Map(
                        "path", keyPath,
                        "name", A_LoopRegName,
                        "value", value,
                        "type", "value",
                        "depth", depth,
                        "indent", indent . "  "
                    ))
                } catch {
                    ; Skip inaccessible values
                }
            }

            ; Enumerate subkeys recursively
            Loop Reg, keyPath, "K"
            {
                subKeyPath := keyPath . "\" . A_LoopRegName
                this.Explore(subKeyPath, depth + 1)
            }

        } catch {
            ; Skip inaccessible keys
        }

        return this.results
    }

    /**
     * @method GetReport
     * @description Generates a formatted report of exploration results
     * @returns {String} Formatted report
     */
    GetReport() {
        report := "Registry Exploration Report:`n"
        report .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
        report .= "Total Items: " . this.results.Length . "`n`n"

        count := 0
        for item in this.results {
            if (count >= 50)  ; Limit display
                break

            if (item["type"] = "key") {
                report .= item["indent"] . "[KEY] " . item["path"] . "`n"
            } else {
                valueStr := String(item["value"])
                if (StrLen(valueStr) > 50)
                    valueStr := SubStr(valueStr, 1, 47) . "..."
                report .= item["indent"] . item["name"] . " = " . valueStr . "`n"
            }
            count++
        }

        if (this.results.Length > 50)
            report .= "`n... (" . (this.results.Length - 50) . " more items)"

        return report
    }

    /**
     * @method Reset
     * @description Resets the explorer
     */
    Reset() {
        this.results := []
        this.currentDepth := 0
    }
}

/**
 * @function Example1_RecursiveEnumeration
 * @description Demonstrates recursive registry enumeration
 * @returns {void}
 */
Example1_RecursiveEnumeration() {
    MsgBox "=== Example 1: Recursive Registry Enumeration ===`n`n" .
        "Exploring registry structure recursively..."

    explorer := RegistryExplorer()
    explorer.maxDepth := 2

    ; Explore a safe registry location
    keyPath := "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes"

    try {
        explorer.Explore(keyPath)
        report := explorer.GetReport()
        MsgBox report, "Registry Exploration"
    } catch Error as err {
        MsgBox "Error: " . err.Message, "Error"
    }
}

; ============================================================================
; EXAMPLE 2: Registry Value Comparison
; ============================================================================

/**
 * @function Example2_ValueComparison
 * @description Compares registry values across different keys
 * @returns {void}
 */
Example2_ValueComparison() {
    MsgBox "=== Example 2: Registry Value Comparison ===`n`n" .
        "Comparing registry values..."

    ; Helper function to safely read registry
    SafeRegRead(keyPath, valueName, default := "N/A") {
        try {
            return RegRead(keyPath, valueName)
        } catch {
            return default
        }
    }

    ; Compare similar settings across different locations
    comparisons := []

    ; Example: Compare version information
    comparison1 := Map()
    comparison1["Name"] := "Windows Product Name"
    comparison1["Location 1"] := "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
    comparison1["Value 1"] := SafeRegRead(
        "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion",
        "ProductName"
    )

    comparisons.Push(comparison1)

    ; Example: Compare build numbers
    comparison2 := Map()
    comparison2["Name"] := "Windows Build"
    comparison2["Location 1"] := "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
    comparison2["Value 1"] := SafeRegRead(
        "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion",
        "CurrentBuild"
    )
    comparison2["Location 2"] := "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion"
    comparison2["Value 2"] := SafeRegRead(
        "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion",
        "CurrentBuildNumber"
    )

    comparisons.Push(comparison2)

    ; Build result
    result := "Registry Value Comparison:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"

    for comp in comparisons {
        result .= "Comparing: " . comp["Name"] . "`n"
        result .= "  Location: " . comp["Location 1"] . "`n"
        result .= "  Value: " . comp["Value 1"] . "`n"

        if (comp.Has("Location 2")) {
            result .= "  Location: " . comp["Location 2"] . "`n"
            result .= "  Value: " . comp["Value 2"] . "`n"

            if (comp["Value 1"] = comp["Value 2"])
                result .= "  Status: ✓ Values Match`n"
            else
                result .= "  Status: ✗ Values Differ`n"
        }
        result .= "`n"
    }

    MsgBox result, "Value Comparison"
}

; ============================================================================
; EXAMPLE 3: Registry Search Functionality
; ============================================================================

/**
 * @class RegistrySearcher
 * @description Searches for registry values matching criteria
 */
class RegistrySearcher {
    results := []
    searchTerm := ""
    caseSensitive := false

    /**
     * @method SearchValues
     * @description Searches for values containing search term
     * @param {String} keyPath - Registry key to search
     * @param {String} searchTerm - Term to search for
     * @returns {Integer} Number of matches found
     */
    SearchValues(keyPath, searchTerm) {
        this.searchTerm := searchTerm
        this.results := []

        try {
            Loop Reg, keyPath, "VK"
            {
                valueName := A_LoopRegName
                try {
                    value := RegRead(keyPath . "\" . A_LoopRegKey, valueName)
                    valueStr := String(value)

                    ; Check if search term is in value name or value
                    nameMatch := this.caseSensitive ?
                        InStr(valueName, searchTerm) :
                        InStr(valueName, searchTerm, false)

                    valueMatch := this.caseSensitive ?
                        InStr(valueStr, searchTerm) :
                        InStr(valueStr, searchTerm, false)

                    if (nameMatch || valueMatch) {
                        this.results.Push(Map(
                            "key", keyPath . "\" . A_LoopRegKey,
                            "name", valueName,
                            "value", valueStr,
                            "matchType", nameMatch ? "name" : "value"
                        ))
                    }
                } catch {
                    ; Skip inaccessible values
                }
            }
        } catch {
            ; Skip inaccessible keys
        }

        return this.results.Length
    }

    /**
     * @method GetResults
     * @description Gets formatted search results
     * @returns {String} Formatted results
     */
    GetResults() {
        if (this.results.Length = 0)
            return "No matches found for: " . this.searchTerm

        report := "Search Results for: " . this.searchTerm . "`n"
        report .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
        report .= "Total Matches: " . this.results.Length . "`n`n"

        count := 0
        for match in this.results {
            if (count >= 20)
                break

            report .= "Match " . (count + 1) . ":`n"
            report .= "  Key: " . match["key"] . "`n"
            report .= "  Name: " . match["name"] . "`n"
            report .= "  Value: " . match["value"] . "`n"
            report .= "  Match Type: " . match["matchType"] . "`n`n"

            count++
        }

        if (this.results.Length > 20)
            report .= "... (" . (this.results.Length - 20) . " more matches)"

        return report
    }
}

/**
 * @function Example3_RegistrySearch
 * @description Demonstrates registry search functionality
 * @returns {void}
 */
Example3_RegistrySearch() {
    MsgBox "=== Example 3: Registry Search ===`n`n" .
        "Searching registry for specific values..."

    searcher := RegistrySearcher()

    ; Search for "Windows" in HKCU\Software\Microsoft
    keyPath := "HKCU\Software\Microsoft\Windows\CurrentVersion"
    searchTerm := "Windows"

    count := searcher.SearchValues(keyPath, searchTerm)

    if (count > 0) {
        results := searcher.GetResults()
        MsgBox results, "Search Results"
    } else {
        MsgBox "No matches found for: " . searchTerm, "Search Results"
    }
}

; ============================================================================
; EXAMPLE 4: Registry Monitoring (Snapshot-based)
; ============================================================================

/**
 * @class RegistryMonitor
 * @description Monitors registry changes using snapshots
 */
class RegistryMonitor {
    snapshots := Map()

    /**
     * @method TakeSnapshot
     * @description Takes a snapshot of a registry key
     * @param {String} keyPath - Registry key to snapshot
     * @param {String} snapshotName - Name for this snapshot
     * @returns {Integer} Number of values captured
     */
    TakeSnapshot(keyPath, snapshotName) {
        snapshot := Map()

        try {
            Loop Reg, keyPath, "V"
            {
                try {
                    value := RegRead(keyPath, A_LoopRegName)
                    snapshot[A_LoopRegName] := value
                } catch {
                    ; Skip inaccessible values
                }
            }
        } catch {
            return 0
        }

        this.snapshots[snapshotName] := Map(
            "keyPath", keyPath,
            "values", snapshot,
            "timestamp", A_Now
        )

        return snapshot.Count
    }

    /**
     * @method CompareSnapshots
     * @description Compares two snapshots
     * @param {String} snapshot1Name - First snapshot name
     * @param {String} snapshot2Name - Second snapshot name
     * @returns {Map} Comparison results
     */
    CompareSnapshots(snapshot1Name, snapshot2Name) {
        if (!this.snapshots.Has(snapshot1Name) || !this.snapshots.Has(snapshot2Name))
            return Map("error", "Snapshot not found")

        snap1 := this.snapshots[snapshot1Name]["values"]
        snap2 := this.snapshots[snapshot2Name]["values"]

        changes := Map(
            "added", [],
            "removed", [],
            "modified", []
        )

        ; Check for added and modified values
        for valueName, value in snap2 {
            if (!snap1.Has(valueName)) {
                changes["added"].Push(Map(
                    "name", valueName,
                    "value", value
                ))
            } else if (snap1[valueName] != value) {
                changes["modified"].Push(Map(
                    "name", valueName,
                    "oldValue", snap1[valueName],
                    "newValue", value
                ))
            }
        }

        ; Check for removed values
        for valueName, value in snap1 {
            if (!snap2.Has(valueName)) {
                changes["removed"].Push(Map(
                    "name", valueName,
                    "value", value
                ))
            }
        }

        return changes
    }

    /**
     * @method GetChangeReport
     * @description Gets a formatted change report
     * @param {Map} changes - Changes map from CompareSnapshots
     * @returns {String} Formatted report
     */
    GetChangeReport(changes) {
        if (changes.Has("error"))
            return "Error: " . changes["error"]

        report := "Registry Change Report:`n"
        report .= "━━━━━━━━━━━━━━━━━━━━━━`n`n"

        ; Added values
        if (changes["added"].Length > 0) {
            report .= "Added Values (" . changes["added"].Length . "):`n"
            for item in changes["added"] {
                report .= "  + " . item["name"] . " = " . item["value"] . "`n"
            }
            report .= "`n"
        }

        ; Removed values
        if (changes["removed"].Length > 0) {
            report .= "Removed Values (" . changes["removed"].Length . "):`n"
            for item in changes["removed"] {
                report .= "  - " . item["name"] . " = " . item["value"] . "`n"
            }
            report .= "`n"
        }

        ; Modified values
        if (changes["modified"].Length > 0) {
            report .= "Modified Values (" . changes["modified"].Length . "):`n"
            for item in changes["modified"] {
                report .= "  * " . item["name"] . "`n"
                report .= "    Old: " . item["oldValue"] . "`n"
                report .= "    New: " . item["newValue"] . "`n"
            }
        }

        if (changes["added"].Length = 0 && changes["removed"].Length = 0 && changes["modified"].Length = 0) {
            report .= "No changes detected."
        }

        return report
    }
}

/**
 * @function Example4_RegistryMonitoring
 * @description Demonstrates registry monitoring
 * @returns {void}
 */
Example4_RegistryMonitoring() {
    MsgBox "=== Example 4: Registry Monitoring ===`n`n" .
        "Demonstrating snapshot-based monitoring..."

    monitor := RegistryMonitor()
    keyPath := "HKCU\Software\Microsoft\Windows\CurrentVersion\Themes"

    ; Take initial snapshot
    count1 := monitor.TakeSnapshot(keyPath, "snapshot1")
    MsgBox "Initial snapshot taken.`nValues captured: " . count1, "Snapshot"

    ; Simulate time passing (in real use, changes would occur)
    Sleep 1000

    ; Take second snapshot
    count2 := monitor.TakeSnapshot(keyPath, "snapshot2")
    MsgBox "Second snapshot taken.`nValues captured: " . count2, "Snapshot"

    ; Compare snapshots
    changes := monitor.CompareSnapshots("snapshot1", "snapshot2")
    report := monitor.GetChangeReport(changes)

    MsgBox report, "Change Detection"
}

; ============================================================================
; EXAMPLE 5: Application Configuration Reader
; ============================================================================

/**
 * @class AppConfigReader
 * @description Reads application configuration from registry
 */
class AppConfigReader {
    appKey := ""
    config := Map()

    __New(appKey) {
        this.appKey := appKey
    }

    /**
     * @method LoadConfig
     * @description Loads all configuration values
     * @returns {Boolean} Success status
     */
    LoadConfig() {
        this.config := Map()

        try {
            Loop Reg, this.appKey, "V"
            {
                try {
                    value := RegRead(this.appKey, A_LoopRegName)
                    this.config[A_LoopRegName] := value
                } catch {
                    ; Skip inaccessible values
                }
            }
            return true
        } catch {
            return false
        }
    }

    /**
     * @method GetValue
     * @description Gets a configuration value
     * @param {String} key - Configuration key
     * @param {Any} default - Default value if not found
     * @returns {Any} Configuration value
     */
    GetValue(key, default := "") {
        if (this.config.Has(key))
            return this.config[key]
        return default
    }

    /**
     * @method GetAllValues
     * @description Gets all configuration values
     * @returns {Map} All configuration values
     */
    GetAllValues() {
        return this.config
    }

    /**
     * @method GetReport
     * @description Gets a formatted configuration report
     * @returns {String} Formatted report
     */
    GetReport() {
        report := "Application Configuration:`n"
        report .= "━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
        report .= "Key: " . this.appKey . "`n"
        report .= "Total Settings: " . this.config.Count . "`n`n"

        for key, value in this.config {
            valueStr := String(value)
            if (StrLen(valueStr) > 60)
                valueStr := SubStr(valueStr, 1, 57) . "..."
            report .= key . " = " . valueStr . "`n"
        }

        return report
    }
}

/**
 * @function Example5_AppConfigReader
 * @description Demonstrates application configuration reading
 * @returns {void}
 */
Example5_AppConfigReader() {
    MsgBox "=== Example 5: Application Config Reader ===`n`n" .
        "Reading application configuration..."

    ; Use Windows Explorer as example
    reader := AppConfigReader("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer")

    if (reader.LoadConfig()) {
        report := reader.GetReport()
        MsgBox report, "Configuration"
    } else {
        MsgBox "Failed to load configuration", "Error"
    }
}

; ============================================================================
; EXAMPLE 6: Windows Settings Inspector
; ============================================================================

/**
 * @function Example6_WindowsSettings
 * @description Inspects various Windows system settings
 * @returns {void}
 */
Example6_WindowsSettings() {
    MsgBox "=== Example 6: Windows Settings Inspector ===`n`n" .
        "Inspecting Windows system settings..."

    SafeRead(keyPath, valueName, default := "N/A") {
        try {
            return RegRead(keyPath, valueName)
        } catch {
            return default
        }
    }

    settings := Map()

    ; System Information
    settings["OS Product"] := SafeRead("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "ProductName")
    settings["Build Number"] := SafeRead("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "CurrentBuild")
    settings["Edition ID"] := SafeRead("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "EditionID")

    ; Time Zone
    settings["TimeZone"] := SafeRead("HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation", "TimeZoneKeyName")

    ; Computer Name
    settings["Computer Name"] := SafeRead("HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName", "ComputerName")

    ; Windows Firewall
    settings["Firewall Enabled"] := SafeRead("HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile", "EnableFirewall")

    ; Build report
    result := "Windows Settings Inspector:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"

    result .= "System Information:`n"
    result .= "  OS: " . settings["OS Product"] . "`n"
    result .= "  Build: " . settings["Build Number"] . "`n"
    result .= "  Edition: " . settings["Edition ID"] . "`n`n"

    result .= "System Configuration:`n"
    result .= "  Computer Name: " . settings["Computer Name"] . "`n"
    result .= "  Time Zone: " . settings["TimeZone"] . "`n"
    result .= "  Firewall: " . (settings["Firewall Enabled"] = "1" ? "Enabled" : "Disabled") . "`n"

    MsgBox result, "Windows Settings"
}

; ============================================================================
; EXAMPLE 7: Registry Performance Analysis
; ============================================================================

/**
 * @function Example7_PerformanceAnalysis
 * @description Analyzes registry read performance
 * @returns {void}
 */
Example7_PerformanceAnalysis() {
    MsgBox "=== Example 7: Performance Analysis ===`n`n" .
        "Analyzing registry read performance..."

    results := []

    ; Test 1: Single value read
    startTime := A_TickCount
    Loop 100 {
        try {
            RegRead("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "ProductName")
        }
    }
    singleReadTime := A_TickCount - startTime

    results.Push(Map(
        "test", "Single Value Read (100x)",
        "time", singleReadTime . " ms",
        "average", Round(singleReadTime / 100, 2) . " ms"
    ))

    ; Test 2: Multiple value enumeration
    startTime := A_TickCount
    count := 0
    try {
        Loop Reg, "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer", "V"
        {
            count++
        }
    }
    enumTime := A_TickCount - startTime

    results.Push(Map(
        "test", "Value Enumeration (" . count . " values)",
        "time", enumTime . " ms",
        "average", count > 0 ? Round(enumTime / count, 2) . " ms" : "N/A"
    ))

    ; Build report
    result := "Registry Performance Analysis:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"

    for test in results {
        result .= test["test"] . "`n"
        result .= "  Total Time: " . test["time"] . "`n"
        result .= "  Average: " . test["average"] . "`n`n"
    }

    MsgBox result, "Performance Analysis"
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMenu() {
    menu := "
    (
    AutoHotkey v2 - RegRead Advanced Examples
    ═══════════════════════════════════════════

    1. Recursive Enumeration
    2. Value Comparison
    3. Registry Search
    4. Registry Monitoring
    5. App Config Reader
    6. Windows Settings
    7. Performance Analysis

    0. Exit

    Select an example (1-7):
    )"

    choice := InputBox(menu, "RegRead Advanced Examples").Value

    switch choice {
        case "1": Example1_RecursiveEnumeration()
        case "2": Example2_ValueComparison()
        case "3": Example3_RegistrySearch()
        case "4": Example4_RegistryMonitoring()
        case "5": Example5_AppConfigReader()
        case "6": Example6_WindowsSettings()
        case "7": Example7_PerformanceAnalysis()
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
