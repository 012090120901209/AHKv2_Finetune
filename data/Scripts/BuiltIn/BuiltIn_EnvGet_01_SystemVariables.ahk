#Requires AutoHotkey v2.0

/**
 * BuiltIn_EnvGet_01_SystemVariables.ahk
 * 
 * DESCRIPTION:
 * Demonstrates how to retrieve and use system environment variables
 * with EnvGet, essential for cross-platform scripting and system integration.
 * 
 * FEATURES:
 * - Retrieving common system variables (PATH, TEMP, USERNAME, etc.)
 * - Environment variable validation and error handling
 * - Dynamic path construction using env vars
 * - System information gathering
 * - Cross-user compatible scripting
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - EnvGet() function syntax
 * - Return value handling (empty string if not found)
 * - String concatenation with env vars
 * - Map/Object storage of env vars
 * - Error handling for missing variables
 * 
 * LEARNING POINTS:
 * 1. EnvGet retrieves environment variable values
 * 2. Returns empty string if variable doesn't exist
 * 3. Variable names are case-insensitive on Windows
 * 4. Use for portable, user-independent paths
 * 5. PATH variable contains multiple directories
 * 6. System vs User environment variables
 * 7. Always validate retrieved values before use
 */

;===============================================================================
; EXAMPLE 1: Basic Environment Variable Retrieval
;===============================================================================

Example1_BasicEnvGet() {
    ; Retrieve common environment variables
    username := EnvGet("USERNAME")
    computerName := EnvGet("COMPUTERNAME")
    userProfile := EnvGet("USERPROFILE")
    homeDrive := EnvGet("HOMEDRIVE")
    homePath := EnvGet("HOMEPATH")

    ; Display basic system info
    info := "=== Basic System Information ===`n`n"
    info .= "Username: " username "`n"
    info .= "Computer Name: " computerName "`n"
    info .= "User Profile: " userProfile "`n"
    info .= "Home Drive: " homeDrive "`n"
    info .= "Home Path: " homePath "`n"

    MsgBox(info, "System Environment Variables")

    ; Retrieve Windows directory
    winDir := EnvGet("WINDIR")
    sysRoot := EnvGet("SYSTEMROOT")

    info := "=== Windows Directories ===`n`n"
    info .= "Windows Directory: " winDir "`n"
    info .= "System Root: " sysRoot "`n"

    MsgBox(info, "Windows Directories")

    ; Retrieve temporary directories
    temp := EnvGet("TEMP")
    tmp := EnvGet("TMP")

    info := "=== Temporary Directories ===`n`n"
    info .= "TEMP: " temp "`n"
    info .= "TMP: " tmp "`n`n"
    info .= "Use these for temporary file storage"

    MsgBox(info, "Temp Directories")
}

;===============================================================================
; EXAMPLE 2: PATH Variable Analysis
;===============================================================================

Example2_PathVariableAnalysis() {
    ; Get PATH variable
    pathVar := EnvGet("PATH")

    if pathVar = "" {
        MsgBox("PATH variable not found!", "Error")
        return
    }

    ; Split PATH into individual directories
    paths := StrSplit(pathVar, ";")

    ; Create analysis GUI
    pathGui := Gui(, "PATH Variable Analysis")

    pathGui.Add("Text", "x10 y10 w480", "System PATH contains " paths.Length " directories:")

    ; ListView to display paths
    lv := pathGui.Add("ListView", "x10 y40 w480 h300", ["#", "Path", "Exists"])

    ; Populate ListView
    for index, path in paths {
        path := Trim(path)
        if path = ""
            continue

        exists := DirExist(path) ? "Yes" : "No"
        lv.Add(, index, path, exists)
    }

    ; Auto-size columns
    lv.ModifyCol(1, "Auto")
    lv.ModifyCol(2, "Auto")
    lv.ModifyCol(3, "Auto")

    ; Add statistics
    validCount := 0
    invalidCount := 0

    for index, path in paths {
        path := Trim(path)
        if path = ""
            continue

        if DirExist(path)
            validCount++
        else
            invalidCount++
    }

    stats := "Valid Paths: " validCount " | Invalid/Missing: " invalidCount
    pathGui.Add("Text", "x10 y350 w480", stats)

    btnClose := pathGui.Add("Button", "x200 y380 w100 h30", "Close")
    btnClose.OnEvent("Click", (*) => pathGui.Destroy())

    pathGui.Show("w500 h430")
}

;===============================================================================
; EXAMPLE 3: Environment Variable Validator
;===============================================================================

