#Requires AutoHotkey v2.0
/**
 * BuiltIn_TreeView_03_Selection.ahk
 *
 * DESCRIPTION:
 * Comprehensive guide to TreeView selection handling, including single and
 * multi-selection scenarios, selection events, and programmatic selection.
 *
 * FEATURES:
 * - Single item selection handling
 * - Multi-selection simulation with checkboxes
 * - Selection change events
 * - Programmatic selection
 * - Selection state persistence
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/TreeView.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - Event-driven programming
 * - Map data structures for state tracking
 * - Array manipulation for collections
 * - Function binding and callbacks
 *
 * LEARNING POINTS:
 * 1. TreeView natively supports single selection only
 * 2. Use checkboxes to simulate multi-selection
 * 3. ItemSelect event fires when selection changes
 * 4. Selection can be changed programmatically with Select option
 * 5. Vis option ensures selected item is scrolled into view
 */

;=============================================================================
; EXAMPLE 1: Basic Selection Handling
;=============================================================================
; Demonstrates fundamental selection operations and events

Example1_BasicSelection() {
    myGui := Gui("+Resize", "Example 1: Basic Selection")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h400")

    ; Build sample tree
    Root := TV.Add("Departments")

    Sales := TV.Add("Sales", Root)
    TV.Add("North Region", Sales)
    TV.Add("South Region", Sales)
    TV.Add("East Region", Sales)
    TV.Add("West Region", Sales)

    Engineering := TV.Add("Engineering", Root)
    TV.Add("Frontend Team", Engineering)
    TV.Add("Backend Team", Engineering)
    TV.Add("DevOps Team", Engineering)

    HR := TV.Add("Human Resources", Root)
    TV.Add("Recruitment", HR)
    TV.Add("Training", HR)
    TV.Add("Benefits", HR)

    TV.Modify(Root, "Expand")

    ; Selection info display
    infoEdit := myGui.Add("Edit", "xm y+10 w500 h150 ReadOnly")

    ; Selection controls
    myGui.Add("Text", "xm y+10", "Selection Controls:")

    selectFirstBtn := myGui.Add("Button", "xm y+5 w120", "Select First")
    selectFirstBtn.OnEvent("Click", (*) => SelectFirst())

    selectLastBtn := myGui.Add("Button", "x+5 yp w120", "Select Last")
    selectLastBtn.OnEvent("Click", (*) => SelectLast())

    selectParentBtn := myGui.Add("Button", "x+5 yp w120", "Select Parent")
    selectParentBtn.OnEvent("Click", (*) => SelectParent())

    clearSelectionBtn := myGui.Add("Button", "x+5 yp w120", "Clear Selection")
    clearSelectionBtn.OnEvent("Click", (*) => ClearSelection())

    SelectFirst() {
        first := TV.GetNext()
        if (first) {
            TV.Modify(first, "Select Vis")
            UpdateInfo()
        }
    }

    SelectLast() {
        last := TV.GetNext()
        current := last
        while (current := TV.GetNext(current, "Full"))
            last := current
        if (last) {
            TV.Modify(last, "Select Vis")
            UpdateInfo()
        }
    }

    SelectParent() {
        if (selected := TV.GetSelection()) {
            if (parent := TV.GetParent(selected)) {
                TV.Modify(parent, "Select Vis")
                UpdateInfo()
            }
        }
    }

    ClearSelection() {
        ; TreeView always has a selection, so select root
        TV.Modify(Root, "Select")
        UpdateInfo()
    }

    ; Update info when selection changes
    TV.OnEvent("ItemSelect", (*) => UpdateInfo())

    UpdateInfo() {
        info := "SELECTION INFORMATION:`n`n"

        if (selected := TV.GetSelection()) {
            info .= "Selected Item: " . TV.GetText(selected) . "`n"

            ; Get parent info
            if (parent := TV.GetParent(selected))
                info .= "Parent: " . TV.GetText(parent) . "`n"
            else
                info .= "Parent: (None - Root Level)`n"

            ; Get children info
            childCount := 0
            child := TV.GetChild(selected)
            while (child) {
                childCount++
                child := TV.GetNext(child)
            }
            info .= "Children Count: " . childCount . "`n"

            ; Get path
            info .= "Full Path: " . GetNodePath(TV, selected) . "`n"

            ; Get position
            pos := GetNodePosition(TV, selected)
            total := TV.GetCount()
            info .= "Position: " . pos . " of " . total . "`n"

            ; Get properties
            info .= "`nProperties:`n"
            info .= "  Bold: " . (TV.Get(selected, "Bold") ? "Yes" : "No") . "`n"
            info .= "  Expanded: " . (TV.Get(selected, "Expand") ? "Yes" : "No") . "`n"
        } else {
            info .= "No item selected"
        }

        infoEdit.Value := info
    }

    UpdateInfo()

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

; Get full path from root to node
GetNodePath(TV, NodeID) {
    path := TV.GetText(NodeID)
    ParentID := TV.GetParent(NodeID)
    while (ParentID) {
        path := TV.GetText(ParentID) . " → " . path
        ParentID := TV.GetParent(ParentID)
    }
    return path
}

; Get position of node in tree (visible order)
GetNodePosition(TV, TargetID) {
    pos := 1
    current := TV.GetNext()
    while (current) {
        if (current = TargetID)
            return pos
        pos++
        current := TV.GetNext(current, "Full")
    }
    return 0
}

;=============================================================================
; EXAMPLE 2: Multi-Selection with Checkboxes
;=============================================================================
; Simulates multi-selection using TreeView checkbox feature

Example2_MultiSelection() {
    myGui := Gui("+Resize", "Example 2: Multi-Selection")

    ; Create TreeView with checkboxes
    TV := myGui.Add("TreeView", "w500 h400 Checked")

    ; Build sample tree
    Root := TV.Add("Project Tasks")

    Frontend := TV.Add("Frontend Development", Root)
    TV.Add("Create login page", Frontend)
    TV.Add("Design dashboard", Frontend)
    TV.Add("Implement navigation", Frontend)

    Backend := TV.Add("Backend Development", Root)
    TV.Add("Setup database", Backend)
    TV.Add("Create API endpoints", Backend)
    TV.Add("Implement authentication", Backend)

    Testing := TV.Add("Testing", Root)
    TV.Add("Unit tests", Testing)
    TV.Add("Integration tests", Testing)
    TV.Add("E2E tests", Testing)

    TV.Modify(Root, "Expand")

    ; Selection info
    infoEdit := myGui.Add("Edit", "xm y+10 w500 h120 ReadOnly")

    ; Multi-selection controls
    myGui.Add("Text", "xm y+10", "Multi-Selection Controls:")

    checkAllBtn := myGui.Add("Button", "xm y+5 w120", "Check All")
    checkAllBtn.OnEvent("Click", (*) => CheckAll(TV, Root, true))

    uncheckAllBtn := myGui.Add("Button", "x+5 yp w120", "Uncheck All")
    uncheckAllBtn.OnEvent("Click", (*) => CheckAll(TV, Root, false))

    checkChildrenBtn := myGui.Add("Button", "x+5 yp w120", "Check Children")
    checkChildrenBtn.OnEvent("Click", (*) => CheckChildren())

    invertBtn := myGui.Add("Button", "x+5 yp w120", "Invert Selection")
    invertBtn.OnEvent("Click", (*) => InvertChecks(TV, Root))

    getSelectedBtn := myGui.Add("Button", "xm y+5 w120", "Get Checked Items")
    getSelectedBtn.OnEvent("Click", (*) => ShowCheckedItems())

    CheckChildren() {
        if (selected := TV.GetSelection()) {
            CheckAll(TV, selected, true)
            UpdateInfo()
        }
    }

    ShowCheckedItems() {
        checked := GetCheckedItems(TV, Root)
        if (checked.Length = 0) {
            MsgBox("No items checked", "Info", 64)
            return
        }

        list := "Checked Items (" . checked.Length . "):`n`n"
        for itemID in checked
            list .= "• " . TV.GetText(itemID) . "`n"

        MsgBox(list, "Checked Items", 64)
    }

    ; Update info when check state changes
    TV.OnEvent("Click", (*) => UpdateInfo())

    UpdateInfo() {
        checked := GetCheckedItems(TV, Root)
        total := TV.GetCount()

        info := "Multi-Selection Status:`n"
        info .= "Total Items: " . total . "`n"
        info .= "Checked Items: " . checked.Length . "`n"
        info .= "Unchecked Items: " . (total - checked.Length) . "`n"
        info .= "`nLast Checked:`n"

        ; Show last 5 checked items
        count := Min(5, checked.Length)
        Loop count {
            itemID := checked[checked.Length - count + A_Index]
            info .= "  • " . TV.GetText(itemID) . "`n"
        }

        infoEdit.Value := info
    }

    UpdateInfo()

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

; Check/uncheck all nodes recursively
CheckAll(TV, NodeID, CheckState) {
    if (NodeID)
        TV.Modify(NodeID, CheckState ? "Check" : "-Check")

    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        CheckAll(TV, ChildID, CheckState)
        ChildID := TV.GetNext(ChildID)
    }
}

; Invert check state of all nodes
InvertChecks(TV, NodeID) {
    if (NodeID) {
        currentState := TV.Get(NodeID, "Check")
        TV.Modify(NodeID, currentState ? "-Check" : "Check")
    }

    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        InvertChecks(TV, ChildID)
        ChildID := TV.GetNext(ChildID)
    }
}

