#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Child Process Examples - thqby/ahk2_lib
*
* Execute external programs and capture output
* Library: https://github.com/thqby/ahk2_lib/blob/master/child_process.ahk
*
* To use these examples:
* #Include <child_process>
*/

/**
* Example 1: Run Command and Get Output
*/
RunCommandExample() {
    ; Run ping command
    proc := child_process('ping -n 4 google.com')

    ; Wait for completion
    proc.wait()

    ; Read output
    output := proc.stdout.read()

    MsgBox("Ping Output:`n`n" output)
}

/**
* Example 2: Run with Arguments Array
*/
RunWithArgsExample() {
    ; Run with arguments array
    args := ['-n', '2', 'localhost']
    proc := child_process('ping', args)

    proc.wait()
    output := proc.stdout.read()

    MsgBox("Ping Localhost:`n`n" output)
}

/**
* Example 3: Capture Stdout and Stderr Separately
*/
CaptureStdErrExample() {
    ; Run command that might produce errors
    proc := child_process('cmd /c dir C:\NonExistentFolder 2>&1')

    proc.wait()

    stdout := proc.stdout.read()
    stderr := proc.stderr.read()

    output := "STDOUT:`n" stdout "`n`n"
    output .= "STDERR:`n" (stderr ? stderr : "No errors")

    MsgBox(output)
}

/**
* Example 4: Set Working Directory
*/
SetWorkingDirectoryExample() {
    ; Run dir command in specific directory
    options := Map()
    options.cwd := A_WinDir  ; Set working directory to Windows folder

    proc := child_process('cmd /c dir /b', , options)
    proc.wait()

    output := proc.stdout.read()
    MsgBox("Files in " A_WinDir ":`n`n" output)
}

/**
* Example 5: Send Input to Process
*/
SendInputExample() {
    ; Start cmd.exe
    options := Map()
    options.encoding := 'cp' DllCall('GetOEMCP')  ; Use console codepage

    proc := child_process('cmd.exe', , options)

    ; Write commands to stdin
    proc.stdin.Write("echo Hello from AHK!`n")
    proc.stdin.Write("echo Current directory:`n")
    proc.stdin.Write("cd`n")
    proc.stdin.Write("exit`n")

    ; Wait and read output
    proc.wait()
    output := proc.stdout.read()

    MsgBox("CMD Output:`n`n" output)
}

/**
* Example 6: Run Python Script
*/
RunPythonExample() {
    ; Create simple Python script
    scriptPath := A_ScriptDir "\test_script.py"
    FileDelete(scriptPath)
    FileAppend("
    (
    import sys
    print('Hello from Python!')
    print(f'Python version: {sys.version}')
    print(f'Arguments: {sys.argv[1:]}')
    )", scriptPath)

    ; Run Python script with arguments
    proc := child_process('python', [scriptPath, 'arg1', 'arg2'])
    proc.wait()

    output := proc.stdout.read()
    MsgBox("Python Output:`n`n" output)

    ; Cleanup
    FileDelete(scriptPath)
}

/**
* Example 7: Monitor Process Exit Code
*/
ExitCodeExample() {
    ; Run command that succeeds
    proc1 := child_process('cmd /c exit 0')
    proc1.wait()
    exitCode1 := proc1.exitCode

    ; Run command that fails
    proc2 := child_process('cmd /c exit 42')
    proc2.wait()
    exitCode2 := proc2.exitCode

    output := "Exit Code Testing:`n`n"
    output .= "Success command exit code: " exitCode1 " (0 = success)`n"
    output .= "Failure command exit code: " exitCode2 " (42 = custom error)`n`n"
    output .= "Use exit codes to detect command success/failure"

    MsgBox(output)
}

/**
* Example 8: Run Hidden Process
*/
RunHiddenExample() {
    ; Run process completely hidden
    options := Map()
    options.hide := true  ; Don't show window

    proc := child_process('cmd /c echo This runs hidden', , options)
    proc.wait()

    output := proc.stdout.read()
    MsgBox("Hidden Process Output:`n`n" output "`n`nNo window was shown!")
}

/**
* Example 9: Timeout on Long-Running Process
*/
TimeoutExample() {
    ; Start long-running process
    proc := child_process('ping -n 100 localhost')

    ; Wait with timeout (3000ms = 3 seconds)
    startTime := A_TickCount
    result := proc.wait(3000)
    elapsed := A_TickCount - startTime

    if (result = 0x102) {  ; WAIT_TIMEOUT
    proc.terminate()
    MsgBox("Process timeout!`nElapsed: " elapsed "ms`nProcess was terminated.")
} else {
    MsgBox("Process completed`nElapsed: " elapsed "ms")
}
}

/**
* Example 10: Interactive Command Shell
*/
InteractiveShellExample() {

    ; Create interactive shell
    shell := InteractiveShell()

    ; Execute commands
    output := "Interactive Shell Demo:`n`n"

    ; Command 1
    result1 := shell.Execute("echo Hello World")
    output .= "Command: echo Hello World`n"
    output .= "Output: " Trim(result1) "`n`n"

    ; Command 2
    result2 := shell.Execute("ver")
    output .= "Command: ver`n"
    output .= "Output: " Trim(result2) "`n`n"

    shell.Close()

    MsgBox(output)
}

; Display menu
MsgBox("Child Process Library Examples Loaded`n`n"
. "Available Examples:`n`n"
. "1. RunCommandExample() - Run command and get output`n"
. "2. RunWithArgsExample() - Use arguments array`n"
. "3. CaptureStdErrExample() - Capture errors`n"
. "4. SetWorkingDirectoryExample() - Set working dir`n"
. "5. SendInputExample() - Send input to process`n"
. "6. RunPythonExample() - Execute Python scripts`n"
. "7. ExitCodeExample() - Monitor exit codes`n"
. "8. RunHiddenExample() - Run hidden processes`n"
. "9. TimeoutExample() - Timeout long processes`n"
. "10. InteractiveShellExample() - Interactive cmd shell`n`n"
. "Uncomment any function call below to run")

; Uncomment to run examples:
; RunCommandExample()
; RunWithArgsExample()
; CaptureStdErrExample()
; SetWorkingDirectoryExample()
; SendInputExample()
; RunPythonExample()
; ExitCodeExample()
; RunHiddenExample()
; TimeoutExample()
; InteractiveShellExample()

; Moved class InteractiveShell from nested scope
class InteractiveShell {
    proc := ''
    stdin := ''
    stdout := ''

    __New() {
        options := Map()
        options.encoding := 'cp' DllCall('GetOEMCP')

        this.proc := child_process('cmd.exe', , options)
        this.stdin := this.proc.stdin
        this.stdout := this.proc.stdout

        ; Setup stdout reader
        this.stdout.complete := false
        this.stdout.onData := (pipe, data) => {
            ; Detect command prompt to know when output is complete
            if RegExMatch(data, '(^|`n)(\s*[A-Z]:[^>]*>)$', &m) {
                pipe.append(SubStr(data, pipe.complete := 1, -m.Len[2]))
            } else {
                pipe.append(data)
            }
        }
    }

    Execute(command) {
        ; Write command
        this.stdin.Write(command "`n")
        this.stdin.Read(0)  ; Flush

        ; Wait for completion
        this.stdout.complete := false
        timeout := A_TickCount + 5000
        while (!this.stdout.complete && A_TickCount < timeout)
        Sleep(10)

        ; Read output
        result := this.stdout.read()
        this.stdout.complete := false
        return result
    }

    Close() {
        this.stdin.Write("exit`n")
        this.proc.wait(1000)
        this.proc.terminate()
    }
}
