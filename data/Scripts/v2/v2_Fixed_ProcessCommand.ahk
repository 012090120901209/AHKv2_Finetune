#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* AHK v2 Process/Command Execution Functions - Corrected
*
* Fixed versions of StdOutToVar and StdOutStream for v2
* These functions execute command-line programs and capture their output
*/

/**
* Execute a command and return all stdout output
*
* Original by SKAN and Sean, corrected for AHK v2
* @param {String} sCmd - Command line to execute
* @returns {String} Complete stdout output from the command
*
* Example: result := StdOutToVar("ping 1.1.1.1")
*/
StdOutToVar(sCmd) {
    ; Create anonymous pipes for stdout
    DllCall("CreatePipe", "Ptr*", &hPipeRead := 0, "Ptr*", &hPipeWrite := 0, "Ptr", 0, "UInt", 0)
    DllCall("SetHandleInformation", "Ptr", hPipeWrite, "UInt", 1, "UInt", 1)

    ; STARTUPINFO structure
    STARTUPINFO := Buffer(104, 0)
    NumPut("UInt", 104, STARTUPINFO, 0)                    ; cbSize
    NumPut("UInt", 0x100, STARTUPINFO, 60)                 ; dwFlags = STARTF_USESTDHANDLES
    NumPut("Ptr", hPipeWrite, STARTUPINFO, 88)             ; hStdOutput
    NumPut("Ptr", hPipeWrite, STARTUPINFO, 96)             ; hStdError

    ; PROCESS_INFORMATION structure
    PROCESS_INFORMATION := Buffer(24, 0)

    ; Create process
    if !DllCall("CreateProcess"
    , "Ptr", 0                                          ; lpApplicationName
    , "Str", sCmd                                       ; lpCommandLine
    , "Ptr", 0                                          ; lpProcessAttributes
    , "Ptr", 0                                          ; lpThreadAttributes
    , "UInt", 1                                         ; bInheritHandles
    , "UInt", 0x08000000                                ; dwCreationFlags (CREATE_NO_WINDOW)
    , "Ptr", 0                                          ; lpEnvironment
    , "Ptr", 0                                          ; lpCurrentDirectory
    , "Ptr", STARTUPINFO                                ; lpStartupInfo
    , "Ptr", PROCESS_INFORMATION) {                     ; lpProcessInformation

    DllCall("CloseHandle", "Ptr", hPipeWrite)
    DllCall("CloseHandle", "Ptr", hPipeRead)
    throw Error("Failed to create process")
}

hProcess := NumGet(PROCESS_INFORMATION, 0, "Ptr")
hThread := NumGet(PROCESS_INFORMATION, 8, "Ptr")

DllCall("CloseHandle", "Ptr", hPipeWrite)

; Read output
Buffer := Buffer(4096, 0)
sOutput := ""

while DllCall("ReadFile", "Ptr", hPipeRead, "Ptr", Buffer, "UInt", 4094, "UInt*", &nSz := 0, "Ptr", 0) {
    if (nSz = 0)
    break
    sOutput .= StrGet(Buffer, nSz, "CP0")
}

; Cleanup
DllCall("GetExitCodeProcess", "Ptr", hProcess, "UInt*", &ExitCode := 0)
DllCall("CloseHandle", "Ptr", hProcess)
DllCall("CloseHandle", "Ptr", hThread)
DllCall("CloseHandle", "Ptr", hPipeRead)

return sOutput
}

