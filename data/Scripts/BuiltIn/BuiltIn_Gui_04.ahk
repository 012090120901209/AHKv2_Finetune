#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Gui_04.ahk - Multi-Window Management
 * 
 * This file demonstrates managing multiple windows in AutoHotkey v2.
 * Topics covered:
 * - Parent-child window relationships
 * - Window ownership and dependencies
 * - Inter-window communication
 * - Window switching and focus management
 * - Multiple document interface (MDI-like) patterns
 * - Coordinated window operations
 * - Window state synchronization
 * 
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024
 */

; =============================================================================
; Example 1: Parent-Child Windows
; =============================================================================

/**
 * Demonstrates parent-child window relationships
 * Child windows are owned by parent
 */
Example1_ParentChild() {
    ; Create parent window
    parentGui := Gui(, "Parent Window")
    parentGui.BackColor := "0xE8F4E8"

    parentGui.SetFont("s11 Bold")
    parentGui.Add("Text", "x20 y20 w360", "Parent Window")
    parentGui.SetFont("s9 Norm")

    parentGui.Add("Text", "x20 y50 w360", "This is the parent window. It can have multiple children.")

    ; Child window list
    childList := parentGui.Add("ListBox", "x20 y80 w360 h150", [])

    ; Buttons
    parentGui.Add("Button", "x20 y240 w170", "Create Child").OnEvent("Click", (*) => CreateChild())
    parentGui.Add("Button", "x200 y240 w180", "Close All Children").OnEvent("Click", (*) => CloseAllChildren())

    statusText := parentGui.Add("Text", "x20 y275 w360", "Children: 0")

    ; Close button
    parentGui.Add("Button", "x20 y305 w360", "Close Parent (closes all)").OnEvent("Click", (*) => CleanupAndClose())

    parentGui.OnEvent("Close", (*) => CleanupAndClose())

    ; Track child windows
    children := []

    CreateChild() {
        childNum := children.Length + 1

        ; Create child window owned by parent
        childGui := Gui("+Owner" parentGui.Hwnd " +ToolWindow", "Child Window #" childNum)
        childGui.BackColor := "0xFFF8E8"

        childGui.Add("Text", "x20 y20 w260", "Child Window #" childNum)
        childGui.Add("Text", "x20 y50 w260", "Owned by parent window")
        childGui.Add("Text", "x20 y75 w260", "Closes when parent closes")

        ; Child-specific data
        noteEdit := childGui.Add("Edit", "x20 y105 w260 h100 Multi", "Notes for child #" childNum "...")

        ; Buttons
        childGui.Add("Button", "x20 y215 w120", "Focus Parent").OnEvent("Click", (*) => WinActivate(parentGui.Hwnd))
        childGui.Add("Button", "x150 y215 w130", "Close").OnEvent("Click", (*) => CloseChild(childGui))

        childGui.OnEvent("Close", (*) => CloseChild(childGui))

        childGui.Show("w300 h260")

        ; Track child
        children.Push({ gui: childGui, num: childNum })
        UpdateChildList()
    }

    CloseChild(childGui) {
        ; Find and remove from array
        for index, child in children {
            if (child.gui.Hwnd = childGui.Hwnd) {
                children.RemoveAt(index)
                break
            }
        }
        childGui.Destroy()
        UpdateChildList()
    }

    CloseAllChildren() {
        for child in children {
            try child.gui.Destroy()
        }
        children := []
        UpdateChildList()
    }

    UpdateChildList() {
        items := []
        for child in children {
            items.Push("Child #" child.num)
        }
        childList.Delete()
        if (items.Length > 0)
            childList.Add(items)

        statusText.Value := "Children: " children.Length
    }

    CleanupAndClose() {
        CloseAllChildren()
        parentGui.Destroy()
    }

    parentGui.Show("w400 h350")
}

; =============================================================================
; Example 2: Window Communication
; =============================================================================

/**
 * Windows that communicate with each other
 * Demonstrates message passing between windows
 */
