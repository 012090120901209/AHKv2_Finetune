#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Semaphore - Counted Resource Synchronization
 *
 * Demonstrates using Semaphore to limit concurrent access to resources.
 * Unlike Mutex (binary), Semaphore allows N simultaneous accesses.
 *
 * Source: AHK_Notes/Snippets/Semaphore.md
 */

; Example: Resource Pool with 3 Available Resources
MsgBox("Semaphore Example: Resource Pool`n`n"
     . "Creating pool with 3 available resources.`n"
     . "Will attempt 5 concurrent accesses.", , "T3")

; Create semaphore with 3 available resources (max 3)
sem := Semaphore(3, 3, "Local\ResourcePool")

; Simulate 5 concurrent resource requests
SetTimer(() => UseResource("Resource A", 2000), -100)
SetTimer(() => UseResource("Resource B", 3000), -200)
SetTimer(() => UseResource("Resource C", 1000), -300)
SetTimer(() => UseResource("Resource D", 1500), -400)  ; Will wait
SetTimer(() => UseResource("Resource E", 2500), -500)  ; Will wait

Persistent()

/**
 * Function to simulate resource usage
 */
UseResource(resourceName, duration) {
    ; Open the semaphore
    sem := Semaphore("Local\ResourcePool")

    ; Try to acquire resource (wait up to 5 seconds)
    if (sem.Wait(5000) != 0) {
        MsgBox("✗ " resourceName " - Failed to acquire (timed out)", , "Icon! T2")
        return
    }

    ; Resource acquired
    MsgBox("✓ " resourceName " - Acquired from pool", , "T1")

    ; Simulate work
    Sleep(duration)

    ; Release resource back to pool
    prevCount := sem.Release()
    MsgBox("✓ " resourceName " - Released (now " (prevCount + 1) " available)", , "T2")
}

/**
 * Semaphore Class Implementation
 *
 * Wraps Windows Semaphore API for counting synchronization
 */
class Semaphore {
    /**
     * Create or open a semaphore
     *
     * Creating new semaphore:
     *   Semaphore(initialCount, maximumCount, name?, securityAttributes)
     *
     * Opening existing semaphore:
     *   Semaphore(name, desiredAccess?, inheritHandle?)
     */
    __New(initialCount, maximumCount?, name?, securityAttributes := 0) {
        ; Create new semaphore
        if IsSet(initialCount) && IsSet(maximumCount) &&
           IsInteger(initialCount) && IsInteger(maximumCount) {
            this.ptr := DllCall("CreateSemaphore",
                "Ptr", securityAttributes,
                "Int", initialCount,
                "Int", maximumCount,
                "Ptr", IsSet(name) ? StrPtr(name) : 0)

            if (!this.ptr)
                throw Error("Unable to create the semaphore", -1)
        }
        ; Open existing semaphore
        else if IsSet(initialCount) && initialCount is String {
            this.ptr := DllCall("OpenSemaphore",
                "Int", maximumCount ?? 0x0002,  ; SEMAPHORE_MODIFY_STATE
                "Int", !!(name ?? 0),           ; inheritHandle
                "Ptr", StrPtr(initialCount))    ; name

            if (!this.ptr)
                throw Error("Unable to open the semaphore", -1)
        }
        else
            throw ValueError("Invalid parameter list!", -1)
    }

    /**
     * Wait for semaphore (decrement count)
     *
     * @param timeout - Milliseconds to wait (0xFFFFFFFF = infinite)
     * @return 0 = success, 258 = timeout
     */
    Wait(timeout := 0xFFFFFFFF) {
        return DllCall("WaitForSingleObject", "Ptr", this, "Int", timeout, "Int")
    }

    /**
     * Release semaphore (increment count)
     *
     * @param count - Number to release (default 1)
     * @param out - Output variable for previous count
     * @return Previous count value
     */
    Release(count := 1, &out?) {
        out := DllCall("ReleaseSemaphore",
            "Ptr", this,
            "Int", count,
            "Int*", &prevCount := 0)
        return prevCount
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
 * 1. Semaphore vs Mutex:
 *
 *    Mutex (Binary):
 *    - Only 1 can access at a time
 *    - Ownership (same thread must release)
 *    - Use for exclusive access
 *
 *    Semaphore (Counted):
 *    - N can access simultaneously
 *    - No ownership (any thread can release)
 *    - Use for resource pools
 *
 * 2. Semaphore Counts:
 *    - initialCount: Available resources at creation
 *    - maximumCount: Maximum available resources
 *    - Current count: Decreases on Wait, increases on Release
 *    - Wait blocks when count = 0
 *
 * 3. Common Use Cases:
 *    - Connection pools (database, network)
 *    - Thread pools
 *    - License limiting
 *    - Rate limiting
 *    - Resource quotas
 *    - Concurrent instance limiting
 *
 * 4. Example Scenarios:
 *
 *    Database Connection Pool:
 *    - Max 10 connections
 *    - Semaphore(10, 10)
 *    - Wait() = acquire connection
 *    - Release() = return connection
 *
 *    Rate Limiter:
 *    - Max 5 requests/second
 *    - Semaphore(5, 5)
 *    - Timer releases periodically
 *
 *    Printer Queue:
 *    - Max 3 simultaneous prints
 *    - Semaphore(3, 3)
 *
 * 5. Best Practices:
 *    ✅ Always match Wait() with Release()
 *    ✅ Use timeout to prevent deadlocks
 *    ✅ Handle timeout cases gracefully
 *    ✅ Release in finally block for guaranteed cleanup
 *    ⚠️  Don't release more than acquired
 *    ⚠️  Don't exceed maximum count
 */