; Get all checked items
GetCheckedItems(TV, NodeID := 0) {
    checked := []

    if (NodeID && TV.Get(NodeID, "Check"))
        checked.Push(NodeID)

    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        checked.Push(GetCheckedItems(TV, ChildID)*)
        ChildID := TV.GetNext(ChildID)
    }

    return checked
}

;=============================================================================
; EXAMPLE 3: Selection Events and Callbacks
;=============================================================================
; Advanced event handling for selection changes

Example3_SelectionEvents() {
    myGui := Gui("+Resize", "Example 3: Selection Events")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h300")

    ; Build tree
    Root := TV.Add("Root")
    Loop 5 {
        category := TV.Add("Category " . A_Index, Root)
        Loop 5 {
            TV.Add("Item " . A_Index, category)
        }
    }
    TV.Modify(Root, "Expand")

    ; Event log
    eventLog := myGui.Add("Edit", "xm y+10 w500 h250 ReadOnly")

    ; Event tracking
    events := []
    maxEvents := 30
    lastSelected := 0
    selectionCount := 0

    ; Register multiple event handlers
    TV.OnEvent("ItemSelect", OnItemSelect)
    TV.OnEvent("Click", OnClick)
    TV.OnEvent("DoubleClick", OnDoubleClick)

    OnItemSelect(GuiCtrl, ItemID) {
        selectionCount++
        LogEvent("ItemSelect", ItemID)

        ; Track selection changes
        if (lastSelected != ItemID) {
            if (lastSelected)
                LogEvent("Deselected", lastSelected)
            lastSelected := ItemID
        }
    }

    OnClick(GuiCtrl, ItemID) {
        if (ItemID)
            LogEvent("Click", ItemID)
    }

    OnDoubleClick(GuiCtrl, ItemID) {
        if (ItemID) {
            LogEvent("DoubleClick", ItemID)
            ; Toggle expansion on double-click
            isExpanded := TV.Get(ItemID, "Expand")
            TV.Modify(ItemID, isExpanded ? "-Expand" : "Expand")
        }
    }

    LogEvent(eventType, ItemID) {
        timestamp := FormatTime(, "HH:mm:ss.") . SubStr(A_TickCount, -2)
        itemText := ItemID ? TV.GetText(ItemID) : "None"

        eventStr := timestamp . " | " . eventType . " | " . itemText

        events.Push(eventStr)

        ; Keep only recent events
        if (events.Length > maxEvents)
            events.RemoveAt(1)

        UpdateEventLog()
    }

    UpdateEventLog() {
        logText := "EVENT LOG (Total Selections: " . selectionCount . "):`n`n"
        for event in events
            logText .= event . "`n"

        eventLog.Value := logText
    }

    ; Control buttons
    clearLogBtn := myGui.Add("Button", "xm y+10 w100", "Clear Log")
    clearLogBtn.OnEvent("Click", ClearLog)

    ClearLog(*) {
        events := []
        selectionCount := 0
        UpdateEventLog()
    }

    closeBtn := myGui.Add("Button", "x+10 yp w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 4: Programmatic Selection
;=============================================================================
; Demonstrates selecting items programmatically with various criteria

Example4_ProgrammaticSelection() {
    myGui := Gui("+Resize", "Example 4: Programmatic Selection")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h350")

    ; Build tree with categorized items
    Root := TV.Add("Products")

    Electronics := TV.Add("Electronics", Root)
    TV.Add("Laptop - $999", Electronics)
    TV.Add("Phone - $699", Electronics)
    TV.Add("Tablet - $399", Electronics)

    Clothing := TV.Add("Clothing", Root)
    TV.Add("Shirt - $29", Clothing)
    TV.Add("Pants - $49", Clothing)
    TV.Add("Jacket - $89", Clothing)

    Books := TV.Add("Books", Root)
    TV.Add("Fiction - $15", Books)
    TV.Add("Science - $35", Books)
    TV.Add("History - $25", Books)

    TV.Modify(Root, "Expand")

    ; Selection controls
    myGui.Add("Text", "xm y+10", "Programmatic Selection:")

    selectByTextBtn := myGui.Add("Button", "xm y+5 w120", "Select 'Phone'")
    selectByTextBtn.OnEvent("Click", (*) => SelectByText("Phone"))

    selectRandomBtn := myGui.Add("Button", "x+5 yp w120", "Select Random")
    selectRandomBtn.OnEvent("Click", (*) => SelectRandom())

    selectNextMatchBtn := myGui.Add("Button", "x+5 yp w120", "Next with '$'")
    selectNextMatchBtn.OnEvent("Click", (*) => SelectNextMatching("$"))

    selectDeepestBtn := myGui.Add("Button", "x+5 yp w120", "Select Deepest")
    selectDeepestBtn.OnEvent("Click", (*) => SelectDeepest())

    ; Pattern-based selection
    myGui.Add("Text", "xm y+10", "Search Pattern:")
    searchInput := myGui.Add("Edit", "x+10 yp-3 w200")
    searchBtn := myGui.Add("Button", "x+5 yp-0 w100", "Find & Select")
    searchBtn.OnEvent("Click", SearchAndSelect)

    SelectByText(searchText) {
        found := FindNodeByText(TV, Root, searchText)
        if (found) {
            TV.Modify(found, "Select Vis")
            MsgBox("Found and selected: " . TV.GetText(found), "Success", 64)
        } else {
            MsgBox("Not found: " . searchText, "Info", 64)
        }
    }

    SelectRandom() {
        items := CollectAllItems(TV, Root)
        if (items.Length > 0) {
            randomItem := items[Random(1, items.Length)]
            TV.Modify(randomItem, "Select Vis")
        }
    }

    SelectNextMatching(pattern) {
        current := TV.GetSelection()
        if (!current)
            current := TV.GetNext()

        ; Search forward from current
        startItem := current
        Loop {
            current := TV.GetNext(current, "Full")
            if (!current)
                current := TV.GetNext()  ; Wrap around

            if (current = startItem)
                break

            if (InStr(TV.GetText(current), pattern)) {
                TV.Modify(current, "Select Vis")
                return
            }
        }

        MsgBox("No more items matching: " . pattern, "Info", 64)
    }

    SelectDeepest() {
        deepest := FindDeepestNode(TV, Root)
        if (deepest.itemID) {
            TV.Modify(deepest.itemID, "Select Vis")
            MsgBox("Deepest item at level " . deepest.depth . ": " . TV.GetText(deepest.itemID), "Info", 64)
        }
    }

    SearchAndSelect(*) {
        pattern := searchInput.Value
        if (!pattern) {
            MsgBox("Please enter a search pattern", "Info", 64)
            return
        }

        found := FindNodeByText(TV, Root, pattern)
        if (found) {
            TV.Modify(found, "Select Vis")
            searchInput.Value := ""
        } else {
            MsgBox("Not found: " . pattern, "Info", 64)
        }
    }

    ; Status
    statusText := myGui.Add("Text", "xm y+20 w500", "")
    TV.OnEvent("ItemSelect", UpdateStatus)

    UpdateStatus(*) {
        if (selected := TV.GetSelection())
            statusText.Value := "Selected: " . TV.GetText(selected)
    }

    UpdateStatus()

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

; Find node by text
FindNodeByText(TV, NodeID, SearchText) {
    if (NodeID && InStr(TV.GetText(NodeID), SearchText))
        return NodeID

    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        if (found := FindNodeByText(TV, ChildID, SearchText))
            return found
        ChildID := TV.GetNext(ChildID)
    }
    return 0
}

; Collect all items in array
CollectAllItems(TV, NodeID := 0) {
    items := []

    if (NodeID)
        items.Push(NodeID)

    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        items.Push(CollectAllItems(TV, ChildID)*)
        ChildID := TV.GetNext(ChildID)
    }

    return items
}

; Find deepest node
FindDeepestNode(TV, NodeID, CurrentDepth := 0) {
    deepest := {itemID: NodeID, depth: CurrentDepth}

    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        childDeepest := FindDeepestNode(TV, ChildID, CurrentDepth + 1)
        if (childDeepest.depth > deepest.depth)
            deepest := childDeepest
        ChildID := TV.GetNext(ChildID)
    }

    return deepest
}

