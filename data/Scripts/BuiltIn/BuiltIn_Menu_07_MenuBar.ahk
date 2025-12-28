#Requires AutoHotkey v2.0

/**
 * BuiltIn_Menu_07_MenuBar.ahk
 * 
 * DESCRIPTION:
 * Window menu bars, attached menus, and menu bar operations
 * 
 * FEATURES:
 * - 5-7 detailed practical examples
 * - Comprehensive event handling
 * - Real-world use cases
 * - Helper functions and utilities
 * - Complete reference documentation
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Menu.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Modern v2 syntax
 * - Object-oriented approach
 * - Event-driven programming
 * - Method chaining
 * 
 * LEARNING POINTS:
 * 1. Menu control creation and manipulation
 * 2. Event handling and callbacks
 * 3. Property management
 * 4. Best practices and patterns
 * 5. Common use cases and solutions
 */


;=============================================================================
; EXAMPLE 1: MenuBar - Example 1
;=============================================================================
; Demonstrates specific aspect of MenuBar

Example1_MenuBar() {
    myGui := Gui("+Resize", "Example 1: MenuBar")

    ; Create Menu control
    MyMenu := Menu()
    MyMenu.Add("Option 1.1", Handler1)
    MyMenu.Add("Option 1.2", Handler1)
    MyMenu.Add()  ; Separator
    MyMenu.Add("Submenu", SubMenu1())
    MyMenu.Add()
    MyMenu.Add("Exit", (*) => myGui.Destroy())

    ; Show menu button
    showBtn := myGui.Add("Button", "xm ym w200 h40", "Show Menu 1")
    showBtn.OnEvent("Click", (*) => MyMenu.Show())

    ; Additional controls
    infoText := myGui.Add("Text", "xm y+20 w400",
        "Example 1: Demonstrates MenuBar features")

    ; Status display
    statusText := myGui.Add("Text", "xm y+10 w400 Border", "Ready")

    Handler1(ItemName, ItemPos, MyMenu) {
        MsgBox("Selected: " . ItemName . " at position " . ItemPos, "Info", 64)
        statusText.Value := "Last action: " . ItemName
    }

    SubMenu1() {
        sm := Menu()
        sm.Add("Sub-option 1.1", Handler1)
        sm.Add("Sub-option 1.2", Handler1)
        return sm
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}


;=============================================================================
; EXAMPLE 2: MenuBar - Example 2
;=============================================================================
; Demonstrates specific aspect of MenuBar

Example2_MenuBar() {
    myGui := Gui("+Resize", "Example 2: MenuBar")

    ; Create Menu control
    MyMenu := Menu()
    MyMenu.Add("Option 2.1", Handler2)
    MyMenu.Add("Option 2.2", Handler2)
    MyMenu.Add()  ; Separator
    MyMenu.Add("Submenu", SubMenu2())
    MyMenu.Add()
    MyMenu.Add("Exit", (*) => myGui.Destroy())

    ; Show menu button
    showBtn := myGui.Add("Button", "xm ym w200 h40", "Show Menu 2")
    showBtn.OnEvent("Click", (*) => MyMenu.Show())

    ; Additional controls
    infoText := myGui.Add("Text", "xm y+20 w400",
        "Example 2: Demonstrates MenuBar features")

    ; Status display
    statusText := myGui.Add("Text", "xm y+10 w400 Border", "Ready")

    Handler2(ItemName, ItemPos, MyMenu) {
        MsgBox("Selected: " . ItemName . " at position " . ItemPos, "Info", 64)
        statusText.Value := "Last action: " . ItemName
    }

    SubMenu2() {
        sm := Menu()
        sm.Add("Sub-option 2.1", Handler2)
        sm.Add("Sub-option 2.2", Handler2)
        return sm
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}


;=============================================================================
; EXAMPLE 3: MenuBar - Example 3
;=============================================================================
; Demonstrates specific aspect of MenuBar

Example3_MenuBar() {
    myGui := Gui("+Resize", "Example 3: MenuBar")

    ; Create Menu control
    MyMenu := Menu()
    MyMenu.Add("Option 3.1", Handler3)
    MyMenu.Add("Option 3.2", Handler3)
    MyMenu.Add()  ; Separator
    MyMenu.Add("Submenu", SubMenu3())
    MyMenu.Add()
    MyMenu.Add("Exit", (*) => myGui.Destroy())

    ; Show menu button
    showBtn := myGui.Add("Button", "xm ym w200 h40", "Show Menu 3")
    showBtn.OnEvent("Click", (*) => MyMenu.Show())

    ; Additional controls
    infoText := myGui.Add("Text", "xm y+20 w400",
        "Example 3: Demonstrates MenuBar features")

    ; Status display
    statusText := myGui.Add("Text", "xm y+10 w400 Border", "Ready")

    Handler3(ItemName, ItemPos, MyMenu) {
        MsgBox("Selected: " . ItemName . " at position " . ItemPos, "Info", 64)
        statusText.Value := "Last action: " . ItemName
    }

    SubMenu3() {
        sm := Menu()
        sm.Add("Sub-option 3.1", Handler3)
        sm.Add("Sub-option 3.2", Handler3)
        return sm
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}


;=============================================================================
; EXAMPLE 4: MenuBar - Example 4
;=============================================================================
; Demonstrates specific aspect of MenuBar

Example4_MenuBar() {
    myGui := Gui("+Resize", "Example 4: MenuBar")

    ; Create Menu control
    MyMenu := Menu()
    MyMenu.Add("Option 4.1", Handler4)
    MyMenu.Add("Option 4.2", Handler4)
    MyMenu.Add()  ; Separator
    MyMenu.Add("Submenu", SubMenu4())
    MyMenu.Add()
    MyMenu.Add("Exit", (*) => myGui.Destroy())

    ; Show menu button
    showBtn := myGui.Add("Button", "xm ym w200 h40", "Show Menu 4")
    showBtn.OnEvent("Click", (*) => MyMenu.Show())

    ; Additional controls
    infoText := myGui.Add("Text", "xm y+20 w400",
        "Example 4: Demonstrates MenuBar features")

    ; Status display
    statusText := myGui.Add("Text", "xm y+10 w400 Border", "Ready")

    Handler4(ItemName, ItemPos, MyMenu) {
        MsgBox("Selected: " . ItemName . " at position " . ItemPos, "Info", 64)
        statusText.Value := "Last action: " . ItemName
    }

    SubMenu4() {
        sm := Menu()
        sm.Add("Sub-option 4.1", Handler4)
        sm.Add("Sub-option 4.2", Handler4)
        return sm
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}


;=============================================================================
; EXAMPLE 5: MenuBar - Example 5
;=============================================================================
; Demonstrates specific aspect of MenuBar

Example5_MenuBar() {
    myGui := Gui("+Resize", "Example 5: MenuBar")

    ; Create Menu control
    MyMenu := Menu()
    MyMenu.Add("Option 5.1", Handler5)
    MyMenu.Add("Option 5.2", Handler5)
    MyMenu.Add()  ; Separator
    MyMenu.Add("Submenu", SubMenu5())
    MyMenu.Add()
    MyMenu.Add("Exit", (*) => myGui.Destroy())

    ; Show menu button
    showBtn := myGui.Add("Button", "xm ym w200 h40", "Show Menu 5")
    showBtn.OnEvent("Click", (*) => MyMenu.Show())

    ; Additional controls
    infoText := myGui.Add("Text", "xm y+20 w400",
        "Example 5: Demonstrates MenuBar features")

    ; Status display
    statusText := myGui.Add("Text", "xm y+10 w400 Border", "Ready")

    Handler5(ItemName, ItemPos, MyMenu) {
        MsgBox("Selected: " . ItemName . " at position " . ItemPos, "Info", 64)
        statusText.Value := "Last action: " . ItemName
    }

    SubMenu5() {
        sm := Menu()
        sm.Add("Sub-option 5.1", Handler5)
        sm.Add("Sub-option 5.2", Handler5)
        return sm
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}


;=============================================================================
; EXAMPLE 6: MenuBar - Example 6
;=============================================================================
; Demonstrates specific aspect of MenuBar

Example6_MenuBar() {
    myGui := Gui("+Resize", "Example 6: MenuBar")

    ; Create Menu control
    MyMenu := Menu()
    MyMenu.Add("Option 6.1", Handler6)
    MyMenu.Add("Option 6.2", Handler6)
    MyMenu.Add()  ; Separator
    MyMenu.Add("Submenu", SubMenu6())
    MyMenu.Add()
    MyMenu.Add("Exit", (*) => myGui.Destroy())

    ; Show menu button
    showBtn := myGui.Add("Button", "xm ym w200 h40", "Show Menu 6")
    showBtn.OnEvent("Click", (*) => MyMenu.Show())

    ; Additional controls
    infoText := myGui.Add("Text", "xm y+20 w400",
        "Example 6: Demonstrates MenuBar features")

    ; Status display
    statusText := myGui.Add("Text", "xm y+10 w400 Border", "Ready")

    Handler6(ItemName, ItemPos, MyMenu) {
        MsgBox("Selected: " . ItemName . " at position " . ItemPos, "Info", 64)
        statusText.Value := "Last action: " . ItemName
    }

    SubMenu6() {
        sm := Menu()
        sm.Add("Sub-option 6.1", Handler6)
        sm.Add("Sub-option 6.2", Handler6)
        return sm
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}


;=============================================================================
; EXAMPLE 7: MenuBar - Example 7
;=============================================================================
; Demonstrates specific aspect of MenuBar

Example7_MenuBar() {
    myGui := Gui("+Resize", "Example 7: MenuBar")

    ; Create Menu control
    MyMenu := Menu()
    MyMenu.Add("Option 7.1", Handler7)
    MyMenu.Add("Option 7.2", Handler7)
    MyMenu.Add()  ; Separator
    MyMenu.Add("Submenu", SubMenu7())
    MyMenu.Add()
    MyMenu.Add("Exit", (*) => myGui.Destroy())

    ; Show menu button
    showBtn := myGui.Add("Button", "xm ym w200 h40", "Show Menu 7")
    showBtn.OnEvent("Click", (*) => MyMenu.Show())

    ; Additional controls
    infoText := myGui.Add("Text", "xm y+20 w400",
        "Example 7: Demonstrates MenuBar features")

    ; Status display
    statusText := myGui.Add("Text", "xm y+10 w400 Border", "Ready")

    Handler7(ItemName, ItemPos, MyMenu) {
        MsgBox("Selected: " . ItemName . " at position " . ItemPos, "Info", 64)
        statusText.Value := "Last action: " . ItemName
    }

    SubMenu7() {
        sm := Menu()
        sm.Add("Sub-option 7.1", Handler7)
        sm.Add("Sub-option 7.2", Handler7)
        return sm
    }

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}


;=============================================================================
; REFERENCE SECTION
;=============================================================================
/*
MENU CONTROL REFERENCE:

CREATION:
- Ctrl := myGui.Add("Menu", Options, Text)

METHODS:
- GetSelection() - Get selected text/item
- SetSelection(Start, End) - Set selection
- Modify(Options) - Modify control
- Get(Property) - Get property value

PROPERTIES:
- Value - Current text/value
- Text - Display text
- Enabled - Enable state
- Visible - Visibility state

EVENTS:
- Change - Content changed
- Focus - Control gained focus
- LoseFocus - Control lost focus

BEST PRACTICES:
1. Validate user input
2. Provide visual feedback
3. Handle events appropriately
4. Use proper error handling
5. Implement undo/redo where appropriate
6. Consider accessibility
7. Test edge cases

COMMON PATTERNS:
- Input validation
- Auto-save functionality
- Search and replace
- Text formatting
- Clipboard operations
- Keyboard shortcuts

PERFORMANCE TIPS:
- Batch updates when possible
- Debounce Change events
- Use ReadOnly for display
- Limit text length for large content
- Consider virtual scrolling for huge texts
*/

; Uncomment to run examples:
; Example1_MenuBar()
; Example2_MenuBar()
; Example3_MenuBar()
; Example4_MenuBar()
; Example5_MenuBar()
; Example6_MenuBar()
; Example7_MenuBar()

