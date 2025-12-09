#Requires AutoHotkey v2.0

/**
* BuiltIn_ListView_09_Virtualization.ahk
*
* DESCRIPTION:
* Demonstrates techniques for handling large datasets in ListView controls including
* pagination, lazy loading, progressive loading, and performance optimization.
*
* FEATURES:
* - Pagination for large datasets
* - Lazy loading techniques
* - Progressive/chunked loading
* - Performance optimization with -Redraw
* - Memory management strategies
* - Virtual scrolling concepts
* - Batch operations on large data
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/ListView.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - -Redraw option for performance
* - Efficient bulk loading
* - Timer-based progressive loading
* - Memory-conscious data handling
* - SetTimer for async operations
*
* LEARNING POINTS:
* 1. ListView can slow down with 10,000+ items
* 2. Use -Redraw during bulk operations
* 3. Pagination improves UX for large datasets
* 4. Progressive loading prevents UI freezing
* 5. Consider virtual scrolling for huge datasets
* 6. Keep only visible data in memory when possible
* 7. Batch operations for better performance
*/

; ============================================================================
; EXAMPLE 1: Pagination Pattern
; ============================================================================
Example1_Pagination() {
    ; Large dataset simulation (10,000 records)
    global AllData := []
    Loop 10000 {
        AllData.Push({
            id: A_Index,
            name: "Record " A_Index,
            value: Random(1, 1000),
            status: (Mod(A_Index, 3) = 0) ? "Active" : "Inactive"
        })
    }

    ; Pagination state
    global PageSize := 100
    global CurrentPage := 1
    global TotalPages := Ceil(AllData.Length / PageSize)

    MyGui := Gui("+Resize", "Example 1: Pagination (10,000 records)")

    LV := MyGui.Add("ListView", "r15 w750", ["ID", "Name", "Value", "Status"])

    ; Pagination controls
    MyGui.Add("Text", "w750", "Pagination Controls:")
    firstBtn := MyGui.Add("Button", "w100", "First")
    prevBtn := MyGui.Add("Button", "w100", "Previous")
    pageText := MyGui.Add("Text", "w200 Center", "")
    nextBtn := MyGui.Add("Button", "w100", "Next")
    lastBtn := MyGui.Add("Button", "w100", "Last")

    ; Page size selector
    MyGui.Add("Text", "w100", "Items per page:")
    pageSizeDD := MyGui.Add("DropDownList", "w100", ["50", "100", "200", "500"])
    pageSizeDD.Choose(2)  ; Default to 100
    pageSizeDD.OnEvent("Change", ChangePageSize)

    statusText := MyGui.Add("Text", "w750", "")

    ; Load page
    LoadPage(pageNum) {
        global CurrentPage := pageNum

        ; Calculate range
        startIdx := (pageNum - 1) * PageSize + 1
        endIdx := Min(pageNum * PageSize, AllData.Length)

        ; Disable redraw for performance
        LV.Opt("-Redraw")
        LV.Delete()

        ; Load only current page data
        Loop endIdx - startIdx + 1 {
            idx := startIdx + A_Index - 1
            record := AllData[idx]
            LV.Add(, record.id, record.name, record.value, record.status)
        }

        LV.Opt("+Redraw")
        LV.ModifyCol()

        ; Update UI
        pageText.Value := "Page " pageNum " of " TotalPages
        statusText.Value := "Showing records " startIdx "-" endIdx " of " AllData.Length

        ; Enable/disable buttons
        firstBtn.Enabled := (pageNum > 1)
        prevBtn.Enabled := (pageNum > 1)
        nextBtn.Enabled := (pageNum < TotalPages)
        lastBtn.Enabled := (pageNum < TotalPages)
    }

    ChangePageSize(*) {
        PageSize := Number(pageSizeDD.Text)
        TotalPages := Ceil(AllData.Length / PageSize)
        CurrentPage := 1
        LoadPage(1)
    }

    ; Button handlers
    firstBtn.OnEvent("Click", (*) => LoadPage(1))
    prevBtn.OnEvent("Click", (*) => LoadPage(Max(1, CurrentPage - 1)))
    nextBtn.OnEvent("Click", (*) => LoadPage(Min(TotalPages, CurrentPage + 1)))
    lastBtn.OnEvent("Click", (*) => LoadPage(TotalPages))

    ; Initial load
    LoadPage(1)

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 2: Progressive Loading
; ============================================================================
Example2_ProgressiveLoading() {
    ; Simulate large dataset
    global BigData := []
    Loop 5000 {
        BigData.Push({
            id: A_Index,
            item: "Item " Format("{:04}", A_Index),
            category: ["Electronics", "Furniture", "Clothing"][Mod(A_Index, 3) + 1],
            price: Random(10, 1000)
        })
    }

    global LoadedCount := 0
    global ChunkSize := 100

    MyGui := Gui("+Resize", "Example 2: Progressive Loading")

    LV := MyGui.Add("ListView", "r15 w700", ["ID", "Item", "Category", "Price"])

    progressBar := MyGui.Add("Progress", "w700 h20", 0)
    statusText := MyGui.Add("Text", "w700", "Ready to load...")

    MyGui.Add("Button", "w200", "Start Progressive Load").OnEvent("Click", StartLoading)
    MyGui.Add("Button", "w200", "Load All at Once").OnEvent("Click", LoadAllAtOnce)
    MyGui.Add("Button", "w200", "Clear").OnEvent("Click", ClearList)

    StartLoading(*) {
        global LoadedCount := 0
        LV.Delete()
        progressBar.Value := 0
        statusText.Value := "Loading..."

        ; Disable redraw during entire process
        LV.Opt("-Redraw")

        ; Load in chunks using timer
        LoadNextChunk()
    }

    LoadNextChunk() {
        if LoadedCount >= BigData.Length {
            ; Finished loading
            LV.Opt("+Redraw")
            LV.ModifyCol()
            statusText.Value := "Loading complete! " BigData.Length " records loaded."
            progressBar.Value := 100
            return
        }

        ; Load next chunk
        endIdx := Min(LoadedCount + ChunkSize, BigData.Length)

        Loop endIdx - LoadedCount {
            idx := LoadedCount + A_Index
            record := BigData[idx]
            LV.Add(, record.id, record.item, record.category, Format("${:.2f}", record.price))
        }

        LoadedCount := endIdx

        ; Update progress
        progress := Round((LoadedCount / BigData.Length) * 100)
        progressBar.Value := progress
        statusText.Value := "Loading... " LoadedCount " / " BigData.Length " (" progress "%)"

        ; Schedule next chunk (gives UI time to update)
        SetTimer(LoadNextChunk, -50)
    }

    LoadAllAtOnce(*) {
        startTime := A_TickCount
        statusText.Value := "Loading all at once..."

        LV.Opt("-Redraw")
        LV.Delete()

        for record in BigData {
            LV.Add(, record.id, record.item, record.category, Format("${:.2f}", record.price))
        }

        LV.Opt("+Redraw")
        LV.ModifyCol()

        elapsed := A_TickCount - startTime
        statusText.Value := "Loaded " BigData.Length " records in " elapsed " ms (all at once)"
        progressBar.Value := 100
    }

    ClearList(*) {
        LV.Delete()
        LoadedCount := 0
        progressBar.Value := 0
        statusText.Value := "Cleared"
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 3: On-Demand Loading
; ============================================================================
Example3_OnDemandLoading() {
    ; Simulate database with 20,000 records
    global TotalRecords := 20000
    global LoadedRecords := 0
    global BatchSize := 500

    ; Function to simulate fetching data from database
    FetchBatch(startIdx, count) {
        batch := []
        Loop count {
            idx := startIdx + A_Index - 1
            if idx > TotalRecords
            break

            batch.Push({
                id: idx,
                code: Format("CODE{:05}", idx),
                description: "Description for item " idx,
                amount: Random(100, 10000) / 100
            })
        }
        return batch
    }

    MyGui := Gui("+Resize", "Example 3: On-Demand Loading")

    LV := MyGui.Add("ListView", "r15 w750", ["ID", "Code", "Description", "Amount"])

    infoText := MyGui.Add("Text", "w750", "Click 'Load More' to fetch data in batches")
    statusText := MyGui.Add("Text", "w750", "0 / " TotalRecords " records loaded")

    MyGui.Add("Button", "w200", "Load More (500)").OnEvent("Click", LoadMore)
    MyGui.Add("Button", "w200", "Load Remaining").OnEvent("Click", LoadRemaining)
    MyGui.Add("Button", "w200", "Clear All").OnEvent("Click", ClearAll)

    LoadMore(*) {
        if LoadedRecords >= TotalRecords {
            MsgBox("All records already loaded!")
            return
        }

        startTime := A_TickCount

        ; Fetch next batch
        batch := FetchBatch(LoadedRecords + 1, BatchSize)

        if batch.Length = 0 {
            MsgBox("No more records to load!")
            return
        }

        ; Add to ListView
        LV.Opt("-Redraw")

        for record in batch {
            LV.Add(, record.id, record.code, record.description, Format("${:.2f}", record.amount))
        }

        LV.Opt("+Redraw")
        LV.ModifyCol()

        LoadedRecords += batch.Length
        elapsed := A_TickCount - startTime

        statusText.Value := LoadedRecords " / " TotalRecords " records loaded (batch loaded in " elapsed " ms)"
        infoText.Value := "Click 'Load More' to load next " BatchSize " records"
    }

    LoadRemaining(*) {
        if LoadedRecords >= TotalRecords {
            MsgBox("All records already loaded!")
            return
        }

        remaining := TotalRecords - LoadedRecords
        result := MsgBox("Load remaining " remaining " records?`nThis may take a moment.", "Confirm", "YesNo")

        if result = "No"
        return

        startTime := A_TickCount

        ; Load all remaining
        batch := FetchBatch(LoadedRecords + 1, remaining)

        LV.Opt("-Redraw")

        for record in batch {
            LV.Add(, record.id, record.code, record.description, Format("${:.2f}", record.amount))
        }

        LV.Opt("+Redraw")
        LV.ModifyCol()

        LoadedRecords += batch.Length
        elapsed := A_TickCount - startTime

        statusText.Value := "All " TotalRecords " records loaded in " elapsed " ms"
        infoText.Value := "All records loaded!"
    }

    ClearAll(*) {
        LV.Delete()
        LoadedRecords := 0
        statusText.Value := "0 / " TotalRecords " records loaded"
        infoText.Value := "Click 'Load More' to fetch data in batches"
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 4: Search-Based Loading
; ============================================================================
Example4_SearchBasedLoading() {
    ; Full dataset (simulated)
    global FullDataset := []
    Loop 10000 {
        FullDataset.Push({
            id: A_Index,
            name: "Person " A_Index,
            email: "person" A_Index "@example.com",
            city: ["New York", "Los Angeles", "Chicago", "Houston", "Phoenix"][Mod(A_Index, 5) + 1]
        })
    }

    MyGui := Gui("+Resize", "Example 4: Search-Based Loading")

    MyGui.Add("Text", "w750", "Search (loads matching results only):")
    searchBox := MyGui.Add("Edit", "w500")
    MyGui.Add("Button", "w200", "Search").OnEvent("Click", PerformSearch)

    LV := MyGui.Add("ListView", "r15 w750", ["ID", "Name", "Email", "City"])

    resultText := MyGui.Add("Text", "w750", "Enter search term and click Search")

    PerformSearch(*) {
        searchTerm := Trim(searchBox.Value)

        if searchTerm = "" {
            MsgBox("Please enter a search term!")
            return
        }

        startTime := A_TickCount

        ; Clear current results
        LV.Delete()

        ; Search and load only matching records
        LV.Opt("-Redraw")

        matchCount := 0
        for record in FullDataset {
            ; Check if search term matches any field (case-insensitive)
            if InStr(record.name, searchTerm, false)
            or InStr(record.email, searchTerm, false)
            or InStr(record.city, searchTerm, false) {

                LV.Add(, record.id, record.name, record.email, record.city)
                matchCount++

                ; Limit results to prevent overload
                if matchCount >= 1000
                break
            }
        }

        LV.Opt("+Redraw")
        LV.ModifyCol()

        elapsed := A_TickCount - startTime

        if matchCount = 0
        resultText.Value := "No matches found for '" searchTerm "' (searched " FullDataset.Length " records in " elapsed " ms)"
        else if matchCount >= 1000
        resultText.Value := "Showing first 1000 matches for '" searchTerm "' (more results available, refine search)"
        else
        resultText.Value := "Found " matchCount " matches for '" searchTerm "' in " elapsed " ms"
    }

    ; Real-time search (with debounce)
    MyGui.Add("Text", "w750", "Or enable real-time search (types as you type):")
    MyGui.Add("Button", "w200", "Enable Real-Time Search").OnEvent("Click", EnableRealTime)

    EnableRealTime(*) {
        searchBox.OnEvent("Change", QueueSearch)
        MsgBox("Real-time search enabled! Type in the search box.")
    }

    QueueSearch(*) {
        ; Debounce: wait 500ms after last keystroke
        SetTimer(PerformSearch, -500)
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 5: Performance Comparison
; ============================================================================
Example5_PerformanceComparison() {
    MyGui := Gui("+Resize", "Example 5: Performance Comparison")

    MyGui.Add("Text", "w750", "Compare loading techniques with different dataset sizes:")

    MyGui.Add("Text", "w150", "Dataset size:")
    sizeDD := MyGui.Add("DropDownList", "w150", ["1000", "5000", "10000", "20000"])
    sizeDD.Choose(2)  ; Default to 5000

    MyGui.Add("Button", "w200", "Load with Redraw").OnEvent("Click", TestWithRedraw)
    MyGui.Add("Button", "w200", "Load WITHOUT Redraw").OnEvent("Click", TestWithoutRedraw)
    MyGui.Add("Button", "w200", "Clear").OnEvent("Click", (*) => LV.Delete())

    LV := MyGui.Add("ListView", "r12 w750", ["ID", "Name", "Value", "Category"])

    resultText := MyGui.Add("Edit", "r6 w750 ReadOnly")

    TestWithRedraw(*) {
        size := Number(sizeDD.Text)
        data := GenerateTestData(size)

        startTime := A_TickCount
        LV.Delete()

        ; Load WITHOUT disabling redraw (slow)
        for record in data {
            LV.Add(, record.id, record.name, record.value, record.category)
        }

        LV.ModifyCol()
        elapsed := A_TickCount - startTime

        resultText.Value := "WITH Redraw (Slow Method):`n"
        . "Records: " size "`n"
        . "Time: " elapsed " ms`n"
        . "Rate: " Round(size / elapsed * 1000) " records/second`n`n"
        . "This method updates the display for each row added."
    }

    TestWithoutRedraw(*) {
        size := Number(sizeDD.Text)
        data := GenerateTestData(size)

        startTime := A_TickCount
        LV.Delete()

        ; Load WITH disabling redraw (fast)
        LV.Opt("-Redraw")

        for record in data {
            LV.Add(, record.id, record.name, record.value, record.category)
        }

        LV.Opt("+Redraw")
        LV.ModifyCol()
        elapsed := A_TickCount - startTime

        resultText.Value := "WITHOUT Redraw (Fast Method):`n"
        . "Records: " size "`n"
        . "Time: " elapsed " ms`n"
        . "Rate: " Round(size / elapsed * 1000) " records/second`n`n"
        . "This method updates the display only once at the end.`n`n"
        . "MUCH FASTER for bulk operations!"
    }

    GenerateTestData(count) {
        data := []
        Loop count {
            data.Push({
                id: A_Index,
                name: "Item " A_Index,
                value: Random(1, 1000),
                category: ["A", "B", "C", "D"][Mod(A_Index, 4) + 1]
            })
        }
        return data
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 6: Batch Operations on Large Data
; ============================================================================
Example6_BatchOperations() {
    ; Create large dataset
    global DataSet := []
    Loop 5000 {
        DataSet.Push({
            id: A_Index,
            status: "Pending",
            value: Random(1, 100),
            processed: false
        })
    }

    MyGui := Gui("+Resize", "Example 6: Batch Operations (5000 records)")

    LV := MyGui.Add("ListView", "r12 w750", ["ID", "Status", "Value", "Processed"])

    LoadData() {
        LV.Opt("-Redraw")
        LV.Delete()

        for record in DataSet {
            processedText := record.processed ? "Yes" : "No"
            LV.Add(, record.id, record.status, record.value, processedText)
        }

        LV.Opt("+Redraw")
        LV.ModifyCol()
    }

    LoadData()

    MyGui.Add("Text", "w750", "Batch Operations:")
    MyGui.Add("Button", "w200", "Mark All Processed").OnEvent("Click", MarkAllProcessed)
    MyGui.Add("Button", "w200", "Update High Values").OnEvent("Click", UpdateHighValues)
    MyGui.Add("Button", "w200", "Batch Delete").OnEvent("Click", BatchDelete)
    MyGui.Add("Button", "w200", "Reset All").OnEvent("Click", ResetAll)

    statusText := MyGui.Add("Text", "w750", "")

    MarkAllProcessed(*) {
        startTime := A_TickCount

        ; Update data model
        for record in DataSet {
            record.processed := true
            record.status := "Complete"
        }

        ; Refresh view
        LoadData()

        elapsed := A_TickCount - startTime
        statusText.Value := "Marked all " DataSet.Length " records as processed in " elapsed " ms"
    }

    UpdateHighValues(*) {
        startTime := A_TickCount
        count := 0

        ; Update data model
        for record in DataSet {
            if record.value > 75 {
                record.status := "Priority"
                count++
            }
        }

        ; Refresh view
        LoadData()

        elapsed := A_TickCount - startTime
        statusText.Value := "Updated " count " high-value records in " elapsed " ms"
    }

    BatchDelete(*) {
        result := MsgBox("Delete all processed records?", "Confirm", "YesNo")
        if result = "No"
        return

        startTime := A_TickCount
        originalCount := DataSet.Length

        ; Filter out processed records
        newDataSet := []
        for record in DataSet {
            if !record.processed
            newDataSet.Push(record)
        }

        DataSet := newDataSet

        ; Refresh view
        LoadData()

        deleted := originalCount - DataSet.Length
        elapsed := A_TickCount - startTime
        statusText.Value := "Deleted " deleted " records in " elapsed " ms (" DataSet.Length " remaining)"
    }

    ResetAll(*) {
        startTime := A_TickCount

        for record in DataSet {
            record.status := "Pending"
            record.processed := false
        }

        LoadData()

        elapsed := A_TickCount - startTime
        statusText.Value := "Reset all records in " elapsed " ms"
    }

    MyGui.Show()
}

; ============================================================================
; EXAMPLE 7: Memory-Efficient Windowing
; ============================================================================
Example7_WindowedView() {
    ; Simulated huge dataset (100,000 records)
    global TotalRecordsAvailable := 100000
    global WindowSize := 1000  ; Keep only 1000 in memory
    global WindowStart := 1

    MyGui := Gui("+Resize", "Example 7: Windowed View (100,000 records)")

    MyGui.Add("Text", "w750", "Only " WindowSize " records loaded at a time (memory efficient)")

    LV := MyGui.Add("ListView", "r15 w750", ["ID", "Data", "Timestamp"])

    ; Generate data for current window only
    LoadWindow(startIdx) {
        global WindowStart := startIdx
        endIdx := Min(startIdx + WindowSize - 1, TotalRecordsAvailable)

        LV.Opt("-Redraw")
        LV.Delete()

        Loop endIdx - startIdx + 1 {
            idx := startIdx + A_Index - 1
            ; Simulate fetching data (don't store all in memory)
            LV.Add(, idx, "Data for record " idx, FormatTime(, "yyyy-MM-dd HH:mm:ss"))
        }

        LV.Opt("+Redraw")
        LV.ModifyCol()

        statusText.Value := "Showing records " startIdx "-" endIdx " of " TotalRecordsAvailable " (Window size: " WindowSize ")"
    }

    ; Navigation
    MyGui.Add("Button", "w150", "Previous Window").OnEvent("Click", PrevWindow)
    MyGui.Add("Button", "w150", "Next Window").OnEvent("Click", NextWindow)
    MyGui.Add("Button", "w150", "Jump to Record").OnEvent("Click", JumpTo)

    statusText := MyGui.Add("Text", "w750", "")

    PrevWindow(*) {
        newStart := Max(1, WindowStart - WindowSize)
        LoadWindow(newStart)
    }

    NextWindow(*) {
        newStart := Min(TotalRecordsAvailable - WindowSize + 1, WindowStart + WindowSize)
        LoadWindow(newStart)
    }

    JumpTo(*) {
        result := InputBox("Jump to record number (1-" TotalRecordsAvailable "):", "Jump", "w300")
        if result.Result = "Cancel"
        return

        targetRecord := Number(result.Value)
        if targetRecord < 1 or targetRecord > TotalRecordsAvailable {
            MsgBox("Invalid record number!")
            return
        }

        ; Calculate window start
        newStart := Max(1, targetRecord - Floor(WindowSize / 2))
        LoadWindow(newStart)
    }

    LoadWindow(1)

    MyGui.Show()
}

; ============================================================================
; Main Menu
; ============================================================================
MainMenu := Gui(, "ListView Virtualization & Large Datasets")
MainMenu.Add("Text", "w400", "Select an example to run:")
MainMenu.Add("Button", "w400", "Example 1: Pagination").OnEvent("Click", (*) => Example1_Pagination())
MainMenu.Add("Button", "w400", "Example 2: Progressive Loading").OnEvent("Click", (*) => Example2_ProgressiveLoading())
MainMenu.Add("Button", "w400", "Example 3: On-Demand Loading").OnEvent("Click", (*) => Example3_OnDemandLoading())
MainMenu.Add("Button", "w400", "Example 4: Search-Based Loading").OnEvent("Click", (*) => Example4_SearchBasedLoading())
MainMenu.Add("Button", "w400", "Example 5: Performance Comparison").OnEvent("Click", (*) => Example5_PerformanceComparison())
MainMenu.Add("Button", "w400", "Example 6: Batch Operations").OnEvent("Click", (*) => Example6_BatchOperations())
MainMenu.Add("Button", "w400", "Example 7: Memory-Efficient Windowing").OnEvent("Click", (*) => Example7_WindowedView())
MainMenu.Show()

; ============================================================================
; REFERENCE SECTION
; ============================================================================
/*
PERFORMANCE OPTIMIZATION:
------------------------
; Always use -Redraw for bulk operations
LV.Opt("-Redraw")
Loop 10000 {
    LV.Add(, data...)
}
LV.Opt("+Redraw")

; Difference can be 100x faster or more!

PAGINATION PATTERN:
------------------
PageSize := 100
CurrentPage := 1
TotalPages := Ceil(TotalRecords / PageSize)

LoadPage(pageNum) {
    startIdx := (pageNum - 1) * PageSize + 1
    endIdx := Min(pageNum * PageSize, TotalRecords)

    LV.Delete()
    Loop endIdx - startIdx + 1 {
        idx := startIdx + A_Index - 1
        LV.Add(, DataSource[idx].fields...)
    }
}

PROGRESSIVE LOADING:
-------------------
ChunkSize := 100
LoadedSoFar := 0

LoadNextChunk() {
    endIdx := Min(LoadedSoFar + ChunkSize, TotalRecords)

    Loop endIdx - LoadedSoFar {
        idx := LoadedSoFar + A_Index
        LV.Add(, Data[idx].fields...)
    }

    LoadedSoFar := endIdx

    if LoadedSoFar < TotalRecords
    SetTimer(LoadNextChunk, -50)  ; Schedule next chunk
}

ON-DEMAND LOADING:
-----------------
; Load button
LoadMore(*) {
    newData := FetchFromDatabase(LoadedCount, BatchSize)
    for record in newData
    LV.Add(, record.fields...)
    LoadedCount += newData.Length
}

SEARCH-BASED LOADING:
--------------------
PerformSearch(searchTerm) {
    LV.Delete()
    matchCount := 0

    for record in AllData {
        if InStr(record.field, searchTerm) {
            LV.Add(, record.fields...)
            matchCount++
            if matchCount >= MaxResults
            break
        }
    }
}

WINDOWED VIEW:
-------------
WindowSize := 1000

LoadWindow(startIdx) {
    LV.Delete()
    endIdx := Min(startIdx + WindowSize - 1, TotalRecords)

    Loop endIdx - startIdx + 1 {
        idx := startIdx + A_Index - 1
        record := FetchRecord(idx)  ; Fetch on demand
        LV.Add(, record.fields...)
    }
}

BATCH OPERATIONS:
----------------
; Update data model first, then refresh view once
for record in AllData {
    if record.matches
    record.status := "Updated"
}
RefreshListView()  ; Single update

PERFORMANCE TIPS:
----------------
1. Use LV.Opt("-Redraw") for bulk operations
2. Implement pagination for 1000+ records
3. Use progressive loading for 10000+ records
4. Limit search results to reasonable number
5. Consider virtual scrolling for 100000+ records
6. Keep only visible data in memory when possible
7. Batch database queries
8. Use SetTimer for async loading
9. Show progress indicators for long operations
10. Test with realistic data volumes

THRESHOLDS:
----------
< 100 records: Load all, no optimization needed
100-1000: Use -Redraw, consider pagination
1000-10000: Implement pagination or progressive loading
10000-100000: Mandatory pagination + search
> 100000: Virtual scrolling, windowed views, database pagination

MEMORY MANAGEMENT:
-----------------
; Don't keep all data in memory
FetchPage(pageNum) {
    return DatabaseQuery("SELECT * LIMIT " PageSize " OFFSET " offset)
}

; Clear data when switching pages
global CurrentPageData := []

LoadPage(pageNum) {
    CurrentPageData := FetchPage(pageNum)
    DisplayData(CurrentPageData)
}
*/
