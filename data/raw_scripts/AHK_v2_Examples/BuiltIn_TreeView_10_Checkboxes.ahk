#Requires AutoHotkey v2.0
/**
 * BuiltIn_TreeView_10_Checkboxes.ahk
 *
 * DESCRIPTION:
 * Demonstrates using TreeView controls with checkboxes for multi-selection,
 * tri-state logic, cascading checks, and checkbox-based operations.
 *
 * FEATURES:
 * - Creating TreeView with checkboxes
 * - Checking and unchecking nodes
 * - Tri-state checkbox logic
 * - Cascading check/uncheck (parent-child)
 * - Getting all checked items
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/TreeView.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - Checked TreeView style
 * - Check state management
 * - Recursive checkbox operations
 * - Event handling for checkboxes
 *
 * LEARNING POINTS:
 * 1. Use "Checked" option to enable checkboxes
 * 2. Check state accessed via TV.Get(ID, "Check")
 * 3. Set check with TV.Modify(ID, "Check") or "-Check"
 * 4. Implement custom tri-state logic
 * 5. Cascade checks to maintain consistency
 */

;=============================================================================
; EXAMPLE 1: Basic Checkboxes
;=============================================================================
; Simple TreeView with checkbox functionality

Example1_BasicCheckboxes() {
    myGui := Gui("+Resize", "Example 1: Basic Checkboxes")
    
    ; Create TreeView with Checked style
    TV := myGui.Add("TreeView", "w600 h450 Checked")
    
    ; Build tree
    Root := TV.Add("Features")
    
    Feature1 := TV.Add("Feature 1", Root)
    TV.Add("Sub-feature 1A", Feature1)
    TV.Add("Sub-feature 1B", Feature1)
    
    Feature2 := TV.Add("Feature 2", Root)
    TV.Add("Sub-feature 2A", Feature2)
    TV.Add("Sub-feature 2B", Feature2)
    TV.Add("Sub-feature 2C", Feature2)
    
    Feature3 := TV.Add("Feature 3", Root)
    
    TV.Modify(Root, "Expand")
    
    ; Buttons for checkbox operations
    checkAllBtn := myGui.Add("Button", "xm y+10 w120", "Check All")
    checkAllBtn.OnEvent("Click", (*) => CheckAll(TV, Root, true))
    
    uncheckAllBtn := myGui.Add("Button", "x+10 yp w120", "Uncheck All")
    uncheckAllBtn.OnEvent("Click", (*) => CheckAll(TV, Root, false))
    
    getCheckedBtn := myGui.Add("Button", "x+10 yp w120", "Get Checked")
    getCheckedBtn.OnEvent("Click", ShowChecked)
    
    ShowChecked(*) {
        checked := []
        GetCheckedItems(TV, Root, checked)
        
        if (checked.Length = 0) {
            MsgBox("No items checked", "Info", 64)
            return
        }
        
        list := "Checked Items:`n`n"
        for item in checked
            list .= "• " . TV.GetText(item) . "`n"
        
        MsgBox(list, "Checked Items", 64)
    }
    
    ; Status display
    statusText := myGui.Add("Text", "xm y+10 w600", "")
    
    ; Update status on click
    TV.OnEvent("Click", UpdateStatus)
    
    UpdateStatus(*) {
        checked := []
        GetCheckedItems(TV, Root, checked)
        total := TV.GetCount()
        statusText.Value := "Checked: " . checked.Length . " / " . total
    }
    
    UpdateStatus()
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())
    
    myGui.Show()
}

; Recursively check/uncheck all nodes
CheckAll(TV, nodeID, state) {
    if (nodeID)
        TV.Modify(nodeID, state ? "Check" : "-Check")
    
    child := TV.GetChild(nodeID)
    while (child) {
        CheckAll(TV, child, state)
        child := TV.GetNext(child)
    }
}

; Get all checked items
GetCheckedItems(TV, nodeID, &checked) {
    if (nodeID && TV.Get(nodeID, "Check"))
        checked.Push(nodeID)
    
    child := TV.GetChild(nodeID)
    while (child) {
        GetCheckedItems(TV, child, &checked)
        child := TV.GetNext(child)
    }
}

