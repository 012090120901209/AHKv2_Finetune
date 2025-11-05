# AutoHotkey v2 Examples - Complete Classification Guide

**Generated:** November 5, 2025
**Total Examples:** 814
**Repository:** AHKv2_Finetune Training Dataset

---

## Table of Contents

1. [Overview](#overview)
2. [Quick Reference by Category](#quick-reference-by-category)
3. [Classification by Difficulty](#classification-by-difficulty)
4. [Classification by Feature Type](#classification-by-feature-type)
5. [Detailed Category Breakdown](#detailed-category-breakdown)
6. [Index by Use Case](#index-by-use-case)
7. [Learning Path](#learning-path)

---

## Overview

This guide classifies all 814 AHK v2 examples in the repository to help you quickly find examples relevant to your learning needs or project requirements.

### Example Count by Category

| Category | Count | Description |
|----------|-------|-------------|
| **String** | 175 | String manipulation, parsing, formatting |
| **File** | 142 | File I/O, directory operations |
| **GUI** | 124 | Graphical user interfaces, controls, dialogs |
| **Window** | 63 | Window management, manipulation |
| **Advanced** | 50 | Complex real-world applications |
| **Control** | 43 | Flow control, loops, conditionals |
| **Misc** | 37 | Miscellaneous utilities |
| **Hotkey** | 34 | Keyboard and mouse input |
| **Lib** | 24 | External libraries, DLL calls |
| **Process** | 20 | Process management |
| **Directive** | 19 | Compiler directives |
| **Env** | 18 | Environment variables, system info |
| **Flow** | 13 | Advanced flow control patterns |
| **Syntax** | 11 | Language syntax examples |
| **Registry** | 10 | Windows Registry operations |
| **Failed** | 8 | Known conversion issues/edge cases |
| **DateTime** | 6 | Date and time operations |
| **Sound** | 5 | Audio operations |
| **Screen** | 5 | Screen/pixel operations |
| **Integrity** | 5 | Code correctness testing |
| **Maths** | 2 | Mathematical operations |

---

## Quick Reference by Category

### 🔤 String Operations (175 examples)

**Basic String Functions:**
- `String_SubStr_ex01.ahk` through `String_SubStr_ex40.ahk` - Substring extraction (40)
- `String_InStr_ex01.ahk` through `String_InStr_ex38.ahk` - Find substring (38)
- `String_StrReplace_ex01.ahk` through `String_StrReplace_ex13.ahk` - Replace text (13)
- `String_StrLen_ex01.ahk`, `String_StrLen_ex02.ahk` - String length (2)
- `String_StrUpper_ex01.ahk`, `String_StrUpper_ex02.ahk` - Case conversion (2)
- `String_StrTitle_ex01.ahk`, `String_StrTitle_ex02.ahk` - Title case (2)
- `String_StrCompare_ex01.ahk` through `String_StrCompare_ex10.ahk` - String comparison (10)

**String Manipulation:**
- `String_Array_ex1.ahk` through `String_Array_ex5.ahk` - Array operations (5)
- `String_Assignment_ex1.ahk` through `String_Assignment_ex13.ahk` - Variable assignment (13)
- `String_StringSplit_ex1.ahk`, `String_StringSplit_ex2.ahk` - String splitting (2)
- `String_StringMid_ex1.ahk`, `String_StringMid_ex2.ahk` - Extract middle (2)
- `String_StringGetPos_ex1.ahk` - Get position (1)

**Advanced String Features:**
- `String_ContinuationWithVar.ahk` through `String_ContinuationWithVar5.ahk` - Multi-line strings (5)
- `String_ContinuationComments_ex1.ahk`, `String_ContinuationComments_ex2.ahk` - Comments in continuations (2)
- `String_EscapedLiteralChars_01.ahk` - Escape sequences (1)
- `String_QuotedObjLiterals_ex1.ahk`, `String_QuotedObjLiterals_ex2.ahk` - Quoted literals (2)
- `String_Ternary_ex2.ahk` through `String_Ternary_ex4.ahk` - Ternary with strings (3)

**String Utilities:**
- `String_StringCaseSense_ex1.ahk` through `String_StringCaseSense_ex3.ahk` - Case sensitivity (3)
- `String_IfInString_ex1.ahk` - Check if substring exists (1)
- `String_ifVarContains_ex1.ahk`, `String_ifVarContains_ex3.ahk` - Variable contains (2)

---

### 📁 File Operations (142 examples)

**File Reading/Writing:**
- `File_FileAppend_ex01.ahk` through `File_FileAppend_ex66.ahk` - Append to files (66)
- `File_Append_ex1.ahk` through `File_Append_ex3.ahk` - File append (3)
- `File_Read_ex1.ahk` - Read file contents (1)
- `File_ReadLine_Issue20.ahk`, `File_ReadLine_Issue20b.ahk` - Read specific lines (2)

**File Management:**
- `File_Copy_ex1.ahk` through `File_Copy_ex3.ahk` - Copy files (3)
- `File_Move_ex1.ahk` through `File_Move_ex4.ahk` - Move/rename files (4)
- `File_Delete_ex1.ahk` - Delete files (1)
- `File_Exists_ex1.ahk` through `File_Exists_ex4.ahk` - Check file existence (4)

**File Properties:**
- `File_FileExist_ex01.ahk` through `File_FileExist_ex04.ahk` - File existence (4)
- `File_GetAttrib_ex1.ahk`, `File_GetAttrib_ex2.ahk` - Get attributes (2)
- `File_SetAttrib_ex1.ahk` through `File_SetAttrib_ex4.ahk` - Set attributes (4)
- `File_GetSize_ex1.ahk`, `File_GetSize_ex2.ahk`, `File_FileGetSize_ex01.ahk` - File size (3)
- `File_GetTime_ex1.ahk`, `File_GetTime_ex2.ahk` - File timestamps (2)
- `File_SetTime_ex1.ahk` through `File_SetTime_ex4.ahk` - Set timestamps (4)
- `File_GetVersion_ex1.ahk`, `File_GetVersion_ex2.ahk` - File version (2)

**Directory Operations:**
- `File_DirCreate_ex01.ahk`, `File_DirCreate_ex02.ahk` - Create directories (2)
- `File_DirDelete_ex01.ahk`, `File_DirDelete_ex02.ahk` - Delete directories (2)
- `File_DirCopy_ex01.ahk`, `File_DirCopy_ex02.ahk` - Copy directories (2)
- `File_DirMove_ex01.ahk`, `File_DirMove_ex02.ahk` - Move directories (2)
- `File_DirSelect_ex01.ahk`, `File_DirSelect_ex02.ahk` - Directory picker (2)
- `File_RemoveDir_ex1.ahk`, `File_RemoveDir_ex2.ahk` - Remove directories (2)

**File Dialogs:**
- `File_SelectFile_ex1.ahk`, `File_SelectFile_ex2.ahk` - File picker (2)

**Drive Operations:**
- `File_Drive_ex1.ahk`, `File_Drive_ex2.ahk` - Drive commands (2)
- `File_DriveGet_ex1.ahk` - Get drive info (1)
- `File_DriveSpaceFree_ex1.ahk` - Free space (1)

**Shortcuts:**
- `File_CreateShortcut_ex1.ahk` - Create shortcuts (1)
- `File_GetShortcut.ahk` - Read shortcuts (1)

**INI Files:**
- `File_IniDelete_ex1.ahk` - INI operations (1)

**Recycling:**
- `File_Recycle_ex1.ahk`, `File_RecycleEmpty_ex1.ahk` - Recycle bin (2)

**Path Operations:**
- `File_SplitPath_ex1.ahk` - Parse file paths (1)

**Working Directory:**
- `File_SetWorkingDir_ex1.ahk`, `File_SetWorkingDir_ex2.ahk` - Set working dir (2)

**File Installation:**
- `File_Install_ex1.ahk` - Include files in compiled scripts (1)

**File Objects:**
- `File_Obj_ex1.ahk` - File object usage (1)

---

### 🖼️ GUI (Graphical User Interface) (124 examples)

**MsgBox (Message Boxes):**
- `GUI_MsgBox_ex01.ahk` through `GUI_MsgBox_ex69.ahk` - Message boxes (69)
- Various formats, options, and use cases

**GUI Creation:**
- `GUI_Gui_ex01.ahk`, `GUI_Gui_ex02.ahk` - Basic GUI (2)
- `GUI_GuiExample1.ahk` - GUI example (1)
- `GUI_Gui-New-Opt.ahk` - GUI options (1)

**GUI Controls:**
- `GUI_GuiControl_test.ahk` - Control testing (1)
- `GUI_GuiControl-Font_ex1.ahk` - Font control (1)
- `GUI_GuiControl-Options.ahk` - Control options (1)
- `GUI_GuiControl-Var_ex1.ahk` - Control variables (1)
- `GUI_GuiControlGet_ex1.ahk` - Get control values (1)
- `GUI_A_GuiControl_ex1.ahk` - A_GuiControl variable (1)

**Input Controls:**
- `GUI_InputBox_ex01.ahk`, `GUI_InputBox_ex02.ahk` - Input boxes (2)
- `GUI_Inputbox_ex1.ahk` through `GUI_Inputbox_ex3.ahk` - More input boxes (3)
- `GUI_Inputbox_all-params.ahk` - All parameters (1)
- `GUI_Inputbox_CBE.ahk` - Input box example (1)

**ListView:**
- `GUI_Listview_1.ahk`, `GUI_Listview_2.ahk` - ListView control (2)

**TreeView:**
- `GUI_Treeview_1.ahk` - TreeView control (1)

**Menus:**
- `GUI_GuiMenu_ex1.ahk` - GUI menus (1)
- `GUI_MenuGetHandle_ex1.ahk` - Menu handles (1)

**Tray Icon:**
- `GUI_Tray_Add_ex01.ahk`, `GUI_Tray_Add_ex02.ahk` - Tray menus (2)

**Status Bar:**
- `GUI_SB_SetParts_ex1.ahk` - Status bar (1)

**Event Handling:**
- `GUI_gLabel_ex1.ahk`, `GUI_gLabel_2025-07-03.ahk` - g-Labels (2)
- `GUI_Anti-gLabel_ex1.ahk` - Anti-gLabel (1)
- `GUI_Gui-Assumed-gLabels.ahk` - Assumed g-labels (1)

**GUI Features:**
- `GUI_Gui-Cancel_ex1.ahk` - Cancel handling (1)
- `GUI_Gui-Hwnd_ex1.ahk` through `GUI_Gui-Hwnd_ex7.ahk` - Window handles (7)
- `GUI_Gui-DDL-ContSec_ex1.ahk` - DropDownList (1)
- `GUI_Gui_ListWithVar_ex1.ahk` - List with variable (1)

**GUI Issues:**
- `GUI_Gui_Issue331.ahk`, `GUI_Gui_issue281_ex1.ahk`, `GUI_Gui_issue_#202.ahk` - Issue examples (3)
- `GUI_Gui_pr_137_fixed.ahk` - Fixed PR (1)

**Message Box Variations:**
- `GUI_MsgBox_continuation.ahk` - Continuation sections (1)
- `GUI_MsgBox_smart-mode-mix-1.ahk`, `GUI_MsgBox_smart-mode-mix-2.ahk` - Smart mode (2)
- `GUI_msgbox_cont-sect-mix.ahk` - Continuation mix (1)
- `GUI_MsgBox_wrong-timeout.ahk` - Timeout issues (1)

---

### 🪟 Window Management (63 examples)

**Window Detection:**
- `Window_WinExist_ex01.ahk` through `Window_WinExist_ex04.ahk` - Check window existence (4)
- `Window_WinActive_ex1.ahk` through `Window_WinActive_ex07.ahk` - Check active window (7)

**Window Activation:**
- `Window_WinActivate_1.ahk` - Activate window (1)

**Window Information:**
- `Window_WinGetTitle_ex1.ahk` through `Window_WinGetTitle_ex05.ahk` - Get title (5)
- `Window_WinGetClass_ex1.ahk` - Get class (1)
- `Window_WinGetPos_ex1.ahk` through `Window_WinGetPos_ex3.ahk` - Get position/size (3)
- `Window_WinGetText_ex1.ahk` - Get window text (1)
- `Window_WinGetActiveTitle_ex1.ahk` - Get active title (1)
- `Window_WinGetActiveStats_ex1.ahk` - Get active stats (1)
- `Window_WinGet_ex1.ahk` through `Window_WinGet_ex4.ahk` - Get window info (4)

**Window Manipulation:**
- `Window_WinMove_ex1.ahk` through `Window_WinMove_ex3.ahk` - Move/resize (3)
- `Window_WinMove_issue_114.ahk`, `Window_WinMove_param_combinations.ahk` - Move variations (2)
- `Window_WinMaximize_test1.ahk` - Maximize (1)
- `Window_WinMinimize_ex1.ahk`, `Window_WinMinimize_ex2.ahk` - Minimize (2)
- `Window_WinMinimizeAll_ex1.ahk` - Minimize all (1)
- `Window_WinRestore_ex1.ahk` - Restore (1)
- `Window_WinHide_ex1.ahk` - Hide window (1)
- `Window_WinClose_ex1.ahk` - Close window (1)
- `Window_WinKill_ex1.ahk` - Force close (1)

**Window Settings:**
- `Window_WinSet_ex1.ahk` through `Window_WinSet_ex10.ahk` - Window settings (10)
- `Window_WinSetTitle_ex1.ahk`, `Window_WinSetTitle_ex2.ahk` - Set title (2)

**Window Waiting:**
- `Window_WinWait_ex1.ahk` - Wait for window (1)
- `Window_WinWaitActive_ex1.ahk` - Wait for active (1)
- `Window_WinWaitClose_ex1.ahk` - Wait for close (1)

**Status Bar:**
- `Window_StatusbargetText_ex1.ahk` - Get status bar (1)
- `Window_StatusbarWait_ex1.ahk` - Wait for status (1)

**Window Options:**
- `Window_SetTitleMatchMode_ex1.ahk`, `Window_SetTitleMatchMode_ex2.ahk` - Title matching (2)
- `Window_SetWinDelay_ex1.ahk` - Window delay (1)
- `Window_DetectHiddenWindows_ex1.ahk` - Detect hidden (1)
- `Window_DetectHiddenText_ex1.ahk` - Detect hidden text (1)

---

### ⚡ Advanced Examples (50 examples)

**GUI Applications:**
- `Advanced_GUI_Calculator.ahk` - Calculator app
- `Advanced_GUI_TodoList.ahk` - Todo list manager
- `Advanced_GUI_TabControl.ahk` - Tab control demo
- `Advanced_GUI_ProgressBar.ahk` - Progress bar
- `Advanced_GUI_ColorPicker.ahk` - RGB color picker
- `Advanced_GUI_DynamicControls.ahk` - Dynamic control creation
- `Advanced_GUI_ContextMenu.ahk` - Context menus
- `Advanced_GUI_SplashScreen.ahk` - Splash screen
- `Advanced_GUI_MultiMonitor.ahk` - Multi-monitor info
- `Advanced_GUI_DataGrid.ahk` - Editable data grid

**Hotkeys & Input:**
- `Advanced_Hotkey_Remapping.ahk` - Key remapping
- `Advanced_Hotkey_WindowSpecific.ahk` - Window-specific hotkeys
- `Advanced_Hotkey_MediaKeys.ahk` - Media controls
- `Advanced_Hotkey_MouseGestures.ahk` - Mouse gestures
- `Advanced_Hotkey_MultiFunction.ahk` - Multi-function keys
- `Advanced_Hotkey_Chords.ahk` - Keyboard chords
- `Advanced_Hotstring_Autocorrect.ahk` - Auto-correct
- `Advanced_Hotstring_SmartQuotes.ahk` - Smart typography

**Data Structures:**
- `Advanced_DataStructure_NestedMaps.ahk` - Nested maps
- `Advanced_DataStructure_Queue.ahk` - Queue implementation
- `Advanced_DataStructure_Stack.ahk` - Stack implementation

**Flow Control:**
- `Advanced_FlowControl_StateMachine.ahk` - State machine
- `Advanced_FlowControl_AsyncCallbacks.ahk` - Async callbacks
- `Advanced_FlowControl_Pipeline.ahk` - Data pipelines
- `Advanced_Loop_Recursive.ahk` - Recursive functions
- `Advanced_Loop_Generator.ahk` - Generator pattern

**File Processing:**
- `Advanced_File_CSVProcessor.ahk` - CSV processor
- `Advanced_File_BatchRename.ahk` - Batch renamer
- `Advanced_File_LogParser.ahk` - Log parser
- `Advanced_File_TextMerger.ahk` - File merger
- `Advanced_File_DuplicateFinder.ahk` - Duplicate finder
- `Advanced_File_BackupManager.ahk` - Backup manager

**Window & Process:**
- `Advanced_Window_Arranger.ahk` - Window arranger
- `Advanced_Window_AlwaysOnTop.ahk` - Always on top
- `Advanced_Window_ClickThrough.ahk` - Click-through overlay
- `Advanced_Window_Spy.ahk` - Window spy tool
- `Advanced_Window_Minimizer.ahk` - Window minimizer
- `Advanced_Process_Monitor.ahk` - Process monitor

**OOP/Classes:**
- `Advanced_Class_EventEmitter.ahk` - Event emitter
- `Advanced_Class_Singleton.ahk` - Singleton pattern
- `Advanced_Class_Factory.ahk` - Factory pattern
- `Advanced_Class_LinkedList.ahk` - Linked list
- `Advanced_Class_Observer.ahk` - Observer pattern

**Utilities:**
- `Advanced_Misc_ClipboardManager.ahk` - Clipboard history
- `Advanced_Misc_ScreenshotTool.ahk` - Screenshot tool
- `Advanced_Misc_SystemInfo.ahk` - System information
- `Advanced_Misc_Stopwatch.ahk` - Stopwatch
- `Advanced_Misc_Countdown.ahk` - Countdown timer
- `Advanced_Misc_PasswordGenerator.ahk` - Password generator
- `Advanced_Misc_UnitConverter.ahk` - Unit converter

---

### 🎮 Control Flow (43 examples)

**Conditionals:**
- `Control_IfEqual_ex1.ahk`, `Control_IfEqual_ex2.ahk` - If equal (2)
- `Control_if_traditional_ex1.ahk`, `Control_if_traditional_ex2.ahk` - Traditional if (2)
- `Control_if-blank-expr_ex1.ahk` - Blank expression (1)
- `Control_if_between_ex1.ahk` - Between check (1)
- `Control_ifVarContains_ex1.ahk`, `Control_ifVarContains_ex3.ahk` - Variable contains (2)
- `Control_if_issue25.ahk`, `Control_if_issue26_ex1.ahk` through `Control_if_issue26_ex3.ahk` - Issue examples (4)
- `Control_if_issue87_ex1.ahk` through `Control_if_issue87_ex3.ahk` - Issue examples (3)

**Switch:**
- `Control_Switch_ex1.ahk`, `Control_Switch_ex2.ahk` - Switch statements (2)

**Ternary:**
- `Control_Ternary_ex1.ahk` - Ternary operator (1)

**Loops:**
- `Control_LoopFiles_ex1.ahk` through `Control_LoopFiles_ex3.ahk` - Loop files (3)
- `Control_LoopParse_ex1.ahk`, `Control_LoopParse_ex3.ahk`, `Control_LoopParse_ex4.ahk` - Parse loop (3)
- `Control_LoopParse_issue_77.ahk` - Parse issue (1)
- `Control_LoopReadFile_ex1.ahk`, `Control_LoopReadFile_ex2.ahk` - Read file loop (2)

**Exception Handling:**
- `Control_Catch_ex1.ahk` - Catch exceptions (1)
- `Control_Exception_ex1.ahk` - Exception handling (1)

**Functions:**
- `Control_Return_ex1-2.ahk` through `Control_Return_ex4.ahk` - Return statements (3)
- `Control_ByRef_ex1.ahk` through `Control_ByRef_ex5.ahk` - Pass by reference (5)

**Timers:**
- `Control_SetTimer_ex1.ahk`, `Control_SetTimer_ex2.ahk` - Timers (2)

**Includes:**
- `Control_#Include_ex1.ahk` through `Control_#Include_ex3.ahk` - Include files (3)

**Misc:**
- `Control_Indentation-Issue349.ahk` - Indentation (1)

---

### 🔧 Miscellaneous (37 examples)

**Functions:**
- `Misc_MyFunc_ex01.ahk`, `Misc_MyFunc_ex02.ahk` - Function examples (2)
- `Misc_func_ex1.ahk` - Function usage (1)
- `Misc_func_A_ThisFunc.ahk` - A_ThisFunc variable (1)
- `Misc_FuncObj-Call_ex1.ahk` - Function object calls (1)
- `Misc_FuncsInObj.ahk` - Functions in objects (1)

**String/Data:**
- `Misc_Concat_ex01.ahk` through `Misc_Concat_ex11.ahk` - Concatenation (11)
- `Misc_Sort_ex01.ahk`, `Misc_Sort_ex02.ahk` - Sorting (2)
- `Misc_isFloat_ex01.ahk` through `Misc_isFloat_ex04.ahk` - Float checking (4)

**File Operations:**
- `Misc_SplitPath_ex01.ahk` through `Misc_SplitPath_ex06.ahk` - Path splitting (6)
- `Misc_DriveGetSpaceFree_ex01.ahk` - Drive space (1)

**Process:**
- `Misc_RunWait_ex01.ahk`, `Misc_RunWait_ex02.ahk` - Run and wait (2)

**Messages:**
- `Misc_SendMessage_ex01.ahk`, `Misc_SendMessage_ex02.ahk` - Send messages (2)

**UI:**
- `Misc_ToolTip_ex01.ahk`, `Misc_ToolTip_ex02.ahk` - Tooltips (2)

**Class:**
- `Misc_Class-Property.ahk` - Class properties (1)

---

### ⌨️ Hotkeys & Input (34 examples)

**Mouse:**
- `Hotkey_Click_ex1.ahk`, `Hotkey_Click_ex2.ahk` - Mouse clicks (2)
- `Hotkey_MousClick_examples.ahk` - Click examples (1)
- `Hotkey_MouseClickDrag_ex1.ahk`, `Hotkey_MouseClickDrag_ex2.ahk` - Click and drag (2)
- `Hotkey_MouseGetPos_ex1.ahk`, `Hotkey_MouseGetPos_ex2.ahk` - Mouse position (2)
- `Hotkey_SetDefaultMouseSpeed_ex1.ahk` - Mouse speed (1)

**Keyboard:**
- `Hotkey_Send_ex1.ahk` - Send keys (1)
- `Hotkey_SendMode_ex1.ahk` - Send mode (1)
- `Hotkey_SendLevel_ex1.ahk` - Send level (1)
- `Hotkey_GetKeyName_ex1.ahk` - Key names (1)
- `Hotkey_GetKeyState_ex1.ahk` - Key state (1)
- `Hotkey_ListOfKeys_ex1.ahk` - Key list (1)

**Key Waiting:**
- `Hotkey_KeyWait_ex5.ahk` through `Hotkey_KeyWait_ex7.ahk` - Key wait (3)

**Input:**
- `Hotkey_Input_ex1.ahk` through `Hotkey_Input_ex3.ahk` - Input handling (3)
- `Hotkey_BlockInput_ex1.ahk` - Block input (1)

**Lock Keys:**
- `Hotkey_SetCapsLockState_ex1.ahk`, `Hotkey_SetCapsLockState_examples.ahk` - CapsLock (2)
- `Hotkey_SetNumLockState_ex1.ahk` - NumLock (1)
- `Hotkey_SetStoreCapsLockMode_ex1.ahk`, `Hotkey_SetStoreCapsLockMoed_ex1.ahk` - Store mode (2)

**Control Input:**
- `Hotkey_controlSend_ex1.ahk`, `Hotkey_controlSend_ex2.ahk` - Control send (2)
- `Hotkey_controlclick_ex1.ahk` through `Hotkey_controlclick_ex3.ahk` - Control click (3)

**Coordinate Modes:**
- `Hotkey_CoordMode_ex1.ahk`, `Hotkey_CoordMode_ex2.ahk` - Coordinate modes (2)

**Key Delays:**
- `Hotkey_SetKeyDelay_ex_1.ahk` - Key delay (1)

---

### 📚 External Libraries (24 examples)

**DLL Calls:**
- `Lib_DllCall_ex5.ahk`, `Lib_DllCall_ex7.ahk`, `Lib_DllCall_ex11.ahk`, `Lib_DllCall_ex12.ahk` - DLL calls (4)

**Memory Operations:**
- `Lib_Numput.ahk` - NumPut (1)
- `Lib_Numput_ex2.ahk` - NumPut example (1)
- `Lib_NumputInNumput_Inline.ahk` - Nested NumPut (1)
- `Lib_NumputInNumput_WithContinuationSection.ahk` - NumPut continuation (1)
- `Lib_VarSetCapacity_ex1.ahk` through `Lib_VarSetCapacity_ex12.ahk` - Buffer capacity (12)

**COM Objects:**
- `Lib_ComObjError_ex1.ahk` - COM error handling (1)
- `Lib_ComObjMissing_ex1.ahk`, `Lib_ComObjMissing_ex2.ahk` - COM missing (2)
- `Lib_ComObjParameter_ex1.ahk` - COM parameters (1)

---

### ⚙️ Process Management (20 examples)

**Running Programs:**
- `Process_Run_ex1.ahk` through `Process_Run_ex7.ahk` - Run processes (7)
- `Process_Runas_ex1.ahk` - Run as admin (1)

**Process Control:**
- `Process_Process_ex1.ahk`, `Process_Process_ex2.ahk` - Process commands (2)
- `Process_Process_close.ahk` - Close process (1)

**Messages:**
- `Process_OnMessage_ex2.ahk` through `Process_OnMessage_ex8.ahk` - Message handlers (7)
- `Process_OnMessage_Issue_136.ahk`, `Process_OnMessage_Issue_384.ahk` - Issue examples (2)

**System:**
- `Process_Shutdown_ex1.ahk`, `Process_Shutdown_ex2.ahk` - Shutdown (2)

---

### 📝 Directives (19 examples)

**Delimiter (Deprecated):**
- `Directive_#Delimiter_ex1.ahk` through `Directive_#Delimiter_ex5.ahk` - Delimiter (5)

**Comments:**
- `Directive_#CommentFlag_ex1.ahk` - Comment flag (1)
- `Directive_#AllowSameLineComments_ex1.ahk` - Same-line comments (1)

**Escape:**
- `Directive_#EscapeChar_ex1.ahk` - Escape character (1)

**Hotkeys:**
- `Directive_#HotkeyInterval_ex1.ahk` - Hotkey interval (1)
- `Directive_#HotkeyModifierTimeout_ex1.ahk` - Modifier timeout (1)
- `Directive_#Hotstring_ex1.ahk` - Hotstring options (1)
- `Directive_#If_ex1.ahk`, `Directive_#If_ex3.ahk` - Context-sensitive (2)
- `Directive_#InputLevel.ahk` - Input level (1)

**Window:**
- `Directive_#WinActivateForce_ex1.ahk` - Force activate (1)

**Warnings:**
- `Directive_#Warn_ex1.ahk` - Warnings (1)

**Version:**
- `Directive_Requires_ex1.ahk` - Requires version (1)

**Deprecated:**
- `Directive_#NoEnv_ex1.ahk` - NoEnv (1)

**Mixed:**
- `Directive_Directive_Mix.ahk`, `Directive_Directive_Mix2.ahk` - Mixed directives (2)

---

### 🌍 Environment (18 examples)

**Environment Variables:**
- `Env_EnvGet_ex1.ahk`, `Env_EnvGet_ex2.ahk` - Get environment (2)
- `Env_EnvSet_ex1.ahk` - Set environment (1)

**System Info:**
- `Env_SysGet_ex1.ahk` through `Env_SysGet_ex3.ahk` - System metrics (3)

**Clipboard:**
- `Env_Clipboard_ex1.ahk` - Clipboard access (1)
- `Env_ClipWait_ex1.ahk` - Wait for clipboard (1)
- `Env_OnClipboardChange_ex1.ahk` - Clipboard monitor (1)

**Caret:**
- `Env_CaretXY_ex1.ahk` through `Env_CaretXY_ex3.ahk` - Caret position (3)

**Network:**
- `Env_IPAddress_ex1-4.ahk` - IP address (1)

**Control:**
- `Env_BatchLines_ex1.ahk` - Batch lines (1)

**Navigation:**
- `Env_Goto_ex1.ahk` through `Env_Goto_ex4.ahk` - Goto labels (4)

---

### 🌊 Advanced Flow (13 examples)

**Sleep:**
- `Flow_Sleep_ex01.ahk` through `Flow_Sleep_ex11.ahk` - Sleep delays (11)

**Ternary:**
- `Flow_Ternary_ex01.ahk`, `Flow_Ternary_ex02.ahk` - Ternary operators (2)

---

### 🔤 Syntax (11 examples)

**Variables:**
- `Syntax_A_AhkVersion.ahk` - AHK version (1)
- `Syntax_A_LoopRegSubKey_conversion.ahk` - Loop registry (1)
- `Syntax_Empty_Str_Ass_ex1.ahk`, `Syntax_Empty_Str_Ass_ex2.ahk` - Empty strings (2)
- `Syntax_Var_Declaration_Keywords.ahk` - Variable declaration (1)

**Data Structures:**
- `Syntax_Associative_Arrays_ex1.ahk` - Associative arrays (1)
- `Syntax_Associative_Arrays_key-types.ahk` - Key types (1)

**Comments:**
- `Syntax_Comment_Blocks.ahk` - Comment blocks (1)
- `Syntax_mix_of_single_line_comments.ahk` - Mixed comments (1)

**Formatting:**
- `Syntax_Indentation-Mix.ahk` - Indentation (1)

**Removal:**
- `Syntax_Cmd_Removal_Issue_#375.ahk` - Command removal (1)

---

### 🗂️ Registry (10 examples)

**Read/Write:**
- `Registry_RegRead_ex1.ahk`, `Registry_RegRead_ex2.ahk` - Read registry (2)
- `Registry_RegWrite_ex1.ahk` through `Registry_RegWrite_ex3.ahk` - Write registry (3)
- `Registry_RegWrite_ex1_oldSyntax.ahk` - Old syntax (1)

**Delete:**
- `Registry_RegDelete_ex1.ahk`, `Registry_RegDelete_ex1_2.ahk` - Delete keys (2)

**Loop:**
- `Registry_Loop_regestry_ex1.ahk` - Loop registry (1)

**View:**
- `Registry_SetRegView_ex1.ahk` - Set registry view (1)

---

### ❌ Failed Conversions (8 examples)

These examples document known conversion issues and edge cases:

- `Failed_#Delimiter_ex4.ahk` - Delimiter issues
- `Failed_GlobalGui_ex1.ahk` - Global GUI variables
- `Failed_Menu_ex10.ahk`, `Failed_Menu_ex11.ahk` - Menu edge cases
- `Failed_MsgBox_ex11.ahk` - MsgBox issues
- `Failed_Process_ex3.ahk` - Process issues
- `Failed_StringCaseSense_ex4.ahk` - Case sensitivity
- `Failed_Ternary_ex5.ahk` - Ternary operator

---

### 📅 Date/Time (6 examples)

**Date Operations:**
- `DateTime_DateAdd_ex01.ahk`, `DateTime_DateAdd_ex02.ahk` - Add to date (2)
- `DateTime_DateDiff_ex01.ahk`, `DateTime_DateDiff_ex02.ahk` - Date difference (2)

**Formatting:**
- `DateTime_FormatTime_ex01.ahk`, `DateTime_FormatTime_ex02.ahk` - Format time (2)

---

### 🔊 Sound (5 examples)

**Playback:**
- `Sound_SoundPlay_ex1.ahk`, `Sound_SoundPlay_ex2.ahk` - Play sounds (2)
- `Sound_SoundBeeb_ex1.ahk`, `Sound_SoundBeeb_ex2.ahk` - Beep sounds (2)

**Volume:**
- `Sound_SoundGet_ex1.ahk` - Get volume (1)

---

### 🖥️ Screen (5 examples)

**Pixel Operations:**
- `Screen_PixelGetColor_ex1.ahk` - Get pixel color (1)
- `Screen_PixelSearch_ex1.ahk`, `Screen_PixelSearch_ex2.ahk` - Search pixels (2)

**Image Search:**
- `Screen_ImageSearch_ex1.ahk`, `Screen_ImageSearch_ex2.ahk` - Image search (2)

---

### ✅ Integrity (5 examples)

Code correctness and testing:

- `Integrity_Accumulated Errors 01.ahk` - Error accumulation
- `Integrity_Class&Func_Mask_01.ahk` - Class masking
- `Integrity_Class_01_Issue_379.ahk` - Class issues
- `Integrity_Continuation MIX 2025-06.ahk` - Continuation
- `Integrity_blankMissing_output_issue_277.ahk` - Output issues

---

### ➕ Mathematics (2 examples)

**Transforms:**
- `Maths_Transform_BitMath.ahk` - Bitwise operations
- `Maths_Transform_NumberMath.ahk` - Number operations

---

## Classification by Difficulty

### 🟢 Beginner (Approx. 300 examples)

**Start here if you're new to AHK v2:**

- Basic `String_*` operations (SubStr, InStr, StrLen)
- Simple `File_*` operations (Read, Append, Exists)
- `GUI_MsgBox_*` examples
- Basic `Control_If*` examples
- `DateTime_*` operations
- `Env_*` variable examples
- `Window_WinExist_*`, `Window_WinActive_*`

**Learning Focus:**
- Variable assignment with `:=`
- Function calls with parentheses
- Basic if statements and loops
- Simple file operations
- MsgBox usage

---

### 🟡 Intermediate (Approx. 350 examples)

**Build on basics:**

- Advanced `String_*` (Ternary, Arrays, Continuation)
- `File_*` advanced (Attributes, Timestamps, Directories)
- `GUI_*` controls (ListView, TreeView, InputBox)
- `Control_Loop*` variations
- `Window_*` manipulation (Move, Set, Wait)
- `Hotkey_*` input handling
- `Process_*` management
- `Registry_*` operations

**Learning Focus:**
- Arrays and objects
- GUI creation
- Event handling
- Window management
- File system operations
- Error handling (try-catch)

---

### 🔴 Advanced (Approx. 164 examples)

**Master complex patterns:**

- All `Advanced_*` examples (50)
- `Lib_*` DLL calls and COM objects
- Complex `Process_OnMessage_*` handlers
- `Directive_*` usage
- `Integrity_*` and `Failed_*` edge cases
- Complex `GUI_*` applications
- State machines and design patterns

**Learning Focus:**
- Object-oriented programming
- Design patterns (Singleton, Factory, Observer)
- Data structures (Queue, Stack, LinkedList)
- Async programming
- Advanced GUI applications
- Performance optimization
- DLL/COM interop

---

## Classification by Feature Type

### 📊 Data Manipulation

**String Processing:** 175 examples
- Parsing, formatting, searching, replacing
- `String_*` series

**Arrays & Collections:** 20+ examples
- `String_Array_*`, `Advanced_DataStructure_*`
- Maps, queues, stacks

**File I/O:** 142 examples
- Reading, writing, CSV, logs
- `File_*`, `Advanced_File_*`

---

### 🎨 User Interface

**GUI Creation:** 124 examples
- Windows, controls, dialogs
- `GUI_*`, `Advanced_GUI_*`

**Input Handling:** 34 examples
- Hotkeys, mouse, keyboard
- `Hotkey_*`, `Advanced_Hotkey_*`

**Window Management:** 63 examples
- Manipulation, detection, arrangement
- `Window_*`, `Advanced_Window_*`

---

### ⚙️ System Integration

**Process Control:** 20 examples
- Running programs, monitoring
- `Process_*`, `Advanced_Process_*`

**Registry:** 10 examples
- Read, write, delete
- `Registry_*`

**Environment:** 18 examples
- Variables, clipboard, system info
- `Env_*`, `Advanced_Misc_SystemInfo.ahk`

---

### 🔧 Programming Concepts

**Control Flow:** 43 + 13 + 8 examples
- Conditionals, loops, state machines
- `Control_*`, `Flow_*`, `Advanced_FlowControl_*`

**Functions & Classes:** 37 + 6 examples
- OOP, design patterns
- `Misc_*`, `Advanced_Class_*`

**Error Handling:** 10+ examples
- Try-catch, exception handling
- `Control_Catch_*`, `Control_Exception_*`

---

## Index by Use Case

### 📝 Text Processing

**Basic Text Manipulation:**
- Find text: `String_InStr_*`
- Replace text: `String_StrReplace_*`
- Extract text: `String_SubStr_*`
- Case conversion: `String_StrUpper_*`, `String_StrTitle_*`

**Advanced Text:**
- Multi-line strings: `String_ContinuationWithVar*`
- Text expansion: `Advanced_Hotstring_Autocorrect.ahk`
- Smart typography: `Advanced_Hotstring_SmartQuotes.ahk`
- CSV parsing: `Advanced_File_CSVProcessor.ahk`

---

### 💾 File Management

**Basic File Operations:**
- Read files: `File_Read_ex1.ahk`
- Write files: `File_FileAppend_*`
- Check existence: `File_FileExist_*`
- Copy/move: `File_Copy_*`, `File_Move_*`

**Advanced File Tools:**
- Batch rename: `Advanced_File_BatchRename.ahk`
- Find duplicates: `Advanced_File_DuplicateFinder.ahk`
- Merge files: `Advanced_File_TextMerger.ahk`
- Parse logs: `Advanced_File_LogParser.ahk`
- Auto backup: `Advanced_File_BackupManager.ahk`

---

### 🖼️ Desktop Automation

**Window Control:**
- Detect windows: `Window_WinExist_*`, `Window_WinActive_*`
- Move/resize: `Window_WinMove_*`
- Tile windows: `Advanced_Window_Arranger.ahk`
- Always on top: `Advanced_Window_AlwaysOnTop.ahk`
- Window spy: `Advanced_Window_Spy.ahk`

**Process Management:**
- Launch apps: `Process_Run_*`
- Monitor processes: `Advanced_Process_Monitor.ahk`
- Control processes: `Process_Process_*`

---

### ⌨️ Productivity Tools

**Input Enhancement:**
- Key remapping: `Advanced_Hotkey_Remapping.ahk`
- Text expansion: `Advanced_Hotstring_Autocorrect.ahk`
- Mouse gestures: `Advanced_Hotkey_MouseGestures.ahk`
- Keyboard chords: `Advanced_Hotkey_Chords.ahk`

**Utilities:**
- Clipboard history: `Advanced_Misc_ClipboardManager.ahk`
- Screenshot tool: `Advanced_Misc_ScreenshotTool.ahk`
- Password generator: `Advanced_Misc_PasswordGenerator.ahk`
- Unit converter: `Advanced_Misc_UnitConverter.ahk`
- Stopwatch/timer: `Advanced_Misc_Stopwatch.ahk`, `Advanced_Misc_Countdown.ahk`

---

### 🎓 Learning Patterns

**Design Patterns:**
- Singleton: `Advanced_Class_Singleton.ahk`
- Factory: `Advanced_Class_Factory.ahk`
- Observer: `Advanced_Class_Observer.ahk`
- Event Emitter: `Advanced_Class_EventEmitter.ahk`

**Data Structures:**
- Queue (FIFO): `Advanced_DataStructure_Queue.ahk`
- Stack (LIFO): `Advanced_DataStructure_Stack.ahk`
- Linked List: `Advanced_Class_LinkedList.ahk`
- Nested Maps: `Advanced_DataStructure_NestedMaps.ahk`

**Advanced Patterns:**
- State Machine: `Advanced_FlowControl_StateMachine.ahk`
- Generator/Iterator: `Advanced_Loop_Generator.ahk`
- Data Pipeline: `Advanced_FlowControl_Pipeline.ahk`
- Async Callbacks: `Advanced_FlowControl_AsyncCallbacks.ahk`

---

## Learning Path

### Path 1: Complete Beginner

**Week 1 - Basics:**
1. `GUI_MsgBox_ex01.ahk` - First program
2. `String_Assignment_ex1.ahk` - Variables
3. `Control_IfEqual_ex1.ahk` - Conditionals
4. `File_FileAppend_ex01.ahk` - File output
5. `Window_WinExist_ex01.ahk` - Window detection

**Week 2 - Strings & Files:**
6. `String_SubStr_ex01.ahk` - Substring
7. `String_InStr_ex01.ahk` - Find text
8. `String_StrReplace_ex01.ahk` - Replace text
9. `File_Read_ex1.ahk` - Read files
10. `File_Copy_ex1.ahk` - Copy files

**Week 3 - GUI & Windows:**
11. `GUI_Gui_ex01.ahk` - Create GUI
12. `GUI_InputBox_ex01.ahk` - Get user input
13. `Window_WinActivate_1.ahk` - Activate windows
14. `Window_WinMove_ex1.ahk` - Move windows

**Week 4 - Input & Loops:**
15. `Hotkey_Click_ex1.ahk` - Mouse clicks
16. `Hotkey_Send_ex1.ahk` - Send keys
17. `Control_LoopFiles_ex1.ahk` - Loop through files
18. `Control_LoopParse_ex1.ahk` - Parse strings

---

### Path 2: Intermediate User

**Focus Areas:**
1. **Arrays:** `String_Array_*` series
2. **GUI Controls:** `GUI_Listview_*`, `GUI_Treeview_*`
3. **Window Management:** All `Window_WinSet_*`
4. **File Operations:** `File_DirCopy_*`, `File_SetAttrib_*`
5. **Error Handling:** `Control_Catch_ex1.ahk`
6. **Functions:** `Control_ByRef_*`, `Misc_MyFunc_*`

**Project Ideas:**
- Build a file organizer
- Create a simple todo app
- Make a window manager
- Build a text processor

---

### Path 3: Advanced Developer

**Focus Areas:**
1. **OOP:** All `Advanced_Class_*` examples
2. **Data Structures:** `Advanced_DataStructure_*` series
3. **Design Patterns:** State machines, observers, factories
4. **DLL/COM:** All `Lib_*` examples
5. **Complex GUI:** `Advanced_GUI_*` applications
6. **Advanced Patterns:** Generators, pipelines, recursion

**Project Ideas:**
- Build a complete application (calculator, data manager)
- Create automation framework
- Develop productivity suite
- Build code generator

---

## Quick Search Index

### By Keyword

**Calculator:** `Advanced_GUI_Calculator.ahk`
**Clipboard:** `Env_Clipboard_*`, `Advanced_Misc_ClipboardManager.ahk`
**Color:** `Advanced_GUI_ColorPicker.ahk`, `Screen_PixelGetColor_*`
**CSV:** `Advanced_File_CSVProcessor.ahk`
**Date/Time:** `DateTime_*`, `Advanced_Misc_Stopwatch.ahk`
**DLL:** `Lib_DllCall_*`
**File Rename:** `Advanced_File_BatchRename.ahk`
**GUI:** `GUI_*`, `Advanced_GUI_*`
**Hotkey:** `Hotkey_*`, `Advanced_Hotkey_*`
**Loop:** `Control_Loop*`, `Advanced_Loop_*`
**Menu:** `GUI_Menu*`, `GUI_Tray_*`
**Password:** `Advanced_Misc_PasswordGenerator.ahk`
**Process:** `Process_*`, `Advanced_Process_*`
**Queue:** `Advanced_DataStructure_Queue.ahk`
**Registry:** `Registry_*`
**Screenshot:** `Advanced_Misc_ScreenshotTool.ahk`
**Stack:** `Advanced_DataStructure_Stack.ahk`
**Timer:** `Control_SetTimer_*`, `Advanced_Misc_Countdown.ahk`
**Todo List:** `Advanced_GUI_TodoList.ahk`
**Window:** `Window_*`, `Advanced_Window_*`

---

## File Naming Convention

All examples follow this pattern:
```
[Category]_[Feature/Function]_[Variation].ahk
```

**Examples:**
- `String_SubStr_ex01.ahk` - String category, SubStr function, example 1
- `Advanced_GUI_Calculator.ahk` - Advanced category, GUI Calculator
- `Control_LoopFiles_ex1.ahk` - Control flow, Loop Files, example 1

**Category Prefixes:**
- `String_` - String operations
- `File_` - File/directory operations
- `GUI_` - Graphical interfaces
- `Window_` - Window management
- `Control_` - Flow control
- `Hotkey_` - Input handling
- `Process_` - Process management
- `Advanced_` - Complex applications
- `Lib_` - External libraries
- `Directive_` - Compiler directives
- `Env_` - Environment/system
- `Registry_` - Registry operations
- `DateTime_` - Date/time functions
- `Sound_` - Audio operations
- `Screen_` - Display operations
- `Misc_` - Miscellaneous
- `Flow_` - Advanced flow patterns
- `Syntax_` - Language syntax
- `Integrity_` - Code correctness
- `Maths_` - Mathematical operations
- `Failed_` - Known issues

---

## Tips for Using This Guide

1. **Start with your goal:** Look up use cases in the index
2. **Match your skill level:** Use the difficulty classification
3. **Learn by category:** Follow the detailed breakdowns
4. **Study patterns:** Examine advanced examples for design patterns
5. **Practice progressively:** Follow the learning paths
6. **Combine examples:** Mix features from different categories
7. **Reference frequently:** Use quick search for specific features

---

## Related Documentation

- **Feature Guide:** `docs/AHK_v2_Examples_Feature_Guide.md`
- **Examples README:** `data/raw_scripts/AHK_v2_Examples/README.md`
- **Official Docs:** https://www.autohotkey.com/docs/v2/

---

**Last Updated:** November 5, 2025
**Repository Version:** 814 examples total
**Advanced Examples:** 50
**Basic/Intermediate:** 764
