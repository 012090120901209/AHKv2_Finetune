#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Map_Set_04_Batch.ahk
 * 
 * @description Map.Set() for batch and bulk operations
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2025-11-16
 * 
 * @overview
 * Demonstrates using Map.Set() for bulk data operations, batch processing,
 * data imports, bulk updates, and performance optimization techniques.
 */

;=============================================================================
; Example 1: Bulk Data Import from Arrays
;=============================================================================

/**
 * @function Example1_BulkImport
 * @description Import large datasets into Maps efficiently
 */
Example1_BulkImport() {
    ; Sample CSV-like data
    csvData := [
        "ID,Name,Department,Salary",
        "101,John Doe,Engineering,75000",
        "102,Jane Smith,Marketing,68000",
        "103,Bob Johnson,Engineering,82000",
        "104,Alice Williams,HR,65000",
        "105,Charlie Brown,Sales,71000",
        "106,Diana Prince,Engineering,95000",
        "107,Eve Adams,Marketing,73000"
    ]

    employees := Map()

    ; Skip header row, process data rows
    Loop csvData.Length {
        if (A_Index = 1)
            continue

        row := csvData[A_Index]
        fields := StrSplit(row, ",")

        ; Create employee record
        employees.Set(fields[1], Map(
            "name", fields[2],
            "department", fields[3],
            "salary", Integer(fields[4])
        ))
    }

    ; Display results
    output := "=== Bulk Import Example ===`n`n"
    output .= "Imported " employees.Count " employees`n`n"

    ; Group by department
    deptMap := Map()
    for id, emp in employees {
        dept := emp["department"]
        if (!deptMap.Has(dept))
            deptMap.Set(dept, [])
        deptMap[dept].Push(emp["name"])
    }

    output .= "By Department:`n"
    for dept, names in deptMap {
        output .= "  " dept ": " names.Length " employees`n"
    }

    MsgBox(output, "Bulk Import")
}

;=============================================================================
; Example 2: Batch Update Operations
;=============================================================================

/**
 * @class BatchUpdater
 * @description Efficient batch update operations
 */
class BatchUpdater {
    data := Map()
    pendingUpdates := []
    updateCount := 0

    /**
     * @method Initialize
     * @description Initialize with sample data
     */
    Initialize() {
        ; Create initial dataset
        Loop 100 {
            this.data.Set("record" A_Index, Map(
                "id", A_Index,
                "value", Random(1, 1000),
                "status", "active",
                "version", 1
            ))
        }
    }

    /**
     * @method QueueUpdate
     * @description Queue an update for batch processing
     */
    QueueUpdate(key, field, value) {
        this.pendingUpdates.Push(Map(
            "key", key,
            "field", field,
            "value", value
        ))
    }

    /**
     * @method ExecuteBatch
     * @description Execute all queued updates at once
     * @returns {Integer} Number of updates applied
     */
    ExecuteBatch() {
        count := 0

        for update in this.pendingUpdates {
            if (this.data.Has(update["key"])) {
                record := this.data[update["key"]]
                record.Set(update["field"], update["value"])
                record["version"]++
                count++
            }
        }

        this.pendingUpdates := []
        this.updateCount += count

        return count
    }

    /**
     * @method GetStats
     * @description Get statistics about data and updates
     */
    GetStats() {
        return "Total records: " this.data.Count
            . "`nPending updates: " this.pendingUpdates.Length
            . "`nTotal updates applied: " this.updateCount
    }
}

Random(min, max) {
    return mod(A_TickCount * A_Index, (max - min + 1)) + min
}

Example2_BatchUpdate() {
    updater := BatchUpdater()
    updater.Initialize()

    output := "=== Batch Update Example ===`n`n"
    output .= "Initial state:`n" updater.GetStats() "`n`n"

    ; Queue multiple updates
    Loop 10 {
        updater.QueueUpdate("record" A_Index, "status", "updated")
        updater.QueueUpdate("record" A_Index, "value", Random(2000, 3000))
    }

    output .= "After queueing 20 updates:`n" updater.GetStats() "`n`n"

    ; Execute batch
    applied := updater.ExecuteBatch()

    output .= "After executing batch:`n"
    output .= "Updates applied: " applied "`n"
    output .= updater.GetStats()

    MsgBox(output, "Batch Update")
}

;=============================================================================
; Example 3: Bulk Data Transformation
;=============================================================================

/**
 * @class DataTransformer
 * @description Transform data in bulk operations
 */
class DataTransformer {
    /**
     * @method TransformArray
     * @description Transform array of objects to indexed Map
     */
    static TransformArray(arr, keyField) {
        result := Map()

        for item in arr {
            if (IsObject(item) && item.HasProp(keyField)) {
                key := item.%keyField%
                result.Set(key, item)
            }
        }

        return result
    }