;=============================================================================
; EXAMPLE 2: Cascading Checkboxes
;=============================================================================
; Checking parent checks all children, and vice versa

Example2_CascadingChecks() {
    myGui := Gui("+Resize", "Example 2: Cascading Checkboxes")
    
    ; Create TreeView with checkboxes
    TV := myGui.Add("TreeView", "w600 h450 Checked")
    
    ; Build tree
    Root := TV.Add("Project Tasks")
    
    Phase1 := TV.Add("Phase 1: Planning", Root)
    TV.Add("Research", Phase1)
    TV.Add("Design", Phase1)
    TV.Add("Approval", Phase1)
    
    Phase2 := TV.Add("Phase 2: Development", Root)
    TV.Add("Frontend", Phase2)
    TV.Add("Backend", Phase2)
    TV.Add("Testing", Phase2)
    
    Phase3 := TV.Add("Phase 3: Deployment", Root)
    TV.Add("Staging", Phase3)
    TV.Add("Production", Phase3)
    
    TV.Modify(Root, "Expand")
    
    ; Handle checkbox clicks with cascading
    TV.OnEvent("Click", OnCheckChange)
    
    OnCheckChange(GuiCtrl, ItemID) {
        if (!ItemID)
            return
        
        ; Small delay to let checkbox state update
        Sleep(50)
        
        isChecked := TV.Get(ItemID, "Check")
        
        ; Cascade to children
        CascadeToChildren(TV, ItemID, isChecked)
        
        ; Update parent state
        UpdateParentState(TV, ItemID)
        
        UpdateStatus()
    }
    
    CascadeToChildren(TV, nodeID, state) {
        child := TV.GetChild(nodeID)
        while (child) {
            TV.Modify(child, state ? "Check" : "-Check")
            CascadeToChildren(TV, child, state)
            child := TV.GetNext(child)
        }
    }
    
    UpdateParentState(TV, nodeID) {
        parent := TV.GetParent(nodeID)
        if (!parent)
            return
        
        ; Check if all siblings are checked
        allChecked := true
        anyChecked := false
        
        sibling := TV.GetChild(parent)
        while (sibling) {
            if (TV.Get(sibling, "Check"))
                anyChecked := true
            else
                allChecked := false
            sibling := TV.GetNext(sibling)
        }
        
        ; Update parent check state
        if (allChecked)
            TV.Modify(parent, "Check")
        else
            TV.Modify(parent, "-Check")
        
        ; Recurse up the tree
        UpdateParentState(TV, parent)
    }
    
    ; Status
    statusText := myGui.Add("Text", "xm y+10 w600", "")
    
    UpdateStatus() {
        checked := []
        GetCheckedItems(TV, Root, &checked)
        statusText.Value := "Checked Items: " . checked.Length . " | Click parent to check/uncheck all children"
    }
    
    UpdateStatus()
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())
    
    myGui.Show()
}

;=============================================================================
; EXAMPLE 3: Tri-State Checkboxes
;=============================================================================
; Implement tri-state logic (checked, unchecked, indeterminate)

