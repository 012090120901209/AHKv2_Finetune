#Requires AutoHotkey v2.0
/**
 * BuiltIn_Ceil_02_Pagination.ahk
 *
 * DESCRIPTION:
 * Pagination and resource allocation applications using Ceil() for calculating
 * page counts, batch sizes, and resource distribution
 *
 * FEATURES:
 * - Pagination calculations for data display
 * - Batch processing size determination
 * - Resource allocation and distribution
 * - Group and team sizing
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Ceil.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - Ceil() for division rounding
 * - Array slicing and batching
 * - Object-based data structures
 * - Iterator patterns
 *
 * LEARNING POINTS:
 * 1. Ceil() essential for pagination math
 * 2. Calculate total pages: Ceil(items / pageSize)
 * 3. Ensures all items are included
 * 4. Last page may be partially filled
 * 5. Critical for UI and batch processing
 */

; ============================================================
; Example 1: Basic Pagination
; ============================================================

/**
 * Calculate pagination information
 *
 * @param {Number} totalItems - Total number of items
 * @param {Number} itemsPerPage - Items to display per page
 * @returns {Object} - Pagination details
 */
CalculatePagination(totalItems, itemsPerPage) {
    totalPages := Ceil(totalItems / itemsPerPage)
    lastPageItems := Mod(totalItems, itemsPerPage)
    if (lastPageItems = 0)
        lastPageItems := itemsPerPage

    return {
        totalItems: totalItems,
        itemsPerPage: itemsPerPage,
        totalPages: totalPages,
        lastPageItems: lastPageItems,
        fullPages: totalPages - (lastPageItems = itemsPerPage ? 0 : 1)
    }
}

; Example: Search results
searchResults := 247
resultsPerPage := 20

pagination := CalculatePagination(searchResults, resultsPerPage)

MsgBox("Search Results Pagination:`n`n"
     . "Total Results: " pagination.totalItems "`n"
     . "Results per Page: " pagination.itemsPerPage "`n`n"
     . "Total Pages: " pagination.totalPages "`n"
     . "Full Pages: " pagination.fullPages "`n"
     . "Items on Last Page: " pagination.lastPageItems "`n`n"
     . "Calculation: Ceil(" searchResults " / " resultsPerPage ")`n"
     . "= Ceil(12.35) = " pagination.totalPages " pages",
     "Pagination Example", "Icon!")

; ============================================================
; Example 2: Page Range Calculator
; ============================================================

/**
 * Get items for a specific page
 *
 * @param {Number} pageNumber - Page to retrieve (1-based)
 * @param {Number} totalItems - Total items available
 * @param {Number} pageSize - Items per page
 * @returns {Object} - Page range information
 */
GetPageRange(pageNumber, totalItems, pageSize) {
    totalPages := Ceil(totalItems / pageSize)

    if (pageNumber < 1 || pageNumber > totalPages)
        return {error: "Page out of range"}

    startIndex := ((pageNumber - 1) * pageSize) + 1
    endIndex := Min(pageNumber * pageSize, totalItems)
    itemsOnPage := endIndex - startIndex + 1

    return {
        pageNumber: pageNumber,
        totalPages: totalPages,
        startIndex: startIndex,
        endIndex: endIndex,
        itemsOnPage: itemsOnPage,
        rangeText: Format("Showing {1}-{2} of {3}", startIndex, endIndex, totalItems)
    }
}

; Display pagination for various pages
totalRecords := 156
recordsPerPage := 15

output := "Database Record Pagination:`n"
output .= "Total: " totalRecords " records, " recordsPerPage " per page`n"
output .= "═══════════════════════════════════════`n`n"

for page in [1, 5, 10, 11] {
    range := GetPageRange(page, totalRecords, recordsPerPage)

    if (range.HasOwnProp("error")) {
        output .= "Page " page ": " range.error "`n"
    } else {
        output .= Format("Page {1}/{2}: Items {3}-{4} ({5} items)`n",
                        range.pageNumber, range.totalPages,
                        range.startIndex, range.endIndex, range.itemsOnPage)
    }
}

MsgBox(output, "Page Ranges", "Icon!")