    /**
     * @method MergeData
     * @description Merge two Maps with conflict resolution
     */
    static MergeData(target, source, onConflict := "overwrite") {
        for key, value in source {
            if (!target.Has(key)) {
                target.Set(key, value)
            } else {
                ; Handle conflict
                switch onConflict {
                    case "overwrite":
                        target.Set(key, value)
                    case "skip":
                        ; Keep existing value
                        continue
                    case "merge":
                        ; Merge if both are Maps
                        if (IsObject(target[key]) && IsObject(value)) {
                            this.MergeData(target[key], value, onConflict)
                        }
                }
            }
        }

        return target
    }

    /**
     * @method FilterAndTransform
     * @description Filter and transform data in one pass
     */
    static FilterAndTransform(source, filterFunc, transformFunc) {
        result := Map()

        for key, value in source {
            if (filterFunc.Call(key, value)) {
                newValue := transformFunc.Call(key, value)
                result.Set(key, newValue)
            }
        }

        return result
    }
}

Example3_DataTransformation() {
    ; Sample data
    products := [{
        sku: "PROD001", name: "Laptop", price: 999, stock: 50 }, {
            sku: "PROD002", name: "Mouse", price: 29, stock: 200 }, {
                sku: "PROD003", name: "Keyboard", price: 79, stock: 150 }, {
                    sku: "PROD004", name: "Monitor", price: 299, stock: 75
                }
    ]

    output := "=== Data Transformation Example ===`n`n"

    ; Transform array to Map indexed by SKU
    productMap := DataTransformer.TransformArray(products, "sku")
    output .= "Transformed " productMap.Count " products to Map`n`n"

    ; Create updates Map
    updates := Map()
    updates.Set("PROD001", { price: 899, stock: 45 })  ; Price reduction
    updates.Set("PROD002", { stock: 180 })              ; Stock update
    updates.Set("PROD005", { name: "Headphones", price: 149, stock: 100 })  ; New product

    ; Merge updates
    DataTransformer.MergeData(productMap, updates, "overwrite")

    output .= "After merging updates:`n"
    for sku, product in productMap {
        output .= "  " sku ": " product.name " - $" product.price " (" product.stock " in stock)`n"
    }

    ; Filter high-value items and apply discount
    highValue := DataTransformer.FilterAndTransform(
        productMap,
        (key, prod) => prod.price > 100,
        (key, prod) => Map("name", prod.name, "price", Round(prod.price * 0.9, 2), "stock", prod.stock)
    )

    output .= "`nHigh-value items with 10% discount:`n"
    for sku, product in highValue {
        output .= "  " product["name"] ": $" product["price"] "`n"
    }

    MsgBox(output, "Data Transformation")
}

;=============================================================================
; Example 4: Parallel Batch Processing Simulation
;=============================================================================

/**
 * @class BatchProcessor
 * @description Process data in batches for better performance
 */
class BatchProcessor {
    batchSize := 10
    processed := Map()
    totalProcessed := 0

    /**
     * @method ProcessBatch
     * @description Process data in batches
     */
    ProcessBatch(data, processingFunc) {
        batch := []
        results := Map()

        for key, value in data {
            batch.Push({ key: key, value: value })

            ; Process when batch is full
            if (batch.Length >= this.batchSize) {
                this.ExecuteBatch(batch, processingFunc, results)
                batch := []
            }
        }

        ; Process remaining items
        if (batch.Length > 0) {
            this.ExecuteBatch(batch, processingFunc, results)
        }

        return results
    }

    /**
     * @method ExecuteBatch
     * @description Execute processing on a batch
     */
    ExecuteBatch(batch, processingFunc, results) {
        for item in batch {
            processed := processingFunc.Call(item["value"])
            results.Set(item["key"], processed)
            this.totalProcessed++
        }
    }

    /**
     * @method GetStats
     * @description Get processing statistics
     */
    GetStats() {
        return "Total items processed: " this.totalProcessed
            . "`nBatch size: " this.batchSize
            . "`nNumber of batches: " Ceil(this.totalProcessed / this.batchSize)
    }
}

Ceil(num) {
    return (Mod(num, 1) = 0) ? num : Integer(num) + 1
}

Example4_BatchProcessing() {
    ; Create test data
    testData := Map()
    Loop 45 {
        testData.Set("item" A_Index, Random(1, 100))
    }

    processor := BatchProcessor()

    ; Process: multiply by 2 and add 10
    processingFunc := (value) => (value * 2 + 10)

    output := "=== Batch Processing Example ===`n`n"
    output .= "Processing " testData.Count " items in batches of " processor.batchSize "`n`n"

    startTime := A_TickCount
    results := processor.ProcessBatch(testData, processingFunc)
    elapsed := A_TickCount - startTime

    output .= "Processing completed in " elapsed "ms`n"
    output .= processor.GetStats() "`n`n"

    output .= "Sample results (first 5):`n"
    count := 0
    for key, value in results {
        output .= "  " key ": " value "`n"
        count++
        if (count >= 5)
            break
    }

    MsgBox(output, "Batch Processing")
}