Example2_WindowCommunication() {
    ; Shared data object
    sharedData := {
        messages: [],
        counter: 0
    }

    ; Create main control window
    controlGui := Gui(, "Control Center")
    controlGui.BackColor := "0xE0E0FF"

    controlGui.SetFont("s11 Bold")
    controlGui.Add("Text", "x20 y20 w360", "Control Center")
    controlGui.SetFont("s9 Norm")

    controlGui.Add("Text", "x20 y50 w360", "Send messages to all display windows:")

    messageEdit := controlGui.Add("Edit", "x20 y75 w360", "Hello from Control!")
    controlGui.Add("Button", "x20 y105 w170", "Broadcast Message").OnEvent("Click", (*) => BroadcastMessage())
    controlGui.Add("Button", "x200 y105 w180", "Increment Counter").OnEvent("Click", (*) => IncrementCounter())

    controlGui.Add("Text", "x20 y140", "Create display windows:")
    controlGui.Add("Button", "x20 y165 w170", "New Display Window").OnEvent("Click", (*) => CreateDisplay())
    controlGui.Add("Button", "x200 y165 w180", "Close All Displays").OnEvent("Click", (*) => CloseAllDisplays())

    statusText := controlGui.Add("Text", "x20 y200 w360", "Active Displays: 0 | Messages: 0")

    controlGui.Add("Button", "x20 y235 w360", "Close Control").OnEvent("Click", (*) => Cleanup())
    controlGui.OnEvent("Close", (*) => Cleanup())

    ; Track display windows
    displays := []

    BroadcastMessage() {
        msg := messageEdit.Value
        if (msg = "")
            return

        sharedData.messages.Push({
            text: msg,
            time: FormatTime(A_Now, "HH:mm:ss"),
            source: "Control"
        })

        ; Update all displays
        for display in displays {
            try UpdateDisplay(display.gui)
        }

        UpdateStatus()
    }

    IncrementCounter() {
        sharedData.counter++

        ; Update all displays
        for display in displays {
            try UpdateDisplay(display.gui)
        }

        UpdateStatus()
    }

    CreateDisplay() {
        displayNum := displays.Length + 1

        displayGui := Gui("+Owner" controlGui.Hwnd, "Display #" displayNum)
        displayGui.BackColor := "White"

        displayGui.Add("Text", "x20 y20 w360", "Display Window #" displayNum)

        counterText := displayGui.Add("Text", "x20 y50 w360 h30 Border Center BackgroundYellow", "Counter: 0")
        counterText.SetFont("s12 Bold")

        messagesEdit := displayGui.Add("Edit", "x20 y90 w360 h200 ReadOnly Multi", "Messages will appear here...")

        ; Send message button
        sendEdit := displayGui.Add("Edit", "x20 y300 w260", "")
        sendBtn := displayGui.Add("Button", "x290 y297 w90", "Send")
        sendBtn.OnEvent("Click", (*) => SendFromDisplay(displayNum, sendEdit.Value))

        displayGui.Add("Button", "x20 y335 w360", "Close").OnEvent("Click", (*) => CloseDisplay(displayGui))
        displayGui.OnEvent("Close", (*) => CloseDisplay(displayGui))

        displayGui.Show("w400 h380")

        ; Track display
        displays.Push({
            gui: displayGui,
            num: displayNum,
            counterText: counterText,
            messagesEdit: messagesEdit
        })

        ; Initial update
        UpdateDisplay(displayGui)
        UpdateStatus()
    }

    UpdateDisplay(displayGui) {
        ; Find display data
        for display in displays {
            if (display.gui.Hwnd = displayGui.Hwnd) {
                ; Update counter
                display.counterText.Value := "Counter: " sharedData.counter

                ; Update messages
                msgText := "=== Message History ===`n`n"
                for msg in sharedData.messages {
                    msgText .= Format("[{1}] {2}: {3}`n", msg.time, msg.source, msg.text)
                }
                display.messagesEdit.Value := msgText

                break
            }
        }
    }

    SendFromDisplay(displayNum, message) {
        if (message = "")
            return

        sharedData.messages.Push({
            text: message,
            time: FormatTime(A_Now, "HH:mm:ss"),
            source: "Display #" displayNum
        })

        ; Update all displays
        for display in displays {
            try UpdateDisplay(display.gui)
        }

        UpdateStatus()

        ; Clear send box
        for display in displays {
            if (display.num = displayNum) {
                for ctrl in display.gui {
                    if (ctrl.Type = "Edit" && ctrl.Value = message) {
                        ctrl.Value := ""
                        break
                    }
                }
            }
        }
    }

    CloseDisplay(displayGui) {
        for index, display in displays {
            if (display.gui.Hwnd = displayGui.Hwnd) {
                displays.RemoveAt(index)
                break
            }
        }
        displayGui.Destroy()
        UpdateStatus()
    }

    CloseAllDisplays() {
        for display in displays {
            try display.gui.Destroy()
        }
        displays := []
        UpdateStatus()
    }

    UpdateStatus() {
        statusText.Value := Format("Active Displays: {1} | Messages: {2} | Counter: {3}",
            displays.Length, sharedData.messages.Length, sharedData.counter)
    }

    Cleanup() {
        CloseAllDisplays()
        controlGui.Destroy()
    }

    controlGui.Show("w400 h280")
}

