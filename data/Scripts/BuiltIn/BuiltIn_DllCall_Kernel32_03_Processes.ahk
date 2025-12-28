#Requires AutoHotkey v2.0

/**
 * BuiltIn_DllCall_Kernel32_03_Processes.ahk
 * 
 * DESCRIPTION:
 * Demonstrates process and thread management using Windows API through DllCall.
 * Shows how to create processes, get process information, manage threads,
 * and work with process handles.
 * 
 * FEATURES:
 * - Creating processes with CreateProcess
 * - Getting process and thread IDs
 * - Opening existing processes
 * - Process enumeration
 * - Thread creation and management
 * - Process priority control
 * - Getting exit codes
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - DllCall
 * https://www.autohotkey.com/docs/v2/lib/DllCall.htm
 * Microsoft Process and Thread API
 * https://docs.microsoft.com/en-us/windows/win32/procthread/
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - DllCall() with process functions
 * - Structure handling for PROCESS_INFORMATION and STARTUP_INFO
 * - Handle management
 * - Process synchronization
 * 
 * LEARNING POINTS:
 * 1. Creating processes with CreateProcess API
 * 2. Getting current process and thread IDs
 * 3. Opening processes by ID or name
 * 4. Managing process and thread priorities
 * 5. Waiting for processes to complete
 * 6. Getting process exit codes
 * 7. Working with process handles safely
 */

