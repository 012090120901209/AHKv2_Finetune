#Requires AutoHotkey v2.0
/**
 * BuiltIn_EnvGet_03_UserEnvironment.ahk
 *
 * DESCRIPTION:
 * Working with user-specific environment variables for cross-platform
 * and multi-user script compatibility and configuration management.
 *
 * FEATURES:
 * - User vs system environment variables
 * - AppData and LocalAppData directory usage
 * - User profile path construction
 * - Portable configuration file storage
 * - Multi-user script awareness
 * - Roaming vs local data management
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - EnvGet() for retrieving user variables
 * - String concatenation for dynamic paths
 * - File operations with environment-based paths
 * - DirExist and FileExist validation
 * - IniRead/IniWrite with portable paths
 *
 * LEARNING POINTS:
 * 1. User variables are specific to each Windows user
 * 2. APPDATA stores roaming profile data
 * 3. LOCALAPPDATA stores machine-specific data
 * 4. Build portable paths using EnvGet
 * 5. Always validate paths retrieved from environment
 * 6. Use USERPROFILE for user-specific files
 * 7. Configuration should use appropriate data folders
 */

;===============================================================================
; EXAMPLE 1: User-Specific Configuration Manager
;===============================================================================

Example1_ConfigManager() {
    ; Get user's local app data directory
    localAppData := EnvGet("LOCALAPPDATA")
    
    if !localAppData {
        MsgBox("Cannot retrieve LOCALAPPDATA!", "Error")
        return
    }
    
    ; Create config directory
    configDir := localAppData "\MyAHKScript"
    configFile := configDir "\settings.ini"
    
    ; Ensure directory exists
    if !DirExist(configDir) {
        try {
            DirCreate(configDir)
        } catch Error as err {
            MsgBox("Cannot create config directory:`n" err.Message, "Error")
            return
        }
    }
    
    ; Create configuration GUI
    gui := Gui(, "User Configuration Manager")
    
    gui.Add("Text", "x10 y10 w380", "Configuration stored in: " configDir)
    
    ; Load existing settings or use defaults
    username := IniRead(configFile, "User", "Name", A_UserName)
    theme := IniRead(configFile, "Appearance", "Theme", "Light")
    autoStart := IniRead(configFile, "Options", "AutoStart", "0")
    
    ; Create form
    gui.Add("Text", "x10 y40", "Display Name:")
    nameEdit := gui.Add("Edit", "x120 y35 w270", username)
    
    gui.Add("Text", "x10 y70", "Theme:")
    themeDD := gui.Add("DropDownList", "x120 y65 w150 Choose" (theme = "Dark" ? 2 : 1), ["Light", "Dark"])
    
    autoStartCB := gui.Add("Checkbox", "x10 y100 Checked" autoStart, "Launch at startup")
    
    ; Buttons
    btnSave := gui.Add("Button", "x10 y140 w120 h30", "Save Settings")
    btnReset := gui.Add("Button", "x140 y140 w120 h30", "Reset to Default")
    btnOpen := gui.Add("Button", "x270 y140 w120 h30", "Open Config Folder")
    
    gui.Show("w400 h190")
    
    SaveSettings(*) {
        ; Save to INI file
        IniWrite(nameEdit.Value, configFile, "User", "Name")
        IniWrite(themeDD.Text, configFile, "Appearance", "Theme")
        IniWrite(autoStartCB.Value, configFile, "Options", "AutoStart")
        
        MsgBox("Settings saved to:`n" configFile, "Success")
    }
    
    ResetSettings(*) {
        result := MsgBox("Reset all settings to default?", "Confirm", "YesNo")
        if result = "Yes" {
            nameEdit.Value := A_UserName
            themeDD.Choose(1)
            autoStartCB.Value := 0
        }
    }
    
    OpenFolder(*) {
        if DirExist(configDir)
            Run(configDir)
        else
            MsgBox("Config folder not found!", "Error")
    }
    
    btnSave.OnEvent("Click", SaveSettings)
    btnReset.OnEvent("Click", ResetSettings)
    btnOpen.OnEvent("Click", OpenFolder)
}

