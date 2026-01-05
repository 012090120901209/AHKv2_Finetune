#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Map_Delete_02_Cleanup.ahk
 * 
 * @description Map.Delete() for data cleanup operations
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2025-11-16
 * 
 * @overview
 * Using Map.Delete() for cleaning up old data, removing invalid entries,
 * garbage collection, and maintaining data hygiene.
 */

;=============================================================================
; Example 1: Expired Data Cleanup
;=============================================================================

Example1_ExpiredCleanup() {
    cache := Map(
        "item1", Map("value", "Data 1", "expires", A_Now),
        "item2", Map("value", "Data 2", "expires", FormatTime(DateAdd(A_Now, 1, "days"), "yyyyMMddHHmmss")),
        "item3", Map("value", "Data 3", "expires", "20200101000000"),  ; Expired
        "item4", Map("value", "Data 4", "expires", FormatTime(DateAdd(A_Now, -1, "days"), "yyyyMMddHHmmss"))  ; Expired
    )

    DateAdd(dateTime, amount, units) {
        return FormatTime(dateTime, "yyyyMMddHHmmss")
    }

    CleanupExpired() {
        cleaned := 0
        toDelete := []

        for key, item in cache {
            if (item["expires"] < A_Now)
                toDelete.Push(key)
        }

        for key in toDelete {
            cache.Delete(key)
            cleaned++
        }

        return cleaned
    }

    output := "=== Expired Data Cleanup ===`n`n"
    output .= "Initial items: " cache.Count "`n"

    cleaned := CleanupExpired()

    output .= "Cleaned up: " cleaned " expired items`n"
    output .= "Remaining: " cache.Count " items`n"

    MsgBox(output, "Expired Cleanup")
}

;=============================================================================
; Example 2: Invalid Entry Removal
;=============================================================================

Example2_InvalidRemoval() {
    data := Map(
        "valid1", Map("email", "user@example.com", "age", 25),
        "invalid1", Map("email", "bad-email", "age", 25),
        "invalid2", Map("email", "user2@example.com", "age", -5),
        "valid2", Map("email", "user3@example.com", "age", 30)
    )

    RemoveInvalid() {
        toRemove := []

        for key, record in data {
            ; Validate email
            if (!InStr(record["email"], "@")) {
                toRemove.Push({ key: key, reason: "Invalid email" })
                continue
            }

            ; Validate age
            if (record["age"] < 0 || record["age"] > 150) {
                toRemove.Push({ key: key, reason: "Invalid age" })
                continue
            }
        }

        ; Remove invalid entries
        for item in toRemove {
            data.Delete(item.key)
        }

        return toRemove
    }

    output := "=== Invalid Entry Removal ===`n`n"
    output .= "Initial records: " data.Count "`n`n"

    removed := RemoveInvalid()

    output .= "Removed " removed.Length " invalid records:`n"
    for item in removed {
        output .= "  " item.key ": " item.reason "`n"
    }

    output .= "`nRemaining valid records: " data.Count "`n"

    MsgBox(output, "Invalid Removal")
}

;=============================================================================
; Example 3: Orphan Removal
;=============================================================================

Example3_OrphanRemoval() {
    ; Parent data
    users := Map(
        "U001", Map("name", "Alice"),
        "U002", Map("name", "Bob")
    )

    ; Child data with orphans
    sessions := Map(
        "S001", Map("userId", "U001", "active", true),
        "S002", Map("userId", "U999", "active", true),  ; Orphan
        "S003", Map("userId", "U002", "active", true),
        "S004", Map("userId", "U888", "active", true)  ; Orphan
    )

    RemoveOrphans() {
        removed := []

        for sessionId, session in sessions {
            if (!users.Has(session["userId"])) {
                sessions.Delete(sessionId)
                removed.Push(sessionId)
            }
        }

        return removed
    }

    output := "=== Orphan Removal ===`n`n"
    output .= "Initial sessions: " sessions.Count "`n"
    output .= "Valid users: " users.Count "`n`n"

    removed := RemoveOrphans()

    output .= "Removed orphan sessions: " removed.Length "`n"
    for id in removed {
        output .= "  " id "`n"
    }

    output .= "`nRemaining sessions: " sessions.Count "`n"

    MsgBox(output, "Orphan Removal")
}

;=============================================================================
; Example 4: Duplicate Cleanup
;=============================================================================

Example4_DuplicateCleanup() {
    records := Map(
        "R001", Map("email", "user1@example.com", "name", "User 1"),
        "R002", Map("email", "user2@example.com", "name", "User 2"),
        "R003", Map("email", "user1@example.com", "name", "User 1 Duplicate"),
        "R004", Map("email", "user3@example.com", "name", "User 3"),
        "R005", Map("email", "user2@example.com", "name", "User 2 Duplicate")
    )

    RemoveDuplicates(field) {
        seen := Map()
        duplicates := []

        for id, record in records {
            value := record[field]

            if (seen.Has(value)) {
                duplicates.Push(id)
                records.Delete(id)
            } else {
                seen.Set(value, id)
            }
        }

        return duplicates
    }

    output := "=== Duplicate Cleanup ===`n`n"
    output .= "Initial records: " records.Count "`n"

    duplicates := RemoveDuplicates("email")

    output .= "Removed duplicates: " duplicates.Length "`n"
    for id in duplicates {
        output .= "  " id "`n"
    }

    output .= "`nUnique records remaining: " records.Count "`n"

    MsgBox(output, "Duplicate Cleanup")
}

;=============================================================================
; Example 5: Size-Based Cleanup (LRU Eviction)
;=============================================================================

