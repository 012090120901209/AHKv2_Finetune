#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Flow of Control/LoopFiles_ex2.ah2
; Removed SetBatchLines, -1 ; Make the operation run at maximum speed.
FolderSizeKB := 0
WhichFolder := DirSelect() ; Ask the user to pick a folder.
Loop Files, WhichFolder "\*.*", "R" FolderSizeKB + = A_LoopFileSizeKB
    MsgBox("Size of " WhichFolder " is " FolderSizeKB " KB.")
