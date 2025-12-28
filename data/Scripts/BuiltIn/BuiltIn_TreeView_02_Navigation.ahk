#Requires AutoHotkey v2.0

/**
 * BuiltIn_TreeView_02_Navigation.ahk
 * 
 * DESCRIPTION:
 * Demonstrates advanced TreeView navigation techniques including programmatic
 * expansion/collapse, keyboard navigation, and automatic scrolling.
 * 
 * FEATURES:
 * - Expanding and collapsing nodes programmatically
 * - Keyboard shortcuts for tree navigation
 * - Auto-scroll to make items visible
 * - Breadth-first and depth-first traversal
 * - Smart expansion strategies
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/TreeView.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Modern iteration with For loops
 * - Array and object manipulation
 * - Hotkey function binding
 * - Method references and callbacks
 * 
 * LEARNING POINTS:
 * 1. Use GetNext() with "Full" to iterate all visible items
 * 2. Vis option scrolls items into view
 * 3. Expand/Collapse can be toggled with +/- prefixes
 * 4. GetChild() and GetNext() enable tree traversal
 * 5. Recursive functions useful for deep trees
 */

;=============================================================================
; EXAMPLE 1: Expand/Collapse Operations
;=============================================================================
; Shows different strategies for expanding and collapsing tree nodes

Example1_ExpandCollapse() {
    myGui := Gui("+Resize", "Example 1: Expand/Collapse Operations")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h400")

    ; Build a multi-level tree structure
    Root := TV.Add("File System")

    ; Level 1
    Drives := TV.Add("Drives", Root)
    TV.Add("C:", Drives)
    TV.Add("D:", Drives)

    ; Level 2 - Detailed structure under C:
    CDrive := TV.Add("C: Drive (Detailed)", Root)

    Windows := TV.Add("Windows", CDrive)
    TV.Add("System32", Windows)
    TV.Add("SysWOW64", Windows)
    TV.Add("Temp", Windows)

    Program := TV.Add("Program Files", CDrive)
    TV.Add("Common Files", Program)
    TV.Add("Internet Explorer", Program)
    TV.Add("Windows Defender", Program)

    Users := TV.Add("Users", CDrive)
    User1 := TV.Add("Administrator", Users)
    TV.Add("Documents", User1)
    TV.Add("Downloads", User1)
    TV.Add("Pictures", User1)

    User2 := TV.Add("Guest", Users)
    TV.Add("Documents", User2)
    TV.Add("Downloads", User2)

    ; Initially expand only root
    TV.Modify(Root, "Expand")

    ; Control buttons
    myGui.Add("Text", "xm y+10", "Expansion Controls:")

    expandAllBtn := myGui.Add("Button", "xm y+5 w110", "Expand All")
    expandAllBtn.OnEvent("Click", (*) => ExpandAll(TV, Root))

    collapseAllBtn := myGui.Add("Button", "x+5 yp w110", "Collapse All")
    collapseAllBtn.OnEvent("Click", (*) => CollapseAll(TV, Root))

    expandLevelBtn := myGui.Add("Button", "x+5 yp w110", "Expand Level 1")
    expandLevelBtn.OnEvent("Click", (*) => ExpandToLevel(TV, Root, 1))

    expandLevel2Btn := myGui.Add("Button", "x+5 yp w110", "Expand Level 2")
    expandLevel2Btn.OnEvent("Click", (*) => ExpandToLevel(TV, Root, 2))

    ; Smart expansion
    expandSelectedBtn := myGui.Add("Button", "xm y+5 w110", "Expand Selected")
    expandSelectedBtn.OnEvent("Click", ExpandSelected)

    collapseSelectedBtn := myGui.Add("Button", "x+5 yp w110", "Collapse Selected")
    collapseSelectedBtn.OnEvent("Click", CollapseSelected)

    toggleSelectedBtn := myGui.Add("Button", "x+5 yp w110", "Toggle Selected")
    toggleSelectedBtn.OnEvent("Click", ToggleSelected)

    expandPathBtn := myGui.Add("Button", "x+5 yp w110", "Expand Path")
    expandPathBtn.OnEvent("Click", ExpandPath)

    ExpandSelected(*) {
        if (selected := TV.GetSelection())
            ExpandAll(TV, selected)
    }

    CollapseSelected(*) {
        if (selected := TV.GetSelection())
            TV.Modify(selected, "-Expand")
    }

    ToggleSelected(*) {
        if (selected := TV.GetSelection()) {
            isExpanded := TV.Get(selected, "Expand")
            TV.Modify(selected, isExpanded ? "-Expand" : "Expand")
        }
    }

    ; Expand path from root to selected item
    ExpandPath(*) {
        if (selected := TV.GetSelection()) {
            ; Collect path from root to selected
            path := []
            current := selected
            while (current) {
                path.InsertAt(1, current)
                current := TV.GetParent(current)
            }

            ; Expand each item in path
            for itemID in path
                TV.Modify(itemID, "Expand")

            TV.Modify(selected, "Vis")
        }
    }

    ; Status display
    statusText := myGui.Add("Text", "xm y+20 w500 Border", "Ready")

    UpdateStatus() {
        total := TV.GetCount()
        expanded := CountExpanded(TV, Root)
        statusText.Value := "Total Items: " . total . " | Expanded: " . expanded
    }

    ; Update status after operations
    expandAllBtn.OnEvent("Click", (*) => (SetTimer(UpdateStatus, -100), ""))
    collapseAllBtn.OnEvent("Click", (*) => (SetTimer(UpdateStatus, -100), ""))

    UpdateStatus()

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

; Recursively expand all nodes
ExpandAll(TV, NodeID := 0) {
    if (NodeID)
        TV.Modify(NodeID, "Expand")

    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        ExpandAll(TV, ChildID)
        ChildID := TV.GetNext(ChildID)
    }
}