;=============================================================================
; EXAMPLE 5: Selection State Persistence
;=============================================================================
; Saving and restoring selection state

Example5_StatePersistence() {
    myGui := Gui("+Resize", "Example 5: Selection State Persistence")

    ; Create TreeView with checkboxes
    TV := myGui.Add("TreeView", "w500 h400 Checked")

    ; Build tree
    Root := TV.Add("My Tree")
    Loop 4 {
        category := TV.Add("Category " . A_Index, Root)
        Loop 6 {
            TV.Add("Item " . A_Index, category)
        }
    }
    TV.Modify(Root, "Expand")

    ; State storage
    savedStates := Map()
    currentStateName := ""

    ; Controls
    myGui.Add("Text", "xm y+10", "State Name:")
    stateNameInput := myGui.Add("Edit", "x+10 yp-3 w200")

    saveStateBtn := myGui.Add("Button", "xm y+10 w120", "Save State")
    saveStateBtn.OnEvent("Click", SaveState)

    loadStateBtn := myGui.Add("Button", "x+5 yp w120", "Load State")
    loadStateBtn.OnEvent("Click", LoadState)

    listStatesBtn := myGui.Add("Button", "x+5 yp w120", "List States")
    listStatesBtn.OnEvent("Click", ListStates)

    deleteStateBtn := myGui.Add("Button", "x+5 yp w120", "Delete State")
    deleteStateBtn.OnEvent("Click", DeleteState)

    SaveState(*) {
        stateName := stateNameInput.Value
        if (!stateName) {
            MsgBox("Please enter a state name", "Info", 64)
            return
        }

        ; Capture current state
        state := {
            selected: TV.GetSelection(),
            expanded: [],
            checked: []
        }

        ; Collect expanded nodes
        CollectExpandedNodes(TV, Root, state.expanded)

        ; Collect checked nodes
        state.checked := GetCheckedItems(TV, Root)

        savedStates[stateName] := state
        currentStateName := stateName

        MsgBox("State saved: " . stateName, "Success", 64)
        stateNameInput.Value := ""
    }

    LoadState(*) {
        stateName := stateNameInput.Value
        if (!stateName) {
            MsgBox("Please enter a state name", "Info", 64)
            return
        }

        if (!savedStates.Has(stateName)) {
            MsgBox("State not found: " . stateName, "Error", 16)
            return
        }

        state := savedStates[stateName]

        ; Restore expanded state
        CollapseAll(TV, Root)
        for itemID in state.expanded
            TV.Modify(itemID, "Expand")

        ; Restore checked state
        CheckAll(TV, Root, false)
        for itemID in state.checked
            TV.Modify(itemID, "Check")

        ; Restore selection
        if (state.selected)
            TV.Modify(state.selected, "Select Vis")

        currentStateName := stateName
        MsgBox("State loaded: " . stateName, "Success", 64)
        stateNameInput.Value := ""
    }

    ListStates(*) {
        if (savedStates.Count = 0) {
            MsgBox("No saved states", "Info", 64)
            return
        }

        list := "Saved States:`n`n"
        for stateName, state in savedStates {
            list .= "• " . stateName
            if (stateName = currentStateName)
                list .= " (current)"
            list .= "`n"
        }

        MsgBox(list, "Saved States", 64)
    }

    DeleteState(*) {
        stateName := stateNameInput.Value
        if (!stateName) {
            MsgBox("Please enter a state name", "Info", 64)
            return
        }

        if (savedStates.Has(stateName)) {
            savedStates.Delete(stateName)
            if (currentStateName = stateName)
                currentStateName := ""
            MsgBox("State deleted: " . stateName, "Success", 64)
            stateNameInput.Value := ""
        } else {
            MsgBox("State not found: " . stateName, "Error", 16)
        }
    }

    ; Status
    statusText := myGui.Add("Text", "xm y+20 w500", "")

    UpdateStatus() {
        status := "Current State: " . (currentStateName ? currentStateName : "None")
        status .= " | Saved States: " . savedStates.Count
        statusText.Value := status
    }

    saveStateBtn.OnEvent("Click", (*) => (SetTimer(UpdateStatus, -100), ""))
    loadStateBtn.OnEvent("Click", (*) => (SetTimer(UpdateStatus, -100), ""))
    deleteStateBtn.OnEvent("Click", (*) => (SetTimer(UpdateStatus, -100), ""))

    UpdateStatus()

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

; Collect expanded nodes
CollectExpandedNodes(TV, NodeID, expandedArray) {
    if (NodeID && TV.Get(NodeID, "Expand"))
        expandedArray.Push(NodeID)

    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        CollectExpandedNodes(TV, ChildID, expandedArray)
        ChildID := TV.GetNext(ChildID)
    }
}

