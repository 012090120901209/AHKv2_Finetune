#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_TreeView_01_BasicUsage.ahk
 * 
 * DESCRIPTION:
 * Demonstrates fundamental TreeView control operations including creating trees,
 * adding nodes, setting parent-child relationships, and basic tree manipulation.
 * 
 * FEATURES:
 * - Creating TreeView controls in GUI windows
 * - Adding root and child nodes
 * - Modifying node properties
 * - Basic tree traversal
 * - Node deletion and modification
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/TreeView.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Class-based GUI controls
 * - Method chaining for control creation
 * - Object-oriented event handling
 * - Modern parameter syntax
 * 
 * LEARNING POINTS:
 * 1. TreeView controls require parent GUI window
 * 2. Nodes are identified by unique IDs returned when created
 * 3. Parent-child relationships established via parent parameter
 * 4. Node properties can be modified after creation
 * 5. TV object provides methods for all tree operations
 */

;=============================================================================
; EXAMPLE 1: Creating a Simple TreeView
;=============================================================================
; Demonstrates creating a basic TreeView control and adding root-level nodes

Example1_SimpleTreeView() {
    ; Create the main GUI window
    myGui := Gui("+Resize", "Example 1: Simple TreeView")

    ; Add a TreeView control
    TV := myGui.Add("TreeView", "w300 h400")

    ; Add root level items
    Colors := TV.Add("Colors")
    Shapes := TV.Add("Shapes")
    Numbers := TV.Add("Numbers")

    ; Add some child items to demonstrate hierarchy
    TV.Add("Red", Colors)
    TV.Add("Blue", Colors)
    TV.Add("Green", Colors)

    TV.Add("Circle", Shapes)
    TV.Add("Square", Shapes)
    TV.Add("Triangle", Shapes)

    ; Add a status bar to show information
    myGui.Add("Text", "xm y+10 w300", "Total items: " . TV.GetCount())

    ; Add close button
    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    ; Show the GUI
    myGui.Show()
}

;=============================================================================
; EXAMPLE 2: Building a Hierarchical Tree
;=============================================================================
; Shows how to create multi-level hierarchies with various depths