; ============================================================
; Example 3: Batch Processing
; ============================================================

/**
 * Calculate batch processing requirements
 *
 * @param {Number} totalJobs - Total jobs to process
 * @param {Number} batchSize - Jobs per batch
 * @returns {Object} - Batch processing plan
 */
PlanBatchProcessing(totalJobs, batchSize) {
    totalBatches := Ceil(totalJobs / batchSize)
    batches := []

    Loop totalBatches {
        batchNum := A_Index
        startJob := ((batchNum - 1) * batchSize) + 1
        endJob := Min(batchNum * batchSize, totalJobs)
        jobsInBatch := endJob - startJob + 1

        batches.Push({
            batchNumber: batchNum,
            startJob: startJob,
            endJob: endJob,
            jobCount: jobsInBatch
        })
    }

    return {
        totalJobs: totalJobs,
        batchSize: batchSize,
        totalBatches: totalBatches,
        batches: batches
    }
}

; Email processing example
emailsToProcess := 5420
emailsPerBatch := 500

batchPlan := PlanBatchProcessing(emailsToProcess, emailsPerBatch)

output := "Email Batch Processing Plan:`n`n"
output .= "Total Emails: " batchPlan.totalJobs "`n"
output .= "Batch Size: " batchPlan.batchSize "`n"
output .= "Total Batches: " batchPlan.totalBatches "`n`n"

; Show first 3 and last batch
for i, batch in batchPlan.batches {
    if (i <= 3 || i = batchPlan.batches.Length) {
        output .= Format("Batch {1}: Emails {2}-{3} ({4} emails)`n",
                        batch.batchNumber, batch.startJob,
                        batch.endJob, batch.jobCount)

        if (i = 3 && batchPlan.batches.Length > 4)
            output .= "...`n"
    }
}

MsgBox(output, "Batch Processing", "Icon!")

; ============================================================
; Example 4: Team/Group Assignment
; ============================================================

/**
 * Distribute people into teams
 *
 * @param {Number} totalPeople - Number of people
 * @param {Number} maxPerTeam - Maximum people per team
 * @returns {Object} - Team assignment
 */
AssignToTeams(totalPeople, maxPerTeam) {
    numTeams := Ceil(totalPeople / maxPerTeam)
    baseSize := Floor(totalPeople / numTeams)
    remainder := Mod(totalPeople, numTeams)

    teams := []
    assigned := 0

    Loop numTeams {
        teamNum := A_Index
        ; Distribute remainder across first teams
        teamSize := baseSize + (teamNum <= remainder ? 1 : 0)

        teams.Push({
            teamNumber: teamNum,
            size: teamSize,
            members: Format("{1}-{2}", assigned + 1, assigned + teamSize)
        })

        assigned += teamSize
    }

    return {
        totalPeople: totalPeople,
        maxPerTeam: maxPerTeam,
        numTeams: numTeams,
        teams: teams
    }
}

; Conference workshop groups
attendees := 47
maxPerWorkshop := 12

teamAssignment := AssignToTeams(attendees, maxPerWorkshop)

output := "Workshop Group Assignment:`n`n"
output .= "Total Attendees: " teamAssignment.totalPeople "`n"
output .= "Max per Workshop: " teamAssignment.maxPerTeam "`n"
output .= "Workshops Needed: " teamAssignment.numTeams "`n`n"

for team in teamAssignment.teams {
    output .= Format("Workshop {1}: {2} people (#{3})`n",
                    team.teamNumber, team.size, team.members)
}

MsgBox(output, "Team Assignment", "Icon!")

; ============================================================
; Example 5: Data Table Paging
; ============================================================

/**
 * Create pagination controls
 *
 * @param {Number} currentPage - Current page number
 * @param {Number} totalItems - Total items
 * @param {Number} pageSize - Items per page
 * @returns {Object} - Pagination controls
 */
