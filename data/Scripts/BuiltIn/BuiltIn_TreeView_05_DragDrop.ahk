#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_TreeView_05_DragDrop.ahk
 * 
 * DESCRIPTION:
 * Demonstrates drag-and-drop operations in TreeView controls, including
 * moving nodes, reordering, and cross-tree drag and drop.
 * 
 * FEATURES:
 * - Internal drag and drop reordering
 * - Moving nodes between parents
 * - Visual drag feedback
 * - Drop validation
 * - Cross-TreeView drag and drop
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/TreeView.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Mouse event handling
 * - Coordinate tracking
 * - GUI control manipulation
 * - State management during drag operations
 * 
 * LEARNING POINTS:
 * 1. TreeView doesn't have built-in drag-drop (must implement manually)
 * 2. Track mouse events to detect drag operations
 * 3. Use visual feedback during dragging
 * 4. Validate drop targets before moving nodes
 * 5. Preserve node properties during moves
 */

;=============================================================================
; EXAMPLE 1: Basic Drag and Drop
;=============================================================================
; Simple drag-and-drop within single TreeView

Example1_BasicDragDrop() {
    myGui := Gui("+Resize", "Example 1: Basic Drag and Drop")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h400")

    ; Build sample tree
    Root := TV.Add("Tasks")

    Todo := TV.Add("To Do", Root)
    TV.Add("Task 1", Todo)
    TV.Add("Task 2", Todo)
    TV.Add("Task 3", Todo)

    InProgress := TV.Add("In Progress", Root)
    TV.Add("Task 4", InProgress)

    Done := TV.Add("Done", Root)
    TV.Add("Task 5", Done)

    TV.Modify(Root, "Expand")

    ; Drag state
    dragData := { active: false, sourceID: 0, sourceText: "" }

    ; Instructions
    infoText := myGui.Add("Text", "xm y+10 w500",
        "Click and hold on a task to start dragging.`n" .
        "Release over a category to move the task.`n" .
        "Try moving tasks between To Do, In Progress, and Done.")

    ; Mouse events
    TV.OnEvent("Click", StartDrag)

    StartDrag(GuiCtrl, ItemID) {
        if (!ItemID || ItemID = Root || ItemID = Todo || ItemID = InProgress || ItemID = Done)
            return

        dragData.active := true
        dragData.sourceID := ItemID
        dragData.sourceText := TV.GetText(ItemID)

        ; Visual feedback
        TV.Modify(ItemID, "Bold")
        SetTimer(CheckDrop, 50)
    }

    CheckDrop() {
        if (!GetKeyState("LButton", "P")) {
            ; Mouse released - perform drop
            if (dragData.active) {
                ; Get item under cursor
                MouseGetPos(, , &WinID, &CtrlID)
                if (WinID = myGui.Hwnd) {
                    ; Check which item is selected
                    targetID := TV.GetSelection()
                    if (targetID && targetID != dragData.sourceID) {
                        ; Validate drop (only on category nodes)
                        if (targetID = Todo || targetID = InProgress || targetID = Done) {
                            ; Move the node
                            sourceText := dragData.sourceText
                            TV.Delete(dragData.sourceID)
                            newID := TV.Add(sourceText, targetID)
                            TV.Modify(targetID, "Expand")
                            TV.Modify(newID, "Select Vis")
                        }
                    }
                }

                ; Reset drag state
                dragData.active := false
                dragData.sourceID := 0
            }
            SetTimer(, 0)
        }
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 2: Advanced Drag with Visual Feedback
;=============================================================================
; Enhanced drag-and-drop with better visual cues

Example2_VisualFeedback() {
    myGui := Gui("+Resize", "Example 2: Visual Feedback")

    ; Create TreeView with checkboxes
    TV := myGui.Add("TreeView", "w500 h400")

    ; Build tree
    Root := TV.Add("File System")

    Folder1 := TV.Add("Documents", Root)
    TV.Add("File1.txt", Folder1)
    TV.Add("File2.txt", Folder1)
    TV.Add("File3.txt", Folder1)

    Folder2 := TV.Add("Pictures", Root)
    TV.Add("Photo1.jpg", Folder2)
    TV.Add("Photo2.jpg", Folder2)

    Folder3 := TV.Add("Music", Root)
    TV.Add("Song1.mp3", Folder3)

    TV.Modify(Root, "Expand")

    ; Drag state
    global dragState := {
        active: false,
        sourceID: 0,
        sourceText: "",
        targetID: 0,
        validDrop: false
    }

    ; Status display
    statusText := myGui.Add("Text", "xm y+10 w500 Border", "Ready")

    infoText := myGui.Add("Text", "xm y+5 w500",
        "Drag files between folders. Valid drop targets are highlighted.")

    ; Events
    TV.OnEvent("Click", OnClick)

    OnClick(GuiCtrl, ItemID) {
        if (!ItemID || ItemID = Root)
            return

        ; Check if it's a file (not a folder)
        if (!TV.GetChild(ItemID)) {
            dragState.active := true
            dragState.sourceID := ItemID
            dragState.sourceText := TV.GetText(ItemID)
            TV.Modify(ItemID, "Bold")
            statusText.Value := "Dragging: " . dragState.sourceText
            SetTimer(TrackDrag, 50)
        }
    }

    TrackDrag() {
        if (!GetKeyState("LButton", "P")) {
            ; Drop
            if (dragState.active && dragState.validDrop && dragState.targetID) {
                ; Perform move
                TV.Delete(dragState.sourceID)
                newID := TV.Add(dragState.sourceText, dragState.targetID)
                TV.Modify(dragState.targetID, "Expand")
                TV.Modify(newID, "Select Vis")
                statusText.Value := "Moved: " . dragState.sourceText
            } else {
                statusText.Value := "Drop cancelled"
            }

            dragState.active := false
            SetTimer(, 0)
        } else {
            ; Update target
            currentTarget := TV.GetSelection()
            if (currentTarget && currentTarget != dragState.sourceID) {
                ; Check if target is a folder
                dragState.validDrop := (TV.GetChild(currentTarget) != 0) || (currentTarget = Root)
                dragState.targetID := currentTarget

                if (dragState.validDrop)
                    statusText.Value := "Drop on: " . TV.GetText(currentTarget)
                else
                    statusText.Value := "Invalid drop target"
            }
        }
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 3: Reordering Siblings
;=============================================================================
; Drag to reorder items at same level

Example3_ReorderSiblings() {
    myGui := Gui("+Resize", "Example 3: Reorder Siblings")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h400")

    ; Build list
    Root := TV.Add("Priority List")
    TV.Add("Item 1 - High Priority", Root)
    TV.Add("Item 2 - Medium Priority", Root)
    TV.Add("Item 3 - Low Priority", Root)
    TV.Add("Item 4 - Medium Priority", Root)
    TV.Add("Item 5 - High Priority", Root)

    TV.Modify(Root, "Expand")

    infoText := myGui.Add("Text", "xm y+10 w500",
        "Drag items up or down to reorder priorities.")

    ; Reorder controls
    myGui.Add("Text", "xm y+10", "Reorder Controls:")

    upBtn := myGui.Add("Button", "xm y+5 w100", "Move Up")
    upBtn.OnEvent("Click", MoveUp)

    downBtn := myGui.Add("Button", "x+10 yp w100", "Move Down")
    downBtn.OnEvent("Click", MoveDown)

    topBtn := myGui.Add("Button", "x+10 yp w100", "Move to Top")
    topBtn.OnEvent("Click", MoveToTop)

    bottomBtn := myGui.Add("Button", "x+10 yp w100", "Move to Bottom")
    bottomBtn.OnEvent("Click", MoveToBottom)

    MoveUp(*) {
        if (!(selected := TV.GetSelection()))
            return
        if (selected = Root)
            return

        ; Get previous sibling
        if (prev := TV.GetPrev(selected)) {
            MoveNodeBefore(TV, selected, prev)
        }
    }

    MoveDown(*) {
        if (!(selected := TV.GetSelection()))
            return
        if (selected = Root)
            return

        ; Get next sibling
        if (next := TV.GetNext(selected)) {
            MoveNodeAfter(TV, selected, next)
        }
    }

    MoveToTop(*) {
        if (!(selected := TV.GetSelection()))
            return
        if (selected = Root)
            return

        parent := TV.GetParent(selected)
        firstChild := TV.GetChild(parent)

        if (selected != firstChild) {
            text := TV.GetText(selected)
            TV.Delete(selected)
            newID := TV.Add(text, parent)
            TV.Modify(newID, "Select Vis")
        }
    }

    MoveToBottom(*) {
        if (!(selected := TV.GetSelection()))
            return
        if (selected = Root)
            return

        parent := TV.GetParent(selected)
        text := TV.GetText(selected)

        ; Find last sibling
        lastSibling := TV.GetChild(parent)
        while (next := TV.GetNext(lastSibling))
            lastSibling := next

        if (selected != lastSibling) {
            TV.Delete(selected)
            newID := TV.Add(text, parent)
            TV.Modify(newID, "Select Vis")
        }
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

; Helper function to move node before another
MoveNodeBefore(TV, sourceID, targetID) {
    ; This is a simplified version - full implementation would preserve all properties
    sourceText := TV.GetText(sourceID)
    parent := TV.GetParent(sourceID)

    ; Rebuild siblings list without source
    siblings := []
    child := TV.GetChild(parent)
    while (child) {
        if (child != sourceID)
            siblings.Push({ id: child, text: TV.GetText(child) })
        child := TV.GetNext(child)
    }

    ; Insert source before target in list
    newSiblings := []
    for sibling in siblings {
        if (sibling.id = targetID)
            newSiblings.Push({ id: 0, text: sourceText })
        newSiblings.Push(sibling)
    }

    ; Rebuild tree
    ; Note: Full implementation would preserve all node properties
}

; Helper function to move node after another
MoveNodeAfter(TV, sourceID, targetID) {
    sourceText := TV.GetText(sourceID)
    parent := TV.GetParent(sourceID)

    TV.Delete(sourceID)
    ; Note: Simplified - would need to insert at correct position
    newID := TV.Add(sourceText, parent)
    TV.Modify(newID, "Select Vis")
}

;=============================================================================
; EXAMPLE 4: Cross-TreeView Drag and Drop
;=============================================================================
; Dragging between two separate TreeView controls

Example4_CrossTreeDrag() {
    myGui := Gui("+Resize", "Example 4: Cross-TreeView Drag")

    ; Create two TreeViews side by side
    myGui.Add("Text", "xm ym", "Source Tree:")
    TV1 := myGui.Add("TreeView", "xm y+5 w250 h400")

    myGui.Add("Text", "x+20 ym", "Target Tree:")
    TV2 := myGui.Add("TreeView", "x+20 yp+20 w250 h400")

    ; Build source tree
    Root1 := TV1.Add("Available Items")
    TV1.Add("Item A", Root1)
    TV1.Add("Item B", Root1)
    TV1.Add("Item C", Root1)
    TV1.Add("Item D", Root1)
    TV1.Add("Item E", Root1)
    TV1.Modify(Root1, "Expand")

    ; Build target tree
    Root2 := TV2.Add("Selected Items")
    TV2.Modify(Root2, "Expand")

    ; Instructions
    infoText := myGui.Add("Text", "xm y+10 w530",
        "Click items in the Source Tree to move them to the Target Tree.")

    ; Simple transfer buttons
    transferBtn := myGui.Add("Button", "xm y+10 w100", "Transfer →")
    transferBtn.OnEvent("Click", TransferRight)

    transferBackBtn := myGui.Add("Button", "x+10 yp w100", "← Transfer Back")
    transferBackBtn.OnEvent("Click", TransferLeft)

    transferAllBtn := myGui.Add("Button", "x+10 yp w100", "Transfer All →")
    transferAllBtn.OnEvent("Click", TransferAllRight)

    TransferRight(*) {
        if (selected := TV1.GetSelection()) {
            if (selected != Root1) {
                text := TV1.GetText(selected)
                TV1.Delete(selected)
                newID := TV2.Add(text, Root2)
                TV2.Modify(newID, "Select Vis")
            }
        }
    }

    TransferLeft(*) {
        if (selected := TV2.GetSelection()) {
            if (selected != Root2) {
                text := TV2.GetText(selected)
                TV2.Delete(selected)
                newID := TV1.Add(text, Root1)
                TV1.Modify(newID, "Select Vis")
            }
        }
    }

    TransferAllRight(*) {
        while (child := TV1.GetChild(Root1)) {
            text := TV1.GetText(child)
            TV1.Delete(child)
            TV2.Add(text, Root2)
        }
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 5: Drag with Restrictions
;=============================================================================
; Implementing drag rules and validation

Example5_DragRestrictions() {
    myGui := Gui("+Resize", "Example 5: Drag Restrictions")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h400")

    ; Build hierarchical structure
    Root := TV.Add("Organization")

    ; Managers (can't be moved)
    Managers := TV.Add("Managers", Root)
    TV.Add("CEO", Managers)
    TV.Add("CTO", Managers)
    TV.Add("CFO", Managers)

    ; Employees (can be moved between departments)
    Dept1 := TV.Add("Engineering", Root)
    TV.Add("Employee A", Dept1)
    TV.Add("Employee B", Dept1)

    Dept2 := TV.Add("Sales", Root)
    TV.Add("Employee C", Dept2)

    Dept3 := TV.Add("Support", Root)
    TV.Add("Employee D", Dept3)

    TV.Modify(Root, "Expand")

    ; Rules
    rules := "
    (
    DRAG RULES:
    • Managers cannot be moved
    • Employees can only be moved to department folders
    • Cannot move items into Managers folder
    • Department folders cannot be moved
    )"

    rulesText := myGui.Add("Edit", "xm y+10 w500 h120 ReadOnly", rules)

    ; Transfer controls with validation
    myGui.Add("Text", "xm y+10", "Move Employee To:")

    toDept1Btn := myGui.Add("Button", "xm y+5 w150", "→ Engineering")
    toDept1Btn.OnEvent("Click", (*) => MoveToDefpt(Dept1))

    toDept2Btn := myGui.Add("Button", "x+10 yp w150", "→ Sales")
    toDept2Btn.OnEvent("Click", (*) => MoveToDefpt(Dept2))

    toDept3Btn := myGui.Add("Button", "x+10 yp w150", "→ Support")
    toDept3Btn.OnEvent("Click", (*) => MoveToDefpt(Dept3))

    MoveToDefpt(targetDept) {
        if (!(selected := TV.GetSelection()))
            return

        ; Validate source
        parent := TV.GetParent(selected)

        ; Check if it's a manager
        if (parent = Managers) {
            MsgBox("Managers cannot be moved!", "Error", 16)
            return
        }

        ; Check if it's an employee (not a folder)
        if (TV.GetChild(selected)) {
            MsgBox("Cannot move department folders!", "Error", 16)
            return
        }

        ; Check if already in target department
        if (parent = targetDept) {
            MsgBox("Employee is already in this department!", "Info", 64)
            return
        }

        ; Perform move
        text := TV.GetText(selected)
        TV.Delete(selected)
        newID := TV.Add(text, targetDept)
        TV.Modify(targetDept, "Expand")
        TV.Modify(newID, "Select Vis")

        MsgBox("Employee moved successfully!", "Success", 64)
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 6: Drag and Drop with Undo
;=============================================================================
; Implementing undo/redo for drag operations

Example6_DragUndo() {
    myGui := Gui("+Resize", "Example 6: Drag with Undo")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h350")

    ; Build tree
    Root := TV.Add("Tasks")
    Category1 := TV.Add("Category 1", Root)
    TV.Add("Task A", Category1)
    TV.Add("Task B", Category1)
    Category2 := TV.Add("Category 2", Root)
    TV.Add("Task C", Category2)
    TV.Modify(Root, "Expand")

    ; History tracking
    history := []
    historyPos := 0

    ; Info display
    infoText := myGui.Add("Edit", "xm y+10 w500 h150 ReadOnly")

    ; Controls
    undoBtn := myGui.Add("Button", "xm y+10 w100", "Undo")
    undoBtn.OnEvent("Click", Undo)

    redoBtn := myGui.Add("Button", "x+10 yp w100", "Redo")
    redoBtn.OnEvent("Click", Redo)

    clearHistoryBtn := myGui.Add("Button", "x+10 yp w120", "Clear History")
    clearHistoryBtn.OnEvent("Click", ClearHistory)

    ; Simple move controls (for demo)
    moveBtn := myGui.Add("Button", "x+10 yp w100", "Move to Cat 2")
    moveBtn.OnEvent("Click", DoMove)

    DoMove(*) {
        if (!(selected := TV.GetSelection()))
            return
        if (TV.GetChild(selected))  ; Don't move folders
            return

        parent := TV.GetParent(selected)
        if (parent = Category2)
            return

        ; Record action
        action := {
            type: "move",
            itemText: TV.GetText(selected),
            fromParent: parent,
            toParent: Category2,
            itemID: selected
        }

        ; Remove any redo history
        if (historyPos < history.Length)
            history.Length := historyPos

        history.Push(action)
        historyPos := history.Length

        ; Perform move
        text := TV.GetText(selected)
        TV.Delete(selected)
        newID := TV.Add(text, Category2)
        TV.Modify(Category2, "Expand")
        TV.Modify(newID, "Select Vis")

        UpdateInfo()
    }

    Undo(*) {
        if (historyPos > 0) {
            action := history[historyPos]

            ; Find item by text in toParent
            child := TV.GetChild(action.toParent)
            while (child) {
                if (TV.GetText(child) = action.itemText) {
                    ; Move back
                    TV.Delete(child)
                    newID := TV.Add(action.itemText, action.fromParent)
                    TV.Modify(action.fromParent, "Expand")
                    TV.Modify(newID, "Select Vis")
                    break
                }
                child := TV.GetNext(child)
            }

            historyPos--
            UpdateInfo()
        }
    }

    Redo(*) {
        if (historyPos < history.Length) {
            historyPos++
            action := history[historyPos]

            ; Find item by text in fromParent
            child := TV.GetChild(action.fromParent)
            while (child) {
                if (TV.GetText(child) = action.itemText) {
                    ; Move forward
                    TV.Delete(child)
                    newID := TV.Add(action.itemText, action.toParent)
                    TV.Modify(action.toParent, "Expand")
                    TV.Modify(newID, "Select Vis")
                    break
                }
                child := TV.GetNext(child)
            }

            UpdateInfo()
        }
    }

    ClearHistory(*) {
        history := []
        historyPos := 0
        UpdateInfo()
    }

    UpdateInfo() {
        info := "HISTORY:`n"
        info .= "Position: " . historyPos . " / " . history.Length . "`n`n"

        if (history.Length > 0) {
            info .= "Actions:`n"
            for index, action in history {
                marker := (index = historyPos) ? " ← Current" : ""
                info .= index . ". Move '" . action.itemText . "'" . marker . "`n"
            }
        } else {
            info .= "No history"
        }

        infoText.Value := info
    }

    UpdateInfo()

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 7: Complete Drag-Drop System
;=============================================================================
; Full-featured drag-and-drop implementation

Example7_CompleteDragDrop() {
    myGui := Gui("+Resize", "Example 7: Complete Drag-Drop")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w500 h350")

    ; Build tree
    Root := TV.Add("Project")
    Loop 3 {
        folder := TV.Add("Folder " . A_Index, Root)
        Loop 3 {
            TV.Add("Item " . A_Index, folder)
        }
    }
    TV.Modify(Root, "Expand")

    ; Drag-drop manager

    ; Create manager
    ddManager := DragDropManager(TV)

    ; Events
    TV.OnEvent("Click", OnClick)

    OnClick(GuiCtrl, ItemID) {
        if (ddManager.StartDrag(ItemID)) {
            SetTimer(CheckDrop, 50)
        }
    }

    CheckDrop() {
        if (!GetKeyState("LButton", "P")) {
            targetID := TV.GetSelection()
            ddManager.EndDrag(targetID)
            SetTimer(, 0)
        }
    }

    ; Info
    infoText := myGui.Add("Text", "xm y+10 w500",
        "Drag and drop items to reorganize. Folders can be moved with contents.")

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; REFERENCE SECTION
;=============================================================================
/*
DRAG-DROP IMPLEMENTATION:

TreeView doesn't have built-in drag-drop, so you must implement it:

1. TRACK MOUSE EVENTS:
- OnEvent("Click") - Start drag
- SetTimer - Track mouse position
- GetKeyState("LButton") - Detect release

2. VISUAL FEEDBACK:
- Modify source item (Bold, etc.)
- Update status text
- Highlight valid drop targets

3. VALIDATE DROPS:
- Check drop target validity
- Prevent circular references
- Enforce business rules

4. PERFORM MOVE:
- Save item properties
- Delete from source
- Add to destination
- Restore properties

BEST PRACTICES:
1. Provide clear visual feedback
2. Validate all drops before executing
3. Preserve node properties and children
4. Implement undo for complex operations
5. Consider drag cancellation (Escape key)
6. Test edge cases thoroughly

COMMON VALIDATIONS:
- Can't drop on self
- Can't drop on descendants
- Can't drop on invalid targets
- Can't create circular references
- Business rule enforcement

PERFORMANCE CONSIDERATIONS:
- Use timers efficiently
- Cache node properties
- Batch tree updates
- Minimize redraws during drag
*/

; Uncomment to run examples:
; Example1_BasicDragDrop()
; Example2_VisualFeedback()
; Example3_ReorderSiblings()
; Example4_CrossTreeDrag()
; Example5_DragRestrictions()
; Example6_DragUndo()
; Example7_CompleteDragDrop()

; Moved class DragDropManager from nested scope
class DragDropManager {
    __New(treeView) {
        this.TV := treeView
        this.isDragging := false
        this.sourceID := 0
        this.timer := 0
    }

    StartDrag(itemID) {
        if (!itemID || !this.TV.GetParent(itemID))
            return false

        this.isDragging := true
        this.sourceID := itemID
        this.TV.Modify(itemID, "Bold")
        return true
    }

    EndDrag(targetID) {
        if (!this.isDragging)
            return false

        success := false
        if (targetID && targetID != this.sourceID) {
            ; Validate drop
            if (this.ValidateDrop(this.sourceID, targetID)) {
                this.PerformMove(this.sourceID, targetID)
                success := true
            }
        }

        this.isDragging := false
        this.sourceID := 0
        return success
    }

    ValidateDrop(sourceID, targetID) {
        ; Can't drop on self
        if (sourceID = targetID)
            return false

        ; Can't drop on descendant
        if (this.IsDescendant(sourceID, targetID))
            return false

        return true
    }

    IsDescendant(ancestorID, nodeID) {
        parent := this.TV.GetParent(nodeID)
        while (parent) {
            if (parent = ancestorID)
                return true
            parent := this.TV.GetParent(parent)
        }
        return false
    }

    PerformMove(sourceID, targetID) {
        text := this.TV.GetText(sourceID)

        ; Copy children if any
        children := this.CollectChildren(sourceID)

        ; Delete source
        this.TV.Delete(sourceID)

        ; Add to target
        newID := this.TV.Add(text, targetID)

        ; Restore children
        this.RestoreChildren(newID, children)

        this.TV.Modify(targetID, "Expand")
        this.TV.Modify(newID, "Select Vis")
    }

    CollectChildren(parentID) {
        children := []
        child := this.TV.GetChild(parentID)
        while (child) {
            childData := {
                text: this.TV.GetText(child),
                children: this.CollectChildren(child)
            }
            children.Push(childData)
            child := this.TV.GetNext(child)
        }
        return children
    }

    RestoreChildren(parentID, children) {
        for childData in children {
            newChild := this.TV.Add(childData.text, parentID)
            if (childData.children.Length > 0)
                this.RestoreChildren(newChild, childData.children)
        }
    }
}