Example3_TriState() {
    myGui := Gui("+Resize", "Example 3: Tri-State Checkboxes")
    
    ; Create TreeView
    TV := myGui.Add("TreeView", "w600 h400 Checked")
    
    ; Build tree
    Root := TV.Add("Permissions")
    
    FilePerms := TV.Add("File Operations", Root)
    TV.Add("Read", FilePerms)
    TV.Add("Write", FilePerms)
    TV.Add("Delete", FilePerms)
    
    NetworkPerms := TV.Add("Network Operations", Root)
    TV.Add("Internet Access", NetworkPerms)
    TV.Add("Local Network", NetworkPerms)
    
    SystemPerms := TV.Add("System Operations", Root)
    TV.Add("Registry Access", SystemPerms)
    TV.Add("Process Control", SystemPerms)
    
    TV.Modify(Root, "Expand")
    
    ; Track tri-state (using Bold for indeterminate)
    TV.OnEvent("Click", OnCheckClick)
    
    OnCheckClick(GuiCtrl, ItemID) {
        if (!ItemID || !TV.GetChild(ItemID))
            return
        
        Sleep(50)
        UpdateTriState(TV, ItemID)
    }
    
    UpdateTriState(TV, parentID) {
        checkedCount := 0
        totalCount := 0
        
        child := TV.GetChild(parentID)
        while (child) {
            totalCount++
            if (TV.Get(child, "Check"))
                checkedCount++
            child := TV.GetNext(child)
        }
        
        ; Set tri-state visual
        if (checkedCount = 0) {
            ; All unchecked
            TV.Modify(parentID, "-Check")
            TV.Modify(parentID, "-Bold")
        } else if (checkedCount = totalCount) {
            ; All checked
            TV.Modify(parentID, "Check")
            TV.Modify(parentID, "-Bold")
        } else {
            ; Indeterminate (use Bold as indicator)
            TV.Modify(parentID, "Check")
            TV.Modify(parentID, "Bold")
        }
        
        UpdateStatus(checkedCount, totalCount)
    }
    
    ; Status with legend
    legendText := myGui.Add("Text", "xm y+10 w600",
        "Legend: Normal = All checked | Unchecked = None | Bold + Checked = Some")
    
    statusText := myGui.Add("Text", "xm y+5 w600", "")
    
    UpdateStatus(checked, total) {
        if (checked = 0)
            state := "None"
        else if (checked = total)
            state := "All"
        else
            state := "Some (" . checked . "/" . total . ")"
        
        statusText.Value := "Status: " . state
    }
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())
    
    myGui.Show()
}

;=============================================================================
; EXAMPLE 4: Checkbox-Based Selection
;=============================================================================
; Use checkboxes for multi-selection and batch operations

Example4_CheckboxSelection() {
    myGui := Gui("+Resize", "Example 4: Checkbox Selection")
    
    ; Create TreeView
    TV := myGui.Add("TreeView", "w600 h350 Checked")
    
    ; Build file list
    Root := TV.Add("Files")
    Loop 20 {
        TV.Add("File_" . Format("{:02}", A_Index) . ".txt", Root)
    }
    TV.Modify(Root, "Expand")
    
    ; Selection controls
    myGui.Add("Text", "xm y+10", "Selection:")
    
    selectAllBtn := myGui.Add("Button", "xm y+5 w100", "Select All")
    selectAllBtn.OnEvent("Click", (*) => CheckAll(TV, Root, true))
    
    selectNoneBtn := myGui.Add("Button", "x+10 yp w100", "Select None")
    selectNoneBtn.OnEvent("Click", (*) => CheckAll(TV, Root, false))
    
    invertBtn := myGui.Add("Button", "x+10 yp w100", "Invert Selection")
    invertBtn.OnEvent("Click", InvertSelection)
    
    selectEvenBtn := myGui.Add("Button", "x+10 yp w100", "Select Even")
    selectEvenBtn.OnEvent("Click", SelectEven)
    
    selectOddBtn := myGui.Add("Button", "x+10 yp w100", "Select Odd")
    selectOddBtn.OnEvent("Click", SelectOdd)
    
    InvertSelection(*) {
        InvertChecks(TV, Root)
        UpdateCount()
    }
    
    InvertChecks(TV, nodeID) {
        if (nodeID) {
            isChecked := TV.Get(nodeID, "Check")
            TV.Modify(nodeID, isChecked ? "-Check" : "Check")
        }
        
        child := TV.GetChild(nodeID)
        while (child) {
            InvertChecks(TV, child)
            child := TV.GetNext(child)
        }
    }
    
    SelectEven(*) {
        CheckAll(TV, Root, false)
        child := TV.GetChild(Root)
        index := 1
        while (child) {
            if (Mod(index, 2) = 0)
                TV.Modify(child, "Check")
            child := TV.GetNext(child)
            index++
        }
        UpdateCount()
    }
    
    SelectOdd(*) {
        CheckAll(TV, Root, false)
        child := TV.GetChild(Root)
        index := 1
        while (child) {
            if (Mod(index, 2) = 1)
                TV.Modify(child, "Check")
            child := TV.GetNext(child)
            index++
        }
        UpdateCount()
    }
    
    ; Operations on checked items
    myGui.Add("Text", "xm y+10", "Operations:")
    
    deleteBtn := myGui.Add("Button", "xm y+5 w120", "Delete Checked")
    deleteBtn.OnEvent("Click", DeleteChecked)
    
    exportBtn := myGui.Add("Button", "x+10 yp w120", "Export Checked")
    exportBtn.OnEvent("Click", ExportChecked)
    
    DeleteChecked(*) {
        checked := []
        GetCheckedItems(TV, Root, &checked)
        
        if (checked.Length = 0)
            return
        
        result := MsgBox("Delete " . checked.Length . " items?", "Confirm", "YesNo 32")
        if (result = "Yes") {
            for itemID in checked
                TV.Delete(itemID)
            UpdateCount()
        }
    }
    
    ExportChecked(*) {
        checked := []
        GetCheckedItems(TV, Root, &checked)
        
        if (checked.Length = 0)
            return
        
        list := "Selected Files:`n"
        for itemID in checked
            list .= TV.GetText(itemID) . "`n"
        
        MsgBox(list, "Export", 64)
    }
    
    ; Status
    statusText := myGui.Add("Text", "xm y+10 w600", "")
    
    UpdateCount() {
        checked := []
        GetCheckedItems(TV, Root, &checked)
        total := TV.GetCount() - 1  ; Exclude root
        statusText.Value := "Selected: " . checked.Length . " / " . total
    }
    
    TV.OnEvent("Click", (*) => UpdateCount())
    UpdateCount()
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())
    
    myGui.Show()
}