Example3_EnvVarValidator() {
    ; Create validator GUI
    validatorGui := Gui(, "Environment Variable Validator")

    validatorGui.Add("Text", "x10 y10", "Variable Name:")
    varInput := validatorGui.Add("Edit", "x120 y5 w260", "USERNAME")

    btnCheck := validatorGui.Add("Button", "x390 y3 w100", "Check")

    validatorGui.Add("Text", "x10 y45", "Results:")
    resultBox := validatorGui.Add("Edit", "x10 y65 w480 h250 ReadOnly Multi", "")

    ; Predefined variables to test
    validatorGui.Add("Text", "x10 y325", "Common Variables:")

    btnUsername := validatorGui.Add("Button", "x10 y345 w90", "USERNAME")
    btnTemp := validatorGui.Add("Button", "x110 y345 w90", "TEMP")
    btnPath := validatorGui.Add("Button", "x210 y345 w90", "PATH")
    btnWinDir := validatorGui.Add("Button", "x310 y345 w90", "WINDIR")
    btnProfile := validatorGui.Add("Button", "x410 y345 w80", "USERPROFILE")

    validatorGui.Show("w500 h390")

    CheckVariable(*) {
        varName := Trim(varInput.Value)

        if varName = "" {
            MsgBox("Please enter a variable name!", "Error")
            return
        }

        ; Get the variable value
        value := EnvGet(varName)

        ; Build result
        result := "Variable: " varName "`n"
        result .= "=" . StrLen("Variable: " varName) . "`n`n"

        if value = "" {
            result .= "Status: NOT FOUND`n"
            result .= "This environment variable does not exist.`n"
        } else {
            result .= "Status: FOUND`n"
            result .= "Value: " value "`n`n"

            ; Additional analysis
            result .= "Length: " StrLen(value) " characters`n`n"

            ; Check if it's a path
            if InStr(value, "\") || InStr(value, "/") {
                result .= "Type: Appears to be a path`n"

                if DirExist(value) {
                    result .= "Path Status: Directory exists`n"
                } else if FileExist(value) {
                    result .= "Path Status: File exists`n"
                } else {
                    result .= "Path Status: Does not exist`n"
                }
            }

            ; Check if it contains multiple paths (like PATH variable)
            if InStr(value, ";") {
                parts := StrSplit(value, ";")
                result .= "`nContains " parts.Length " semicolon-separated parts`n"
            }
        }

        resultBox.Value := result
    }

    ; Event handlers
    btnCheck.OnEvent("Click", CheckVariable)
    varInput.OnEvent("Change", CheckVariable)

    ; Quick access buttons
    btnUsername.OnEvent("Click", (*) => (varInput.Value := "USERNAME", CheckVariable()))
    btnTemp.OnEvent("Click", (*) => (varInput.Value := "TEMP", CheckVariable()))
    btnPath.OnEvent("Click", (*) => (varInput.Value := "PATH", CheckVariable()))
    btnWinDir.OnEvent("Click", (*) => (varInput.Value := "WINDIR", CheckVariable()))
    btnProfile.OnEvent("Click", (*) => (varInput.Value := "USERPROFILE", CheckVariable()))

    ; Initial check
    CheckVariable()
}

;===============================================================================
; EXAMPLE 4: User-Specific Path Construction
;===============================================================================