;===============================================================================
; EXAMPLE 2: AppData vs LocalAppData Demonstrator
;===============================================================================

Example2_DataLocationDemo() {
    ; Get both app data locations
    appData := EnvGet("APPDATA")
    localAppData := EnvGet("LOCALAPPDATA")
    
    gui := Gui(, "AppData Locations Comparison")
    
    ; Display paths
    gui.Add("GroupBox", "x10 y10 w480 h80", "Roaming Profile Data (APPDATA)")
    gui.Add("Edit", "x20 y30 w460 h50 ReadOnly Multi", appData)
    
    gui.Add("GroupBox", "x10 y100 w480 h80", "Local Machine Data (LOCALAPPDATA)")
    gui.Add("Edit", "x20 y120 w460 h50 ReadOnly Multi", localAppData)
    
    ; Explanation
    gui.Add("Text", "x10 y190 w480 h120",
        "APPDATA (Roaming):`n"
        "- Syncs across domain computers`n"
        "- Use for: Settings, preferences, user documents`n"
        "`n"
        "LOCALAPPDATA:`n"
        "- Machine-specific, doesn't roam`n"
        "- Use for: Cache, temporary files, large data")
    
    ; Demonstrate file creation in both
    btnRoaming := gui.Add("Button", "x10 y320 w230 h30", "Create Test File in Roaming")
    btnLocal := gui.Add("Button", "x260 y320 w230 h30", "Create Test File in Local")
    
    gui.Show("w500 h370")
    
    CreateRoamingFile(*) {
        testDir := appData "\AHKTest"
        if !DirExist(testDir)
            DirCreate(testDir)
        
        testFile := testDir "\roaming_test.txt"
        FileAppend("This file syncs across computers`nCreated: " A_Now, testFile)
        
        MsgBox("Created roaming file:`n" testFile "`n`nThis file will sync to other domain computers.", "Roaming File")
        Run(testDir)
    }
    
    CreateLocalFile(*) {
        testDir := localAppData "\AHKTest"
        if !DirExist(testDir)
            DirCreate(testDir)
        
        testFile := testDir "\local_test.txt"
        FileAppend("This file stays on this computer`nCreated: " A_Now, testFile)
        
        MsgBox("Created local file:`n" testFile "`n`nThis file remains on this computer only.", "Local File")
        Run(testDir)
    }
    
    btnRoaming.OnEvent("Click", CreateRoamingFile)
    btnLocal.OnEvent("Click", CreateLocalFile)
}

;===============================================================================
; EXAMPLE 3: Multi-User Script Data Manager
;===============================================================================