;=============================================================================
; EXAMPLE 5: Checkbox State Persistence
;=============================================================================
; Save and restore checkbox states

Example5_StatePersistence() {
    myGui := Gui("+Resize", "Example 5: State Persistence")
    
    ; Create TreeView
    TV := myGui.Add("TreeView", "w600 h350 Checked")
    
    ; Build tree
    Root := TV.Add("Settings")
    
    Display := TV.Add("Display", Root)
    TV.Add("High Resolution", Display)
    TV.Add("Dark Mode", Display)
    TV.Add("Animations", Display)
    
    Audio := TV.Add("Audio", Root)
    TV.Add("Sound Effects", Audio)
    TV.Add("Background Music", Audio)
    
    Network := TV.Add("Network", Root)
    TV.Add("Auto-Connect", Network)
    TV.Add("Proxy", Network)
    
    TV.Modify(Root, "Expand")
    
    ; State management
    savedStates := Map()
    
    ; Controls
    myGui.Add("Text", "xm y+10", "Preset Name:")
    presetInput := myGui.Add("Edit", "x+10 yp-3 w200")
    
    saveBtn := myGui.Add("Button", "xm y+10 w120", "Save Preset")
    saveBtn.OnEvent("Click", SavePreset)
    
    loadBtn := myGui.Add("Button", "x+10 yp w120", "Load Preset")
    loadBtn.OnEvent("Click", LoadPreset)
    
    listBtn := myGui.Add("Button", "x+10 yp w120", "List Presets")
    listBtn.OnEvent("Click", ListPresets)
    
    SavePreset(*) {
        name := presetInput.Value
        if (!name) {
            MsgBox("Please enter preset name", "Info", 64)
            return
        }
        
        state := []
        SaveCheckState(TV, Root, state)
        savedStates[name] := state
        
        MsgBox("Preset saved: " . name, "Success", 64)
        presetInput.Value := ""
    }
    
    SaveCheckState(TV, nodeID, &state) {
        if (nodeID) {
            state.Push({
                text: TV.GetText(nodeID),
                checked: TV.Get(nodeID, "Check")
            })
        }
        
        child := TV.GetChild(nodeID)
        while (child) {
            SaveCheckState(TV, child, &state)
            child := TV.GetNext(child)
        }
    }
    
    LoadPreset(*) {
        name := presetInput.Value
        if (!name || !savedStates.Has(name)) {
            MsgBox("Preset not found", "Error", 16)
            return
        }
        
        state := savedStates[name]
        LoadCheckState(TV, Root, state, 0)
        
        MsgBox("Preset loaded: " . name, "Success", 64)
        presetInput.Value := ""
    }
    
    LoadCheckState(TV, nodeID, state, &index) {
        if (nodeID && index < state.Length) {
            index++
            itemState := state[index]
            TV.Modify(nodeID, itemState.checked ? "Check" : "-Check")
        }
        
        child := TV.GetChild(nodeID)
        while (child) {
            LoadCheckState(TV, child, state, &index)
            child := TV.GetNext(child)
        }
    }
    
    ListPresets(*) {
        if (savedStates.Count = 0) {
            MsgBox("No presets saved", "Info", 64)
            return
        }
        
        list := "Saved Presets:`n`n"
        for name, state in savedStates {
            checkedCount := 0
            for item in state {
                if (item.checked)
                    checkedCount++
            }
            list .= "• " . name . " (" . checkedCount . " checked)`n"
        }
        
        MsgBox(list, "Presets", 64)
    }
    
    ; Status
    statusText := myGui.Add("Text", "xm y+10 w600", "Saved presets: " . savedStates.Count)
    
    saveBtn.OnEvent("Click", (*) => (SetTimer(UpdateStatus, -100), ""))
    
    UpdateStatus() {
        statusText.Value := "Saved presets: " . savedStates.Count
    }
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())
    
    myGui.Show()
}

