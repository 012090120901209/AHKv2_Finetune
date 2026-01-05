#!/bin/bash
# AutoHotkey v2 Examples Pruning Script
# WARNING: This will DELETE 288 files

set -e  # Exit on error

EXAMPLES_DIR="/home/user/AHKv2_Finetune/data/raw_scripts/AHK_v2_Examples"

echo "========================================="
echo "AutoHotkey v2 Examples Pruning Script"
echo "========================================="
echo ""

cd "$EXAMPLES_DIR" || exit 1

echo "Deleting exact duplicates (33 files)..."

# OOP_File duplicates (9 files)
rm -f OOP_File_CSVProcessor.ahk
rm -f OOP_File_ConfigManager.ahk
rm -f OOP_File_DataExporter.ahk
rm -f OOP_File_FileWatcher.ahk
rm -f OOP_File_JSONParser.ahk
rm -f OOP_File_LogAnalyzer.ahk
rm -f OOP_File_MarkdownParser.ahk
rm -f OOP_File_TemplateEngine.ahk
rm -f OOP_File_XMLProcessor.ahk

# OOP_GUI duplicates (5 files)
rm -f OOP_GUI_SettingsPanel.ahk
rm -f OOP_GUI_Toolbar.ahk
rm -f OOP_GUI_ModalDialog.ahk
rm -f OOP_GUI_ProgressTracker.ahk
rm -f OOP_GUI_TreeView.ahk

# GUI_MsgBox duplicates (4 files)
rm -f GUI_MsgBox_ex47.ahk
rm -f GUI_MsgBox_ex48.ahk
rm -f GUI_MsgBox_ex49.ahk
rm -f GUI_MsgBox_ex53.ahk

# File_FileAppend duplicates (5 files)
rm -f File_FileAppend_ex36.ahk
rm -f File_FileAppend_ex41.ahk
rm -f File_FileAppend_ex46.ahk
rm -f File_FileAppend_ex47.ahk
rm -f File_FileAppend_ex50.ahk

# String_SubStr duplicates (3 files)
rm -f String_SubStr_ex29.ahk
rm -f String_SubStr_ex34.ahk
rm -f String_SubStr_ex38.ahk

# String_InStr duplicates (3 files)
rm -f String_InStr_ex29.ahk
rm -f String_InStr_ex30.ahk
rm -f String_InStr_ex26.ahk

# Flow_Sleep duplicates (2 files)
rm -f Flow_Sleep_ex06.ahk
rm -f Flow_Sleep_ex10.ahk

# Misc duplicates (2 files)
rm -f Misc_SplitPath_ex05.ahk
rm -f Misc_Concat_ex03.ahk

echo "✓ Deleted exact duplicates"

echo ""
echo "Deleting trivial File_FileAppend test cases (60 files)..."

# Keep only: ex02, ex03, ex12, ex13, ex16, ex42, ex43
# Delete all others
for i in 01 04 05 06 07 08 09 10 11 14 15 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 37 38 39 40 44 45 48 49 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66; do
    rm -f "File_FileAppend_ex${i}.ahk"
done

echo "✓ Deleted 60 trivial FileAppend examples"

echo ""
echo "Deleting trivial GUI_MsgBox test cases (70 files)..."

# Keep only: ex01, ex02, ex03, ex04, ex05, ex08, ex09, ex12
# Delete all others except GUI_MsgBox_continuation
for i in 06 07 10 11 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 50 51 52 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80; do
    rm -f "GUI_MsgBox_ex${i}.ahk"
done

echo "✓ Deleted 70 trivial MsgBox examples"

echo ""
echo "Deleting trivial String_SubStr test cases (35 files)..."

# Keep only: ex01, ex02, ex04, ex10, ex15, ex20
for file in String_SubStr_ex*.ahk; do
    case "$file" in
        String_SubStr_ex01.ahk|String_SubStr_ex02.ahk|String_SubStr_ex04.ahk|String_SubStr_ex10.ahk|String_SubStr_ex15.ahk|String_SubStr_ex20.ahk)
            # Keep these
            ;;
        *)
            rm -f "$file"
            ;;
    esac
done

echo "✓ Deleted ~35 trivial SubStr examples"

echo ""
echo "Deleting trivial String_InStr test cases (35 files)..."

# Keep only: ex01, ex04, ex10, ex15, ex20, ex24
for file in String_InStr_ex*.ahk; do
    case "$file" in
        String_InStr_ex01.ahk|String_InStr_ex04.ahk|String_InStr_ex10.ahk|String_InStr_ex15.ahk|String_InStr_ex20.ahk|String_InStr_ex24.ahk)
            # Keep these
            ;;
        *)
            rm -f "$file"
            ;;
    esac
done

echo "✓ Deleted ~35 trivial InStr examples"

echo ""
echo "Deleting trivial Flow_Sleep test cases (9 files)..."

# Keep only: ex01, ex04
for file in Flow_Sleep_ex*.ahk; do
    case "$file" in
        Flow_Sleep_ex01.ahk|Flow_Sleep_ex04.ahk)
            # Keep these
            ;;
        *)
            rm -f "$file"
            ;;
    esac
done

echo "✓ Deleted ~9 trivial Sleep examples"

echo ""
echo "========================================="
echo "Pruning Complete!"
echo "========================================="
echo ""
echo "Counting remaining files..."
REMAINING=$(ls -1 *.ahk 2>/dev/null | wc -l)
echo "Files remaining: $REMAINING"
echo ""