;=============================================================================
; Example 5: Bulk Operations with Transactions
;=============================================================================

/**
 * @class TransactionalBatch
 * @description Batch operations with rollback support
 */
class TransactionalBatch {
    data := Map()
    snapshot := Map()
    inTransaction := false

    /**
     * @method BeginTransaction
     * @description Start a transaction (create snapshot)
     */
    BeginTransaction() {
        this.snapshot := Map()

        ; Create deep copy
        for key, value in this.data {
            this.snapshot.Set(key, value)
        }

        this.inTransaction := true
    }

    /**
     * @method Commit
     * @description Commit transaction (clear snapshot)
     */
    Commit() {
        this.snapshot := Map()
        this.inTransaction := false
        return true
    }

    /**
     * @method Rollback
     * @description Rollback to snapshot
     */
    Rollback() {
        if (!this.inTransaction)
            return false

        ; Restore from snapshot
        this.data := Map()
        for key, value in this.snapshot {
            this.data.Set(key, value)
        }

        this.snapshot := Map()
        this.inTransaction := false
        return true
    }

    /**
     * @method BulkSet
     * @description Set multiple key-value pairs
     */
    BulkSet(updates) {
        for key, value in updates {
            this.data.Set(key, value)
        }
    }

    /**
     * @method GetAll
     * @description Get all data
     */
    GetAll() {
        return this.data
    }
}

Example5_TransactionalBatch() {
    batch := TransactionalBatch()

    ; Initial data
    initial := Map("key1", "value1", "key2", "value2", "key3", "value3")
    batch.BulkSet(initial)

    output := "=== Transactional Batch Example ===`n`n"
    output .= "Initial data: " batch.data.Count " entries`n`n"

    ; Start transaction
    batch.BeginTransaction()
    output .= "Transaction started`n`n"

    ; Make changes
    updates := Map("key2", "updated2", "key4", "value4", "key5", "value5")
    batch.BulkSet(updates)

    output .= "After updates: " batch.data.Count " entries`n"
    output .= "Snapshot has: " batch.snapshot.Count " entries`n`n"

    ; Rollback
    batch.Rollback()
    output .= "Transaction rolled back`n"
    output .= "Current data: " batch.data.Count " entries`n`n"

    ; Try again with commit
    batch.BeginTransaction()
    batch.BulkSet(updates)
    batch.Commit()

    output .= "New transaction committed`n"
    output .= "Final data count: " batch.data.Count " entries"

    MsgBox(output, "Transactional Batch")
}

;=============================================================================
; Example 6: Bulk Import with Validation
;=============================================================================

/**
 * @class ValidatedBulkImporter
 * @description Import data with validation and error handling
 */
class ValidatedBulkImporter {
    data := Map()
    errors := []
    successCount := 0
    errorCount := 0

    /**
     * @method ImportBatch
     * @description Import batch with validation
     */
    ImportBatch(records, validationFunc) {
        this.errors := []
        this.successCount := 0
        this.errorCount := 0

        for record in records {
            result := validationFunc.Call(record)

            if (result.valid) {
                this.data.Set(record.id, record)
                this.successCount++
            } else {
                this.errors.Push(Map(
                    "record", record,
                    "error", result.error
                ))
                this.errorCount++
            }
        }
    }

    /**
     * @method GetReport
     * @description Get import report
     */
    GetReport() {
        output := "=== Import Report ===`n`n"
        output .= "Successfully imported: " this.successCount "`n"
        output .= "Errors: " this.errorCount "`n`n"

        if (this.errors.Length > 0) {
            output .= "Error details:`n"
            for err in this.errors {
                output .= "  ID " err["record"].id ": " err["error"] "`n"
            }
        }

        return output
    }
}

Example6_ValidatedImport() {
    importer := ValidatedBulkImporter()

    ; Sample records with some invalid data
    records := [{
        id: 1, name: "John", age: 30, email: "john@example.com" }, {
            id: 2, name: "Jane", age: -5, email: "jane@example.com" },  ; Invalid age
        {
            id: 3, name: "", age: 25, email: "bob@example.com" },        ; Missing name
        {
            id: 4, name: "Alice", age: 28, email: "invalid-email" },     ; Invalid email
        {
            id: 5, name: "Charlie", age: 35, email: "charlie@example.com"
        }
    ]

    ; Validation function
    validateRecord := (record) {
        if (!record.HasProp("name") || record.name = "")
            return { valid: false, error: "Name is required" }

        if (!record.HasProp("age") || record.age < 0 || record.age > 120)
            return { valid: false, error: "Invalid age" }

        if (!record.HasProp("email") || !InStr(record.email, "@"))
            return { valid: false, error: "Invalid email" }

        return { valid: true }
    }

    ; Import with validation
    importer.ImportBatch(records, validateRecord)

    MsgBox(importer.GetReport(), "Validated Import")
}