;=============================================================================
; EXAMPLE 6: Checkbox with Dependencies
;=============================================================================
; Checkboxes with dependency rules

Example6_Dependencies() {
    myGui := Gui("+Resize", "Example 6: Checkbox Dependencies")
    
    ; Create TreeView
    TV := myGui.Add("TreeView", "w600 h400 Checked")
    
    ; Build tree
    Root := TV.Add("Software Installation")
    
    ; Store node IDs for dependency checking
    Nodes := Map()
    
    Nodes["Core"] := TV.Add("Core Components (Required)", Root)
    Nodes["CoreFiles"] := TV.Add("Core Files", Nodes["Core"])
    Nodes["CoreLibs"] := TV.Add("Core Libraries", Nodes["Core"])
    
    Nodes["Optional"] := TV.Add("Optional Components", Root)
    Nodes["Plugins"] := TV.Add("Plugins (Requires Core)", Nodes["Optional"])
    Nodes["Themes"] := TV.Add("Themes (Requires Core)", Nodes["Optional"])
    
    Nodes["Advanced"] := TV.Add("Advanced Features", Root)
    Nodes["DevTools"] := TV.Add("Dev Tools (Requires Plugins)", Nodes["Advanced"])
    
    TV.Modify(Root, "Expand")
    
    ; Check core by default (required)
    TV.Modify(Nodes["Core"], "Check")
    TV.Modify(Nodes["CoreFiles"], "Check")
    TV.Modify(Nodes["CoreLibs"], "Check")
    
    ; Handle clicks with dependency validation
    TV.OnEvent("Click", ValidateDependencies)
    
    ValidateDependencies(GuiCtrl, ItemID) {
        if (!ItemID)
            return
        
        Sleep(50)
        
        ; Core is always required
        if (ItemID = Nodes["Core"] || ItemID = Nodes["CoreFiles"] || ItemID = Nodes["CoreLibs"]) {
            if (!TV.Get(ItemID, "Check")) {
                TV.Modify(ItemID, "Check")
                MsgBox("Core components are required!", "Info", 64)
                return
            }
        }
        
        ; Plugins and Themes require Core
        if (ItemID = Nodes["Plugins"] || ItemID = Nodes["Themes"]) {
            if (TV.Get(ItemID, "Check") && !TV.Get(Nodes["Core"], "Check")) {
                TV.Modify(ItemID, "-Check")
                MsgBox("This component requires Core Components!", "Dependency Error", 16)
                return
            }
        }
        
        ; Dev Tools requires Plugins
        if (ItemID = Nodes["DevTools"]) {
            if (TV.Get(ItemID, "Check") && !TV.Get(Nodes["Plugins"], "Check")) {
                TV.Modify(ItemID, "-Check")
                MsgBox("Dev Tools requires Plugins to be installed!", "Dependency Error", 16)
                return
            }
        }
        
        ; If unchecking Plugins, uncheck Dev Tools
        if (ItemID = Nodes["Plugins"] && !TV.Get(ItemID, "Check")) {
            TV.Modify(Nodes["DevTools"], "-Check")
        }
        
        UpdateInfo()
    }
    
    ; Info display
    infoText := myGui.Add("Edit", "xm y+10 w600 h120 ReadOnly")
    
    UpdateInfo() {
        info := "Installation Summary:`n`n"
        
        checked := []
        GetCheckedItems(TV, Root, &checked)
        
        info .= "Selected Components:`n"
        for itemID in checked {
            text := TV.GetText(itemID)
            info .= "  • " . text . "`n"
        }
        
        infoText.Value := info
    }
    
    UpdateInfo()
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())
    
    myGui.Show()
}