Example2_HierarchicalTree() {
    myGui := Gui("+Resize", "Example 2: Hierarchical Tree")

    ; Create TreeView with options
    TV := myGui.Add("TreeView", "w400 h450")

    ; Build a company organization structure
    Company := TV.Add("Acme Corporation")

    ; Executive Level
    Executive := TV.Add("Executive Team", Company)
    TV.Add("CEO - John Smith", Executive)
    TV.Add("CFO - Jane Doe", Executive)
    TV.Add("CTO - Bob Johnson", Executive)

    ; Engineering Department
    Engineering := TV.Add("Engineering", Company)
    Frontend := TV.Add("Frontend Team", Engineering)
    TV.Add("Senior Dev - Alice", Frontend)
    TV.Add("Junior Dev - Charlie", Frontend)
    TV.Add("Junior Dev - Diana", Frontend)

    Backend := TV.Add("Backend Team", Engineering)
    TV.Add("Senior Dev - Eve", Backend)
    TV.Add("Mid Dev - Frank", Backend)
    TV.Add("Junior Dev - Grace", Backend)

    ; Sales Department
    Sales := TV.Add("Sales", Company)
    TV.Add("Sales Manager - Henry", Sales)
    Regional := TV.Add("Regional Sales", Sales)
    TV.Add("North Region - Iris", Regional)
    TV.Add("South Region - Jack", Regional)
    TV.Add("East Region - Kelly", Regional)
    TV.Add("West Region - Leo", Regional)

    ; Support Department
    Support := TV.Add("Support", Company)
    TV.Add("Support Lead - Mike", Support)
    TV.Add("Support Agent - Nancy", Support)
    TV.Add("Support Agent - Oscar", Support)

    ; Expand the top level by default
    TV.Modify(Company, "Expand")

    ; Add information display
    infoText := myGui.Add("Text", "xm y+10 w400",
        "Total Employees: " . (TV.GetCount() - 1) . " | Departments: 3")

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 3: Dynamic Node Addition
;=============================================================================
; Demonstrates adding nodes dynamically based on user interaction

Example3_DynamicAddition() {
    myGui := Gui("+Resize", "Example 3: Dynamic Node Addition")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w400 h400")

    ; Add initial root node
    Root := TV.Add("My Tree")
    TV.Modify(Root, "Select")

    ; Add input controls
    myGui.Add("Text", "xm y+10", "Node Text:")
    nodeInput := myGui.Add("Edit", "x+10 yp-3 w200", "New Node")

    ; Add buttons for operations
    addChildBtn := myGui.Add("Button", "xm y+10 w120", "Add Child")
    addSiblingBtn := myGui.Add("Button", "x+10 yp w120", "Add Sibling")

    ; Add child node to selected item
    addChildBtn.OnEvent("Click", AddChild)
    AddChild(*) {
        selected := TV.GetSelection()
        if (selected) {
            nodeText := nodeInput.Value
            newNode := TV.Add(nodeText, selected)
            TV.Modify(selected, "Expand")
            TV.Modify(newNode, "Select Vis")
            UpdateStats()
        }
    }

    ; Add sibling node to selected item
    addSiblingBtn.OnEvent("Click", AddSibling)
    AddSibling(*) {
        selected := TV.GetSelection()
        if (selected) {
            parent := TV.GetParent(selected)
            nodeText := nodeInput.Value
            newNode := TV.Add(nodeText, parent)
            TV.Modify(newNode, "Select Vis")
            UpdateStats()
        }
    }

    ; Delete selected node
    deleteBtn := myGui.Add("Button", "xm y+10 w120", "Delete Selected")
    deleteBtn.OnEvent("Click", DeleteNode)
    DeleteNode(*) {
        selected := TV.GetSelection()
        if (selected && selected != Root) {
            TV.Delete(selected)
            UpdateStats()
        } else {
            MsgBox("Cannot delete root node or no node selected", "Info", 64)
        }
    }

    ; Clear all except root
    clearBtn := myGui.Add("Button", "x+10 yp w120", "Clear Tree")
    clearBtn.OnEvent("Click", ClearTree)
    ClearTree(*) {
        TV.Delete()
        Root := TV.Add("My Tree")
        TV.Modify(Root, "Select")
        UpdateStats()
    }

    ; Status display
    statusText := myGui.Add("Text", "xm y+20 w400", "")

    UpdateStats() {
        total := TV.GetCount()
        selected := TV.GetSelection()
        selText := selected ? TV.GetText(selected) : "None"
        statusText.Value := "Total Nodes: " . total . " | Selected: " . selText
    }

    UpdateStats()

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 4: Node Property Modification
;=============================================================================
; Shows how to modify node properties like bold, check, select, expand

Example4_NodeProperties() {
    myGui := Gui("+Resize", "Example 4: Node Property Modification")

    ; Create TreeView with checkboxes
    TV := myGui.Add("TreeView", "w400 h350 Checked")

    ; Build sample tree
    Projects := TV.Add("Projects")

    Project1 := TV.Add("Website Redesign", Projects)
    TV.Add("Design mockups", Project1)
    TV.Add("Frontend development", Project1)
    TV.Add("Backend API", Project1)

    Project2 := TV.Add("Mobile App", Projects)
    TV.Add("iOS version", Project2)
    TV.Add("Android version", Project2)

    Project3 := TV.Add("Database Migration", Projects)
    TV.Add("Schema design", Project3)
    TV.Add("Data transfer", Project3)
    TV.Add("Testing", Project3)

    ; Expand root
    TV.Modify(Projects, "Expand")

    ; Property modification buttons
    myGui.Add("Text", "xm y+10", "Modify Selected Node:")

    boldBtn := myGui.Add("Button", "xm y+5 w90", "Toggle Bold")
    boldBtn.OnEvent("Click", ToggleBold)
    ToggleBold(*) {
        if (selected := TV.GetSelection()) {
            ; Check current state and toggle
            currentState := TV.Get(selected, "Bold")
            TV.Modify(selected, currentState ? "-Bold" : "Bold")
        }
    }

    checkBtn := myGui.Add("Button", "x+10 yp w90", "Toggle Check")
    checkBtn.OnEvent("Click", ToggleCheck)
    ToggleCheck(*) {
        if (selected := TV.GetSelection()) {
            currentState := TV.Get(selected, "Check")
            TV.Modify(selected, currentState ? "-Check" : "Check")
        }
    }

    expandBtn := myGui.Add("Button", "x+10 yp w90", "Toggle Expand")
    expandBtn.OnEvent("Click", ToggleExpand)
    ToggleExpand(*) {
        if (selected := TV.GetSelection()) {
            currentState := TV.Get(selected, "Expand")
            TV.Modify(selected, currentState ? "-Expand" : "Expand")
        }
    }

    ; Bulk operations
    myGui.Add("Text", "xm y+20", "Bulk Operations:")

    expandAllBtn := myGui.Add("Button", "xm y+5 w90", "Expand All")
    expandAllBtn.OnEvent("Click", (*) => ExpandAll(TV, Projects))

    collapseAllBtn := myGui.Add("Button", "x+10 yp w90", "Collapse All")
    collapseAllBtn.OnEvent("Click", (*) => TV.Modify(Projects, "-Expand"))

    checkAllBtn := myGui.Add("Button", "x+10 yp w90", "Check All")
    checkAllBtn.OnEvent("Click", (*) => CheckAll(TV, Projects, true))

    uncheckAllBtn := myGui.Add("Button", "xm y+5 w90", "Uncheck All")
    uncheckAllBtn.OnEvent("Click", (*) => CheckAll(TV, Projects, false))

    ; Status
    statusText := myGui.Add("Text", "xm y+20 w400", "")

    ; Update status on selection change
    TV.OnEvent("ItemSelect", (*) => UpdateStatus())

    UpdateStatus() {
        if (selected := TV.GetSelection()) {
            text := TV.GetText(selected)
            bold := TV.Get(selected, "Bold") ? "Yes" : "No"
            checked := TV.Get(selected, "Check") ? "Yes" : "No"
            expanded := TV.Get(selected, "Expand") ? "Yes" : "No"
            statusText.Value := "Node: " . text . " | Bold: " . bold . " | Checked: " . checked . " | Expanded: " . expanded
        }
    }

    UpdateStatus()

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

; Helper function to expand all nodes recursively
ExpandAll(TV, NodeID := 0) {
    TV.Modify(NodeID, "Expand")
    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        ExpandAll(TV, ChildID)
        ChildID := TV.GetNext(ChildID)
    }
}

; Helper function to check/uncheck all nodes recursively
CheckAll(TV, NodeID, CheckState) {
    TV.Modify(NodeID, CheckState ? "Check" : "-Check")
    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        CheckAll(TV, ChildID, CheckState)
        ChildID := TV.GetNext(ChildID)
    }
}

;=============================================================================
; EXAMPLE 5: Tree Traversal Methods
;=============================================================================
; Demonstrates different methods for traversing and navigating tree structure

Example5_TreeTraversal() {
    myGui := Gui("+Resize", "Example 5: Tree Traversal")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w400 h300")

    ; Build a sample tree
    Foods := TV.Add("Foods")

    Fruits := TV.Add("Fruits", Foods)
    TV.Add("Apple", Fruits)
    TV.Add("Banana", Fruits)
    TV.Add("Orange", Fruits)

    Vegetables := TV.Add("Vegetables", Foods)
    TV.Add("Carrot", Vegetables)
    TV.Add("Broccoli", Vegetables)
    TV.Add("Spinach", Vegetables)

    Grains := TV.Add("Grains", Foods)
    TV.Add("Rice", Grains)
    TV.Add("Wheat", Grains)
    TV.Add("Oats", Grains)

    TV.Modify(Foods, "Expand")

    ; Output area
    outputEdit := myGui.Add("Edit", "xm y+10 w400 h150 ReadOnly")

    ; Traversal buttons
    myGui.Add("Text", "xm y+10", "Traversal Methods:")

    listAllBtn := myGui.Add("Button", "xm y+5 w120", "List All Nodes")
    listAllBtn.OnEvent("Click", ListAll)
    ListAll(*) {
        output := "All Nodes:`n"
        output .= TraverseTree(TV, Foods)
        outputEdit.Value := output
    }

    listChildrenBtn := myGui.Add("Button", "x+10 yp w120", "List Children")
    listChildrenBtn.OnEvent("Click", ListChildren)
    ListChildren(*) {
        if (selected := TV.GetSelection()) {
            text := TV.GetText(selected)
            output := "Children of '" . text . "':`n"
            ChildID := TV.GetChild(selected)
            if (!ChildID) {
                output .= "(No children)"
            } else {
                while (ChildID) {
                    output .= "  - " . TV.GetText(ChildID) . "`n"
                    ChildID := TV.GetNext(ChildID)
                }
            }
            outputEdit.Value := output
        }
    }

    pathBtn := myGui.Add("Button", "x+10 yp w120", "Show Path")
    pathBtn.OnEvent("Click", ShowPath)
    ShowPath(*) {
        if (selected := TV.GetSelection()) {
            path := GetNodePath(TV, selected)
            outputEdit.Value := "Path: " . path
        }
    }

    countBtn := myGui.Add("Button", "xm y+5 w120", "Count Children")
    countBtn.OnEvent("Click", CountChildren)
    CountChildren(*) {
        if (selected := TV.GetSelection()) {
            count := CountNodes(TV, selected)
            text := TV.GetText(selected)
            outputEdit.Value := "'" . text . "' has " . count . " total descendants"
        }
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

; Recursively traverse tree and return formatted string
TraverseTree(TV, NodeID := 0, Indent := 0) {
    output := ""
    if (NodeID) {
        output .= StrRepeat("  ", Indent) . TV.GetText(NodeID) . "`n"
    }
    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        output .= TraverseTree(TV, ChildID, Indent + 1)
        ChildID := TV.GetNext(ChildID)
    }
    return output
}

; Get full path from root to node
GetNodePath(TV, NodeID) {
    path := TV.GetText(NodeID)
    ParentID := TV.GetParent(NodeID)
    while (ParentID) {
        path := TV.GetText(ParentID) . " > " . path
        ParentID := TV.GetParent(ParentID)
    }
    return path
}

; Count all descendants of a node
CountNodes(TV, NodeID) {
    count := 0
    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        count++
        count += CountNodes(TV, ChildID)
        ChildID := TV.GetNext(ChildID)
    }
    return count
}

; Helper function to repeat string
StrRepeat(str, count) {
    result := ""
    Loop count
        result .= str
    return result
}

;=============================================================================
; EXAMPLE 6: TreeView Event Handling
;=============================================================================
; Demonstrates handling various TreeView events

Example6_EventHandling() {
    myGui := Gui("+Resize", "Example 6: TreeView Events")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w400 h350")

    ; Build sample tree
    Root := TV.Add("Animals")

    Mammals := TV.Add("Mammals", Root)
    TV.Add("Dog", Mammals)
    TV.Add("Cat", Mammals)
    TV.Add("Elephant", Mammals)

    Birds := TV.Add("Birds", Root)
    TV.Add("Eagle", Birds)
    TV.Add("Parrot", Birds)
    TV.Add("Penguin", Birds)

    Reptiles := TV.Add("Reptiles", Root)
    TV.Add("Snake", Reptiles)
    TV.Add("Lizard", Reptiles)
    TV.Add("Turtle", Reptiles)

    TV.Modify(Root, "Expand")

    ; Event log
    logEdit := myGui.Add("Edit", "xm y+10 w400 h150 ReadOnly")

    ; Track events
    eventLog := []
    maxLogEntries := 20

    LogEvent(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        eventLog.Push(timestamp . " - " . msg)

        ; Keep only last maxLogEntries
        if (eventLog.Length > maxLogEntries)
            eventLog.RemoveAt(1)

        ; Update display
        logText := ""
        for index, entry in eventLog
            logText .= entry . "`n"
        logEdit.Value := logText
    }

    ; Register event handlers
    TV.OnEvent("Click", OnClick)
    TV.OnEvent("DoubleClick", OnDoubleClick)
    TV.OnEvent("ItemSelect", OnItemSelect)
    TV.OnEvent("ItemExpand", OnItemExpand)
    TV.OnEvent("ItemEdit", OnItemEdit)

    OnClick(GuiCtrl, Info) {
        if (Info) {
            text := TV.GetText(Info)
            LogEvent("Click on: " . text)
        }
    }

    OnDoubleClick(GuiCtrl, Info) {
        if (Info) {
            text := TV.GetText(Info)
            LogEvent("Double-click on: " . text)
        }
    }

    OnItemSelect(GuiCtrl, Info) {
        if (Info) {
            text := TV.GetText(Info)
            LogEvent("Selected: " . text)
        }
    }

    OnItemExpand(GuiCtrl, Info) {
        if (Info) {
            text := TV.GetText(Info)
            isExpanded := TV.Get(Info, "Expand")
            LogEvent((isExpanded ? "Expanded: " : "Collapsed: ") . text)
        }
    }

    OnItemEdit(GuiCtrl, Info) {
        if (Info) {
            newText := TV.GetText(Info)
            LogEvent("Edited to: " . newText)
        }
    }

    ; Control buttons
    clearLogBtn := myGui.Add("Button", "xm y+10 w100", "Clear Log")
    clearLogBtn.OnEvent("Click", (*) => (eventLog := [], logEdit.Value := ""))

    closeBtn := myGui.Add("Button", "x+10 yp w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    LogEvent("TreeView created and ready")

    myGui.Show()
}

;=============================================================================
; EXAMPLE 7: Complete TreeView Manager
;=============================================================================
; Full-featured tree management with all common operations

Example7_CompleteManager() {
    myGui := Gui("+Resize", "Example 7: Complete TreeView Manager")

    ; Create TreeView with checkboxes
    TV := myGui.Add("TreeView", "w500 h400 Checked")

    ; Initialize with sample data
    Root := TV.Add("My Documents")
    Work := TV.Add("Work", Root)
    TV.Add("Report.docx", Work)
    TV.Add("Presentation.pptx", Work)
    Personal := TV.Add("Personal", Root)
    TV.Add("Photos", Personal)
    TV.Add("Videos", Personal)

    TV.Modify(Root, "Expand Select")

    ; Input controls
    myGui.Add("Text", "xm y+10", "Node Name:")
    nodeInput := myGui.Add("Edit", "x+10 yp-3 w200")

    ; Operation buttons arranged in grid
    addChildBtn := myGui.Add("Button", "xm y+10 w100", "Add Child")
    addSiblingBtn := myGui.Add("Button", "x+5 yp w100", "Add Sibling")
    renameBtn := myGui.Add("Button", "x+5 yp w100", "Rename")
    deleteBtn := myGui.Add("Button", "x+5 yp w100", "Delete")

    moveUpBtn := myGui.Add("Button", "xm y+5 w100", "Move Up")
    moveDownBtn := myGui.Add("Button", "x+5 yp w100", "Move Down")
    sortBtn := myGui.Add("Button", "x+5 yp w100", "Sort Children")
    findBtn := myGui.Add("Button", "x+5 yp w100", "Find")

    ; Status bar
    statusBar := myGui.Add("Text", "xm y+20 w500 Border", "Ready")

    ; Event handlers
    addChildBtn.OnEvent("Click", AddChild)
    addSiblingBtn.OnEvent("Click", AddSibling)
    renameBtn.OnEvent("Click", RenameNode)
    deleteBtn.OnEvent("Click", DeleteNode)
    moveUpBtn.OnEvent("Click", MoveUp)
    moveDownBtn.OnEvent("Click", MoveDown)
    sortBtn.OnEvent("Click", SortChildren)
    findBtn.OnEvent("Click", FindNode)

    AddChild(*) {
        if (!selected := TV.GetSelection())
            return SetStatus("No node selected")
        if (!nodeInput.Value)
            return SetStatus("Please enter node name")

        newNode := TV.Add(nodeInput.Value, selected)
        TV.Modify(selected, "Expand")
        TV.Modify(newNode, "Select Vis")
        SetStatus("Added child node: " . nodeInput.Value)
        nodeInput.Value := ""
    }

    AddSibling(*) {
        if (!selected := TV.GetSelection())
            return SetStatus("No node selected")
        if (!nodeInput.Value)
            return SetStatus("Please enter node name")

        parent := TV.GetParent(selected)
        newNode := TV.Add(nodeInput.Value, parent)
        TV.Modify(newNode, "Select Vis")
        SetStatus("Added sibling node: " . nodeInput.Value)
        nodeInput.Value := ""
    }

    RenameNode(*) {
        if (!selected := TV.GetSelection())
            return SetStatus("No node selected")
        if (!nodeInput.Value)
            return SetStatus("Please enter new name")

        TV.Modify(selected, nodeInput.Value)
        SetStatus("Renamed to: " . nodeInput.Value)
        nodeInput.Value := ""
    }

    DeleteNode(*) {
        if (!selected := TV.GetSelection())
            return SetStatus("No node selected")
        if (selected = Root)
            return SetStatus("Cannot delete root node")

        text := TV.GetText(selected)
        TV.Delete(selected)
        SetStatus("Deleted: " . text)
    }

    MoveUp(*) {
        if (!selected := TV.GetSelection())
            return SetStatus("No node selected")

        ; This would require more complex implementation
        SetStatus("Move up functionality - would reorder siblings")
    }

    MoveDown(*) {
        if (!selected := TV.GetSelection())
            return SetStatus("No node selected")

        SetStatus("Move down functionality - would reorder siblings")
    }

    SortChildren(*) {
        if (!selected := TV.GetSelection())
            return SetStatus("No node selected")

        ; Sort would require collecting children, sorting, and rebuilding
        SetStatus("Sort functionality - would alphabetically sort children")
    }

    FindNode(*) {
        if (!nodeInput.Value)
            return SetStatus("Please enter search term")

        found := FindInTree(TV, Root, nodeInput.Value)
        if (found) {
            TV.Modify(found, "Select Vis")
            SetStatus("Found: " . TV.GetText(found))
        } else {
            SetStatus("Not found: " . nodeInput.Value)
        }
    }

    SetStatus(msg) {
        statusBar.Value := msg
    }

    ; Update status when selection changes
    TV.OnEvent("ItemSelect", (*) => UpdateSelectionInfo())

    UpdateSelectionInfo() {
        if (selected := TV.GetSelection()) {
            text := TV.GetText(selected)
            parent := TV.GetParent(selected)
            parentText := parent ? TV.GetText(parent) : "None"
            childCount := 0
            child := TV.GetChild(selected)
            while (child) {
                childCount++
                child := TV.GetNext(child)
            }
            SetStatus("Selected: " . text . " | Parent: " . parentText . " | Children: " . childCount)
        }
    }

    UpdateSelectionInfo()

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

; Find node by text (case-insensitive)
FindInTree(TV, NodeID, SearchText) {
    if (NodeID) {
        if (InStr(TV.GetText(NodeID), SearchText))
            return NodeID
    }

    ChildID := TV.GetChild(NodeID)
    while (ChildID) {
        if (found := FindInTree(TV, ChildID, SearchText))
            return found
        ChildID := TV.GetNext(ChildID)
    }
    return 0
}

;=============================================================================
; REFERENCE SECTION
;=============================================================================
/*
TREEVIEW METHODS:
- TV.Add(Name [, ParentItemID, Options]) - Add new item
- TV.Delete([ItemID]) - Delete item or all items
- TV.Get(ItemID, Attribute) - Get item attribute
- TV.GetChild(ParentItemID) - Get first child
- TV.GetCount() - Get total item count
- TV.GetNext([ItemID, "Full | Check"]) - Get next item
- TV.GetParent(ItemID) - Get parent item
- TV.GetPrev(ItemID) - Get previous item
- TV.GetSelection() - Get selected item
- TV.GetText(ItemID) - Get item text
- TV.Modify(ItemID [, Options, NewName]) - Modify item

ITEM OPTIONS:
- Bold - Bold text
- Check - Checked state (requires Checked style)
- Expand - Expanded state
- Select - Selected state
- Vis - Ensure visible (scroll into view)
- Icon - Icon number

EVENTS:
- Click - Single click
- DoubleClick - Double click
- ItemSelect - Item selection changed
- ItemExpand - Item expanded/collapsed
- ItemEdit - Item edited (requires -ReadOnly)

BEST PRACTICES:
1. Store ItemIDs returned by Add() for later reference
2. Use Modify() with "Vis" option to ensure visibility
3. Handle events to respond to user actions
4. Use recursive functions for tree traversal
5. Consider using checkboxes for multi-selection scenarios
*/

; Uncomment to run examples:
; Example1_SimpleTreeView()
; Example2_HierarchicalTree()
; Example3_DynamicAddition()
; Example4_NodeProperties()
; Example5_TreeTraversal()
; Example6_EventHandling()
; Example7_CompleteManager()

