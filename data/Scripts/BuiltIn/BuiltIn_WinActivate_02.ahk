#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * WinActivate Examples - Part 2: Activate by Window Class
 * ============================================================================
 * 
 * This script demonstrates how to use WinActivate with window classes.
 * Window classes are more reliable than titles for identifying windows,
 * as they don't change when the window content changes.
 * 
 * @description Advanced window activation using class names and combinations
 * @author AutoHotkey Community
 * @version 2.0.0
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Activate by Window Class
; ============================================================================

/**
 * Activates windows using their window class
 * Window classes are internal identifiers that remain constant
 * 
 * @hotkey F1 - Activate Notepad by class
 */
F1:: {
    try {
        ; Notepad's window class is "Notepad"
        if WinExist("ahk_class Notepad") {
            WinActivate()
            ToolTip("Notepad activated using class: Notepad")
            SetTimer(() => ToolTip(), -2000)
        } else {
            result := MsgBox("Notepad not found. Launch it?", "Launch Notepad", 4)
            if result = "Yes" {
                Run("notepad.exe")
                WinWait("ahk_class Notepad", , 5)
                WinActivate()
            }
        }
    } catch Error as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 2: Combine Class and Title for Precise Matching
; ============================================================================

/**
 * Uses multiple criteria to identify windows precisely
 * Combining class and title helps avoid ambiguity
 * 
 * @hotkey F2 - Activate specific window using class and title
 */
F2:: {
    try {
        ; Find Windows Explorer window showing a specific folder
        windowCriteria := "ahk_class CabinetWClass ahk_exe explorer.exe"

        if WinExist(windowCriteria) {
            WinActivate()
            path := GetExplorerPath()
            ToolTip("Activated Explorer window: " path)
            SetTimer(() => ToolTip(), -3000)
        } else {
            MsgBox("No File Explorer window found.", "Info", 64)
        }
    } catch Error as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

/**
 * Gets the current path from the active Explorer window
 * 
 * @returns {String} Current folder path
 */
GetExplorerPath() {
    try {
        for window in ComObject("Shell.Application").Windows {
            if (window.HWND = WinGetID("A")) {
                return window.Document.Folder.Self.Path
            }
        }
        return "Path not available"
    } catch {
        return "Error getting path"
    }
}

; ============================================================================
; Example 3: Class-Based Application Switcher
; ============================================================================

/**
 * Switches between common applications using their window classes
 * Creates a reliable app switcher independent of window titles
 * 
 * @hotkey F3 - Show application class switcher
 */
F3:: {
    ShowClassSwitcher()
}

/**
 * Displays a GUI to switch between applications by class
 */
ShowClassSwitcher() {
    static classSwitcherGui := ""

    if classSwitcherGui {
        try classSwitcherGui.Destroy()
    }

    classSwitcherGui := Gui("+AlwaysOnTop", "Application Switcher (by Class)")
    classSwitcherGui.SetFont("s10", "Segoe UI")

    ; Define common application classes
    appClasses := Map(
        "Notepad", "ahk_class Notepad",
        "Calculator", "ahk_class ApplicationFrameWindow ahk_exe ApplicationFrameHost.exe",
        "File Explorer", "ahk_class CabinetWClass",
        "Task Manager", "ahk_class TaskManagerWindow",
        "Chrome", "ahk_class Chrome_WidgetWin_1",
        "Firefox", "ahk_class MozillaWindowClass",
        "Visual Studio Code", "ahk_class Chrome_WidgetWin_1 ahk_exe Code.exe",
        "Command Prompt", "ahk_class ConsoleWindowClass"
    )

    classSwitcherGui.Add("Text", "w350", "Select application to activate:")

    appList := classSwitcherGui.Add("ListBox", "w350 h250 vSelectedApp")
    availableApps := []

    ; Check which applications are running
    for appName, classSpec in appClasses {
        if WinExist(classSpec) {
            count := WinGetCount(classSpec)
            availableApps.Push(appName " (" count " window" (count > 1 ? "s" : "") ")")
        }
    }

    if availableApps.Length > 0 {
        appList.Add(availableApps)
        appList.Choose(1)
    } else {
        appList.Add(["No matching applications running"])
    }

    classSwitcherGui.Add("Button", "w170 Default", "Activate").OnEvent("Click", ActivateApp)
    classSwitcherGui.Add("Button", "w170 x+10 yp", "Close").OnEvent("Click", (*) => classSwitcherGui.Destroy())

    classSwitcherGui.Show()

    ActivateApp(*) {
        try {
            selected := appList.Text
            ; Extract app name (remove count info)
            appName := RegExReplace(selected, " \(\d+ window.*\)$", "")

            if appClasses.Has(appName) {
                WinActivate(appClasses[appName])
                classSwitcherGui.Destroy()
                ToolTip("Activated: " appName)
                SetTimer(() => ToolTip(), -2000)
            }
        } catch Error as err {
            MsgBox("Error: " err.Message, "Error", 16)
        }
    }
}

; ============================================================================
; Example 4: Window Class Inspector Tool
; ============================================================================

/**
 * Creates a tool to inspect window classes
 * Useful for discovering class names of windows
 * 
 * @hotkey F4 - Show window class inspector
 */
F4:: {
    ShowClassInspector()
}

/**
 * Displays window class information for the window under cursor
 */
ShowClassInspector() {
    static inspectorGui := ""
    static updateTimer := 0

    if inspectorGui {
        try inspectorGui.Destroy()
    }

    inspectorGui := Gui("+AlwaysOnTop +ToolWindow", "Window Class Inspector")
    inspectorGui.SetFont("s9", "Consolas")

    inspectorGui.Add("Text", "w500", "Hover over a window to see its information:")
    inspectorGui.Add("Text", "w500 h2 0x10")  ; Separator

    ; Add controls for displaying window info
    inspectorGui.Add("Text", "w100", "Window Title:")
    titleCtrl := inspectorGui.Add("Edit", "w400 x+5 yp-3 ReadOnly vTitle")

    inspectorGui.Add("Text", "w100 xm", "Window Class:")
    classCtrl := inspectorGui.Add("Edit", "w400 x+5 yp-3 ReadOnly vClass")

    inspectorGui.Add("Text", "w100 xm", "Process Name:")
    processCtrl := inspectorGui.Add("Edit", "w400 x+5 yp-3 ReadOnly vProcess")

    inspectorGui.Add("Text", "w100 xm", "Process ID:")
    pidCtrl := inspectorGui.Add("Edit", "w400 x+5 yp-3 ReadOnly vPID")

    inspectorGui.Add("Text", "w100 xm", "Window ID:")
    hwndCtrl := inspectorGui.Add("Edit", "w400 x+5 yp-3 ReadOnly vHWND")

    inspectorGui.Add("Text", "w100 xm", "Full Criteria:")
    criteriaCtrl := inspectorGui.Add("Edit", "w400 r3 x+5 yp-3 ReadOnly vCriteria")

    ; Add action buttons
    inspectorGui.Add("Button", "w160 xm", "Activate Window").OnEvent("Click", ActivateInspectedWindow)
    inspectorGui.Add("Button", "w160 x+10 yp", "Copy Criteria").OnEvent("Click", CopyCriteria)
    inspectorGui.Add("Button", "w160 x+10 yp", "Close").OnEvent("Click", (*) => CloseInspector())

    inspectorGui.Show()

    ; Start updating window info
    updateTimer := SetTimer(UpdateWindowInfo, 250)

    UpdateWindowInfo() {
        try {
            MouseGetPos(, , &hwnd)

            if hwnd {
                title := WinGetTitle(hwnd)
                class := WinGetClass(hwnd)
                process := WinGetProcessName(hwnd)
                pid := WinGetPID(hwnd)

                titleCtrl.Value := title
                classCtrl.Value := class
                processCtrl.Value := process
                pidCtrl.Value := pid
                hwndCtrl.Value := Format("0x{:X}", hwnd)

                criteria := 'ahk_class ' class ' ahk_exe ' process
                criteriaCtrl.Value := criteria
            }
        }
    }

    ActivateInspectedWindow(*) {
        try {
            hwnd := Integer(hwndCtrl.Value)
            if hwnd {
                WinActivate(hwnd)
                ToolTip("Window activated!")
                SetTimer(() => ToolTip(), -1500)
            }
        } catch Error as err {
            MsgBox("Error: " err.Message, "Error", 16)
        }
    }

    CopyCriteria(*) {
        try {
            A_Clipboard := criteriaCtrl.Value
            ToolTip("Criteria copied to clipboard!")
            SetTimer(() => ToolTip(), -1500)
        } catch Error as err {
            MsgBox("Error: " err.Message, "Error", 16)
        }
    }

    CloseInspector() {
        if updateTimer {
            SetTimer(updateTimer, 0)
        }
        inspectorGui.Destroy()
    }
}

; ============================================================================
; Example 5: Smart Browser Tab Activator by Class
; ============================================================================

/**
 * Cycles through browser windows based on their class
 * Works with multiple browsers
 * 
 * @hotkey F5 - Cycle through browser windows
 */
F5:: {
    CycleBrowserWindows()
}

/**
 * Cycles through all browser windows
 */
CycleBrowserWindows() {
    static lastBrowser := ""
    static browsers := Map(
        "Chrome", "ahk_class Chrome_WidgetWin_1 ahk_exe chrome.exe",
        "Firefox", "ahk_class MozillaWindowClass",
        "Edge", "ahk_class Chrome_WidgetWin_1 ahk_exe msedge.exe"
    )

    ; Find next available browser
    foundNext := false
    startSearching := (lastBrowser = "")

    for browserName, classSpec in browsers {
        if startSearching && WinExist(classSpec) {
            WinActivate()
            lastBrowser := browserName
            ToolTip("Activated: " browserName)
            SetTimer(() => ToolTip(), -2000)
            return
        }

        if browserName = lastBrowser {
            startSearching := true
        }
    }

    ; If we're here, cycle back to first browser
    for browserName, classSpec in browsers {
        if WinExist(classSpec) {
            WinActivate()
            lastBrowser := browserName
            ToolTip("Activated: " browserName)
            SetTimer(() => ToolTip(), -2000)
            return
        }
    }

    MsgBox("No browser windows found.", "Info", 64)
    lastBrowser := ""
}

; ============================================================================
; Example 6: Activate Newest Window by Class
; ============================================================================

/**
 * Activates the most recently created window of a specific class
 * Useful when multiple instances exist
 * 
 * @hotkey F6 - Activate newest Notepad window
 */
F6:: {
    ActivateNewestByClass("Notepad")
}

/**
 * Activates the most recently created window of a class
 * 
 * @param {String} className - Window class name
 */
ActivateNewestByClass(className) {
    try {
        criteria := "ahk_class " className

        if WinExist(criteria) {
            ; Get all windows of this class
            windows := WinGetList(criteria)

            if windows.Length > 0 {
                ; The first window in the list is typically the newest
                newestWindow := windows[1]
                WinActivate(newestWindow)

                title := WinGetTitle(newestWindow)
                ToolTip("Activated newest " className ": " title)
                SetTimer(() => ToolTip(), -2000)
            }
        } else {
            MsgBox("No windows found with class: " className, "Info", 64)
        }
    } catch Error as err {
        MsgBox("Error: " err.Message, "Error", 16)
    }
}

; ============================================================================
; Example 7: Application Launcher and Activator by Class
; ============================================================================

/**
 * Smart launcher that activates if exists, launches if not
 * Uses class for reliable identification
 * 
 * @hotkey F7 - Launch/activate application manager
 */
F7:: {
    ShowAppManager()
}

/**
 * Displays application manager GUI
 */
ShowAppManager() {
    static managerGui := ""

    if managerGui {
        try managerGui.Destroy()
    }

    managerGui := Gui("+AlwaysOnTop", "Application Manager")
    managerGui.SetFont("s10", "Segoe UI")

    ; Define applications with their launch commands and class
    apps := Map(
        "Notepad", { exe: "notepad.exe", class: "ahk_class Notepad" },
        "Calculator", { exe: "calc.exe", class: "ahk_exe ApplicationFrameHost.exe" },
        "Paint", { exe: "mspaint.exe", class: "ahk_class MSPaintApp" },
        "Command Prompt", { exe: "cmd.exe", class: "ahk_class ConsoleWindowClass" }
    )

    managerGui.Add("Text", "w400", "Select an application:")

    appList := managerGui.Add("ListBox", "w400 h200 vSelectedApp")
    appList.Add(Map.Keys(apps))
    appList.Choose(1)

    managerGui.Add("Button", "w125 Default", "Activate").OnEvent("Click", ActivateSelectedApp)
    managerGui.Add("Button", "w125 x+10 yp", "Launch New").OnEvent("Click", LaunchSelectedApp)
    managerGui.Add("Button", "w125 x+10 yp", "Close").OnEvent("Click", (*) => managerGui.Destroy())

    managerGui.Show()

    ActivateSelectedApp(*) {
        try {
            appName := appList.Text
            if apps.Has(appName) {
                appInfo := apps[appName]
                if WinExist(appInfo.class) {
                    WinActivate()
                    ToolTip("Activated: " appName)
                    SetTimer(() => ToolTip(), -1500)
                } else {
                    result := MsgBox(appName " is not running. Launch it?", "Launch?", 4)
                    if result = "Yes" {
                        Run(appInfo.exe)
                    }
                }
            }
        } catch Error as err {
            MsgBox("Error: " err.Message, "Error", 16)
        }
    }

    LaunchSelectedApp(*) {
        try {
            appName := appList.Text
            if apps.Has(appName) {
                Run(apps[appName].exe)
                ToolTip("Launched: " appName)
                SetTimer(() => ToolTip(), -1500)
            }
        } catch Error as err {
            MsgBox("Error: " err.Message, "Error", 16)
        }
    }
}

; ============================================================================
; Cleanup and Help
; ============================================================================

Esc:: ExitApp()

^F1:: {
    help := "
    (
    WinActivate Examples - Part 2 (Window Class)
    =============================================

    Hotkeys:
    F1 - Activate Notepad by class
    F2 - Activate Explorer with class and title
    F3 - Show application class switcher
    F4 - Show window class inspector
    F5 - Cycle through browser windows
    F6 - Activate newest Notepad window
    F7 - Show application manager
    Esc - Exit script

    Ctrl+F1 - Show this help
    )"

    MsgBox(help, "Help", 64)
}
