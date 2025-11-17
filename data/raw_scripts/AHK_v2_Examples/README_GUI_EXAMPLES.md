# AutoHotkey v2 GUI Examples - Comprehensive Collection

## Overview
This collection contains 20 comprehensive AutoHotkey v2 example files demonstrating GUI creation, controls, events, and advanced techniques.

**Location:** `/home/user/AHKv2_Finetune/data/raw_scripts/AHK_v2_Examples/`

## Statistics
- **Total Files:** 20
- **Total Lines of Code:** 13,227
- **Total Examples:** 277+
- **Average Lines per File:** 661
- **Average Examples per File:** 13+

## File Categories

### 1. Basic GUI (Files 01-04)
Fundamental window creation and management

| File | Title | Lines | Topics |
|------|-------|-------|--------|
| BuiltIn_Gui_01.ahk | Basic GUI Creation and Window Management | 537 | Simple windows, properties, modal/modeless, cleanup |
| BuiltIn_Gui_02.ahk | GUI Layouts and Positioning | 527 | Absolute/relative positioning, grid layouts, anchoring |
| BuiltIn_Gui_03.ahk | Window Sizing and Constraints | 604 | Fixed/resizable, min/max constraints, fullscreen |
| BuiltIn_Gui_04.ahk | Multi-Window Management | 965 | Parent-child, communication, MDI patterns, focus |

### 2. GUI Controls (Files 05-08)
Standard GUI control elements

| File | Title | Lines | Topics |
|------|-------|-------|--------|
| BuiltIn_GuiControls_01.ahk | Button and Text Controls | 726 | Button types, text formatting, states, groups |
| BuiltIn_GuiControls_02.ahk | Edit and Input Controls | 866 | Single/multi-line, passwords, validation, search |
| BuiltIn_GuiControls_03.ahk | Checkbox and Radio Controls | 816 | Checkboxes, radio buttons, three-state, groups |
| BuiltIn_GuiControls_04.ahk | DropDownList, ComboBox, ListBox | 578 | Lists, selection, sorting, filtering |

### 3. GUI Events (Files 09-12)
Event handling and management

| File | Title | Lines | Topics |
|------|-------|-------|--------|
| BuiltIn_GuiEvents_01.ahk | OnClick Event Handling | 529 | Click events, double-click, propagation, counters |
| BuiltIn_GuiEvents_02.ahk | OnChange Event Handling | 529 | Change events, real-time validation, tracking |
| BuiltIn_GuiEvents_03.ahk | Custom Event Handlers | 529 | Custom events, callbacks, async, delegation |
| BuiltIn_GuiEvents_04.ahk | Input Validation Events | 529 | Validation, error handling, multi-field |

### 4. GUI ListView (Files 13-16)
ListView control demonstrations

| File | Title | Lines | Topics |
|------|-------|-------|--------|
| BuiltIn_GuiListView_01.ahk | Basic ListView Operations | 795 | Creation, data management, selection, events |
| BuiltIn_GuiListView_02.ahk | ListView Columns and Sorting | 795 | Column management, sorting, reordering |
| BuiltIn_GuiListView_03.ahk | ListView Context Menus | 795 | Right-click menus, operations, export |
| BuiltIn_GuiListView_04.ahk | Advanced ListView Features | 795 | Icons, checkboxes, editing, drag-drop |

### 5. GUI Advanced (Files 17-20)
Advanced GUI techniques

| File | Title | Lines | Topics |
|------|-------|-------|--------|
| BuiltIn_GuiAdvanced_01.ahk | Custom GUI Controls | 578 | Custom controls, subclassing, widgets |
| BuiltIn_GuiAdvanced_02.ahk | Owner-Drawn Controls | 578 | Custom drawing, gradients, hover states |
| BuiltIn_GuiAdvanced_03.ahk | Tab Control Management | 578 | Tabs, navigation, dynamic tabs, nested |
| BuiltIn_GuiAdvanced_04.ahk | Menu Bar and Context Menus | 578 | Menu bars, submenus, shortcuts, status |

## Features

