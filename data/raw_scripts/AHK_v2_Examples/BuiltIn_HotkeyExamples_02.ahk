#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Productivity Tool Hotkeys - Workflow Enhancement
 * ============================================================================
 *
 * Advanced productivity tools using hotkeys for workflow automation,
 * task management, focus modes, and efficiency boosters.
 *
 * @author AutoHotkey v2 Documentation Team
 * @version 1.0.0
 */

; ============================================================================
; Example 1: Pomodoro Timer with Hotkeys
; ============================================================================

Example1_PomodoroTimer() {
    global pomodoroActive := false
    global workMinutes := 25
    global breakMinutes := 5
    global pomodoroCount := 0

    /**
     * Starts a Pomodoro session
     */
    StartPomodoro() {
        global pomodoroActive, workMinutes, pomodoroCount

        pomodoroActive := true
        endTime := A_TickCount + (workMinutes * 60 * 1000)

        ; Show start notification
        ToolTip("Pomodoro started - " . workMinutes . " min", A_ScreenWidth - 200, 10)
        SetTimer(() => ToolTip(), -2000)

        ; Timer function
        CheckPomodoro() {
            global pomodoroActive, breakMinutes, pomodoroCount

            if !pomodoroActive
                return

            remaining := Round((endTime - A_TickCount) / 1000)

            if remaining <= 0 {
                ; Pomodoro complete
                pomodoroActive := false
                pomodoroCount++

                MsgBox(
                    "Pomodoro #" . pomodoroCount . " complete!`n`n"
                    "Take a " . breakMinutes . " minute break.",
                    "Pomodoro Complete"
                )
            } else {
                ; Update tooltip
                mins := remaining // 60
                secs := Mod(remaining, 60)
                ToolTip(
                    Format("Pomodoro: {:02d}:{:02d}", mins, secs),
                    A_ScreenWidth - 150,
                    10
                )
            }
        }

        SetTimer(CheckPomodoro, 1000)
    }

    /**
     * Stops Pomodoro
     */
    StopPomodoro() {
        global pomodoroActive
        pomodoroActive := false
        ToolTip()
        MsgBox("Pomodoro stopped!", "Stop")
    }

    ; Hotkeys
    Hotkey("^!p", (*) => StartPomodoro())
    Hotkey("^!+p", (*) => StopPomodoro())

    MsgBox(
        "Pomodoro Timer`n`n"
        "Ctrl+Alt+P → Start 25min Pomodoro`n"
        "Ctrl+Alt+Shift+P → Stop Pomodoro`n`n"
        "Timer shows in top-right corner`n"
        "Notification when complete!",
        "Example 1"
    )
}

; ============================================================================
; Example 2: Focus Mode Manager
; ============================================================================

Example2_FocusMode() {
    global focusMode := false
    global distractingApps := ["chrome.exe", "firefox.exe"]

    /**
     * Toggles focus mode
     */
    ToggleFocus() {
        global focusMode, distractingApps

        focusMode := !focusMode

        if focusMode {
            ; Close distracting apps
            for app in distractingApps {
                try ProcessClose(app)
            }

            ; Show notification
            ToolTip("FOCUS MODE: ON", A_ScreenWidth - 150, 10)

            ; Block certain hotkeys
            Hotkey("^!w", "Off")
            Hotkey("^!#w", "Off")
        } else {
            ToolTip("FOCUS MODE: OFF", A_ScreenWidth - 150, 10)

            ; Re-enable hotkeys
            Hotkey("^!w", "On")
            Hotkey("^!#w", "On")
        }

        SetTimer(() => ToolTip(), -2000)
    }

    /**
     * Quick web search (disabled in focus mode)
     */
    Hotkey("^!w", (*) {
        MsgBox("Web search (blocked in focus mode)", "Search")
    })

    ; Focus toggle
    Hotkey("^!f", (*) => ToggleFocus())

    MsgBox(
        "Focus Mode Manager`n`n"
        "Ctrl+Alt+F → Toggle focus mode`n`n"
        "Focus mode:`n"
        "  • Closes distracting apps`n"
        "  • Blocks certain hotkeys`n"
        "  • Shows indicator`n`n"
        "Stay productive!",
        "Example 2"
    )
}