; =============================================================================
; Example 3: MDI-Like Interface
; =============================================================================

/**
 * Multiple Document Interface pattern
 * Container window with multiple document windows
 */
Example3_MDIInterface() {
    ; Main container window
    mainGui := Gui("+Resize", "MDI-Like Interface")
    mainGui.BackColor := "0x2C3E50"

    ; Menu bar simulation
    menuBar := mainGui.Add("Text", "x0 y0 w800 h30 Background0x34495E cWhite 0x200", "")
    mainGui.SetFont("s9 cWhite")
    mainGui.Add("Text", "x10 y7 Background0x34495E", "File | Edit | View | Window | Help")

    ; Document area
    docArea := mainGui.Add("Text", "x0 y30 w800 h520 Background0x2C3E50", "")

    ; Status bar
    statusBar := mainGui.Add("Text", "x0 y550 w800 h30 Background0xECF0F1 Border", "")
    statusText := mainGui.Add("Text", "x10 y560", "Ready | Documents: 0")

    ; Track documents
    documents := []
    nextDocNum := 1
    activeDoc := 0

    ; Window menu (simulated)
    mainGui.Add("Button", "x10 y45 w100", "New Document").OnEvent("Click", (*) => CreateDocument())
    mainGui.Add("Button", "x120 y45 w100", "Tile Horizontal").OnEvent("Click", (*) => TileHorizontal())
    mainGui.Add("Button", "x230 y45 w100", "Tile Vertical").OnEvent("Click", (*) => TileVertical())
    mainGui.Add("Button", "x340 y45 w100", "Cascade").OnEvent("Click", (*) => Cascade())
    mainGui.Add("Button", "x450 y45 w100", "Close All").OnEvent("Click", (*) => CloseAllDocuments())

    CreateDocument() {
        docNum := nextDocNum++

        ; Calculate position (cascade)
        offset := (documents.Length * 30) mod 200
        docX := 20 + offset
        docY := 90 + offset

        ; Create document window
        docGui := Gui("+Owner" mainGui.Hwnd " -MinimizeBox -MaximizeBox", "Document " docNum)
        docGui.BackColor := "White"

        docGui.Add("Text", "x10 y10 w360", "Document #" docNum)

        contentEdit := docGui.Add("Edit", "x10 y35 w360 h200 Multi", "Document content for #" docNum "`n`nType your content here...")

        ; Document buttons
        docGui.Add("Button", "x10 y245 w80", "Save").OnEvent("Click", (*) => SaveDocument(docNum))
        docGui.Add("Button", "x100 y245 w80", "Activate").OnEvent("Click", (*) => ActivateDocument(docNum))
        docGui.Add("Button", "x190 y245 w90", "Close").OnEvent("Click", (*) => CloseDocument(docNum))

        docGui.OnEvent("Close", (*) => CloseDocument(docNum))

        ; Position within main window
        mainGui.GetPos(&mainX, &mainY)
        docGui.Show(Format("x{1} y{2} w380 h290", mainX + docX, mainY + docY))

        ; Track document
        documents.Push({
            gui: docGui,
            num: docNum,
            content: contentEdit
        })

        UpdateStatus()
    }

    SaveDocument(docNum) {
        for doc in documents {
            if (doc.num = docNum) {
                MsgBox("Document #" docNum " saved!`n`nContent: " StrLen(doc.content.Value) " characters", "Save")
                break
            }
        }
    }

    ActivateDocument(docNum) {
        for doc in documents {
            if (doc.num = docNum) {
                WinActivate(doc.gui.Hwnd)
                activeDoc := docNum
                UpdateStatus()
                break
            }
        }
    }

    CloseDocument(docNum) {
        for index, doc in documents {
            if (doc.num = docNum) {
                doc.gui.Destroy()
                documents.RemoveAt(index)
                UpdateStatus()
                break
            }
        }
    }

    CloseAllDocuments() {
        for doc in documents {
            try doc.gui.Destroy()
        }
        documents := []
        UpdateStatus()
    }

    TileHorizontal() {
        if (documents.Length = 0)
            return

        mainGui.GetPos(&mainX, &mainY, &mainW, &mainH)

        docHeight := (mainH - 120) // documents.Length
        currentY := mainY + 90

        for doc in documents {
            doc.gui.Show(Format("x{1} y{2} w{3} h{4}", mainX + 20, currentY, mainW - 40, docHeight))
            currentY += docHeight
        }
    }

    TileVertical() {
        if (documents.Length = 0)
            return

        mainGui.GetPos(&mainX, &mainY, &mainW)

        docWidth := (mainW - 40) // documents.Length
        currentX := mainX + 20

        for doc in documents {
            doc.gui.Show(Format("x{1} y{2} w{3} h{4}", currentX, mainY + 90, docWidth, 400))
            currentX += docWidth
        }
    }

    Cascade() {
        if (documents.Length = 0)
            return

        mainGui.GetPos(&mainX, &mainY)

        offset := 0
        for doc in documents {
            doc.gui.Show(Format("x{1} y{2} w380 h290", mainX + 20 + offset, mainY + 90 + offset))
            offset += 30
        }
    }

    UpdateStatus() {
        statusText.Value := Format("Ready | Documents: {1} | Active: {2}",
            documents.Length, activeDoc > 0 ? "Document " activeDoc : "None")
    }

    mainGui.OnEvent("Close", (*) => (CloseAllDocuments(), mainGui.Destroy()))
    mainGui.Show("w800 h580")
}

