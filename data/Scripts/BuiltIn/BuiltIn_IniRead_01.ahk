#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 INI Read Examples - Part 1
* ============================================================================
*
* This file demonstrates comprehensive usage of the IniRead function in
* AutoHotkey v2, including reading INI files, sections, and default values.
*
* @description Examples of reading INI configuration files
* @author AHK v2 Examples Collection
* @version 1.0.0
* @date 2024-01-15
*/

; ============================================================================
; EXAMPLE 1: Basic INI Reading
; ============================================================================

/**
* @function Example1_BasicIniRead
* @description Demonstrates basic INI file reading
* @returns {void}
*/
Example1_BasicIniRead() {
    MsgBox "=== Example 1: Basic INI Reading ===`n`n" .
    "Creating and reading an INI file..."

    iniFile := A_ScriptDir . "\test_config.ini"

    ; Create a sample INI file
    try {
        FileDelete iniFile
    }

    IniWrite "MyApplication", iniFile, "Application", "Name"
    IniWrite "1.2.3", iniFile, "Application", "Version"
    IniWrite "John Doe", iniFile, "Application", "Author"

    IniWrite "1024", iniFile, "Window", "Width"
    IniWrite "768", iniFile, "Window", "Height"
    IniWrite "100", iniFile, "Window", "X"
    IniWrite "100", iniFile, "Window", "Y"

    ; Read values
    appName := IniRead(iniFile, "Application", "Name")
    appVersion := IniRead(iniFile, "Application", "Version")
    author := IniRead(iniFile, "Application", "Author")

    windowWidth := IniRead(iniFile, "Window", "Width")
    windowHeight := IniRead(iniFile, "Window", "Height")

    result := "INI File Contents:`n"
    result .= "━━━━━━━━━━━━━━━━━━`n`n"
    result .= "[Application]`n"
    result .= "Name: " . appName . "`n"
    result .= "Version: " . appVersion . "`n"
    result .= "Author: " . author . "`n`n"
    result .= "[Window]`n"
    result .= "Width: " . windowWidth . "`n"
    result .= "Height: " . windowHeight . "`n"

    MsgBox result, "INI Read Results"
}

; ============================================================================
; EXAMPLE 2: Reading with Default Values
; ============================================================================

/**
* @function Example2_DefaultValues
* @description Demonstrates reading INI values with defaults
* @returns {void}
*/
Example2_DefaultValues() {
    MsgBox "=== Example 2: Default Values ===`n`n" .
    "Reading INI with default fallback values..."

    iniFile := A_ScriptDir . "\partial_config.ini"

    ; Create a partial INI file
    try {
        FileDelete iniFile
    }

    IniWrite "True", iniFile, "Settings", "EnableFeatureA"
    ; Intentionally don't write EnableFeatureB

    ; Read with defaults
    featureA := IniRead(iniFile, "Settings", "EnableFeatureA", "False")
    featureB := IniRead(iniFile, "Settings", "EnableFeatureB", "False")  ; Uses default
    featureC := IniRead(iniFile, "Settings", "EnableFeatureC", "True")   ; Uses default

    result := "Reading with Defaults:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Feature A: " . featureA . " (found in file)`n"
    result .= "Feature B: " . featureB . " (using default)`n"
    result .= "Feature C: " . featureC . " (using default)`n"

    MsgBox result, "Default Values"
}

; ============================================================================
; EXAMPLE 3: Reading All Sections
; ============================================================================

/**
* @function Example3_ReadAllSections
* @description Demonstrates reading all sections from an INI file
* @returns {void}
*/
Example3_ReadAllSections() {
    MsgBox "=== Example 3: Read All Sections ===`n`n" .
    "Reading all sections from INI file..."

    iniFile := A_ScriptDir . "\multi_section.ini"

    ; Create INI with multiple sections
    try {
        FileDelete iniFile
    }

    IniWrite "Value1", iniFile, "Section1", "Key1"
    IniWrite "Value2", iniFile, "Section1", "Key2"

    IniWrite "ValueA", iniFile, "Section2", "KeyA"
    IniWrite "ValueB", iniFile, "Section2", "KeyB"

    IniWrite "Data1", iniFile, "Section3", "Item1"
    IniWrite "Data2", iniFile, "Section3", "Item2"

    ; Read all section names
    sections := IniRead(iniFile, , , "")
    sectionList := StrSplit(sections, "`n")

    result := "All Sections in INI File:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "Total Sections: " . sectionList.Length . "`n`n"

    for section in sectionList {
        if (section != "")
        result .= "  • " . section . "`n"
    }

    MsgBox result, "All Sections"
}