;=============================================================================
; EXAMPLE 7: Complete Checkbox System
;=============================================================================
; Full-featured checkbox TreeView with all capabilities

Example7_CompleteSystem() {
    myGui := Gui("+Resize", "Example 7: Complete Checkbox System")
    
    ; Create TreeView
    TV := myGui.Add("TreeView", "w700 h350 Checked")
    
    ; Build comprehensive tree
    Root := TV.Add("Project Checklist")
    
    Planning := TV.Add("Planning Phase", Root)
    TV.Add("Requirements Gathering", Planning)
    TV.Add("Design Mockups", Planning)
    TV.Add("Architecture Planning", Planning)
    
    Development := TV.Add("Development Phase", Root)
    Frontend := TV.Add("Frontend", Development)
    TV.Add("HTML/CSS", Frontend)
    TV.Add("JavaScript", Frontend)
    Backend := TV.Add("Backend", Development)
    TV.Add("API Development", Backend)
    TV.Add("Database Setup", Backend)
    
    Testing := TV.Add("Testing Phase", Root)
    TV.Add("Unit Tests", Testing)
    TV.Add("Integration Tests", Testing)
    TV.Add("UAT", Testing)
    
    TV.Modify(Root, "Expand")
    
    ; Comprehensive controls
    myGui.Add("Text", "xm y+10", "Batch Operations:")
    
    checkAllBtn := myGui.Add("Button", "xm y+5 w100", "Check All")
    checkAllBtn.OnEvent("Click", (*) => (CheckAll(TV, Root, true), UpdateStats()))
    
    uncheckAllBtn := myGui.Add("Button", "x+10 yp w100", "Uncheck All")
    uncheckAllBtn.OnEvent("Click", (*) => (CheckAll(TV, Root, false), UpdateStats()))
    
    expandAllBtn := myGui.Add("Button", "x+10 yp w100", "Expand All")
    expandAllBtn.OnEvent("Click", (*) => ExpandAll(TV, Root))
    
    collapseAllBtn := myGui.Add("Button", "x+10 yp w100", "Collapse All")
    collapseAllBtn.OnEvent("Click", (*) => CollapseAll(TV, Root))
    
    reportBtn := myGui.Add("Button", "x+10 yp w100", "Generate Report")
    reportBtn.OnEvent("Click", GenerateReport)
    
    ExpandAll(TV, nodeID) {
        if (nodeID)
            TV.Modify(nodeID, "Expand")
        child := TV.GetChild(nodeID)
        while (child) {
            ExpandAll(TV, child)
            child := TV.GetNext(child)
        }
    }
    
    CollapseAll(TV, nodeID) {
        child := TV.GetChild(nodeID)
        while (child) {
            CollapseAll(TV, child)
            TV.Modify(child, "-Expand")
            child := TV.GetNext(child)
        }
    }
    
    GenerateReport(*) {
        report := "PROJECT STATUS REPORT`n`n"
        
        ; Get all phases
        phases := ["Planning Phase", "Development Phase", "Testing Phase"]
        
        for phaseName in phases {
            phaseNode := FindNodeByText(TV, Root, phaseName)
            if (phaseNode) {
                total := 0
                completed := 0
                CountPhaseProgress(TV, phaseNode, &total, &completed)
                
                percent := total > 0 ? Round((completed / total) * 100) : 0
                report .= phaseName . ": " . completed . "/" . total . " (" . percent . "%)`n"
            }
        }
        
        MsgBox(report, "Project Report", 64)
    }
    
    FindNodeByText(TV, nodeID, searchText) {
        if (nodeID && TV.GetText(nodeID) = searchText)
            return nodeID
        
        child := TV.GetChild(nodeID)
        while (child) {
            if (found := FindNodeByText(TV, child, searchText))
                return found
            child := TV.GetNext(child)
        }
        return 0
    }
    
    CountPhaseProgress(TV, nodeID, &total, &completed) {
        child := TV.GetChild(nodeID)
        while (child) {
            if (!TV.GetChild(child)) {  ; Leaf node
                total++
                if (TV.Get(child, "Check"))
                    completed++
            } else {
                CountPhaseProgress(TV, child, &total, &completed)
            }
            child := TV.GetNext(child)
        }
    }
    
    ; Statistics
    statsText := myGui.Add("Text", "xm y+10 w700 Border", "")
    
    UpdateStats() {
        total := TV.GetCount() - 1
        checked := []
        GetCheckedItems(TV, Root, &checked)
        percent := total > 0 ? Round((checked.Length / total) * 100) : 0
        
        statsText.Value := "Progress: " . checked.Length . " / " . total . " (" . percent . "%) | Click items to mark as complete"
    }
    
    TV.OnEvent("Click", (*) => UpdateStats())
    UpdateStats()
    
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())
    
    myGui.Show()
}