; =============================================================================
; Example 4: Synchronized Windows
; =============================================================================

/**
 * Windows that synchronize their state
 * Demonstrates coordinated window updates
 */
Example4_SynchronizedWindows() {
    ; Shared state
    sharedState := {
        color: "White",
        fontSize: 12,
        text: "Synchronized Text"
    }

    windows := []

    ; Create controller window
    controlGui := Gui(, "Synchronization Controller")
    controlGui.BackColor := "0xF0F0F0"

    controlGui.SetFont("s11 Bold")
    controlGui.Add("Text", "x20 y20 w360", "Window Synchronization Controller")
    controlGui.SetFont("s9 Norm")

    ; Controls that affect all windows
    controlGui.Add("Text", "x20 y55", "Background Color:")
    colorDDL := controlGui.Add("DropDownList", "x20 y75 w160", ["White", "Yellow", "Aqua", "Lime", "Pink"])
    colorDDL.Choose(1)
    colorDDL.OnEvent("Change", (*) => UpdateAllWindows("color", colorDDL.Text))

    controlGui.Add("Text", "x200 y55", "Font Size:")
    sizeDDL := controlGui.Add("DropDownList", "x200 y75 w160", ["8", "10", "12", "14", "16", "18", "20"])
    sizeDDL.Choose(3)
    sizeDDL.OnEvent("Change", (*) => UpdateAllWindows("fontSize", Integer(sizeDDL.Text)))

    controlGui.Add("Text", "x20 y110", "Shared Text:")
    textEdit := controlGui.Add("Edit", "x20 y130 w340")
    textEdit.Value := sharedState.text
    controlGui.Add("Button", "x20 y160 w340", "Update All Windows").OnEvent("Click", (*) => UpdateAllWindows("text", textEdit.Value))

    controlGui.Add("Button", "x20 y200 w160", "Create Synced Window").OnEvent("Click", (*) => CreateSyncedWindow())
    controlGui.Add("Button", "x200 y200 w160", "Close All Windows").OnEvent("Click", (*) => CloseAllWindows())

    statusText := controlGui.Add("Text", "x20 y240 w340", "Synced Windows: 0")

    controlGui.Add("Button", "x20 y270 w340", "Close Controller").OnEvent("Click", (*) => Cleanup())

    CreateSyncedWindow() {
        winNum := windows.Length + 1

        syncGui := Gui("+Owner" controlGui.Hwnd " +ToolWindow", "Synced Window #" winNum)

        ; Apply current shared state
        syncGui.BackColor := sharedState.color
        syncGui.SetFont("s" sharedState.fontSize)

        displayText := syncGui.Add("Text", "x20 y20 w260 h100 Border Center Background" sharedState.color, sharedState.text)

        infoText := syncGui.Add("Text", "x20 y130 w260", Format("Window #{1}`nColor: {2}`nFont: {3}pt",
            winNum, sharedState.color, sharedState.fontSize))

        syncGui.Add("Button", "x20 y180 w260", "Close This Window").OnEvent("Click", (*) => CloseSyncedWindow(syncGui))
        syncGui.OnEvent("Close", (*) => CloseSyncedWindow(syncGui))

        ; Position cascade
        offset := (windows.Length * 30) mod 300
        syncGui.Show(Format("x{1} y{2} w300 h230", 100 + offset, 100 + offset))

        ; Track window
        windows.Push({
            gui: syncGui,
            num: winNum,
            displayText: displayText,
            infoText: infoText
        })

        UpdateStatus()
    }

    UpdateAllWindows(prop, value) {
        ; Update shared state
        sharedState.%prop% := value

        ; Update all synced windows
        for win in windows {
            try {
                switch prop {
                    case "color":
                        win.gui.BackColor := value
                        win.displayText.Opt("Background" value)
                        win.infoText.Value := Format("Window #{1}`nColor: {2}`nFont: {3}pt",
                            win.num, sharedState.color, sharedState.fontSize)
                    case "fontSize":
                        win.gui.SetFont("s" value)
                        win.displayText.SetFont()
                        win.infoText.Value := Format("Window #{1}`nColor: {2}`nFont: {3}pt",
                            win.num, sharedState.color, sharedState.fontSize)
                    case "text":
                        win.displayText.Value := value
                }
            }
        }
    }

    CloseSyncedWindow(syncGui) {
        for index, win in windows {
            if (win.gui.Hwnd = syncGui.Hwnd) {
                windows.RemoveAt(index)
                break
            }
        }
        syncGui.Destroy()
        UpdateStatus()
    }

    CloseAllWindows() {
        for win in windows {
            try win.gui.Destroy()
        }
        windows := []
        UpdateStatus()
    }

    UpdateStatus() {
        statusText.Value := "Synced Windows: " windows.Length
    }

    Cleanup() {
        CloseAllWindows()
        controlGui.Destroy()
    }

    controlGui.Show("w400 h320")
}