; Recursively collapse all nodes
CollapseAll(TV, NodeID := 0) {
    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        CollapseAll(TV, ChildID)
        TV.Modify(ChildID, "-Expand")
        ChildID := TV.GetNext(ChildID)
    }
}

; Expand to specific depth level
ExpandToLevel(TV, NodeID, TargetLevel, CurrentLevel := 0) {
    if (NodeID) {
        if (CurrentLevel < TargetLevel)
            TV.Modify(NodeID, "Expand")
        else
            TV.Modify(NodeID, "-Expand")
    }

    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        ExpandToLevel(TV, ChildID, TargetLevel, CurrentLevel + 1)
        ChildID := TV.GetNext(ChildID)
    }
}

; Count expanded nodes
CountExpanded(TV, NodeID := 0) {
    count := 0
    if (NodeID && TV.Get(NodeID, "Expand"))
        count := 1

    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        count += CountExpanded(TV, ChildID)
        ChildID := TV.GetNext(ChildID)
    }
    return count
}

;=============================================================================
; EXAMPLE 2: Keyboard Navigation
;=============================================================================
; Implements keyboard shortcuts for efficient tree navigation

Example2_KeyboardNavigation() {
    myGui := Gui("+Resize", "Example 2: Keyboard Navigation")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h450")

    ; Build sample tree
    BuildSampleTree(TV)

    ; Instructions
    instructions := "
    (
    KEYBOARD SHORTCUTS:
    Ctrl+E = Expand selected branch
    Ctrl+C = Collapse selected branch
    Ctrl+A = Expand all nodes
    Ctrl+Shift+C = Collapse all nodes
    Ctrl+Home = Go to first item
    Ctrl+End = Go to last visible item
    Ctrl+Up = Go to parent
    Ctrl+Down = Go to first child
    Ctrl+Right = Next sibling
    Ctrl+Left = Previous sibling
    F3 = Find next
    Shift+F3 = Find previous
    )"

    instructText := myGui.Add("Edit", "xm y+10 w500 h150 ReadOnly", instructions)

    ; Register hotkeys (use HotIfWinActive for specific window)
    HotIfWinActive("ahk_id " . myGui.Hwnd)

    ; Expansion hotkeys
    Hotkey("^e", (*) => ExpandSelectedBranch())
    Hotkey("^c", (*) => CollapseSelectedBranch())
    Hotkey("^a", (*) => ExpandAll(TV, TV.GetNext()))
    Hotkey("^+c", (*) => CollapseAll(TV, TV.GetNext()))

    ; Navigation hotkeys
    Hotkey("^Home", (*) => GoToFirst())
    Hotkey("^End", (*) => GoToLast())
    Hotkey("^Up", (*) => GoToParent())
    Hotkey("^Down", (*) => GoToFirstChild())
    Hotkey("^Right", (*) => GoToNextSibling())
    Hotkey("^Left", (*) => GoToPrevSibling())

    ; Search hotkeys
    Hotkey("F3", (*) => FindNext())
    Hotkey("+F3", (*) => FindPrevious())

    HotIf()  ; End conditional hotkeys

    ; Hotkey implementations
    ExpandSelectedBranch() {
        if (selected := TV.GetSelection())
            ExpandAll(TV, selected)
    }

    CollapseSelectedBranch() {
        if (selected := TV.GetSelection())
            TV.Modify(selected, "-Expand")
    }

    GoToFirst() {
        first := TV.GetNext()
        if (first)
            TV.Modify(first, "Select Vis")
    }

    GoToLast() {
        last := TV.GetNext()
        current := last
        while (current := TV.GetNext(current, "Full"))
            last := current
        if (last)
            TV.Modify(last, "Select Vis")
    }

    GoToParent() {
        if (selected := TV.GetSelection()) {
            if (parent := TV.GetParent(selected))
                TV.Modify(parent, "Select Vis")
        }
    }

    GoToFirstChild() {
        if (selected := TV.GetSelection()) {
            if (child := TV.GetChild(selected)) {
                TV.Modify(selected, "Expand")
                TV.Modify(child, "Select Vis")
            }
        }
    }

    GoToNextSibling() {
        if (selected := TV.GetSelection()) {
            if (next := TV.GetNext(selected))
                TV.Modify(next, "Select Vis")
        }
    }

    GoToPrevSibling() {
        if (selected := TV.GetSelection()) {
            if (prev := TV.GetPrev(selected))
                TV.Modify(prev, "Select Vis")
        }
    }

    ; Simple find next/previous
    static searchTerm := "File"

    FindNext() {
        current := TV.GetSelection()
        if (!current)
            current := TV.GetNext()

        found := FindInTreeForward(TV, current, searchTerm)
        if (found)
            TV.Modify(found, "Select Vis")
        else
            MsgBox("No more matches found", "Find", 64)
    }

    FindPrevious() {
        current := TV.GetSelection()
        if (!current)
            current := TV.GetNext()

        found := FindInTreeBackward(TV, current, searchTerm)
        if (found)
            TV.Modify(found, "Select Vis")
        else
            MsgBox("No previous matches found", "Find", 64)
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.OnEvent("Close", CleanupHotkeys)
    CleanupHotkeys(*) {
        HotIfWinActive("ahk_id " . myGui.Hwnd)
        Hotkey("^e", "Off")
        Hotkey("^c", "Off")
        Hotkey("^a", "Off")
        Hotkey("^+c", "Off")
        Hotkey("^Home", "Off")
        Hotkey("^End", "Off")
        Hotkey("^Up", "Off")
        Hotkey("^Down", "Off")
        Hotkey("^Right", "Off")
        Hotkey("^Left", "Off")
        Hotkey("F3", "Off")
        Hotkey("+F3", "Off")
        HotIf()
        myGui.Destroy()
    }

    myGui.Show()
}

; Build a sample tree structure
BuildSampleTree(TV) {
    Root := TV.Add("Documents")

    Work := TV.Add("Work Files", Root)
    TV.Add("Project A", Work)
    TV.Add("Project B", Work)
    TV.Add("Reports", Work)

    Personal := TV.Add("Personal Files", Root)
    TV.Add("Photos 2023", Personal)
    TV.Add("Videos", Personal)
    TV.Add("Music", Personal)

    Archive := TV.Add("Archive", Root)
    TV.Add("Old Projects", Archive)
    TV.Add("Backups", Archive)

    TV.Modify(Root, "Expand")
    return Root
}

; Find next occurrence forward
FindInTreeForward(TV, StartID, SearchText) {
    ; Start from next item
    current := TV.GetNext(StartID, "Full")
    if (!current)
        current := TV.GetNext()  ; Wrap to beginning

    startItem := current
    Loop {
        if (!current)
            return 0

        if (InStr(TV.GetText(current), SearchText))
            return current

        current := TV.GetNext(current, "Full")
        if (!current)
            current := TV.GetNext()

        if (current = startItem)
            break
    }
    return 0
}

; Find previous occurrence backward
FindInTreeBackward(TV, StartID, SearchText) {
    ; Get all items
    items := []
    current := TV.GetNext()
    while (current) {
        items.Push(current)
        current := TV.GetNext(current, "Full")
    }

    ; Find current position
    currentPos := 0
    for index, itemID in items {
        if (itemID = StartID) {
            currentPos := index
            break
        }
    }

    ; Search backward
    pos := currentPos - 1
    if (pos < 1)
        pos := items.Length

    startPos := pos
    Loop {
        if (pos < 1 || pos > items.Length)
            return 0

        itemID := items[pos]
        if (InStr(TV.GetText(itemID), SearchText))
            return itemID

        pos--
        if (pos < 1)
            pos := items.Length

        if (pos = startPos)
            break
    }
    return 0
}

;=============================================================================
; EXAMPLE 3: Auto-Scroll and Visibility
;=============================================================================
; Demonstrates ensuring items are visible and auto-scrolling

Example3_AutoScroll() {
    myGui := Gui("+Resize", "Example 3: Auto-Scroll and Visibility")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h350")

    ; Build a large tree
    Root := TV.Add("Large Tree Structure")

    ; Add many items to require scrolling
    Loop 20 {
        section := TV.Add("Section " . A_Index, Root)
        Loop 10 {
            TV.Add("Item " . A_Index, section)
        }
    }

    TV.Modify(Root, "Expand")

    ; Navigation controls
    myGui.Add("Text", "xm y+10", "Quick Navigation:")

    jumpTopBtn := myGui.Add("Button", "xm y+5 w120", "Jump to Top")
    jumpTopBtn.OnEvent("Click", JumpToTop)

    jumpBottomBtn := myGui.Add("Button", "x+5 yp w120", "Jump to Bottom")
    jumpBottomBtn.OnEvent("Click", JumpToBottom)

    jumpMiddleBtn := myGui.Add("Button", "x+5 yp w120", "Jump to Middle")
    jumpMiddleBtn.OnEvent("Click", JumpToMiddle)

    jumpRandomBtn := myGui.Add("Button", "x+5 yp w120", "Jump Random")
    jumpRandomBtn.OnEvent("Click", JumpRandom)

    ; Advanced scrolling
    scrollBtn := myGui.Add("Button", "xm y+5 w120", "Smooth Scroll")
    scrollBtn.OnEvent("Click", SmoothScroll)

    expandVisibleBtn := myGui.Add("Button", "x+5 yp w120", "Expand Visible")
    expandVisibleBtn.OnEvent("Click", ExpandVisible)

    JumpToTop(*) {
        first := TV.GetNext()
        if (first)
            TV.Modify(first, "Select Vis")
    }

    JumpToBottom(*) {
        ; Find last item
        last := TV.GetNext()
        current := last
        while (current := TV.GetNext(current, "Full"))
            last := current

        if (last)
            TV.Modify(last, "Select Vis")
    }

    JumpToMiddle(*) {
        ; Count total items
        count := TV.GetCount()
        target := count // 2

        ; Navigate to middle item
        current := TV.GetNext()
        Loop target - 1 {
            if (current := TV.GetNext(current, "Full"))
                continue
            else
                break
        }

        if (current)
            TV.Modify(current, "Select Vis")
    }

    JumpRandom(*) {
        ; Get random item
        count := TV.GetCount()
        if (count = 0)
            return

        target := Random(1, count)

        current := TV.GetNext()
        Loop target - 1 {
            current := TV.GetNext(current, "Full")
        }

        if (current)
            TV.Modify(current, "Select Vis")
    }

    SmoothScroll(*) {
        ; Simulate smooth scrolling by jumping through items
        current := TV.GetSelection()
        if (!current)
            current := TV.GetNext()

        Loop 10 {
            if (current := TV.GetNext(current, "Full")) {
                TV.Modify(current, "Select Vis")
                Sleep(50)
            } else {
                break
            }
        }
    }

    ExpandVisible(*) {
        ; Expand only currently visible items
        current := TV.GetNext()
        Loop {
            if (!current)
                break

            TV.Modify(current, "Expand")
            current := TV.GetNext(current, "Full")
        }
    }

    ; Status
    statusText := myGui.Add("Text", "xm y+20 w500", "")

    TV.OnEvent("ItemSelect", UpdateStatus)

    UpdateStatus(*) {
        if (selected := TV.GetSelection()) {
            text := TV.GetText(selected)
            ; Count position
            pos := 1
            current := TV.GetNext()
            while (current && current != selected) {
                pos++
                current := TV.GetNext(current, "Full")
            }
            total := TV.GetCount()
            statusText.Value := "Position: " . pos . " / " . total . " - " . text
        }
    }

    UpdateStatus()

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 4: Breadth-First Traversal
;=============================================================================
; Demonstrates breadth-first tree traversal using queue

Example4_BreadthFirst() {
    myGui := Gui("+Resize", "Example 4: Breadth-First Traversal")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h350")

    ; Build hierarchical tree
    Root := TV.Add("Root")

    ; Level 1
    A := TV.Add("A", Root)
    B := TV.Add("B", Root)
    C := TV.Add("C", Root)

    ; Level 2
    TV.Add("A1", A)
    TV.Add("A2", A)
    TV.Add("B1", B)
    TV.Add("B2", B)
    TV.Add("B3", B)
    TV.Add("C1", C)

    ; Level 3
    A1 := TV.GetChild(A)
    TV.Add("A1a", A1)
    TV.Add("A1b", A1)

    ExpandAll(TV, Root)

    ; Output area
    outputEdit := myGui.Add("Edit", "xm y+10 w500 h200 ReadOnly")

    ; Traversal buttons
    bfsBtn := myGui.Add("Button", "xm y+10 w150", "Breadth-First")
    bfsBtn.OnEvent("Click", DoBreadthFirst)

    dfsBtn := myGui.Add("Button", "x+10 yp w150", "Depth-First")
    dfsBtn.OnEvent("Click", DoDepthFirst)

    levelOrderBtn := myGui.Add("Button", "x+10 yp w150", "Level Order")
    levelOrderBtn.OnEvent("Click", DoLevelOrder)

    DoBreadthFirst(*) {
        output := "Breadth-First Traversal:`n"
        output .= BreadthFirstTraverse(TV, Root)
        outputEdit.Value := output
    }

    DoDepthFirst(*) {
        output := "Depth-First Traversal:`n"
        output .= DepthFirstTraverse(TV, Root)
        outputEdit.Value := output
    }

    DoLevelOrder(*) {
        output := "Level Order Traversal:`n"
        output .= LevelOrderTraverse(TV, Root)
        outputEdit.Value := output
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

; Breadth-first traversal using queue
BreadthFirstTraverse(TV, RootID) {
    output := ""
    queue := [RootID]

    while (queue.Length > 0) {
        currentID := queue.RemoveAt(1)
        output .= TV.GetText(currentID) . "`n"

        ; Add all children to queue
        childID := TV.GetChild(currentID)
        while (childID) {
            queue.Push(childID)
            childID := TV.GetNext(childID)
        }
    }

    return output
}

; Depth-first traversal (recursive)
DepthFirstTraverse(TV, NodeID, depth := 0) {
    output := StrRepeat("  ", depth) . TV.GetText(NodeID) . "`n"

    childID := TV.GetChild(NodeID)
    while (childID) {
        output .= DepthFirstTraverse(TV, childID, depth + 1)
        childID := TV.GetNext(childID)
    }

    return output
}

; Level order with level indicators
LevelOrderTraverse(TV, RootID) {
    output := ""
    queue := [[RootID, 0]]  ; [NodeID, Level]

    currentLevel := -1
    while (queue.Length > 0) {
        item := queue.RemoveAt(1)
        nodeID := item[1]
        level := item[2]

        if (level != currentLevel) {
            output .= "`n--- Level " . level . " ---`n"
            currentLevel := level
        }

        output .= TV.GetText(nodeID) . "`n"

        ; Add children with incremented level
        childID := TV.GetChild(nodeID)
        while (childID) {
            queue.Push([childID, level + 1])
            childID := TV.GetNext(childID)
        }
    }

    return output
}

; Helper: Repeat string
StrRepeat(str, count) {
    result := ""
    Loop count
        result .= str
    return result
}

;=============================================================================
; EXAMPLE 5: Smart Navigation System
;=============================================================================
; Advanced navigation with history and bookmarks

Example5_SmartNavigation() {
    myGui := Gui("+Resize", "Example 5: Smart Navigation System")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h350")

    ; Build sample tree
    Root := BuildSampleTree(TV)
    ExpandAll(TV, Root)

    ; Navigation state
    history := []
    historyPos := 0
    bookmarks := Map()

    ; Controls
    myGui.Add("Text", "xm y+10", "Navigation:")

    backBtn := myGui.Add("Button", "xm y+5 w100", "← Back")
    backBtn.OnEvent("Click", GoBack)

    forwardBtn := myGui.Add("Button", "x+5 yp w100", "Forward →")
    forwardBtn.OnEvent("Click", GoForward)

    bookmarkBtn := myGui.Add("Button", "x+5 yp w100", "Bookmark")
    bookmarkBtn.OnEvent("Click", AddBookmark)

    showBookmarksBtn := myGui.Add("Button", "x+5 yp w100", "Show Bookmarks")
    showBookmarksBtn.OnEvent("Click", ShowBookmarks)

    ; Status
    statusText := myGui.Add("Text", "xm y+20 w500", "")

    ; Track selection changes
    TV.OnEvent("ItemSelect", OnSelect)

    OnSelect(*) {
        if (selected := TV.GetSelection()) {
            ; Add to history
            if (historyPos < history.Length) {
                ; Remove forward history
                history.Length := historyPos
            }
            history.Push(selected)
            historyPos := history.Length

            UpdateStatus()
        }
    }

    GoBack(*) {
        if (historyPos > 1) {
            historyPos--
            itemID := history[historyPos]
            TV.OnEvent("ItemSelect", "")  ; Temporarily disable
            TV.Modify(itemID, "Select Vis")
            TV.OnEvent("ItemSelect", OnSelect)  ; Re-enable
            UpdateStatus()
        }
    }

    GoForward(*) {
        if (historyPos < history.Length) {
            historyPos++
            itemID := history[historyPos]
            TV.OnEvent("ItemSelect", "")
            TV.Modify(itemID, "Select Vis")
            TV.OnEvent("ItemSelect", OnSelect)
            UpdateStatus()
        }
    }

    AddBookmark(*) {
        if (selected := TV.GetSelection()) {
            name := TV.GetText(selected)
            bookmarks[name] := selected
            MsgBox("Bookmarked: " . name, "Bookmark Added", 64)
        }
    }

    ShowBookmarks(*) {
        if (bookmarks.Count = 0) {
            MsgBox("No bookmarks saved", "Bookmarks", 64)
            return
        }

        list := "Saved Bookmarks:`n`n"
        for name, itemID in bookmarks
            list .= "• " . name . "`n"

        MsgBox(list, "Bookmarks", 64)
    }

    UpdateStatus() {
        text := ""
        if (selected := TV.GetSelection())
            text := TV.GetText(selected)

        statusBar := "Current: " . text
        statusBar .= " | History: " . historyPos . "/" . history.Length
        statusBar .= " | Bookmarks: " . bookmarks.Count

        statusText.Value := statusBar
    }

    UpdateStatus()

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 6: Animated Expansion
;=============================================================================
; Shows animated/progressive tree expansion

Example6_AnimatedExpansion() {
    myGui := Gui("+Resize", "Example 6: Animated Expansion")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h400")

    ; Build tree
    Root := TV.Add("Root Node")

    Loop 5 {
        parent := TV.Add("Category " . A_Index, Root)
        Loop 8 {
            child := TV.Add("Item " . A_Index, parent)
            Loop 3 {
                TV.Add("Sub-item " . A_Index, child)
            }
        }
    }

    ; Animation controls
    myGui.Add("Text", "xm y+10", "Animation Controls:")

    animateExpandBtn := myGui.Add("Button", "xm y+5 w150", "Animated Expand All")
    animateExpandBtn.OnEvent("Click", AnimatedExpandAll)

    animateCollapseBtn := myGui.Add("Button", "x+10 yp w150", "Animated Collapse")
    animateCollapseBtn.OnEvent("Click", AnimatedCollapseAll)

    cascadeBtn := myGui.Add("Button", "x+10 yp w150", "Cascade Expand")
    cascadeBtn.OnEvent("Click", CascadeExpand)

    AnimatedExpandAll(*) {
        ; Expand nodes one by one with delay
        ExpandRecursiveAnimated(TV, Root, 50)
    }

    AnimatedCollapseAll(*) {
        ; Collapse from bottom up
        CollapseAnimated(TV, Root, 50)
    }

    CascadeExpand(*) {
        ; Expand level by level
        ExpandByLevel(TV, Root, 100)
    }

    ; Status
    statusText := myGui.Add("Text", "xm y+20 w500", "Click animation buttons to see effects")

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

; Animated recursive expansion
ExpandRecursiveAnimated(TV, NodeID, delay) {
    if (NodeID) {
        TV.Modify(NodeID, "Expand Vis")
        Sleep(delay)
    }

    childID := TV.GetChild(NodeID)
    while (childID) {
        ExpandRecursiveAnimated(TV, childID, delay)
        childID := TV.GetNext(childID)
    }
}

; Animated collapse
CollapseAnimated(TV, NodeID, delay) {
    ; First collapse children
    childID := TV.GetChild(NodeID)
    while (childID) {
        CollapseAnimated(TV, childID, delay)
        childID := TV.GetNext(childID)
    }

    ; Then collapse this node
    if (NodeID) {
        TV.Modify(NodeID, "-Expand")
        Sleep(delay)
    }
}

; Expand level by level
ExpandByLevel(TV, RootID, delay) {
    queue := [[RootID, 0]]
    currentLevel := -1

    while (queue.Length > 0) {
        item := queue.RemoveAt(1)
        nodeID := item[1]
        level := item[2]

        if (level != currentLevel) {
            currentLevel := level
            Sleep(delay * 2)  ; Longer pause between levels
        }

        TV.Modify(nodeID, "Expand")
        Sleep(delay)

        childID := TV.GetChild(nodeID)
        while (childID) {
            queue.Push([childID, level + 1])
            childID := TV.GetNext(childID)
        }
    }
}

;=============================================================================
; EXAMPLE 7: Navigation Performance Monitor
;=============================================================================
; Monitors and displays navigation performance metrics

Example7_PerformanceMonitor() {
    myGui := Gui("+Resize", "Example 7: Navigation Performance")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h300")

    ; Build large tree for performance testing
    Root := TV.Add("Performance Test Tree")

    Loop 50 {
        section := TV.Add("Section " . A_Index, Root)
        Loop 20 {
            TV.Add("Item " . A_Index, section)
        }
    }

    ; Metrics display
    metricsEdit := myGui.Add("Edit", "xm y+10 w500 h200 ReadOnly")

    ; Test buttons
    testExpandBtn := myGui.Add("Button", "xm y+10 w150", "Test Expand All")
    testExpandBtn.OnEvent("Click", TestExpandPerformance)

    testTraverseBtn := myGui.Add("Button", "x+10 yp w150", "Test Traversal")
    testTraverseBtn.OnEvent("Click", TestTraversalPerformance)

    testSearchBtn := myGui.Add("Button", "x+10 yp w150", "Test Search")
    testSearchBtn.OnEvent("Click", TestSearchPerformance)

    TestExpandPerformance(*) {
        start := A_TickCount
        ExpandAll(TV, Root)
        expandTime := A_TickCount - start

        start := A_TickCount
        CollapseAll(TV, Root)
        collapseTime := A_TickCount - start

        output := "EXPANSION PERFORMANCE:`n"
        output .= "Total nodes: " . TV.GetCount() . "`n"
        output .= "Expand all: " . expandTime . " ms`n"
        output .= "Collapse all: " . collapseTime . " ms`n"

        metricsEdit.Value := output
    }

    TestTraversalPerformance(*) {
        ; Test different traversal methods
        start := A_TickCount
        BreadthFirstTraverse(TV, Root)
        bfsTime := A_TickCount - start

        start := A_TickCount
        DepthFirstTraverse(TV, Root)
        dfsTime := A_TickCount - start

        output := "TRAVERSAL PERFORMANCE:`n"
        output .= "Total nodes: " . TV.GetCount() . "`n"
        output .= "Breadth-first: " . bfsTime . " ms`n"
        output .= "Depth-first: " . dfsTime . " ms`n"

        metricsEdit.Value := output
    }

    TestSearchPerformance(*) {
        searchTerm := "Item 10"

        start := A_TickCount
        found := FindInTreeForward(TV, TV.GetNext(), searchTerm)
        searchTime := A_TickCount - start

        output := "SEARCH PERFORMANCE:`n"
        output .= "Searching for: '" . searchTerm . "'`n"
        output .= "Search time: " . searchTime . " ms`n"
        output .= "Result: " . (found ? "Found" : "Not found") . "`n"

        metricsEdit.Value := output
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; REFERENCE SECTION
;=============================================================================
/*
NAVIGATION METHODS:
- TV.GetNext([ItemID, "Full"]) - Get next item (Full = all visible)
- TV.GetPrev(ItemID) - Get previous sibling
- TV.GetChild(ParentItemID) - Get first child
- TV.GetParent(ItemID) - Get parent item
- TV.GetSelection() - Get currently selected item
- TV.Modify(ItemID, "Vis") - Scroll item into view
- TV.Modify(ItemID, "Expand") - Expand item
- TV.Modify(ItemID, "-Expand") - Collapse item

TRAVERSAL STRATEGIES:
1. Depth-First (Recursive):
- Process node, then recursively process children
- Natural for hierarchical operations

2. Breadth-First (Queue):
- Process all nodes at current level
- Then move to next level
- Good for level-based operations

3. Level Order:
- Track depth while traversing
- Process nodes level by level

NAVIGATION BEST PRACTICES:
1. Use "Vis" option to ensure items are visible
2. Disable events during programmatic navigation
3. Store history for back/forward navigation
4. Cache frequently accessed nodes
5. Use progressive loading for large trees
6. Consider performance when traversing large trees

PERFORMANCE TIPS:
- GetNext() with "Full" is faster than recursive traversal
- Cache item IDs instead of searching repeatedly
- Batch operations when possible
- Use appropriate traversal method for task
- Disable redraw for bulk operations
*/

; Uncomment to run examples:
; Example1_ExpandCollapse()
; Example2_KeyboardNavigation()
; Example3_AutoScroll()
; Example4_BreadthFirst()
; Example5_SmartNavigation()
; Example6_AnimatedExpansion()
; Example7_PerformanceMonitor()