/**
* Execute command and stream output to callback function
*
* @param {String} sCmd - Command to execute
* @param {Func} Callback - Function to call for each chunk of output
*                          Callback(text, lineNumber) is called for each chunk
*                          Callback("", 0) is called when complete
* @returns {String} Complete output if no callback, empty if callback provided
*
* Example: StdOutStream("ping 1.1.1.1", (text, line) => ToolTip(text))
*/
StdOutStream(sCmd, Callback := "") {
    ; Create pipes
    DllCall("CreatePipe", "Ptr*", &hPipeRead := 0, "Ptr*", &hPipeWrite := 0, "Ptr", 0, "UInt", 0)
    DllCall("SetHandleInformation", "Ptr", hPipeWrite, "UInt", 1, "UInt", 1)

    STARTUPINFO := Buffer(104, 0)
    NumPut("UInt", 104, STARTUPINFO, 0)
    NumPut("UInt", 0x100, STARTUPINFO, 60)
    NumPut("Ptr", hPipeWrite, STARTUPINFO, 88)
    NumPut("Ptr", hPipeWrite, STARTUPINFO, 96)

    PROCESS_INFORMATION := Buffer(24, 0)

    if !DllCall("CreateProcess", "Ptr", 0, "Str", sCmd, "Ptr", 0, "Ptr", 0
    , "UInt", 1, "UInt", 0x08000000, "Ptr", 0, "Ptr", 0
    , "Ptr", STARTUPINFO, "Ptr", PROCESS_INFORMATION) {
        DllCall("CloseHandle", "Ptr", hPipeWrite)
        DllCall("CloseHandle", "Ptr", hPipeRead)
        throw Error("Failed to create process")
    }

    hProcess := NumGet(PROCESS_INFORMATION, 0, "Ptr")
    hThread := NumGet(PROCESS_INFORMATION, 8, "Ptr")
    DllCall("CloseHandle", "Ptr", hPipeWrite)

    Buffer := Buffer(4096, 0)
    sOutput := ""
    lineNum := 0

    while DllCall("ReadFile", "Ptr", hPipeRead, "Ptr", Buffer, "UInt", 4094, "UInt*", &nSz := 0, "Int", 0) {
        if (nSz = 0)
        break

        tOutput := StrGet(Buffer, nSz, "CP0")
        lineNum++

        if (IsObject(Callback) && HasMethod(Callback, "Call"))
        Callback.Call(tOutput, lineNum)
        else
        sOutput .= tOutput
    }

    DllCall("GetExitCodeProcess", "Ptr", hProcess, "UInt*", &ExitCode := 0)
    DllCall("CloseHandle", "Ptr", hProcess)
    DllCall("CloseHandle", "Ptr", hThread)
    DllCall("CloseHandle", "Ptr", hPipeRead)

    ; Call callback with empty string to signal completion
    if (IsObject(Callback) && HasMethod(Callback, "Call"))
    Callback.Call("", 0)

    return sOutput
}

/**
* Example 1: Execute ping and get complete output
*/
PingExample() {
    MsgBox("Executing ping command...")
    result := StdOutToVar("ping -n 4 1.1.1.1")
    MsgBox("Ping result:`n`n" result)
}

/**
* Example 2: List directory contents
*/
DirExample() {
    result := StdOutToVar("cmd /c dir " A_ScriptDir)
    MsgBox("Directory listing:`n`n" result)
}

/**
* Example 3: Get system information
*/
SystemInfoExample() {
    result := StdOutToVar("systeminfo | findstr /C:`"OS Name`" /C:`"OS Version`"")
    MsgBox("System Info:`n`n" result)
}

/**
* Example 4: Stream output with callback
*/
StreamExample() {
    outputText := ""

    ; Create callback to accumulate output
    callback := (text, line) {
        global outputText
        if (line > 0) {
            outputText .= text
            ToolTip("Line " line ":`n" SubStr(outputText, -200))
        } else {
            ToolTip()
            MsgBox("Command completed!`n`nOutput:`n" outputText)
        }
    }

    StdOutStream("ping -n 4 8.8.8.8", callback)
}

/**
* Example 5: Execute PowerShell command
*/
PowerShellExample() {
    psCmd := 'powershell -Command "Get-Process | Select-Object -First 5 | Format-Table Name, CPU"'
    result := StdOutToVar(psCmd)
    MsgBox("Top 5 processes:`n`n" result)
}

/**
* Example 6: Get network adapters
*/
NetworkExample() {
    result := StdOutToVar("ipconfig")
    MsgBox("Network configuration:`n`n" SubStr(result, 1, 500) "`n...")
}

/**
* Example 7: Execute Python script (if Python installed)
*/
PythonExample() {
    ; Create temporary Python script
    script := 'import sys; print(f"Python {sys.version}"); print("Hello from Python!")'
    result := StdOutToVar('python -c "' script '"')
    MsgBox("Python output:`n`n" result)
}

/**
* Example 8: Real-time streaming with progress
*/
StreamProgressExample() {
    lineCount := 0

    progressCallback := (text, line) {
        static lineCount := 0
        if (line > 0) {
            lineCount++
            ToolTip("Processing line " lineCount "`n" text)
        } else {
            ToolTip()
            MsgBox("Processed " lineCount " lines of output")
        }
    }

    ; This will show real-time progress
    StdOutStream("ping -n 10 localhost", progressCallback)
}

MsgBox("Process/Command Execution Functions Loaded`n`nUncomment examples to test:`n`n"
. "- PingExample()`n"
. "- DirExample()`n"
. "- SystemInfoExample()`n"
. "- StreamExample()`n"
. "- PowerShellExample()`n"
. "- NetworkExample()")

; Uncomment to test:
; PingExample()
; DirExample()
; SystemInfoExample()
; StreamExample()
; PowerShellExample()
; NetworkExample()
