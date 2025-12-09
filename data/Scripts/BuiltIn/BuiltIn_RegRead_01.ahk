#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 Registry Read Examples - Part 1
* ============================================================================
*
* This file demonstrates comprehensive usage of the RegRead function in
* AutoHotkey v2, including reading registry values, checking existence,
* and enumerating keys.
*
* @description Examples of reading Windows Registry values
* @author AHK v2 Examples Collection
* @version 1.0.0
* @date 2024-01-15
*/

; ============================================================================
; EXAMPLE 1: Basic Registry Reading
; ============================================================================

/**
* @function Example1_BasicRegistryRead
* @description Demonstrates basic registry value reading
* @returns {void}
*/
Example1_BasicRegistryRead() {
    MsgBox "=== Example 1: Basic Registry Reading ===`n`n" .
    "Reading common Windows registry values..."

    try {
        ; Read Windows Product Name
        productName := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "ProductName")

        ; Read Windows Build Number
        buildNumber := RegRead("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "CurrentBuild")

        ; Read Registered Owner
        regOwner := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "RegisteredOwner")

        ; Read Install Date (as DWORD)
        installDate := RegRead("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "InstallDate")

        result := "Windows Information:`n"
        result .= "━━━━━━━━━━━━━━━━━━━━`n"
        result .= "Product Name: " . productName . "`n"
        result .= "Build Number: " . buildNumber . "`n"
        result .= "Registered Owner: " . regOwner . "`n"
        result .= "Install Date (Unix): " . installDate . "`n"

        MsgBox result, "Registry Read Results"

    } catch Error as err {
        MsgBox "Error reading registry: " . err.Message, "Error"
    }
}

; ============================================================================
; EXAMPLE 2: Checking Registry Value Existence
; ============================================================================

/**
* @function Example2_CheckRegistryExistence
* @description Demonstrates how to safely check if registry values exist
* @returns {void}
*/
Example2_CheckRegistryExistence() {
    MsgBox "=== Example 2: Checking Registry Existence ===`n`n" .
    "Safely checking for registry values..."

    ; Helper function to check if a registry value exists
    RegValueExists(keyName, valueName) {
        try {
            RegRead(keyName, valueName)
            return true
        } catch {
            return false
        }
    }

    ; Check various registry locations
    checks := Map()

    ; Check Windows version info
    checks["Windows ProductName"] := RegValueExists(
    "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion",
    "ProductName"
    )

    ; Check for .NET Framework
    checks[".NET Framework 4.8"] := RegValueExists(
    "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full",
    "Version"
    )

    ; Check user's wallpaper setting
    checks["Desktop Wallpaper"] := RegValueExists(
    "HKEY_CURRENT_USER\Control Panel\Desktop",
    "Wallpaper"
    )

    ; Check AutoHotkey installation (example)
    checks["AutoHotkey Install"] := RegValueExists(
    "HKEY_CURRENT_USER\Software\AutoHotkey",
    "InstallDir"
    )

    ; Display results
    result := "Registry Existence Check Results:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"

    for item, exists in checks {
        status := exists ? "✓ Found" : "✗ Not Found"
        result .= item . ": " . status . "`n"
    }

    MsgBox result, "Existence Check"
}

; ============================================================================
; EXAMPLE 3: Reading Different Registry Data Types
; ============================================================================

