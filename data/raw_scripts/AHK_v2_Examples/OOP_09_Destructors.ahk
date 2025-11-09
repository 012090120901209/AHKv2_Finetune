#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Destructors - Resource Cleanup with __Delete
 *
 * Demonstrates automatic resource cleanup using __Delete method
 * for file handles, timers, and temporary resources.
 *
 * Source: AHK_Notes/Classes/class-destructors.md
 */

; Test 1: File handle cleanup
MsgBox("Test 1: File Handle Cleanup", , "T2")
{
    file := ManagedFile("test_output.txt")
    file.WriteLine("Hello, World!")
    file.WriteLine("This file will auto-close")
    ; file.__Delete() automatically called when 'file' goes out of scope
}
MsgBox("File automatically closed!", , "T2")

; Test 2: Timer cleanup
MsgBox("Test 2: Timer Cleanup (3 seconds)", , "T2")
{
    timer := ManagedTimer(500)
    timer.Start()
    Sleep(3000)
    ; timer.__Delete() automatically stops timer
}
MsgBox("Timer automatically stopped!", , "T2")

; Test 3: Temporary file cleanup
MsgBox("Test 3: Temporary File Cleanup", , "T2")
{
    tempFile := TempFile()
    MsgBox("Temp file created: " tempFile.path "`n`nWill be deleted automatically.", , "T3")
    ; tempFile.__Delete() automatically deletes file
}
MsgBox("Temp file automatically deleted!", , "T2")

/**
 * ManagedFile - Auto-closing file wrapper
 */
class ManagedFile {
    handle := 0
    path := ""

    __New(filePath) {
        this.path := filePath
        try {
            this.handle := FileOpen(filePath, "w")
        } catch as err {
            MsgBox("Error opening file: " err.Message)
        }
    }

    /**
     * Write line to file
     */
    WriteLine(text) {
        if (this.handle)
            this.handle.WriteLine(text)
    }

    /**
     * Destructor - Automatically closes file
     */
    __Delete() {
        if (this.handle) {
            try {
                this.handle.Close()
                ToolTip("File closed: " this.path)
                SetTimer(() => ToolTip(), -1000)
            } catch as err {
                ; Silent error handling in destructor
            }
        }
    }
}

/**
 * ManagedTimer - Auto-stopping timer
 */
class ManagedTimer {
    interval := 0
    timerFunc := 0
    tickCount := 0

    __New(intervalMs) {
        this.interval := intervalMs
        this.timerFunc := ObjBindMethod(this, "Tick")
    }

    /**
     * Start timer
     */
    Start() {
        SetTimer(this.timerFunc, this.interval)
    }

    /**
     * Timer tick callback
     */
    Tick() {
        this.tickCount++
        ToolTip("Timer tick: " this.tickCount)
    }

    /**
     * Destructor - Automatically stops timer
     */
    __Delete() {
        if (this.timerFunc) {
            try {
                SetTimer(this.timerFunc, 0)
                ToolTip()  ; Clear tooltip
            }
        }
    }
}

/**
 * TempFile - Auto-deleting temporary file
 */
class TempFile {
    path := ""

    __New() {
        ; Create temp file path
        this.path := A_Temp "\ahk_temp_" A_TickCount ".tmp"

        ; Create the file
        try {
            FileAppend("Temporary data", this.path)
        } catch as err {
            MsgBox("Error creating temp file: " err.Message)
        }
    }

    /**
     * Destructor - Automatically deletes temp file
     */
    __Delete() {
        if (this.path && FileExist(this.path)) {
            try {
                FileDelete(this.path)
                ToolTip("Deleted: " this.path)
                SetTimer(() => ToolTip(), -2000)
            } catch as err {
                ; Log error but don't throw in destructor
            }
        }
    }
}

/*
 * Key Concepts:
 *
 * 1. Destructor Syntax:
 *    __Delete() {
 *        ; Cleanup code here
 *    }
 *    Called automatically when object is destroyed
 *
 * 2. When Destructors Run:
 *    - Object goes out of scope
 *    - Script exits
 *    - Garbage collector runs
 *    - ObjRelease() is called
 *
 * 3. Resource Cleanup:
 *    Common resources to clean up:
 *    ✅ File handles
 *    ✅ Timers
 *    ✅ GUI windows
 *    ✅ COM objects
 *    ✅ Temporary files
 *    ✅ Network connections
 *
 * 4. Error Handling:
 *    try/catch in destructors
 *    Don't throw errors from destructors
 *    Silent failure is often better
 *
 * 5. RAII Pattern:
 *    Resource Acquisition Is Initialization
 *    Acquire in __New()
 *    Release in __Delete()
 *    Automatic lifetime management
 *
 * 6. Best Practices:
 *    ✅ Keep destructors simple
 *    ✅ Don't rely on execution order
 *    ✅ Use try/catch for safety
 *    ✅ Validate resources exist
 *    ⚠ Don't access other objects
 *    ⚠ Timing is unpredictable
 *
 * 7. Manual Cleanup:
 *    For critical resources, add Close() method
 *    Don't rely solely on destructor
 *    Explicit cleanup is safer
 *
 * 8. Scope-Based Cleanup:
 *    {
 *        obj := ManagedFile("test.txt")
 *        ; Use obj
 *    }  ; obj.__Delete() called here
 *
 * 9. Memory Management:
 *    AHK uses reference counting
 *    When refcount = 0, destructor runs
 *    Circular refs prevent cleanup
 */