; =============================================================================
; Example 5: Window Focus Management
; =============================================================================

/**
 * Manages focus across multiple windows
 * Demonstrates focus tracking and switching
 */
Example5_FocusManagement() {
    ; Main window
    mainGui := Gui(, "Focus Management Demo")
    mainGui.BackColor := "White"

    mainGui.SetFont("s11 Bold")
    mainGui.Add("Text", "x20 y20 w560", "Window Focus Management")
    mainGui.SetFont("s9 Norm")

    ; Focus log
    focusLog := mainGui.Add("Edit", "x20 y50 w560 h200 ReadOnly Multi", "Focus Event Log:`n")

    ; Window list
    mainGui.Add("Text", "x20 y260", "Active Windows:")
    windowList := mainGui.Add("ListBox", "x20 y280 w360 h100", [])

    ; Buttons
    mainGui.Add("Button", "x390 y280 w190", "Create Test Window").OnEvent("Click", (*) => CreateTestWindow())
    mainGui.Add("Button", "x390 y315 w190", "Focus Selected").OnEvent("Click", (*) => FocusSelected())
    mainGui.Add("Button", "x390 y350 w190", "Close Selected").OnEvent("Click", (*) => CloseSelected())

    mainGui.Add("Button", "x20 y390 w560", "Clear Log").OnEvent("Click", (*) => (focusLog.Value := "Focus Event Log:`n"))

    testWindows := []

    LogFocusEvent(msg) {
        timestamp := FormatTime(A_Now, "HH:mm:ss.") SubStr(A_TickCount, -2)
        focusLog.Value .= Format("[{1}] {2}`n", timestamp, msg)
        ControlSend("{End}", focusLog)
    }

    CreateTestWindow() {
        winNum := testWindows.Length + 1

        testGui := Gui("+Owner" mainGui.Hwnd, "Test Window #" winNum)
        testGui.BackColor := "0xFFFFE0"

        testGui.Add("Text", "x20 y20 w260", "Test Window #" winNum)
        testGui.Add("Edit", "x20 y50 w260", "Test input field")
        testGui.Add("Button", "x20 y85 w260", "Click Me").OnEvent("Click", (*) => LogFocusEvent("Button clicked in Window #" winNum))
        testGui.Add("Button", "x20 y120 w260", "Close").OnEvent("Click", (*) => CloseTestWindow(testGui))

        ; Track focus events
        testGui.OnEvent("Close", (*) => CloseTestWindow(testGui))

        ; Position cascade
        offset := (testWindows.Length * 30) mod 200
        testGui.Show(Format("x{1} y{2} w300 h165", 50 + offset, 50 + offset))

        testWindows.Push({
            gui: testGui,
            num: winNum
        })

        UpdateWindowList()
        LogFocusEvent("Test Window #" winNum " created")

        ; Set timer to check focus
        SetTimer(CheckFocus, 500)
    }

    lastFocusedHwnd := 0
    CheckFocus() {
        focusedHwnd := WinExist("A")

        if (focusedHwnd != lastFocusedHwnd) {
            lastFocusedHwnd := focusedHwnd

            ; Check if it's the main window
            if (focusedHwnd = mainGui.Hwnd) {
                LogFocusEvent("Main window gained focus")
            } else {
                ; Check test windows
                for win in testWindows {
                    if (focusedHwnd = win.gui.Hwnd) {
                        LogFocusEvent("Test Window #" win.num " gained focus")
                        break
                    }
                }
            }
        }
    }

    CloseTestWindow(testGui) {
        for index, win in testWindows {
            if (win.gui.Hwnd = testGui.Hwnd) {
                LogFocusEvent("Test Window #" win.num " closed")
                testWindows.RemoveAt(index)
                break
            }
        }
        testGui.Destroy()
        UpdateWindowList()

        if (testWindows.Length = 0)
            SetTimer(CheckFocus, 0)
    }

    FocusSelected() {
        selected := windowList.Value
        if (selected > 0 && selected <= testWindows.Length) {
            WinActivate(testWindows[selected].gui.Hwnd)
        }
    }

    CloseSelected() {
        selected := windowList.Value
        if (selected > 0 && selected <= testWindows.Length) {
            CloseTestWindow(testWindows[selected].gui)
        }
    }

    UpdateWindowList() {
        windowList.Delete()
        items := []
        for win in testWindows {
            items.Push("Test Window #" win.num)
        }
        if (items.Length > 0)
            windowList.Add(items)
    }

    mainGui.OnEvent("Close", (*) => (SetTimer(CheckFocus, 0), mainGui.Destroy()))
    mainGui.Show("w600 h440")
}