; ============================================================================
; EXAMPLE 4: Reading All Keys in a Section
; ============================================================================

/**
* @function Example4_ReadAllKeys
* @description Demonstrates reading all keys in a section
* @returns {void}
*/
Example4_ReadAllKeys() {
    MsgBox "=== Example 4: Read All Keys ===`n`n" .
    "Reading all keys in a section..."

    iniFile := A_ScriptDir . "\keys_config.ini"

    ; Create INI with multiple keys
    try {
        FileDelete iniFile
    }

    IniWrite "Value1", iniFile, "Database", "Host"
    IniWrite "Value2", iniFile, "Database", "Port"
    IniWrite "Value3", iniFile, "Database", "Username"
    IniWrite "Value4", iniFile, "Database", "Password"
    IniWrite "Value5", iniFile, "Database", "Database"

    ; Read all keys in the Database section
    keys := IniRead(iniFile, "Database", , "")
    keyList := StrSplit(keys, "`n")

    result := "All Keys in [Database] Section:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"

    for key in keyList {
        if (key != "") {
            value := IniRead(iniFile, "Database", key)
            result .= key . " = " . value . "`n"
        }
    }

    MsgBox result, "All Keys"
}

; ============================================================================
; EXAMPLE 5: Configuration Manager Class
; ============================================================================

/**
* @class ConfigManager
* @description Manages INI configuration files
*/
class ConfigManager {
    iniFile := ""

    __New(iniFile) {
        this.iniFile := iniFile
    }

    /**
    * @method GetString
    * @description Gets a string value
    * @param {String} section - Section name
    * @param {String} key - Key name
    * @param {String} default - Default value
    * @returns {String} Value
    */
    GetString(section, key, default := "") {
        return IniRead(this.iniFile, section, key, default)
    }

    /**
    * @method GetInteger
    * @description Gets an integer value
    * @param {String} section - Section name
    * @param {String} key - Key name
    * @param {Integer} default - Default value
    * @returns {Integer} Value
    */
    GetInteger(section, key, default := 0) {
        value := IniRead(this.iniFile, section, key, default)
        return Integer(value)
    }

    /**
    * @method GetBoolean
    * @description Gets a boolean value
    * @param {String} section - Section name
    * @param {String} key - Key name
    * @param {Boolean} default - Default value
    * @returns {Boolean} Value
    */
    GetBoolean(section, key, default := false) {
        value := IniRead(this.iniFile, section, key, default ? "true" : "false")
        return (value = "true" || value = "1" || value = "yes")
    }

    /**
    * @method GetSection
    * @description Gets all keys in a section as a Map
    * @param {String} section - Section name
    * @returns {Map} Section contents
    */
    GetSection(section) {
        keys := IniRead(this.iniFile, section, , "")
        keyList := StrSplit(keys, "`n")

        sectionMap := Map()
        for key in keyList {
            if (key != "") {
                value := IniRead(this.iniFile, section, key)
                sectionMap[key] := value
            }
        }

        return sectionMap
    }

    /**
    * @method GetAllSections
    * @description Gets all section names
    * @returns {Array} Section names
    */
    GetAllSections() {
        sections := IniRead(this.iniFile, , , "")
        sectionList := StrSplit(sections, "`n")

        result := []
        for section in sectionList {
            if (section != "")
            result.Push(section)
        }

        return result
    }
}

/**
* @function Example5_ConfigManagerClass
* @description Demonstrates the ConfigManager class
* @returns {void}
*/
Example5_ConfigManagerClass() {
    MsgBox "=== Example 5: Config Manager Class ===`n`n" .
    "Using ConfigManager class..."

    iniFile := A_ScriptDir . "\app_config.ini"

    ; Create config file
    try {
        FileDelete iniFile
    }

    IniWrite "MyApp", iniFile, "Application", "Name"
    IniWrite "1024", iniFile, "Window", "Width"
    IniWrite "768", iniFile, "Window", "Height"
    IniWrite "true", iniFile, "Features", "DarkMode"
    IniWrite "false", iniFile, "Features", "BetaFeatures"

    ; Use ConfigManager
    config := ConfigManager(iniFile)

    appName := config.GetString("Application", "Name")
    width := config.GetInteger("Window", "Width")
    height := config.GetInteger("Window", "Height")
    darkMode := config.GetBoolean("Features", "DarkMode")
    betaFeatures := config.GetBoolean("Features", "BetaFeatures")

    result := "Configuration Manager Results:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"
    result .= "App Name: " . appName . "`n"
    result .= "Window Size: " . width . "x" . height . "`n"
    result .= "Dark Mode: " . (darkMode ? "Enabled" : "Disabled") . "`n"
    result .= "Beta Features: " . (betaFeatures ? "Enabled" : "Disabled") . "`n"

    MsgBox result, "Config Manager"
}