### Every File Includes:
- ✓ `#Requires AutoHotkey v2.0` directive
- ✓ Comprehensive JSDoc documentation
- ✓ 7+ practical examples per file
- ✓ 400-600+ lines of code
- ✓ Main menu launcher for easy navigation
- ✓ Real-world practical examples

### Example Types Covered:
- **Dialog Boxes:** Input dialogs, confirmation dialogs, about dialogs
- **Forms:** Registration forms, settings panels, survey forms
- **Data Entry:** Validation, auto-complete, character limits
- **File Browsers:** File selection, directory navigation
- **Settings Panels:** Preferences, configuration, toggles
- **Dashboards:** Status displays, metrics, system monitoring
- **Data Management:** ListViews, tables, CRUD operations
- **Interactive Controls:** Real-time updates, event handling

## Usage

### Running Individual Files
Each file can be run independently:
```bash
AutoHotkey.exe BuiltIn_Gui_01.ahk
```

### Main Menu Launcher
Every file includes a built-in main menu that allows you to:
1. See all available examples
2. Launch any example individually
3. Navigate between examples easily

Simply run the file and select from the menu.

### Example Structure
Each example follows this pattern:
```autohotkey
Example1_FeatureName() {
    ; Create GUI
    myGui := Gui(, "Example Title")
    
    ; Add controls and functionality
    ; ...
    
    ; Show window
    myGui.Show("w600 h450")
}
```

## Learning Path

### Beginner (Start Here)
1. BuiltIn_Gui_01.ahk - Basic window creation
2. BuiltIn_GuiControls_01.ahk - Buttons and text
3. BuiltIn_GuiEvents_01.ahk - Click handling

### Intermediate
4. BuiltIn_Gui_02.ahk - Layouts
5. BuiltIn_GuiControls_02.ahk - Input controls
6. BuiltIn_GuiControls_03.ahk - Checkboxes and radios
7. BuiltIn_GuiEvents_02.ahk - Change events

### Advanced
8. BuiltIn_Gui_04.ahk - Multi-window management
9. BuiltIn_GuiListView series - Data management
10. BuiltIn_GuiAdvanced series - Custom controls

## Requirements

- **AutoHotkey Version:** v2.0 or higher
- **Operating System:** Windows
- **Knowledge Level:** Beginner to Advanced

## File Organization

```
AHK_v2_Examples/
├── BuiltIn_Gui_01.ahk           # Basic GUI
├── BuiltIn_Gui_02.ahk           # Layouts
├── BuiltIn_Gui_03.ahk           # Sizing
├── BuiltIn_Gui_04.ahk           # Multi-window
├── BuiltIn_GuiControls_01.ahk   # Buttons/Text
├── BuiltIn_GuiControls_02.ahk   # Edit controls
├── BuiltIn_GuiControls_03.ahk   # Checkbox/Radio
├── BuiltIn_GuiControls_04.ahk   # Lists
├── BuiltIn_GuiEvents_01.ahk     # Click events
├── BuiltIn_GuiEvents_02.ahk     # Change events
├── BuiltIn_GuiEvents_03.ahk     # Custom events
├── BuiltIn_GuiEvents_04.ahk     # Validation
├── BuiltIn_GuiListView_01.ahk   # Basic ListView
├── BuiltIn_GuiListView_02.ahk   # Columns/Sorting
├── BuiltIn_GuiListView_03.ahk   # Context menus
├── BuiltIn_GuiListView_04.ahk   # Advanced ListView
├── BuiltIn_GuiAdvanced_01.ahk   # Custom controls
├── BuiltIn_GuiAdvanced_02.ahk   # Owner-drawn
├── BuiltIn_GuiAdvanced_03.ahk   # Tab controls
└── BuiltIn_GuiAdvanced_04.ahk   # Menus
```

## Notes

- All examples are self-contained and can run independently
- Code follows AutoHotkey v2 best practices
- Examples demonstrate real-world use cases
- Each file includes error handling where appropriate
- Comments explain complex concepts
- Code is formatted for readability

## Created

Date: 2024
Purpose: Fine-tuning dataset for AutoHotkey v2 GUI development
Total Scope: 20 files, 13,227 lines, 277+ examples