; =============================================================================
; Example 6: Modal Dialog Chain
; =============================================================================

/**
 * Demonstrates chained modal dialogs
 * Each dialog blocks its parent
 */
Example6_ModalChain() {
    ; Start with main window
    ShowLevel1()

    ShowLevel1() {
        level1 := Gui(, "Level 1 - Main Window")
        level1.BackColor := "0xE0FFE0"

        level1.SetFont("s12 Bold")
        level1.Add("Text", "x20 y20 w360", "Level 1: Main Window")
        level1.SetFont("s9 Norm")

        level1.Add("Text", "x20 y55 w360", "This is the first level window.")
        level1.Add("Text", "x20 y80 w360", "Click below to open a modal dialog (Level 2)")
        level1.Add("Text", "x20 y105 w360", "which will block this window.")

        level1.Add("Button", "x20 y140 w360 h40", "Open Level 2 (Modal)").OnEvent("Click", (*) => ShowLevel2(level1))
        level1.Add("Button", "x20 y190 w360", "Close").OnEvent("Click", (*) => level1.Destroy())

        level1.Show("w400 h240")
    }

    ShowLevel2(parentGui) {
        level2 := Gui("+Owner" parentGui.Hwnd " +ToolWindow", "Level 2 - Modal Dialog")
        level2.BackColor := "0xFFFFE0"

        level2.SetFont("s12 Bold")
        level2.Add("Text", "x20 y20 w360", "Level 2: Modal Dialog")
        level2.SetFont("s9 Norm")

        level2.Add("Text", "x20 y55 w360", "This dialog blocks Level 1.")
        level2.Add("Text", "x20 y80 w360", "Try clicking Level 1 - you can't!")
        level2.Add("Text", "x20 y105 w360", "You can open Level 3 from here.")

        level2.Add("Button", "x20 y140 w360 h40", "Open Level 3 (Modal)").OnEvent("Click", (*) => ShowLevel3(level2, parentGui))
        level2.Add("Button", "x20 y190 w360", "Close and Return to Level 1").OnEvent("Click", CloseLevel2)

        level2.OnEvent("Close", CloseLevel2)
        level2.OnEvent("Escape", CloseLevel2)

        CloseLevel2(*) {
            level2.Destroy()
            parentGui.Opt("-Disabled")
        }

        level2.Show("w400 h240")
        parentGui.Opt("+Disabled")
    }

    ShowLevel3(parentGui, grandParentGui) {
        level3 := Gui("+Owner" parentGui.Hwnd " +ToolWindow", "Level 3 - Nested Modal")
        level3.BackColor := "0xFFE0E0"

        level3.SetFont("s12 Bold")
        level3.Add("Text", "x20 y20 w360", "Level 3: Nested Modal")
        level3.SetFont("s9 Norm")

        level3.Add("Text", "x20 y55 w360", "This is the deepest level (3).")
        level3.Add("Text", "x20 y80 w360", "Both Level 1 and Level 2 are blocked.")
        level3.Add("Text", "x20 y105 w360", "Close this to return to Level 2.")

        level3.Add("Button", "x20 y140 w360 h40", "Close and Return to Level 2").OnEvent("Click", CloseLevel3)

        level3.OnEvent("Close", CloseLevel3)
        level3.OnEvent("Escape", CloseLevel3)

        CloseLevel3(*) {
            level3.Destroy()
            parentGui.Opt("-Disabled")
        }

        level3.Show("w400 h200")
        parentGui.Opt("+Disabled")
    }
}