; ============================================================================
; Example 3: Smart Snippet Manager
; ============================================================================

Example3_SnippetManager() {
    global snippets := Map(
        "meeting", "Meeting Notes:`n" . Repeat("-", 40) . "`nDate: {DATE}`nAttendees:`n`nAgenda:`n`nAction Items:`n",
        "email", "Dear {NAME},`n`nThank you for your email. `n`nBest regards,`n{USER}",
        "bug", "BUG REPORT`n" . Repeat("-", 40) . "`nTitle: `nReproduction Steps:`n1. `n2. `nExpected: `nActual: ",
        "todo", "TODO: ",
        "review", "CODE REVIEW`n" . Repeat("-", 40) . "`nFile: `nIssues:`n- `nSuggestions:`n- "
    )

    /**
     * Shows snippet menu
     */
    ShowSnippetMenu() {
        global snippets

        snippetGui := Gui("+AlwaysOnTop", "Quick Snippets")

        snippetGui.AddText("", "Select a snippet:")

        for name in snippets {
            snippetGui.AddButton("w300", name).OnEvent("Click", (*) {
                InsertSnippet(name)
                snippetGui.Destroy()
            })
        }

        snippetGui.Show()
    }

    /**
     * Inserts snippet with replacements
     */
    InsertSnippet(name) {
        global snippets

        if !snippets.Has(name)
            return

        text := snippets[name]

        ; Replace placeholders
        text := StrReplace(text, "{DATE}", FormatTime(, "yyyy-MM-dd"))
        text := StrReplace(text, "{TIME}", FormatTime(, "HH:mm"))
        text := StrReplace(text, "{USER}", A_UserName)

        ; Handle {NAME} placeholder
        if InStr(text, "{NAME}") {
            result := InputBox("Enter name:", "Name")
            if result.Result = "OK"
                text := StrReplace(text, "{NAME}", result.Value)
        }

        SendText(text)
    }

    Repeat(char, count) {
        result := ""
        Loop count
            result .= char
        return result
    }

    ; Hotkeys
    Hotkey("^!s", (*) => ShowSnippetMenu())

    ; Individual snippet hotkeys
    Hotkey("^!s1", (*) => InsertSnippet("meeting"))
    Hotkey("^!s2", (*) => InsertSnippet("email"))
    Hotkey("^!s3", (*) => InsertSnippet("bug"))

    MsgBox(
        "Smart Snippet Manager`n`n"
        "Ctrl+Alt+S → Show snippet menu`n`n"
        "Quick snippets:`n"
        "  Ctrl+Alt+S1 → Meeting notes`n"
        "  Ctrl+Alt+S2 → Email template`n"
        "  Ctrl+Alt+S3 → Bug report`n`n"
        "Snippets include placeholders!",
        "Example 3"
    )
}

; ============================================================================
; Example 4: Workspace Switcher
; ============================================================================

Example4_WorkspaceSwitcher() {
    global workspaces := Map(
        "dev", ["code.exe", "cmd.exe"],
        "design", ["photoshop.exe", "illustrator.exe"],
        "office", ["winword.exe", "excel.exe"]
    )

    /**
     * Switches to a workspace
     */
    SwitchWorkspace(name) {
        global workspaces

        if !workspaces.Has(name) {
            MsgBox("Workspace not found: " . name, "Error")
            return
        }

        apps := workspaces[name]

        ; Launch or activate apps
        for app in apps {
            if WinExist("ahk_exe " . app) {
                WinActivate()
            } else {
                try Run(app)
            }
            Sleep(500)
        }

        ToolTip("Switched to: " . name . " workspace")
        SetTimer(() => ToolTip(), -2000)
    }

    ; Workspace hotkeys
    Hotkey("^!#1", (*) => SwitchWorkspace("dev"))
    Hotkey("^!#2", (*) => SwitchWorkspace("design"))
    Hotkey("^!#3", (*) => SwitchWorkspace("office"))

    MsgBox(
        "Workspace Switcher`n`n"
        "Ctrl+Alt+Win+1 → Dev workspace`n"
        "Ctrl+Alt+Win+2 → Design workspace`n"
        "Ctrl+Alt+Win+3 → Office workspace`n`n"
        "Automatically launches/switches to apps!",
        "Example 4"
    )
}