; Collapse all nodes
CollapseAll(TV, NodeID) {
    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        CollapseAll(TV, ChildID)
        TV.Modify(ChildID, "-Expand")
        ChildID := TV.GetNext(ChildID)
    }
}

;=============================================================================
; EXAMPLE 6: Advanced Selection Patterns
;=============================================================================
; Complex selection scenarios and patterns

Example6_AdvancedPatterns() {
    myGui := Gui("+Resize", "Example 6: Advanced Selection Patterns")

    ; Create TreeView with checkboxes
    TV := myGui.Add("TreeView", "w500 h350 Checked")

    ; Build tree
    Root := TV.Add("Projects")

    Loop 5 {
        project := TV.Add("Project " . A_Index, Root)
        Loop 4 {
            phase := TV.Add("Phase " . A_Index, project)
            Loop 3 {
                TV.Add("Task " . A_Index, phase)
            }
        }
    }

    TV.Modify(Root, "Expand")

    ; Controls
    myGui.Add("Text", "xm y+10", "Selection Patterns:")

    selectLeavesBtn := myGui.Add("Button", "xm y+5 w120", "Select Leaves")
    selectLeavesBtn.OnEvent("Click", (*) => SelectLeaves())

    selectParentsBtn := myGui.Add("Button", "x+5 yp w120", "Select Parents")
    selectParentsBtn.OnEvent("Click", (*) => SelectParents())

    selectLevelBtn := myGui.Add("Button", "x+5 yp w120", "Select Level 2")
    selectLevelBtn.OnEvent("Click", (*) => SelectLevel(2))

    selectSiblingsBtn := myGui.Add("Button", "x+5 yp w120", "Select Siblings")
    selectSiblingsBtn.OnEvent("Click", (*) => SelectSiblings())

    ; Pattern functions
    SelectLeaves() {
        CheckAll(TV, Root, false)
        CheckLeafNodes(TV, Root)
        MsgBox("Selected all leaf nodes (items without children)", "Info", 64)
    }

    SelectParents() {
        CheckAll(TV, Root, false)
        CheckParentNodes(TV, Root)
        MsgBox("Selected all parent nodes (items with children)", "Info", 64)
    }

    SelectLevel(level) {
        CheckAll(TV, Root, false)
        CheckNodesAtLevel(TV, Root, level)
        MsgBox("Selected all nodes at level " . level, "Info", 64)
    }

    SelectSiblings() {
        if (selected := TV.GetSelection()) {
            CheckAll(TV, Root, false)
            parent := TV.GetParent(selected)

            ; Check all siblings
            sibling := TV.GetChild(parent)
            while (sibling) {
                TV.Modify(sibling, "Check")
                sibling := TV.GetNext(sibling)
            }

            MsgBox("Selected all siblings of current item", "Info", 64)
        }
    }

    ; Info display
    infoText := myGui.Add("Text", "xm y+20 w500", "")

    UpdateInfo() {
        checked := GetCheckedItems(TV, Root)
        infoText.Value := "Checked Items: " . checked.Length . " / " . TV.GetCount()
    }

    TV.OnEvent("Click", (*) => UpdateInfo())
    UpdateInfo()

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

; Check only leaf nodes
CheckLeafNodes(TV, NodeID) {
    if (NodeID) {
        if (!TV.GetChild(NodeID))
            TV.Modify(NodeID, "Check")
    }

    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        CheckLeafNodes(TV, ChildID)
        ChildID := TV.GetNext(ChildID)
    }
}