CreatePaginationControls(currentPage, totalItems, pageSize) {
    totalPages := Ceil(totalItems / pageSize)

    return {
        currentPage: currentPage,
        totalPages: totalPages,
        hasPrevious: currentPage > 1,
        hasNext: currentPage < totalPages,
        previousPage: Max(currentPage - 1, 1),
        nextPage: Min(currentPage + 1, totalPages),
        firstPage: 1,
        lastPage: totalPages,
        pageNumbers: GeneratePageNumbers(currentPage, totalPages)
    }
}

/**
 * Generate visible page numbers (with ellipsis for large sets)
 *
 * @param {Number} current - Current page
 * @param {Number} total - Total pages
 * @returns {Array} - Page numbers to display
 */
GeneratePageNumbers(current, total) {
    if (total <= 7)
        return Range(1, total)

    ; Show: 1 ... n-1 n n+1 ... total
    pages := [1]

    if (current > 3)
        pages.Push("...")

    ; Show pages around current
    startPage := Max(2, current - 1)
    endPage := Min(total - 1, current + 1)

    Loop endPage - startPage + 1
        pages.Push(startPage + A_Index - 1)

    if (current < total - 2)
        pages.Push("...")

    if (total > 1)
        pages.Push(total)

    return pages
}

Range(start, end) {
    arr := []
    Loop end - start + 1
        arr.Push(start + A_Index - 1)
    return arr
}

; Example pagination UI
currentPage := 5
totalItems := 1000
itemsPerPage := 25

controls := CreatePaginationControls(currentPage, totalItems, itemsPerPage)

output := "Pagination Controls:`n`n"
output .= "Page " controls.currentPage " of " controls.totalPages "`n`n"

output .= "Pages: "
for pageNum in controls.pageNumbers {
    if (pageNum = controls.currentPage)
        output .= "[" pageNum "] "
    else
        output .= pageNum " "
}

output .= "`n`n"
output .= "Previous: " (controls.hasPrevious ? "Page " controls.previousPage : "N/A") "`n"
output .= "Next: " (controls.hasNext ? "Page " controls.nextPage : "N/A")

MsgBox(output, "Pagination UI", "Icon!")

; ============================================================
; Example 6: File Upload Chunks
; ============================================================

/**
 * Calculate file upload chunks
 *
 * @param {Number} fileSizeBytes - Total file size
 * @param {Number} chunkSizeBytes - Chunk size
 * @returns {Object} - Upload plan
 */
PlanFileUpload(fileSizeBytes, chunkSizeBytes) {
    totalChunks := Ceil(fileSizeBytes / chunkSizeBytes)
    chunks := []

    Loop totalChunks {
        chunkNum := A_Index
        startByte := ((chunkNum - 1) * chunkSizeBytes)
        endByte := Min(chunkNum * chunkSizeBytes - 1, fileSizeBytes - 1)
        chunkSize := endByte - startByte + 1

        chunks.Push({
            chunkNumber: chunkNum,
            startByte: startByte,
            endByte: endByte,
            sizeBytes: chunkSize,
            sizeMB: Round(chunkSize / 1048576, 2)
        })
    }

    return {
        fileSizeBytes: fileSizeBytes,
        fileSizeMB: Round(fileSizeBytes / 1048576, 2),
        chunkSizeBytes: chunkSizeBytes,
        chunkSizeMB: Round(chunkSizeBytes / 1048576, 2),
        totalChunks: totalChunks,
        chunks: chunks
    }
}

; Large video upload
videoSize := 157286400  ; bytes (150 MB)
chunkSize := 10485760   ; bytes (10 MB)

uploadPlan := PlanFileUpload(videoSize, chunkSize)

output := "File Upload Plan:`n`n"
output .= "File Size: " uploadPlan.fileSizeMB " MB`n"
output .= "Chunk Size: " uploadPlan.chunkSizeMB " MB`n"
output .= "Total Chunks: " uploadPlan.totalChunks "`n`n"

; Show first 3 and last chunk
for i, chunk in uploadPlan.chunks {
    if (i <= 3 || i = uploadPlan.chunks.Length) {
        output .= Format("Chunk {1}: Bytes {2}-{3} ({4} MB)`n",
                        chunk.chunkNumber, chunk.startByte,
                        chunk.endByte, chunk.sizeMB)

        if (i = 3 && uploadPlan.chunks.Length > 4)
            output .= "...`n"
    }
}