; ============================================================================
; Example 5: Task List Manager
; ============================================================================

Example5_TaskManager() {
    global tasks := []

    /**
     * Adds a new task
     */
    AddTask() {
        global tasks

        result := InputBox("Enter new task:", "Add Task", "w400")

        if result.Result = "OK" && result.Value != "" {
            tasks.Push({
                text: result.Value,
                completed: false,
                created: FormatTime(, "yyyy-MM-dd HH:mm")
            })

            MsgBox("Task added! Total: " . tasks.Length, "Task")
        }
    }

    /**
     * Shows task list
     */
    ShowTasks() {
        global tasks

        if tasks.Length = 0 {
            MsgBox("No tasks yet!", "Tasks")
            return
        }

        taskGui := Gui("+AlwaysOnTop +Resize", "Task List")

        taskGui.AddText("", "Your Tasks:")

        for index, task in tasks {
            status := task.completed ? "✓" : "☐"
            taskText := status . " " . task.text

            cb := taskGui.AddCheckbox("w400", taskText)
            cb.Value := task.completed ? 1 : 0

            ; Closure to capture index
            cb.OnEvent("Click", ((i) => (*) => ToggleTask(i))(index))
        }

        taskGui.AddButton("w400", "Add New Task").OnEvent("Click", (*) {
            AddTask()
            taskGui.Destroy()
            ShowTasks()
        })

        taskGui.Show()
    }

    /**
     * Toggles task completion
     */
    ToggleTask(index) {
        global tasks
        if index > 0 && index <= tasks.Length {
            tasks[index].completed := !tasks[index].completed
        }
    }

    ; Hotkeys
    Hotkey("^!a", (*) => AddTask())
    Hotkey("^!#t", (*) => ShowTasks())

    MsgBox(
        "Task List Manager`n`n"
        "Ctrl+Alt+A → Add task`n"
        "Ctrl+Alt+Win+T → Show tasks`n`n"
        "Click checkboxes to mark complete!",
        "Example 5"
    )
}

; ============================================================================
; Example 6: Screen Time Tracker
; ============================================================================

Example6_ScreenTimeTracker() {
    global screenTime := Map()
    global startTime := A_TickCount

    /**
     * Tracks active window time
     */
    TrackScreenTime() {
        global screenTime

        try {
            activeApp := WinGetProcessName("A")

            if !screenTime.Has(activeApp)
                screenTime[activeApp] := 0

            screenTime[activeApp] += 1 ; 1 second increments
        }
    }

    /**
     * Shows screen time report
     */
    ShowReport() {
        global screenTime, startTime

        totalTime := Round((A_TickCount - startTime) / 1000)
        totalMins := totalTime // 60

        report := "Screen Time Report`n" . Repeat("=", 50) . "`n`n"
        report .= "Total session: " . totalMins . " minutes`n`n"

        ; Sort by time
        apps := []
        for app, time in screenTime {
            apps.Push({app: app, time: time})
        }

        ; Simple sort
        Loop apps.Length {
            i := A_Index
            Loop apps.Length - i {
                j := A_Index
                if apps[j].time < apps[j + 1].time {
                    temp := apps[j]
                    apps[j] := apps[j + 1]
                    apps[j + 1] := temp
                }
            }
        }

        ; Show top apps
        report .= "Top Applications:`n"
        count := Min(10, apps.Length)
        Loop count {
            app := apps[A_Index]
            mins := app.time // 60
            secs := Mod(app.time, 60)
            report .= A_Index . ". " . app.app . ": " . mins . "m " . secs . "s`n"
        }

        MsgBox(report, "Screen Time")
    }

    Repeat(char, count) {
        result := ""
        Loop count
            result .= char
        return result
    }

    ; Start tracking
    SetTimer(TrackScreenTime, 1000)

    ; Report hotkey
    Hotkey("^!#r", (*) => ShowReport())

    MsgBox(
        "Screen Time Tracker`n`n"
        "Tracking started automatically!`n`n"
        "Ctrl+Alt+Win+R → View report`n`n"
        "See where you spend your time!",
        "Example 6"
    )
}