Example3_MultiUserDataManager() {
    ; Get user information
    username := EnvGet("USERNAME")
    userDomain := EnvGet("USERDOMAIN")
    userProfile := EnvGet("USERPROFILE")
    
    ; Create data directory in user profile
    dataDir := userProfile "\Documents\MyScriptData"
    
    if !DirExist(dataDir) {
        try DirCreate(dataDir)
    }
    
    gui := Gui(, "Multi-User Data Manager - " username)
    
    gui.Add("Text", "x10 y10 w380", "Current User: " username "@" userDomain)
    gui.Add("Text", "x10 y30 w380", "Data Directory: " dataDir)
    
    ; File list
    gui.Add("Text", "x10 y60", "Your Files:")
    fileList := gui.Add("ListBox", "x10 y80 w480 h200", [])
    
    ; Buttons
    btnRefresh := gui.Add("Button", "x10 y290 w100 h30", "Refresh")
    btnCreate := gui.Add("Button", "x120 y290 w100 h30", "Create File")
    btnOpen := gui.Add("Button", "x230 y290 w120 h30", "Open Selected")
    btnFolder := gui.Add("Button", "x360 y290 w130 h30", "Open Data Folder")
    
    gui.Show("w500 h340")
    
    RefreshFileList(*) {
        fileList.Delete()
        
        if !DirExist(dataDir)
            return
        
        files := []
        Loop Files, dataDir "\*.*" {
            files.Push(A_LoopFileName)
        }
        
        if files.Length > 0
            fileList.Add(files)
        else
            fileList.Add(["(No files yet)"])
    }
    
    CreateNewFile(*) {
        fileName := InputBox("Enter filename:", "Create File", "w300 h100")
        if fileName.Result = "Cancel"
            return
        
        fullPath := dataDir "\" fileName.Value
        
        if !InStr(fullPath, ".txt")
            fullPath .= ".txt"
        
        content := "File created by: " username "`n"
        content .= "Date: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n"
        content .= "Computer: " A_ComputerName "`n"
        
        try {
            FileAppend(content, fullPath)
            MsgBox("File created successfully!", "Success")
            RefreshFileList()
        } catch Error as err {
            MsgBox("Error creating file:`n" err.Message, "Error")
        }
    }
    
    OpenSelected(*) {
        selected := fileList.GetNext()
        if !selected {
            MsgBox("Please select a file!", "Error")
            return
        }
        
        fileName := fileList.GetText(selected)
        if fileName = "(No files yet)"
            return
        
        fullPath := dataDir "\" fileName
        if FileExist(fullPath)
            Run(fullPath)
    }
    
    OpenDataFolder(*) {
        if DirExist(dataDir)
            Run(dataDir)
    }
    
    btnRefresh.OnEvent("Click", RefreshFileList)
    btnCreate.OnEvent("Click", CreateNewFile)
    btnOpen.OnEvent("Click", OpenSelected)
    btnFolder.OnEvent("Click", OpenDataFolder)
    
    ; Initial refresh
    RefreshFileList()
}

;===============================================================================
; EXAMPLE 4: Portable Application Template
;===============================================================================

Example4_PortableAppTemplate() {
    ; Create a portable application structure
    
    class PortableApp {
        __New() {
            ; Determine if running portable or installed
            this.appName := "MyPortableApp"
            this.scriptDir := A_ScriptDir
            
            ; Check for portable marker
            portableMarker := this.scriptDir "\portable.txt"
            this.isPortable := FileExist(portableMarker) ? true : false
            
            ; Set data directory based on mode
            if this.isPortable {
                ; Use script directory for portable mode
                this.dataDir := this.scriptDir "\Data"
                this.configDir := this.scriptDir "\Config"
            } else {
                ; Use user's AppData for installed mode
                localAppData := EnvGet("LOCALAPPDATA")
                this.dataDir := localAppData "\" this.appName "\Data"
                this.configDir := localAppData "\" this.appName "\Config"
            }
            
            ; Create directories
            if !DirExist(this.dataDir)
                DirCreate(this.dataDir)
            if !DirExist(this.configDir)
                DirCreate(this.configDir)
            
            this.configFile := this.configDir "\settings.ini"
        }
        
        ShowInfo() {
            gui := Gui(, this.appName " - Application Info")
            
            info := "Application Mode: " (this.isPortable ? "PORTABLE" : "INSTALLED") "`n`n"
            info .= "Script Directory: " this.scriptDir "`n"
            info .= "Data Directory: " this.dataDir "`n"
            info .= "Config Directory: " this.configDir "`n"
            info .= "Config File: " this.configFile "`n`n"
            
            if this.isPortable {
                info .= "PORTABLE MODE:`n"
                info .= "- All data stored in script folder`n"
                info .= "- Can be moved to USB drive`n"
                info .= "- Settings follow the application`n"
            } else {
                info .= "INSTALLED MODE:`n"
                info .= "- Data stored in user's AppData`n"
                info .= "- Follows Windows conventions`n"
                info .= "- User-specific settings`n"
            }
            
            gui.Add("Edit", "x10 y10 w480 h250 ReadOnly Multi", info)
            
            btnToggle := gui.Add("Button", "x10 y270 w230 h30",
                                this.isPortable ? "Switch to Installed" : "Switch to Portable")
            btnClose := gui.Add("Button", "x260 y270 w230 h30", "Close")
            
            gui.Show("w500 h320")
            
            btnToggle.OnEvent("Click", (*) => this.ToggleMode())
            btnClose.OnEvent("Click", (*) => gui.Destroy())
        }
        
        ToggleMode() {
            portableMarker := this.scriptDir "\portable.txt"
            
            if this.isPortable {
                ; Switch to installed
                if FileExist(portableMarker)
                    FileDelete(portableMarker)
                MsgBox("Switched to INSTALLED mode`nPlease restart the script.", "Mode Changed")
            } else {
                ; Switch to portable
                FileAppend("This file marks portable mode", portableMarker)
                MsgBox("Switched to PORTABLE mode`nPlease restart the script.", "Mode Changed")
            }
        }
    }
    
    ; Create and show app
    app := PortableApp()
    app.ShowInfo()
}