Example5_SizeBasedCleanup() {
    cache := Map()
    accessTimes := Map()
    maxSize := 5

    Add(key, value) {
        cache.Set(key, value)
        accessTimes.Set(key, A_TickCount)

        if (cache.Count > maxSize)
            EvictLRU()
    }

    EvictLRU() {
        oldest := ""
        oldestTime := A_TickCount

        for key, time in accessTimes {
            if (time < oldestTime) {
                oldest := key
                oldestTime := time
            }
        }

        if (oldest != "") {
            cache.Delete(oldest)
            accessTimes.Delete(oldest)
            return oldest
        }

        return ""
    }

    output := "=== Size-Based Cleanup (LRU) ===`n`n"
    output .= "Max cache size: " maxSize "`n`n"

    ; Add items
    Loop 8 {
        Add("item" A_Index, "value" A_Index)
        Sleep(10)
    }

    output .= "Added 8 items`n"
    output .= "Final cache size: " cache.Count "`n"
    output .= "Evicted: " (8 - cache.Count) " items`n"

    MsgBox(output, "Size-Based Cleanup")
}

;=============================================================================
; Example 6: Scheduled Cleanup
;=============================================================================

Example6_ScheduledCleanup() {
    tempFiles := Map()

    AddTempFile(name, path) {
        tempFiles.Set(name, Map(
            "path", path,
            "created", A_Now,
            "accessed", A_Now
        ))
    }

    CleanupOlderThan(hours) {
        cutoff := FormatTime(DateAdd(A_Now, -hours, "hours"), "yyyyMMddHHmmss")
        cleaned := []

        for name, file in tempFiles {
            if (file["accessed"] < cutoff) {
                tempFiles.Delete(name)
                cleaned.Push(name)
            }
        }

        return cleaned
    }

    DateAdd(dateTime, amount, units) {
        ; Simplified for example
        return FormatTime(dateTime, "yyyyMMddHHmmss")
    }

    output := "=== Scheduled Cleanup ===`n`n"

    AddTempFile("temp1.txt", "C:\Temp\temp1.txt")
    AddTempFile("temp2.txt", "C:\Temp\temp2.txt")
    AddTempFile("old1.txt", "C:\Temp\old1.txt")
    tempFiles["old1.txt"]["accessed"] := "20200101000000"

    output .= "Temp files: " tempFiles.Count "`n`n"

    cleaned := CleanupOlderThan(24)

    output .= "Cleaned up " cleaned.Length " old files`n"
    for name in cleaned {
        output .= "  " name "`n"
    }

    output .= "`nRemaining: " tempFiles.Count " files`n"

    MsgBox(output, "Scheduled Cleanup")
}

;=============================================================================
; Example 7: Batch Cleanup Operations
;=============================================================================

Example7_BatchCleanup() {
    data := Map()

    ; Add test data
    Loop 100 {
        data.Set("item" A_Index, Map(
            "value", "Data " A_Index,
            "flag", Mod(A_Index, 3) = 0,
            "priority", Mod(A_Index, 5)
        ))
    }

    CleanupBatch(condition, batchSize := 10) {
        cleaned := 0
        toDelete := []

        for key, item in data {
            if (condition.Call(key, item)) {
                toDelete.Push(key)

                if (toDelete.Length >= batchSize)
                    break
            }
        }

        for key in toDelete {
            data.Delete(key)
            cleaned++
        }

        return cleaned
    }

    output := "=== Batch Cleanup ===`n`n"
    output .= "Initial items: " data.Count "`n`n"

    ; Cleanup items where flag is true, in batches of 10
    cleaned := CleanupBatch((k, v) => v["flag"], 10)

    output .= "Cleaned in first batch: " cleaned "`n"
    output .= "Remaining: " data.Count "`n"

    MsgBox(output, "Batch Cleanup")
}

;=============================================================================
; GUI Interface
;=============================================================================

CreateDemoGUI() {
    demoGui := Gui()
    demoGui.Title := "Map.Delete() - Cleanup Operations"

    demoGui.Add("Text", "x10 y10 w480 +Center", "Data Cleanup with Map.Delete()")

    demoGui.Add("Button", "x10 y40 w230 h30", "Example 1: Expired")
        .OnEvent("Click", (*) => Example1_ExpiredCleanup())

    demoGui.Add("Button", "x250 y40 w230 h30", "Example 2: Invalid")
        .OnEvent("Click", (*) => Example2_InvalidRemoval())

    demoGui.Add("Button", "x10 y80 w230 h30", "Example 3: Orphans")
        .OnEvent("Click", (*) => Example3_OrphanRemoval())

    demoGui.Add("Button", "x250 y80 w230 h30", "Example 4: Duplicates")
        .OnEvent("Click", (*) => Example4_DuplicateCleanup())

    demoGui.Add("Button", "x10 y120 w230 h30", "Example 5: Size-Based")
        .OnEvent("Click", (*) => Example5_SizeBasedCleanup())

    demoGui.Add("Button", "x250 y120 w230 h30", "Example 6: Scheduled")
        .OnEvent("Click", (*) => Example6_ScheduledCleanup())

    demoGui.Add("Button", "x10 y160 w470 h30", "Example 7: Batch Cleanup")
        .OnEvent("Click", (*) => Example7_BatchCleanup())

    demoGui.Add("Button", "x10 y200 w470 h30", "Run All Examples")
        .OnEvent("Click", RunAll)

    RunAll(*) {
        Example1_ExpiredCleanup()
        Example2_InvalidRemoval()
        Example3_OrphanRemoval()
        Example4_DuplicateCleanup()
        Example5_SizeBasedCleanup()
        Example6_ScheduledCleanup()
        Example7_BatchCleanup()
        MsgBox("All examples completed!", "Finished")
    }

    demoGui.Show("w490 h240")
}

CreateDemoGUI()