Example4_UserSpecificPaths() {
    ; Get user profile
    userProfile := EnvGet("USERPROFILE")

    if userProfile = "" {
        MsgBox("Cannot retrieve user profile!", "Error")
        return
    }

    ; Construct common user paths
    paths := Map()
    paths["Desktop"] := userProfile "\Desktop"
    paths["Documents"] := userProfile "\Documents"
    paths["Downloads"] := userProfile "\Downloads"
    paths["Pictures"] := userProfile "\Pictures"
    paths["Music"] := userProfile "\Music"
    paths["Videos"] := userProfile "\Videos"
    paths["AppData"] := EnvGet("APPDATA")
    paths["LocalAppData"] := EnvGet("LOCALAPPDATA")
    paths["Temp"] := EnvGet("TEMP")

    ; Create path browser
    pathGui := Gui(, "User-Specific Paths")

    pathGui.Add("Text", "x10 y10 w380", "Common user paths for: " EnvGet("USERNAME"))

    ; ListView for paths
    lv := pathGui.Add("ListView", "x10 y40 w480 h250", ["Location", "Path", "Exists"])

    ; Populate ListView
    for location, path in paths {
        exists := DirExist(path) ? "✓" : "✗"
        lv.Add(, location, path, exists)
    }

    ; Auto-size columns
    lv.ModifyCol(1, 100)
    lv.ModifyCol(2, 280)
    lv.ModifyCol(3, 60)

    ; Add open button
    btnOpen := pathGui.Add("Button", "x10 y300 w150 h30", "Open Selected")
    btnCopy := pathGui.Add("Button", "x170 y300 w150 h30", "Copy Path")
    btnClose := pathGui.Add("Button", "x330 y300 w160 h30", "Close")

    pathGui.Show("w500 h350")

    OpenSelected(*) {
        if lv.GetNext() = 0 {
            MsgBox("Please select a path first!", "No Selection")
            return
        }

        row := lv.GetNext()
        path := lv.GetText(row, 2)

        if DirExist(path) {
            Run(path)
        } else {
            MsgBox("Path does not exist: " path, "Error")
        }
    }

    CopyPath(*) {
        if lv.GetNext() = 0 {
            MsgBox("Please select a path first!", "No Selection")
            return
        }

        row := lv.GetNext()
        path := lv.GetText(row, 2)

        A_Clipboard := path
        MsgBox("Path copied to clipboard!", "Success")
    }

    btnOpen.OnEvent("Click", OpenSelected)
    btnCopy.OnEvent("Click", CopyPath)
    btnClose.OnEvent("Click", (*) => pathGui.Destroy())
}

;===============================================================================
; EXAMPLE 5: System Info Collector
;===============================================================================

Example5_SystemInfoCollector() {
    ; Collect comprehensive system information
    sysInfo := Map()

    ; User information
    sysInfo["Username"] := EnvGet("USERNAME")
    sysInfo["User Domain"] := EnvGet("USERDOMAIN")
    sysInfo["User Profile"] := EnvGet("USERPROFILE")
    sysInfo["Home Drive"] := EnvGet("HOMEDRIVE")
    sysInfo["Home Path"] := EnvGet("HOMEPATH")

    ; Computer information
    sysInfo["Computer Name"] := EnvGet("COMPUTERNAME")
    sysInfo["Processor"] := EnvGet("PROCESSOR_IDENTIFIER")
    sysInfo["Processor Architecture"] := EnvGet("PROCESSOR_ARCHITECTURE")
    sysInfo["Number of Processors"] := EnvGet("NUMBER_OF_PROCESSORS")

    ; System directories
    sysInfo["Windows Directory"] := EnvGet("WINDIR")
    sysInfo["System Root"] := EnvGet("SYSTEMROOT")
    sysInfo["System Drive"] := EnvGet("SYSTEMDRIVE")
    sysInfo["Program Files"] := EnvGet("PROGRAMFILES")
    sysInfo["Program Files (x86)"] := EnvGet("PROGRAMFILES(X86)")

    ; Application data
    sysInfo["AppData"] := EnvGet("APPDATA")
    sysInfo["Local AppData"] := EnvGet("LOCALAPPDATA")
    sysInfo["Common Program Files"] := EnvGet("COMMONPROGRAMFILES")

    ; Temporary directories
    sysInfo["Temp"] := EnvGet("TEMP")
    sysInfo["TMP"] := EnvGet("TMP")

    ; Other
    sysInfo["Path Ext"] := EnvGet("PATHEXT")
    sysInfo["OS"] := EnvGet("OS")

    ; Create display GUI
    infoGui := Gui(, "System Information")

    infoGui.Add("Text", "x10 y10 w480", "Complete System Environment Information")

    ; Create tabs for organization
    tabs := infoGui.Add("Tab3", "x10 y40 w480 h350", ["User", "Computer", "Directories", "All"])

    ; User Tab
    tabs.UseTab("User")
    userInfo := ""
    for key in ["Username", "User Domain", "User Profile", "Home Drive", "Home Path"] {
        if sysInfo.Has(key)
            userInfo .= key ": " sysInfo[key] "`n"
    }
    infoGui.Add("Edit", "x20 y70 w460 h300 ReadOnly Multi", userInfo)

    ; Computer Tab
    tabs.UseTab("Computer")
    compInfo := ""
    for key in ["Computer Name", "Processor", "Processor Architecture", "Number of Processors", "OS"] {
        if sysInfo.Has(key)
            compInfo .= key ": " sysInfo[key] "`n"
    }
    infoGui.Add("Edit", "x20 y70 w460 h300 ReadOnly Multi", compInfo)

    ; Directories Tab
    tabs.UseTab("Directories")
    dirInfo := ""
    for key in ["Windows Directory", "System Root", "System Drive", "Program Files",
        "Program Files (x86)", "AppData", "Local AppData", "Temp"] {
        if sysInfo.Has(key) && sysInfo[key] != ""
            dirInfo .= key ": " sysInfo[key] "`n"
    }
    infoGui.Add("Edit", "x20 y70 w460 h300 ReadOnly Multi", dirInfo)

    ; All Tab
    tabs.UseTab("All")
    allInfo := ""
    for key, value in sysInfo {
        if value != ""
            allInfo .= key ": " value "`n"
    }
    infoGui.Add("Edit", "x20 y70 w460 h300 ReadOnly Multi", allInfo)

    tabs.UseTab()

    ; Add buttons
    btnExport := infoGui.Add("Button", "x10 y400 w150 h30", "Export to File")
    btnCopy := infoGui.Add("Button", "x170 y400 w150 h30", "Copy All")
    btnClose := infoGui.Add("Button", "x330 y400 w160 h30", "Close")

    infoGui.Show("w500 h450")

    ExportToFile(*) {
        ; Create export text
        exportText := "System Information Report`n"
        exportText .= "Generated: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n"
        exportText .= "=" . StrLen(exportText) . "`n`n"

        for key, value in sysInfo {
            if value != ""
                exportText .= key ": " value "`n"
        }

        ; Save to file
        fileName := EnvGet("USERPROFILE") "\Desktop\SystemInfo_" A_Now ".txt"
        FileAppend(exportText, fileName)

        MsgBox("System information exported to:`n" fileName, "Export Complete")
    }

    CopyAll(*) {
        allText := ""
        for key, value in sysInfo {
            if value != ""
                allText .= key ": " value "`n"
        }

        A_Clipboard := allText
        MsgBox("All system information copied to clipboard!", "Success")
    }

    btnExport.OnEvent("Click", ExportToFile)
    btnCopy.OnEvent("Click", CopyAll)
    btnClose.OnEvent("Click", (*) => infoGui.Destroy())
}

