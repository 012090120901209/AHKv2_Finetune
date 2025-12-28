#Requires AutoHotkey v2.0
#Include JSON.ahk

/**
 * BuiltIn_TreeView_08_DataBinding.ahk
 * 
 * DESCRIPTION:
 * Demonstrates binding hierarchical data structures to TreeView controls,
 * including JSON, XML-like structures, and database-style data.
 * 
 * FEATURES:
 * - Binding objects and maps to TreeView
 * - Loading JSON data into tree structure
 * - Hierarchical data representation
 * - Two-way data binding
 * - Dynamic data updates
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/TreeView.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Map and Array data structures
 * - Object manipulation
 * - JSON parsing (via external library concepts)
 * - Recursive data processing
 * 
 * LEARNING POINTS:
 * 1. Maps and Arrays can represent tree structures
 * 2. Recursive functions traverse hierarchical data
 * 3. Maintain mapping between TreeView items and data
 * 4. Update TreeView when data changes
 * 5. Extract data from TreeView structure
 */

;=============================================================================
; EXAMPLE 1: Binding Object Data
;=============================================================================
; Load hierarchical object data into TreeView

Example1_ObjectBinding() {
    myGui := Gui("+Resize", "Example 1: Object Data Binding")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w600 h450")

    ; Sample hierarchical data structure
    companyData := {
        name: "Tech Corp",
        employees: [{
            name: "John Doe",
            role: "CEO",
            department: "Executive"
        }, {
            name: "Jane Smith",
            role: "CTO",
            department: "Technology",
            team: [{
                name: "Bob Johnson", role: "Senior Dev" }, {
                    name: "Alice Williams", role: "Dev"
                }
            ]
        }, {
            name: "Mike Brown",
            role: "CFO",
            department: "Finance"
        }
        ]
    }

    ; Bind data to tree
    BindObjectToTree(TV, companyData, 0)

    ; Expand first level
    root := TV.GetNext()
    TV.Modify(root, "Expand")

    infoText := myGui.Add("Edit", "xm y+10 w600 h120 ReadOnly",
        "Object data bound to TreeView. Hierarchical structures are represented as nodes.")

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

; Recursively bind object to tree
BindObjectToTree(TV, data, parentID := 0) {
    if (Type(data) = "Object" || Type(data) = "Map") {
        for key, value in (Type(data) = "Map" ? data : data.OwnProps()) {
            if (Type(value) = "Object" || Type(value) = "Array" || Type(value) = "Map") {
                nodeID := TV.Add(key, parentID)
                BindObjectToTree(TV, value, nodeID)
            } else {
                TV.Add(key . ": " . value, parentID)
            }
        }
    } else if (Type(data) = "Array") {
        for index, item in data {
            if (Type(item) = "Object" || Type(item) = "Array" || Type(item) = "Map") {
                nodeID := TV.Add("[" . index . "]", parentID)
                BindObjectToTree(TV, item, nodeID)
            } else {
                TV.Add("[" . index . "]: " . item, parentID)
            }
        }
    }
}

;=============================================================================
; EXAMPLE 2: Map Data Binding
;=============================================================================
; Binding Map structures to TreeView

Example2_MapBinding() {
    myGui := Gui("+Resize", "Example 2: Map Data Binding")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w600 h450")

    ; Create hierarchical Map structure
    projectData := Map(
        "Project", Map(
            "Name", "Web Application",
            "Status", "In Progress",
            "Team", Map(
                "Lead", "Sarah Connor",
                "Developers", ["Dev1", "Dev2", "Dev3"]
            ),
            "Tasks", [
                Map("Name", "Frontend", "Status", "Complete"),
                Map("Name", "Backend", "Status", "In Progress"),
                Map("Name", "Testing", "Status", "Pending")
            ]
        )
    )

    ; Bind Map to TreeView
    BindMapToTree(TV, projectData, 0)

    ; Expand all
    ExpandAll(TV, TV.GetNext())

    ; Info
    infoText := myGui.Add("Text", "xm y+10 w600",
        "Map data structure bound to TreeView with nested hierarchies.")

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

BindMapToTree(TV, data, parentID) {
    if (Type(data) = "Map") {
        for key, value in data {
            if (Type(value) = "Map" || Type(value) = "Array") {
                nodeID := TV.Add(key, parentID)
                BindMapToTree(TV, value, nodeID)
            } else {
                TV.Add(key . " = " . value, parentID)
            }
        }
    } else if (Type(data) = "Array") {
        for index, item in data {
            if (Type(item) = "Map" || Type(item) = "Array") {
                nodeID := TV.Add("Item " . index, parentID)
                BindMapToTree(TV, item, nodeID)
            } else {
                TV.Add(item, parentID)
            }
        }
    }
}

ExpandAll(TV, nodeID) {
    if (nodeID)
        TV.Modify(nodeID, "Expand")
    child := TV.GetChild(nodeID)
    while (child) {
        ExpandAll(TV, child)
        child := TV.GetNext(child)
    }
}

;=============================================================================
; EXAMPLE 3: JSON-Style Data
;=============================================================================
; Representing JSON-like data in TreeView

Example3_JSONData() {
    myGui := Gui("+Resize", "Example 3: JSON-Style Data")

    ; Create TreeView with checkboxes
    TV := myGui.Add("TreeView", "w600 h400")

    ; Simulate JSON data structure
    jsonData := '
        (
        {
            "users": [
            {
                "id": 1, "name": "Alice", "active": true},
                {
                    "id": 2, "name": "Bob", "active": false
                }
                ],
                "settings": {
                    "theme": "dark",
                    "language": "en",
                    "notifications": true
                }
            }
            )'

    ; Parse and display (simplified parsing)
    Root := TV.Add("Root Data", 0)

    ; Users
    UsersNode := TV.Add("users (Array)", Root)
    User1 := TV.Add("User 1", UsersNode)
    TV.Add("id: 1", User1)
    TV.Add("name: Alice", User1)
    TV.Add("active: true", User1)

    User2 := TV.Add("User 2", UsersNode)
    TV.Add("id: 2", User2)
    TV.Add("name: Bob", User2)
    TV.Add("active: false", User2)

    ; Settings
    SettingsNode := TV.Add("settings (Object)", Root)
    TV.Add("theme: dark", SettingsNode)
    TV.Add("language: en", SettingsNode)
    TV.Add("notifications: true", SettingsNode)

    TV.Modify(Root, "Expand")
    ExpandAll(TV, Root)

    ; Display JSON
    jsonDisplay := myGui.Add("Edit", "xm y+10 w600 h180 ReadOnly", jsonData)

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 4: Two-Way Data Binding
;=============================================================================
; Synchronize changes between TreeView and data structure

Example4_TwoWayBinding() {
    myGui := Gui("+Resize", "Example 4: Two-Way Data Binding")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w600 h350")

    ; Data structure
    dataStore := Map(
        "Name", "Project Alpha",
        "Priority", "High",
        "Tasks", []
    )

    ; Item to data mapping
    itemDataMap := Map()

    ; Load data into tree
    LoadData() {
        TV.Delete()
        itemDataMap.Clear()

        Root := TV.Add("Project", 0)
        itemDataMap[Root] := { type: "root", data: dataStore }

        for key, value in dataStore {
            if (Type(value) = "Array") {
                arrNode := TV.Add(key . " (" . value.Length . ")", Root)
                itemDataMap[arrNode] := { type: "array", key: key, data: value }
            } else {
                node := TV.Add(key . ": " . value, Root)
                itemDataMap[node] := { type: "value", key: key, value: value }
            }
        }

        TV.Modify(Root, "Expand")
    }

    LoadData()

    ; Controls to modify data
    myGui.Add("Text", "xm y+10", "Add Task:")
    taskInput := myGui.Add("Edit", "x+10 yp-3 w200")
    addBtn := myGui.Add("Button", "x+10 yp-0 w100", "Add")
    addBtn.OnEvent("Click", AddTask)

    AddTask(*) {
        taskName := taskInput.Value
        if (taskName) {
            dataStore["Tasks"].Push(taskName)
            LoadData()  ; Refresh tree
            taskInput.Value := ""
        }
    }

    ; Display current data
    dataText := myGui.Add("Edit", "xm y+10 w600 h120 ReadOnly")

    UpdateDataDisplay() {
        output := "Current Data:`n"
        output .= "Name: " . dataStore["Name"] . "`n"
        output .= "Priority: " . dataStore["Priority"] . "`n"
        output .= "Tasks: " . dataStore["Tasks"].Length . " items`n"
        for task in dataStore["Tasks"]
            output .= "  - " . task . "`n"
        dataText.Value := output
    }

    UpdateDataDisplay()
    addBtn.OnEvent("Click", (*) => (SetTimer(UpdateDataDisplay, -100), ""))

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 5: Database-Style Hierarchical Data
;=============================================================================
; Representing parent-child relationships from database

Example5_DatabaseStyle() {
    myGui := Gui("+Resize", "Example 5: Database-Style Data")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w600 h450")

    ; Simulate database records with parent-child relationships
    records := [{
        id: 1, parentId: 0, name: "Root Category" }, {
            id: 2, parentId: 1, name: "Electronics" }, {
                id: 3, parentId: 1, name: "Clothing" }, {
                    id: 4, parentId: 2, name: "Laptops" }, {
                        id: 5, parentId: 2, name: "Phones" }, {
                            id: 6, parentId: 3, name: "Shirts" }, {
                                id: 7, parentId: 3, name: "Pants" }, {
                                    id: 8, parentId: 4, name: "Gaming Laptops" }, {
                                        id: 9, parentId: 4, name: "Business Laptops"
                                    }
    ]

    ; ID to TreeView item mapping
    idToNode := Map()

    ; Build tree from flat structure
    for record in records {
        parentNode := record.parentId = 0 ? 0 : idToNode[record.parentId]
        nodeID := TV.Add(record.name . " (ID: " . record.id . ")", parentNode)
        idToNode[record.id] := nodeID
    }

    ; Expand all
    ExpandAll(TV, TV.GetNext())

    ; Info
    infoText := myGui.Add("Edit", "xm y+10 w600 h120 ReadOnly",
        "Database-style flat records with parent-child relationships`n" .
        "converted to hierarchical TreeView structure.`n`n" .
        "Each record has id and parentId for hierarchy.")

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 6: Data Export from TreeView
;=============================================================================
; Extract hierarchical data from TreeView back to structure

Example6_DataExport() {
    myGui := Gui("+Resize", "Example 6: Data Export")

    ; Create TreeView with checkboxes
    TV := myGui.Add("TreeView", "w600 h350 Checked")

    ; Build sample tree
    Root := TV.Add("Configuration")

    Display := TV.Add("Display", Root)
    TV.Add("Resolution: 1920x1080", Display)
    TV.Add("Refresh Rate: 60Hz", Display)
    TV.Add("Color Depth: 32bit", Display)

    Audio := TV.Add("Audio", Root)
    TV.Add("Volume: 75%", Audio)
    TV.Add("Bass: 50%", Audio)

    Network := TV.Add("Network", Root)
    TV.Add("DHCP: Enabled", Network)
    TV.Add("DNS: Auto", Network)

    TV.Modify(Root, "Expand")

    ; Export button
    exportBtn := myGui.Add("Button", "xm y+10 w150", "Export to Map")
    exportBtn.OnEvent("Click", ExportData)

    ; Export display
    exportText := myGui.Add("Edit", "xm y+10 w600 h180 ReadOnly")

    ExportData(*) {
        exported := ExportTreeToMap(TV, Root)

        output := "Exported Data Structure:`n`n"
        output .= FormatMap(exported)

        exportText.Value := output
    }

    ExportTreeToMap(TV, nodeID) {
        result := Map()
        result["name"] := TV.GetText(nodeID)
        result["checked"] := TV.Get(nodeID, "Check")
        result["children"] := []

        child := TV.GetChild(nodeID)
        while (child) {
            result["children"].Push(ExportTreeToMap(TV, child))
            child := TV.GetNext(child)
        }

        return result
    }

    FormatMap(data, indent := 0) {
        output := ""
        prefix := StrRepeat("  ", indent)

        if (Type(data) = "Map") {
            for key, value in data {
                if (Type(value) = "Array" && value.Length > 0) {
                    output .= prefix . key . ":`n"
                    for item in value
                        output .= FormatMap(item, indent + 1)
                } else if (Type(value) = "Map") {
                    output .= prefix . key . ":`n"
                    output .= FormatMap(value, indent + 1)
                } else {
                    output .= prefix . key . ": " . value . "`n"
                }
            }
        }

        return output
    }

    StrRepeat(str, count) {
        result := ""
        Loop count
            result .= str
        return result
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; EXAMPLE 7: Complete Data Binding System
;=============================================================================
; Full CRUD operations with data binding

Example7_CompleteBinding() {
    myGui := Gui("+Resize", "Example 7: Complete Data Binding")

    ; Create TreeView
    TV := myGui.Add("TreeView", "w600 h350")

    ; Data model
    dataModel := []
    nextId := 1

    ; Node to ID mapping
    nodeToId := Map()
    idToNode := Map()

    ; Load model into tree
    LoadModel() {
        TV.Delete()
        nodeToId.Clear()
        idToNode.Clear()

        Root := TV.Add("Data Model (" . dataModel.Length . " items)", 0)

        for item in dataModel {
            nodeID := TV.Add(item.name . " (Type: " . item.type . ")", Root)
            nodeToId[nodeID] := item.id
            idToNode[item.id] := nodeID
        }

        TV.Modify(Root, "Expand")
    }

    ; CRUD Controls
    myGui.Add("Text", "xm y+10", "Name:")
    nameInput := myGui.Add("Edit", "x+10 yp-3 w200")

    myGui.Add("Text", "x+20 yp+3", "Type:")
    typeDD := myGui.Add("DropDownList", "x+10 yp-3 w100", ["Task", "Note", "Event"])
    typeDD.Choose(1)

    createBtn := myGui.Add("Button", "xm y+10 w100", "Create")
    createBtn.OnEvent("Click", CreateItem)

    updateBtn := myGui.Add("Button", "x+10 yp w100", "Update")
    updateBtn.OnEvent("Click", UpdateItem)

    deleteBtn := myGui.Add("Button", "x+10 yp w100", "Delete")
    deleteBtn.OnEvent("Click", DeleteItem)

    CreateItem(*) {
        name := nameInput.Value
        type := typeDD.Text

        if (!name) {
            MsgBox("Please enter a name", "Info", 64)
            return
        }

        dataModel.Push({ id: nextId++, name: name, type: type })
        LoadModel()
        nameInput.Value := ""
    }

    UpdateItem(*) {
        selected := TV.GetSelection()
        if (!selected || !nodeToId.Has(selected))
            return

        itemId := nodeToId[selected]
        name := nameInput.Value
        type := typeDD.Text

        if (!name)
            return

        ; Find and update item
        for item in dataModel {
            if (item.id = itemId) {
                item.name := name
                item.type := type
                break
            }
        }

        LoadModel()
    }

    DeleteItem(*) {
        selected := TV.GetSelection()
        if (!selected || !nodeToId.Has(selected))
            return

        itemId := nodeToId[selected]

        ; Remove from model
        for index, item in dataModel {
            if (item.id = itemId) {
                dataModel.RemoveAt(index)
                break
            }
        }

        LoadModel()
    }

    ; Selection updates form
    TV.OnEvent("ItemSelect", OnSelect)

    OnSelect(*) {
        selected := TV.GetSelection()
        if (!selected || !nodeToId.Has(selected))
            return

        itemId := nodeToId[selected]

        for item in dataModel {
            if (item.id = itemId) {
                nameInput.Value := item.name
                typeDD.Text := item.type
                break
            }
        }
    }

    ; Status
    statusText := myGui.Add("Text", "xm y+10 w600", "")

    UpdateStatus() {
        statusText.Value := "Total Items: " . dataModel.Length
    }

    createBtn.OnEvent("Click", (*) => (SetTimer(UpdateStatus, -100), ""))
    deleteBtn.OnEvent("Click", (*) => (SetTimer(UpdateStatus, -100), ""))

    UpdateStatus()

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}

;=============================================================================
; REFERENCE SECTION
;=============================================================================
/*
DATA BINDING CONCEPTS:

1. ONE-WAY BINDING:
- Data → TreeView only
- Changes to data reflect in tree
- Reload tree when data changes

2. TWO-WAY BINDING:
- Data ↔ TreeView
- Changes in either direction sync
- Requires mapping between nodes and data

3. DATA STRUCTURES:
- Object: Property-based hierarchies
- Map: Key-value hierarchies
- Array: Indexed collections
- Mixed: Nested combinations

MAPPING STRATEGIES:
- NodeID → Data mapping (Map)
- Data → NodeID mapping (Map)
- Maintain both for fast lookups
- Clear mappings on reload

HIERARCHICAL DATA PATTERNS:
1. Nested Objects/Maps
{
    parent: {child1: {}, child2: {}}
}

2. Parent-Child IDs (Database)
[{id:1, parent:0}, {id:2, parent:1}]

3. Array-based Trees
[item, [child1, child2], [grandchild]]

BEST PRACTICES:
1. Keep data separate from UI
2. Maintain bidirectional mapping
3. Reload tree when data changes
4. Validate data before binding
5. Handle circular references
6. Implement proper serialization
7. Use IDs for stable references

PERFORMANCE:
- Cache mappings
- Batch updates
- Use lazy loading for large datasets
- Minimize tree rebuilds
- Track dirty state
*/

; Uncomment to run examples:
; Example1_ObjectBinding()
; Example2_MapBinding()
; Example3_JSONData()
; Example4_TwoWayBinding()
; Example5_DatabaseStyle()
; Example6_DataExport()
; Example7_CompleteBinding()