; ============================================================================
; EXAMPLE 6: Multi-Language Configuration
; ============================================================================

/**
* @function Example6_MultiLanguage
* @description Demonstrates multi-language INI configuration
* @returns {void}
*/
Example6_MultiLanguage() {
    MsgBox "=== Example 6: Multi-Language Config ===`n`n" .
    "Reading multi-language strings..."

    iniFile := A_ScriptDir . "\lang_config.ini"

    ; Create language config
    try {
        FileDelete iniFile
    }

    ; English
    IniWrite "Hello", iniFile, "English", "Greeting"
    IniWrite "Goodbye", iniFile, "English", "Farewell"
    IniWrite "Thank you", iniFile, "English", "Thanks"

    ; Spanish
    IniWrite "Hola", iniFile, "Spanish", "Greeting"
    IniWrite "Adiós", iniFile, "Spanish", "Farewell"
    IniWrite "Gracias", iniFile, "Spanish", "Thanks"

    ; French
    IniWrite "Bonjour", iniFile, "French", "Greeting"
    IniWrite "Au revoir", iniFile, "French", "Farewell"
    IniWrite "Merci", iniFile, "French", "Thanks"

    ; Read different languages
    result := "Multi-Language Configuration:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━━━━━━━━━`n`n"

    languages := ["English", "Spanish", "French"]
    for lang in languages {
        greeting := IniRead(iniFile, lang, "Greeting")
        result .= lang . " Greeting: " . greeting . "`n"
    }

    MsgBox result, "Multi-Language"
}

; ============================================================================
; EXAMPLE 7: Application Settings Reader
; ============================================================================

/**
* @function Example7_AppSettings
* @description Demonstrates comprehensive application settings reading
* @returns {void}
*/
Example7_AppSettings() {
    MsgBox "=== Example 7: Application Settings ===`n`n" .
    "Reading comprehensive app settings..."

    iniFile := A_ScriptDir . "\full_app_config.ini"

    ; Create comprehensive config
    try {
        FileDelete iniFile
    }

    ; Application Info
    IniWrite "SuperApp", iniFile, "Application", "Name"
    IniWrite "2.5.0", iniFile, "Application", "Version"
    IniWrite "Production", iniFile, "Application", "Environment"

    ; UI Settings
    IniWrite "Dark", iniFile, "UI", "Theme"
    IniWrite "12", iniFile, "UI", "FontSize"
    IniWrite "true", iniFile, "UI", "ShowToolbar"
    IniWrite "true", iniFile, "UI", "ShowStatusBar"

    ; Database
    IniWrite "localhost", iniFile, "Database", "Host"
    IniWrite "5432", iniFile, "Database", "Port"
    IniWrite "appdb", iniFile, "Database", "DatabaseName"

    ; Logging
    IniWrite "true", iniFile, "Logging", "Enabled"
    IniWrite "INFO", iniFile, "Logging", "Level"
    IniWrite "app.log", iniFile, "Logging", "Filename"

    ; Read and display
    config := ConfigManager(iniFile)

    result := "Application Settings:`n"
    result .= "━━━━━━━━━━━━━━━━━━━━`n`n"

    sections := config.GetAllSections()
    for section in sections {
        result .= "[" . section . "]`n"
        sectionData := config.GetSection(section)

        for key, value in sectionData {
            result .= "  " . key . " = " . value . "`n"
        }
        result .= "`n"
    }

    MsgBox result, "Full Configuration"
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMenu() {
    menu := "
    (
    AutoHotkey v2 - IniRead Examples
    ═════════════════════════════════

    1. Basic INI Reading
    2. Default Values
    3. Read All Sections
    4. Read All Keys
    5. Config Manager Class
    6. Multi-Language Config
    7. Application Settings

    0. Exit

    Select an example (1-7):
    )"

    choice := InputBox(menu, "IniRead Examples").Value

    switch choice {
        case "1": Example1_BasicIniRead()
        case "2": Example2_DefaultValues()
        case "3": Example3_ReadAllSections()
        case "4": Example4_ReadAllKeys()
        case "5": Example5_ConfigManagerClass()
        case "6": Example6_MultiLanguage()
        case "7": Example7_AppSettings()
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