; ============================================================================
; Example 7: Command Palette System
; ============================================================================

Example7_CommandPalette() {
    global commands := Map(
        "reload", {action: (*) => Reload(), desc: "Reload script"},
        "edit", {action: (*) => Edit(), desc: "Edit script"},
        "time", {action: (*) => MsgBox(FormatTime()), desc: "Show time"},
        "date", {action: (*) => SendText(FormatTime(, "yyyy-MM-dd")), desc: "Insert date"},
        "calc", {action: (*) => Run("calc.exe"), desc: "Calculator"},
        "notepad", {action: (*) => Run("notepad.exe"), desc: "Notepad"}
    )

    /**
     * Shows command palette
     */
    ShowCommandPalette() {
        global commands

        paletteGui := Gui("+AlwaysOnTop", "Command Palette")

        paletteGui.AddText("", "Type command:")
        searchBox := paletteGui.AddEdit("w400")

        paletteGui.AddText("", "Commands:")
        commandList := paletteGui.AddListBox("w400 r10", [])

        ; Populate all commands
        UpdateList("")

        ; Update on typing
        searchBox.OnEvent("Change", (*) => UpdateList(searchBox.Value))

        ; Execute on double-click
        commandList.OnEvent("DoubleClick", (*) => ExecuteSelected())

        paletteGui.AddButton("w400", "Execute").OnEvent("Click", (*) => ExecuteSelected())

        UpdateList(filter) {
            global commands
            commandList.Delete()

            for name, cmd in commands {
                if filter = "" || InStr(name, filter) || InStr(cmd.desc, filter) {
                    commandList.Add([name . " - " . cmd.desc])
                }
            }
        }

        ExecuteSelected() {
            global commands
            sel := commandList.Text

            if sel = ""
                return

            ; Extract command name
            name := SubStr(sel, 1, InStr(sel, " -") - 1)

            if commands.Has(name) {
                paletteGui.Destroy()
                commands[name].action.Call()
            }
        }

        paletteGui.Show()
    }

    ; Command palette hotkey
    Hotkey("^+p", (*) => ShowCommandPalette())

    MsgBox(
        "Command Palette System`n`n"
        "Ctrl+Shift+P → Open command palette`n`n"
        "Available commands:`n"
        "  • reload - Reload script`n"
        "  • edit - Edit script`n"
        "  • time - Show time`n"
        "  • date - Insert date`n"
        "  • calc - Calculator`n"
        "  • notepad - Notepad`n`n"
        "Type to search, double-click to execute!",
        "Example 7"
    )
}

; ============================================================================
; Main Execution
; ============================================================================

ShowExampleMenu() {
    menu := "
    (
    Productivity Tool Hotkeys
    ==========================

    1. Pomodoro Timer
    2. Focus Mode Manager
    3. Smart Snippet Manager
    4. Workspace Switcher
    5. Task List Manager
    6. Screen Time Tracker
    7. Command Palette

    Press Alt+F[1-7] to run
    )"

    MsgBox(menu, "Productivity Tools")
}

Hotkey("!F1", (*) => Example1_PomodoroTimer())
Hotkey("!F2", (*) => Example2_FocusMode())
Hotkey("!F3", (*) => Example3_SnippetManager())
Hotkey("!F4", (*) => Example4_WorkspaceSwitcher())
Hotkey("!F5", (*) => Example5_TaskManager())
Hotkey("!F6", (*) => Example6_ScreenTimeTracker())
Hotkey("!F7", (*) => Example7_CommandPalette())

ShowExampleMenu()