; =============================================================================
; Example 7: Task Manager Style Interface
; =============================================================================

/**
 * Task manager showing all application windows
 * Demonstrates window enumeration and management
 */
Example7_TaskManager() {
    taskGui := Gui("+Resize", "Window Task Manager")
    taskGui.BackColor := "White"

    taskGui.SetFont("s11 Bold")
    taskGui.Add("Text", "x10 y10 w580", "Window Task Manager")
    taskGui.SetFont("s9 Norm")

    ; Window list
    windowLV := taskGui.Add("ListView", "x10 y40 w580 h300", ["Title", "Process", "HWND", "Status"])
    windowLV.ModifyCol(1, 250)
    windowLV.ModifyCol(2, 120)
    windowLV.ModifyCol(3, 100)
    windowLV.ModifyCol(4, 100)

    ; Buttons
    taskGui.Add("Button", "x10 y350 w140", "Refresh List").OnEvent("Click", (*) => RefreshWindowList())
    taskGui.Add("Button", "x160 y350 w140", "Activate Selected").OnEvent("Click", (*) => ActivateSelected())
    taskGui.Add("Button", "x310 y350 w140", "Close Selected").OnEvent("Click", (*) => CloseSelectedWindow())
    taskGui.Add("Button", "x460 y350 w130", "Exit").OnEvent("Click", (*) => taskGui.Destroy())

    ; Status
    statusText := taskGui.Add("Text", "x10 y385 w580", "Windows: 0")

    RefreshWindowList() {
        windowLV.Delete()
        count := 0

        ; Enumerate all windows
        windows := WinGetList()
        for hwnd in windows {
            try {
                title := WinGetTitle(hwnd)
                process := WinGetProcessName(hwnd)

                ; Filter out hidden and tool windows
                if (title != "" && WinGetExStyle(hwnd) & 0x80 = 0) {  ; Not a tool window
                    isVisible := WinGetStyle(hwnd) & 0x10000000  ; WS_VISIBLE
                    status := isVisible ? "Visible" : "Hidden"

                    windowLV.Add(, title, process, hwnd, status)
                    count++
                }
            }
        }

        statusText.Value := Format("Windows: {1} (visible windows with titles)", count)
    }

    ActivateSelected() {
        row := windowLV.GetNext()
        if (row) {
            hwnd := Integer(windowLV.GetText(row, 3))
            try {
                WinActivate(hwnd)
                MsgBox("Activated window: " windowLV.GetText(row, 1), "Success")
            } catch as err {
                MsgBox("Failed to activate window: " err.Message, "Error")
            }
        } else {
            MsgBox("Please select a window first", "No Selection")
        }
    }

    CloseSelectedWindow() {
        row := windowLV.GetNext()
        if (row) {
            hwnd := Integer(windowLV.GetText(row, 3))
            title := windowLV.GetText(row, 1)

            result := MsgBox("Close window: " title "?", "Confirm Close", "YesNo")
            if (result = "Yes") {
                try {
                    WinClose(hwnd)
                    Sleep(500)
                    RefreshWindowList()
                } catch as err {
                    MsgBox("Failed to close window: " err.Message, "Error")
                }
            }
        } else {
            MsgBox("Please select a window first", "No Selection")
        }
    }

    ; Auto-refresh timer
    SetTimer(RefreshWindowList, 3000)
    taskGui.OnEvent("Close", (*) => SetTimer(RefreshWindowList, 0))

    RefreshWindowList()
    taskGui.Show("w600 h420")
}

; =============================================================================
; Main Menu - Example Launcher
; =============================================================================

/**
 * Creates a main menu to launch all examples
 */
ShowMainMenu() {
    menuGui := Gui(, "BuiltIn_Gui_04 - Multi-Window Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "Multi-Window Management Examples")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    ; Example buttons
    menuGui.Add("Button", "x20 y80 w360", "Example 1: Parent-Child Windows").OnEvent("Click", (*) => Example1_ParentChild())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: Window Communication").OnEvent("Click", (*) => Example2_WindowCommunication())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: MDI-Like Interface").OnEvent("Click", (*) => Example3_MDIInterface())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Synchronized Windows").OnEvent("Click", (*) => Example4_SynchronizedWindows())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: Focus Management").OnEvent("Click", (*) => Example5_FocusManagement())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: Modal Dialog Chain").OnEvent("Click", (*) => Example6_ModalChain())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: Task Manager Interface").OnEvent("Click", (*) => Example7_TaskManager())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

; Show the main menu
ShowMainMenu()