;===============================================================================
; EXAMPLE 5: User Environment Explorer
;===============================================================================

Example5_EnvironmentExplorer() {
    ; Create comprehensive environment explorer
    gui := Gui(, "User Environment Explorer")
    
    ; Get all user-related variables
    userVars := Map()
    userVars["USERNAME"] := EnvGet("USERNAME")
    userVars["USERPROFILE"] := EnvGet("USERPROFILE")
    userVars["USERDOMAIN"] := EnvGet("USERDOMAIN")
    userVars["HOMEDRIVE"] := EnvGet("HOMEDRIVE")
    userVars["HOMEPATH"] := EnvGet("HOMEPATH")
    userVars["APPDATA"] := EnvGet("APPDATA")
    userVars["LOCALAPPDATA"] := EnvGet("LOCALAPPDATA")
    userVars["TEMP"] := EnvGet("TEMP")
    userVars["TMP"] := EnvGet("TMP")
    
    ; Create tabs
    tabs := gui.Add("Tab3", "x10 y10 w480 h350", ["Variables", "Folders", "Tools"])
    
    ; Variables tab
    tabs.UseTab("Variables")
    lv := gui.Add("ListView", "x20 y40 w460 h300", ["Variable", "Value", "Valid"])
    
    for varName, value in userVars {
        valid := ""
        if InStr(value, "\") {
            valid := DirExist(value) || FileExist(value) ? "✓" : "✗"
        }
        lv.Add(, varName, value, valid)
    }
    lv.ModifyCol()
    
    ; Folders tab
    tabs.UseTab("Folders")
    folders := gui.Add("ListBox", "x20 y40 w460 h260", [])
    
    folderList := []
    for varName, value in userVars {
        if DirExist(value)
            folderList.Push(varName ": " value)
    }
    folders.Add(folderList)
    
    btnOpenFolder := gui.Add("Button", "x20 y310 w200 h25", "Open Selected Folder")
    
    ; Tools tab
    tabs.UseTab("Tools")
    gui.Add("Button", "x20 y40 w200 h30", "Show Desktop Path").OnEvent("Click",
        (*) => MsgBox(EnvGet("USERPROFILE") "\Desktop"))
    gui.Add("Button", "x20 y80 w200 h30", "Show Documents Path").OnEvent("Click",
        (*) => MsgBox(EnvGet("USERPROFILE") "\Documents"))
    gui.Add("Button", "x20 y120 w200 h30", "Show Temp Path").OnEvent("Click",
        (*) => MsgBox(EnvGet("TEMP")))
    gui.Add("Button", "x20 y160 w200 h30", "Clear Temp Files").OnEvent("Click",
        (*) => MsgBox("This would clear: " EnvGet("TEMP")))
    
    tabs.UseTab()
    
    gui.Add("Button", "x190 y370 w100 h30", "Close").OnEvent("Click", (*) => gui.Destroy())
    
    btnOpenFolder.OnEvent("Click", (*) => (
        selected := folders.GetNext(),
        selected ? Run(StrSplit(folders.GetText(selected), ": ")[2]) : ""
    ))
    
    gui.Show("w500 h420")
}