MsgBox(output, "Upload Chunks", "Icon!")

; ============================================================
; Example 7: Print Job Pages
; ============================================================

/**
 * Calculate print job requirements
 *
 * @param {Number} totalPages - Document pages
 * @param {Number} sheetsPerPage - Pages per sheet (1, 2, 4, etc.)
 * @param {Number} duplex - Print both sides (true/false)
 * @returns {Object} - Print requirements
 */
CalculatePrintJob(totalPages, sheetsPerPage := 1, duplex := false) {
    pagesPerSheet := sheetsPerPage * (duplex ? 2 : 1)
    sheetsNeeded := Ceil(totalPages / pagesPerSheet)
    blankPages := (sheetsNeeded * pagesPerSheet) - totalPages

    return {
        totalPages: totalPages,
        sheetsPerPage: sheetsPerPage,
        duplex: duplex,
        pagesPerSheet: pagesPerSheet,
        sheetsNeeded: sheetsNeeded,
        blankPages: blankPages
    }
}

; Print job scenarios
printJobs := [
    {name: "Simple (1-sided)", pages: 47, perSheet: 1, duplex: false},
    {name: "Duplex (2-sided)", pages: 47, perSheet: 1, duplex: true},
    {name: "2-up Duplex", pages: 47, perSheet: 2, duplex: true},
    {name: "4-up Single", pages: 47, perSheet: 4, duplex: false}
]

output := "Print Job Calculations:`n`n"

for job in printJobs {
    calc := CalculatePrintJob(job.pages, job.perSheet, job.duplex)

    output .= job.name . ":`n"
    output .= "  " calc.totalPages " pages → "
    output .= calc.sheetsNeeded " sheets"

    if (calc.blankPages > 0)
        output .= " (" calc.blankPages " blank)"

    output .= "`n`n"
}

MsgBox(output, "Print Planning", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
CEIL() FOR PAGINATION & RESOURCE ALLOCATION:

Pagination Formula:
───────────────────
  total_pages = Ceil(total_items / items_per_page)

Example:
  247 items, 20 per page
  Ceil(247 / 20) = Ceil(12.35) = 13 pages

Page Range Calculation:
───────────────────────
For page N (1-based):
  start = (N - 1) × page_size + 1
  end = Min(N × page_size, total_items)

Example (Page 5, size 20):
  start = (5-1) × 20 + 1 = 81
  end = Min(5 × 20, 247) = 100
  Range: Items 81-100

Batch Processing:
─────────────────
  batches = Ceil(total_jobs / batch_size)

Use when:
✓ Processing large datasets in chunks
✓ Limiting API calls per request
✓ Managing memory with large files
✓ Distributing work across workers

Team/Group Distribution:
─────────────────────────
  groups = Ceil(total_people / max_per_group)

Ensures everyone is assigned:
  47 people, max 12 per group
  Ceil(47 / 12) = 4 groups
  Groups: 12, 12, 12, 11 people

File Chunking:
──────────────
  chunks = Ceil(file_size / chunk_size)

For uploads/downloads:
  150 MB file, 10 MB chunks
  Ceil(150 / 10) = 15 chunks

Print Jobs:
───────────
  sheets = Ceil(pages / pages_per_sheet)

Duplex (2-sided):
  sheets = Ceil(pages / 2)

2-up duplex (4 per sheet):
  sheets = Ceil(pages / 4)

Common Patterns:
────────────────
1. Calculate total pages/batches
2. Determine start/end for each page
3. Handle partial last page/batch
4. Generate navigation controls
5. Track progress

Best Practices:
───────────────
✓ Always validate page numbers
✓ Handle edge cases (0 items, page 1)
✓ Show clear range indicators
✓ Account for remainder items
✓ Test with various total counts
✓ Consider performance with large sets

UI Pagination Elements:
───────────────────────
• Current page number
• Total pages
• Previous/Next buttons
• First/Last page links
• Page number list (with ellipsis)
• Items range (e.g., "1-20 of 247")
• Items per page selector
)"

MsgBox(info, "Pagination Reference", "Icon!")