; Check only parent nodes
CheckParentNodes(TV, NodeID) {
    if (NodeID) {
        if (TV.GetChild(NodeID))
            TV.Modify(NodeID, "Check")
    }

    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        CheckParentNodes(TV, ChildID)
        ChildID := TV.GetNext(ChildID)
    }
}

; Check nodes at specific level
CheckNodesAtLevel(TV, NodeID, TargetLevel, CurrentLevel := 0) {
    if (NodeID && CurrentLevel = TargetLevel)
        TV.Modify(NodeID, "Check")

    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        CheckNodesAtLevel(TV, ChildID, TargetLevel, CurrentLevel + 1)
        ChildID := TV.GetNext(ChildID)
    }
}

;=============================================================================
; EXAMPLE 7: Selection Performance Analyzer
;=============================================================================
; Analyzes selection performance in large trees

Example7_SelectionPerformance() {
    myGui := Gui("+Resize", "Example 7: Selection Performance")

    ; Create large TreeView
    TV := myGui.Add("TreeView", "w500 h300 Checked")

    ; Build large tree
    Root := TV.Add("Large Tree")
    Loop 30 {
        category := TV.Add("Category " . A_Index, Root)
        Loop 30 {
            TV.Add("Item " . A_Index, category)
        }
    }

    ; Results display
    resultsEdit := myGui.Add("Edit", "xm y+10 w500 h250 ReadOnly")

    ; Performance tests
    testSelectBtn := myGui.Add("Button", "xm y+10 w150", "Test Selection Speed")
    testSelectBtn.OnEvent("Click", TestSelection)

    testCheckBtn := myGui.Add("Button", "x+10 yp w150", "Test Check Speed")
    testCheckBtn.OnEvent("Click", TestChecking)

    testSearchBtn := myGui.Add("Button", "x+10 yp w150", "Test Search Speed")
    testSearchBtn.OnEvent("Click", TestSearch)

    TestSelection(*) {
        total := TV.GetCount()

        ; Test sequential selection
        start := A_TickCount
        current := TV.GetNext()
        Loop 100 {
            if (!current)
                current := TV.GetNext()
            TV.Modify(current, "Select")
            current := TV.GetNext(current, "Full")
        }
        selectTime := A_TickCount - start

        ; Test random selection
        items := CollectAllItems(TV, Root)
        start := A_TickCount
        Loop 100 {
            randomItem := items[Random(1, items.Length)]
            TV.Modify(randomItem, "Select")
        }
        randomTime := A_TickCount - start

        results := "SELECTION PERFORMANCE:`n"
        results .= "Total items: " . total . "`n`n"
        results .= "Sequential selection (100): " . selectTime . " ms`n"
        results .= "Random selection (100): " . randomTime . " ms`n"
        results .= "Avg per selection: " . Round(randomTime/100, 2) . " ms`n"

        resultsEdit.Value := results
    }

    TestChecking(*) {
        total := TV.GetCount()

        ; Test check all
        start := A_TickCount
        CheckAll(TV, Root, true)
        checkTime := A_TickCount - start

        ; Test uncheck all
        start := A_TickCount
        CheckAll(TV, Root, false)
        uncheckTime := A_TickCount - start

        ; Test get checked items
        CheckAll(TV, Root, true)
        start := A_TickCount
        checked := GetCheckedItems(TV, Root)
        getTime := A_TickCount - start

        results := "CHECKING PERFORMANCE:`n"
        results .= "Total items: " . total . "`n`n"
        results .= "Check all: " . checkTime . " ms`n"
        results .= "Uncheck all: " . uncheckTime . " ms`n"
        results .= "Get checked items: " . getTime . " ms`n"
        results .= "Checked count: " . checked.Length . "`n"

        resultsEdit.Value := results
    }

    TestSearch(*) {
        total := TV.GetCount()

        ; Test find by text
        searchTerm := "Item 15"
        start := A_TickCount
        found := FindNodeByText(TV, Root, searchTerm)
        searchTime := A_TickCount - start

        ; Test collect all items
        start := A_TickCount
        items := CollectAllItems(TV, Root)
        collectTime := A_TickCount - start

        results := "SEARCH PERFORMANCE:`n"
        results .= "Total items: " . total . "`n`n"
        results .= "Find by text: " . searchTime . " ms`n"
        results .= "Collect all items: " . collectTime . " ms`n"
        results .= "Items collected: " . items.Length . "`n"

        resultsEdit.Value := results
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; REFERENCE SECTION
;=============================================================================
/*
SELECTION METHODS:
- TV.GetSelection() - Get currently selected item ID
- TV.Modify(ItemID, "Select") - Select an item
- TV.Modify(ItemID, "Select Vis") - Select and scroll into view
- TV.Get(ItemID, "Check") - Get check state
- TV.Modify(ItemID, "Check") - Check an item
- TV.Modify(ItemID, "-Check") - Uncheck an item

SELECTION EVENTS:
- ItemSelect - Fires when selection changes
- Click - Fires on single click
- DoubleClick - Fires on double click

MULTI-SELECTION SIMULATION:
- Use Checked TreeView style
- Track checked items manually
- Provide check/uncheck all functionality
- Use GetCheckedItems() helper function

SELECTION BEST PRACTICES:
1. Always check if GetSelection() returns valid ID
2. Use "Vis" option to ensure visibility
3. Disable events during programmatic selection
4. Cache selection state when needed
5. Use checkboxes for multi-selection scenarios

PERFORMANCE CONSIDERATIONS:
- Selection is O(1) operation
- Checking/unchecking is O(1) per item
- Finding checked items requires tree traversal
- Cache frequently accessed selections
- Batch selection operations when possible
*/

; Uncomment to run examples:
; Example1_BasicSelection()
; Example2_MultiSelection()
; Example3_SelectionEvents()
; Example4_ProgrammaticSelection()
; Example5_StatePersistence()
; Example6_AdvancedPatterns()
; Example7_SelectionPerformance()