;===============================================================================
; EXAMPLE 6: Cross-Platform Path Helper
;===============================================================================

Example6_CrossPlatformPaths() {
    ; Helper class for building portable paths
    class PathBuilder {
        static GetUserPath(subPath) {
            return EnvGet("USERPROFILE") "\" subPath
        }
        
        static GetAppDataPath(subPath) {
            return EnvGet("APPDATA") "\" subPath
        }
        
        static GetLocalAppDataPath(subPath) {
            return EnvGet("LOCALAPPDATA") "\" subPath
        }
        
        static GetDesktop() {
            return EnvGet("USERPROFILE") "\Desktop"
        }
        
        static GetDocuments() {
            return EnvGet("USERPROFILE") "\Documents"
        }
    }
    
    ; Demo GUI
    gui := Gui(, "Cross-Platform Path Builder")
    
    gui.Add("Text", "x10 y10", "Path Type:")
    pathType := gui.Add("DropDownList", "x100 y5 w200 Choose1",
                        ["User Profile", "AppData", "LocalAppData", "Desktop", "Documents"])
    
    gui.Add("Text", "x10 y40", "Subpath:")
    subPath := gui.Add("Edit", "x100 y35 w300", "MyApp\Data")
    
    gui.Add("Text", "x10 y75", "Result:")
    result := gui.Add("Edit", "x10 y95 w480 h60 ReadOnly Multi", "")
    
    btnBuild := gui.Add("Button", "x10 y165 w150 h30", "Build Path")
    btnCreate := gui.Add("Button", "x170 y165 w150 h30", "Create Directory")
    btnOpen := gui.Add("Button", "x330 y165 w160 h30", "Open in Explorer")
    
    gui.Show("w500 h215")
    
    BuildPath(*) {
        sub := subPath.Value
        fullPath := ""
        
        switch pathType.Value {
            case 1: fullPath := PathBuilder.GetUserPath(sub)
            case 2: fullPath := PathBuilder.GetAppDataPath(sub)
            case 3: fullPath := PathBuilder.GetLocalAppDataPath(sub)
            case 4: fullPath := PathBuilder.GetDesktop()
            case 5: fullPath := PathBuilder.GetDocuments()
        }
        
        result.Value := fullPath "`n`nExists: " (DirExist(fullPath) ? "Yes" : "No")
    }
    
    CreateDir(*) {
        BuildPath()
        path := StrSplit(result.Value, "`n")[1]
        
        if DirExist(path) {
            MsgBox("Directory already exists!", "Info")
            return
        }
        
        try {
            DirCreate(path)
            MsgBox("Directory created successfully!", "Success")
            BuildPath()
        } catch Error as err {
            MsgBox("Error: " err.Message, "Error")
        }
    }
    
    OpenDir(*) {
        BuildPath()
        path := StrSplit(result.Value, "`n")[1]
        
        if DirExist(path)
            Run(path)
        else
            MsgBox("Directory does not exist!", "Error")
    }
    
    btnBuild.OnEvent("Click", BuildPath)
    btnCreate.OnEvent("Click", CreateDir)
    btnOpen.OnEvent("Click", OpenDir)
    pathType.OnEvent("Change", BuildPath)
    subPath.OnEvent("Change", BuildPath)
    
    BuildPath()
}

;===============================================================================
; Run Examples
;===============================================================================

; Uncomment to run:
; Example1_ConfigManager()
; Example2_DataLocationDemo()
; Example3_MultiUserDataManager()
; Example4_PortableAppTemplate()
; Example5_EnvironmentExplorer()
; Example6_CrossPlatformPaths()
