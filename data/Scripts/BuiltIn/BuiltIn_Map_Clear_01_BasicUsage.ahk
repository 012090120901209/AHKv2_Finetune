#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* BuiltIn_Map_Clear_01_BasicUsage.ahk
*
* @description Comprehensive examples of Map.Clear() method
* @author AutoHotkey v2 Examples Collection
* @version 1.0.0
* @date 2025-11-16
*
* @overview
* The Map.Clear() method removes all key-value pairs from a Map.
* Syntax: MapObject.Clear()
* Returns: void (no return value)
*
* Key Features:
* - Remove all entries at once
* - Reset map to empty state
* - Faster than deleting individually
* - Useful for bulk operations
*/

;=============================================================================
; Example 1: Basic Clear Operation
;=============================================================================

Example1_BasicClear() {
    data := Map(
    "key1", "value1",
    "key2", "value2",
    "key3", "value3",
    "key4", "value4",
    "key5", "value5"
    )

    output := "=== Basic Clear Example ===`n`n"
    output .= "Before Clear:`n"
    output .= "  Count: " data.Count "`n"
    output .= "  Has 'key1': " (data.Has("key1") ? "Yes" : "No") "`n`n"

    ; Clear all entries
    data.Clear()

    output .= "After Clear:`n"
    output .= "  Count: " data.Count "`n"
    output .= "  Has 'key1': " (data.Has("key1") ? "Yes" : "No") "`n"

    MsgBox(output, "Basic Clear")
}

;=============================================================================
; Example 2: Clear vs Delete Performance
;=============================================================================

Example2_ClearVsDelete() {
    ; Create large map
    data1 := Map()
    data2 := Map()

    Loop 1000 {
        data1.Set("key" A_Index, "value" A_Index)
        data2.Set("key" A_Index, "value" A_Index)
    }

    output := "=== Clear vs Delete Performance ===`n`n"

    ; Method 1: Clear()
    start := A_TickCount
    data1.Clear()
    clearTime := A_TickCount - start

    ; Method 2: Individual Delete
    start := A_TickCount
    for key in data2 {
        data2.Delete(key)
    }
    deleteTime := A_TickCount - start

    output .= "Removing 1000 items:`n"
    output .= "  Clear(): " clearTime "ms`n"
    output .= "  Individual Delete: " deleteTime "ms`n"
    output .= "`nClear is " Round(deleteTime / clearTime, 1) "x faster`n"

    MsgBox(output, "Performance Comparison")
}

;=============================================================================
; Example 3: Reset and Reinitialize Pattern
;=============================================================================

Example3_ResetPattern() {
    config := Map()

    LoadDefaults() {
        config.Clear()
        config.Set("theme", "light")
        config.Set("fontSize", 12)
        config.Set("language", "en")
        config.Set("autoSave", true)
    }

    output := "=== Reset Pattern ===`n`n"

    ; Initial load
    LoadDefaults()
    output .= "Initial config: " config.Count " settings`n`n"

    ; User makes changes
    config.Set("theme", "dark")
    config.Set("fontSize", 16)
    config.Set("customSetting", "value")
    output .= "After user changes: " config.Count " settings`n"
    output .= "  Theme: " config["theme"] "`n"
    output .= "  Custom: " config["customSetting"] "`n`n"

    ; Reset to defaults
    LoadDefaults()
    output .= "After reset: " config.Count " settings`n"
    output .= "  Theme: " config["theme"] "`n"
    output .= "  Has custom: " (config.Has("customSetting") ? "Yes" : "No") "`n"

    MsgBox(output, "Reset Pattern")
}

;=============================================================================
; Example 4: Session Management
;=============================================================================

Example4_SessionManagement() {
    sessions := Map()

    CreateSession(userId) {
        sessionId := "sess_" A_TickCount
        sessions.Set(sessionId, Map(
        "userId", userId,
        "created", A_Now,
        "data", Map()
        ))
        return sessionId
    }

    ClearAllSessions() {
        count := sessions.Count
        sessions.Clear()
        return count
    }

    output := "=== Session Management ===`n`n"

    ; Create sessions
    CreateSession("user1")
    CreateSession("user2")
    CreateSession("user3")

    output .= "Active sessions: " sessions.Count "`n`n"

    ; Clear all sessions (logout all)
    cleared := ClearAllSessions()

    output .= "Cleared " cleared " sessions`n"
    output .= "Active sessions: " sessions.Count "`n"

    MsgBox(output, "Session Management")
}

;=============================================================================
; Example 5: Batch Processing with Clear
;=============================================================================