/**
* @function Example3_RegistryDataTypes
* @description Demonstrates reading different registry data types (REG_SZ, REG_DWORD, etc.)
* @returns {void}
*/
Example3_RegistryDataTypes() {
    MsgBox "=== Example 3: Registry Data Types ===`n`n" .
    "Reading various registry data types..."

    try {
        ; REG_SZ (String)
        productName := RegRead("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "ProductName")

        ; REG_DWORD (32-bit number)
        errorMode := RegRead("HKLM\SYSTEM\CurrentControlSet\Control\Windows", "ErrorMode")

        ; REG_QWORD (64-bit number) - if available
        try {
            installTime := RegRead("HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion", "InstallTime")
            hasInstallTime := true
        } catch {
            hasInstallTime := false
        }

        ; REG_EXPAND_SZ (Expandable String)
        try {
            pathExt := RegRead("HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment", "PATHEXT")
            hasPathExt := true
        } catch {
            hasPathExt := false
        }

        ; Build result string
        result := "Registry Data Types:`n"
        result .= "━━━━━━━━━━━━━━━━━━━━`n"
        result .= "REG_SZ (String):`n"
        result .= "  ProductName: " . productName . "`n`n"
        result .= "REG_DWORD (32-bit):`n"
        result .= "  ErrorMode: " . errorMode . "`n`n"

        if (hasInstallTime)
        result .= "REG_QWORD (64-bit):`n  InstallTime: " . installTime . "`n`n"

        if (hasPathExt)
        result .= "REG_EXPAND_SZ (Expandable):`n  PATHEXT: " . pathExt . "`n"

        MsgBox result, "Data Types"

    } catch Error as err {
        MsgBox "Error: " . err.Message, "Error"
    }
}

; ============================================================================
; EXAMPLE 4: Enumerating Registry Subkeys
; ============================================================================

/**
* @function Example4_EnumerateSubkeys
* @description Demonstrates enumerating all subkeys in a registry key
* @returns {void}
*/
Example4_EnumerateSubkeys() {
    MsgBox "=== Example 4: Enumerating Registry Subkeys ===`n`n" .
    "Listing all subkeys in a registry location..."

    ; We'll enumerate subkeys using Loop Reg
    baseKey := "HKEY_CURRENT_USER\Software"
    subkeys := []

    try {
        ; Enumerate subkeys
        Loop Reg, baseKey, "K"
 {
            subkeys.Push(A_LoopRegName)

            ; Limit to first 20 for display
            if (subkeys.Length >= 20)
            break
        }

        ; Build result
        result := "Subkeys in HKCU\Software:`n"
        result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n"
        result .= "(Showing first 20)`n`n"

        for index, keyName in subkeys {
            result .= index . ". " . keyName . "`n"
        }

        MsgBox result, "Subkey Enumeration"

    } catch Error as err {
        MsgBox "Error enumerating subkeys: " . err.Message, "Error"
    }
}

; ============================================================================
; EXAMPLE 5: Reading and Displaying User Preferences
; ============================================================================

/**
* @function Example5_UserPreferences
* @description Reads various user preferences from the registry
* @returns {void}
*/
Example5_UserPreferences() {
    MsgBox "=== Example 5: User Preferences ===`n`n" .
    "Reading user preferences from registry..."

    prefs := Map()

    try {
        ; Desktop Wallpaper
        try {
            prefs["Wallpaper"] := RegRead("HKCU\Control Panel\Desktop", "Wallpaper")
        } catch {
            prefs["Wallpaper"] := "Not set"
        }

        ; Screen saver
        try {
            prefs["ScreenSaver"] := RegRead("HKCU\Control Panel\Desktop", "SCRNSAVE.EXE")
        } catch {
            prefs["ScreenSaver"] := "None"
        }

        ; Mouse settings
        try {
            prefs["MouseSpeed"] := RegRead("HKCU\Control Panel\Mouse", "MouseSpeed")
            prefs["DoubleClickSpeed"] := RegRead("HKCU\Control Panel\Mouse", "DoubleClickSpeed")
        } catch {
            prefs["MouseSpeed"] := "N/A"
            prefs["DoubleClickSpeed"] := "N/A"
        }

        ; Keyboard settings
        try {
            prefs["KeyboardDelay"] := RegRead("HKCU\Control Panel\Keyboard", "KeyboardDelay")
            prefs["KeyboardSpeed"] := RegRead("HKCU\Control Panel\Keyboard", "KeyboardSpeed")
        } catch {
            prefs["KeyboardDelay"] := "N/A"
            prefs["KeyboardSpeed"] := "N/A"
        }

        ; Explorer settings
        try {
            prefs["ShowHiddenFiles"] := RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden")
            prefs["HideFileExt"] := RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "HideFileExt")
        } catch {
            prefs["ShowHiddenFiles"] := "N/A"
            prefs["HideFileExt"] := "N/A"
        }

        ; Build result
        result := "User Preferences:`n"
        result .= "━━━━━━━━━━━━━━━━━━━━`n`n"

        result .= "Desktop:`n"
        result .= "  Wallpaper: " . prefs["Wallpaper"] . "`n"
        result .= "  Screen Saver: " . prefs["ScreenSaver"] . "`n`n"

        result .= "Mouse:`n"
        result .= "  Speed: " . prefs["MouseSpeed"] . "`n"
        result .= "  Double-Click Speed: " . prefs["DoubleClickSpeed"] . "`n`n"

        result .= "Keyboard:`n"
        result .= "  Delay: " . prefs["KeyboardDelay"] . "`n"
        result .= "  Speed: " . prefs["KeyboardSpeed"] . "`n`n"

        result .= "Explorer:`n"
        result .= "  Show Hidden Files: " . prefs["ShowHiddenFiles"] . "`n"
        result .= "  Hide File Extensions: " . prefs["HideFileExt"] . "`n"

        MsgBox result, "User Preferences"

    } catch Error as err {
        MsgBox "Error reading preferences: " . err.Message, "Error"
    }
}

; ============================================================================
; EXAMPLE 6: Application Settings Backup System
; ============================================================================

/**
* @class RegistryBackup
* @description A class for backing up registry settings
*/
class RegistryBackup {
    backup := Map()