;==============================================================================
; EXAMPLE 1: Getting Process Information
;==============================================================================
Example1_ProcessInfo() {
    ; Get current process ID
    pid := DllCall("Kernel32.dll\GetCurrentProcessId", "UInt")

    ; Get current thread ID
    tid := DllCall("Kernel32.dll\GetCurrentThreadId", "UInt")

    ; Get process handle
    hProcess := DllCall("Kernel32.dll\GetCurrentProcess", "Ptr")

    ; Get command line
    cmdLineBuf := DllCall("Kernel32.dll\GetCommandLineW", "Ptr")
    cmdLine := StrGet(cmdLineBuf, "UTF-16")

    info := Format("
    (
    Current Process Information:
    ============================

    Process ID (PID): {}
    Thread ID (TID): {}
    Process Handle: 0x{:X}

    Command Line:
    {

    }
    )", pid, tid, hProcess, cmdLine)

    MsgBox(info, "Process Info")

    ; Get process times
    creation := Buffer(8, 0)
    exit := Buffer(8, 0)
    kernel := Buffer(8, 0)
    user := Buffer(8, 0)

    DllCall("Kernel32.dll\GetProcessTimes"
        , "Ptr", hProcess
        , "Ptr", creation.Ptr
        , "Ptr", exit.Ptr
        , "Ptr", kernel.Ptr
        , "Ptr", user.Ptr
        , "Int")

    MsgBox("Process timing information retrieved", "Success")
}

;==============================================================================
; EXAMPLE 2: Creating Processes
;==============================================================================
Example2_CreateProcess() {
    ; STARTUPINFO structure (104 bytes on x64)
    startupInfo := Buffer(104, 0)
    NumPut("UInt", 104, startupInfo, 0)  ; cb (size)

    ; PROCESS_INFORMATION structure (24 bytes on x64)
    processInfo := Buffer(24, 0)

    ; Create notepad process
    cmdLine := "notepad.exe"
    cmdLineBuffer := Buffer(StrPut(cmdLine, "UTF-16") * 2, 0)
    StrPut(cmdLine, cmdLineBuffer.Ptr, "UTF-16")

    success := DllCall("Kernel32.dll\CreateProcessW"
        , "Ptr", 0                          ; lpApplicationName
        , "Ptr", cmdLineBuffer.Ptr          ; lpCommandLine
        , "Ptr", 0                          ; lpProcessAttributes
        , "Ptr", 0                          ; lpThreadAttributes
        , "Int", 0                          ; bInheritHandles
        , "UInt", 0                         ; dwCreationFlags
        , "Ptr", 0                          ; lpEnvironment
        , "Ptr", 0                          ; lpCurrentDirectory
        , "Ptr", startupInfo.Ptr            ; lpStartupInfo
        , "Ptr", processInfo.Ptr            ; lpProcessInformation
        , "Int")

    if (success) {
        hProcess := NumGet(processInfo, 0, "Ptr")
        hThread := NumGet(processInfo, 8, "Ptr")
        procId := NumGet(processInfo, 16, "UInt")
        threadId := NumGet(processInfo, 20, "UInt")

        MsgBox(Format("Process created successfully!`n`nPID: {}`nTID: {}", procId, threadId), "Success")

        ; Close handles
        DllCall("Kernel32.dll\CloseHandle", "Ptr", hProcess, "Int")
        DllCall("Kernel32.dll\CloseHandle", "Ptr", hThread, "Int")
    } else {
        MsgBox("Failed to create process!`nError: " . DllCall("Kernel32.dll\GetLastError", "UInt"), "Error")
    }
}

;==============================================================================
; EXAMPLE 3: Opening Existing Processes
;==============================================================================
Example3_OpenProcess() {
    ; Process access rights
    PROCESS_QUERY_INFORMATION := 0x0400
    PROCESS_VM_READ := 0x0010
    PROCESS_ALL_ACCESS := 0x1F0FFF

    ; Find a process (using current process as example)
    currentPid := DllCall("Kernel32.dll\GetCurrentProcessId", "UInt")

    ; Open process with query rights
    hProcess := DllCall("Kernel32.dll\OpenProcess"
        , "UInt", PROCESS_QUERY_INFORMATION | PROCESS_VM_READ
        , "Int", 0              ; bInheritHandle
        , "UInt", currentPid    ; dwProcessId
        , "Ptr")

    if (hProcess) {
        MsgBox(Format("Opened process {}:`nHandle: 0x{:X}", currentPid, hProcess), "Success")

        ; Get process exit code (should be STILL_ACTIVE = 259 for running process)
        exitCode := Buffer(4, 0)
        DllCall("Kernel32.dll\GetExitCodeProcess"
            , "Ptr", hProcess
            , "Ptr", exitCode.Ptr
            , "Int")

        code := NumGet(exitCode, 0, "UInt")
        status := (code = 259) ? "Still Running" : "Exited with code " . code

        MsgBox("Process status: " . status, "Process Status")

        ; Get process priority class
        priority := DllCall("Kernel32.dll\GetPriorityClass", "Ptr", hProcess, "UInt")

        priorityNames := Map(
            0x00000040, "IDLE_PRIORITY_CLASS",
            0x00004000, "BELOW_NORMAL_PRIORITY_CLASS",
            0x00000020, "NORMAL_PRIORITY_CLASS",
            0x00008000, "ABOVE_NORMAL_PRIORITY_CLASS",
            0x00000080, "HIGH_PRIORITY_CLASS",
            0x00000100, "REALTIME_PRIORITY_CLASS"
        )

        priorityName := priorityNames.Has(priority) ? priorityNames[priority] : "Unknown"
        MsgBox(Format("Process Priority: 0x{:X}`n{}", priority, priorityName), "Priority")

        DllCall("Kernel32.dll\CloseHandle", "Ptr", hProcess, "Int")
    }
}

;==============================================================================
; EXAMPLE 4: Process Priority Management
;==============================================================================
Example4_ProcessPriority() {
    ; Priority class constants
    IDLE_PRIORITY_CLASS := 0x00000040
    BELOW_NORMAL_PRIORITY_CLASS := 0x00004000
    NORMAL_PRIORITY_CLASS := 0x00000020
    ABOVE_NORMAL_PRIORITY_CLASS := 0x00008000
    HIGH_PRIORITY_CLASS := 0x00000080

    PROCESS_QUERY_INFORMATION := 0x0400
    PROCESS_SET_INFORMATION := 0x0200

    currentPid := DllCall("Kernel32.dll\GetCurrentProcessId", "UInt")

    hProcess := DllCall("Kernel32.dll\OpenProcess"
        , "UInt", PROCESS_QUERY_INFORMATION | PROCESS_SET_INFORMATION
        , "Int", 0
        , "UInt", currentPid
        , "Ptr")

    if (!hProcess) {
        MsgBox("Failed to open process!", "Error")
        return
    }

    ; Get current priority
    origPriority := DllCall("Kernel32.dll\GetPriorityClass", "Ptr", hProcess, "UInt")

    MsgBox(Format("Current priority: 0x{:X}`n`nChanging to ABOVE_NORMAL...", origPriority), "Info")

    ; Set to above normal
    success := DllCall("Kernel32.dll\SetPriorityClass"
        , "Ptr", hProcess
        , "UInt", ABOVE_NORMAL_PRIORITY_CLASS
        , "Int")

    if (success) {
        newPriority := DllCall("Kernel32.dll\GetPriorityClass", "Ptr", hProcess, "UInt")
        MsgBox(Format("Priority changed to: 0x{:X}", newPriority), "Success")

        ; Restore original
        Sleep(1000)
        DllCall("Kernel32.dll\SetPriorityClass", "Ptr", hProcess, "UInt", origPriority, "Int")
        MsgBox("Priority restored", "Success")
    }

    DllCall("Kernel32.dll\CloseHandle", "Ptr", hProcess, "Int")
}

;==============================================================================
; EXAMPLE 5: Waiting for Process Completion
;==============================================================================
Example5_WaitForProcess() {
    ; Create a process that will exit quickly
    startupInfo := Buffer(104, 0)
    NumPut("UInt", 104, startupInfo, 0)

    processInfo := Buffer(24, 0)

    ; Run cmd /c echo Hello
    cmdLine := 'cmd.exe /c echo Hello && timeout /t 3'
    cmdLineBuffer := Buffer(StrPut(cmdLine, "UTF-16") * 2, 0)
    StrPut(cmdLine, cmdLineBuffer.Ptr, "UTF-16")

    ; CREATE_NO_WINDOW flag
    CREATE_NO_WINDOW := 0x08000000

    success := DllCall("Kernel32.dll\CreateProcessW"
        , "Ptr", 0
        , "Ptr", cmdLineBuffer.Ptr
        , "Ptr", 0
        , "Ptr", 0
        , "Int", 0
        , "UInt", CREATE_NO_WINDOW
        , "Ptr", 0
        , "Ptr", 0
        , "Ptr", startupInfo.Ptr
        , "Ptr", processInfo.Ptr
        , "Int")

    if (!success) {
        MsgBox("Failed to create process!", "Error")
        return
    }

    hProcess := NumGet(processInfo, 0, "Ptr")
    hThread := NumGet(processInfo, 8, "Ptr")

    MsgBox("Process created. Waiting for completion (3 seconds)...", "Info", "T1")

    ; Wait for process (INFINITE = 0xFFFFFFFF)
    WAIT_OBJECT_0 := 0
    WAIT_TIMEOUT := 0x00000102

    waitResult := DllCall("Kernel32.dll\WaitForSingleObject"
        , "Ptr", hProcess
        , "UInt", 5000      ; 5 second timeout
        , "UInt")

    if (waitResult = WAIT_OBJECT_0) {
        ; Get exit code
        exitCode := Buffer(4, 0)
        DllCall("Kernel32.dll\GetExitCodeProcess", "Ptr", hProcess, "Ptr", exitCode.Ptr, "Int")
        code := NumGet(exitCode, 0, "UInt")

        MsgBox("Process completed!`nExit code: " . code, "Success")
    } else {
        MsgBox("Wait timed out or failed!", "Error")
    }

    DllCall("Kernel32.dll\CloseHandle", "Ptr", hProcess, "Int")
    DllCall("Kernel32.dll\CloseHandle", "Ptr", hThread, "Int")
}

;==============================================================================
; EXAMPLE 6: Thread Information
;==============================================================================
Example6_ThreadInfo() {
    ; Get current thread
    hThread := DllCall("Kernel32.dll\GetCurrentThread", "Ptr")
    tid := DllCall("Kernel32.dll\GetCurrentThreadId", "UInt")

    ; Get thread priority
    priority := DllCall("Kernel32.dll\GetThreadPriority", "Ptr", hThread, "Int")

    priorityNames := Map(
        -2, "THREAD_PRIORITY_LOWEST",
        -1, "THREAD_PRIORITY_BELOW_NORMAL",
        0, "THREAD_PRIORITY_NORMAL",
        1, "THREAD_PRIORITY_ABOVE_NORMAL",
        2, "THREAD_PRIORITY_HIGHEST"
    )

    priorityName := priorityNames.Has(priority) ? priorityNames[priority] : "Unknown (" . priority . ")"

    info := Format("
    (
    Current Thread Information:
    ===========================

    Thread ID: {}
    Handle: 0x{:X}
    Priority: {}
    )", tid, hThread, priorityName)

    MsgBox(info, "Thread Info")

    ; Change thread priority temporarily
    THREAD_PRIORITY_ABOVE_NORMAL := 1

    success := DllCall("Kernel32.dll\SetThreadPriority"
        , "Ptr", hThread
        , "Int", THREAD_PRIORITY_ABOVE_NORMAL
        , "Int")

    if (success) {
        MsgBox("Thread priority changed to ABOVE_NORMAL", "Success", "T2")

        ; Restore
        DllCall("Kernel32.dll\SetThreadPriority", "Ptr", hThread, "Int", priority, "Int")
    }
}

;==============================================================================
; EXAMPLE 7: Advanced Process Operations
;==============================================================================
Example7_AdvancedOperations() {
    ; Get environment strings
    envStrings := DllCall("Kernel32.dll\GetEnvironmentStringsW", "Ptr")

    if (envStrings) {
        ; Parse first few environment variables
        results := "Environment Variables (first 5):`n`n"
        offset := 0
        count := 0

        Loop {
            str := StrGet(envStrings + offset, "UTF-16")
            if (str = "" || count >= 5)
                break

            results .= str . "`n"
            offset += (StrLen(str) + 1) * 2
            count++
        }

        MsgBox(results, "Environment")

        ; Free environment block
        DllCall("Kernel32.dll\FreeEnvironmentStringsW", "Ptr", envStrings, "Int")
    }

    ; Get Windows directory
    winDirBuf := Buffer(520, 0)
    length := DllCall("Kernel32.dll\GetWindowsDirectoryW"
        , "Ptr", winDirBuf.Ptr
        , "UInt", 260
        , "UInt")

    if (length > 0) {
        winDir := StrGet(winDirBuf.Ptr, "UTF-16")

        ; Get system directory
        sysDirBuf := Buffer(520, 0)
        DllCall("Kernel32.dll\GetSystemDirectoryW", "Ptr", sysDirBuf.Ptr, "UInt", 260, "UInt")
        sysDir := StrGet(sysDirBuf.Ptr, "UTF-16")

        MsgBox(Format("Directories:`n`nWindows: {}`nSystem: {}", winDir, sysDir), "System Paths")
    }

    ; Get computer name
    nameBuf := Buffer(520, 0)
    nameLenBuf := Buffer(4, 0)
    NumPut("UInt", 260, nameLenBuf, 0)

    DllCall("Kernel32.dll\GetComputerNameW"
        , "Ptr", nameBuf.Ptr
        , "Ptr", nameLenBuf.Ptr
        , "Int")

    computerName := StrGet(nameBuf.Ptr, "UTF-16")

    ; Get username
    userBuf := Buffer(520, 0)
    userLenBuf := Buffer(4, 0)
    NumPut("UInt", 260, userLenBuf, 0)

    DllCall("Advapi32.dll\GetUserNameW"
        , "Ptr", userBuf.Ptr
        , "Ptr", userLenBuf.Ptr
        , "Int")

    userName := StrGet(userBuf.Ptr, "UTF-16")

    MsgBox(Format("System Info:`n`nComputer: {}`nUser: {}", computerName, userName), "User Info")
}

;==============================================================================
; DEMO MENU
;==============================================================================

ShowDemoMenu() {
    menu := "
    (
    Process Operations DllCall Examples
    ====================================

    1. Process Information
    2. Create Process
    3. Open Existing Process
    4. Process Priority
    5. Wait for Process
    6. Thread Information
    7. Advanced Operations

    Enter choice (1-7) or 0 to exit:
    )"

    Loop {
        choice := InputBox(menu, "Process Examples", "w400 h350").Value

        if (choice = "0" or choice = "")
            break

        switch choice {
            case "1": Example1_ProcessInfo()
            case "2": Example2_CreateProcess()
            case "3": Example3_OpenProcess()
            case "4": Example4_ProcessPriority()
            case "5": Example5_WaitForProcess()
            case "6": Example6_ThreadInfo()
            case "7": Example7_AdvancedOperations()
            default: MsgBox("Invalid choice! Please enter 1-7.", "Error", "IconX")
        }
    }
}

; Run the demo menu
ShowDemoMenu()
