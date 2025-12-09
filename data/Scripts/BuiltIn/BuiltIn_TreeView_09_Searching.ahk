#Requires AutoHotkey v2.0

/**
* BuiltIn_TreeView_09_Searching.ahk
*
* DESCRIPTION:
* Demonstrates searching, filtering, and finding nodes in TreeView controls
* with various search algorithms and highlighting techniques.
*
* FEATURES:
* - Text-based search in tree
* - Incremental/live search
* - Search result highlighting
* - Filter tree by criteria
* - Find and replace in tree
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/TreeView.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - String matching functions
* - Tree traversal algorithms
* - Dynamic tree filtering
* - Result highlighting
*
* LEARNING POINTS:
* 1. Search requires traversing entire tree
* 2. Bold/Select properties highlight results
* 3. Filter creates new filtered view
* 4. Track search results for navigation
* 5. Case-sensitive vs case-insensitive search
*/

;=============================================================================
; EXAMPLE 1: Basic Text Search
;=============================================================================
; Simple search functionality with result navigation

Example1_BasicSearch() {
    myGui := Gui("+Resize", "Example 1: Basic Text Search")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w600 h400")

    ; Build sample tree
    Root := TV.Add("Documents")
    Loop 10 {
        folder := TV.Add("Folder " . A_Index, Root)
        Loop 8 {
            TV.Add("File " . A_Index . ".txt", folder)
        }
    }
    TV.Modify(Root, "Expand")

    ; Search controls
    myGui.Add("Text", "xm y+10", "Search:")
    searchInput := myGui.Add("Edit", "x+10 yp-3 w300")
    searchBtn := myGui.Add("Button", "x+10 yp-0 w100", "Find")
    searchBtn.OnEvent("Click", DoSearch)

    nextBtn := myGui.Add("Button", "x+10 yp w100", "Find Next")
    nextBtn.OnEvent("Click", FindNext)

    ; Search state
    searchResults := []
    currentResult := 0

    DoSearch(*) {
        searchTerm := searchInput.Value
        if (!searchTerm) {
            MsgBox("Please enter search term", "Info", 64)
            return
        }

        ; Clear previous results
        ClearHighlights(TV, Root)
        searchResults := []
        currentResult := 0

        ; Find all matches
        FindMatches(TV, Root, searchTerm, searchResults)

        ; Highlight results
        for itemID in searchResults
        TV.Modify(itemID, "Bold")

        if (searchResults.Length > 0) {
            currentResult := 1
            TV.Modify(searchResults[1], "Select Vis")
            UpdateStatus()
        } else {
            MsgBox("No results found for: " . searchTerm, "Search", 64)
        }
    }

    FindNext(*) {
        if (searchResults.Length = 0)
        return DoSearch()

        currentResult++
        if (currentResult > searchResults.Length)
        currentResult := 1

        TV.Modify(searchResults[currentResult], "Select Vis")
        UpdateStatus()
    }

    FindMatches(TV, nodeID, searchTerm, &results) {
        if (nodeID) {
            text := TV.GetText(nodeID)
            if (InStr(text, searchTerm))
            results.Push(nodeID)
        }

        child := TV.GetChild(nodeID)
        while (child) {
            FindMatches(TV, child, searchTerm, &results)
            child := TV.GetNext(child)
        }
    }

    ClearHighlights(TV, nodeID) {
        if (nodeID)
        TV.Modify(nodeID, "-Bold")

        child := TV.GetChild(nodeID)
        while (child) {
            ClearHighlights(TV, child)
            child := TV.GetNext(child)
        }
    }

    ; Status
    statusText := myGui.Add("Text", "xm y+10 w600", "Ready")

    UpdateStatus() {
        if (searchResults.Length > 0)
        statusText.Value := "Found " . searchResults.Length . " results | Showing: " . currentResult
        else
        statusText.Value := "No results"
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 2: Incremental Live Search
;=============================================================================
; Search as you type with instant results

Example2_LiveSearch() {
    myGui := Gui("+Resize", "Example 2: Live Search")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w600 h400")

    ; Build tree
    Root := TV.Add("Employees")
    Dept1 := TV.Add("Engineering", Root)
    TV.Add("Alice Anderson", Dept1)
    TV.Add("Bob Brown", Dept1)
    TV.Add("Charlie Chen", Dept1)

    Dept2 := TV.Add("Sales", Root)
    TV.Add("David Davis", Dept2)
    TV.Add("Eva Evans", Dept2)
    TV.Add("Frank Foster", Dept2)

    Dept3 := TV.Add("Support", Root)
    TV.Add("Grace Garcia", Dept3)
    TV.Add("Henry Harris", Dept3)

    TV.Modify(Root, "Expand")

    ; Live search
    myGui.Add("Text", "xm y+10", "Live Search:")
    searchInput := myGui.Add("Edit", "x+10 yp-3 w400")
    searchInput.OnEvent("Change", LiveSearch)

    caseSensitiveCheck := myGui.Add("Checkbox", "x+10 yp+3", "Case Sensitive")

    LiveSearch(*) {
        searchTerm := searchInput.Value
        caseSensitive := caseSensitiveCheck.Value

        ; Clear previous highlights
        ClearAllBold(TV, Root)

        if (!searchTerm)
        return

        ; Highlight matches
        count := HighlightMatches(TV, Root, searchTerm, caseSensitive)
        UpdateStatus(count)
    }

    HighlightMatches(TV, nodeID, term, caseSensitive) {
        count := 0

        if (nodeID) {
            text := TV.GetText(nodeID)
            searchText := caseSensitive ? text : StrLower(text)
            searchTerm := caseSensitive ? term : StrLower(term)

            if (InStr(searchText, searchTerm)) {
                TV.Modify(nodeID, "Bold")
                count++
            }
        }

        child := TV.GetChild(nodeID)
        while (child) {
            count += HighlightMatches(TV, child, term, caseSensitive)
            child := TV.GetNext(child)
        }

        return count
    }

    ClearAllBold(TV, nodeID) {
        if (nodeID)
        TV.Modify(nodeID, "-Bold")
        child := TV.GetChild(nodeID)
        while (child) {
            ClearAllBold(TV, child)
            child := TV.GetNext(child)
        }
    }

    ; Status
    statusText := myGui.Add("Text", "xm y+10 w600", "Type to search...")

    UpdateStatus(count) {
        statusText.Value := count . " matches found"
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 3: Tree Filtering
;=============================================================================
; Filter tree to show only matching items

Example3_TreeFilter() {
    myGui := Gui("+Resize", "Example 3: Tree Filtering")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w600 h400")

    ; Original tree data (stored for reloading)
    treeData := []

    ; Build original tree
    BuildOriginalTree() {
        TV.Delete()
        treeData := []

        Root := TV.Add("Products")

        Electronics := TV.Add("Electronics", Root)
        treeData.Push({text: "Laptop Computer", parent: Electronics})
        treeData.Push({text: "Desktop Computer", parent: Electronics})
        treeData.Push({text: "Tablet Device", parent: Electronics})

        Clothing := TV.Add("Clothing", Root)
        treeData.Push({text: "T-Shirt", parent: Clothing})
        treeData.Push({text: "Jeans", parent: Clothing})
        treeData.Push({text: "Jacket", parent: Clothing})

        Books := TV.Add("Books", Root)
        treeData.Push({text: "Fiction Novel", parent: Books})
        treeData.Push({text: "Computer Science Textbook", parent: Books})
        treeData.Push({text: "History Book", parent: Books})

        for item in treeData
        item.nodeID := TV.Add(item.text, item.parent)

        TV.Modify(Root, "Expand")
    }

    BuildOriginalTree()

    ; Filter controls
    myGui.Add("Text", "xm y+10", "Filter:")
    filterInput := myGui.Add("Edit", "x+10 yp-3 w300")

    filterBtn := myGui.Add("Button", "x+10 yp-0 w100", "Apply Filter")
    filterBtn.OnEvent("Click", ApplyFilter)

    clearBtn := myGui.Add("Button", "x+10 yp w100", "Clear Filter")
    clearBtn.OnEvent("Click", ClearFilter)

    ApplyFilter(*) {
        filterText := filterInput.Value
        if (!filterText)
        return ClearFilter()

        TV.Delete()
        Root := TV.Add("Filtered Results")

        count := 0
        for item in treeData {
            if (InStr(item.text, filterText)) {
                TV.Add(item.text, Root)
                count++
            }
        }

        if (count = 0)
        TV.Add("No matches found", Root)

        TV.Modify(Root, "Expand")
        UpdateStatus(count)
    }

    ClearFilter(*) {
        BuildOriginalTree()
        filterInput.Value := ""
        UpdateStatus(treeData.Length)
    }

    ; Status
    statusText := myGui.Add("Text", "xm y+10 w600", "")

    UpdateStatus(count) {
        statusText.Value := "Showing " . count . " items"
    }

    UpdateStatus(treeData.Length)

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 4: Advanced Search Options
;=============================================================================
; Search with wildcards, regex, and multiple criteria

Example4_AdvancedSearch() {
    myGui := Gui("+Resize", "Example 4: Advanced Search")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w600 h350")

    ; Build tree
    Root := TV.Add("Files")
    Loop 20 {
        ext := (Mod(A_Index, 3) = 0) ? ".txt" : (Mod(A_Index, 3) = 1) ? ".ahk" : ".md"
        TV.Add("file" . A_Index . ext, Root)
    }
    TV.Modify(Root, "Expand")

    ; Search options
    myGui.Add("Text", "xm y+10", "Search Pattern:")
    searchInput := myGui.Add("Edit", "x+10 yp-3 w300")

    searchTypeDD := myGui.Add("DropDownList", "x+10 yp w120", ["Contains", "Starts With", "Ends With", "Regex"])
    searchTypeDD.Choose(1)

    searchBtn := myGui.Add("Button", "x+10 yp w80", "Search")
    searchBtn.OnEvent("Click", DoSearch)

    DoSearch(*) {
        pattern := searchInput.Value
        searchType := searchTypeDD.Text

        if (!pattern)
        return

        ; Clear highlights
        ClearBold(TV, Root)

        ; Search based on type
        count := 0
        SearchTree(TV, Root, pattern, searchType, &count)

        UpdateStatus(count)
    }

    SearchTree(TV, nodeID, pattern, searchType, &count) {
        if (nodeID) {
            text := TV.GetText(nodeID)
            match := false

            switch searchType {
                case "Contains":
                match := InStr(text, pattern)
                case "Starts With":
                match := SubStr(text, 1, StrLen(pattern)) = pattern
                case "Ends With":
                match := SubStr(text, -(StrLen(pattern)-1)) = pattern
                case "Regex":
                match := RegExMatch(text, pattern)
            }

            if (match) {
                TV.Modify(nodeID, "Bold")
                count++
            }
        }

        child := TV.GetChild(nodeID)
        while (child) {
            SearchTree(TV, child, pattern, searchType, &count)
            child := TV.GetNext(child)
        }
    }

    ClearBold(TV, nodeID) {
        if (nodeID)
        TV.Modify(nodeID, "-Bold")
        child := TV.GetChild(nodeID)
        while (child) {
            ClearBold(TV, child)
            child := TV.GetNext(child)
        }
    }

    ; Results
    statusText := myGui.Add("Text", "xm y+10 w600", "Enter search pattern and select search type")

    UpdateStatus(count) {
        statusText.Value := "Found " . count . " matches"
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 5: Find and Replace
;=============================================================================
; Search and replace text in tree nodes

Example5_FindReplace() {
    myGui := Gui("+Resize", "Example 5: Find and Replace")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w600 h350")

    ; Build tree
    Root := TV.Add("Documents")
    Loop 5 {
        folder := TV.Add("Project " . A_Index, Root)
        Loop 5 {
            TV.Add("Document_v1.txt", folder)
        }
    }
    TV.Modify(Root, "Expand")

    ; Find/Replace controls
    myGui.Add("Text", "xm y+10", "Find:")
    findInput := myGui.Add("Edit", "x+10 yp-3 w200")

    myGui.Add("Text", "x+20 yp+3", "Replace:")
    replaceInput := myGui.Add("Edit", "x+10 yp-3 w200")

    replaceBtn := myGui.Add("Button", "xm y+10 w120", "Replace All")
    replaceBtn.OnEvent("Click", ReplaceAll)

    previewBtn := myGui.Add("Button", "x+10 yp w120", "Preview Changes")
    previewBtn.OnEvent("Click", PreviewChanges)

    undoBtn := myGui.Add("Button", "x+10 yp w120", "Undo")
    undoBtn.OnEvent("Click", UndoChanges)

    ; History for undo
    history := []

    ReplaceAll(*) {
        findText := findInput.Value
        replaceText := replaceInput.Value

        if (!findText)
        return

        ; Save current state
        SaveState()

        count := ReplaceInTree(TV, Root, findText, replaceText)

        MsgBox("Replaced " . count . " occurrences", "Replace Complete", 64)
    }

    ReplaceInTree(TV, nodeID, findText, replaceText) {
        count := 0

        if (nodeID) {
            text := TV.GetText(nodeID)
            if (InStr(text, findText)) {
                newText := StrReplace(text, findText, replaceText)
                TV.Modify(nodeID, newText)
                count++
            }
        }

        child := TV.GetChild(nodeID)
        while (child) {
            count += ReplaceInTree(TV, child, findText, replaceText)
            child := TV.GetNext(child)
        }

        return count
    }

    PreviewChanges(*) {
        findText := findInput.Value
        replaceText := replaceInput.Value

        if (!findText)
        return

        preview := "Preview of changes:`n`n"
        count := 0
        PreviewTree(TV, Root, findText, replaceText, &preview, &count)

        if (count = 0)
        preview .= "No matches found"

        MsgBox(preview, "Preview", 64)
    }

    PreviewTree(TV, nodeID, findText, replaceText, &preview, &count) {
        if (nodeID) {
            text := TV.GetText(nodeID)
            if (InStr(text, findText)) {
                newText := StrReplace(text, findText, replaceText)
                preview .= text . " → " . newText . "`n"
                count++
            }
        }

        child := TV.GetChild(nodeID)
        while (child) {
            PreviewTree(TV, child, findText, replaceText, &preview, &count)
            child := TV.GetNext(child)
        }
    }

    SaveState() {
        state := []
        SaveTreeState(TV, Root, state)
        history.Push(state)
    }

    SaveTreeState(TV, nodeID, &state) {
        if (nodeID)
        state.Push({id: nodeID, text: TV.GetText(nodeID)})

        child := TV.GetChild(nodeID)
        while (child) {
            SaveTreeState(TV, child, &state)
            child := TV.GetNext(child)
        }
    }

    UndoChanges(*) {
        if (history.Length = 0) {
            MsgBox("Nothing to undo", "Info", 64)
            return
        }

        state := history.Pop()
        for item in state
        TV.Modify(item.id, item.text)

        MsgBox("Changes undone", "Undo", 64)
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 6: Search with Path Display
;=============================================================================
; Show full path of search results

Example6_SearchWithPath() {
    myGui := Gui("+Resize", "Example 6: Search with Path")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w600 h300")

    ; Build tree
    Root := TV.Add("Root")
    Level1 := TV.Add("Folder A", Root)
    TV.Add("Important File", Level1)
    TV.Add("Regular File", Level1)

    Level2 := TV.Add("Folder B", Root)
    SubLevel := TV.Add("Subfolder", Level2)
    TV.Add("Important Document", SubLevel)

    TV.Modify(Root, "Expand")

    ; Search
    myGui.Add("Text", "xm y+10", "Search:")
    searchInput := myGui.Add("Edit", "x+10 yp-3 w300")
    searchBtn := myGui.Add("Button", "x+10 yp-0 w100", "Search")
    searchBtn.OnEvent("Click", DoSearch)

    ; Results with paths
    resultsEdit := myGui.Add("Edit", "xm y+10 w600 h200 ReadOnly")

    DoSearch(*) {
        searchTerm := searchInput.Value
        if (!searchTerm)
        return

        results := "Search Results:`n`n"
        count := 0

        SearchWithPath(TV, Root, searchTerm, &results, &count)

        if (count = 0)
        results .= "No matches found"
        else
        results := "Found " . count . " matches:`n`n" . results

        resultsEdit.Value := results
    }

    SearchWithPath(TV, nodeID, term, &results, &count) {
        if (nodeID) {
            text := TV.GetText(nodeID)
            if (InStr(text, term)) {
                path := GetFullPath(TV, nodeID)
                results .= path . "`n"
                count++
            }
        }

        child := TV.GetChild(nodeID)
        while (child) {
            SearchWithPath(TV, child, term, &results, &count)
            child := TV.GetNext(child)
        }
    }

    GetFullPath(TV, nodeID) {
        path := TV.GetText(nodeID)
        parent := TV.GetParent(nodeID)

        while (parent) {
            path := TV.GetText(parent) . " → " . path
            parent := TV.GetParent(parent)
        }

        return path
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 7: Complete Search System
;=============================================================================
; Full-featured search with all capabilities

Example7_CompleteSearch() {
    myGui := Gui("+Resize", "Example 7: Complete Search System")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w700 h300")

    ; Build comprehensive tree
    Root := TV.Add("Library")
    Loop 15 {
        category := TV.Add("Category " . A_Index, Root)
        Loop 10 {
            TV.Add("Item " . A_Index . " in Cat" . A_Index, category)
        }
    }
    TV.Modify(Root, "Expand")

    ; Comprehensive search controls
    myGui.Add("Text", "xm y+10", "Search:")
    searchInput := myGui.Add("Edit", "x+10 yp-3 w250")

    typeDD := myGui.Add("DropDownList", "x+10 yp w100", ["Contains", "Regex", "Exact"])
    typeDD.Choose(1)

    caseCheck := myGui.Add("Checkbox", "x+10 yp+3", "Match Case")

    searchBtn := myGui.Add("Button", "xm y+10 w100", "Search")
    searchBtn.OnEvent("Click", DoSearch)

    prevBtn := myGui.Add("Button", "x+10 yp w100", "← Previous")
    prevBtn.OnEvent("Click", GoPrevious)

    nextBtn := myGui.Add("Button", "x+10 yp w100", "Next →")
    nextBtn.OnEvent("Click", GoNext)

    clearBtn := myGui.Add("Button", "x+10 yp w100", "Clear")
    clearBtn.OnEvent("Click", ClearSearch)

    ; Search state
    searchResults := []
    currentIndex := 0

    DoSearch(*) {
        term := searchInput.Value
        if (!term)
        return

        searchType := typeDD.Text
        matchCase := caseCheck.Value

        ; Clear previous
        ClearHighlights(TV, Root)
        searchResults := []
        currentIndex := 0

        ; Perform search
        PerformSearch(TV, Root, term, searchType, matchCase, searchResults)

        ; Highlight all results
        for itemID in searchResults
        TV.Modify(itemID, "Bold")

        ; Select first
        if (searchResults.Length > 0) {
            currentIndex := 1
            TV.Modify(searchResults[1], "Select Vis")
        }

        UpdateStatus()
    }

    PerformSearch(TV, nodeID, term, searchType, matchCase, &results) {
        if (nodeID) {
            text := TV.GetText(nodeID)
            searchText := matchCase ? text : StrLower(text)
            searchTerm := matchCase ? term : StrLower(term)

            match := false
            switch searchType {
                case "Contains":
                match := InStr(searchText, searchTerm)
                case "Exact":
                match := (searchText = searchTerm)
                case "Regex":
                match := RegExMatch(text, term)
            }

            if (match)
            results.Push(nodeID)
        }

        child := TV.GetChild(nodeID)
        while (child) {
            PerformSearch(TV, child, term, searchType, matchCase, &results)
            child := TV.GetNext(child)
        }
    }

    GoNext(*) {
        if (searchResults.Length = 0)
        return

        currentIndex++
        if (currentIndex > searchResults.Length)
        currentIndex := 1

        TV.Modify(searchResults[currentIndex], "Select Vis")
        UpdateStatus()
    }

    GoPrevious(*) {
        if (searchResults.Length = 0)
        return

        currentIndex--
        if (currentIndex < 1)
        currentIndex := searchResults.Length

        TV.Modify(searchResults[currentIndex], "Select Vis")
        UpdateStatus()
    }

    ClearSearch(*) {
        ClearHighlights(TV, Root)
        searchResults := []
        currentIndex := 0
        searchInput.Value := ""
        UpdateStatus()
    }

    ClearHighlights(TV, nodeID) {
        if (nodeID)
        TV.Modify(nodeID, "-Bold")
        child := TV.GetChild(nodeID)
        while (child) {
            ClearHighlights(TV, child)
            child := TV.GetNext(child)
        }
    }

    ; Status
    statusText := myGui.Add("Text", "xm y+10 w700 Border", "Ready to search")

    UpdateStatus() {
        if (searchResults.Length > 0)
        statusText.Value := "Result " . currentIndex . " of " . searchResults.Length
        else
        statusText.Value := "No results found"
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; REFERENCE SECTION
;=============================================================================
/*
SEARCH TECHNIQUES:

1. LINEAR SEARCH:
- Traverse entire tree sequentially
- Check each node against criteria
- Time: O(n) where n = node count

2. FILTERED VIEW:
- Create new tree with matches only
- Shows only relevant results
- Original tree preserved

3. IN-PLACE HIGHLIGHT:
- Mark matching nodes (Bold/Select)
- Keep tree structure intact
- Easy navigation

SEARCH TYPES:
- Contains: InStr(text, pattern)
- Starts With: SubStr(text, 1, len) = pattern
- Ends With: SubStr(text, -len) = pattern
- Regex: RegExMatch(text, pattern)
- Wildcard: Custom implementation

HIGHLIGHTING METHODS:
1. Bold property - TV.Modify(ID, "Bold")
2. Select property - TV.Modify(ID, "Select")
3. Custom icons - Change icon for matches
4. Check property - For TreeViews with checkboxes

PERFORMANCE OPTIMIZATION:
- Cache search results
- Use incremental search for large trees
- Debounce live search
- Limit visible results (pagination)
- Index tree for faster searches

BEST PRACTICES:
1. Clear previous highlights before new search
2. Provide result navigation (Next/Previous)
3. Show result count and current position
4. Support case-sensitive/insensitive
5. Implement keyboard shortcuts (F3, Ctrl+F)
6. Provide visual feedback during search
7. Allow search within specific branches

FIND AND REPLACE:
- Preview changes before applying
- Support undo/redo
- Batch replace with confirmation
- Case-sensitive replace option
- Regex capture groups for complex replacements
*/

; Uncomment to run examples:
; Example1_BasicSearch()
; Example2_LiveSearch()
; Example3_TreeFilter()
; Example4_AdvancedSearch()
; Example5_FindReplace()
; Example6_SearchWithPath()
; Example7_CompleteSearch()