    /**
    * @method AddValue
    * @description Backs up a registry value
    * @param {String} keyPath - Registry key path
    * @param {String} valueName - Value name to backup
    * @returns {Boolean} Success status
    */
    AddValue(keyPath, valueName) {
        try {
            value := RegRead(keyPath, valueName)
            this.backup[keyPath . "\" . valueName] := value
            return true
        } catch {
            return false
        }
    }

    /**
    * @method BackupKey
    * @description Backs up all values in a registry key
    * @param {String} keyPath - Registry key path
    * @returns {Integer} Number of values backed up
    */
    BackupKey(keyPath) {
        count := 0
        try {
            Loop Reg, keyPath, "V"
 {
                if this.AddValue(keyPath, A_LoopRegName)
                count++
            }
        }
        return count
    }

    /**
    * @method GetBackupReport
    * @description Gets a formatted report of backed up values
    * @returns {String} Formatted report
    */
    GetBackupReport() {
        report := "Registry Backup Report:`n"
        report .= "━━━━━━━━━━━━━━━━━━━━━━`n"
        report .= "Total Items: " . this.backup.Count . "`n`n"

        for fullPath, value in this.backup {
            report .= fullPath . "`n"
            report .= "  Value: " . value . "`n`n"
        }

        return report
    }

    /**
    * @method Clear
    * @description Clears the backup
    */
    Clear() {
        this.backup := Map()
    }
}

/**
* @function Example6_BackupSystem
* @description Demonstrates a registry backup system
* @returns {void}
*/
Example6_BackupSystem() {
    MsgBox "=== Example 6: Registry Backup System ===`n`n" .
    "Creating backup of registry settings..."

    backup := RegistryBackup()

    ; Backup some user settings
    backup.AddValue("HKCU\Control Panel\Desktop", "Wallpaper")
    backup.AddValue("HKCU\Control Panel\Mouse", "MouseSpeed")
    backup.AddValue("HKCU\Control Panel\Keyboard", "KeyboardDelay")

    ; Backup entire key (example with a safe location)
    ; Note: Using a test key location
    testKey := "HKCU\Software\AutoHotkey"
    if (RegValueExists(testKey, "InstallDir")) {
        count := backup.BackupKey(testKey)
        MsgBox "Backed up " . count . " values from AutoHotkey key", "Info"
    }

    ; Display backup report
    report := backup.GetBackupReport()
    MsgBox report, "Backup Report"
}

; Helper function for Example 6
RegValueExists(keyName, valueName) {
    try {
        RegRead(keyName, valueName)
        return true
    } catch {
        return false
    }
}

; ============================================================================
; EXAMPLE 7: Windows Feature Detection
; ============================================================================

/**
* @function Example7_FeatureDetection
* @description Detects installed Windows features and components
* @returns {void}
*/
Example7_FeatureDetection() {
    MsgBox "=== Example 7: Windows Feature Detection ===`n`n" .
    "Detecting installed Windows features..."

    features := Map()

    ; Detect Windows Features
    DetectFeature(name, keyPath, valueName := "") {
        try {
            if (valueName = "")
            value := RegRead(keyPath, "")
            else
            value := RegRead(keyPath, valueName)
            return true
        } catch {
            return false
        }
    }

    ; Check for various features
    features["Windows Defender"] := DetectFeature(
    "Windows Defender",
    "HKLM\SOFTWARE\Microsoft\Windows Defender"
    )

    features["Windows Media Player"] := DetectFeature(
    "WMP",
    "HKLM\SOFTWARE\Microsoft\MediaPlayer"
    )

    features[".NET Framework"] := DetectFeature(
    ".NET",
    "HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full",
    "Version"
    )

    features["PowerShell"] := DetectFeature(
    "PS",
    "HKLM\SOFTWARE\Microsoft\PowerShell\1"
    )

    features["Hyper-V"] := DetectFeature(
    "Hyper-V",
    "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization"
    )

    ; Build result
    result := "Windows Feature Detection:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"

    for feature, installed in features {
        status := installed ? "✓ Installed" : "✗ Not Found"
        result .= feature . ": " . status . "`n"
    }

    MsgBox result, "Feature Detection"
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMenu() {
    menu := "
    (
    AutoHotkey v2 - RegRead Examples
    ════════════════════════════════════

    1. Basic Registry Reading
    2. Check Registry Existence
    3. Registry Data Types
    4. Enumerate Subkeys
    5. User Preferences
    6. Backup System
    7. Feature Detection

    0. Exit

    Select an example (1-7):
    )"

    choice := InputBox(menu, "RegRead Examples").Value

    switch choice {
        case "1": Example1_BasicRegistryRead()
        case "2": Example2_CheckRegistryExistence()
        case "3": Example3_RegistryDataTypes()
        case "4": Example4_EnumerateSubkeys()
        case "5": Example5_UserPreferences()
        case "6": Example6_BackupSystem()
        case "7": Example7_FeatureDetection()
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