;===============================================================================
; EXAMPLE 6: Environment Variable Search Tool
;===============================================================================

Example6_EnvVarSearchTool() {
    ; Create search tool
    searchGui := Gui(, "Environment Variable Search")

    searchGui.Add("Text", "x10 y10", "Search:")
    searchInput := searchGui.Add("Edit", "x60 y5 w320", "")
    btnSearch := searchGui.Add("Button", "x390 y3 w100", "Search")

    searchGui.Add("Text", "x10 y45", "Results:")
    resultsLV := searchGui.Add("ListView", "x10 y65 w480 h300", ["Variable", "Value"])

    statsText := searchGui.Add("Text", "x10 y375 w480", "Found: 0 variables")

    btnRefresh := searchGui.Add("Button", "x10 y400 w150 h30", "Refresh All")
    btnClose := searchGui.Add("Button", "x340 y400 w150 h30", "Close")

    searchGui.Show("w500 h450")

    ; Common environment variables to search
    commonVars := [
        "PATH", "PATHEXT", "TEMP", "TMP", "USERNAME", "USERPROFILE",
        "COMPUTERNAME", "USERDOMAIN", "HOMEDRIVE", "HOMEPATH",
        "WINDIR", "SYSTEMROOT", "SYSTEMDRIVE", "PROGRAMFILES",
        "PROGRAMFILES(X86)", "APPDATA", "LOCALAPPDATA", "COMMONPROGRAMFILES",
        "PROCESSOR_IDENTIFIER", "PROCESSOR_ARCHITECTURE", "NUMBER_OF_PROCESSORS",
        "OS", "COMSPEC", "ALLUSERSPROFILE", "PUBLIC", "PROGRAMDATA"
    ]

    PerformSearch(*) {
        searchTerm := Trim(searchInput.Value)
        resultsLV.Delete()

        foundCount := 0

        for varName in commonVars {
            value := EnvGet(varName)

            ; Skip if not found
            if value = ""
                continue

            ; Check if search term matches (case-insensitive)
            if searchTerm = "" ||
                InStr(varName, searchTerm, false) ||
                InStr(value, searchTerm, false) {
                ; Truncate long values for display
                displayValue := value
                if StrLen(displayValue) > 80
                    displayValue := SubStr(displayValue, 1, 77) "..."

                resultsLV.Add(, varName, displayValue)
                foundCount++
            }
        }

        ; Auto-size columns
        resultsLV.ModifyCol(1, 150)
        resultsLV.ModifyCol(2, 320)

        statsText.Value := "Found: " foundCount " variables"

        if foundCount = 0 && searchTerm != ""
            MsgBox("No variables found matching: " searchTerm, "No Results")
    }

    RefreshAll(*) {
        searchInput.Value := ""
        PerformSearch()
    }

    btnSearch.OnEvent("Click", PerformSearch)
    searchInput.OnEvent("Change", PerformSearch)
    btnRefresh.OnEvent("Click", RefreshAll)
    btnClose.OnEvent("Click", (*) => searchGui.Destroy())

    ; Initial load
    RefreshAll()
}