;=============================================================================
; REFERENCE SECTION
;=============================================================================
/*
CHECKBOX TREEVIEW:

CREATION:
- TV := Gui.Add("TreeView", "Checked")
- "Checked" option enables checkboxes

CHECK STATE OPERATIONS:
- Get state: TV.Get(ItemID, "Check")  ; Returns 1 or 0
- Set checked: TV.Modify(ItemID, "Check")
- Set unchecked: TV.Modify(ItemID, "-Check")

COMMON PATTERNS:

1. CHECK ALL/UNCHECK ALL:
   CheckAll(TV, RootID, State) {
       TV.Modify(RootID, State ? "Check" : "-Check")
       ; Recurse through children
   }

2. GET CHECKED ITEMS:
   GetChecked(TV, NodeID, &Results) {
       if TV.Get(NodeID, "Check")
           Results.Push(NodeID)
       ; Recurse through children
   }

3. CASCADING CHECKS:
   - Parent checked → All children checked
   - All children checked → Parent checked
   - Some children checked → Parent indeterminate

4. TRI-STATE LOGIC:
   - Checked: All descendants checked
   - Unchecked: No descendants checked
   - Indeterminate: Some descendants checked
   - Use Bold property to indicate indeterminate

5. INVERT SELECTION:
   InvertChecks(TV, NodeID) {
       isChecked := TV.Get(NodeID, "Check")
       TV.Modify(NodeID, isChecked ? "-Check" : "Check")
       ; Recurse through children
   }

EVENTS:
- Click event fires when checkbox is clicked
- Small delay (Sleep 50) may be needed after click
  to ensure check state has updated

USE CASES:
- Multi-selection in trees
- Task/checklist management
- Feature/permission selection
- File/folder selection
- Configuration options
- Batch operations

BEST PRACTICES:
1. Use for multi-selection scenarios
2. Implement cascading for intuitive UX
3. Provide "Check All" and "Uncheck All"
4. Consider tri-state for hierarchies
5. Save/restore states for preferences
6. Validate dependencies between items
7. Provide visual feedback for operations

LIMITATIONS:
- No native tri-state support
- Must implement cascading manually
- Check state not preserved during tree rebuild
- Limited customization of checkbox appearance

PERFORMANCE:
- Checking/unchecking is O(1) operation
- Getting all checked items requires traversal O(n)
- Cache checked items if frequently accessed
- Batch checkbox operations when possible
*/

; Uncomment to run examples:
; Example1_BasicCheckboxes()
; Example2_CascadingChecks()
; Example3_TriState()
; Example4_CheckboxSelection()
; Example5_StatePersistence()
; Example6_Dependencies()
; Example7_CompleteSystem()
