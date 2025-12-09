#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* BuiltIn_Map_Delete_01_BasicUsage.ahk
*
* @description Comprehensive examples of Map.Delete() method for basic usage
* @author AutoHotkey v2 Examples Collection
* @version 1.0.0
* @date 2025-11-16
*
* @overview
* The Map.Delete() method removes a key-value pair from a Map.
* Syntax: MapObject.Delete(Key)
* Returns: The value that was removed, or empty string if key didn't exist
*
* Key Features:
* - Remove specific keys
* - Return deleted values
* - Safe deletion (no error if key doesn't exist)
* - Reduce map size
*/

;=============================================================================
; Example 1: Basic Delete Operations
;=============================================================================

Example1_BasicDelete() {
    data := Map(
    "key1", "value1",
    "key2", "value2",
    "key3", "value3",
    "key4", "value4"
    )

    output := "=== Basic Delete Example ===`n`n"
    output .= "Initial count: " data.Count "`n`n"

    ; Delete existing key
    deleted := data.Delete("key2")
    output .= "Deleted 'key2': " deleted "`n"
    output .= "Count after delete: " data.Count "`n`n"

    ; Try to delete non-existent key
    deleted := data.Delete("key99")
    output .= "Deleted 'key99': '" deleted "' (doesn't exist)`n`n"

    ; Delete multiple keys
    data.Delete("key1")
    data.Delete("key3")
    output .= "After deleting key1 and key3:`n"
    output .= "Remaining count: " data.Count "`n"

    MsgBox(output, "Basic Delete")
}

;=============================================================================
; Example 2: Conditional Deletion
;=============================================================================

Example2_ConditionalDelete() {
    inventory := Map(
    "item1", Map("name", "Laptop", "stock", 0),
    "item2", Map("name", "Mouse", "stock", 50),
    "item3", Map("name", "Keyboard", "stock", 0),
    "item4", Map("name", "Monitor", "stock", 25)
    )

    ; Remove items with zero stock
    toDelete := []
    for id, item in inventory {
        if (item["stock"] = 0)
        toDelete.Push(id)
    }

    output := "=== Conditional Delete ===`n`n"
    output .= "Initial items: " inventory.Count "`n"
    output .= "Items to delete: " toDelete.Length "`n`n"

    for id in toDelete {
        deleted := inventory.Delete(id)
        output .= "Removed " id ": " deleted["name"] "`n"
    }

    output .= "`nRemaining items: " inventory.Count "`n"
    for id, item in inventory {
        output .= "  " id ": " item["name"] " (stock: " item["stock"] ")`n"
    }

    MsgBox(output, "Conditional Delete")
}

;=============================================================================
; Example 3: Delete and Return Pattern
;=============================================================================

Example3_DeleteAndReturn() {
    queue := Map(
    1, "Task A",
    2, "Task B",
    3, "Task C",
    4, "Task D"
    )

    ProcessAndRemove(key) {
        if (queue.Has(key)) {
            task := queue.Delete(key)
            return "Processed: " task
        }
        return "Task not found"
    }

    output := "=== Delete and Return ===`n`n"
    output .= "Initial queue size: " queue.Count "`n`n"

    output .= ProcessAndRemove(1) "`n"
    output .= ProcessAndRemove(3) "`n"
    output .= ProcessAndRemove(5) "`n"

    output .= "`nRemaining tasks: " queue.Count "`n"
    for id, task in queue {
        output .= "  " id ": " task "`n"
    }

    MsgBox(output, "Delete and Return")
}

;=============================================================================
; Example 4: Batch Deletion
;=============================================================================

Example4_BatchDelete() {
    data := Map()
    Loop 20 {
        data.Set("key" A_Index, "value" A_Index)
    }

    DeleteMultiple(mapObj, keys) {
        deleted := []
        failed := []

        for key in keys {
            value := mapObj.Delete(key)
            if (value != "")
            deleted.Push(key)
            else
            failed.Push(key)
        }

        return {deleted: deleted, failed: failed}
    }

    toDelete := ["key5", "key10", "key15", "key99", "key20"]

    output := "=== Batch Deletion ===`n`n"
    output .= "Initial count: " data.Count "`n"

    result := DeleteMultiple(data, toDelete)

    output .= "Deleted: " result.deleted.Length " keys`n"
    output .= "Failed: " result.failed.Length " keys`n"
    output .= "Final count: " data.Count "`n"

    MsgBox(output, "Batch Deletion")
}

;=============================================================================
; Example 5: Temporary Data Pattern
;=============================================================================

Example5_TemporaryData() {
    tempData := Map()

    StoreTemporary(key, value, lifetime := 3000) {
        tempData.Set(key, Map("value", value, "expires", A_TickCount + lifetime))
        return key
    }

    GetTemporary(key) {
        if (!tempData.Has(key))
        return ""

        item := tempData[key]
        if (A_TickCount > item["expires"]) {
            tempData.Delete(key)
            return ""
        }

        return item["value"]
    }

    CleanupExpired() {
        toDelete := []
        for key, item in tempData {
            if (A_TickCount > item["expires"])
            toDelete.Push(key)
        }

        for key in toDelete {
            tempData.Delete(key)
        }

        return toDelete.Length
    }

    output := "=== Temporary Data ===`n`n"

    StoreTemporary("session1", "User data 1")
    StoreTemporary("session2", "User data 2")
    StoreTemporary("expired", "Old data", -1000)  ; Already expired

    output .= "Stored " tempData.Count " items`n"

    cleaned := CleanupExpired()
    output .= "Cleaned up " cleaned " expired items`n"
    output .= "Remaining: " tempData.Count " items`n"

    MsgBox(output, "Temporary Data")
}

;=============================================================================
; Example 6: Undo/Redo with Delete
;=============================================================================

Example6_UndoDelete() {
    data := Map("key1", "value1", "key2", "value2", "key3", "value3")
    deletedHistory := []

    DeleteWithUndo(key) {
        if (data.Has(key)) {
            value := data.Delete(key)
            deletedHistory.Push(Map("key", key, "value", value))
            return "Deleted: " key
        }
        return "Key not found"
    }

    UndoDelete() {
        if (deletedHistory.Length = 0)
        return "Nothing to undo"

        lastDeleted := deletedHistory.Pop()
        data.Set(lastDeleted["key"], lastDeleted["value"])
        return "Restored: " lastDeleted["key"]
    }

    output := "=== Undo Delete ===`n`n"

    output .= DeleteWithUndo("key1") "`n"
    output .= DeleteWithUndo("key2") "`n"
    output .= "Count: " data.Count "`n`n"

    output .= UndoDelete() "`n"
    output .= "Count: " data.Count "`n`n"

    output .= UndoDelete() "`n"
    output .= "Count: " data.Count "`n"

    MsgBox(output, "Undo Delete")
}

;=============================================================================
; Example 7: Soft Delete Pattern
;=============================================================================

Example7_SoftDelete() {
    records := Map(
    "R001", Map("name", "Record 1", "deleted", false),
    "R002", Map("name", "Record 2", "deleted", false),
    "R003", Map("name", "Record 3", "deleted", false)
    )

    SoftDelete(id) {
        if (records.Has(id)) {
            records[id]["deleted"] := true
            records[id]["deletedAt"] := A_Now
            return true
        }
        return false
    }

    HardDelete(id) {
        return records.Delete(id) != ""
    }

    GetActive() {
        active := []
        for id, record in records {
            if (!record["deleted"])
            active.Push(id)
        }
        return active
    }

    CleanupDeleted() {
        toRemove := []
        for id, record in records {
            if (record["deleted"])
            toRemove.Push(id)
        }

        for id in toRemove {
            records.Delete(id)
        }

        return toRemove.Length
    }

    output := "=== Soft Delete ===`n`n"

    SoftDelete("R001")
    SoftDelete("R002")

    output .= "Total records: " records.Count "`n"
    output .= "Active records: " GetActive().Length "`n`n"

    cleaned := CleanupDeleted()
    output .= "Hard deleted: " cleaned " records`n"
    output .= "Remaining: " records.Count " records`n"

    MsgBox(output, "Soft Delete")
}

;=============================================================================
; GUI Interface
;=============================================================================

CreateDemoGUI() {
    demoGui := Gui()
    demoGui.Title := "Map.Delete() - Basic Usage Examples"

    demoGui.Add("Text", "x10 y10 w480 +Center", "Delete Operations with Map.Delete()")

    demoGui.Add("Button", "x10 y40 w230 h30", "Example 1: Basic Delete")
    .OnEvent("Click", (*) => Example1_BasicDelete())

    demoGui.Add("Button", "x250 y40 w230 h30", "Example 2: Conditional")
    .OnEvent("Click", (*) => Example2_ConditionalDelete())

    demoGui.Add("Button", "x10 y80 w230 h30", "Example 3: Delete & Return")
    .OnEvent("Click", (*) => Example3_DeleteAndReturn())

    demoGui.Add("Button", "x250 y80 w230 h30", "Example 4: Batch Delete")
    .OnEvent("Click", (*) => Example4_BatchDelete())

    demoGui.Add("Button", "x10 y120 w230 h30", "Example 5: Temporary")
    .OnEvent("Click", (*) => Example5_TemporaryData())

    demoGui.Add("Button", "x250 y120 w230 h30", "Example 6: Undo")
    .OnEvent("Click", (*) => Example6_UndoDelete())

    demoGui.Add("Button", "x10 y160 w470 h30", "Example 7: Soft Delete")
    .OnEvent("Click", (*) => Example7_SoftDelete())

    demoGui.Add("Button", "x10 y200 w470 h30", "Run All Examples")
    .OnEvent("Click", RunAll)

    RunAll(*) {
        Example1_BasicDelete()
        Example2_ConditionalDelete()
        Example3_DeleteAndReturn()
        Example4_BatchDelete()
        Example5_TemporaryData()
        Example6_UndoDelete()
        Example7_SoftDelete()
        MsgBox("All examples completed!", "Finished")
    }

    demoGui.Show("w490 h240")
}

CreateDemoGUI()