;=============================================================================
; Example 7: Performance-Optimized Bulk Loading
;=============================================================================

/**
 * @class BulkLoader
 * @description Optimized bulk data loading
 */
class BulkLoader {
    /**
     * @method LoadFromArray
     * @description Efficiently load from array
     */
    static LoadFromArray(arr) {
        result := Map()
        result.Capacity := arr.Length  ; Pre-allocate if possible

        for item in arr {
            if (IsObject(item) && item.HasProp("id")) {
                result.Set(item.id, item)
            }
        }

        return result
    }

    /**
     * @method LoadFromKeyValuePairs
     * @description Load from alternating key-value array
     */
    static LoadFromKeyValuePairs(kvArray) {
        result := Map()

        i := 1
        while (i < kvArray.Length) {
            result.Set(kvArray[i], kvArray[i + 1])
            i += 2
        }

        return result
    }

    /**
     * @method BulkCopy
     * @description Copy all entries from one Map to another
     */
    static BulkCopy(source, target) {
        for key, value in source {
            target.Set(key, value)
        }
        return target
    }
}

Example7_OptimizedLoading() {
    output := "=== Optimized Bulk Loading ===`n`n"

    ; Test 1: Load from object array
    startTime := A_TickCount
    objArray := []
    Loop 1000 {
        objArray.Push({ id: "ID" A_Index, value: Random(1, 1000) })
    }
    loadTime := A_TickCount - startTime

    startTime := A_TickCount
    map1 := BulkLoader.LoadFromArray(objArray)
    mapTime := A_TickCount - startTime

    output .= "Array creation: " loadTime "ms`n"
    output .= "Map loading: " mapTime "ms`n"
    output .= "Loaded: " map1.Count " entries`n`n"

    ; Test 2: Load from key-value pairs
    kvPairs := []
    Loop 100 {
        kvPairs.Push("key" A_Index)
        kvPairs.Push("value" A_Index)
    }

    startTime := A_TickCount
    map2 := BulkLoader.LoadFromKeyValuePairs(kvPairs)
    elapsed := A_TickCount - startTime

    output .= "Key-value pair loading: " elapsed "ms`n"
    output .= "Loaded: " map2.Count " entries`n`n"

    ; Test 3: Bulk copy
    startTime := A_TickCount
    map3 := Map()
    BulkLoader.BulkCopy(map1, map3)
    elapsed := A_TickCount - startTime

    output .= "Bulk copy: " elapsed "ms`n"
    output .= "Copied: " map3.Count " entries"

    MsgBox(output, "Optimized Loading")
}

;=============================================================================
; GUI Interface
;=============================================================================

CreateDemoGUI() {
    demoGui := Gui()
    demoGui.Title := "Map.Set() - Batch Operations Examples"

    demoGui.Add("Text", "x10 y10 w480 +Center", "Batch and Bulk Operations with Map.Set()")

    demoGui.Add("Button", "x10 y40 w230 h30", "Example 1: Bulk Import")
        .OnEvent("Click", (*) => Example1_BulkImport())

    demoGui.Add("Button", "x250 y40 w230 h30", "Example 2: Batch Update")
        .OnEvent("Click", (*) => Example2_BatchUpdate())

    demoGui.Add("Button", "x10 y80 w230 h30", "Example 3: Data Transform")
        .OnEvent("Click", (*) => Example3_DataTransformation())

    demoGui.Add("Button", "x250 y80 w230 h30", "Example 4: Batch Process")
        .OnEvent("Click", (*) => Example4_BatchProcessing())

    demoGui.Add("Button", "x10 y120 w230 h30", "Example 5: Transactions")
        .OnEvent("Click", (*) => Example5_TransactionalBatch())

    demoGui.Add("Button", "x250 y120 w230 h30", "Example 6: Validated Import")
        .OnEvent("Click", (*) => Example6_ValidatedImport())

    demoGui.Add("Button", "x10 y160 w470 h30", "Example 7: Optimized Loading")
        .OnEvent("Click", (*) => Example7_OptimizedLoading())

    demoGui.Add("Button", "x10 y200 w470 h30", "Run All Examples")
        .OnEvent("Click", RunAll)

    RunAll(*) {
        Example1_BulkImport()
        Example2_BatchUpdate()
        Example3_DataTransformation()
        Example4_BatchProcessing()
        Example5_TransactionalBatch()
        Example6_ValidatedImport()
        Example7_OptimizedLoading()
        MsgBox("All batch operation examples completed!", "Finished")
    }

    demoGui.Show("w490 h240")
}

CreateDemoGUI()
