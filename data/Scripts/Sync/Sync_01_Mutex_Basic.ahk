#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Mutex - Mutual Exclusion Synchronization
 * 
 * Demonstrates using Mutex for exclusive access to shared resources.
 * Prevents multiple threads/processes from accessing same resource simultaneously.
 * 
 * Source: AHK_Notes/Snippets/Mutex.md
 */

; Example 1: Basic Mutex Usage
MsgBox("Example 1: Basic Mutex Lock/Release`n`n"
    . "Attempting to acquire mutex...", , "T3")

mtx := Mutex("Local\MyAppMutex")

if (mtx.Lock(5000) = 0) {
    MsgBox("✓ Mutex acquired successfully!`n`n"
        . "Resource is now locked.`n"
        . "Simulating work for 2 seconds...", , "T2")

    Sleep(2000)

    mtx.Release()
    MsgBox("✓ Mutex released!`n`nResource is now available.", , "T2")
} else {
    MsgBox("✗ Could not acquire mutex within timeout period", , "Icon!")
}

; Example 2: Prevent Multiple Script Instances
; Note: #SingleInstance Force does this automatically,
; but Mutex provides more control

mtx2 := Mutex("Local\SingleInstanceMutex")

if (mtx2.Lock(0) != 0) {  ; 0ms timeout = don't wait
    MsgBox("Another instance is already running!`n`n"
        . "This script will exit.", , "Icon! T3")
    ExitApp
}

MsgBox("✓ This is the only running instance.`n`n"
    . "Mutex will be released when script exits.", , "T3")

; Mutex is automatically released when object is destroyed (script exits)

/**
 * Mutex Class Implementation
 * 
 * Wraps Windows Mutex API for synchronization
 */
class Mutex {
    /**
     * Create or open a mutex
     * 
     * @param name - Mutex name (Local\ for session-scoped, Global\ for system-wide)
     * @param initialOwner - If true, calling thread owns mutex initially
     * @param securityAttributes - Security descriptor (usually 0)
     */
    __New(name?, initialOwner := 0, securityAttributes := 0) {
        this.ptr := DllCall("CreateMutex",
            "Ptr", securityAttributes,
            "Int", !!initialOwner,
            "Ptr", IsSet(name) ? StrPtr(name) : 0)

        if (!this.ptr)
            throw Error("Unable to create or open the mutex", -1)
    }

    /**
     * Acquire (lock) the mutex
     * 
     * @param timeout - Milliseconds to wait (0xFFFFFFFF = infinite)
     * @return 0 = success, 258 = timeout, other = error
     */
    Lock(timeout := 0xFFFFFFFF) {
        return DllCall("WaitForSingleObject", "Ptr", this, "Int", timeout, "Int")
    }

    /**
     * Release (unlock) the mutex
     * 
     * @return Non-zero on success
     */
    Release() {
        return DllCall("ReleaseMutex", "Ptr", this)
    }

    /**
     * Destructor - automatically closes handle
     */
    __Delete() {
        DllCall("CloseHandle", "Ptr", this)
    }
}

/*
* Key Concepts:
*
* 1. Mutex (Mutual Exclusion):
*    - Synchronization primitive
*    - Only one thread/process can own at a time
*    - Others must wait until released
*
* 2. Lock Return Values:
*    0 (WAIT_OBJECT_0) = Success, mutex acquired
*    258 (WAIT_TIMEOUT) = Timeout expired
*    192 (WAIT_ABANDONED) = Previous owner terminated
*    Other values = Error
*
* 3. Mutex Naming:
*    Local\Name = Session-scoped (current user session)
*    Global\Name = System-wide (all users)
*    No prefix = Local to current process
*
* 4. Common Use Cases:
*    - Single instance enforcement
*    - Exclusive file access
*    - Critical section protection
*    - Inter-process synchronization
*    - Resource locking
*
* 5. Best Practices:
*    ✅ Always release mutex when done
*    ✅ Use timeout to prevent deadlocks
*    ✅ Handle timeout/error cases
*    ✅ Use try/finally for guaranteed release
*    ⚠️  Don't lock for extended periods
*    ⚠️  Avoid nested locks (can cause deadlock)
*
* 6. Automatic Cleanup:
*    - Mutex released when object destroyed
*    - Windows releases if process terminates
*    - Use OnExit for explicit cleanup
*/