Example5_BatchProcessing() {
    buffer := Map()

    ProcessBatch(items) {
        ; Load items into buffer
        for item in items {
            buffer.Set(item.id, item.value)
        }

        ; Process buffer
        result := "Processed " buffer.Count " items"

        ; Clear buffer for next batch
        buffer.Clear()

        return result
    }

    output := "=== Batch Processing ===`n`n"

    ; Batch 1
    batch1 := [{id: "i1", value: "v1"}, {id: "i2", value: "v2"}]
    output .= ProcessBatch(batch1) "`n"
    output .= "Buffer after batch 1: " buffer.Count " items`n`n"

    ; Batch 2
    batch2 := [{id: "i3", value: "v3"}, {id: "i4", value: "v4"}, {id: "i5", value: "v5"}]
    output .= ProcessBatch(batch2) "`n"
    output .= "Buffer after batch 2: " buffer.Count " items`n"

    MsgBox(output, "Batch Processing")
}

;=============================================================================
; Example 6: Clear with Backup
;=============================================================================

Example6_ClearWithBackup() {
    data := Map("key1", "value1", "key2", "value2", "key3", "value3")
    backup := Map()

    ClearWithBackup() {
        ; Backup current data
        backup.Clear()
        for key, value in data {
            backup.Set(key, value)
        }

        ; Clear data
        count := data.Count
        data.Clear()

        return count
    }

    RestoreFromBackup() {
        for key, value in backup {
            data.Set(key, value)
        }
        return backup.Count
    }

    output := "=== Clear with Backup ===`n`n"

    output .= "Original: " data.Count " items`n`n"

    cleared := ClearWithBackup()
    output .= "Cleared " cleared " items (backed up)`n"
    output .= "Current: " data.Count " items`n"
    output .= "Backup: " backup.Count " items`n`n"

    restored := RestoreFromBackup()
    output .= "Restored " restored " items`n"
    output .= "Current: " data.Count " items`n"

    MsgBox(output, "Clear with Backup")
}

;=============================================================================
; Example 7: Multi-Map Synchronized Clear
;=============================================================================

Example7_SynchronizedClear() {
    users := Map("u1", "Alice", "u2", "Bob")
    sessions := Map("s1", "u1", "s2", "u2")
    cache := Map("c1", "data1", "c2", "data2")

    ClearAll() {
        counts := Map(
        "users", users.Count,
        "sessions", sessions.Count,
        "cache", cache.Count
        )

        users.Clear()
        sessions.Clear()
        cache.Clear()

        return counts
    }

    output := "=== Synchronized Clear ===`n`n"

    output .= "Before clear:`n"
    output .= "  Users: " users.Count "`n"
    output .= "  Sessions: " sessions.Count "`n"
    output .= "  Cache: " cache.Count "`n`n"

    cleared := ClearAll()

    output .= "Cleared:`n"
    for name, count in cleared {
        output .= "  " name ": " count "`n"
    }

    output .= "`nAfter clear:`n"
    output .= "  Users: " users.Count "`n"
    output .= "  Sessions: " sessions.Count "`n"
    output .= "  Cache: " cache.Count "`n"

    MsgBox(output, "Synchronized Clear")
}

;=============================================================================
; GUI Interface
;=============================================================================

CreateDemoGUI() {
    demoGui := Gui()
    demoGui.Title := "Map.Clear() - Usage Examples"

    demoGui.Add("Text", "x10 y10 w480 +Center", "Clear All Entries with Map.Clear()")

    demoGui.Add("Button", "x10 y40 w230 h30", "Example 1: Basic Clear")
    .OnEvent("Click", (*) => Example1_BasicClear())

    demoGui.Add("Button", "x250 y40 w230 h30", "Example 2: Performance")
    .OnEvent("Click", (*) => Example2_ClearVsDelete())

    demoGui.Add("Button", "x10 y80 w230 h30", "Example 3: Reset")
    .OnEvent("Click", (*) => Example3_ResetPattern())

    demoGui.Add("Button", "x250 y80 w230 h30", "Example 4: Sessions")
    .OnEvent("Click", (*) => Example4_SessionManagement())

    demoGui.Add("Button", "x10 y120 w230 h30", "Example 5: Batch")
    .OnEvent("Click", (*) => Example5_BatchProcessing())

    demoGui.Add("Button", "x250 y120 w230 h30", "Example 6: Backup")
    .OnEvent("Click", (*) => Example6_ClearWithBackup())

    demoGui.Add("Button", "x10 y160 w470 h30", "Example 7: Synchronized")
    .OnEvent("Click", (*) => Example7_SynchronizedClear())

    demoGui.Add("Button", "x10 y200 w470 h30", "Run All Examples")
    .OnEvent("Click", RunAll)

    RunAll(*) {
        Example1_BasicClear()
        Example2_ClearVsDelete()
        Example3_ResetPattern()
        Example4_SessionManagement()
        Example5_BatchProcessing()
        Example6_ClearWithBackup()
        Example7_SynchronizedClear()
        MsgBox("All examples completed!", "Finished")
    }

    demoGui.Show("w490 h240")
}

CreateDemoGUI()