;===============================================================================
; EXAMPLE 7: Portable Script Path Builder
;===============================================================================

Example7_PortablePathBuilder() {
    ; Demonstrate building portable paths
    builderGui := Gui(, "Portable Path Builder")

    builderGui.Add("Text", "x10 y10 w480",
        "Build portable paths that work on any user's computer")

    ; Base path selector
    builderGui.Add("Text", "x10 y40", "Base Path:")
    baseSelect := builderGui.Add("DropDownList", "x80 y35 w200 Choose1",
        ["USERPROFILE", "APPDATA", "LOCALAPPDATA", "TEMP", "PROGRAMFILES"])

    ; Relative path
    builderGui.Add("Text", "x10 y70", "Relative Path:")
    relPath := builderGui.Add("Edit", "x100 y65 w380", "\MyApp\Data")

    ; Result
    builderGui.Add("Text", "x10 y100", "Full Path:")
    fullPath := builderGui.Add("Edit", "x80 y95 w400 ReadOnly", "")

    ; Code example
    builderGui.Add("Text", "x10 y130", "AHK Code:")
    codeExample := builderGui.Add("Edit", "x10 y150 w470 h60 ReadOnly Multi", "")

    btnBuild := builderGui.Add("Button", "x10 y220 w150 h30", "Build Path")
    btnTest := builderGui.Add("Button", "x170 y220 w150 h30", "Test Path")
    btnCopy := builderGui.Add("Button", "x330 y220 w150 h30", "Copy Code")

    builderGui.Show("w490 h270")

    BuildPath(*) {
        baseVar := baseSelect.Text
        rel := relPath.Value

        ; Get base path from environment
        base := EnvGet(baseVar)

        if base = "" {
            MsgBox("Environment variable not found: " baseVar, "Error")
            return
        }

        ; Build full path
        full := base . rel
        fullPath.Value := full

        ; Generate code
        code := '; Portable path construction`n'
        code .= 'basePath := EnvGet("' baseVar '")`n'
        code .= 'fullPath := basePath "' rel '"'

        codeExample.Value := code
    }

    TestPath(*) {
        path := fullPath.Value

        if path = "" {
            MsgBox("Please build a path first!", "Error")
            return
        }

        result := "Path: " path "`n`n"

        if DirExist(path) {
            result .= "Status: Directory exists ✓"
        } else if FileExist(path) {
            result .= "Status: File exists ✓"
        } else {
            result .= "Status: Does not exist ✗`n`n"
            result .= "Would you like to create this directory?"

            response := MsgBox(result, "Test Result", "YesNo")
            if response = "Yes" {
                try {
                    DirCreate(path)
                    MsgBox("Directory created successfully!", "Success")
                } catch Error as err {
                    MsgBox("Error creating directory:`n" err.Message, "Error")
                }
            }
            return
        }

        MsgBox(result, "Test Result")
    }

    CopyCode(*) {
        code := codeExample.Value
        if code = "" {
            MsgBox("No code to copy!", "Error")
            return
        }

        A_Clipboard := code
        MsgBox("Code copied to clipboard!", "Success")
    }

    btnBuild.OnEvent("Click", BuildPath)
    btnTest.OnEvent("Click", TestPath)
    btnCopy.OnEvent("Click", CopyCode)
    baseSelect.OnEvent("Change", BuildPath)
    relPath.OnEvent("Change", BuildPath)

    ; Initial build
    BuildPath()
}

;===============================================================================
; Run Examples
;===============================================================================

; Uncomment to run specific examples:
; Example1_BasicEnvGet()
; Example2_PathVariableAnalysis()
; Example3_EnvVarValidator()
; Example4_UserSpecificPaths()
; Example5_SystemInfoCollector()
; Example6_EnvVarSearchTool()
; Example7_PortablePathBuilder()

